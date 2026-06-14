import requests
import json
import os

BASE_URL = "https://hagiang.caremycars.com/wp-json/toursapp/v1"
PROVINCE_ID = 144  # Ha Giang

def download_and_save(endpoint, filename):
    url = f"{BASE_URL}{endpoint}"
    print(f"Fetching {url}...")
    
    # Đã thêm header UUID giả lập để Server có thể nhận diện và ghi log
    headers = {
        "Accept": "application/json",
        "X-Device-UUID": "TEST-SYNC-BOT-9999"
    }
    response = requests.get(url, headers=headers)
    
    data_to_save = {
        "status_code": response.status_code,
    }
    
    try:
        data_to_save["json"] = response.json()
    except json.JSONDecodeError:
        data_to_save["text"] = response.text

    with open(filename, "w", encoding="utf-8") as f:
        json.dump(data_to_save, f, ensure_ascii=False, indent=2)
    
    print(f"Saved to {filename} (Status: {response.status_code})")

if __name__ == "__main__":
    download_and_save(f"/sync/package/{PROVINCE_ID}", "sync_package_144.json")
    download_and_save(f"/sync/media/{PROVINCE_ID}?type=all", "sync_media_144.json")
    print("Download completed.")
