# CutiePi Shell

A Qt/QML tablet shell for Raspberry Pi OS style deployments.

This repository contains:

- The main shell application (browser-first UI, settings, lock/power flows)
- A systray helper application (battery/rotation integration)
- Runtime assets under source/opt/cutiepi-shell
- Service wiring for system startup
- Project documentation under docs/

## Current Project State

- Version: 0.0.1 (from VERSION)
- UI stack: Qt Widgets + Qt Quick/QML + QtWebEngine
- Network integration in QML: NetworkManager DBus
- Optional adblocking path: Brave ad-block library (build-time define)
- Deployment target layout assumes /opt/cutiepi-shell runtime assets

Reference architecture documentation:

- docs/ARCHITECTURE.md

## Repository Layout

- source/app
	- Main shell C++ entry point and backlight integration
	- qmake project for shell binary
- source/opt/cutiepi-shell
	- Shell QML, dialogs, JavaScript tab logic, launcher script, assets
- source/systray
	- Separate systray Qt/QML helper
- source/lib/systemd/system
	- Systemd service unit
- docs
	- ADRs, architecture docs, code review cycles, job aids, roadmap, etc.

## Features

- Touch-first full-screen shell UI
- Tabbed web browsing with side drawer
- Built-in settings app tab and factory mode tab
- Virtual keyboard integration
- Wi-Fi scan/connect flow through DBus
- Battery and charging status integration
- Orientation handling and lock/power-off interactions

## Build

This project uses qmake projects in source/app and source/systray.

### Main shell

From source/app:

```bash
qmake
make
```

Optional adblock build:

```bash
qmake DEFINES+=USE_ADBLOCK
make
```

If USE_ADBLOCK is enabled, third-party ad-block dependencies referenced in source/app/README.md must be available.

### Systray helper

From source/systray:

```bash
qmake
make
```

## Runtime Dependencies

- Qt (project imports indicate Qt 5.15-era modules)
- QtWebEngine
- Nemo DBus QML plugin
- Process QML plugin used by shell and systray
- Yat terminal QML plugin
- NetworkManager DBus service for Wi-Fi UI paths
- SensorProxy DBus service for orientation paths
- MCU integration services/plugins used by platform deployment

## Runtime and Deployment Notes

- Runtime assets are expected under /opt/cutiepi-shell.
- The service unit is at source/lib/systemd/system/cutiepi-shell.service.
- Launcher script is source/opt/cutiepi-shell/cutiepi-shell.

Important: the launcher script sets QT_QPA_PLATFORM=eglfs while source/app/main.cpp sets QT_QPA_PLATFORM=xcb at process startup. This should be treated as an active deployment ambiguity until unified.

## Documentation

- Architecture: docs/ARCHITECTURE.md
- Contributor guidance: CONTRIBUTING.md
- Rules of engagement: AGENTS.md
- Review cycles: docs/code-review/

## License

- Source code is licensed under GPL-3.0-or-later (see LICENSE).
- Documentation licensing and third-party asset/license attributions should be maintained as documented in repository materials.
