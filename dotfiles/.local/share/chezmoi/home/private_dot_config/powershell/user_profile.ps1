# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

### Oh My Posh
oh-my-posh init pwsh --config "$env:HOME/.config/oh-my-posh/Betelgeuse.omp.json" | Invoke-Expression

# Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Vim
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

### zoxide
Invoke-Expression (& {
  $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
  (zoxide init --hook $hook powershell | Out-String)
})

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

### Aliases
Set-Alias grep findstr

### Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
