import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { initializeApp, cert } from "npm:firebase-admin/app";
import { getMessaging } from "npm:firebase-admin/messaging";
console.log("🔔 Starting notification function...");
// تهيئة Supabase client أولاً
const supabaseUrl = Deno.env.get("SUPABASE_URL");
const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
if (!supabaseUrl || !supabaseServiceKey) {
  console.error("❌ Missing Supabase environment variables");
  throw new Error("Supabase URL or Service Role Key is missing");
}
const supabase = createClient(supabaseUrl, supabaseServiceKey);
console.log("✅ Supabase client initialized");
// تهيئة Firebase بشكل غير متزامن عند الطلب الأول
let firebaseApp = null;
async function initializeFirebase() {
  if (firebaseApp) {
    return firebaseApp;
  }
  console.log("🔄 Initializing Firebase...");
  const serviceAccountEnv = Deno.env.get("FIREBASE_SERVICE_ACCOUNT_KEY");
  if (!serviceAccountEnv) {
    throw new Error("❌ FIREBASE_SERVICE_ACCOUNT_KEY environment variable is missing");
  }
  try {
    const serviceAccount = JSON.parse(serviceAccountEnv);
    console.log("✅ Firebase service account parsed successfully");
    // تنظيف المفتاح الخاص
    if (serviceAccount.private_key) {
      serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, '\n');
      console.log("✅ Private key formatted");
    }
    firebaseApp = initializeApp({
      credential: cert(serviceAccount)
    });
    console.log("✅ Firebase app initialized successfully");
    return firebaseApp;
  } catch (error) {
    console.error("❌ Firebase initialization failed:", error);
    throw new Error(`Firebase init error: ${error.message}`);
  }
}
serve(async (req)=>{
  const startTime = Date.now();
  console.log(`📨 Request received at ${new Date().toISOString()}`);
  try {
    // التحقق من طريقة الطلب
    if (req.method !== "POST") {
      console.log("❌ Method not allowed:", req.method);
      return new Response(JSON.stringify({
        success: false,
        error: "Method not allowed. Use POST."
      }), {
        status: 405,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "POST"
        }
      });
    }
    // التحقق من Content-Type
    const contentType = req.headers.get("content-type");
    if (!contentType || !contentType.includes("application/json")) {
      console.log("❌ Invalid content type:", contentType);
      return new Response(JSON.stringify({
        success: false,
        error: "Content-Type must be application/json"
      }), {
        status: 400,
        headers: {
          "Content-Type": "application/json"
        }
      });
    }
    // تحليل JSON body
    let requestBody;
    try {
      requestBody = await req.json();
      console.log("📦 Request body:", requestBody);
    } catch (parseError) {
      console.log("❌ JSON parse error:", parseError);
      return new Response(JSON.stringify({
        success: false,
        error: "Invalid JSON in request body"
      }), {
        status: 400,
        headers: {
          "Content-Type": "application/json"
        }
      });
    }
    const { receiverId, title, body } = requestBody;
    // التحقق من البيانات المطلوبة
    if (!receiverId) {
      return new Response(JSON.stringify({
        success: false,
        error: "Missing required field: receiverId"
      }), {
        status: 400,
        headers: {
          "Content-Type": "application/json"
        }
      });
    }
    if (!title) {
      return new Response(JSON.stringify({
        success: false,
        error: "Missing required field: title"
      }), {
        status: 400,
        headers: {
          "Content-Type": "application/json"
        }
      });
    }
    if (!body) {
      return new Response(JSON.stringify({
        success: false,
        error: "Missing required field: body"
      }), {
        status: 400,
        headers: {
          "Content-Type": "application/json"
        }
      });
    }
    console.log(`🔍 Searching for FCM token for user: ${receiverId}`);
    // البحث عن token في قاعدة البيانات
    const { data: deviceData, error: deviceError } = await supabase.from("user_devices").select("fcm_token") // بس FCM token
    .eq("user_id", receiverId).not("fcm_token", "is", null).maybeSingle();
    if (deviceError) {
      console.error("❌ Database query error:", deviceError);
      return new Response(JSON.stringify({
        success: false,
        error: "Database query failed",
        details: deviceError.message
      }), {
        status: 500,
        headers: {
          "Content-Type": "application/json"
        }
      });
    }
    if (!deviceData || !deviceData.fcm_token) {
      console.log("❌ No FCM token found for user:", receiverId);
      return new Response(JSON.stringify({
        success: false,
        error: "No FCM token found for this user",
        user_id: receiverId
      }), {
        status: 404,
        headers: {
          "Content-Type": "application/json"
        }
      });
    }
    console.log("✅ FCM token found:", deviceData.fcm_token.substring(0, 20) + "...");
    // تهيئة Firebase
    const firebaseApp = await initializeFirebase();
    // إعداد رسالة الإشعار
    const message = {
      token: deviceData.fcm_token,
      notification: {
        title: String(title),
        body: String(body)
      },
      data: {
        user_id: receiverId,
        timestamp: new Date().toISOString()
      }
    };
    console.log("🚀 Sending FCM notification...");
    // إرسال الإشعار
    try {
      const messageId = await getMessaging(firebaseApp).send(message);
      const executionTime = Date.now() - startTime;
      console.log(`✅ Notification sent successfully!`, {
        messageId,
        userId: receiverId,
        executionTime: `${executionTime}ms`
      });
      return new Response(JSON.stringify({
        success: true,
        messageId: messageId,
        user_id: receiverId,
        execution_time_ms: executionTime
      }), {
        status: 200,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*"
        }
      });
    } catch (fcmError) {
      console.error("❌ FCM send error:", fcmError);
      return new Response(JSON.stringify({
        success: false,
        error: "Failed to send notification",
        details: fcmError.message,
        fcm_error_code: fcmError.code
      }), {
        status: 500,
        headers: {
          "Content-Type": "application/json"
        }
      });
    }
  } catch (error) {
    const executionTime = Date.now() - startTime;
    console.error("💥 Unhandled error in function:", error);
    return new Response(JSON.stringify({
      success: false,
      error: "Internal server error",
      details: error.message,
      execution_time_ms: executionTime
    }), {
      status: 500,
      headers: {
        "Content-Type": "application/json"
      }
    });
  }
});
