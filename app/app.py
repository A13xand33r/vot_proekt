from flask import Flask, jsonify, request
import logging
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app)
logging.basicConfig(level=logging.INFO)

metrics.info("app_info", "DevOps Todo App", version="1.0.0")

tasks = []


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"})


@app.route("/tasks", methods=["GET"])
def get_tasks():
    app.logger.info("GET /tasks called")
    return jsonify(tasks)


@app.route("/tasks", methods=["POST"])
def add_task():
    data = request.get_json() or {}
    task = {"id": len(tasks) + 1, "title": data.get("title", ""), "done": False}
    tasks.append(task)
    app.logger.info(f"Task added: {task}")
    return jsonify(task), 201


@app.route("/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    global tasks
    tasks = [t for t in tasks if t["id"] != task_id]
    return jsonify({"deleted": task_id})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
