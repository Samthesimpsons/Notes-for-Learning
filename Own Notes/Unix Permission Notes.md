# Unix File & Directory Permissions — Notes

## 1. Overview

Unix permissions control **who can access files and directories and what actions they can perform**.

This is a **built-in authorization system** within the Unix filesystem.

Every file and directory has three permission categories:

- Owner
- Group
- Others

Each category has three permission types:

- Read (r)
- Write (w)
- Execute (x)

---

# 2. Permission Categories

- Owner (User)
- The **user who owns the file**. The owner can have permissions different from other users.
- Group
- A **group of users** that share permissions. Any user belonging to the group receives the defined group permissions.
- Others
- All **remaining users on the system**.

## Permission Structure

Permissions are shown in this format:
- Owner | Group | Others

Example Breakdown:

```
rwx  r-x  r--
│    │    │
│    │    └── others
│    └────── group
└────────── owner
```

---

# 3. Permission Types

## Read (r)

Allows reading file contents.

```
cat file.txt
less file.txt
```

Allows listing files:

```
ls directory/
```

---

## Write (w)

Allows modifying the file.

Examples:

```
edit file
delete file
truncate file
```

Allows modifying directory contents:

```
create files
delete files
rename files
```

---

## Execute (x)

Allows executing a file as a program.

Example:

```
./script.sh
```

Execute permission means the ability to **enter the directory**. Permission denied if no permission.

Example:

```
cd directory/
```

---

# 4. Viewing Permissions

Use:

```bash
ls -l
```

Example output:

```
-rwxr-xr-- 1 samuel developers 2048 Mar 14 script.sh
```

Breakdown:

```
-rwxr-xr--
│││ │ │ │
│││ │ │ └── others permissions
│││ │ └──── group permissions
│││ └────── owner permissions
││└──────── file type
│└───────── permission bits
└────────── indicator
```

---

# 5. File Types (via Indicators)

The first character indicates the file type.

| Symbol | Type             |
| ------ | ---------------- |
| `-`    | regular file     |
| `d`    | directory        |
| `l`    | symbolic link    |
| `c`    | character device |
| `b`    | block device     |

Examples:

```
drwxr-xr-x directory
-rw-r--r-- file
```

---

# 6. Numeric Permission Representation (Octal)

Permissions can be represented using octal numbers. Unix octal permissions are computed by summing the numeric values of the permission bits.

| Permission | Binary | Value |
| ---------- | ------ | ----- |
| Read       | 100    | 4     |
| Write      | 010    | 2     |
| Execute    | 001    | 1     |

Example of changing permissions using `chmod` command:

```bash
# Command
chmod 755 script.sh 

# Meaning
Owner  → rwx (7)
Group  → r-x (5)
Others → r-x (5)

# result
rwxr-xr-x 
```

When special bits are included, a leading digit is added. Check the sections below for more details.
Structure: special | owner | group | others

| Special Bit | Value |
| ----------- | ----- |
| setuid      | 4     |
| setgid      | 2     |
| sticky      | 1     |

---

# 7. Changing Permissions

Use the `chmod` command using numeric mode as shown above. Or using symbolic mode:

```bash
# Format
chmod [who][operator][permission] file

# Example
chmod u+x script.sh
```

Who:
| Symbol | Meaning                     |
| ------ | --------------------------- |
| `u`    | user (owner)                |
| `g`    | group                       |
| `o`    | others                      |
| `a`    | all (user + group + others) |

Operator:
| Operator | Meaning              |
| -------- | -------------------- |
| `+`      | add permission       |
| `-`      | remove permission    |
| `=`      | set exact permission |

---

# 8. Changing Ownership

Change Owner:

```bash
chown user file

# Example:
chown samuel file.txt
```

Change Group:

```bash
chgrp group file

# Example:
chgrp developers file.txt
```

Change both:

```bash
chown user:group file

# Example:
chown samuel:developers file.txt
```

---

# 9. Special Permissions

Unix provides **three special permission bits** that extend the normal `rwx` permission model:

- **setuid (SUID)**
- **setgid (SGID)**
- **sticky bit**

These permissions change how **programs execute** or how **directories behave**.

## setuid (SUID)

`setuid` allows a program to run **as the file owner**, regardless of who executes it.

When a setuid program runs:

- **Real User ID (RUID)** → user who launched the program  
- **Effective User ID (EUID)** → owner of the executable file  

This allows the program to temporarily use the **owner's privileges**. However do note that:
* `setuid` **does NOT cause files to inherit the directory owner**.
* On most Linux systems, **setuid on directories is ignored**.

Example:

```bash
chmod u+s file # enabling setuid
-rwsr-xr-x # result
rws r-x r-x # breakdown
│││
││└─ execute
│└── setuid
└── owner permissions
```

The `s` replaces the owner's execute bit and indicates: execute + setuid enabled. When a user runs a program, Unix follows this order:

1. **Permission check happens first**

The system checks the **permission bits** in this order:

```
owner → group → others
```

It determines whether the user has **execute permission (`x`)**.

