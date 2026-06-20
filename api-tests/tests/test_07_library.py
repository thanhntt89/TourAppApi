"""
test_07_library.py
Library, Favorites, Offline Sync, Passport — new endpoints
#36-related (user/library, user/favorites, user/offline/sync, user/passport)
Schema validation theo ENDPOINTS.md + class-ta-ep-library.php
"""
import pytest
from schemas import assert_has_fields, get_data

# ═════════════════════════════════════════════════════════════════════════════
# LIBRARY — GET /user/library
# ═════════════════════════════════════════════════════════════════════════════

LIBRARY_FIELDS = [
    "resume_items", "favourite_places",
    "favourite_stories", "offline_counts", "recent_activity",
]

FAVE_PLACE_FIELDS = ["id", "name", "feature_image", "lat", "lng", "saved_at"]

FAVE_STORY_FIELDS = [
    "id", "name", "feature_image",
    "completion_pct", "is_offline", "status", "saved_at",
]


def test_user_library_no_auth(api_client, base_url):
    """GET /user/library — không auth → 401."""
    response = api_client.get(f"{base_url}/user/library")
    assert response.status_code in [401, 403]


def test_user_library_with_auth(auth_client, base_url):
    """GET /user/library — schema: 5 required sections."""
    response = auth_client.get(f"{base_url}/user/library")
    assert response.status_code == 200
    data = get_data(response)
    assert_has_fields(data, LIBRARY_FIELDS, label="user_library")

    assert isinstance(data["resume_items"], list)
    assert isinstance(data["favourite_places"], list)
    assert isinstance(data["favourite_stories"], list)
    assert isinstance(data["offline_counts"], dict)
    assert isinstance(data["recent_activity"], list)

    # Validate nested objects nếu có data
    if data["favourite_places"]:
        assert_has_fields(data["favourite_places"][0], FAVE_PLACE_FIELDS, label="library.favourite_places[0]")

    if data["favourite_stories"]:
        assert_has_fields(data["favourite_stories"][0], FAVE_STORY_FIELDS, label="library.favourite_stories[0]")
        assert data["favourite_stories"][0]["status"] in ["saved", "in_progress", "downloaded"]


# ═════════════════════════════════════════════════════════════════════════════
# FAVORITES — POST + DELETE /user/favorites
# ═════════════════════════════════════════════════════════════════════════════

def test_favorites_no_auth(api_client, base_url):
    """POST /user/favorites — không auth → 401."""
    response = api_client.post(f"{base_url}/user/favorites", json={
        "content_type": "place", "content_id": 1,
    })
    assert response.status_code in [401, 403]


def test_favorites_add_place(auth_client, base_url):
    """POST /user/favorites — thêm place vào favorites."""
    response = auth_client.post(f"{base_url}/user/favorites", json={
        "content_type": "place", "content_id": 1,
    })
    assert response.status_code in [200, 201, 404]
    if response.status_code in [200, 201]:
        data = get_data(response)
        assert "favorited" in data
        assert data["favorited"] is True


def test_favorites_add_story(auth_client, base_url):
    """POST /user/favorites — thêm story vào favorites."""
    response = auth_client.post(f"{base_url}/user/favorites", json={
        "content_type": "ta_story", "content_id": 1,
    })
    assert response.status_code in [200, 201, 404]


def test_favorites_add_invalid_type(auth_client, base_url):
    """POST /user/favorites — content_type không hợp lệ → 400."""
    response = auth_client.post(f"{base_url}/user/favorites", json={
        "content_type": "invalid_type", "content_id": 1,
    })
    assert response.status_code in [400, 422]


def test_favorites_remove_place(auth_client, base_url):
    """DELETE /user/favorites/{type}/{id}."""
    response = auth_client.delete(f"{base_url}/user/favorites/place/1")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert "removed" in data
        assert data["removed"] is True


def test_favorites_remove_invalid_type(auth_client, base_url):
    """DELETE /user/favorites/{type}/{id} — type không hợp lệ → 400."""
    response = auth_client.delete(f"{base_url}/user/favorites/bad_type/1")
    assert response.status_code in [400, 422]


# ═════════════════════════════════════════════════════════════════════════════
# OFFLINE SYNC — POST /user/offline/sync
# ═════════════════════════════════════════════════════════════════════════════

def test_offline_sync_no_auth(api_client, base_url):
    """POST /user/offline/sync — không auth → 401."""
    response = api_client.post(f"{base_url}/user/offline/sync", json={"items": []})
    assert response.status_code in [401, 403]


def test_offline_sync_empty(auth_client, base_url):
    """POST /user/offline/sync — items rỗng → OK."""
    response = auth_client.post(f"{base_url}/user/offline/sync", json={"items": []})
    assert response.status_code == 200
    data = get_data(response)
    assert "synced" in data
    assert data["synced"] is True
    assert "counts" in data


def test_offline_sync_with_items(auth_client, base_url):
    """POST /user/offline/sync — gửi danh sách items đã tải."""
    items = [
        {"content_type": "place", "content_id": 1},
        {"content_type": "ta_story", "content_id": 1},
    ]
    response = auth_client.post(f"{base_url}/user/offline/sync", json={"items": items})
    assert response.status_code == 200
    data = get_data(response)
    assert_has_fields(data, ["synced", "counts"], label="offline_sync")


def test_offline_sync_too_many_items(auth_client, base_url):
    """POST /user/offline/sync — quá 500 items → 400."""
    items = [{"content_type": "place", "content_id": i} for i in range(501)]
    response = auth_client.post(f"{base_url}/user/offline/sync", json={"items": items})
    assert response.status_code == 400, "501 items phải bị reject với 400"


# ═════════════════════════════════════════════════════════════════════════════
# PASSPORT — GET /user/passport/{journey_id}
# ═════════════════════════════════════════════════════════════════════════════

def test_user_passport_no_auth(api_client, base_url):
    """GET /user/passport/{journey_id} — không auth → 401."""
    response = api_client.get(f"{base_url}/user/passport/1")
    assert response.status_code in [401, 403]


def test_user_passport_with_auth(auth_client, base_url):
    """GET /user/passport/{journey_id} — trả về passport data."""
    response = auth_client.get(f"{base_url}/user/passport/1")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        body = response.json()
        assert body["success"] is True
        assert body["data"] is not None
