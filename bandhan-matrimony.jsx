import { useState, useEffect } from "react";

// ── THEME & CONSTANTS ────────────────────────────────────────────────────────
const RED = "#991b1b"; // Deep Royal Red
const GOLD = "#b45309";
const GOLD_LIGHT = "#fef3c7";
const CREAM = "#fffbeb";
const NAVY = "#0f172a";
const TEXT = "#1e293b";
const MUTED = "#64748b";
const BORDER = "#e2e8f0";

const MOCK_MATCHES = [
  { id: 1, name: "Ananya Sharma", age: 26, height: "5'4\"", city: "Mumbai", education: "MBA, IIM Bangalore", occupation: "Marketing Manager", photos: ["👩"], bio: "Looking for someone who loves traveling and deep conversations. Family-oriented and passionate about my career." },
  { id: 2, name: "Priyanka Gupta", age: 25, height: "5'5\"", city: "Delhi", education: "MBBS", occupation: "Cardiologist", photos: ["👩‍⚕️"], bio: "A doctor by profession, a poet by heart. Searching for a soulmate who understands the balance of life." },
  { id: 3, name: "Sneha Reddy", age: 27, height: "5'3\"", city: "Hyderabad", education: "B.Tech, MS in CS", occupation: "Software Engineer at Google", photos: ["👩‍💻"], bio: "Tech enthusiast, foodie, and an avid reader. Let's build a future together." }
];

// ── COMPONENTS ────────────────────────────────────────────────────────────────

const Card = ({ children, style }) => (
  <div style={{ background: "#fff", borderRadius: "24px", padding: "20px", boxShadow: "0 10px 30px rgba(0,0,0,0.05)", border: `1px solid ${BORDER}`, ...style }}>
    {children}
  </div>
);

const Button = ({ children, onClick, variant = "primary", loading }) => (
  <button 
    onClick={onClick} 
    disabled={loading}
    style={{ 
      width: "100%", 
      padding: "16px", 
      borderRadius: "14px", 
      border: "none", 
      background: variant === "primary" ? RED : "transparent", 
      color: variant === "primary" ? "#fff" : RED, 
      border: variant === "outline" ? `2px solid ${RED}` : "none",
      fontSize: "16px", 
      fontWeight: "700", 
      cursor: "pointer", 
      transition: "all 0.2s",
      opacity: loading ? 0.7 : 1
    }}
  >
    {children}
  </button>
);

const Badge = ({ text }) => (
  <span style={{ background: GOLD_LIGHT, color: GOLD, padding: "4px 12px", borderRadius: "999px", fontSize: "10px", fontWeight: "800", letterSpacing: "0.5px" }}>
    {text.toUpperCase()}
  </span>
);

// ── SCREENS ──────────────────────────────────────────────────────────────────

// 1. Splash / Discovery
function Discover({ onSelect }) {
  const [matches, setMatches] = useState(MOCK_MATCHES);
  const [index, setIndex] = useState(0);
  const current = matches[index];

  if (!current) return <div style={{ padding: "40px", textAlign: "center" }}>No more matches today! Check back later.</div>;

  return (
    <div className="fadeUp" style={{ padding: "20px", paddingBottom: "100px" }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "24px" }}>
        <h2 style={{ fontSize: "28px", fontWeight: "800", color: RED, fontFamily: "'Playfair Display', serif" }}>For You</h2>
        <div style={{ width: "40px", height: "40px", borderRadius: "50%", background: BORDER, display: "flex", alignItems: "center", justifyContent: "center", fontSize: "20px" }}>⚙️</div>
      </div>

      <div style={{ position: "relative", height: "500px", borderRadius: "30px", overflow: "hidden", boxShadow: "0 20px 50px rgba(0,0,0,0.2)" }}>
        <div style={{ width: "100%", height: "100%", background: "#f3f4f6", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "120px" }}>
          {current.photos[0]}
        </div>
        <div style={{ position: "absolute", bottom: 0, left: 0, right: 0, padding: "32px", background: "linear-gradient(transparent, rgba(0,0,0,0.8))", color: "#fff" }}>
          <div style={{ display: "flex", alignItems: "center", gap: "10px", marginBottom: "8px" }}>
            <h3 style={{ fontSize: "28px", fontWeight: "800" }}>{current.name}, {current.age}</h3>
            <div style={{ width: "20px", height: "20px", background: "#3b82f6", borderRadius: "50%", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "12px" }}>✓</div>
          </div>
          <p style={{ fontSize: "16px", opacity: 0.9, marginBottom: "16px" }}>{current.occupation} · {current.city}</p>
          <div style={{ display: "flex", gap: "8px" }}>
            <Badge text={current.education.split(',')[0]} />
            <Badge text={current.height} />
          </div>
        </div>
      </div>

      <div style={{ display: "flex", justifyContent: "center", gap: "20px", marginTop: "-30px", position: "relative", zIndex: 10 }}>
        <button onClick={() => setIndex(i => i + 1)} style={{ width: "64px", height: "64px", borderRadius: "50%", background: "#fff", border: "none", boxShadow: "0 10px 20px rgba(0,0,0,0.1)", fontSize: "24px", cursor: "pointer", color: MUTED }}>✕</button>
        <button onClick={() => { alert("Interest Sent! ❤️"); setIndex(i => i + 1); }} style={{ width: "72px", height: "72px", borderRadius: "50%", background: RED, border: "none", boxShadow: "0 10px 20px rgba(153,27,27,0.3)", fontSize: "32px", cursor: "pointer", color: "#fff" }}>❤️</button>
        <button style={{ width: "64px", height: "64px", borderRadius: "50%", background: "#fff", border: "none", boxShadow: "0 10px 20px rgba(0,0,0,0.1)", fontSize: "24px", cursor: "pointer", color: GOLD }}>★</button>
      </div>
    </div>
  );
}

