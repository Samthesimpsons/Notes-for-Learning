# 1. Computer Architecture

Before diving into system design, it is critical to understand the **building blocks of a computer**, their **roles**, and **implications for system performance**.

## Components

### **Disk (Persistent Storage)**
* Primary, persistent storage (data persists across power cycles).
* Measured in **TB (10¹² bytes)**; smaller devices may use **GB (10⁹ bytes)**.
* **HDD (Hard Disk Drive):**
  * Mechanical, with read/write heads.
  * Slows down over time due to wear.
* **SSD (Solid-State Drive):**
  * No moving parts, faster, more expensive.
  * Writes and reads data electronically (similar to RAM).

### **RAM (Random Access Memory)**
* Volatile, temporary storage for **currently running applications and variables**.
* Faster but more expensive than disk.
* Size: typically **1GB–128GB**.
* Speed:
  * Writing 1MB to RAM: microseconds (10⁻⁶ s).
  * Writing 1MB to Disk: milliseconds (10⁻³ s).
* Requires CPU to transfer data to/from disk.
* Data lost when power is off.

### **CPU (Central Processing Unit)**
* Intermediary between **RAM and Disk**; executes computations.
* Executes instructions stored in RAM:
  * Fetch → Decode → Execute cycle.
* Performs arithmetic and logic operations.
* Reads/writes data between RAM and Disk during execution.
* Contains **Cache (fast memory on CPU die).**

### **Cache**
* Faster than RAM, but smaller (**KBs to tens of MBs**).
* Types: **L1, L2, L3**.
* **Read hierarchy:** Cache → RAM → Disk.
* Managed by OS for frequently accessed data.
* Cache uses **SRAM**, RAM uses **DRAM**.
* Used in other systems (e.g., browser caching).

## Moore’s Law
* Transistor count **doubles every \~2 years**.
* Implies **computing power increases, cost decreases**.
* Plateauing due to physical limits.

## Visual Hierarchy Recap
```
[CPU]
  ↳ [L1/L2/L3 Cache (fast, small)]
  ↳ [RAM (fast, larger, volatile)]
  ↳ [Disk (slowest, persistent, large)]
```

## Relevance for AI System Design
* Optimize **model serving pipelines** using memory hierarchies and latency awareness.
* Disk vs. RAM speed informs **batching and caching** strategies.
* CPU and cache limitations guide **CPU vs. GPU inference choices**.

# 2. Application Architecture

## Basic Interaction Model

### Developer’s Perspective
* Code is deployed to a **server**.
* Requires persistent storage (DB/cloud) accessible via the network.

### User’s Perspective
* Users interact via **web browsers (clients)**.
* Server responds with **HTML/CSS/JS**.
* Bottlenecks in **RAM, CPU, network** under load → requires scaling.

## Scaling Strategies

### **Vertical Scaling**
* Upgrade **RAM/CPU** on a single server.
* Simple for small apps, but hardware-constrained.

### **Horizontal Scaling**
* Add **multiple servers** to handle requests in parallel.
* Distributes load, adds **fault tolerance**, but requires:
  * Inter-server communication.
  * Consistency management.

## Load Balancer
* Distributes requests across servers.
* Ensures **speed, reliability, and failover**.

## External Interactions
* Servers interact with **external APIs** (e.g., Stripe for payments).

## Logging and Metrics

### Logging
* Logs **requests, errors, diagnostics**.
* Best practice: external log storage.

### Metrics
* Track CPU, RAM, network usage.
* Detect bottlenecks.

## Alerts
* Automatic notifications when metrics cross thresholds.
* Example: Trigger alert if success rate < 95%.

## Relevance for AI System Design
* Horizontal scaling and load balancing for **scalable inference services**.
* Logging/metrics for **monitoring latency, errors, and resource utilization**.
* API knowledge for **data pipelines and third-party ML services**.
* Alerting for **real-time anomaly detection**.

# 3. Thinking in System Design

## Moving Data
* From local (disk ↔ RAM ↔ CPU) to **global client-server networks**.
* Challenges: latency, reliability, protocol efficiency.

