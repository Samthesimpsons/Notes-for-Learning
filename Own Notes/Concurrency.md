### Concurrency 

Using Python as an example

---

#### 1  ·  Baseline - synchronous (blocking)

```python
import time
from langchain_community.chat_models import ChatVertexAI, ChatAnthropicVertex
from langchain_core.messages import SystemMessage, HumanMessage

def ask_gemini(temp: float):
    chat = ChatVertexAI(model_name="gemini-1.5-pro-latest", temperature=temp)
    msgs = [SystemMessage(content="You are a helpful assistant."),
            HumanMessage(content="Who is Donald Trump?")]
    return chat.invoke(msgs).content

def ask_claude(temp: float):
    chat = ChatAnthropicVertex(model_name="claude-3-sonnet-20240229", temperature=temp)
    msgs = [SystemMessage(content="You are a helpful assistant."),
            HumanMessage(content="Who is Donald Trump?")]
    return chat.invoke(msgs).content

start = time.time()
responses = [ask_gemini(1), ask_claude(1)]
print(responses, time.time() - start)
```

*Single thread, single process, easy to reason about but waits for each request.*

---

#### 2  ·  Multithreading (I/O-bound)

```python
from concurrent.futures import ThreadPoolExecutor

with ThreadPoolExecutor(max_workers=2) as pool:
    futures = [pool.submit(ask_gemini, 1),
               pool.submit(ask_claude, 1)]
    responses = [f.result() for f in futures]
```

* Still **one** CPython process → the Global Interpreter Lock (GIL) prevents true parallel execution of *CPU-bound* Python code.
* Ideal for **I/O-bound** work (HTTP, disk, DB) because the thread that is waiting on the OS releases the GIL.
* Certainly we can scale up the number of threads/workers however this just results in higher overhead during thread switching.

---

#### 3  ·  Async I/O (single-threaded concurrency)

```python
import asyncio

async def ask_gemini_async(temp):
    chat = ChatVertexAI(model_name="gemini-1.5-pro-latest", temperature=temp)
    msgs = [...]
    return (await chat.ainvoke(msgs)).content

async def ask_claude_async(temp):
    chat = ChatAnthropicVertex(model_name="claude-3-sonnet-20240229", temperature=temp)
    msgs = [...]
    return (await chat.ainvoke(msgs)).content

start = time.time()
responses = asyncio.run(asyncio.gather(
    ask_gemini_async(1), ask_claude_async(1)
))
```

* **Event loop** interleaves coroutines; no extra threads.
* Every blocking call must be replaced with an `await`-able (e.g. `aiohttp` instead of `requests`).

---

#### 4  ·  Multiprocessing (CPU-bound)

```python
from multiprocessing import Pool

if __name__ == "__main__":           # needed on Windows
    with Pool(processes=2) as pool:  # or use ProcessPoolExecutor
        f1 = pool.apply_async(ask_gemini, (1,))
        f2 = pool.apply_async(ask_claude, (1,))
        responses = [f1.get(), f2.get()]
```

* **Separate interpreter per process** → each bypasses the GIL and can run on its own CPU core.
* Good for CPU-heavy tasks (ML inference, image processing, heavy data transforms).
* Higher cost: inter-process communication (IPC) and duplicated memory; share large read-only data via `multiprocessing.shared_memory`.
* Creating *more* processes than cores is allowed but often brings diminishing returns.

---

### Choosing the right tool

| Scenario                           | Best fit                                    | Why                                             |
| ---------------------------------- | ------------------------------------------- | ----------------------------------------------- |
| Many web/API calls, negligible CPU | `asyncio` or **ThreadPoolExecutor**         | I/O waits dominate, minimal context-switch cost |
| Moderate I/O + Python callbacks    | **ThreadPoolExecutor**                      | Simpler to retrofit than full async             |
| CPU-bound computation              | **multiprocessing** / `ProcessPoolExecutor` | True parallelism                                |
| Small script, low concurrency      | plain **sync**                              | Easiest to read & debug                         |

*Rule of thumb:* **I/O-bound ⇒ async/threading; CPU-bound ⇒ multiprocessing.**
Measure with `time.perf_counter()` or `asyncio.get_running_loop().time()` to prove the speed-up-assumptions about concurrency often surprise.

---

#### Extra tips

* `concurrent.futures.ProcessPoolExecutor` gives the same API as threads with automatic process management.
* For more ergonomic async **HTTP**, use `aiohttp`; for DBs use libraries that expose async drivers (e.g. `asyncpg`).
* If you only need parallel *native* code (NumPy, TensorFlow, PyTorch), those libraries often release the GIL internally-threads can already scale.
* Consider higher-level frameworks (`anyio`, `trio`, `ray`, `dask`) when your concurrency story grows complex.
