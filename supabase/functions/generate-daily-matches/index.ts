// supabase/functions/generate-daily-matches/index.ts
import Anthropic from "npm:@anthropic-ai/sdk";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const anthropic = new Anthropic({ apiKey: Deno.env.get("ANTHROPIC_API_KEY") });

Deno.serve(async (req) => {
  const { user_id } = await req.json();
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL"),
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
  );

  // 1. Get user profile
  const { data: user } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user_id)
    .single();

  if (!user) return new Response("User not found", { status: 404 });

  // 2. Get candidates based on preferences
  const oppositeGender = user.gender === "male" ? "female" : "male";
  const { data: candidates } = await supabase
    .from("profiles")
    .select("*")
    .eq("gender", oppositeGender)
    .eq("is_active", true)
    .eq("is_verified", true)
    .limit(15);

  if (!candidates || candidates.length === 0) {
    return new Response(JSON.stringify({ success: true, count: 0 }));
  }

  // 3. Prompt Claude for matching
  const prompt = `You are an expert Indian matrimony matchmaker.
Identify the top 3 most compatible candidates for the main user.
Return ONLY a valid JSON array of objects: [{"candidate_id": "uuid", "score": 85, "reason": "Explanation"}]

Main User: ${JSON.stringify({
    religion: user.religion, city: user.city, education: user.education,
    profession: user.profession, marriage_timeline: user.marriage_timeline,
    about_me: user.about_me
  })}

Candidates: ${JSON.stringify(candidates.map(c => ({
    id: c.id, religion: c.religion, city: c.city, education: c.education,
    profession: c.profession, marriage_timeline: c.marriage_timeline,
    about_me: c.about_me
  })))}`;

  const response = await anthropic.messages.create({
    model: "claude-3-5-sonnet-20240620",
    max_tokens: 1000,
    messages: [{ role: "user", content: prompt }]
  });

  const results = JSON.parse(response.content[0].text);

  // 4. Save matches to DB
  await supabase.from("matches").insert(
    results.map((r: any) => ({
      user_a: user_id,
      user_b: r.candidate_id,
      ai_score: r.score,
      ai_reason: r.reason,
      matched_date: new Date().toISOString().split("T")[0]
    }))
  );

  return new Response(JSON.stringify({ success: true, count: results.length }));
});
