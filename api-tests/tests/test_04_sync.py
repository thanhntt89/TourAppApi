"""
test_04_sync.py
Sync endpoints: /sync/check, /sync/package, /sync/media
Schema validation theo ENDPOINTS.md.
"""
import pytest
from schemas import assert_has_fields, get_data

PROVINCE_ID = 144
SINCE = "2020-01-01T00:00:00Z"

# ═════════════════════════════════════════════════════════════════════════════
# SYNC CHECK — #48 (Public)
# ═════════════════════════════════════════════════════════════════════════════

SYNC_CHECK_FIELDS = ["has_updates", "last_modified", "changes", "estimated_download_size_mb"]
SYNC_CHECK_CHANGE_FIELDS = ["provinces", "locations", "places", "sub_places", "sub_items", "journeys", "news"]


def test_sync_check_no_auth(api_client, base_url):
    """#48 GET /sync/check — public endpoint, không cần auth."""
    response = api_client.get(f"{base_url}/sync/check", params={
        "province_id": PROVINCE_ID, "since": SINCE,
    })
    assert response.status_code in [200, 404]


def test_sync_check_with_auth(auth_client, base_url):
    """#48 GET /sync/check — với auth, validate full schema."""
    response = auth_client.get(f"{base_url}/sync/check", params={
        "province_id": PROVINCE_ID, "since": SINCE,
    })
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, SYNC_CHECK_FIELDS, label="sync_check")
        assert isinstance(data["has_updates"], bool)
        assert_has_fields(data["changes"], SYNC_CHECK_CHANGE_FIELDS, label="sync_check.changes")


# ═════════════════════════════════════════════════════════════════════════════
# SYNC PACKAGE — #49 (🔒 Device UUID required)
# ═════════════════════════════════════════════════════════════════════════════

SYNC_PACKAGE_FIELDS = [
    "province", "locations", "places", "sub_places", "sub_items",
    "journeys", "news", "media_manifest", "sync_version", "total_media_size_mb",
]


def test_sync_package_no_auth(api_client, base_url):
    """#49 GET /sync/package/{province_id} — không auth → 401."""
    response = api_client.get(f"{base_url}/sync/package/{PROVINCE_ID}")
    assert response.status_code == 401


def test_sync_package_with_auth(auth_client, base_url):
    """#49 GET /sync/package/{province_id} — validate top-level sections."""
    response = auth_client.get(f"{base_url}/sync/package/{PROVINCE_ID}")
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, SYNC_PACKAGE_FIELDS, label="sync_package")
        assert isinstance(data["locations"], list)
        assert isinstance(data["places"], list)
        assert isinstance(data["sub_places"], list)
        assert isinstance(data["sub_items"], list)
        assert isinstance(data["media_manifest"], list)


# ═════════════════════════════════════════════════════════════════════════════
# SYNC MEDIA — #50 (🔒 Device UUID required)
# ═════════════════════════════════════════════════════════════════════════════

# NOTE: API thực tế dùng 'related_to' (object) thay vì 'related_type' + 'related_id' riêng lẻ
MEDIA_FILE_FIELDS = ["id", "type", "url", "size_bytes", "checksum", "related_to"]


def test_sync_media_no_auth(api_client, base_url):
    """#50 GET /sync/media/{province_id} — không auth → 401."""
    response = api_client.get(f"{base_url}/sync/media/{PROVINCE_ID}", params={"type": "all"})
    assert response.status_code == 401


def test_sync_media_with_auth(auth_client, base_url):
    """#50 GET /sync/media/{province_id} — validate files schema."""
    response = auth_client.get(f"{base_url}/sync/media/{PROVINCE_ID}", params={"type": "all"})
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        assert_has_fields(data, ["files", "summary"], label="sync_media")
        assert isinstance(data["files"], list)
        # summary object chứa total_files và total_size_mb
        assert_has_fields(data["summary"], ["total_files", "total_size_mb"], label="sync_media.summary")
        assert isinstance(data["summary"]["total_files"], int)
        if data["files"]:
            assert_has_fields(data["files"][0], MEDIA_FILE_FIELDS, label="sync_media.files[0]")


def test_sync_media_images_only(auth_client, base_url):
    """#50 GET /sync/media — filter type=images."""
    response = auth_client.get(f"{base_url}/sync/media/{PROVINCE_ID}", params={"type": "images"})
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        # Tất cả files phải là image
        for f in data.get("files", []):
            assert f["type"] == "image", f"Expected type=image, got {f['type']}"


def test_sync_media_audio_only(auth_client, base_url):
    """#50 GET /sync/media — filter type=audio."""
    response = auth_client.get(f"{base_url}/sync/media/{PROVINCE_ID}", params={"type": "audio"})
    assert response.status_code in [200, 404]
    if response.status_code == 200:
        data = get_data(response)
        for f in data.get("files", []):
            assert f["type"] == "audio", f"Expected type=audio, got {f['type']}"