// 2. Interests Tab
function Interests() {
  const requests = [
    { name: "Meera Kapoor", age: 24, photo: "👩", status: "received", time: "2h ago" },
    { name: "Neha Verma", age: 26, photo: "👩‍💼", status: "sent", time: "Yesterday" }
  ];

  return (
    <div className="fadeUp" style={{ padding: "24px" }}>
      <h2 style={{ fontSize: "28px", fontWeight: "800", color: RED, fontFamily: "'Playfair Display', serif", marginBottom: "24px" }}>Interests</h2>
      <div style={{ display: "flex", gap: "12px", marginBottom: "24px" }}>
        {["Received", "Sent", "Mutual"].map(t => (
          <button key={t} style={{ flex: 1, padding: "10px", borderRadius: "12px", border: "none", background: t === "Received" ? RED : BORDER, color: t === "Received" ? "#fff" : MUTED, fontWeight: "700" }}>{t}</button>
        ))}
      </div>

      {requests.map((r, i) => (
        <Card key={i} style={{ marginBottom: "12px", padding: "16px" }}>
          <div style={{ display: "flex", gap: "16px", alignItems: "center" }}>
            <div style={{ width: "50px", height: "50px", borderRadius: "50%", background: CREAM, display: "flex", alignItems: "center", justifyContent: "center", fontSize: "24px" }}>{r.photo}</div>
            <div style={{ flex: 1 }}>
              <p style={{ fontWeight: "700", color: TEXT }}>{r.name}, {r.age}</p>
              <p style={{ fontSize: "12px", color: MUTED }}>Interest {r.status} · {r.time}</p>
            </div>
            {r.status === "received" ? (
              <div style={{ display: "flex", gap: "8px" }}>
                <button style={{ width: "32px", height: "32px", borderRadius: "50%", background: "#fee2e2", color: RED, border: "none", fontSize: "14px" }}>✕</button>
                <button style={{ width: "32px", height: "32px", borderRadius: "50%", background: "#dcfce7", color: "#166534", border: "none", fontSize: "14px" }}>✓</button>
              </div>
            ) : (
              <Badge text="PENDING" />
            )}
          </div>
        </Card>
      ))}
    </div>
  );
}

// 3. Messages / Chat
function Messages() {
  return (
    <div className="fadeUp" style={{ padding: "24px" }}>
      <h2 style={{ fontSize: "28px", fontWeight: "800", color: RED, fontFamily: "'Playfair Display', serif", marginBottom: "24px" }}>Messages</h2>
      <div style={{ textAlign: "center", padding: "60px 20px" }}>
        <div style={{ fontSize: "60px", marginBottom: "20px" }}>💬</div>
        <h3 style={{ fontSize: "20px", fontWeight: "700", color: TEXT, marginBottom: "8px" }}>No Conversations Yet</h3>
        <p style={{ color: MUTED, fontSize: "14px" }}>Send an interest to start a conversation with your potential matches.</p>
      </div>
    </div>
  );
}

