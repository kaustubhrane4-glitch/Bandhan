-- ── BANDHAN MATRIMONY SUPABASE SCHEMA ───────────────────────────────────
-- A COMPLETELY INDEPENDENT SCHEMA FOR THE MATCHMAKING PLATFORM
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. MATRIMONY PROFILES
-- Contains detailed attributes for matchmaking.
CREATE TABLE matrimony_profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT NOT NULL,
  gender TEXT CHECK (gender IN ('male', 'female', 'other')),
  date_of_birth DATE,
  height TEXT, -- e.g., 5'8"
  marital_status TEXT CHECK (marital_status IN ('never_married', 'divorced', 'widowed', 'awaiting_divorce')),
  mother_tongue TEXT,
  religion TEXT,
  caste TEXT,
  gotra TEXT,
  
  -- Education & Occupation
  education TEXT,
  occupation TEXT,
  annual_income TEXT,
  company_name TEXT,
  
  -- Location
  city TEXT,
  state TEXT,
  country TEXT DEFAULT 'India',
  
  -- Lifestyle
  diet TEXT CHECK (diet IN ('veg', 'non_veg', 'eggiterian')),
  drink TEXT CHECK (drink IN ('yes', 'no', 'occasionally')),
  smoke TEXT CHECK (smoke IN ('yes', 'no', 'occasionally')),
  
  -- About
  bio TEXT,
  photos TEXT[], -- Array of image URLs
  
  -- Internal
  is_verified BOOLEAN DEFAULT false,
  membership_plan TEXT DEFAULT 'free', -- 'free', 'gold', 'platinum'
  completeness_score INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. INTERESTS & MATCHES
-- Tracks sent and received interests.
CREATE TABLE interests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id UUID REFERENCES matrimony_profiles(id),
  receiver_id UUID REFERENCES matrimony_profiles(id),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(sender_id, receiver_id)
);

-- 4. CONVERSATIONS & MESSAGES
-- Only created when an interest is 'accepted'.
CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_1 UUID REFERENCES matrimony_profiles(id),
  user_2 UUID REFERENCES matrimony_profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_1, user_2)
);

CREATE TABLE matrimony_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID REFERENCES conversations(id),
  sender_id UUID REFERENCES matrimony_profiles(id),
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. PARTNER PREFERENCES
CREATE TABLE partner_preferences (
  profile_id UUID REFERENCES matrimony_profiles(id) PRIMARY KEY,
  min_age INTEGER DEFAULT 18,
  max_age INTEGER DEFAULT 70,
  min_height TEXT,
  max_height TEXT,
  religions TEXT[],
  castes TEXT[],
  mother_tongues TEXT[],
  diets TEXT[]
);

-- ── ROW LEVEL SECURITY (RLS) ─────────────────────────────────────────────

ALTER TABLE matrimony_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Profiles are viewable by registered users" ON matrimony_profiles FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Users can update own profile" ON matrimony_profiles FOR UPDATE USING (auth.uid() = id);

ALTER TABLE interests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their interests" ON interests FOR ALL USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- ── FUNCTIONS & TRIGGERS ──────────────────────────────────────────────────

-- Automatically create a conversation when interest is accepted
CREATE OR REPLACE FUNCTION create_conversation_on_accept()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'accepted' AND OLD.status = 'pending' THEN
    INSERT INTO conversations (user_1, user_2)
    VALUES (NEW.sender_id, NEW.receiver_id)
    ON CONFLICT DO NOTHING;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_interest_accepted
AFTER UPDATE ON interests
FOR EACH ROW EXECUTE FUNCTION create_conversation_on_accept();
