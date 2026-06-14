import uuid

def test_device_register_new(api_client, base_url):
    """Test registering a brand new device."""
    new_uuid = str(uuid.uuid4())
    payload = {
        "device_uuid": new_uuid,
        "device_name": "Test Device 1",
        "platform": "ios"
    }
    
    response = api_client.post(f"{base_url}/device/register", json=payload)
    assert response.status_code == 200
    
    data = response.json()
    assert data["success"] is True
    
    # Assert response fields based on ENDPOINTS.md
    result = data["data"]
    assert "is_new" in result
    assert result["is_new"] is True
    assert "wallet_balance" in result

def test_device_register_existing(api_client, base_url, registered_device_uuid):
    """Test re-registering an existing device."""
    payload = {
        "device_uuid": registered_device_uuid,
        "device_name": "Updated Test Device"
    }
    
    response = api_client.post(f"{base_url}/device/register", json=payload)
    assert response.status_code == 200
    
    data = response.json()
    assert data["success"] is True
    
    result = data["data"]
    assert result["is_new"] is False # Should not be new
