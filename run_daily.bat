@echo off
:: ─── run_daily.bat ──────────────────────────────────────────────────────────
:: Drop this into Windows Task Scheduler to auto-commit every day at 9 AM.
:: 
:: Task Scheduler setup (one-time):
::   1. Open "Task Scheduler"  →  Create Basic Task
::   2. Name: "GitHub Green"
::   3. Trigger: Daily, 9:00 AM
::   4. Action: Start a program
::        Program:  C:\Users\hr988\Downloads\BitBuffer Module\run_daily.bat
::   5. Finish → Done!
:: ─────────────────────────────────────────────────────────────────────────────

cd /d "C:\Users\hr988\Downloads\BitBuffer Module"
python git_green.py today
git push origin main >> run_daily.log 2>&1
