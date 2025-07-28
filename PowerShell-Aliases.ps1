# Human description

# Normally, I use gitbash+zsh as a terminal on windows, but... some tools don't play well with it
# which means I sometimes need to switch to PowerShell and all my muscle memory goes to hell
# so I vibecoded myself (thanks https://www.warp.dev/ :D) aliases for common unix functions
# I added some additional aliases based on my .bashrc and that's it.
# this file is ugly as hell, but it gets the job done, so hey. why not just use it? :D
# hopefully this will be of use to someone else as well!

# everything below this point is vibecoded

# PowerShell Aliases - Custom Functions and Aliases
# This file contains custom aliases and their automatic categorization system
# Equivalent to .bash_aliases in Unix systems

# ========== REMOVE CONFLICTING BUILT-IN ALIASES ==========
# Automatically remove built-in PowerShell aliases that conflict with our custom functions
$aliasesFilePath = $PSCommandPath
if (-not $aliasesFilePath) {
    $aliasesFilePath = Join-Path $PSScriptRoot "aliases.ps1"
}

if (Test-Path $aliasesFilePath) {
    $aliasesContent = Get-Content $aliasesFilePath -Raw
    $functionMatches = [regex]::Matches($aliasesContent, 'function\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\{')
    $customFunctionNames = $functionMatches | ForEach-Object { $_.Groups[1].Value }
    
    foreach ($functionName in $customFunctionNames) {
        if (Get-Alias $functionName -ErrorAction SilentlyContinue) {
            Remove-Item "alias:$functionName" -Force -ErrorAction SilentlyContinue
        }
    }
}

# ========== CUSTOM ALIASES ==========
# Add your custom functions/aliases below this line
# The profile will automatically detect and display them on startup
#
# To categorize your aliases, add [Category: CategoryName] in the comment above each function:
# Example: # [Category: Navigation] Go to home directory
#          function home { Set-Location ~ }

# [Category: Docker Setup] Add Docker completion and environment setup
Register-ArgumentCompleter -CommandName docker -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    docker completion powershell | Out-String | Invoke-Expression
}

# [Category: Navigation]
function work { Set-Location "C:\_work" }

# [Category: Dev Tools]
function dcu { docker compose up -d @args }

# [Category: Dev Tools]
function dcd { docker compose down @args }

# [Category: Dev Tools]
function s { serverless @args }

# [Category: Dev Tools]
function tf { terraform @args }
# [Category: Dev Tools]
function tg { terragrunt @args }
# [Category: Dev Tools]
function tfa { terraform apply -auto-approve @args }
# [Category: Dev Tools]
function tfp { terraform plan @args }

# [Category: Dev Tools]
function got { git @args }
# [Category: Dev Tools]
function gut { git @args }

# [Category: Dev Tools]
function gitpush { git push @args }
# [Category: Dev Tools]
function gp { gitpush @args }
# [Category: Dev Tools]
function gl { git pull @args }

# [Category: Dev Tools]
function g {
    git @args
}

# [Category: Dev Tools]
function p {
    pnpm @args
}

# [Category: File Operations]
function ll {
    param([string]$Path = ".")
    Get-ChildItem -Path $Path -Force | Format-Table -AutoSize
}

# [Category: Utilities]
function c {
    Clear-Host
}

# [Category: File Operations]
function tree {
    Get-ChildItem -Recurse | Format-Table FullName -AutoSize
}

# [Category: System Info]
function dush {
    param([string]$Path = ".")
    $size = Get-ChildItem -Path $Path -Recurse -File | Measure-Object -Property Length -Sum
    $sizeInMB = [math]::Round($size.Sum / 1MB, 2)
    Write-Host "$sizeInMB MB" -ForegroundColor DarkGreen
}

# [Category: System Info]
function dfh {
    Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}, @{Name="%Free";Expression={[math]::Round(($_.FreeSpace/$_.Size)*100,1)}} | Format-Table -AutoSize
}

# [Category: Network]
function curl {
    param([string]$Url)
    Invoke-WebRequest -Uri $Url
}

# [Category: Network]
function wget {
    param([string]$Url, [string]$OutFile)
    if ($OutFile) {
        Invoke-WebRequest -Uri $Url -OutFile $OutFile
    } else {
        $filename = Split-Path $Url -Leaf
        if (-not $filename) { $filename = "index.html" }
        Invoke-WebRequest -Uri $Url -OutFile $filename
    }
}

# [Category: Network]
function ping {
    param([string]$ComputerName, [int]$Count = 4)
    Test-NetConnection -ComputerName $ComputerName -Count $Count
}

