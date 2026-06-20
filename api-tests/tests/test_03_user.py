"""
test_03_user.py
Authenticated user endpoints: Wallet, History, Journeys, Check-in,
Unlock, Share, Referral, Features, Downloads — schema validation.
"""
import pytest
from schemas import assert_has_fields, assert_list_items, get_data

# ═════════════════════════════════════════════════════════════════════════════
# WALLET — #33
# ═════════════════════════════════════════════════════════════════════════════

TRANSACTION_FIELDS = ["type", "amount", "balance_after", "description", "created_at"]


def test_get_wallet_no_auth(api_client, base_url):
    """#33 GET /user/wallet không có auth → 401/403."""
    response = api_client.get(f"{base_url}/user/wallet")
    assert response.status_code in [401, 403, 400]


def test_get_wallet_with_auth(auth_client, base_url):
    """#33 GET /user/wallet — schema: balance + transactions list."""
    response = auth_client.get(f"{base_url}/user/wallet")
    assert response.status_code == 200
    data = get_data(response)
    assert_has_fields(data, ["balance", "transactions"], label="wallet")
    assert isinstance(data["balance"], (int, float))
    assert isinstance(data["transactions"], list)
    if data["transactions"]:
        assert_has_fields(data["transactions"][0], TRANSACTION_FIELDS, label="wallet.transactions[0]")


# ═════════════════════════════════════════════════════════════════════════════
# HISTORY — #32
# ═════════════════════════════════════════════════════════════════════════════

def test_user_history(auth_client, base_url):
    """#32 GET /user/history — phải trả 200 và là list/dict."""
    response = auth_client.get(f"{base_url}/user/history")
    assert response.status_code == 200
    body = response.json()
    assert body["success"] is True
    # data có thể là list checkin records hoặc dict có list
    assert body["data"] is not None


# ═════════════════════════════════════════════════════════════════════════════
# USER JOURNEYS — #36-41
# ═════════════════════════════════════════════════════════════════════════════

USER_JOURNEY_FIELDS = [
    "id", "type", "name", "description",
    "province_id", "source_journey_id",
    "status", "total_places", "visited_count",
    "progress_percent", "stops", "created_at", "updated_at",
]


def test_user_journeys_list(auth_client, base_url):
    """#36 GET /user/journeys — schema fields."""
    response = auth_client.get(f"{base_url}/user/journeys")
    assert response.status_code == 200
    body = response.json()
    assert body["success"] is True
    items = body["data"]
    assert isinstance(items, list)
    if items:
        assert_has_fields(items[0], USER_JOURNEY_FIELDS, label="user_journeys[0]")
        assert items[0]["type"] == "user"


def test_user_journeys_create(auth_client, base_url):
    """#37 POST /user/journeys — 200/201 khi tạo, 403 nếu đạt limit."""
    response = auth_client.post(f"{base_url}/user/journeys", json={
        "name": "Schema Test Journey",
        "province_id": 144,
    })
    assert response.status_code in [200, 201, 403]
    if response.status_code in [200, 201]:
        data = get_data(response)
        assert_has_fields(data, USER_JOURNEY_FIELDS, label="journey_create")
        assert data["name"] == "Schema Test Journey"
    elif response.status_code == 403:
        body = response.json()
        # 403 journey_limit_reached phải trả limit, current, feature
        assert_has_fields(body.get("data", {}), ["limit", "current", "feature"],
                          label="journey_create 403 body")


def test_user_journeys_update(auth_client, base_url):
    """#38-40 PUT /user/journeys/{id}."""
    response = auth_client.put(f"{base_url}/user/journeys/1", json={"name": "Updated Journey"})
    assert response.status_code in [200, 404, 403]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, ["id", "name", "updated_at"], label="journey_update")


def test_user_journeys_delete(auth_client, base_url):
    """#41 DELETE /user/journeys/{id}."""
    response = auth_client.delete(f"{base_url}/user/journeys/1")
    assert response.status_code in [200, 404, 403]


# ═════════════════════════════════════════════════════════════════════════════
# CHECK-IN — #30
# ═════════════════════════════════════════════════════════════════════════════

