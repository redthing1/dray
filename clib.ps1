# Common variables
$PROJECT = "dray"
$LIB_NAME = "raylib"
$SOURCETREE_URL="https://github.com/redthing1/raylib"
$SOURCETREE_DIR="raylib_source"
$SOURCETREE_BRANCH="5.0.0_patch"
$PACKAGE_DIR = $PSScriptRoot

# Function to check if a command is available
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Function to ensure a command is available
function Ensure-Command($cmdname) {
    if (-not (Test-Command $cmdname)) {
        Write-Error "Error: $cmdname is not installed or not in PATH"
        Write-Error "Please install $cmdname and try again"
        exit 1
    }
    Write-PROJECT "$cmdname is available"
}

# Ensure all required commands are available
Ensure-Command "git"
Ensure-Command "cmake"

# Function to prepare the source
function Prepare-Source {
    Write-PROJECT "[$PROJECT] preparing $LIB_NAME source..."
    Set-Location $PACKAGE_DIR
    
    if (Test-Path $SOURCETREE_DIR) {
        Write-PROJECT "[$PROJECT] source folder already exists, using it."
    } else {
        Write-PROJECT "[$PROJECT] getting source to build $LIB_NAME"
        git clone --depth 1 --branch $SOURCETREE_BRANCH $SOURCETREE_URL $SOURCETREE_DIR
    }

    Set-Location $SOURCETREE_DIR
    git submodule update --init --recursive
    Write-PROJECT "[$PROJECT] finished preparing $LIB_NAME source"
}

# Function to build the library
function Build-Library {
    # throw error
    Write-Error "Error: Building $LIB_NAME is not supported on Windows"
}

# Main execution
function Main {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Action,
        
        [Parameter(ValueFromRemainingArguments=$true)]
        $RemainingArgs
    )

    # export all other KEY=VALUE pairs as environment variables
    foreach ($arg in $RemainingArgs) {
        if ($arg -match '^(\w+)=(.*)$') {
            $key = $matches[1]
            $value = $matches[2]
            Set-Item -Path "env:$key" -Value $value
        }
    }

    switch ($Action) {
        "prepare" { Prepare-Source }
        "build" { 
            Prepare-Source  # Always call prepare before build
            Build-Library 
        }
        default {
            Write-PROJECT "Usage: .\script.ps1 [prepare|build] [build arguments...]"
            exit 1
        }
    }
}

# Run the script
Main @args