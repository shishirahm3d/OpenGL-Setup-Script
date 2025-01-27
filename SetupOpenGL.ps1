# PowerShell script for automating the OpenGL and Code::Blocks setup with error handling

# Step 1: Download the OpenGL setup file with retry logic
$openglUrl = "https://bfl-my.sharepoint.com/personal/shishir_ahm3d_bfl_onmicrosoft_com/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fshishir%5Fahm3d%5Fbfl%5Fonmicrosoft%5Fcom%2FDocuments%2FDIU%2FComputer%20Graphics%20Lab%2Fglut32%2Edll"
$openglDestSys32 = "C:\Windows\System32\openglsetup.exe"
$openglDestSysWOW64 = "C:\Windows\SysWOW64\openglsetup.exe"

# Function to retry download if failed
function Retry-Download {
    param (
        [string]$url,
        [string]$destination
    )
    $maxRetries = 5
    $retryCount = 0
    $success = $false

    while ($retryCount -lt $maxRetries -and !$success) {
        try {
            Invoke-WebRequest -Uri $url -OutFile $destination
            $success = $true
            Write-Host "File downloaded successfully to $destination"
        } catch {
            $retryCount++
            Write-Host "Failed to download. Retrying ($retryCount/$maxRetries)..."
            Start-Sleep -Seconds 5
        }
    }

    if (!$success) {
        Write-Host "Failed to download after $maxRetries attempts."
    }
}

# Download OpenGL setup file to both directories
Retry-Download -url $openglUrl -destination $openglDestSys32
Retry-Download -url $openglUrl -destination $openglDestSysWOW64

# Step 2: Download and extract Code::Blocks zip file
$codeblocksUrl = "https://bfl-my.sharepoint.com/personal/shishir_ahm3d_bfl_onmicrosoft_com/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fshishir%5Fahm3d%5Fbfl%5Fonmicrosoft%5Fcom%2FDocuments%2FDIU%2FComputer%20Graphics%20Lab%2Fcodeblocks%2D20%2E03%2D32bit%2Ezip"
$codeblocksZip = "C:\codeblocks.zip"
$codeblocksExtractTo = "C:\codeblocks-20.03-32bit"

# Retry downloading the Code::Blocks zip file
Retry-Download -url $codeblocksUrl -destination $codeblocksZip

# Try extracting the zip file with error handling
try {
    Expand-Archive -Path $codeblocksZip -DestinationPath $codeblocksExtractTo
    Write-Host "Code::Blocks extracted successfully."
} catch {
    Write-Host "Failed to extract Code::Blocks zip file."
}

# Step 3: Create Desktop Shortcut
$shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), "CodeBlocks.lnk")
$targetPath = "C:\codeblocks-20.03-32bit\codeblocks.exe"
$iconLocation = "C:\codeblocks-20.03-32bit\codeblocks.exe"

# Create a new COM object for creating the shortcut
try {
    $wshShell = New-Object -ComObject WScript.Shell
    $shortcut = $wshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $targetPath
    $shortcut.IconLocation = $iconLocation
    $shortcut.Save()
    Write-Host "Desktop shortcut created."
} catch {
    Write-Host "Failed to create desktop shortcut."
}

Write-Host "Setup Complete: OpenGL and Code::Blocks have been installed, and a desktop shortcut has been created."
