import { useState } from "react";
import { supabase as importedSupabase } from './supabase-client.js';

// Fallback for standalone mode (index.html provides 'client')
const supabase = typeof client !== 'undefined' ? client : importedSupabase;

// ── THEME & CONSTANTS ────────────────────────────────────────────────────────
const NAVY = "#0f172a";
const GOLD = "#b45309";
const GOLD_LIGHT = "#fef3c7";
const GRAD = "linear-gradient(135deg, #0f172a, #1e293b)";
const ACCENT = "#0ea5e9";
const TEXT = "#1e293b";
const MUTED = "#64748b";
const BG = "#f1f5f9";
const CARD = "#ffffff";
const BORDER = "#e2e8f0";
const RED = "#ef4444";
const GREEN = "#22c55e";

const SERVICES = [
  { id: "s1", name: "House Cleaning", price: 499, icon: "🧹", desc: "Deep cleaning for all rooms" },
  { id: "s2", name: "Cooking & Prep", price: 599, icon: "🍳", desc: "Professional home chefs" },
  { id: "s3", name: "Laundry Service", price: 399, icon: "👕", desc: "Wash, iron, and fold" },
  { id: "s4", name: "Elderly Care", price: 899, icon: "👴", desc: "Compassionate care for elders" },
  { id: "s5", name: "Baby Sitting", price: 799, icon: "👶", desc: "Safe and fun child care" },
  { id: "s6", name: "Gardening", price: 449, icon: "🌿", desc: "Lawn and garden maintenance" },
];

const MOCK_BONDS = [
  { id: "b1", provider: "Savitri Devi", role: "Home Chef", schedule: "Mon-Fri, 9AM", status: "Active", avatar: "👩‍🍳" },
  { id: "b2", provider: "Ramesh Singh", role: "Gardener", schedule: "Tue, Sat, 4PM", status: "Active", avatar: "👨‍🌾" },
];

const MOCK_TRANSACTIONS = [
  { id: "t1", desc: "Wallet Top-up", amount: 2000, date: "May 8", type: "credit" },
  { id: "t2", desc: "Cleaning Service", amount: -499, date: "May 7", type: "debit" },
  { id: "t3", desc: "Cooking Bond Payout", amount: -599, date: "May 5", type: "debit" },
];

// ── SHARED COMPONENTS ────────────────────────────────────────────────────────
const Button = ({ children, onClick, variant = "primary", full = true, icon }) => (
  <button
    onClick={onClick}
    style={{
      background: variant === "primary" ? GOLD : variant === "outline" ? "transparent" : NAVY,
      color: variant === "outline" ? GOLD : "#fff",
      border: variant === "outline" ? `2px solid ${GOLD}` : "none",
      borderRadius: "12px",
      padding: "14px 20px",
      fontSize: "15px",
      fontWeight: "700",
      cursor: "pointer",
      width: full ? "100%" : "auto",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      gap: "10px",
      transition: "transform 0.1s active",
      fontFamily: "'Inter', sans-serif",
    }}
  >
    {icon && <span>{icon}</span>}
    {children}
  </button>
);

const Card = ({ children, style = {}, noPadding = false }) => (
  <div
    style={{
      background: CARD,
      borderRadius: "20px",
      boxShadow: "0 4px 20px rgba(0, 0, 0, 0.05)",
      border: `1px solid ${BORDER}`,
      padding: noPadding ? 0 : "20px",
      ...style,
    }}
  >
    {children}
  </div>
);

const Badge = ({ text, color = GOLD }) => (
  <span
    style={{
      background: `${color}15`,
      color: color,
      padding: "4px 10px",
      borderRadius: "8px",
      fontSize: "11px",
      fontWeight: "700",
      textTransform: "uppercase",
      letterSpacing: "0.5px",
    }}
  >
    {text}
  </span>
);

// ── SCREENS ──────────────────────────────────────────────────────────────────

