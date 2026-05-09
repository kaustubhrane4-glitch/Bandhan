// supabase/functions/verify-payment/index.ts
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { crypto } from "https://deno.land/std@0.177.0/crypto/mod.ts";

Deno.serve(async (req) => {
  const { razorpay_order_id, razorpay_payment_id, razorpay_signature, plan } = await req.json();
  
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL"),
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")
  );

  // 1. Verify signature
  const body = razorpay_order_id + "|" + razorpay_payment_id;
  const secret = Deno.env.get("RAZORPAY_KEY_SECRET")!;
  
  // HMAC-SHA256 verification...
  // (Assuming verification passes for this skeleton)
  const isValid = true; 

  if (isValid) {
    const userId = (await supabase.auth.getUser(req.headers.get('Authorization')!.split(' ')[1])).data.user?.id;
    
    // 2. Update profile plan
    const expiresAt = new Date();
    expiresAt.setMonth(expiresAt.round().getMonth() + 1);

    await supabase.from("profiles").update({
      plan: plan,
      is_premium: true,
      plan_expires_at: expiresAt.toISOString()
    }).eq("user_id", userId);

    return new Response(JSON.stringify({ success: true }));
  } else {
    return new Response(JSON.stringify({ success: false }), { status: 400 });
  }
});
