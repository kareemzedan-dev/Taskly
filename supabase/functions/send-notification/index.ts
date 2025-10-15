import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { initializeApp, cert } from "npm:firebase-admin/app";
import { getMessaging } from "npm:firebase-admin/messaging";
console.log("🔔 Starting notification function...");
// تهيئة Supabase client
const supabaseUrl = Deno.env.get("SUPABASE_URL");
const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
if (!supabaseUrl || !supabaseServiceKey) {
  throw new Error("❌ Supabase URL or Service Role Key is missing");
}
const supabase = createClient(supabaseUrl, supabaseServiceKey);
console.log("✅ Supabase client initialized");
// تهيئة Firebase عند أول استخدام
let firebaseApp = null;
async function initializeFirebase() {
  if (firebaseApp) return firebaseApp;
  const serviceAccountEnv = Deno.env.get("FIREBASE_SERVICE_ACCOUNT_KEY");
  if (!serviceAccountEnv) throw new Error("❌ FIREBASE_SERVICE_ACCOUNT_KEY missing");
  const serviceAccount = JSON.parse(serviceAccountEnv);
  if (serviceAccount.private_key) {
    serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, "\n");
  }
  firebaseApp = initializeApp({
    credential: cert(serviceAccount)
  });
  console.log("✅ Firebase app initialized successfully");
  return firebaseApp;
}
serve(async (req)=>{
  const startTime = Date.now();
  if (req.method !== "POST") {
    return new Response(JSON.stringify({
      success: false,
      error: "Method not allowed. Use POST."
    }), {
      status: 405,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      }
    });
  }
  const contentType = req.headers.get("content-type");
  if (!contentType || !contentType.includes("application/json")) {
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
  let requestBody;
  try {
    requestBody = await req.json();
  } catch (parseError) {
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
  if (!receiverId || !title || !body) {
    return new Response(JSON.stringify({
      success: false,
      error: "Missing required fields: receiverId, title, body"
    }), {
      status: 400,
      headers: {
        "Content-Type": "application/json"
      }
    });
  }
  try {
    console.log(`🔍 Searching for FCM tokens for user: ${receiverId}`);
    // جلب كل الأجهزة للمستخدم
    const { data: devices, error: deviceError } = await supabase.from("user_devices").select("fcm_token").eq("user_id", receiverId).not("fcm_token", "is", null);
    if (deviceError) throw deviceError;
    if (!devices || devices.length === 0) {
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
    console.log(`✅ Found ${devices.length} FCM token(s)`);
    const firebaseAppInstance = await initializeFirebase();
    const results = [];
    for (const device of devices){
      try {
        // استخدام Notification Messages مع إعدادات الخلفية
        const message = {
          token: device.fcm_token,
          notification: {
            title: String(title),
            body: String(body)
          },
          android: {
            priority: "high",
            ttl: 3600,
            notification: {
              title: String(title),
              body: String(body),
              sound: "default",
              channel_id: "high_priority_channel",
              priority: "max",
              default_sound: true,
              default_vibrate_timings: true,
              // إعدادات إضافية للشاشة المقفولة
              visibility: "public",
              notification_count: 1
            }
          },
          apns: {
            headers: {
              "apns-priority": "10",
              "apns-topic": "com.example.taskly" // bundle identifier
            },
            payload: {
              aps: {
                alert: {
                  title: String(title),
                  body: String(body)
                },
                sound: "default",
                badge: 1,
                contentAvailable: true,
                // إعدادات للشاشة المقفولة في iOS
                category: "IMPORTANT",
                threadId: "important-messages"
              }
            }
          },
          data: {
            user_id: receiverId,
            timestamp: new Date().toISOString(),
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            priority: "high",
            type: "important_message"
          }
        };
        const messageId = await getMessaging(firebaseAppInstance).send(message);
        results.push({
          token: device.fcm_token.substring(0, 20) + "...",
          success: true,
          messageId
        });
        console.log(`✅ Notification sent to token: ${device.fcm_token.substring(0, 20)}...`);
      } catch (fcmError) {
        console.error(`❌ Failed to send to token: ${device.fcm_token.substring(0, 20)}...`, fcmError);
        results.push({
          token: device.fcm_token.substring(0, 20) + "...",
          success: false,
          error: fcmError.message
        });
      }
    }
    const executionTime = Date.now() - startTime;
    // حساب النتائج الناجحة والفاشلة
    const successful = results.filter((r)=>r.success).length;
    const failed = results.filter((r)=>!r.success).length;
    console.log(`📊 Results: ${successful} successful, ${failed} failed`);
    return new Response(JSON.stringify({
      success: successful > 0,
      results,
      summary: {
        total: devices.length,
        successful,
        failed
      },
      user_id: receiverId,
      execution_time_ms: executionTime
    }), {
      status: successful > 0 ? 200 : 500,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      }
    });
  } catch (error) {
    const executionTime = Date.now() - startTime;
    console.error("💥 Unhandled error:", error);
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


