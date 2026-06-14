import os
import pytest
import requests
from dotenv import load_dotenv

load_dotenv()

BASE_URL = os.getenv("BASE_URL", "https://hagiang.caremycars.com/wp-json/toursapp/v1")

@pytest.fixture(scope="session")
def api_client():
    """
    Returns a configured requests.Session with JSON headers.
    """
    session = requests.Session()
    session.headers.update({
        "Accept": "application/json",
        "Content-Type": "application/json"
    })
    return session

@pytest.fixture(scope="session")
def base_url():
    """Returns the base URL for the API."""
    return BASE_URL

@pytest.fixture(scope="session")
def registered_device_uuid(api_client, base_url):
    """
    Registers a new test device and returns its UUID.
    This fixture ensures we have a valid X-Device-UUID for authenticated endpoints.
    """
    import uuid
    new_uuid = str(uuid.uuid4())
    
    payload = {
        "device_uuid": new_uuid,
        "device_name": "Pytest Automation Bot",
        "platform": "android",
        "app_version": "1.0.0-test"
    }
    
    response = api_client.post(f"{base_url}/device/register", json=payload)
    assert response.status_code == 200, f"Failed to register device: {response.text}"
    
    data = response.json()
    assert data.get("success") is True
    
    return new_uuid

@pytest.fixture(scope="session")
def auth_client(api_client, registered_device_uuid):
    """
    Returns an API client pre-configured with the X-Device-UUID header.
    """
    # Create a new session to avoid mutating the global api_client
    session = requests.Session()
    session.headers.update(api_client.headers)
    session.headers.update({
        "X-Device-UUID": registered_device_uuid
    })
    return session
