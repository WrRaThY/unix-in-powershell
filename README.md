# Human description

Normally, I use `gitbash+zsh` as a terminal on windows, but... some tools don't play well with it  
which means I sometimes need to switch to PowerShell and all my muscle memory goes to hell  
so I vibecoded myself (thanks https://www.warp.dev/ :D) aliases for common unix functions  
I added some additional aliases based on my .bashrc and magic happened. It actually works!
this file is ugly as hell, but it gets the job done, so hey. why not just use it? :D  
hopefully this will be of use to someone else as well!  

# everything apart from the human description has been vibecooded. use at your own risk

# PowerShell Aliases with Beautiful Color-Coded Categorization

A comprehensive collection of useful PowerShell aliases with automatic categorization and beautiful colored display. Transform your PowerShell experience with Unix-like commands and development tools shortcuts.

## ✨ Features

- 🎨 **Beautiful Color-Coded Display** - Categories in DarkMagenta, aliases in DarkBlue, commands in DarkGreen
- 📂 **Automatic Categorization** - Organized into logical groups (Navigation, Dev Tools, File Operations, etc.)
- 🔧 **Unix-like Commands** - Familiar commands like `ls`, `grep`, `curl`, `wget`, `touch`, `which`
- ⚡ **Development Tools** - Shortcuts for Docker, Git, Terraform, Serverless, and more
- 🔄 **Easy to Extend** - Simple category system for adding your own aliases
- 📋 **Self-Documenting** - Run `alias` to see all available commands with descriptions

## 📦 Installation

### Step 1: Find Your PowerShell Profile Directory

First, determine your PowerShell profile directory by running this command in PowerShell:

```powershell
Split-Path $PROFILE
```

The location depends on your PowerShell version:
- **Windows PowerShell 5.1**: `$HOME\Documents\WindowsPowerShell\`
- **PowerShell 7+**: `$HOME\Documents\PowerShell\`

### Step 2: Create the Profile Directory (if needed)

If the directory doesn't exist, create it:

```powershell
$profileDir = Split-Path $PROFILE
if (!(Test-Path $profileDir)) {
    New-Item -ItemType Directory -Force -Path $profileDir
    Write-Host "Created profile directory: $profileDir" -ForegroundColor Green
}
```

### Step 3: Download and Install the Files

Download these two files and place them in your PowerShell profile directory:

1. **`Microsoft.PowerShell_profile.ps1`** - Main profile file that loads automatically
2. **`PowerShell_aliases.ps1`** - Contains all the aliases and display logic

You can download them directly to the correct location:

```powershell
# Navigate to your profile directory
cd (Split-Path $PROFILE)

# Download the files (replace URLs with actual download links)
# Invoke-WebRequest -Uri "URL_TO_PROFILE_FILE" -OutFile "Microsoft.PowerShell_profile.ps1"
# Invoke-WebRequest -Uri "URL_TO_ALIASES_FILE" -OutFile "PowerShell_aliases.ps1"
```

Or manually copy the files to your profile directory.

### Step 4: Verify Installation

Check if the files are in the correct location:

```powershell
Test-Path $PROFILE
Test-Path (Join-Path (Split-Path $PROFILE) "PowerShell_aliases.ps1")
```

Both commands should return `True`.

### Step 5: Reload Your Profile

Restart PowerShell or reload your profile:

```powershell
. $PROFILE
```

You should see the beautiful color-coded aliases display automatically!

## 🎯 Quick Start

After installation, try these commands:

```powershell
# See all available aliases
alias

# Navigate around
work          # Navigate to your work directory (customize the path)
ll            # List files with details (like ls -al)
ll src/       # List files in src directory
pwd           # Print working directory

# Development tools
dcu           # Docker compose up -d
dcd           # Docker compose down
g status      # Git status (g is shorthand for git)
tf plan       # Terraform plan

# File operations
touch file.txt    # Create or update file timestamp
mkdir -p dir/sub  # Create directories recursively
tail log.txt      # Show last 10 lines of file
```

## 🔧 Customization

### Adding Your Own Aliases

1. Open the aliases file:
   ```powershell
   code (Join-Path (Split-Path $PROFILE) "PowerShell_aliases.ps1")
   ```

2. Add your alias with a category comment:
   ```powershell
   # [Category: Your Category]
   function your-alias {
       # Your command here
   }
   ```

3. Reload your profile:
   ```powershell
   . $PROFILE
   ```

### Customizing the Work Directory

Edit the `work` function in `PowerShell_aliases.ps1` to point to your actual work directory:

```powershell
# [Category: Navigation]
function work { Set-Location "C:\path\to\your\work\directory" }
```

## 📋 Available Categories

- **Navigation** - Directory navigation shortcuts
- **Dev Tools** - Development tools (Docker, Git, Terraform, etc.)
- **File Operations** - File and directory operations
- **Utilities** - General utility commands
- **System Info** - System information commands
- **Network** - Network-related commands

## 🎨 Color Scheme

- **Categories** (Navigation, Dev Tools, etc.) - **DarkMagenta**
- **Alias names** (work, dcu, tf, etc.) - **DarkBlue**
- **Commands and paths** - **DarkGreen**
- **Descriptions** - **Gray**

## 🔍 Troubleshooting

### Profile Not Loading
If your profile isn't loading automatically:

```powershell
# Check if profile exists
Test-Path $PROFILE

# Check execution policy
Get-ExecutionPolicy

# If restricted, set to RemoteSigned (run as Administrator)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Aliases Not Showing
If aliases aren't displaying:

```powershell
# Manually run the aliases file
. (Join-Path (Split-Path $PROFILE) "PowerShell_aliases.ps1")

# Check for errors
$Error[0]
```

### Colors Not Displaying
If colors aren't showing correctly, your terminal might not support them. Try:
- Windows Terminal (recommended)
- PowerShell 7+ 
- Update your console settings

## 📚 Unix Command Equivalents

This system provides PowerShell equivalents for many Unix commands:

| Unix Command | PowerShell Alias | Description |
|--------------|------------------|-------------|
| `ls -al` | `ll` | List files with details |
| `pwd` | `pwd` | Print working directory |
| `clear` | `c` | Clear screen |
| `touch` | `touch` | Create/update file |
| `mkdir -p` | `mkdir` | Create directories |
| `which` | `which` | Find command location |
| `curl` | `curl` | HTTP requests |
| `wget` | `wget` | Download files |
| `tail` | `tail` | Show last lines of file |
| `du -sh` | `dush` | Directory size summary |
| `df -h` | `dfh` | Disk usage information |

## 🤝 Contributing

Feel free to fork and customize this system! The modular design makes it easy to:
- Add new categories
- Create custom aliases
- Modify the color scheme
- Extend functionality

## 📄 License

This project is open source and available under the MIT License.

---

**Enjoy your enhanced PowerShell experience!** 🚀