# Define URLs for downloads
$codeBlocksURL = "https://www.fosshub.com/Code-Blocks.html?dwl=codeblocks-20.03-setup.exe"
$openGLURL = "http://freeglut.sourceforge.net/index.html"  # Update with a direct download link if possible

# Define installation paths
$installPath = "C:\CodeBlocks"
$openGLPath = "C:\OpenGL"

# Function to download a file
function Download-File {
    param (
        [string]$url,
        [string]$destination
    )
    Write-Host "Downloading from $url..."
    Invoke-WebRequest -Uri $url -OutFile $destination
    Write-Host "Downloaded to $destination."
}

# Download and install Code::Blocks
Write-Host "Installing Code::Blocks..."
$codeBlocksInstaller = "$env:TEMP\codeblocks-setup.exe"
Download-File -url $codeBlocksURL -destination $codeBlocksInstaller
Start-Process -FilePath $codeBlocksInstaller -ArgumentList "/S" -Wait  # Silent install
Write-Host "Code::Blocks installed at $installPath."

# Download and set up OpenGL/GLUT
Write-Host "Setting up OpenGL/GLUT..."
New-Item -ItemType Directory -Force -Path $openGLPath
$openGLZip = "$env:TEMP\opengl.zip"
Download-File -url $openGLURL -destination $openGLZip
Expand-Archive -Path $openGLZip -DestinationPath $openGLPath -Force

# Configure Code::Blocks
Write-Host "Configuring Code::Blocks..."
$codeBlocksUserDir = "$env:APPDATA\codeblocks"
$compilerOptions = @"
[Compiler]
Add="-I$openGLPath\include"
Add="-L$openGLPath\lib"
Add="-lglu32 -lopengl32 -lfreeglut"
"@
$configFile = Join-Path $codeBlocksUserDir "default.conf"
if (Test-Path $configFile) {
    $compilerOptions | Out-File -Append -Encoding UTF8 $configFile
    Write-Host "OpenGL configuration added to Code::Blocks!"
} else {
    Write-Host "Code::Blocks configuration file not found!"
}

# Copy GLUT DLL to System32
Write-Host "Copying GLUT DLL to System32..."
Copy-Item "$openGLPath\bin\freeglut.dll" "C:\Windows\System32\" -Force
Write-Host "Setup complete!"
