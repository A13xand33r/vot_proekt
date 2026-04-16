import sys
import os
import pytest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "app"))
from app import app  # noqa: E402


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as c:
        yield c


def test_health(client):
    res = client.get("/health")
    assert res.status_code == 200


def test_get_tasks(client):
    res = client.get("/tasks")
    assert res.status_code == 200


def test_add_task(client):
    res = client.post("/tasks", json={"title": "Test task"})
    assert res.status_code == 201
    assert res.get_json()["title"] == "Test task"


def test_delete_task(client):
    client.post("/tasks", json={"title": "To delete"})
    res = client.delete("/tasks/1")
    assert res.status_code == 200
