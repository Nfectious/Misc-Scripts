````markdown
# venv-launch.sh

A small, reliable helper script for **creating and activating a Python virtual environment** in the **current shell session**, with an automatic **pip upgrade on first creation**.

---

## Features

- Creates a virtual environment if it does not exist (default: `.venv/`)
- Activates the environment in your **current terminal** (so it stays active after the script runs)
- Upgrades `pip` **only when the venv is first created**
- Optionally runs a command immediately after activation (inside the venv)

---

## Requirements

- Bash (`/usr/bin/env bash`)
- Python installed:
  - `python3` preferred, falls back to `python`
- Supported environments:
  - Linux / macOS (`.venv/bin/activate`)
  - Git Bash on Windows (`.venv/Scripts/activate`)

---

## Installation

1. Create the script in your repo:

```bash
mkdir -p scripts
nano scripts/venv-launch.sh
````

2. Paste the script contents, then make it executable:

```bash
chmod +x scripts/venv-launch.sh
```

---

## Usage

> **Important:** You must **source** the script so it can modify your current shell environment.

### Recommended (default `.venv`)

```bash
source scripts/venv-launch.sh
```

### Use a custom venv directory

```bash
source scripts/venv-launch.sh .venv
# or
source scripts/venv-launch.sh venv
```

### Run a command after activation

```bash
source scripts/venv-launch.sh .venv "python -m pip list"
```

### Verify it worked

```bash
which python
python -V
python -m pip -V
echo "$VIRTUAL_ENV"
```

### Deactivate

```bash
deactivate
```

---

## Behavior Details

### First run (venv does not exist)

* Creates the venv directory
* Activates it
* Runs:

  ```bash
  python -m pip install -U pip
  ```

### Subsequent runs (venv already exists)

* Activates it
* Does **not** re-upgrade pip (fast activation)

---

## Common Issues

### “It activated but then immediately deactivated”

You likely **ran** the script instead of sourcing it. This **won’t persist** activation.

✅ Correct:

```bash
source scripts/venv-launch.sh
```

❌ Incorrect:

```bash
./scripts/venv-launch.sh
```

### “python3/python not found”

Install Python and ensure it is on your `PATH`:

```bash
python3 -V
# or
python -V
```

### “cannot find activate script”

The venv may not have been created successfully, or the directory name differs.
Recreate it:

```bash
rm -rf .venv
source scripts/venv-launch.sh
```

---

## Suggested Project Convention

Add `.venv/` to `.gitignore`:

```gitignore
.venv/
```

---

## License

Use freely within your projects (add your preferred license if distributing).

```

**a.** Want a matching `scripts/venv-down.sh` that deactivates and prints a clear confirmation?  
**b.** Want the README to include a one-liner install snippet that writes the script automatically (curl/heredoc style)?
```
