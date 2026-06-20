"""test_01_device.py — POST /device/register"""
import uuid
from schemas import assert_has_fields, get_data

DEVICE_FIELDS = ["is_new", "wallet_balance", "referral_code"]


def test_device_register_new(api_client, base_url):
    """Đăng ký thiết bị mới — kiểm tra fields trả về."""
    new_uuid = str(uuid.uuid4())
    response = api_client.post(f"{base_url}/device/register", json={
        "device_uuid": new_uuid,
        "device_name": "Test Device Schema",
        "platform": "android",
        "app_version": "1.0.0-test",
    })
    assert response.status_code == 200
    data = get_data(response)
    assert_has_fields(data, DEVICE_FIELDS, label="device/register (new)")
    assert data["is_new"] is True
    assert isinstance(data["wallet_balance"], (int, float))
    assert isinstance(data["referral_code"], str)


def test_device_register_existing(api_client, base_url, registered_device_uuid):
    """Đăng ký lại thiết bị đã tồn tại — is_new phải là False."""
    response = api_client.post(f"{base_url}/device/register", json={
        "device_uuid": registered_device_uuid,
        "device_name": "Updated Test Device",
    })
    assert response.status_code == 200
    data = get_data(response)
    assert_has_fields(data, DEVICE_FIELDS, label="device/register (existing)")
    assert data["is_new"] is False
