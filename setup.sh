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
INIT_SYSTEM_COUNT=0

if [ -x "$(command -v systemctl)" ]; then
  printf "$INFO Systemd detected.\n"
  INIT_SYSTEM_COUNT=$((INIT_SYSTEM_COUNT + 1))
  eval "INIT_SYSTEM_${INIT_SYSTEM_COUNT}=Systemd"
fi

if [ -x "$(command -v openrc-init)" ]; then
  printf "$INFO OpenRC detected.\n"
  INIT_SYSTEM_COUNT=$((INIT_SYSTEM_COUNT + 1))
  eval "INIT_SYSTEM_${INIT_SYSTEM_COUNT}=OpenRC"
fi

if [ -x "$(command -v dinit)" ]; then
  printf "$INFO Dinit detected.\n"
  INIT_SYSTEM_COUNT=$((INIT_SYSTEM_COUNT + 1))
  ((INIT_SYSTEM_COUNT++))
  eval "INIT_SYSTEM_${INIT_SYSTEM_COUNT}=Dinit"
fi

if [ -x "$(command -v runit)" ]; then
  printf "$INFO Runit detected.\n"
  INIT_SYSTEM_COUNT=$((INIT_SYSTEM_COUNT + 1))
  eval "INIT_SYSTEM_${INIT_SYSTEM_COUNT}=Runit"
fi

if [ -x "$(command -v s6-init)" ]; then
  printf "$INFO S6 detected.\n"
  INIT_SYSTEM_COUNT=$((INIT_SYSTEM_COUNT + 1))
  eval "INIT_SYSTEM_${INIT_SYSTEM_COUNT}=S6"
fi

install_init() {
  case ${1} in
    "systemd")
      make install_systemd
      systemctl enable ntfy-resources-usage.service
      ;;

    "openrc")
      make install_openrc
      rc-update add ntfy-resources-usage
      ;;

    "dinit")
      make install_dinit
      #TODO add dinit enable here
      ;;

    "runit")
      make install_runit
      #TODO add runit enable here
      ;;

    "s6")
      make install_s6
      #TODO add runit enable here
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

  printf "$INFO Installed the \`${1}' init service file. Reboot after setup to start it.\n"
}

if [ ${INIT_SYSTEM_COUNT} -gt 1 ]; then
  printf "$INFO Multiple init systems were detected in the system. Please choose which init service to use: [1-${INIT_SYSTEM_COUNT} / C(ancel)]\n"
  for INIT_NUM in ; do
    TMP_INIT_VAR_NAME="INIT_SYSTEM_${INIT_NUM}"
    printf "${INIT_NUM}) ${!TMP_INIT_VAR_NAME}\n"
  done
  printf "C) Cancel\n"

  read INIT_CHOICE
  if [ $(echo "$INIT_CHOICE" | tr '[:upper:]' '[:lower:]') != c ]; then
    TMP_INIT_VAR_NAME=INIT_SYSTEM_${INIT_NUM}
    TMP_INIT_VAR_NAME=$(echo "${!TMP_INIT_VAR_NAME}" | tr '[:upper:]' '[:lower:]')
  else
    TMP_INIT_VAR_NAME=c
  fi

elif [ ${INIT_SYSTEM_COUNT} -eq 1 ]; then
  TMP_INIT_VAR_NAME=$(echo "${INIT_SYSTEM_1}" | tr '[:upper:]' '[:lower:]')

else  # if Systemd or OpenRC couldn't be found in the system
  printf "$ERR Init system couldn't be found!\n"
  printf "$ERR You have to run \`ntfy-resources-usage' manually from now on.\n"
  printf "$ERR More info at \`https://github.com/TheRealOne78/ntfy-resources-usage/wiki'\n"
  ERR_NO_INIT=true
fi

# Actually installing the script
if [ "${ERR_NO_INIT}" != true ]; then
   install_init ${TMP_INIT_VAR_NAME}
fi

printf "$INFO You can now edit the variables in '/etc/ntfy-resources-usage/ntfy-resources-usage.conf'\n"
printf "$INFO More info at https://github.com/TheRealOne78/ntfy-resources-usage/wiki\n"
