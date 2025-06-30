# Git Guide

---

## Tutorial Resources

* **Beginner:** [Git and GitHub for Beginners – Crash Course](https://www.youtube.com/watch?v=RGOj5yH7evk)
* **Intermediate:** [Git Tutorial for Beginners: Learn Git in 1 Hour](https://www.youtube.com/watch?v=Uszj_k0DGsg&t=411s)
* **Advanced:** [Advanced Git Tutorial](https://www.youtube.com/watch?v=qsTthZi23VE&t=1827s)

---

## Further Reading

* [Managing Multiple Git Remotes (Jigarius Blog)](https://jigarius.com/blog/multiple-git-remote-repositories)
* [Corporate Git Workflows](https://www.youtube.com/watch?v=Dl-BdxNRUqs)
* [Git Tips and Tricks](https://www.youtube.com/watch?v=aolI_Rz0ZqY)

---

## Personal Notes

* Uses **VIM and Nano** as terminal editors.
* Familiar with using tags for deployed package versioning.
* Practices:

  * Linear history
  * Dev and deploy branches
  * Prefer **rebase over merge** for clean commit trees.
* Advocates disciplined workflows even without team enforcement authority.
* Regularly uses:

  * `reflog`
  * `cherry-pick`
  * `prune`

---

## Git Basics

```bash
# List all files (including hidden)
ls -la

# Initialize Git in current directory
git init

# Check file staging status
git status

# Add all files
git add .

# Add a specific file
git add index.html

# Show branches
git branch

# Rename current branch
git branch -M main

# Create and switch to a new branch
git checkout -b feature_branch

# Switch to an existing branch
git checkout main

# Commit with message
git commit -m "Short message" -m "Detailed description"

# View remote repositories
git remote -v

# Condensed commit history
git log --oneline
```

---

## Intermediate Git

### Pushing to Remote

**Scenario 1:** Push local project to new remote

```bash
git remote add origin <remote-URL>
git branch -M main
git push -u origin main
```

**Scenario 2:** Push changes after cloning

```bash
git push -u origin main
```

---

## Feature Branch Workflow

### Standard team process

```bash
# Push your feature branch
git push -u origin feature_branch

# After pull request is merged remotely
git checkout main
git pull
git branch -D feature_branch
```

### For personal projects

```bash
git checkout main
git merge feature_branch
git branch -D feature_branch
```

### Squashing during merge

```bash
git checkout main
git merge --squash feature_branch
git branch -D feature_branch
```

### Rebasing (preferred)

```bash
git checkout main
git rebase feature_branch
git branch -D feature_branch
```

---

## Handling Merge Conflicts

```bash
git checkout main
git pull

git checkout feature_branch
git commit -am "Save current work"
git merge main
# Resolve conflicts manually
git commit -am "Resolved merge conflicts"
```

**Abort merge:**

```bash
git merge --abort
```

---

## Undoing Changes

* **Unstage a file:**

  ```bash
  git reset index.html
  ```
* **Undo last commit (keep changes):**

  ```bash
  git reset HEAD~1
  ```
* **Undo to a specific commit:**

  ```bash
  git reset <commit-hash>
  ```
* **Hard reset (discard all changes):**

  ```bash
  git reset --hard <commit-hash>
  ```

---

## Perfect Commits & Selective Staging

**Interactive staging:**

```bash
git add -p index.html
```

**Commit message format:**

```
Short summary (max 50 chars)

Longer body explaining context and reasoning.
```

---

## Forking Workflow

* Forks are **personal copies** of repos for independent changes.
* Use **pull requests** to contribute to the original repository.

---

## Advanced Git

### Interactive Rebase

Clean up local commit history (use before pushing):

```bash
git rebase -i HEAD~3
```

Amend last commit message:

```bash
git commit --amend -m "Updated commit message"
```

---

### Cherry-Picking Commits

Pick specific commits from one branch to another:

```bash
git checkout feature_branch
git cherry-pick <commit-hash>
```

Undo last commit on `main`:

```bash
git checkout main
git reset --hard HEAD~1
```

---

### Reflog

Track **HEAD movements** for recovering lost commits:

```bash
git reflog
```