// 4. My Profile
function Profile() {
  return (
    <div className="fadeUp" style={{ padding: "24px" }}>
      <div style={{ textAlign: "center", marginBottom: "32px" }}>
        <div style={{ width: "100px", height: "100px", borderRadius: "50%", background: CREAM, border: `4px solid ${RED}`, margin: "0 auto 16px", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "48px", boxShadow: "0 10px 30px rgba(153,27,27,0.1)" }}>👨</div>
        <h2 style={{ fontSize: "24px", fontWeight: "800", color: TEXT }}>Rahul Sharma</h2>
        <p style={{ color: MUTED, fontSize: "14px" }}>Profile Completeness: 85%</p>
        <div style={{ width: "150px", height: "6px", background: BORDER, borderRadius: "3px", margin: "12px auto", overflow: "hidden" }}>
          <div style={{ width: "85%", height: "100%", background: RED }} />
        </div>
      </div>

      <Card style={{ marginBottom: "24px" }}>
        <h3 style={{ fontSize: "18px", fontWeight: "800", color: TEXT, marginBottom: "16px" }}>Membership Plan</h3>
        <div style={{ background: "linear-gradient(135deg, #991b1b, #7f1d1d)", padding: "20px", borderRadius: "16px", color: "#fff" }}>
          <p style={{ fontSize: "12px", opacity: 0.8, marginBottom: "4px" }}>CURRENT STATUS</p>
          <h4 style={{ fontSize: "20px", fontWeight: "800", marginBottom: "16px" }}>Gold Member ✦</h4>
          <p style={{ fontSize: "13px" }}>Valid until Dec 2024</p>
        </div>
      </Card>

      <div style={{ display: "flex", flexDirection: "column", gap: "12px" }}>
        {["Edit Profile", "Partner Preferences", "Privacy Settings", "Help & Support"].map(item => (
          <div key={item} style={{ padding: "16px", background: "#fff", borderRadius: "16px", border: `1px solid ${BORDER}`, display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <span style={{ fontWeight: "600", color: TEXT }}>{item}</span>
            <span style={{ color: MUTED }}>›</span>
          </div>
        ))}
      </div>
    </div>
  );
}

// ── MAIN APP ─────────────────────────────────────────────────────────────────
export default function MatrimonyApp() {
  const [tab, setTab] = useState("discover");

  return (
    <div style={{ maxWidth: "480px", margin: "0 auto", position: "relative", minHeight: "100vh", background: CREAM, boxShadow: "0 0 100px rgba(0,0,0,0.1)", overflowX: "hidden" }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Playfair+Display:wght@700;800&display=swap');
        body { margin: 0; padding: 0; font-family: 'Inter', sans-serif; background: #e2e8f0; }
        * { box-sizing: border-box; }
        button:active { transform: scale(0.98); }
        .fadeUp { animation: fadeUp 0.4s ease-out; }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
      `}</style>
      
      {tab === "discover" && <Discover />}
      {tab === "interests" && <Interests />}
      {tab === "messages" && <Messages />}
      {tab === "profile" && <Profile />}

      {/* Bottom Navigation */}
      <div style={{ position: "fixed", bottom: 0, left: "50%", transform: "translateX(-50%)", width: "100%", maxWidth: "480px", background: "rgba(255,255,255,0.95)", backdropFilter: "blur(20px)", borderTop: `1px solid ${BORDER}`, display: "flex", justifyContent: "space-around", padding: "12px 0 24px", zIndex: 1000 }}>
        <NavItem icon="🎴" label="Discover" active={tab === "discover"} onClick={() => setTab("discover")} />
        <NavItem icon="❤️" label="Interests" active={tab === "interests"} onClick={() => setTab("interests")} />
        <NavItem icon="💬" label="Messages" active={tab === "messages"} onClick={() => setTab("messages")} />
        <NavItem icon="👤" label="Profile" active={tab === "profile"} onClick={() => setTab("profile")} />
      </div>
    </div>
  );
}

function NavItem({ icon, label, active, onClick }) {
  return (
    <div onClick={onClick} style={{ textAlign: "center", color: active ? RED : MUTED, cursor: "pointer", transition: "all 0.2s" }}>
      <div style={{ fontSize: "22px" }}>{icon}</div>
      <div style={{ fontSize: "10px", fontWeight: "800", marginTop: "4px" }}>{label}</div>
    </div>
  );
}