# [Category: File Operations]
function tail {
    param([string]$Path, [int]$Lines = 10)
    Get-Content -Path $Path -Tail $Lines
}

# [Category: File Operations]
function wcl {
    param([string]$Path)
    (Get-Content -Path $Path | Measure-Object -Line).Lines
}

# [Category: Navigation]
function pwd {
    Get-Location
}

# [Category: File Operations]
function mkdir {
    param([string]$Path)
    New-Item -ItemType Directory -Force -Path $Path
}

# [Category: File Operations]
function touch {
    param([string]$Path)
    if (Test-Path $Path) {
        (Get-Item $Path).LastWriteTime = Get-Date
    } else {
        New-Item -ItemType File -Force -Path $Path | Out-Null
    }
}

# [Category: Utilities]
function which {
    param([string]$Command)
    Get-Command $Command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
}

# [Category: Utilities]
function where {
    param([string]$Command)
    Get-Command $Command -ErrorAction SilentlyContinue
}

# [Category: Utilities]
function open {
    param([string]$Path = ".")
    code $Path
}

# [Category: Utilities]
function alias {
    Show-PowerShellAliases
}

# ========== END CUSTOM ALIASES ==========

# Function to display all configured aliases with categorization
function Show-PowerShellAliases {
    # Display all configured aliases
    Write-Host "Aliases loaded. Available aliases:" -ForegroundColor DarkGreen
    Write-Host ""

    # Get the path of this aliases file
    $aliasesPath = $PSCommandPath
    if (-not $aliasesPath) {
        $aliasesPath = Join-Path $PSScriptRoot "aliases.ps1"
    }
    
    $aliasesContent = Get-Content $aliasesPath -Raw

    # Extract function names from aliases file using regex
    $functionMatches = [regex]::Matches($aliasesContent, 'function\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\{')
    $customFunctionNames = $functionMatches | ForEach-Object { $_.Groups[1].Value }

    if ($customFunctionNames.Count -gt 0) {
        # Parse categories from function comments automatically
        $categoryMatches = [regex]::Matches($aliasesContent, '#\s*\[Category:\s*([^\]]+)\]\s*[^\r\n]*\r?\nfunction\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\{')
        
        # Build categories dynamically from the parsed data
        $categories = [ordered]@{}
        foreach ($match in $categoryMatches) {
            $categoryName = $match.Groups[1].Value.Trim()
            $functionName = $match.Groups[2].Value
            
            if (-not $categories.Contains($categoryName)) {
                $categories[$categoryName] = @()
            }
            $categories[$categoryName] += $functionName
        }
        
        # Display categories in order
        foreach ($categoryName in $categories.Keys) {
            $categoryFunctions = $categories[$categoryName]
            $availableFunctions = $categoryFunctions | Where-Object { $_ -in $customFunctionNames }
            
            if ($availableFunctions.Count -gt 0) {
                Write-Host $categoryName -ForegroundColor DarkMagenta
                
                foreach ($funcName in $availableFunctions) {
                    $func = Get-Item "function:$funcName" -ErrorAction SilentlyContinue
                    if ($func) {
                        Write-Host "  $funcName" -ForegroundColor DarkBlue -NoNewline
                
                        # Try to extract description from function definition
                        $definition = $func.Definition
                        # Handle functions that call other functions first
                        if ($funcName -eq 'gp' -and $definition.Trim() -eq 'gitpush') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "gitpush" -ForegroundColor DarkGreen
                        } elseif ($funcName -eq 'dcu' -and $definition.Trim() -eq 'docker compose up -d') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "docker compose up -d" -ForegroundColor DarkGreen
                        } elseif ($funcName -eq 'dcd' -and $definition.Trim() -eq 'docker compose down') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "docker compose down" -ForegroundColor DarkGreen
                        } elseif ($funcName -eq 's' -and $definition.Trim() -eq 'serverless @args') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "serverless" -ForegroundColor DarkGreen
                        } elseif ($funcName -eq 'tf' -and $definition.Trim() -eq 'terraform @args') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "terraform" -ForegroundColor DarkGreen
                        } elseif ($funcName -eq 'tg' -and $definition.Trim() -eq 'terragrunt @args') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "terragrunt" -ForegroundColor DarkGreen
                        } elseif ($funcName -eq 'tfa' -and $definition.Trim() -eq 'terraform apply -auto-approve') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "terraform apply -auto-approve" -ForegroundColor DarkGreen
                        } elseif ($funcName -eq 'tfp' -and $definition.Trim() -eq 'terraform plan') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "terraform plan" -ForegroundColor DarkGreen
                        } elseif ($funcName -eq 'gitpush' -and $definition.Trim() -eq 'git push') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "git push" -ForegroundColor DarkGreen
                        } elseif ($funcName -eq 'gl' -and $definition.Trim() -eq 'git pull') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "git pull" -ForegroundColor DarkGreen
                        } elseif ($funcName -eq 'open' -and $definition -match 'code \$Path') {
                            Write-Host " - Open with VS Code" -ForegroundColor Gray
                        } elseif ($definition -match 'Set-Location "([^"]+)"') {
                            Write-Host " - Navigate to " -ForegroundColor Gray -NoNewline
                            Write-Host "$($matches[1])" -ForegroundColor DarkGreen
                        } elseif ($definition -match "Set-Location '([^']+)'") {
                            Write-Host " - Navigate to " -ForegroundColor Gray -NoNewline
                            Write-Host "$($matches[1])" -ForegroundColor DarkGreen
                        } elseif ($definition -match 'Get-ChildItem -Recurse.*Format-Table FullName') {
                            Write-Host " - Directory tree view (like " -ForegroundColor Gray -NoNewline
                            Write-Host "tree" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'Get-ChildItem.*Format-Table') {
                            Write-Host " - List files with details (like " -ForegroundColor Gray -NoNewline
                            Write-Host "ls -al" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'Clear-Host') {
                            Write-Host " - Clear screen (like " -ForegroundColor Gray -NoNewline
                            Write-Host "clear" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'Measure-Object.*Length.*Sum') {
                            Write-Host " - Directory size summary (like " -ForegroundColor Gray -NoNewline
                            Write-Host "du -sh" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'Win32_LogicalDisk') {
                            Write-Host " - Disk usage information (like " -ForegroundColor Gray -NoNewline
                            Write-Host "df -h" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'Invoke-WebRequest.*-Uri') {
                            if ($definition -match '-OutFile') {
                                Write-Host " - Download files (like " -ForegroundColor Gray -NoNewline
                                Write-Host "wget" -ForegroundColor DarkGreen -NoNewline
                                Write-Host ")" -ForegroundColor Gray
                            } else {
                                Write-Host " - HTTP requests (like " -ForegroundColor Gray -NoNewline
                                Write-Host "curl" -ForegroundColor DarkGreen -NoNewline
                                Write-Host ")" -ForegroundColor Gray
                            }
                        } elseif ($definition -match 'Test-NetConnection') {
                            Write-Host " - Network connectivity test (like " -ForegroundColor Gray -NoNewline
                            Write-Host "ping" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'Get-Content.*-Tail') {
                            Write-Host " - Show last lines of file (like " -ForegroundColor Gray -NoNewline
                            Write-Host "tail" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'Measure-Object -Line') {
                            Write-Host " - Count lines in file (like " -ForegroundColor Gray -NoNewline
                            Write-Host "wc -l" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'Get-Location') {
                            Write-Host " - Print working directory (like " -ForegroundColor Gray -NoNewline
                            Write-Host "pwd" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'New-Item.*Directory.*-Force') {
                            Write-Host " - Create directories recursively (like " -ForegroundColor Gray -NoNewline
                            Write-Host "mkdir -p" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'New-Item.*File.*-Force' -or $definition -match 'LastWriteTime.*Get-Date') {
                            Write-Host " - Create/update file timestamp (like " -ForegroundColor Gray -NoNewline
                            Write-Host "touch" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'Get-Command.*Source') {
                            Write-Host " - Find command location (like " -ForegroundColor Gray -NoNewline
                            Write-Host "which" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'Get-Command' -and $funcName -eq 'where') {
                            Write-Host " - Find command details (like " -ForegroundColor Gray -NoNewline
                            Write-Host "where" -ForegroundColor DarkGreen -NoNewline
                            Write-Host ")" -ForegroundColor Gray
                        } elseif ($definition -match 'git @args') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "git" -ForegroundColor DarkGreen
                        } elseif ($definition -match 'pnpm @args') {
                            Write-Host " - " -ForegroundColor Gray -NoNewline
                            Write-Host "pnpm" -ForegroundColor DarkGreen
                        } elseif ($definition -match 'Show-PowerShellAliases') {
                            Write-Host " - Display all configured aliases" -ForegroundColor Gray
                        } else {
                            Write-Host "" # Just newline if no description found
                        }
                    }
                }
                Write-Host "" # Add spacing between categories
            }
        }
    } else {
        Write-Host "  No custom aliases configured." -ForegroundColor Gray
    }
}

# Automatically display aliases when this file is loaded
Show-PowerShellAliases
