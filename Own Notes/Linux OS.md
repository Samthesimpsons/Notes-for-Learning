# 💻 Technical Notes: Linux, Ubuntu, Terminals, Bash & Dev Environments

---

## 🗂️ Linux Folder Structure (Key Directories)

| Directory | Purpose |
|----------|---------|
| `/` | Root of the entire filesystem |
| `/home` | User home directories (`/home/alice`) |
| `/etc` | System-wide configuration files |
| `/bin` | Essential user binaries (e.g., `ls`, `cp`) |
| `/sbin` | System binaries for administration |
| `/usr` | User-installed software and libraries |
| `/var` | Variable data (logs, spools, cache) |
| `/tmp` | Temporary files (auto-deleted on reboot) |
| `/lib` | Shared libraries for binaries in `/bin` and `/sbin` |
| `/opt` | Optional third-party software |
| `/dev` | Device files (e.g., `/dev/sda`, `/dev/null`) |
| `/proc`, `/sys` | Virtual filesystems exposing kernel/system info |

---

## 🐧 What is Ubuntu?

- Popular **Linux distribution** based on **Debian**
- Used for **development**, **cloud servers**, **containers**, and **CI/CD**
- Package manager: `apt`
- Widely supported in **cloud (AWS/GCP)** and **DevOps workflows**

---

## 🖥️ Terminal vs Shell

- **Terminal** = Interface where you type commands (e.g., GNOME Terminal, iTerm, console)
- **Shell** = Program interpreting commands (e.g., `bash`, `zsh`, `sh`)

### Common Shells:
| Shell | Description |
|-------|-------------|
| `bash` | Default on most Linux systems (Bourne Again Shell) |
| `sh` | Older, minimal Bourne shell |
| `zsh` | Modern interactive shell with plugins |
| `fish` | User-friendly shell with built-in help |

---

## 💻 Ubuntu Terminal + Bash

- Ubuntu uses **GNOME Terminal** (desktop)
- Default shell is **`/bin/bash`**
- On remote servers (e.g., via SSH), users land in Bash shell

---

## 🐳 Example: Ubuntu in CDSW / Docker

Platforms like **CDSW** use **Ubuntu-based Docker images**:

```Dockerfile
FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y python3 python3-pip bash

CMD ["/bin/bash"]
````

* Gives devs a clean Ubuntu shell in a container
* Matches cloud/server environments
* Easy to install tools (`apt`, `pip`, etc.)

---

## ✅ Why Ubuntu is Preferred Over macOS/Windows for Development

### Summary:

| Reason                 | Why Ubuntu Wins                              |
| ---------------------- | -------------------------------------------- |
| **Environment match**  | Production servers run Linux – no surprises  |
| **Tooling**            | Native support for Bash, Docker, SSH, etc.   |
| **Package management** | `apt` is fast, scriptable, and reliable      |
| **Performance**        | Lightweight, fast for CI/CD and dev tools    |
| **Cloud-native**       | Docker/K8s use Linux-based containers        |
| **Free/Open-source**   | No license restrictions, full control        |
| **Customizability**    | Full root access, no GUI bloat if not needed |

### TL;DR:

> **Ubuntu is fast, flexible, and mirrors production environments — making it the best choice for modern development, DevOps, and cloud work.**