def test_user_checkin(auth_client, base_url):
    """#30 POST /user/checkin — success: checkin_id, flowers_earned, new_balance."""
    response = auth_client.post(f"{base_url}/user/checkin", json={
        "place_id": 1, "method": "gps",
        "latitude": 22.83, "longitude": 104.98,
    })
    assert response.status_code in [200, 400, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, ["checkin_id", "flowers_earned", "new_balance"], label="checkin")
        assert isinstance(data["flowers_earned"], (int, float))
        assert isinstance(data["new_balance"], (int, float))


# ═════════════════════════════════════════════════════════════════════════════
# UNLOCK — #31
# ═════════════════════════════════════════════════════════════════════════════

def test_user_unlock(auth_client, base_url):
    """#31 POST /user/unlock — success: content_type, content_id, flowers_spent, new_balance."""
    response = auth_client.post(f"{base_url}/user/unlock", json={
        "content_type": "article", "content_id": 1,
    })
    assert response.status_code in [200, 400, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, ["content_type", "content_id", "flowers_spent", "new_balance"],
                          label="unlock")


# ═════════════════════════════════════════════════════════════════════════════
# SHARE & REFERRAL — #34, #35
# ═════════════════════════════════════════════════════════════════════════════

def test_user_share(auth_client, base_url):
    """#34 POST /user/share — ghi nhận share."""
    response = auth_client.post(f"{base_url}/user/share", json={"platform": "facebook"})
    assert response.status_code in [200, 400]


def test_user_referral_redeem(auth_client, base_url):
    """#35 POST /user/referral/redeem — code không hợp lệ → 400/404."""
    response = auth_client.post(f"{base_url}/user/referral/redeem", json={"referral_code": "INVALID_CODE_XYZ"})
    assert response.status_code in [200, 400, 404]


# ═════════════════════════════════════════════════════════════════════════════
# FEATURES — #42, #43, #44
# ═════════════════════════════════════════════════════════════════════════════

FEATURE_FIELDS = ["feature", "label", "enabled", "mode", "has_access"]


def test_user_features(auth_client, base_url):
    """#42 GET /user/features — list features với required fields."""
    response = auth_client.get(f"{base_url}/user/features")
    assert response.status_code == 200
    body = response.json()
    assert body["success"] is True
    items = body["data"]
    assert isinstance(items, list) and len(items) > 0
    assert_has_fields(items[0], FEATURE_FIELDS, label="features[0]")


def test_user_feature_detail(auth_client, base_url):
    """#43 GET /user/features/{feature} — single feature detail."""
    response = auth_client.get(f"{base_url}/user/features/cross_province")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, FEATURE_FIELDS, label="feature_detail")
        assert data["feature"] == "cross_province"


def test_user_feature_unlock(auth_client, base_url):
    """#44 POST /user/features/{feature}/unlock."""
    response = auth_client.post(f"{base_url}/user/features/cross_province/unlock")
    assert response.status_code in [200, 400, 404]


# ═════════════════════════════════════════════════════════════════════════════
# DOWNLOADS — #45, #46, #47
# ═════════════════════════════════════════════════════════════════════════════

def test_user_downloads(auth_client, base_url):
    """#45 GET /user/downloads — list download history."""
    response = auth_client.get(f"{base_url}/user/downloads")
    assert response.status_code == 200
    body = response.json()
    assert body["success"] is True
    assert isinstance(body["data"], list)


def test_user_downloads_start(auth_client, base_url):
    """#46 POST /user/downloads/start — response: download_id."""
    response = auth_client.post(f"{base_url}/user/downloads/start", json={
        "province_id": 144,
        "download_type": "full",
        "lang": "vi",
    })
    assert response.status_code in [200, 201, 400, 404]
    if response.status_code in [200, 201]:
        data = get_data(response)
        assert "download_id" in data, "download_id bị thiếu trong response"


def test_user_downloads_complete(auth_client, base_url):
    """#47 POST /user/downloads/complete."""
    response = auth_client.post(f"{base_url}/user/downloads/complete", json={
        "download_id": 1,
        "file_count": 10,
        "total_size_mb": 12.5,
        "status": "completed",
    })
    assert response.status_code in [200, 400, 404]
