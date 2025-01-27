# Define URLs for downloads
$codeBlocksWithMinGWURL = "https://www.fosshub.com/Code-Blocks.html?dwl=codeblocks-20.03mingw-setup.exe"
$openGLURL = "http://freeglut.sourceforge.net/index.html"  # Replace with a direct download link if available

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
    try {
        Invoke-WebRequest -Uri $url -OutFile $destination -ErrorAction Stop
        Write-Host "Downloaded to $destination."
    } catch {
        Write-Host "Failed to download from $url. Error: $_" -ForegroundColor Red
        exit 1
    }
}

# Download and install Code::Blocks with MinGW
Write-Host "Installing Code::Blocks with MinGW..."
$codeBlocksInstaller = "$env:TEMP\codeblocks-setup.exe"
Download-File -url $codeBlocksWithMinGWURL -destination $codeBlocksInstaller
if (Test-Path $codeBlocksInstaller) {
    Start-Process -FilePath $codeBlocksInstaller -ArgumentList "/S" -Wait
    Write-Host "Code::Blocks with MinGW installed."
} else {
    Write-Host "Code::Blocks installer not found!" -ForegroundColor Red
    exit 1
}

# Download and set up OpenGL/GLUT
Write-Host "Setting up OpenGL/GLUT..."
New-Item -ItemType Directory -Force -Path $openGLPath | Out-Null
$openGLZip = "$env:TEMP\opengl.zip"
Download-File -url $openGLURL -destination $openGLZip
if (Test-Path $openGLZip) {
    Expand-Archive -Path $openGLZip -DestinationPath $openGLPath -Force
    Write-Host "OpenGL/GLUT setup completed at $openGLPath."
} else {
    Write-Host "Failed to download OpenGL/GLUT." -ForegroundColor Red
    exit 1
}

# Configure Code::Blocks to use the MinGW compiler
Write-Host "Configuring Code::Blocks to use MinGW..."
$codeBlocksUserDir = "$env:APPDATA\codeblocks"
if (-Not (Test-Path $codeBlocksUserDir)) {
    New-Item -ItemType Directory -Force -Path $codeBlocksUserDir | Out-Null
}
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
    $compilerOptions | Out-File -Encoding UTF8 $configFile
    Write-Host "Created new configuration file and added OpenGL and MinGW settings!"
}

# Copy GLUT DLL to System32
Write-Host "Copying GLUT DLL to System32..."
$glutDLL = "$openGLPath\bin\freeglut.dll"
if (Test-Path $glutDLL) {
    Copy-Item $glutDLL "C:\Windows\System32\" -Force
    Write-Host "GLUT DLL copied to System32."
} else {
    Write-Host "GLUT DLL not found at $glutDLL!" -ForegroundColor Red
    exit 1
}

Write-Host "Setup complete! You are ready to use Code::Blocks with OpenGL."
