# PowerShell automation script for OpenGL and Code::Blocks setup

# Step 1: Create a folder for Codeblocks-OpenGL
$setupFolder = "C:\Codeblocks-OpenGL"
if (-Not (Test-Path $setupFolder)) {
    New-Item -Path $setupFolder -ItemType Directory
    Write-Host "Created folder C:\Codeblocks-OpenGL"
} else {
    Write-Host "Folder C:\Codeblocks-OpenGL already exists."
}

# Step 2: Download the glut32.dll file
$glut32Url = "https://bfl-my.sharepoint.com/personal/shishir_ahm3d_bfl_onmicrosoft_com/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fshishir%5Fahm3d%5Fbfl%5Fonmicrosoft%5Fcom%2FDocuments%2FDIU%2FComputer%20Graphics%20Lab%2Fglut32%2Edll"
$glut32Dest = "$setupFolder\glut32.dll"
Invoke-WebRequest -Uri $glut32Url -OutFile $glut32Dest
Write-Host "glut32.dll file downloaded to $glut32Dest"

# Step 3: Copy glut32.dll to System32 and SysWOW64 directories
$sys32Dest = "C:\Windows\System32\glut32.dll"
$sysWOW64Dest = "C:\Windows\SysWOW64\glut32.dll"
Copy-Item -Path $glut32Dest -Destination $sys32Dest -Force
Copy-Item -Path $glut32Dest -Destination $sysWOW64Dest -Force
Write-Host "glut32.dll file copied to C:\Windows\System32 and C:\Windows\SysWOW64"

# Step 4: Download the Code::Blocks portable zip file
$codeblocksUrl = "https://bfl-my.sharepoint.com/personal/shishir_ahm3d_bfl_onmicrosoft_com/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fshishir%5Fahm3d%5Fbfl%5Fonmicrosoft%5Fcom%2FDocuments%2FDIU%2FComputer%20Graphics%20Lab%2Fcodeblocks%2D20%2E03%2D32bit%2Ezip"
$codeblocksZip = "C:\codeblocks.zip"
Invoke-WebRequest -Uri $codeblocksUrl -OutFile $codeblocksZip
Write-Host "Code::Blocks zip file downloaded to $codeblocksZip"

# Step 5: Extract Code::Blocks zip file to C:\
$extractPath = "C:\codeblocks-20.03-32bit"
Expand-Archive -Path $codeblocksZip -DestinationPath $extractPath -Force
Write-Host "Code::Blocks extracted to $extractPath"

# Step 6: Create a Desktop shortcut for Code::Blocks
$shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), "CodeBlocks.lnk")
$targetPath = "C:\codeblocks-20.03-32bit\codeblocks.exe"
$iconLocation = "C:\codeblocks-20.03-32bit\codeblocks.exe"

# Create a new COM object for creating the shortcut
$wshShell = New-Object -ComObject WScript.Shell
$shortcut = $wshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetPath
$shortcut.IconLocation = $iconLocation
$shortcut.Save()
Write-Host "Desktop shortcut created at $shortcutPath"

Write-Host "Setup Complete: glut32.dll, OpenGL, and Code::Blocks have been installed, and a desktop shortcut has been created."
