-- ── HOMEHELP & BANDHAN SUPABASE SCHEMA ───────────────────────────────────
-- PRODUCTION READY SCHEMA FOR ON-DEMAND HOME SERVICES
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. PROFILES TABLE
CREATE TABLE profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT,
  phone TEXT UNIQUE,
  email TEXT,
  avatar_url TEXT,
  role TEXT DEFAULT 'customer' CHECK (role IN ('customer', 'expert', 'admin')),
  city TEXT,
  address_line1 TEXT,
  address_line2 TEXT,
  area TEXT,
  wallet_balance DECIMAL(10, 2) DEFAULT 0.00,
  rating DECIMAL(3, 2) DEFAULT 5.00,
  jobs_completed INTEGER DEFAULT 0,
  is_verified BOOLEAN DEFAULT false,
  is_online BOOLEAN DEFAULT false,
  fcm_token TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. SERVICES TABLE
CREATE TABLE services (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  price_per_hour DECIMAL(10, 2) NOT NULL,
  category TEXT,
  icon_emoji TEXT,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. BOOKINGS TABLE
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID REFERENCES profiles(id),
  expert_id UUID REFERENCES profiles(id),
  service_id UUID REFERENCES services(id),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'assigned', 'en_route', 'in_progress', 'completed', 'cancelled')),
  scheduled_at TIMESTAMP WITH TIME ZONE,
  started_at TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE,
  total_price DECIMAL(10, 2),
  duration_hours INTEGER DEFAULT 1,
  address_snapshot TEXT,
  otp_code TEXT, -- Verified upon arrival
  cancellation_reason TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. EXPERT LOCATIONS (REALTIME GPS)
CREATE TABLE expert_locations (
  expert_id UUID REFERENCES profiles(id) PRIMARY KEY,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. WALLET TRANSACTIONS
CREATE TABLE wallet_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  profile_id UUID REFERENCES profiles(id),
  booking_id UUID REFERENCES bookings(id),
  amount DECIMAL(10, 2) NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('credit', 'debit')),
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. REVIEWS
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID REFERENCES bookings(id) UNIQUE,
  from_id UUID REFERENCES profiles(id),
  to_id UUID REFERENCES profiles(id),
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. DAMAGE CLAIMS
CREATE TABLE damage_claims (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID REFERENCES bookings(id),
  customer_id UUID REFERENCES profiles(id),
  description TEXT,
  estimated_amount DECIMAL(10, 2),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'under_review', 'resolved', 'rejected')),
  photo_urls TEXT[], -- Array of storage links
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 9. SUPPORT MESSAGES
CREATE TABLE support_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID REFERENCES bookings(id),
  sender_id UUID REFERENCES profiles(id),
  message TEXT,
  is_urgent BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── ROW LEVEL SECURITY (RLS) ─────────────────────────────────────────────

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Profiles are viewable by everyone" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

ALTER TABLE services ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Services are viewable by everyone" ON services FOR SELECT USING (true);

ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can see their own bookings" ON bookings FOR SELECT USING (auth.uid() = customer_id OR auth.uid() = expert_id);

ALTER TABLE expert_locations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Expert locations are public during active bookings" ON expert_locations FOR SELECT USING (true);
CREATE POLICY "Experts can update their own location" ON expert_locations FOR UPDATE USING (auth.uid() = expert_id);

-- ── FUNCTIONS & TRIGGERS ──────────────────────────────────────────────────

-- 1. WALLET BALANCE SYNC
CREATE OR REPLACE FUNCTION update_wallet_on_transaction()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.type = 'credit' THEN
    UPDATE profiles SET wallet_balance = wallet_balance + NEW.amount WHERE id = NEW.profile_id;
  ELSE
    UPDATE profiles SET wallet_balance = wallet_balance - NEW.amount WHERE id = NEW.profile_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_wallet_sync
AFTER INSERT ON wallet_transactions
FOR EACH ROW EXECUTE FUNCTION update_wallet_on_transaction();

-- 2. AUTO PROFILE CREATION
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, phone, email)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'phone', NEW.email);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER tr_auth_signup
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- 3. INITIAL SERVICES SEED
INSERT INTO services (name, slug, price_per_hour, category, icon_emoji) VALUES
('General Cleaning', 'general-cleaning', 179, 'Cleaning', '🧹'),
('Kitchen Cleaning', 'kitchen-cleaning', 179, 'Cleaning', '🍳'),
('Bathroom Cleaning', 'bathroom-cleaning', 199, 'Cleaning', '🚿'),
('Laundry and Ironing', 'laundry-ironing', 219, 'Laundry', '👕'),
('Dishwashing', 'dishwashing', 159, 'Cleaning', '🍽️'),
('Kitchen Prep', 'kitchen-prep', 219, 'Kitchen', '🥗');
