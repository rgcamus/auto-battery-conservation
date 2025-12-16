# Auto Battery Conservation

A simple bash script to manage battery conservation mode on Lenovo laptops (specifically IdeaPad series using the `ideapad_acpi` driver). This tool allows you to set a desired charge threshold (e.g., 60%) to prolong battery life.

## Features

- **Set Threshold**: Configure a custom battery charge threshold (50-80%).
- **Get Status**: Check the current battery level and the configured threshold.
- **Full Charge**: Quickly force a full charge (100%).
- **Automatic Management**: Runs as a systemd service to automatically apply the threshold.
- **System Logging**: Logs actions to syslog for monitoring.

## Installation

### Using the .deb package (Recommended for Ubuntu 24.04 LTS)

1. Download the `.deb` package (e.g., `auto-battery-conservation_1.0_all.deb`).
2. Install it using `apt`:

   ```bash
   sudo apt install ./auto-battery-conservation_1.0_all.deb
   ```

   This will automatically:

   - Install the script to `/usr/local/bin/auto-battery-conservation`.
   - Install and enable the systemd service and timer.
   - Start the service immediately.

3. Verify installation:

   ```bash
   auto-battery-conservation --help
   sudo systemctl status auto-battery-conservation.timer
   ```

### Manual Installation

If you prefer to install manually:

```bash
sudo ./install.sh
```

## Usage

Run the script with `sudo` privileges to change settings.

### Show Help

```bash
auto-battery-conservation --help
```

### Check Status

```bash
auto-battery-conservation --get
```

### Set Conservation Threshold

Set the charge limit to 60%:

```bash
sudo auto-battery-conservation --set 60
```

_Note: Valid values are between 50 and 80._

### Force Full Charge

Disable conservation mode and charge to 100%:

```bash
sudo auto-battery-conservation --full
```

## License

This project is licensed under the [Creative Commons Zero v1.0 Universal](LICENSE.md) (Public Domain).
