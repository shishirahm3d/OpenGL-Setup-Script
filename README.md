# OpenGL Setup Script for Code::Blocks

This PowerShell script automates the installation and setup of **Code::Blocks with MinGW** and **OpenGL** on a Windows machine. It allows you to set up your development environment with just one command.

## Features
- Downloads and installs **Code::Blocks** with **MinGW**.
- Sets up **OpenGL** and **GLUT** libraries.
- Configures **Code::Blocks** to use the **MinGW** compiler and OpenGL libraries.

## How to Use

### Prerequisites
- **Windows Operating System**
- **PowerShell** (default on Windows)

### Instructions

1. **Open PowerShell as Administrator**:
   - Search for **PowerShell** in the Start menu, right-click it, and choose **Run as Administrator**.

2. **Run the Setup Script**:
   - Copy and paste the following command into the PowerShell window:
   ```powershell
   iwr -useb https://raw.githubusercontent.com/shishirahm3d/OpenGL-Setup-Script/main/SetupOpenGL.ps1 | iex
