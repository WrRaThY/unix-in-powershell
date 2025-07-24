# PowerShell Profile - Main configuration file
# Equivalent to .bashrc in Unix systems
#
# INSTALLATION:
# This file should be placed in your PowerShell profile directory:
# - Windows PowerShell 5.1: $HOME\Documents\WindowsPowerShell\
# - PowerShell 7+: $HOME\Documents\PowerShell\
# 
# To find your profile directory, run: Split-Path $PROFILE
# To check if this file exists, run: Test-Path $PROFILE
# To edit this file, run: notepad $PROFILE (or code $PROFILE for VS Code)
#
# This profile automatically loads custom aliases from PowerShell_aliases.ps1
# in the same directory, providing a clean separation of concerns.

# ========== GENERAL CONFIGURATION ==========
# Add your general PowerShell configuration here
# Examples: Set-PSReadLineOption, Import-Module, etc.

# Enable better tab completion
# Set-PSReadLineKeyHandler -Key Tab -Function Complete

# ========== LOAD ALIASES ==========
# Load custom aliases from separate file (equivalent to sourcing .bash_aliases)
$aliasesFile = Join-Path $PSScriptRoot "PowerShell_aliases.ps1"
if (Test-Path $aliasesFile) {
    . $aliasesFile
} else {
    Write-Host "Aliases file not found: $aliasesFile" -ForegroundColor Yellow
}
