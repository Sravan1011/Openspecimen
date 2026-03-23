# OpenSpecimen Setup

This repository contains a shell script to automate the downloading and extraction of OpenSpecimen.

## Scripts

### `download.sh`
This script securely downloads an OpenSpecimen build artifact from a password-protected build server and extracts it to a local directory.

**Usage:**
```bash
./download.sh <build-server-url>
```

**Example:**
```bash
./download.sh https://build-server.com/path/to/openspecimen.zip
```

The script will prompt you for your `username` and `password` if they are not already exported as Environment Variables (`BUILD_USERNAME` and `BUILD_PASSWORD`).

## Pushing to GitHub

To push your code to your remote repository for the first time, run:

```bash
git add .
git commit -m "Initial commit: Added download and install script"
git branch -M main
git remote add origin https://github.com/Sravan1011/Openspecimen.git
git push -u origin main
```
