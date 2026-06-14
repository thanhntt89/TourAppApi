import sys
import hmac
import hashlib
import time
import os
import requests

sys.stdout.reconfigure(encoding='utf-8')

# ── CẤU HÌNH ──────────────────────────────────────────────────────────────────
BASE_URL   = "https://hagiang.caremycars.com/wp-json/toursapp/v1"
APP_SECRET = "2f6b81669fad791f5c4bec3d5ca62d78f1905281b897ebd9f9428d8e2385bb47"
DEVICE_UUID = "TEST-HMAC-BOT-0001"


def generate_signature(method: str, path: str, body: str = "") -> dict:
    """Tạo HMAC signature đúng chuẩn Backend PHP."""
    timestamp = str(int(time.time()))
    nonce     = os.urandom(8).hex()                # 16 ký tự hex ngẫu nhiên

    body_hash      = hashlib.sha256(body.encode()).hexdigest()
    string_to_sign = "\n".join([method.upper(), path, timestamp, nonce, body_hash])
    signature      = hmac.new(
        APP_SECRET.encode(),
        string_to_sign.encode(),
        hashlib.sha256
    ).hexdigest()

    return {
        "X-Signature":  signature,
        "X-Timestamp":  timestamp,
        "X-Nonce":      nonce,
        "X-Device-UUID": DEVICE_UUID,
        "Accept":       "application/json",
        "Content-Type": "application/json",
    }


def test(label: str, method: str, url: str, api_path: str, headers: dict = None, json_body=None, data=None):
    """Gửi request và in kết quả."""
    try:
        resp = requests.request(method, url, headers=headers, json=json_body, data=data, timeout=10)
        icon = "✅" if resp.status_code < 400 else "❌"
        print(f"  {icon} [{resp.status_code}] {label}")
        if resp.status_code >= 400:
            try:
                err = resp.json()
                print(f"       → {err.get('error', {}).get('code', '')} | {err.get('error', {}).get('message', '')}")
            except Exception:
                print(f"       → {resp.text[:100]}")
    except Exception as e:
        print(f"  💥 [ERROR] {label}: {e}")


# ══════════════════════════════════════════════════════════════════════════════
print("=" * 60)
print("HMAC SIGNATURE TEST — ToursApp API")
print("=" * 60)

# ── CASE 1: Không có header nào ──────────────────────────────────────────────
print("\n[CASE 1] Gọi không có X-Signature (expect 401 SIGNATURE_MISSING):")
test(
    label    = "GET /provinces (no headers)",
    method   = "GET",
    url      = f"{BASE_URL}/provinces",
    api_path = "/toursapp/v1/provinces",
    headers  = {"Accept": "application/json"},
)

# ── CASE 2: Có UUID nhưng không có Signature ─────────────────────────────────
print("\n[CASE 2] Có UUID nhưng thiếu Signature (expect 401 SIGNATURE_MISSING):")
test(
    label    = "GET /provinces (UUID only, no signature)",
    method   = "GET",
    url      = f"{BASE_URL}/provinces",
    api_path = "/toursapp/v1/provinces",
    headers  = {"Accept": "application/json", "X-Device-UUID": DEVICE_UUID},
)

# ── CASE 3: Signature sai (tampered) ─────────────────────────────────────────
print("\n[CASE 3] X-Signature sai (expect 401 SIGNATURE_INVALID):")
bad_headers = generate_signature("GET", "/toursapp/v1/provinces")
bad_headers["X-Signature"] = "a" * 64   # chữ ký giả
test(
    label    = "GET /provinces (bad signature)",
    method   = "GET",
    url      = f"{BASE_URL}/provinces",
    api_path = "/toursapp/v1/provinces",
    headers  = bad_headers,
)

# ── CASE 4: Nonce bị reuse ────────────────────────────────────────────────────
print("\n[CASE 4] Dùng lại cùng Nonce 2 lần (expect 401 NONCE_REUSED):")
headers_once = generate_signature("GET", "/toursapp/v1/provinces")
# Lần 1
test("GET /provinces (nonce lần 1 — should pass)", "GET",
     f"{BASE_URL}/provinces", "/toursapp/v1/provinces", headers_once)
# Lần 2 cùng nonce
test("GET /provinces (nonce lần 2 — should fail)", "GET",
     f"{BASE_URL}/provinces", "/toursapp/v1/provinces", headers_once)

# ── CASE 5: Timestamp quá cũ (> 5 phút) ──────────────────────────────────────
print("\n[CASE 5] Timestamp cũ hơn 5 phút (expect 401 SIGNATURE_EXPIRED):")
old_ts    = str(int(time.time()) - 400)    # 400s trước
old_nonce = os.urandom(8).hex()
body_hash = hashlib.sha256(b"").hexdigest()
sts = "\n".join(["GET", "/toursapp/v1/provinces", old_ts, old_nonce, body_hash])
old_sig = hmac.new(APP_SECRET.encode(), sts.encode(), hashlib.sha256).hexdigest()
test(
    label    = "GET /provinces (old timestamp)",
    method   = "GET",
    url      = f"{BASE_URL}/provinces",
    api_path = "/toursapp/v1/provinces",
    headers  = {
        "Accept":        "application/json",
        "X-Signature":   old_sig,
        "X-Timestamp":   old_ts,
        "X-Nonce":       old_nonce,
        "X-Device-UUID": DEVICE_UUID,
    },
)

# ── CASE 6: Request hợp lệ hoàn toàn ─────────────────────────────────────────
print("\n[CASE 6] Request hợp lệ với HMAC đúng (expect 200 OK):")
api_path = "/toursapp/v1/provinces"
valid_headers = generate_signature("GET", api_path)
test("GET /provinces (valid HMAC)", "GET", f"{BASE_URL}/provinces", api_path, valid_headers)

# ── CASE 7: POST với body ─────────────────────────────────────────────────────
print("\n[CASE 7] POST /device/register với HMAC đúng (expect 200/201):")
import json
body_obj  = {"device_uuid": DEVICE_UUID, "platform": "android", "model": "TestDevice"}
body_str  = json.dumps(body_obj, separators=(',', ':'))
api_path  = "/toursapp/v1/device/register"
post_hdrs = generate_signature("POST", api_path, body=body_str)
test("POST /device/register (valid HMAC + body)", "POST",
     f"{BASE_URL}/device/register", api_path, post_hdrs, data=body_str.encode('utf-8'))

print("\n" + "=" * 60)
print("DONE")
print("=" * 60)