## Storing Data
* Choosing **where and how** to store data: DBs, blob stores, file systems.
* Choice depends on access patterns, consistency, scalability.

## Transforming Data
* Adds value via processing (e.g., filtering, aggregation).
* Requires **efficiency and scalability**.
* Bad design choices (e.g., wrong DB) are costly compared to poor algorithm swaps.

# 4. What Is Good Design?

## Key Metrics

### **Availability**
* % time system is operational:
  * 99% = \~3.65 days downtime/year.
  * 99.9% = \~8.76 hours.
  * 99.999% = \~5 minutes.
* SLAs (contracts) vs. SLOs (internal goals).

### **Reliability, Fault Tolerance, Redundancy**
* **Reliability:** Performs without errors over time.
* **Fault Tolerance:** Detects, isolates, and recovers from failures.
* **Redundancy:** Backups and active-active systems for failover.

### **Throughput**
* Work handled per unit time:
  * Requests/sec, queries/sec, bytes/sec.
* Scaled via vertical or horizontal strategies.

### **Latency**
* Delay between request and response.
* Independent of throughput:
  * Throughput: How much per unit time.
  * Latency: How long per request.

## Relevance for AI System Design
* Core in **model pipelines and serving systems**.
* Availability and fault tolerance ensure **robust AI services**.
* Throughput and latency awareness optimize **batch vs. real-time inference**.
* Prevents **costly migrations and downtime** in infrastructure.

# 5. Networking Basics

## What is a Network?
* Connects devices for **data exchange**, each with an IP address.

## IP Addresses
* Unique numeric identifiers.
* **IPv4 (32-bit):** 4.3 billion addresses, scarce.
* **IPv6 (128-bit):** Virtually infinite.

## Protocols for Data Transmission

### Data Packets
* Header (source/destination), payload, trailer.

### IP (Internet Protocol)
* Routes packets.

### TCP (Transmission Control Protocol)
* Ensures **accurate, in-order delivery**.

## Application Data
* Payload contains application data (e.g., HTTP).

## Network Layers
* **Application (HTTP)** → **Transport (TCP)** → **Network (IP)**.

## Public vs Private Networks
* **Public IP:** Globally unique, internet-accessible.
* **Private IP:** Local networks, not internet-accessible.

## Static vs Dynamic IP Addresses
* **Static:** Fixed, common for servers.
* **Dynamic:** Changes on reconnect, used in home networks.

## Ports
* Numeric identifiers (0–65535) for services:
  * 80: HTTP
  * 443: HTTPS
  * 4200: Angular default

## Relevance for AI System Design

* Critical for **REST/gRPC ML serving**, **latency analysis**, **public/private network management**, **pipeline debugging**.

# 6. TCP and UDP

## TCP (Transmission Control Protocol)
* Connection-oriented (3-way handshake).
* Reliable:
  * Ensures packet delivery and order.
* Acknowledgements with retransmission.
* Used in **HTTP, HTTPS, email**.

## UDP (User Datagram Protocol)
* Connectionless.
* Unreliable (no guarantee of delivery/order).
* Lower overhead, faster.
* Used in **gaming, streaming, VoIP, DNS**.

## Comparison
| Feature     | TCP                         | UDP                    |
| ----------- | --------------------------- | ---------------------- |
| Connection  | Connection-oriented         | Connectionless         |
| Reliability | Reliable, ordered           | Unreliable, unordered  |
| Speed       | Slower                      | Faster                 |
| Overhead    | High                        | Low                    |
| Use Cases   | HTTP, file transfers, email | Streaming, gaming, DNS |

## Relevance for AI System Design
* TCP for **model serving via REST/gRPC**.
* UDP for **high-throughput distributed training, telemetry from edge devices**.
Continuing seamlessly in the **clean, structured, icon-free style** for your **Notion/Obsidian/Anki system design notes**:

# 7. Domain Name System (DNS)

## What is DNS?
* Translates **domain names to IP addresses**.
* Managed by **ICANN**.

