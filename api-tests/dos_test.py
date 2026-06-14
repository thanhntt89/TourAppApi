import sys
import requests
import concurrent.futures
import time
import threading

sys.stdout.reconfigure(encoding='utf-8')

# ── CẤU HÌNH BÀI TEST ──────────────────────────────────────────────────────────
TARGET_URL = "https://hagiang.caremycars.com/wp-json/toursapp/v1/sync/package/144"

# Cấu hình các Giai đoạn (Phases): (RPS: số request/giây, DURATION: thời gian chạy)
PHASES = [
    {"rps": 5,   "duration": 5},   # Giai đoạn 1: Khởi động cực nhẹ 5 req/s trong 5 giây
    {"rps": 10,  "duration": 10},  # Giai đoạn 2: Tăng lên 10 req/s trong 10 giây
    {"rps": 30,  "duration": 10},  # Giai đoạn 3: Bắn dồn dập 30 req/s
    {"rps": 80,  "duration": 10},  # Giai đoạn 4: Bắn phá mãnh liệt 80 req/s
    {"rps": 150, "duration": 10},  # Giai đoạn 5: DDoS cực đại 150 req/s
]

HEADERS = {
    "Accept": "application/json",
    "X-Device-UUID": "DOS-TEST-RAMP-UP"
}

# ── Biến đếm (Counters) ──
status_codes = {}
lock = threading.Lock()
requests_sent = 0

def send_request():
    try:
        response = requests.get(TARGET_URL, headers=HEADERS, timeout=5)
        code = response.status_code
    except Exception:
        code = "TIMEOUT/ERROR"

    with lock:
        status_codes[code] = status_codes.get(code, 0) + 1

def run_stress_test():
    global requests_sent
    print(f"🚀 BẮT ĐẦU BÀI TEST TĂNG DẦN LỰC BẮN (RAMP-UP DOS TEST)")
    print(f"🎯 Mục tiêu: {TARGET_URL}\n")

    start_time = time.time()

    with concurrent.futures.ThreadPoolExecutor(max_workers=200) as executor:
        for phase_idx, phase in enumerate(PHASES, 1):
            rps = phase["rps"]
            duration = phase["duration"]
            interval = 1.0 / rps
            
            print(f"▶️ [PHASE {phase_idx}] Chạy tốc độ: {rps} request/giây (Trong {duration} giây)")
            
            phase_end = time.time() + duration
            while time.time() < phase_end:
                # Gửi request
                executor.submit(send_request)
                requests_sent += 1
                
                # In trạng thái nhanh
                with lock:
                    cf_blocked = status_codes.get(429, 0) + status_codes.get(403, 0)
                if requests_sent % max(rps, 1) == 0:
                    print(f"   ↳ Đã gửi: {requests_sent:4d} | Bị Cloudflare chặn (429/403): {cf_blocked}")
                
                # Nghỉ để khớp với tốc độ RPS
                time.sleep(interval)
            
            print("-" * 50)

        print("Đang đợi các request cuối cùng phản hồi...\n")
        executor.shutdown(wait=True)

    total_time = time.time() - start_time
    
    print("=" * 60)
    print("📊 KẾT QUẢ TỔNG THỂ")
    print("=" * 60)
    print(f"⏱  Thời gian chạy:        {total_time:.1f} giây")
    print(f"📨 Tổng số request:        {requests_sent}")
    print("\nChi tiết HTTP Status Code nhận được:")
    for code, count in sorted(status_codes.items(), key=lambda x: str(x[0])):
        if code == 401:
            desc = "(Bị PHP HMAC từ chối - Tốt)"
        elif code in [429, 403]:
            desc = "(Cloudflare Rate Limit chặn ngang - Rất Tốt!)"
        elif code == 200:
            desc = "(Lọt qua được - Nguy hiểm)"
        else:
            desc = ""
        print(f"  HTTP {code:<13}: {count:>5} lần  {desc}")
    print("=" * 60)

if __name__ == "__main__":
    run_stress_test()
