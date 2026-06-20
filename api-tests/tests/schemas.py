"""
schemas.py — Shared schema validation helpers.

Each `assert_has_fields(obj, fields)` call verifies that all required keys
exist in a dict. Use this in every test that checks a response payload.
"""


def assert_has_fields(obj: dict, fields: list, label: str = ""):
    """Assert that all `fields` are present as keys in `obj`."""
    missing = [f for f in fields if f not in obj]
    assert not missing, f"[{label}] Missing fields: {missing}. Got keys: {list(obj.keys())}"


def assert_list_items(items: list, fields: list, label: str = "", min_count: int = 0):
    """Assert items is a non-empty list and every item has required fields."""
    assert isinstance(items, list), f"[{label}] Expected list, got {type(items)}"
    assert len(items) >= min_count, f"[{label}] Expected at least {min_count} items, got {len(items)}"
    for i, item in enumerate(items):
        assert_has_fields(item, fields, label=f"{label}[{i}]")


def get_data(response) -> dict:
    """Parse response JSON and return the `data` payload."""
    body = response.json()
    assert body.get("success") is True, f"API returned success=False: {body}"
    return body["data"]


def get_data_list(response) -> list:
    """Parse response JSON and return data as a list (handles both list and dict-wrapped list)."""
    body = response.json()
    assert body.get("success") is True, f"API returned success=False: {body}"
    data = body["data"]
    if isinstance(data, list):
        return data
    # Some list endpoints wrap as {"items": [...]}
    for key in ("items", "results", "places", "stories", "journeys", "locations", "provinces"):
        if key in data and isinstance(data[key], list):
            return data[key]
    return data  # let caller decide
