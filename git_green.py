"""
git_green.py  –  GitHub Contribution Graph Auto-Filler
=======================================================
Backfills commits from 2022 → today at specified daily fill percentages,
then optionally runs as a daily job going forward.

Usage:
  python git_green.py backfill          # fill past years
  python git_green.py today             # commit for today only
  python git_green.py status            # show what would be committed

Requirements:
  - Git installed and in PATH
  - Run this from inside the repo folder (already set up for you)
  - Push the repo to GitHub once after setup (see README.md)
"""

import subprocess
import os
import random
import sys
from datetime import date, timedelta, datetime

# ─── CONFIG ────────────────────────────────────────────────────────────────────

# How much of each year to fill (0.0 = none, 1.0 = every day)
YEAR_FILL = {
    2022: 0.90,
    2023: 0.60,
    2024: 0.60,
    2025: 0.80,
    2026: 0.70,
}

# Commits per filled day  (min, max)  – random in this range for natural look
COMMITS_PER_DAY = (1, 7)

# Files to rotate edits through (makes commits look real)
TOUCH_FILES = [
    "bitbuffer.lua",
    "csv.lua",
    "persistence.lua",
    "dataservice.lua",
]

# Commit messages that look legit
COMMIT_MESSAGES = [
    "refactor: improve buffer alignment logic",
    "fix: handle edge case in bit packing",
    "chore: update internal documentation",
    "perf: optimize read/write throughput",
    "feat: add overflow guard to parser",
    "fix: correct bit-shift boundary check",
    "refactor: clean up legacy CSV handler",
    "chore: minor code cleanup",
    "docs: update inline comments",
    "fix: resolve off-by-one in persistence layer",
    "perf: reduce redundant allocations",
    "refactor: simplify dataservice error handling",
    "fix: patch null reference in stream reader",
    "feat: expose version constant",
    "chore: sync formatting with style guide",
    "fix: edge case when buffer is empty",
    "refactor: extract helper utilities",
    "docs: add usage examples to README",
    "chore: update .gitignore entries",
    "fix: correct byte ordering on little-endian systems",
]

# ─── HELPERS ───────────────────────────────────────────────────────────────────

REPO_DIR = os.path.dirname(os.path.abspath(__file__))


def run(cmd, env=None):
    """Run a shell command, raise on failure."""
    result = subprocess.run(
        cmd,
        cwd=REPO_DIR,
        capture_output=True,
        text=True,
        env=env or os.environ.copy(),
    )
    if result.returncode != 0:
        raise RuntimeError(f"Command failed: {' '.join(cmd)}\n{result.stderr}")
    return result.stdout.strip()


def git_commit_with_date(commit_date: date, message: str, file_to_touch: str):
    """Create a commit backdated to commit_date."""
    # Slightly vary the time so commits don't all land at midnight
    hour   = random.randint(9, 22)
    minute = random.randint(0, 59)
    second = random.randint(0, 59)
    dt_str = f"{commit_date.isoformat()}T{hour:02d}:{minute:02d}:{second:02d}"

    env = os.environ.copy()
    env["GIT_AUTHOR_DATE"]    = dt_str
    env["GIT_COMMITTER_DATE"] = dt_str

    # Append a tiny invisible change so git doesn't complain about nothing to commit
    fpath = os.path.join(REPO_DIR, file_to_touch)
    with open(fpath, "a", encoding="utf-8") as f:
        f.write(f"\n-- {dt_str}\n")

    run(["git", "add", file_to_touch])
    run(["git", "commit", "-m", message], env=env)


def get_committed_dates() -> set:
    """Return set of date strings already committed (YYYY-MM-DD)."""
    try:
        log = run(["git", "log", "--pretty=format:%ad", "--date=short"])
        return set(log.splitlines())
    except Exception:
        return set()


def iter_year_days(year: int):
    """Yield every date in the given year (up to today for current year)."""
    today = date.today()
    d = date(year, 1, 1)
    end = date(year, 12, 31) if year < today.year else today
    while d <= end:
        yield d
        d += timedelta(days=1)


def should_fill(year: int, fill_ratio: float, committed: set, d: date) -> bool:
    """Decide whether to fill this day (skip already-committed days)."""
    if d.isoformat() in committed:
        return False  # already done
    return random.random() < fill_ratio


# ─── COMMANDS ──────────────────────────────────────────────────────────────────

def cmd_backfill():
    print("🟢  BitBuffer System – GitHub Contribution Backfiller")
    print("=" * 54)

    # Make sure git repo is initialized
    if not os.path.isdir(os.path.join(REPO_DIR, ".git")):
        print("  Initialising git repo …")
        run(["git", "init"])
        run(["git", "checkout", "-b", "main"])

    committed = get_committed_dates()
    total_committed = 0

    for year, ratio in sorted(YEAR_FILL.items()):
        days = list(iter_year_days(year))
        to_fill = [d for d in days if should_fill(year, ratio, committed, d)]
        to_fill.sort()

        print(f"\n  {year}  ({int(ratio*100)}% target → {len(to_fill)} days to fill)")

        for d in to_fill:
            n_commits = random.randint(*COMMITS_PER_DAY)
            for _ in range(n_commits):
                msg  = random.choice(COMMIT_MESSAGES)
                ftle = random.choice(TOUCH_FILES)
                git_commit_with_date(d, msg, ftle)
                total_committed += 1
            print(f"    ✓  {d}  ({n_commits} commits)", end="\r")
        print(f"    ✓  {year} done – {len(to_fill)} days filled          ")

    print(f"\n✅  Backfill complete!  {total_committed} total commits added.")
    print("\nNext step → push to GitHub:")
    print("  git remote add origin https://github.com/YOUR_USERNAME/BitBuffer-System.git")
    print("  git push -u origin main --force\n")


def cmd_today():
    """Make commits for today only (use this as your daily scheduler job)."""
    today = date.today()
    year  = today.year
    ratio = YEAR_FILL.get(year, 0.70)

    committed = get_committed_dates()
    if today.isoformat() in committed:
        print(f"✅  Already committed for today ({today}). Nothing to do.")
        return

    # Only commit on ~ratio% of days going forward too
    if random.random() > ratio:
        print(f"⏭️   Skipping today ({today}) to keep {int(ratio*100)}% fill rate realistic.")
        return

    n_commits = random.randint(*COMMITS_PER_DAY)
    for _ in range(n_commits):
        msg  = random.choice(COMMIT_MESSAGES)
        ftle = random.choice(TOUCH_FILES)
        git_commit_with_date(today, msg, ftle)

    print(f"✅  {n_commits} commits made for {today}. Run 'git push origin main' to sync.")


def cmd_status():
    committed = get_committed_dates()
    today = date.today()
    print("📊  Planned commits per year:\n")
    for year, ratio in sorted(YEAR_FILL.items()):
        days  = list(iter_year_days(year))
        done  = sum(1 for d in days if d.isoformat() in committed)
        total = len(days)
        print(f"  {year}:  target={int(ratio*100)}%   days={total}   already committed={done}")
    print()


# ─── ENTRY POINT ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "backfill"

    if cmd == "backfill":
        cmd_backfill()
    elif cmd == "today":
        cmd_today()
    elif cmd == "status":
        cmd_status()
    else:
        print(__doc__)