## ICANN & Registrars
* ICANN manages infrastructure.
* Registrars (e.g., GoDaddy) sell/manage domains.

## DNS Records
* **A Record:** Domain to IPv4 mapping.
* Caching for speed.

## URL Anatomy
```
https://domains.google.com/get-started
```
* Protocol: `https://`
* Domain: `domains.google.com`
* Path: `/get-started`
* Port: Optional (default 80/443)

## DNS in Client-Server Communication
* Resolves domain → IP → routes request.

## Relevance for AI System Design
* Managing **API endpoints, cloud deployment, custom domains**.
* Debugging **latency during DNS resolution**.

# 8. HTTP (Hypertext Transfer Protocol)

## Client-Server Model
* Client initiates, server responds.

## RPC
* Execute remote functions over a network.

## HTTP Overview
* Sits on **TCP/IP**.
* Stateless, request-response.

## Developer Tools
* Inspect requests, status codes, headers, timing.

## HTTP Request Anatomy
* Method (`GET`, `POST`, etc.).
* URL/URI.
* Headers.
* Body (for `POST`/`PUT`).

## HTTP Methods
| Method | Description       | Idempotent |
| ------ | ----------------- | ---------- |
| GET    | Retrieve resource | Yes        |
| POST   | Create/send data  | No         |
| PUT    | Update resource   | Yes        |
| DELETE | Remove resource   | Yes        |

## HTTP Status Codes
| Category      | Range   |
| ------------- | ------- |
| Informational | 100–199 |
| Successful    | 200–299 |
| Redirection   | 300–399 |
| Client Errors | 400–499 |
| Server Errors | 500–599 |

## SSL/TLS & HTTPS
* HTTPS = HTTP + TLS encryption for security.

## Relevance for AI System Design
* Building **RESTful APIs for model serving**.
* Structuring **secure ML pipelines**.
* Debugging endpoints with developer tools.
* Using status codes for **monitoring and retry logic**.

# 9. WebSocket

## Context
* Application-level protocol for **real-time, bi-directional communication** over a **single TCP connection**.
* Addresses HTTP’s **statelessness and polling inefficiencies**.

## Why WebSocket?
* Enables **real-time updates** in:
  * Chat apps
  * Live streaming
  * Multiplayer gaming
* Avoids repeated HTTP requests for updates.

## How it Works
1. Client sends HTTP `Upgrade` request.
2. Server responds with `101 Switching Protocols`.
3. Persistent, **full-duplex connection** established.

## WebSocket vs HTTP/2
| Aspect        | WebSocket                  | HTTP/2                       |
| ------------- | -------------------------- | ---------------------------- |
| Communication | Bi-directional, persistent | Multiplexed request-response |
| Use Case      | Real-time data flow        | Parallel HTTP requests       |

## Ports
* WS: Port 80
* WSS (secure): Port 443

## Relevance for AI System Design
* Real-time **model monitoring dashboards**.
* Instant feedback loops in **active learning pipelines**.
* Streaming **real-time anomaly detection outputs**.


# 10. API Paradigms

APIs allow **clients to interact with servers** using **defined protocols**.

## REST (Representational State Transfer)
* Stateless, HTTP-based, widely used.
* Uses JSON for data payloads.
* Simple and easy to debug.
* Limitations: Over-fetching, under-fetching.

## GraphQL
* Allows **clients to specify exactly what data they need**.
* Single endpoint, flexible nested queries.
* Useful for **reducing over-fetching and under-fetching**.

## gRPC
* High-performance RPC using **protocol buffers**.
* Uses HTTP/2, supports bi-directional streaming.
* Ideal for **server-to-server communication**.

## When to Use
| Paradigm | Best Use Case                           |
| -------- | --------------------------------------- |
| REST     | Simple CRUD APIs, broad compatibility   |
| GraphQL  | Flexible data fetching, mobile apps     |
| gRPC     | High-performance internal microservices |

## Relevance for AI System Design
* REST for **model serving endpoints**.
* GraphQL for **efficient metadata or subset retrieval**.
* gRPC for **fast inter-service communication**.

# 11. API Design

