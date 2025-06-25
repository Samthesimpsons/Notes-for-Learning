# 🧠 FastAPI Server Stack – Uvicorn vs Gunicorn

## 🚀 What is FastAPI?

* **FastAPI** is a modern Python web framework for building APIs.
* Based on **ASGI (Asynchronous Server Gateway Interface)** — supports async/await, WebSockets, and background tasks.
* Unlike Flask/Django, it’s designed for **high-performance async workloads**.

---

## 🔌 WSGI vs ASGI — The Core Difference

| Feature                | WSGI                         | ASGI                                      |
| ---------------------- | ---------------------------- | ----------------------------------------- |
| Full Name              | Web Server Gateway Interface | Asynchronous Server Gateway Interface     |
| Sync/Async             | Only synchronous             | Supports both sync and async              |
| WebSockets             | ❌ Not supported              | ✅ Supported                               |
| Long-lived connections | ❌ Not suitable               | ✅ Supported                               |
| Frameworks             | Django, Flask                | FastAPI, Starlette, Django (via Channels) |
| Server Examples        | Gunicorn (default), uWSGI    | Uvicorn, Daphne                           |

**In short**:

* **WSGI**: older, blocking, sync-only – great for traditional web apps.
* **ASGI**: modern, async-first – ideal for real-time, high-concurrency systems like FastAPI.

---

## ⚙️ Uvicorn — ASGI Server

### ✅ Key Features:

* Native **ASGI server**, built for async Python.
* Fast and lightweight: uses `uvloop` (fast event loop) and `httptools`.
* Hot-reload (`--reload`) support for development.
* Minimal configuration; plug-and-play with FastAPI.

### 🛠 Use Cases:

* Ideal for **local development** and **small production deployments**.
* Handles **async I/O** and **WebSocket** connections natively.

### ▶️ Example:

```bash
uvicorn main:app --reload  # Dev mode
uvicorn main:app --workers 4 --host 0.0.0.0 --port 8000  # Basic prod
```

---

## 🧱 Gunicorn — WSGI Server (with ASGI Worker Option)

### ✅ Key Features:

* Traditional WSGI HTTP server (used in Flask/Django apps).
* **Can run FastAPI** via `UvicornWorker` (an ASGI-compatible worker).
* Implements **pre-fork worker model**: master process forks multiple worker processes.
* Great for **multi-core scaling**, with extensive tuning options (timeout, logging, etc).

### 🔄 With FastAPI:

Gunicorn alone can't run FastAPI (ASGI app) — but it works with:

```bash
gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app
```

* `-w 4`: 4 worker processes.
* `-k`: use `UvicornWorker` to run ASGI apps.

### 🛠 Use Cases:

* **Production deployments** where you want:

  * Process supervision
  * Load balancing between workers
  * Fine-grained control over server behavior
* Pairs well with **Nginx** for reverse proxy and SSL.

---

## 🧬 Daphne (Just Briefly)

* ASGI server created for Django Channels.
* Supports async, WebSockets, HTTP2.
* Less common with FastAPI than Uvicorn.

---

## 🧪 When to Use What

| Scenario                      | Server Setup                                              |
| ----------------------------- | --------------------------------------------------------- |
| Local dev                     | `uvicorn main:app --reload`                               |
| Lightweight deployment        | `uvicorn main:app --workers 2`                            |
| Production (scalable, robust) | `gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app` |
| Production with reverse proxy | Nginx → Gunicorn + UvicornWorker                          |
