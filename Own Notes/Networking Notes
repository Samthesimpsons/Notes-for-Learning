# IP Addresses

## What is an IP Address?

An IP address is like a **house address** — it identifies a device on a network so data knows where to go.

---

## Public vs Private IP

- **Public IP** — Your home's street address on Google Maps. Visible to the entire internet, assigned by your ISP.
- **Private IP** — Like room numbers inside the house. Only known to devices on the local network, not routable on the internet.

**Common private ranges:**

| Class | Range | Default Subnet Mask |
|-------|-------|---------------------|
| A | `10.0.0.0 – 10.255.255.255` | `255.0.0.0` |
| B | `172.16.0.0 – 172.31.255.255` | `255.255.0.0` |
| C | `192.168.0.0 – 192.168.255.255` | `255.255.255.0` |

---

## IP Classes (Classful Addressing)

| Class | First Octet Range | Purpose |
|-------|-------------------|---------|
| A | 1 – 126 | Large networks |
| B | 128 – 191 | Medium networks |
| C | 192 – 223 | Small networks |
| D | 224 – 239 | Multicasting |
| E | 240 – 255 | Experimental |

> Classes apply to both public and private IPs.

---

## Loopback Address

- **`127.0.0.1`** (IPv4) / **`::1`** (IPv6)
- Points back to your own machine ("localhost").
- Used for testing network services without hitting the actual network.
- Entire `127.0.0.0/8` range is reserved for loopback.

---

## Are IP Addresses Unique?

- **Public IPs** → Globally unique. No two devices share the same public IP at the same time.
- **Private IPs** → Can overlap across different networks. Two houses can both have a "Room 1" — no conflict because they're separate networks.

---

## IPv4 vs IPv6

| | IPv4 | IPv6 |
|--|------|------|
| **Format** | 4 groups of 8 bits | 8 groups of 16 bits |
| **Total bits** | 4 × 8 = **32 bits** | 8 × 16 = **128 bits** |
| **Combinations** | ~4.3 billion | ~3.4 × 10³⁸ (undecillion) |
| **Example** | `192.168.1.1` | `2001:0db8:85a3::8a2e:0370:7334` |
| **Status** | Running out | Virtually unlimited |

---

## Subnetting

### What is a Subnet?

A subnet divides a larger network into smaller, manageable sub-networks. It controls **how much of the IP address identifies the network vs. the host**.

- **Network portion** — bits from the **left** identify which network.
- **Host portion** — remaining bits on the **right** identify a device on that network.

The **subnet mask** tells you where the split happens.

### Key Addresses in a Subnet

| Address | Meaning |
|---------|---------|
| **Network address** | First address — identifies the subnet itself. All host bits = `0`. Not assignable. |
| **Broadcast address** | Last address — sends data to all hosts in the subnet. All host bits = `1`. Not assignable. |
| **Usable IPs** | Everything in between (non-inclusive of network & broadcast). |

---

### Method 1: Binary (Long Way)

1. **Convert subnet mask to binary** — it's a series of `1`s followed by `0`s.
   - e.g. `255.255.255.0` → `11111111.11111111.11111111.00000000`
2. **Convert IP address to binary.**
   - e.g. `192.168.1.130` → `11000000.10101000.00000001.10000010`
3. **Network address** — set all host bits to `0`, convert back.
   - `11000000.10101000.00000001.00000000` → `192.168.1.0`
4. **Broadcast address** — set all host bits to `1`, convert back.
   - `11000000.10101000.00000001.11111111` → `192.168.1.255`
5. **Usable range** → `192.168.1.1` to `192.168.1.254`

---

### Method 2: Shortcut (Fast Way)

Given IP `192.168.1.130/26` (subnet mask `255.255.255.192`):

1. **Host bits** = `32 - subnet prefix` = `32 - 26` = **6 bits**
2. **Block size (increment)** = `2^host bits` = `2⁶` = **64**
3. **Network address** — find the nearest multiple of 64 ≤ host octet.
   - `130 ÷ 64` → falls in the `128` block → network = `192.168.1.128`
4. **Broadcast address** = network + increment − 1
   - `128 + 64 - 1` = **191** → broadcast = `192.168.1.191`
5. **Usable range** → `192.168.1.129` to `192.168.1.190`
6. **Total usable hosts** = `2^host bits - 2` = `64 - 2` = **62**

> Subtract 2 because network and broadcast addresses are not assignable.
