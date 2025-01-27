# PowerShell script for automating the OpenGL and Code::Blocks setup

# Step 1: Download the OpenGL setup file
$openglUrl = "https://github.com/7b4b7ca4-9dd3-4ee1-befe-b0a3c8b1a908"
$openglDestSys32 = "C:\Windows\System32\openglsetup.exe"
$openglDestSysWOW64 = "C:\Windows\SysWOW64\openglsetup.exe"

# Download the OpenGL setup file to both directories
Invoke-WebRequest -Uri $openglUrl -OutFile $openglDestSys32
Invoke-WebRequest -Uri $openglUrl -OutFile $openglDestSysWOW64

# Step 2: Download the Code::Blocks zip file
$codeblocksUrl = "https://drive.google.com/uc?id=1SnXUPpVDogjJ3zyys4hAps5VOG6Yl7i7&export=download"
$codeblocksZip = "C:\codeblocks.zip"
$codeblocksExtractTo = "C:\codeblocks-20.03-32bit"

# Download the Code::Blocks zip file
Invoke-WebRequest -Uri $codeblocksUrl -OutFile $codeblocksZip

# Extract the Code::Blocks zip file
Expand-Archive -Path $codeblocksZip -DestinationPath $codeblocksExtractTo

# Step 3: Create Desktop Shortcut
$shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), "CodeBlocks.lnk")
$targetPath = "C:\codeblocks-20.03-32bit\codeblocks.exe"
$iconLocation = "C:\codeblocks-20.03-32bit\codeblocks.exe"

# Create a new COM object for creating the shortcut
$wshShell = New-Object -ComObject WScript.Shell
$shortcut = $wshShell.CreateShortcut($shortcutPath)

# Set the properties of the shortcut
$shortcut.TargetPath = $targetPath
$shortcut.IconLocation = $iconLocation
$shortcut.Save()

Write-Host "Setup Complete: OpenGL and Code::Blocks have been installed, and a desktop shortcut has been created."
