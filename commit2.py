import os
import subprocess

def run_cmd(cmd):
    print(f"Running: {cmd}")
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    print(result.stdout)
    if result.stderr:
        print(f"Error: {result.stderr}")

os.chdir(r"D:\deep_read")
run_cmd("git add .")
run_cmd('git commit -m "fix: make showTranslation switch hide/show sentence translation icons"')
run_cmd("git push")
