// supabase/functions/create-razorpay-order/index.ts
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

Deno.serve(async (req) => {
  const { plan } = await req.json();
  const authHeader = req.headers.get('Authorization')!;
  
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL"),
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
  );

  // Get amount based on plan
  let amount = 0;
  if (plan === 'premium') amount = 99900; // 999 INR in paise
  if (plan === 'concierge') amount = 499900;

  const RAZORPAY_KEY_ID = Deno.env.get("RAZORPAY_KEY_ID");
  const RAZORPAY_KEY_SECRET = Deno.env.get("RAZORPAY_KEY_SECRET");

  const response = await fetch("https://api.razorpay.com/v1/orders", {
    method: "POST",
    headers: {
      "Authorization": "Basic " + btoa(RAZORPAY_KEY_ID + ":" + RAZORPAY_KEY_SECRET),
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      amount: amount,
      currency: "INR",
      receipt: `receipt_${Date.now()}`
    })
  });

  const order = await response.json();

  return new Response(JSON.stringify({ order_id: order.id }), {
    headers: { "Content-Type": "application/json" }
  });
});
