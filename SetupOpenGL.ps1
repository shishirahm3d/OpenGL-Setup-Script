# Define URLs for downloads
$codeBlocksWithMinGWURL = "https://www.fosshub.com/Code-Blocks.html?dwl=codeblocks-20.03mingw-setup.exe#"
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

# Download and install Code::Blocks with MinGW
Write-Host "Installing Code::Blocks with MinGW..."
$codeBlocksInstaller = "$env:TEMP\codeblocks-setup.exe"
Download-File -url $codeBlocksWithMinGWURL -destination $codeBlocksInstaller
Start-Process -FilePath $codeBlocksInstaller -ArgumentList "/S" -Wait  # Silent install
Write-Host "Code::Blocks with MinGW installed at $installPath."

# Download and set up OpenGL/GLUT
Write-Host "Setting up OpenGL/GLUT..."
New-Item -ItemType Directory -Force -Path $openGLPath
$openGLZip = "$env:TEMP\opengl.zip"
Download-File -url $openGLURL -destination $openGLZip
Expand-Archive -Path $openGLZip -DestinationPath $openGLPath -Force

# Configure Code::Blocks to use the MinGW compiler
Write-Host "Configuring Code::Blocks to use MinGW..."
$codeBlocksUserDir = "$env:APPDATA\codeblocks"
$compilerOptions = @"
[Compiler]
Add="-IC:\OpenGL\include"
Add="-LC:\OpenGL\lib"
Add="-lglu32 -lopengl32 -lfreeglut"
"@
$configFile = Join-Path $codeBlocksUserDir "default.conf"
if (Test-Path $configFile) {
    $compilerOptions | Out-File -Append -Encoding UTF8 $configFile
    Write-Host "OpenGL and MinGW configuration added to Code::Blocks!"
} else {
    Write-Host "Code::Blocks configuration file not found!"
}

# Copy GLUT DLL to System32
Write-Host "Copying GLUT DLL to System32..."
Copy-Item "$openGLPath\bin\freeglut.dll" "C:\Windows\System32\" -Force
Write-Host "Setup complete!"
