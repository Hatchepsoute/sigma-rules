Param(
  [string]$RepoRoot = "",
  [switch]$InstallIfMissing = $true
)

$ErrorActionPreference = "Stop"

function Info($m){ Write-Host "[*] $m" }
function Warn($m){ Write-Host "[!] $m" -ForegroundColor Yellow }
function Fail($m){ Write-Host "[X] $m" -ForegroundColor Red; exit 1 }

function Has-Command($name){
  return $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

function Find-RepoRoot {
  param([string]$StartDir)

  $d = (Resolve-Path $StartDir).Path
  while ($true) {
    if (Test-Path (Join-Path $d ".git")) { return $d }
    $parent = Split-Path $d -Parent
    if ($parent -eq $d -or [string]::IsNullOrWhiteSpace($parent)) { break }
    $d = $parent
  }
  return $null
}

function Ensure-Python {
  if (-not (Has-Command "python")) { Fail "Python not found. Install Python 3.9+ then rerun." }
  try { python -m pip --version | Out-Null } catch { Fail "pip is not available. Fix Python/pip installation then rerun." }
}

function Ensure-Pipx {
  if (Has-Command "pipx") { return }

  if (-not $InstallIfMissing) {
    Fail "pipx not found. Install pipx or rerun with -InstallIfMissing."
  }

  Info "pipx not found. Installing pipx (user install)..."
  python -m pip install --user -U pipx | Out-Null

  # try to update PATH in this session
  $pipxBinCandidates = @(
    (Join-Path $env:USERPROFILE ".local\bin"),
    (Join-Path $env:APPDATA "Python\Scripts"),
    (Join-Path $env:LOCALAPPDATA "Programs\Python\Python312\Scripts"),
    (Join-Path $env:LOCALAPPDATA "Programs\Python\Python311\Scripts"),
    (Join-Path $env:LOCALAPPDATA "Programs\Python\Python310\Scripts")
  )

  foreach ($p in $pipxBinCandidates) {
    if (Test-Path $p) { $env:PATH = "$p;$env:PATH" }
  }

  try { python -m pipx ensurepath | Out-Null } catch { }
}

function Ensure-Sigma {
  if (Has-Command "sigma") {
    Info "sigma already installed."
    Info ("sigma path: " + (Get-Command sigma).Source)
    return
  }

  if (-not $InstallIfMissing) {
    Fail "sigma not found. Install sigma-cli or rerun with -InstallIfMissing."
  }

  Ensure-Pipx

  if (Has-Command "pipx") {
    Info "Installing sigma-cli with pipx..."
    try { pipx install sigma-cli | Out-Null } catch { pipx upgrade sigma-cli | Out-Null }
  } else {
    Warn "pipx still not available. Falling back to pip --user install (less isolated)."
    python -m pip install --user -U sigma-cli | Out-Null
  }

  if (Has-Command "sigma") {
    Info "sigma installed successfully."
    Info ("sigma path: " + (Get-Command sigma).Source)
  } else {
    Warn "sigma command still not found in PATH; module fallback will be used."
  }
}

function Collect-RuleFiles {
  param([string]$Root)

  # Collect **\rules\*.yml and **\rules\*.yaml, excluding common noise folders
  $exclude = @("\.git\", "\.venv\", "\venv\", "\__pycache__\", "\node_modules\")
  $files = Get-ChildItem -Path $Root -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
      ($_.FullName -match "\\rules\\.*\.(yml|yaml)$") -and
      ($exclude | ForEach-Object { $_ }) -notcontains $null
    }

  # Apply excludes properly
  $files = $files | Where-Object {
    $ok = $true
    foreach ($x in $exclude) {
      if ($_.FullName -match [regex]::Escape($x)) { $ok = $false; break }
    }
    $ok
  }

  return $files
}

# ---------------- Main ----------------
if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
  $RepoRoot = Find-RepoRoot -StartDir (Get-Location).Path
}

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
  Fail "Git repo root not found (.git). Run this script inside your sigma-rules repository."
}

Info "Repo root: $RepoRoot"

Ensure-Python
Ensure-Sigma

$ruleFiles = Collect-RuleFiles -Root $RepoRoot
if (-not $ruleFiles -or $ruleFiles.Count -eq 0) {
  Fail "No Sigma rule files found under **\rules\*.yml or **\rules\*.yaml"
}

Info ("Found {0} Sigma rule files under **\rules\" -f $ruleFiles.Count)

# sigma check accepts multiple INPUT values; avoid command-length issues by batching
$batchSize = 200
$chunks = [System.Collections.Generic.List[object]]::new()
for ($i=0; $i -lt $ruleFiles.Count; $i += $batchSize) {
  $chunks.Add($ruleFiles[$i..([Math]::Min($i+$batchSize-1, $ruleFiles.Count-1))])
}

foreach ($c in $chunks) {
  $paths = $c | ForEach-Object { $_.FullName }

  if (Has-Command "sigma") {
    Info ("Running: sigma check (batch size={0})" -f $paths.Count)
    & sigma check @paths
  } else {
    Warn "sigma not in PATH. Using python module fallback..."
    & python -m sigma.cli.main check @paths
  }
}

Info "Done."

