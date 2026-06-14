def test_get_wallet_no_auth(api_client, base_url):
    response = api_client.get(f"{base_url}/user/wallet")
    assert response.status_code in [401, 403, 400]

def test_get_wallet_with_auth(auth_client, base_url):
    response = auth_client.get(f"{base_url}/user/wallet")
    assert response.status_code == 200

def test_user_history(auth_client, base_url):
    response = auth_client.get(f"{base_url}/user/history")
    assert response.status_code == 200

def test_user_journeys_list(auth_client, base_url):
    response = auth_client.get(f"{base_url}/user/journeys")
    assert response.status_code == 200

def test_user_journeys_create(auth_client, base_url):
    payload = {"name": "Test Journey"}
    response = auth_client.post(f"{base_url}/user/journeys", json=payload)
    assert response.status_code in [200, 201, 403] # 403 if limit reached

def test_user_journeys_update(auth_client, base_url):
    payload = {"name": "Test Journey Updated"}
    response = auth_client.put(f"{base_url}/user/journeys/1", json=payload)
    assert response.status_code in [200, 404, 403]

def test_user_journeys_delete(auth_client, base_url):
    response = auth_client.delete(f"{base_url}/user/journeys/1")
    assert response.status_code in [200, 404, 403]

def test_user_checkin(auth_client, base_url):
    payload = {"place_id": 1, "method": "gps"}
    response = auth_client.post(f"{base_url}/user/checkin", json=payload)
    assert response.status_code in [200, 400, 404]

def test_user_unlock(auth_client, base_url):
    payload = {"content_type": "article", "content_id": 1}
    response = auth_client.post(f"{base_url}/user/unlock", json=payload)
    assert response.status_code in [200, 400, 404]

def test_user_share(auth_client, base_url):
    payload = {"platform": "facebook"}
    response = auth_client.post(f"{base_url}/user/share", json=payload)
    assert response.status_code in [200, 400]

def test_user_referral_redeem(auth_client, base_url):
    payload = {"referral_code": "INVALID_CODE"}
    response = auth_client.post(f"{base_url}/user/referral/redeem", json=payload)
    assert response.status_code in [200, 400, 404]

def test_user_features(auth_client, base_url):
    response = auth_client.get(f"{base_url}/user/features")
    assert response.status_code == 200

def test_user_feature_detail(auth_client, base_url):
    response = auth_client.get(f"{base_url}/user/features/cross_province")
    assert response.status_code in [200, 404]

def test_user_feature_unlock(auth_client, base_url):
    response = auth_client.post(f"{base_url}/user/features/cross_province/unlock")
    assert response.status_code in [200, 400, 404]

def test_user_downloads(auth_client, base_url):
    response = auth_client.get(f"{base_url}/user/downloads")
    assert response.status_code == 200

def test_user_downloads_start(auth_client, base_url):
    payload = {"province_id": 1}
    response = auth_client.post(f"{base_url}/user/downloads/start", json=payload)
    assert response.status_code in [200, 400, 404]

def test_user_downloads_complete(auth_client, base_url):
    payload = {"download_id": 1, "status": "completed"}
    response = auth_client.post(f"{base_url}/user/downloads/complete", json=payload)
    assert response.status_code in [200, 400, 404]
