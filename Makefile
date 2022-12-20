# Copyright (c) 2022 TheRealOne78
# Distributed under the terms of the GNU General Public License v3

SRC = ./src/
BIN = $(SRC)./ntfy-resources-usage
INSTALL_DIR = /usr/bin/

INIT_DIR_SRC = $(SRC)./init/

CONF_DIR = /etc/
CONF_DIR_FINAL = $(CONF_DIR)ntfy-resources-usage/
CONF_FILE = ./src/config/ntfy-resources-usage.conf

# systemd
SYSTEMD_INSTALL_DIR = /etc/systemd/system/
SYSTEMD_BIN = $(INIT_DIR_SRC)./systemd
SYSTEMD_FINAL_BIN = ntfy-resources-usage.service

# openrc
OPENRC_INSTALL_DIR = /etc/init.d/
OPENRC_BIN = $(INIT_DIR_SRC)./openrc
OPENRC_FINAL_BIN = ntfy-resources-usage

install:
	install -t $(INSTALL_DIR) --owner=$(shell stat -c "%U" $(INSTALL_DIR)) --group=$(shell stat -c "%G" $(INSTALL_DIR)) -m 775 $(BIN) # install $(BIN) in $(INSTALL_DIR)

install_config:
	install -d --owner=$(shell stat -c "%U" $(CONF_DIR)) --group=$(shell stat -c "%G" $(CONF_DIR)/) -m 755 "$(CONF_DIR_FINAL)"
	install -t "$(CONF_DIR_FINAL)" --owner=$(shell stat -c "%U" $(CONF_DIR_FINAL)) --group=$(shell stat -c "%G" $(CONF_DIR_FINAL)) -m 755 "$(CONF_FILE)"

install_systemd:
	cp $(SYSTEMD_BIN) $(INIT_DIR_SRC)$(SYSTEMD_FINAL_BIN)
	install -t $(SYSTEMD_INSTALL_DIR) --owner=$(shell stat -c "%U" $(SYSTEMD_INSTALL_DIR)) --group=$(shell stat -c "%G" $(SYSTEMD_INSTALL_DIR)) -m 775 $(INIT_DIR_SRC)$(SYSTEMD_FINAL_BIN)
	rm -rf $(INIT_DIR_SRC)$(SYSTEMD_FINAL_BIN)

install_openrc:
	cp $(OPENRC_BIN) $(INIT_DIR_SRC)$(OPENRC_FINAL_BIN)
	install -t $(OPENRC_INSTALL_DIR) --owner=$(shell stat -c "%U" $(OPENRC_INSTALL_DIR)) --group=$(shell stat -c "%G" $(OPENRC_INSTALL_DIR)) -m 775 $(INIT_DIR_SRC)$(OPENRC_FINAL_BIN)
	rm -rf $(INIT_DIR_SRC)$(OPENRC_FINAL_BIN)

all: install install_systemd install_openrc

uninstall:
	rm -f $(INSTALL_DIR)$(BIN)
	rm -f $(SYSTEMD_INSTALL_DIR)$(SYSTEMD_FINAL_BIN)
	rm -f $(OPENRC_INSTALL_DIR)$(OPENRC_FINAL_BIN)

.PHONY: all install install_systemd install_openrc uninstall
