**NOTE**: This document refers only for installs made by the methods in this very document. ntfy-resources-usage developers are not responsible in any way for broken third party installs like unofficial distributions packages that are broken.

# Installing

## Automatically
The easiest and fastest method is by executing the following command:
```bash
root# bash ./setup.sh
```
This will ensure every dependency will be installed and it will install ntfy-resources-usage to the system.<br>
If the manual installing is the wanted option, the text below will explain how.

## Compiling

### Installing the dependencies
The easiest approach is by running the `configure.sh` script:<br>

```bash
root# bash ./configure.sh
```
This bash script will automatically check and install all dependencies via the package manager the system is using.
The following package managers are available:
* apt-get   (Debian, Ubuntu, Pop!_OS, Mint, etc.)
* pacman    (Arch, Artix, Arco, Manjaro, etc.)
* dnf       (Fedora)
* pkg       (FreeBSD, (probaly Termux as well))
* pkg_add   (OpenBSD)
* pkgin     (NetBSD)

If the system does not have any of these package managers, the next approach may be the solution. Gentoo Linux and CentOS Linux are some examples of distributions that are not compatible for automatic dependencies install.<br>

The manual approach is by selecting the packages and install them manually.
The dependencies ntfy-resources-usage needs for executing are the following:
* bash
* make      (for Linux based systems)
* gmake     (for BSD based systems)
* curl

**NOTE**: From system to system, the packages may have different name!

### Installing
Installing is easy as pie, the only command needed is the following:
```bash
root# make install
```

You also have to make sure you install an init service, or else you'll have to start ntfy-resources-usage manually each time you start you boot your computer.
```bash
# For Systemd users
root# make install_systemd

# For OpenRC users
root# make install_openrc
```

# Uninstalling
Uninstalling the plugin can be made by running the following command:
```bash
root# make uninstall
```
