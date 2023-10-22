# Scripts for my Raspberry Pi 4

These scripts makes easier to start containerized services on my Raspberry Pi 4.

There are 3 kind of the scripts:
  - install: scripts to help installation of docker, hacs, etc.
  - services: these scripts starts the containerized services
  - utils: there are some useful scripts to maintain the rpi

## How to use  the rpictl utility

To start a service use:

```bash
rpictl.sh --start <service_name>
```

To get a service status use:

```bash
rpictl.sh --status <service_name>
```

To update a service use:

```bash
rpictl.sh --update <service_name>
```