## What is API Design?
Defines the **contract** for client-server interaction:
* Methods
* Input/output
* URL structure

## CRUD Operations Mapping
| CRUD   | REST Method | Example         |
| ------ | ----------- | --------------- |
| Create | POST        | `createTweet()` |
| Read   | GET         | `getTweets()`   |
| Update | PUT         | `editTweet()`   |
| Delete | DELETE      | `deleteTweet()` |

## Importance
* Prevents breaking dependent clients.
* Supports backward compatibility.
* Allows independent development.

## Backward Compatibility
* Add optional parameters instead of changing signatures.

## Example
POST `https://api.twitter.com/v1.0/tweet`

```json
{
  "userId": "string",
  "tweetId": "string",
  "content": "string",
  "createdAt": "date",
  "likes": 0
}
```

## Versioning
* Use `/v1.0/`, `/v2.0/` to manage breaking changes.

## API Keys
* Used for authentication, authorization, and rate limiting.

## Relevance for AI System Design
* Clean APIs for **model inference**.
* Pagination for **large result retrieval**.
* Versioning for **model updates**.

# 12. Caching

## What is Caching?
* Storing copies of data in **faster-access storage**.
* Reduces latency.
* Lowers repeated expensive computation or fetches.

## Why Cache?
* Faster retrieval.
* Reduced backend load.
* Improved scalability and user experience.

## Cache Lookup Order
1. Memory
2. Disk
3. Network

