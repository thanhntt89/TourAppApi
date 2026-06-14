import requests
import json
import uuid

BASE_URL = "https://hagiang.caremycars.com/wp-json/toursapp/v1"

# 1. Register a test device
device_uuid = str(uuid.uuid4())
reg_resp = requests.post(f"{BASE_URL}/device/register", json={
    "device_uuid": device_uuid,
    "device_name": "Schema Verifier Bot",
    "platform": "android"
})

headers = {
    "X-Device-UUID": device_uuid,
    "Accept": "application/json"
}

endpoints_to_check = [
    ("GET", "/provinces"),
    ("GET", "/places"),
    ("GET", "/places/1"),
    ("GET", "/user/wallet"),
    ("GET", "/user/journeys")
]

results = {}

for method, path in endpoints_to_check:
    url = f"{BASE_URL}{path}"
    if method == "GET":
        resp = requests.get(url, headers=headers)
    else:
        resp = requests.post(url, headers=headers)
        
    results[path] = {
        "status_code": resp.status_code,
        "json": resp.json() if resp.status_code != 500 else resp.text
    }

with open("schema_dump.json", "w", encoding="utf-8") as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

print("Dumped schemas to schema_dump.json")