If execute permission is **not allowed**, the program **will not run**, even if `setuid` is enabled.

2. **Program execution begins**

If execution is allowed, the program starts normally.

3. **setuid takes effect**

If the file has the `setuid` bit set: Effective User ID (EUID) = file owner.

This means the program runs **as if the process were the file owner**.

## setgid (SGID)

`setgid` causes a program to run **as the file's group**.

When executed: Effective Group ID (EGID) = file's group. For example:

```bash
chmod g+s file # Enable `setgid`
-rwxr-sr-x # Outcome
```

Here the `s` appears in the **group execute position**.

However, when applied to a **directory**, `setgid` changes inheritance behavior. New files created inside the directory will **inherit the directory's group** instead of the creator's primary group.

```bash
drwxrwsr-x project/ # example
```

If the directory group is: developers
A new file created inside becomes:
- owner → user who created the file
- group → developers

A common use case is for shared team directories. This ensures all files stay within the same group for collaboration.

## Sticky Bit

The **sticky bit** is mainly used on **directories**. It prevents users from deleting or renaming files in that directory **unless they are**:
- the file owner
- the directory owner
- or `root`

This is useful for shared writable directories. Hence:
- Sticky bit is primarily meaningful on **directories**.
- On regular files, sticky bit is generally obsolete on modern Unix/Linux systems.

```bash
chmod +t /shared # Enable sticky bit
drwxrwxrwt # outcome
rwx rwx rwt # breakdown
││
│└─ execute
└── sticky bit
```

The `t` appears in the **others execute position**.

The classic example is:

```text
drwxrwxrwt /tmp
```

Many users can create files there, but they should **not** be able to delete each other's files.

## Lowercase vs Uppercase

For special bits:
- lowercase `s` or `t` → special bit **and** execute bit are both set
- uppercase `S` or `T` → special bit is set, but execute bit is **not** set

It is a display encoding used by `ls -l` to show 2 permission bits in a single character slot.

Examples:

```text
-rwsr-xr-x   # setuid + execute
-rwSr--r--   # setuid without execute
drwxrwxrwt   # sticky bit + execute
drwxrwxrwT   # sticky bit without execute
```

## Summary

| Permission     | Effect on Files            | Effect on Directories             |
| -------------- | -------------------------- | --------------------------------- |
| **setuid**     | program runs as file owner | ignored on most Linux systems     |
| **setgid**     | program runs as file group | new files inherit directory group |
| **sticky bit** | not typically used         | restricts file deletion           |

---

# 10. Recursive Changes

Sometimes permissions must apply to **a directory and everything inside it**. However it **ONLY** applies to existing file and not subsequent new files.

Use the recursive flag:

```bash
chmod -R 755 project/
```

This affects:

```
project/
project/file1
project/file2
project/src/
project/src/main.py
```

We can also change ownership recursively:

Example:

```bash
chown -R samuel:developers project/
```

Changes ownership of:

```
project/
project/*
project/**/*
```

Result:

```
owner → samuel
group → developers
```

---

# 11. Owner and Group Inheritance

## Owner

New files are owned by the user who creates the file. Owner is **not inherited from the directory**.

Example:
```
directory owner → root
user samuel creates file → owner = samuel
```

---

## Group (Default Behavior)

By default new file group = user's primary group. o the directory group is **not inherited automatically**.

Example:

```
user group = staff
directory group = developers
new file group → staff
```

---

# 12. Enforcing Group Inheritance (using setgid)

To force group inheritance such that new files inherit the directory group, enable **setgid on a directory**. The letter `s` replaces `x` when a special permission is enabled and execute is also enabled.

Example:

```bash
chmod g+s project/
```

Directory permission becomes:

```
drwxr-sr-x
```

Example:

```
directory group → developers
new file group → developers
```

Common use case:
- shared team folders
- development projects

---

# 13. Default File Permissions

Typical defaults:

| Type        | Default |
| ----------- | ------- |
| Files       | 666     |
| Directories | 777     |

The system subtracts the **umask**, a mask that removes permissions from the default file permissions when new files or directories are created.

Example:
- umask = 022
- File created: 666 - 022 = 644
- Directory created: 777 - 022 = 755

Check current umask that is usually configured in places like:
- `/etc/profile`
- `/etc/bashrc`
- `~/.bashrc`
- `~/.profile`
- `/etc/login.defs`

Different shells or users can have different umask values:

```bash
umask # command
022 # output
```

---

# 14. Example: Shared Team Directory Setup

Goal:
- All developers can modify files
- All files share the same group

Setup:

```bash
chown -R root:developers project/
chmod -R 2775 project/
```

Hence as a result:
- 2 → setgid
- 775 → `rwxrwxr-x`
- Directory permissions: `drwxrwsr-x`. The **`s` in the group execute position** indicates that the **setgid bit is enabled**.

New files created inside the directory will **inherit the directory’s group (`developers`)** instead of the creator’s primary group. This is commonly used for **shared team directories**, where multiple developers collaborate and all files should remain within the same group.
