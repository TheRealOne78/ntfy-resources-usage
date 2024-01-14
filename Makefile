# Copyright (c) 2024 TheRealOne78
# Distributed under the terms of the GNU General Public License v3+
# https://www.gnu.org/licenses/gpl-3.0.en.html

SRC = ./src/
BIN = $(SRC)./ntfy-resources-usage
INSTALL_DIR = /usr/bin/

INIT_DIR_SRC = $(SRC)./init/

CONF_DIR = /etc/
CONF_DIR_FINAL = $(CONF_DIR)ntfy-resources-usage/
CONF_FILE = ./src/config/ntfy-resources-usage.conf
AUTH_FILE = ./src/config/auth

# systemd
SYSTEMD_INSTALL_DIR = /etc/systemd/system/
SYSTEMD_BIN = $(INIT_DIR_SRC)./systemd
SYSTEMD_FINAL_BIN = ntfy-resources-usage.service

# openrc
OPENRC_INSTALL_DIR = /etc/init.d/
OPENRC_BIN = $(INIT_DIR_SRC)./openrc
OPENRC_FINAL_BIN = ntfy-resources-usage

# dinit
DINIT_INSTALL_DIR = /etc/dinit/
DINIT_BIN = $(INIT_DIR_SRC)./dinit
DINIT_FINAL_BIN = ntfy-resources-usage.conf

## runit
#RUNIT_INSTALL_DIR =
#RUNIT_BIN = $(INIT_DIR_SRC)./
#RUNIT_FINAL_BIN =

## s6
#S6_INSTALL_DIR =
#S6_BIN = $(INIT_DIR_SRC)./
#S6_FINAL_BIN =

install:
	install -t $(INSTALL_DIR) --owner=$(shell stat -c "%U" $(INSTALL_DIR)) --group=$(shell stat -c "%G" $(INSTALL_DIR)) -m 755 $(BIN) # install $(BIN) in $(INSTALL_DIR)

install_config_dir:
	install -d --owner=$(shell stat -c "%U" $(CONF_DIR)) --group=$(shell stat -c "%G" $(CONF_DIR)) -m 755 "$(CONF_DIR_FINAL)"

install_config: install_config_dir
	install -t "$(CONF_DIR_FINAL)" --owner=$(shell stat -c "%U" $(CONF_DIR_FINAL)) --group=$(shell stat -c "%G" $(CONF_DIR_FINAL)) -m 644 "$(CONF_FILE)"
	install -t "$(CONF_DIR_FINAL)" --owner=$(shell stat -c "%U" $(CONF_DIR_FINAL)) --group=$(shell stat -c "%G" $(CONF_DIR_FINAL)) -m 600 "$(AUTH_FILE)"

install_systemd:
	cp $(SYSTEMD_BIN) $(INIT_DIR_SRC)$(SYSTEMD_FINAL_BIN)
	install -t $(SYSTEMD_INSTALL_DIR) --owner=$(shell stat -c "%U" $(SYSTEMD_INSTALL_DIR)) --group=$(shell stat -c "%G" $(SYSTEMD_INSTALL_DIR)) -m 775 $(INIT_DIR_SRC)$(SYSTEMD_FINAL_BIN)
	rm -rf $(INIT_DIR_SRC)$(SYSTEMD_FINAL_BIN)

install_openrc:
	cp $(OPENRC_BIN) $(INIT_DIR_SRC)$(OPENRC_FINAL_BIN)
	install -t $(OPENRC_INSTALL_DIR) --owner=$(shell stat -c "%U" $(OPENRC_INSTALL_DIR)) --group=$(shell stat -c "%G" $(OPENRC_INSTALL_DIR)) -m 775 $(INIT_DIR_SRC)$(OPENRC_FINAL_BIN)
	rm -rf $(INIT_DIR_SRC)$(OPENRC_FINAL_BIN)

install_dinit:
	cp $(DINIT_BIN) $(INIT_DIR_SRC)$(DINIT_FINAL_BIN)
	install -t $(DINIT_INSTALL_DIR) --owner=$(shell stat -c "%U" $(DINIT_INSTALL_DIR)) --group=$(shell stat -c "%G" $(DINIT_INSTALL_DIR)) -m 775 $(INIT_DIR_SRC)$(DINIT_FINAL_BIN)
	rm -rf $(INIT_DIR_SRC)$(DINIT_FINAL_BIN)

#install_runit:
#	cp $(RUNIT_BIN) $(INIT_DIR_SRC)$(RUNIT_FINAL_BIN)
#	install -t $(RUNIT_INSTALL_DIR) --owner=$(shell stat -c "%U" $(RUNIT_INSTALL_DIR)) --group=$(shell stat -c "%G" $(RUNIT_INSTALL_DIR)) -m 775 $(INIT_DIR_SRC)$(RUNIT_FINAL_BIN)
#	rm -rf $(INIT_DIR_SRC)$(RUNIT_FINAL_BIN)

#install_s6:
#	cp $(S6_BIN) $(INIT_DIR_SRC)$(S6_FINAL_BIN)
#	install -t $(S6_INSTALL_DIR) --owner=$(shell stat -c "%U" $(S6_INSTALL_DIR)) --group=$(shell stat -c "%G" $(S6_INSTALL_DIR)) -m 775 $(INIT_DIR_SRC)$(S6_FINAL_BIN)
#	rm -rf $(INIT_DIR_SRC)$(S6_FINAL_BIN)

all: install install_config install_systemd install_openrc #install_dinit install_runit install_s6

uninstall:
	rm -f $(INSTALL_DIR)$(BIN)
	rm -f $(SYSTEMD_INSTALL_DIR)$(SYSTEMD_FINAL_BIN)
	rm -f $(OPENRC_INSTALL_DIR)$(OPENRC_FINAL_BIN)
	rm -f $(DINIT_INSTALL_DIR)$(DINIT_FINAL_BIN)
#	rm -f $(RUNIT_INSTALL_DIR)$(RUNIT_FINAL_BIN)
#	rm -f $(S6_INSTALL_DIR)$(S6_FINAL_BIN)

.PHONY: all install install_systemd install_openrc uninstall #install_dinit install_runit install_s6
