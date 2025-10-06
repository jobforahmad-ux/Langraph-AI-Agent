param(
  [string]$SubmodulePath = "langgraph",
  [string]$SubmoduleBranch = "main",
  [string]$Remote = "origin"
)

$ErrorActionPreference = "Stop"

function Exec($cmd, $workdir) {
  Write-Host "> $cmd" -ForegroundColor Cyan
  if ($workdir) { Push-Location $workdir }
  try {
    & powershell -NoProfile -Command $cmd
    if ($LASTEXITCODE -ne 0) { throw "Command failed: $cmd (code $LASTEXITCODE)" }
  } finally {
    if ($workdir) { Pop-Location }
  }
}

# Resolve paths
$repoRoot = (Resolve-Path ".").Path
$subPath = Join-Path $repoRoot $SubmodulePath

if (!(Test-Path -LiteralPath $subPath)) {
  throw "Submodule path not found: $subPath. Did you run 'git submodule update --init --recursive'?"
}

# Ensure git is available
Exec "git --version" $null

# Fetch and fast-forward the submodule to latest on the branch
Exec "git fetch --all --prune" $subPath
Exec "git checkout $SubmoduleBranch" $subPath
Exec "git pull --ff-only $Remote $SubmoduleBranch" $subPath

# Stage updated submodule pointer in the superproject
Exec "git add `"$SubmodulePath`"" $repoRoot

# Check if there is anything to commit
$diff = & git diff --cached --name-only | Out-String
if (-not $diff.Trim()) {
  Write-Host "Submodule already up to date. Nothing to commit." -ForegroundColor Yellow
  exit 0
}

# Commit and push
$sha = (& git -C $subPath rev-parse --short HEAD).Trim()
$message = "Update submodule '$SubmodulePath' to $sha"
Exec "git commit -m `"$message`"" $repoRoot
Exec "git push -u $Remote HEAD" $repoRoot

Write-Host "Done: $message" -ForegroundColor Green
