#!/bin/bash
set -e

URL="$1"

if [ -z "$URL" ]; then
  echo "Usage: $0 <artifact-url>"
  exit 1
fi

FILE=$(basename "$URL")

echo "Downloading $FILE..."

# Use env vars if available, else prompt
USERNAME=${BUILD_USERNAME:-}
PASSWORD=${BUILD_PASSWORD:-}

if [ -z "$USERNAME" ]; then
  read -p "Enter username: " USERNAME
fi

if [ -z "$PASSWORD" ]; then
  read -s -p "Enter password: " PASSWORD
  echo
fi

# Download with auth + progress
curl -fL --progress-bar \
  -u "$USERNAME:$PASSWORD" \
  -o "$FILE" "$URL"

echo
echo "✅ Saved as $FILE"

echo "Extracting $FILE..."
mkdir -p openspecimen-install
unzip -q -o "$FILE" -d openspecimen-install

echo "✅ OpenSpecimen downloaded and extracted to ./openspecimen-install"
echo "Please proceed with database setup and Tomcat deployment."
