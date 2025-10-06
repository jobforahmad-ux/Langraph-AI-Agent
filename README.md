# Langraph-AI-Agent

This repository references the original Langgraph project as a Git submodule.

## Getting started with submodule

- Clone with submodules:
  ```bash
  git clone --recurse-submodules https://github.com/jobforahmad-ux/Langraph-AI-Agent.git
  ```

- If already cloned without submodules:
  ```bash
  git submodule update --init --recursive
  ```

## Updating the Langgraph submodule

- Pull latest from upstream inside the submodule and record the update in this repo:
  ```bash
  cd langgraph
  git checkout main
  git pull origin main
  cd ..
  git add langgraph
  git commit -m "Update submodule to latest"
  git push
  ```

## Auto-update script

Use the PowerShell script to update the submodule to the latest on a branch and push the change:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\update-submodule.ps1 -SubmodulePath "langgraph" -SubmoduleBranch "main" -Remote "origin"
```

### Windows batch wrapper

Double-click to run:

```bat
scripts\update-submodule.bat
```

## Notes

- The submodule points to: https://github.com/harishneel1/langgraph.git
- This setup preserves attribution and avoids redistributing the source code directly in this repository.
