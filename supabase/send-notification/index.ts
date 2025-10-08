// supabase/functions/send-notification/index.ts

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"
import { initializeApp, cert } from "https://esm.sh/firebase-admin@11/app"
import { getMessaging } from "https://esm.sh/firebase-admin@11/messaging"

// إعداد Firebase Admin
const serviceAccount = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT_KEY")!)
const firebaseApp = initializeApp({ credential: cert(serviceAccount) })

// إنشاء عميل Supabase
const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
)

// تشغيل السيرفر
serve(async (req) => {
  try {
    const { receiverId, title, body } = await req.json()

    if (!receiverId || !title || !body) {
      return new Response(
        JSON.stringify({ error: "Missing required fields" }),
        { status: 400 }
      )
    }

    // جيب الـ token من جدول user_devices
    const { data, error } = await supabase
      .from("user_devices")
      .select("fcm_token")
      .eq("user_id", receiverId)
      .maybeSingle()

    if (error || !data) {
      return new Response(JSON.stringify({ error: "Token not found" }), { status: 400 })
    }

    // ابعت الإشعار عبر Firebase
    await getMessaging(firebaseApp).send({
      token: data.fcm_token,
      notification: { title, body },
    })

    return new Response(JSON.stringify({ success: true }))
  } catch (e) {
    console.error("Error sending notification:", e)
    return new Response(JSON.stringify({ error: e.message }), { status: 500 })
  }
})
