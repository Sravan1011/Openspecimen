#!/bin/bash

set -e

# -------------------------------
# INPUT: Artifact URL
# -------------------------------
URL="$1"

if [ -z "$URL" ]; then
  echo "Usage: $0 <artifact-url>"
  exit 1
fi

FILE=$(basename "$URL")

# -------------------------------
# AUTH (env or prompt)
# -------------------------------
USERNAME=${BUILD_USERNAME:-}
PASSWORD=${BUILD_PASSWORD:-}

if [ -z "$USERNAME" ]; then
  read -p "Enter username: " USERNAME
fi

if [ -z "$PASSWORD" ]; then
  read -s -p "Enter password: " PASSWORD
  echo
fi

# -------------------------------
# DOWNLOAD OPENSPECIMEN
# -------------------------------
echo "Downloading $FILE..."

curl -fL --progress-bar \
  -u "$USERNAME:$PASSWORD" \
  -o "$FILE" "$URL"

echo
echo "✅ Saved as $FILE"

echo "Extracting $FILE..."
mkdir -p openspecimen-install
unzip -q -o "$FILE" -d openspecimen-install

echo "✅ OpenSpecimen extracted to ./openspecimen-install"

# -------------------------------
# MYSQL SETUP
# -------------------------------
echo "Updating packages..."
apt update

echo "Installing MySQL Server..."
DEBIAN_FRONTEND=noninteractive apt install -y mysql-server

echo "Checking if MySQL is running..."
if ! mysqladmin ping --silent; then
  echo "Starting MySQL..."
  mysqld_safe &
fi

echo "Waiting for MySQL..."
until mysqladmin ping --silent; do
  sleep 2
done

echo "Configuring MySQL..."

mysql -u root <<EOF

CREATE DATABASE IF NOT EXISTS openspecimen
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'openspecimen'@'localhost'
IDENTIFIED BY 'StrongPass123!';

GRANT ALL PRIVILEGES ON openspecimen.* TO 'openspecimen'@'localhost';

FLUSH PRIVILEGES;

EOF

echo "✅ MySQL setup complete!"

# -------------------------------
# VERIFY SETUP
# -------------------------------
echo "Verifying MySQL user..."

mysql -u root -e "SELECT user, host FROM mysql.user;" | grep openspecimen && \
echo "✅ User exists" || echo "❌ User not found"

echo
echo "🎉 Setup complete!"
echo "Next steps:"
echo "1. Configure OpenSpecimen with DB:"
echo "   DB: openspecimen"
echo "   User: openspecimen"
echo "   Password: StrongPass123!"
echo "2. Deploy to Tomcat"