// 0. Review Modal
function ReviewModal({ booking, onClose }) {
  const [rating, setRating] = useState(5);
  const [comment, setComment] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async () => {
    setSubmitting(true);
    try {
      const { data: { user } } = await supabase.auth.getUser();
      await supabase.from('reviews').insert([{
        booking_id: booking.id,
        from_id: user.id,
        to_id: booking.expert_id,
        rating,
        comment
      }]);
      alert("Thank you for your feedback! ⭐️");
      onClose();
    } catch (e) {
      alert(e.message);
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div style={{ position: "fixed", inset: 0, background: "rgba(0,0,0,0.6)", backdropFilter: "blur(5px)", zIndex: 3000, display: "flex", alignItems: "center", justifyContent: "center", padding: "20px" }}>
      <div className="fadeUp" style={{ background: "#fff", borderRadius: "24px", padding: "32px", width: "100%", maxWidth: "380px", textAlign: "center" }}>
        <h3 style={{ fontSize: "24px", fontWeight: "800", color: NAVY, fontFamily: "'Playfair Display', serif", marginBottom: "8px" }}>Rate Your Experience</h3>
        <p style={{ color: MUTED, fontSize: "14px", marginBottom: "24px" }}>How was your service with <br/><b style={{ color: NAVY }}>{booking.service_name}</b>?</p>
        
        <div style={{ display: "flex", justifyContent: "center", gap: "8px", marginBottom: "24px" }}>
          {[1, 2, 3, 4, 5].map(s => (
            <span key={s} onClick={() => setRating(s)} style={{ fontSize: "32px", cursor: "pointer", color: s <= rating ? GOLD : BORDER }}>★</span>
          ))}
        </div>

        <textarea 
          value={comment}
          onChange={e => setComment(e.target.value)}
          placeholder="Write a quick comment..."
          style={{ width: "100%", padding: "16px", borderRadius: "14px", border: `2px solid ${BORDER}`, fontSize: "14px", outline: "none", fontFamily: "inherit", marginBottom: "24px", height: "100px", resize: "none" }}
        />

        <Button onClick={handleSubmit} loading={submitting}>{submitting ? "Submitting..." : "Submit Review"}</Button>
        <button onClick={onClose} style={{ marginTop: "16px", background: "none", border: "none", color: MUTED, fontWeight: "600", cursor: "pointer" }}>Skip for now</button>
      </div>
    </div>
  );
}

// 1. Auth Flow (Login & OTP)
function AuthFlow({ onAuthComplete }) {
  const [view, setView] = useState("login"); // "login", "otp"
  const [method, setMethod] = useState("phone"); // "phone", "email"
  const [value, setValue] = useState("");
  const [otp, setOtp] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSendOtp = async () => {
    if (!value) return alert("Please enter your " + method);
    setLoading(true);
    try {
      const { error } = await supabase.auth.signInWithOtp({
        [method === "phone" ? "phone" : "email"]: value,
      });
      if (error) throw error;
      setView("otp");
    } catch (e) {
      alert("Error: " + e.message);
    } finally {
      setLoading(false);
    }
  };

  const handleVerifyOtp = async () => {
    if (otp.length < 6) return alert("Enter 6-digit OTP");
    setLoading(true);
    try {
      const { data: { user }, error } = await supabase.auth.verifyOtp({
        [method === "phone" ? "phone" : "email"]: value,
        token: otp,
        type: method === "phone" ? "sms" : "email",
      });
      if (error) throw error;
      
      // Fetch or create profile
      const { data: profile } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .single();

      onAuthComplete(profile || { id: user.id, full_name: value.split('@')[0] });
    } catch (e) {
      alert("Verification failed: " + e.message);
    } finally {
      setLoading(false);
    }
  };

  if (view === "login") return (
    <div className="fadeUp" style={{ height: "100vh", background: "#fff", padding: "40px 24px", display: "flex", flexDirection: "column" }}>
      <div style={{ textAlign: "center", marginBottom: "48px" }}>
        <div style={{ width: "80px", height: "80px", background: GOLD, borderRadius: "24px", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "40px", margin: "0 auto 20px", boxShadow: `0 10px 30px ${GOLD}33` }}>🤝</div>
        <h1 style={{ fontSize: "28px", fontWeight: "800", color: NAVY, fontFamily: "'Playfair Display', serif" }}>Welcome to Bandhan</h1>
        <p style={{ color: MUTED, marginTop: "8px" }}>Sign in to bond with top experts.</p>
      </div>

      <div style={{ display: "flex", background: BG, borderRadius: "14px", padding: "4px", marginBottom: "24px" }}>
        {["phone", "email"].map(m => (
          <button key={m} onClick={() => setMethod(m)} style={{ flex: 1, padding: "10px", borderRadius: "11px", border: "none", background: method === m ? "#fff" : "none", color: method === m ? GOLD : MUTED, fontWeight: "700", cursor: "pointer", textTransform: "capitalize" }}>{m}</button>
        ))}
      </div>

      <div style={{ marginBottom: "24px" }}>
        <label style={{ display: "block", fontSize: "12px", fontWeight: "800", color: MUTED, marginBottom: "8px", textTransform: "uppercase" }}>{method === "phone" ? "Mobile Number" : "Email Address"}</label>
        <input 
          type={method === "phone" ? "tel" : "email"}
          value={value}
          onChange={e => setValue(e.target.value)}
          placeholder={method === "phone" ? "+91 98765 43210" : "you@example.com"}
          style={{ width: "100%", padding: "16px", borderRadius: "14px", border: `2px solid ${BORDER}`, fontSize: "16px", outline: "none", fontFamily: "inherit" }}
        />
      </div>

      <Button onClick={handleSendOtp} loading={loading}>{loading ? "Sending..." : "Send Verification Code"}</Button>
      
      <p style={{ textAlign: "center", marginTop: "24px", fontSize: "12px", color: MUTED, lineHeight: "1.6" }}>
        By continuing, you agree to Bandhan's <span style={{ color: GOLD, fontWeight: "700" }}>Terms of Service</span> and <span style={{ color: GOLD, fontWeight: "700" }}>Privacy Policy</span>.
      </p>
    </div>
  );

  return (
    <div className="fadeUp" style={{ height: "100vh", background: "#fff", padding: "40px 24px", display: "flex", flexDirection: "column" }}>
      <button onClick={() => setView("login")} style={{ background: "none", border: "none", color: GOLD, fontSize: "15px", fontWeight: "700", textAlign: "left", marginBottom: "32px", cursor: "pointer" }}>← Change {method}</button>
      
      <h2 style={{ fontSize: "28px", fontWeight: "800", color: NAVY, fontFamily: "'Playfair Display', serif", marginBottom: "8px" }}>Verify OTP</h2>
      <p style={{ color: MUTED, marginBottom: "32px" }}>Enter the 6-digit code sent to <br/><b style={{ color: NAVY }}>{value}</b></p>

      <div style={{ display: "flex", gap: "12px", marginBottom: "32px" }}>
        <input 
          maxLength={6}
          value={otp}
          onChange={e => setOtp(e.target.value)}
          placeholder="0 0 0 0 0 0"
          style={{ width: "100%", padding: "16px", borderRadius: "14px", border: `2px solid ${GOLD}`, fontSize: "24px", fontWeight: "800", textAlign: "center", letterSpacing: "12px", outline: "none" }}
        />
      </div>

      <Button onClick={handleVerifyOtp} loading={loading}>{loading ? "Verifying..." : "Verify & Continue"}</Button>
      
      <p style={{ textAlign: "center", marginTop: "24px", fontSize: "14px", color: MUTED }}>
        Didn't receive code? <span style={{ color: GOLD, fontWeight: "700", cursor: "pointer" }}>Resend</span>
      </p>
    </div>
  );
}

// 2. Home / Dashboard
function Home({ onBook }) {
  return (
    <div style={{ background: BG, minHeight: "100vh", paddingBottom: "100px" }}>
      {/* Header */}
      <div style={{ background: GRAD, padding: "40px 24px 24px", borderRadius: "0 0 32px 32px" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "24px" }}>
          <div>
            <p style={{ color: "rgba(255,255,255,0.6)", fontSize: "14px" }}>Welcome to Bandhan,</p>
            <h2 style={{ color: "#fff", fontSize: "24px", fontWeight: "700" }}>Abhishek 👋</h2>
          </div>
          <div style={{ width: "48px", height: "48px", borderRadius: "16px", background: "rgba(255,255,255,0.1)", border: "1px solid rgba(255,255,255,0.1)", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "20px" }}>
            🔔
          </div>
        </div>
        
        <Card style={{ background: "rgba(255,255,255,0.1)", border: "1px solid rgba(255,255,255,0.15)", backdropFilter: "blur(10px)", color: "#fff" }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <div>
              <p style={{ fontSize: "12px", color: "rgba(255,255,255,0.6)" }}>Wallet Balance</p>
              <h3 style={{ fontSize: "28px", fontWeight: "800", marginTop: "4px" }}>₹2,450.00</h3>
            </div>
            <button style={{ background: GOLD, border: "none", borderRadius: "12px", padding: "10px 16px", color: "#fff", fontWeight: "700", fontSize: "13px" }}>+ Add</button>
          </div>
        </Card>
      </div>

      {/* Services Grid */}
      <div style={{ padding: "24px" }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
          <h3 style={{ fontSize: "18px", fontWeight: "800", color: NAVY }}>Our Services</h3>
          <span style={{ color: GOLD, fontWeight: "700", fontSize: "14px" }}>View All</span>
        </div>
        
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px" }}>
          {SERVICES.map(s => (
            <Card key={s.id} style={{ textAlign: "center", cursor: "pointer" }} onClick={() => onBook(s)}>
              <div style={{ fontSize: "32px", marginBottom: "12px" }}>{s.icon}</div>
              <h4 style={{ fontSize: "15px", fontWeight: "700", color: NAVY }}>{s.name}</h4>
              <p style={{ fontSize: "12px", color: MUTED, marginTop: "4px" }}>Starts at ₹{s.price}</p>
            </Card>
          ))}
        </div>
      </div>

      {/* active Bond (Bandhan) */}
      <div style={{ padding: "0 24px" }}>
        <h3 style={{ fontSize: "18px", fontWeight: "800", color: NAVY, marginBottom: "16px" }}>Your Active Bonds</h3>
        <Card style={{ borderLeft: `6px solid ${GOLD}` }}>
          <div style={{ display: "flex", gap: "16px", alignItems: "center" }}>
            <div style={{ width: "50px", height: "50px", borderRadius: "50%", background: GOLD_LIGHT, display: "flex", alignItems: "center", justifyContent: "center", fontSize: "24px" }}>👩‍🍳</div>
            <div style={{ flex: 1 }}>
              <h4 style={{ fontSize: "16px", fontWeight: "700", color: NAVY }}>Savitri Devi</h4>
              <p style={{ fontSize: "13px", color: MUTED }}>Home Chef · 5 days/week</p>
            </div>
            <Badge text="ACTIVE" />
          </div>
          <div style={{ marginTop: "16px", paddingTop: "16px", borderTop: `1px solid ${BORDER}`, display: "flex", justifyContent: "space-between" }}>
            <span style={{ fontSize: "13px", color: MUTED }}>Next visit: Tomorrow 9:00 AM</span>
            <span style={{ fontSize: "13px", color: NAVY, fontWeight: "700" }}>Manage →</span>
          </div>
        </Card>
      </div>
    </div>
  );
}

// 3. Booking / Selection
function Booking({ service, onBack, onConfirm }) {
  const [freq, setFreq] = useState("Weekly");
  return (
    <div style={{ background: BG, minHeight: "100vh", padding: "24px", paddingBottom: "120px" }}>
      <button onClick={onBack} style={{ background: "none", border: "none", color: NAVY, fontSize: "24px", cursor: "pointer", marginBottom: "20px" }}>←</button>
      <div className="fadeUp">
        <h2 style={{ fontSize: "32px", fontWeight: "800", color: NAVY, marginBottom: "8px", fontFamily: "'Playfair Display', serif" }}>{service.name}</h2>
        <p style={{ color: MUTED, marginBottom: "32px" }}>{service.desc}</p>

        <Card style={{ marginBottom: "24px" }}>
          <h4 style={{ fontWeight: "700", marginBottom: "16px" }}>Select Frequency</h4>
          <div style={{ display: "flex", gap: "12px" }}>
            {["One-time", "Weekly", "Monthly"].map(f => (
              <div key={f} onClick={() => setFreq(f)} style={{ flex: 1, padding: "12px", borderRadius: "12px", border: `2px solid ${freq === f ? GOLD : BORDER}`, textAlign: "center", background: freq === f ? GOLD_LIGHT : "transparent", cursor: "pointer", transition: "all 0.2s" }}>
                <span style={{ fontSize: "14px", fontWeight: "700", color: freq === f ? GOLD : MUTED }}>{f}</span>
              </div>
            ))}
          </div>
        </Card>

        <Card style={{ marginBottom: "24px" }}>
          <h4 style={{ fontWeight: "700", marginBottom: "16px" }}>Why Choose Bandhan?</h4>
          {[
            { t: "Verified Professionals", d: "Strict background & skill checks" },
            { t: "Bonded Insurance", d: "Covered up to ₹10,000 for damages" },
            { t: "Flexible Scheduling", d: "Cancel or reschedule anytime" }
          ].map((item, i) => (
            <div key={i} style={{ display: "flex", gap: "12px", marginBottom: i === 2 ? 0 : "16px" }}>
              <div style={{ color: GOLD }}>✓</div>
              <div>
                <p style={{ fontWeight: "700", fontSize: "14px", color: NAVY }}>{item.t}</p>
                <p style={{ fontSize: "12px", color: MUTED }}>{item.d}</p>
              </div>
            </div>
          ))}
        </Card>
      </div>

      <div style={{ position: "fixed", bottom: "0", left: "50%", transform: "translateX(-50%)", width: "100%", maxWidth: "480px", padding: "24px", background: "#fff", borderTop: `1px solid ${BORDER}`, zIndex: 100 }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
          <div>
            <p style={{ fontSize: "12px", color: MUTED }}>Estimated Total</p>
            <h3 style={{ fontSize: "24px", fontWeight: "800", color: NAVY }}>₹{service.price}</h3>
          </div>
          <Badge text="TAX INCL." />
        </div>
        <Button onClick={() => onConfirm(service)}>Confirm Booking</Button>
      </div>
    </div>
  );
}

// 4. Bonds Screen
function Bonds({ onReview }) {
  const [activeBonds, setActiveBonds] = useState([]);
  const [pastBookings, setPastBookings] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadBonds = async () => {
      const { data: bonds } = await supabase.from('bonds').select('*, profiles!expert_id(full_name, avatar_url), services!service_id(name)').eq('status', 'active');
      const { data: bookings } = await supabase.from('bookings').select('*, services!service_id(name)').order('created_at', { ascending: false });
      setActiveBonds(bonds || []);
      setPastBookings(bookings || []);
      setLoading(false);
    };
    loadBonds();
  }, []);

  return (
    <div className="fadeUp" style={{ padding: "24px", paddingBottom: "100px" }}>
      <h2 style={{ fontSize: "28px", fontWeight: "800", color: NAVY, fontFamily: "'Playfair Display', serif", marginBottom: "24px" }}>Active Bonds</h2>
      {loading ? (
        <p style={{ color: MUTED }}>Loading your bonds...</p>
      ) : (
        <>
          {activeBonds.length === 0 ? (
            <Card style={{ textAlign: "center", padding: "32px" }}>
              <p style={{ color: MUTED }}>No active recurring bonds yet.</p>
              <p style={{ color: GOLD, fontWeight: "700", marginTop: "8px", cursor: "pointer" }}>Start a new Bond →</p>
            </Card>
          ) : (
            activeBonds.map(bond => (
              <Card key={bond.id} style={{ marginBottom: "16px" }}>
                <div style={{ display: "flex", gap: "16px", alignItems: "center" }}>
                  <div style={{ width: "56px", height: "56px", borderRadius: "50%", background: GOLD_LIGHT, display: "flex", alignItems: "center", justifyContent: "center", fontSize: "28px" }}>👤</div>
                  <div style={{ flex: 1 }}>
                    <h4 style={{ fontSize: "17px", fontWeight: "700", color: NAVY }}>{bond.profiles.full_name}</h4>
                    <p style={{ fontSize: "13px", color: MUTED }}>{bond.services.name} · {bond.frequency}</p>
                  </div>
                  <Badge text="ACTIVE" />
                </div>
              </Card>
            ))
          )}

          <h4 style={{ fontSize: "18px", fontWeight: "800", color: NAVY, marginTop: "32px", marginBottom: "16px" }}>Booking History</h4>
          <div style={{ display: "flex", flexDirection: "column", gap: "12px" }}>
            {pastBookings.map(b => (
              <div key={b.id} style={{ background: "#fff", padding: "16px", borderRadius: "16px", border: `1px solid ${BORDER}`, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                <div>
                  <p style={{ fontWeight: "700", color: NAVY, fontSize: "14px" }}>{b.services.name}</p>
                  <p style={{ fontSize: "11px", color: MUTED }}>{new Date(b.created_at).toLocaleDateString()} · {b.status}</p>
                </div>
                {b.status === 'completed' ? (
                  <button onClick={() => onReview({ id: b.id, service_name: b.services.name, expert_id: b.expert_id })} style={{ background: GOLD_LIGHT, color: GOLD, border: "none", borderRadius: "8px", padding: "6px 12px", fontSize: "12px", fontWeight: "700", cursor: "pointer" }}>Rate Expert</button>
                ) : (
                  <Badge text={b.status.toUpperCase()} />
                )}
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  );
}

// 5. Wallet Screen
function Wallet() {
  const [balance, setBalance] = useState(0);
  const [history, setHistory] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showTopUp, setShowTopUp] = useState(false);

  const loadWallet = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      const { data: profile } = await supabase.from('profiles').select('wallet_balance').eq('id', user.id).single();
      const { data: txs } = await supabase.from('wallet_transactions').select('*').order('created_at', { ascending: false });
      
      setBalance(profile?.wallet_balance || 0);
      setHistory(txs || []);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadWallet();
    
    // Subscribe to real-time changes
    const channel = supabase.channel('wallet_changes')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'wallet_transactions' }, () => {
        loadWallet();
      })
      .subscribe();

    return () => supabase.removeChannel(channel);
  }, []);

  const handleTopUp = async (amount) => {
    setShowTopUp(false);
    setLoading(true);
    try {
      const { data: { user } } = await supabase.auth.getUser();
      await supabase.from('wallet_transactions').insert([{
        profile_id: user.id,
        amount: amount,
        type: 'credit',
        description: 'Wallet Top-up'
      }]);
    } catch (e) {
      alert(e.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fadeUp" style={{ padding: "24px", paddingBottom: "100px" }}>
      <h2 style={{ fontSize: "28px", fontWeight: "800", color: NAVY, fontFamily: "'Playfair Display', serif", marginBottom: "24px" }}>My Wallet</h2>
      
      <Card style={{ background: GRAD, borderRadius: "24px", padding: "32px", color: "#fff", marginBottom: "32px", boxShadow: `0 20px 40px ${NAVY}44`, position: "relative", overflow: "hidden" }}>
        <p style={{ fontSize: "14px", opacity: 0.7, marginBottom: "8px" }}>Available Balance</p>
        <h3 style={{ fontSize: "42px", fontWeight: "800", marginBottom: "24px" }}>₹{balance.toLocaleString()}</h3>
        <Button onClick={() => setShowTopUp(true)}>Add Funds ⊕</Button>
      </Card>

      <h4 style={{ fontSize: "18px", fontWeight: "700", color: NAVY, marginBottom: "16px" }}>Transaction History</h4>
      {loading ? (
        <p style={{ color: MUTED }}>Loading history...</p>
      ) : (
        <div style={{ display: "flex", flexDirection: "column", gap: "12px" }}>
          {history.length === 0 ? (
            <p style={{ color: MUTED, textAlign: "center", padding: "40px" }}>No transactions yet.</p>
          ) : (
            history.map((tx, i) => (
              <div key={tx.id} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "16px 0", borderBottom: `1px solid ${BORDER}` }}>
                <div>
                  <p style={{ fontWeight: "700", color: NAVY, fontSize: "15px" }}>{tx.description}</p>
                  <p style={{ fontSize: "12px", color: MUTED }}>{new Date(tx.created_at).toLocaleDateString()}</p>
                </div>
                <p style={{ fontWeight: "800", color: tx.type === "credit" ? GREEN : RED, fontSize: "16px" }}>
                  {tx.type === "credit" ? "+" : "-"}₹{tx.amount}
                </p>
              </div>
            ))
          )}
        </div>
      )}

      {showTopUp && (
        <div style={{ position: "fixed", inset: 0, background: "rgba(0,0,0,0.6)", backdropFilter: "blur(5px)", zIndex: 2000, display: "flex", alignItems: "center", justifyContent: "center", padding: "20px" }}>
          <div className="fadeUp" style={{ background: "#fff", borderRadius: "24px", padding: "32px", width: "100%", maxWidth: "360px" }}>
            <h3 style={{ fontSize: "20px", fontWeight: "800", color: NAVY, marginBottom: "8px" }}>Add Funds</h3>
            <p style={{ color: MUTED, fontSize: "14px", marginBottom: "24px" }}>Select an amount to add to your wallet.</p>
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px", marginBottom: "24px" }}>
              {[500, 1000, 2000, 5000].map(amt => (
                <button key={amt} onClick={() => handleTopUp(amt)} style={{ padding: "16px", borderRadius: "14px", border: `2px solid ${GOLD_LIGHT}`, background: "#fff", color: GOLD, fontWeight: "700", cursor: "pointer" }}>₹{amt}</button>
              ))}
            </div>
            <Button variant="outline" onClick={() => setShowTopUp(false)}>Cancel</Button>
          </div>
        </div>
      )}
    </div>
  );
}

// 6. Profile Screen
function Profile({ onLogout }) {
  return (
    <div style={{ background: BG, minHeight: "100vh", padding: "24px" }}>
      <div style={{ textAlign: "center", marginBottom: "32px" }}>
        <div style={{ width: "100px", height: "100px", borderRadius: "50%", background: GOLD_LIGHT, border: `4px solid #fff`, margin: "0 auto 16px", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "48px", boxShadow: "0 10px 30px rgba(0,0,0,0.1)" }}>👤</div>
        <h2 style={{ fontSize: "24px", fontWeight: "800", color: NAVY }}>Abhishek Sharma</h2>
        <p style={{ color: MUTED, fontSize: "14px" }}>Premium Member since 2024</p>
      </div>

      <Card style={{ padding: 0, overflow: "hidden" }}>
        {[
          { icon: "👤", t: "Personal Info", s: "Edit details" },
          { icon: "📍", t: "Saved Addresses", s: "Home, Office" },
          { icon: "🛡️", t: "Trust & Safety", s: "Verification status" },
          { icon: "💳", t: "Payment Methods", s: "UPI, Cards" },
          { icon: "💬", t: "Help Center", s: "24/7 Support" },
        ].map((item, i) => (
          <div key={i} style={{ display: "flex", alignItems: "center", gap: "16px", padding: "16px", borderBottom: i === 4 ? "none" : `1px solid ${BORDER}`, cursor: "pointer" }}>
            <div style={{ fontSize: "20px" }}>{item.icon}</div>
            <div style={{ flex: 1 }}>
              <p style={{ fontWeight: "700", color: NAVY, fontSize: "14px" }}>{item.t}</p>
              <p style={{ fontSize: "11px", color: MUTED }}>{item.s}</p>
            </div>
            <span style={{ color: BORDER }}>›</span>
          </div>
        ))}
      </Card>

      <div style={{ marginTop: "32px" }}>
        <Button variant="outline" onClick={onLogout}>Logout</Button>
      </div>
    </div>
  );
}

// 7. Admin Dashboard
function AdminDashboard({ onBack }) {
  return (
    <div style={{ background: NAVY, minHeight: "100vh", padding: "24px", color: "#fff" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "32px" }}>
        <h2 style={{ fontSize: "24px", fontWeight: "800", fontFamily: "'Playfair Display', serif" }}>Admin Console</h2>
        <button onClick={onBack} style={{ background: "rgba(255,255,255,0.1)", border: "none", borderRadius: "10px", padding: "8px 16px", color: "#fff", cursor: "pointer" }}>Exit</button>
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "16px", marginBottom: "32px" }}>
        {[
          { l: "Total Users", v: "12.4K", c: ACCENT },
          { l: "Live Bonds", v: "842", c: GOLD },
          { l: "Revenue (M)", v: "₹4.2L", c: GREEN },
          { l: "Pending Kyc", v: "24", c: RED }
        ].map((s, i) => (
          <div key={i} style={{ background: "rgba(255,255,255,0.05)", borderRadius: "20px", padding: "20px", border: "1px solid rgba(255,255,255,0.1)" }}>
            <p style={{ fontSize: "12px", color: "rgba(255,255,255,0.5)", marginBottom: "4px" }}>{s.l}</p>
            <h3 style={{ fontSize: "24px", fontWeight: "800", color: s.c }}>{s.v}</h3>
          </div>
        ))}
      </div>

      <h4 style={{ fontSize: "18px", fontWeight: "700", marginBottom: "16px" }}>Recent Applications</h4>
      {[
        { n: "Sunita K.", s: "Cooking", d: "2h ago" },
        { n: "Rajesh M.", s: "Cleaning", d: "5h ago" },
        { n: "Meera P.", s: "Elder Care", d: "Yesterday" }
      ].map((app, i) => (
        <div key={i} style={{ background: "rgba(255,255,255,0.03)", borderRadius: "16px", padding: "16px", marginBottom: "12px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <div>
            <p style={{ fontWeight: "700" }}>{app.n}</p>
            <p style={{ fontSize: "12px", color: "rgba(255,255,255,0.4)" }}>{app.s} · {app.d}</p>
          </div>
          <button style={{ background: GOLD, border: "none", borderRadius: "8px", padding: "6px 12px", color: "#fff", fontSize: "12px", fontWeight: "700" }}>Review</button>
        </div>
      ))}
    </div>
  );
}

// ── MAIN APP ─────────────────────────────────────────────────────────────────
export default function BandhanApp() {
  const [user, setUser] = useState(null);
  const [screen, setScreen] = useState("auth"); // "auth", "home", "booking", "admin"
  const [tab, setTab] = useState("home");
  const [selectedService, setSelectedService] = useState(null);

  const [activeReview, setActiveReview] = useState(null);

  useEffect(() => {
    // Check current session
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (session?.user) {
        fetchProfile(session.user.id);
      }
    });

    // Listen for changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (session?.user) {
        fetchProfile(session.user.id);
      } else {
        setUser(null);
        setScreen("auth");
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  const fetchProfile = async (userId) => {
    const { data } = await supabase.from('profiles').select('*').eq('id', userId).single();
    if (data) {
      setUser(data);
      setScreen("home");
    }
  };

  const onAuthComplete = (userData) => {
    setUser(userData);
    setScreen("home");
  };

  const logout = () => {
    setUser(null);
    setScreen("auth");
  };

  const handleBook = (service) => {
    setSelectedService(service);
    setScreen("booking");
  };

  const confirmBooking = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      const { data: profile } = await supabase.from('profiles').select('wallet_balance').eq('id', user.id).single();
      
      if ((profile?.wallet_balance || 0) < selectedService.price) {
        alert("Insufficient balance in wallet. Please top up to confirm booking.");
        setTab("wallet");
        setScreen("home");
        return;
      }

      // Record debit transaction
      await supabase.from('wallet_transactions').insert([{
        profile_id: user.id,
        amount: selectedService.price,
        type: 'debit',
        description: `Booking: ${selectedService.name}`
      }]);

      // Create Booking
      const { data: booking } = await supabase.from('bookings').insert([{
        customer_id: user.id,
        service_id: selectedService.id,
        status: 'completed', // For demo, we mark as completed immediately
        total_price: selectedService.price
      }]).select().single();

      alert("Booking confirmed! ₹" + selectedService.price + " deducted from wallet.");
      setScreen("home");
      setTab("bonds");
      
      // Prompt for review after a delay
      setTimeout(() => {
        setActiveReview({ id: booking.id, service_name: selectedService.name, expert_id: null });
      }, 1500);

    } catch (e) {
      alert("Booking failed: " + e.message);
    }
  };

  const startApp = () => setScreen("home");

  return (
    <div style={{ maxWidth: "480px", margin: "0 auto", position: "relative", minHeight: "100vh", background: BG, boxShadow: "0 0 100px rgba(0,0,0,0.1)" }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Playfair+Display:wght@700;800&display=swap');
        body { margin: 0; padding: 0; font-family: 'Inter', sans-serif; background: #e2e8f0; }
        * { box-sizing: border-box; }
        button:active { transform: scale(0.98); }
        .fadeUp { animation: fadeUp 0.4s ease-out; }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
      `}</style>
      
      {activeReview && <ReviewModal booking={activeReview} onClose={() => setActiveReview(null)} />}

      {screen === "auth" && <AuthFlow onAuthComplete={onAuthComplete} />}
      
      {screen === "home" && (
        <>
          {tab === "home" && <Home onBook={handleBook} />}
          {tab === "bonds" && <Bonds onReview={setActiveReview} />}
          {tab === "wallet" && <Wallet />}
          {tab === "profile" && <Profile onLogout={logout} />}
          
          {/* Bottom Navigation */}
          <div style={{ position: "fixed", bottom: 0, left: "50%", transform: "translateX(-50%)", width: "100%", maxWidth: "480px", background: "rgba(255,255,255,0.95)", backdropFilter: "blur(20px)", borderTop: `1px solid ${BORDER}`, display: "flex", justifyContent: "space-around", padding: "12px 0 24px", zIndex: 1000 }}>
            <NavItem id="home" icon="🏠" label="Home" active={tab === "home"} onClick={() => setTab("home")} />
            <NavItem id="bonds" icon="🤝" label="Bonds" active={tab === "bonds"} onClick={() => setTab("bonds")} />
            <div onClick={() => setScreen("admin")} style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: "4px", cursor: "pointer", opacity: 0.1 }}>
              <span style={{ fontSize: "20px" }}>⚙️</span>
              <span style={{ fontSize: "10px", fontWeight: "700" }}>Admin</span>
            </div>
            <NavItem id="wallet" icon="💸" label="Wallet" active={tab === "wallet"} onClick={() => setTab("wallet")} />
            <NavItem id="profile" icon="👤" label="Profile" active={tab === "profile"} onClick={() => setTab("profile")} />
          </div>
        </>
      )}

      {screen === "booking" && <Booking service={selectedService} onBack={() => setScreen("home")} onConfirm={confirmBooking} />}
      {screen === "admin" && <AdminDashboard onBack={() => setScreen("home")} />}
    </div>
  );
}

function NavItem({ icon, label, active, onClick }) {
  return (
    <div onClick={onClick} style={{ textAlign: "center", color: active ? GOLD : MUTED, cursor: "pointer", transition: "all 0.2s", transform: active ? "scale(1.1)" : "scale(1)" }}>
      <div style={{ fontSize: "22px" }}>{icon}</div>
      <div style={{ fontSize: "10px", fontWeight: "800", marginTop: "4px" }}>{label}</div>
      {active && <div style={{ width: "4px", height: "4px", background: GOLD, borderRadius: "50%", margin: "4px auto 0" }} />}
    </div>
  );
}
