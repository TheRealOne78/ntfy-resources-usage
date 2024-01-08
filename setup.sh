#!/bin/sh
#
# Copyright (c) 2024 TheRealOne78
# Distributed under the terms of the GNU General Public License v3+
# https://www.gnu.org/licenses/gpl-3.0.en.html

RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[34m"
ENDCOLOR="\033[0m"

INFO="["$BLUE"i"$ENDCOLOR"]"
WARN="["$YELLOW"w"$ENDCOLOR"]"
ERR="["$RED"e"$ENDCOLOR"]"

# Check for root
if [ "$EUID" -ne 0 ]; then
  printf "$ERR Please run this script with super user permission!\n"
  exit $EUID
fi

# Install Dependencies
bash ./configure.sh
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  exit $EXIT_CODE;
fi

# Install
printf "$INFO Installing ntfy-resources-usage and configuration file\n"
## BSD family
if [ -x "$(command -v pkg)" ] || [ -x "$(command -v pkg_add)" ] || [ -x "$(command -v pkgin)" ]; then
  gmake install install_config
## Linux
else
  make install install_config
fi
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  printf "$ERR Couldn't install! Please check if all dependencies are installed correctly!\n"
  exit $EXIT_CODE
fi

# Install init service
if [ -x "$(command -v systemctl)" ]; then
  printf "$INFO Systemd detected.\n"
  SYSTEMD=true
fi

if [ -x "$(command -v openrc-init)" ]; then
  printf "$INFO OpenRC detected.\n"
  OPENRC=true
fi

install_init() {
  case $INIT_CHOICE in
    1)
      make install_systemd
      systemctl enable ntfy-resources-usage.service
      ;;
    2)
      make install_openrc
      rc-update add ntfy-resources-usage
      ;;
    c)
      printf "$INFO Exiting ...\n"
      exit 0
      ;;
    *)
      printf "$ERR Wrong choice '$INIT_CHOICE'\n"
      exit 1
      ;;
    esac
}

if [ "${SYSTEMD}" = true ] && [ "${OPENRC}" = true ]; then
  printf "$INFO Both Systemd and OpenRC were detected to the system. Please choose which init service to use: [1-2/c]\n"
  printf "1) Systemd\n"
  printf "2) OpenRC\n"
  printf "c) Cancel\n"

  read INIT_CHOICE
  install_init

elif [ "${SYSTEMD}" = true ]; then
  INIT_CHOICE=1
  install_init
  printf "$INFO Installed Systemd service. Reboot after setup to start it.\n"

elif [ $OPENRC == true ]; then
  INIT_CHOICE=2
  install_init
  printf "$INFO Installed OpenRC service. Reboot after setup to start it.\n"

else  # if Systemd or OpenRC couldn't be found in the system
  printf "$ERR Init system couldn't be found!\n"
  printf "$ERR You have to run 'ntfy-resources-usage' manually from now on.\n"
  printf "$ERR More info at https://github.com/TheRealOne78/ntfy-resources-usage/wiki\n"
fi

printf "$INFO You can now edit the variables in '/etc/ntfy-resources-usage/ntfy-resources-usage.conf'\n"
printf "$INFO More info at https://github.com/TheRealOne78/ntfy-resources-usage/wiki\n"