## Cache Hit Ratio
$$
\text{Cache Hit Ratio} = \frac{\text{# Hits}}{\text{# Hits + # Misses}} \times 100
$$

Higher is better.

## Cache Modes
| Mode          | Description                         |
| ------------- | ----------------------------------- |
| Write-Around  | Write to disk, cache on read        |
| Write-Through | Write to both cache and disk        |
| Write-Back    | Write to cache, flush to disk later |

## Eviction Policies
| Policy | Description                 |
| ------ | --------------------------- |
| FIFO   | Evict oldest                |
| LRU    | Evict least recently used   |
| LFU    | Evict least frequently used |

## Relevance for AI System Design
* Caching for **model inference and feature store retrieval**.
* Choosing **appropriate eviction policies** for workload patterns.

# 13. Content Delivery Networks (CDNs)

## What is a CDN?
* A **network of edge servers** to deliver content closer to users.
* Reduces latency.
* Offloads origin servers.
* Improves reliability.

## How it Works
* Stores **static content** on edge servers.
* On request:
  * Cache hit: served from edge.
  * Cache miss: fetched from origin, cached for future.

## CDN Types
| Type     | Description                                 |
| -------- | ------------------------------------------- |
| Push CDN | Content pushed to edge servers proactively  |
| Pull CDN | Content fetched and cached on first request |

## Benefits
* Faster load times.
* Scalability and redundancy.
* Bandwidth savings.

## Cache Control
* `public`: CDN can cache.
* `private`: CDN should not cache.

## Relevance for AI System Design
* Serving **static ML assets and model binaries globally**.
* Using **edge compute for low-latency inference**.


# 14. Proxies & Load Balancers

## Proxies

### Forward Proxy
* Hides **client identity** from the server.
* Used for **privacy, filtering, caching**.

### Reverse Proxy
* Hides **server identity** from the client.
* Enables **load balancing, DDoS protection, caching**.

## Load Balancers
* Distributes requests across multiple servers for:
  * Performance
  * Reliability
  * Scaling

### Strategies
| Strategy             | Description                                     |
| -------------------- | ----------------------------------------------- |
| Round Robin          | Sequential distribution                         |
| Weighted Round Robin | Based on server capacity weights                |
| Least Connections    | Routes to server with fewest active connections |
| User Location        | Routes to nearest server geographically         |

### Layer 4 vs Layer 7 Load Balancing - OSI (Open Systems Interconnection) model
| Layer | Description                               |
| ----- | ----------------------------------------- |
| L4    | Transport-level (IP/Port) routing, faster |
| L7    | Application-level (content-based) routing |

## Relevance for AI System Design
* Load balancing **inference requests across replicas**.
* Using Layer 7 for **routing requests by model or user tier**.
* Forward proxies for **scraping, secure outbound routing**.

Continuing seamlessly in **clean, icon-free, structured style** for your **Notion/Obsidian/Anki system design notes**:

# 15. Consistent Hashing

## What it is
* Hashing-based load balancing using a **hash ring**.
* Ensures **minimal remapping** when nodes change.

## Why Not Regular Hashing?
* Using `hash(ID) % num_servers` causes **massive remapping** when the number of servers changes.
* Consistent hashing **minimizes cache misses during scaling**.

## Use Cases
* CDNs for consistent cache routing.
* Distributed databases for sharding.
* Cache-heavy systems for **load distribution**.

# 16. SQL & NoSQL Databases

## SQL (Relational Databases)

* Structured, schema-based data.
* Uses **B+ Trees for indexing**.
* Supports **ACID** properties:
  * Atomicity
  * Consistency
  * Isolation
  * Durability

## NoSQL
* Schema-less, horizontally scalable.
* Uses **BASE** properties:
  * Basically Available
  * Soft state
  * Eventual consistency

### Types of NoSQL
| Type           | Example Systems       | Use Case                |
| -------------- | --------------------- | ----------------------- |
| Key-Value      | Redis, DynamoDB       | Fast retrieval          |
| Document Store | MongoDB, CouchDB      | JSON-like data          |
| Wide-Column    | Cassandra, BigTable   | Time-series data        |
| Graph DB       | Neo4j, Amazon Neptune | Relationship-heavy data |

# 17. Replication & Sharding

## Replication
* **Copy data across servers** for availability and fault tolerance.

### Types
| Type          | Description                          |
| ------------- | ------------------------------------ |
| Synchronous   | Consistent, higher latency           |
| Asynchronous  | Low latency, possible stale reads    |
| Master-Master | Multi-region writes, sync complexity |

## Sharding
* **Split data across servers** for scalability.
* Uses shard keys:

  * Range-based
  * Attribute-based
  * Hash-based
* Consistent hashing reduces data movement during scaling.

# 18. CAP Theorem

## Core Idea
* In a distributed system during a **network partition**, you can only have **two of three**:
  * Consistency
  * Availability
  * Partition Tolerance

## Types
* CP (Consistency + Partition Tolerance): Banking systems.
* AP (Availability + Partition Tolerance): Social media feeds.

## PACELC
* In a partition (P), choose between A or C.
* Else, tradeoff Latency (L) vs Consistency (C) during normal operations.

# 19. Object Storage

* **Flat, scalable storage for large, unstructured files** (images, videos, logs).
* Uses **HTTP for retrieval**.
* Examples: AWS S3, GCP Cloud Storage, Azure Blob Storage.

## Benefits
* Scalable
* Cost-effective
* Simple retrieval

## Use Cases
* Profile images, video uploads
* ML training dataset storage
* Backups and archival

# 19. Message Queues

## What They Do
* Enable **asynchronous processing and decoupling** of producers and consumers.
* Buffer high-volume requests during spikes to prevent system overload.

## Models
| Model      | Description                                    |
| ---------- | ---------------------------------------------- |
| Pull-Based | Consumers pull data from the queue             |
| Push-Based | Queue pushes data to consumers                 |
| Pub/Sub    | Publishers send to topics, subscribers receive |

## Reliability
* Acknowledgements and retries ensure **at-least-once delivery**.
* Some systems support exactly-once or at-most-once delivery depending on configuration.

# 20. MapReduce

## What It Is
* Programming model for **distributed big data processing**.

## Phases
1. **Map:** Transform input into key-value pairs.
2. **Shuffle & Sort:** Group values by key.
3. **Reduce:** Aggregate or process values per key.

## Benefits
* Handles **large-scale data efficiently**.
* Fault-tolerant and scalable by design.

## Example: Word Count
* **Map:** Emit `(word, 1)` for each word.
* **Reduce:** Sum counts for each word to get frequencies.
  
These notes are summaries from NeetCode.io