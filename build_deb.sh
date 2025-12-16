#!/bin/bash
set -e

VERSION="1.0"
ARCH="all"
PKG_NAME="auto-battery-conservation"
DEB_NAME="${PKG_NAME}_${VERSION}_${ARCH}.deb"
BUILD_DIR="build_deb"
PKG_ROOT="$BUILD_DIR/$PKG_NAME"

echo "Building $DEB_NAME..."

# Clean up previous build
rm -rf "$BUILD_DIR"
mkdir -p "$PKG_ROOT/DEBIAN"
mkdir -p "$PKG_ROOT/usr/sbin"
mkdir -p "$PKG_ROOT/etc/systemd/system"

# Copy files
echo "Copying files..."
cp auto-battery-conservation "$PKG_ROOT/usr/sbin/"
chmod 755 "$PKG_ROOT/usr/sbin/auto-battery-conservation"

cp auto-battery-conservation.service "$PKG_ROOT/etc/systemd/system/"
cp auto-battery-conservation.timer "$PKG_ROOT/etc/systemd/system/"

# Create control file
echo "Creating control file..."
cat <<EOF > "$PKG_ROOT/DEBIAN/control"
Package: $PKG_NAME
Version: $VERSION
Architecture: $ARCH
Maintainer: Your Name <your.email@example.com>
Description: Lenovo battery conservation mode manager
 A script to automatically enforce battery conservation thresholds
 on Lenovo IdeaPad laptops using the ideapad_acpi driver.
EOF

# Create postinst script
echo "Creating postinst script..."
cat <<EOF > "$PKG_ROOT/DEBIAN/postinst"
#!/bin/bash
set -e

if [ "\$1" = "configure" ]; then
    echo "Reloading systemd daemon..."
    systemctl daemon-reload
    echo "Enabling and starting auto-battery-conservation.timer..."
    systemctl enable --now auto-battery-conservation.timer
fi
EOF
chmod 755 "$PKG_ROOT/DEBIAN/postinst"

# Create prerm script
echo "Creating prerm script..."
cat <<EOF > "$PKG_ROOT/DEBIAN/prerm"
#!/bin/bash
set -e

if [ "\$1" = "remove" ]; then
    echo "Stopping and disabling auto-battery-conservation.timer..."
    systemctl disable --now auto-battery-conservation.timer || true
    systemctl stop auto-battery-conservation.service || true
fi
EOF
chmod 755 "$PKG_ROOT/DEBIAN/postinst"
chmod 755 "$PKG_ROOT/DEBIAN/prerm"


# Create postrm script
echo "Creating postrm script..."
cat <<EOF > "$PKG_ROOT/DEBIAN/postrm"
#!/bin/bash
set -e

if [ "\$1" = "remove" ]; then
    echo "Reloading systemd daemon..."
    systemctl daemon-reload
fi
EOF
chmod 755 "$PKG_ROOT/DEBIAN/postrm"


# Build package
echo "Building package..."
dpkg-deb --build "$PKG_ROOT" "$DEB_NAME"

echo "Done! Package created: $DEB_NAME"
# Verify contents
dpkg-deb --contents "$DEB_NAME"
