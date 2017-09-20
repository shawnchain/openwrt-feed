#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=p25-clients
PKG_REV:=HEAD
PKG_VERSION:=1.0.0
PKG_RELEASE:=

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/g4klx/P25Clients/trunk
#PKG_SOURCE_URL:=https://github.com/g4klx/P25Clients/tags/1.0
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=svn

#include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

#P25Packages
define Package/p25-clients
  SECTION:=net
  CATEGORY:=Network
  TITLE:=P25Clients
  URL:=https://github.com/g4klx/P25Clients/
  DEPENDS:=+uclibcxx +libpthread +libstdcpp
endef

define Package/p25-clients/description
	The P25Clients package including P25Gateway,P25Parrot.
	Build for OpenWrt, by BG5HHP
endef

TARGET_CFLAGS += -std=c++0x

TARGET_CPPFLAGS += \

#       -I$(ICONV_PREFIX)/include \
#       -I$(INTL_PREFIX)/include \
#       -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 \

TARGET_LDFLAGS += \
       -Wl,-rpath-link=$(STAGING_DIR)/usr/lib \

MAKE_FLAGS +=\
        CFLAGS="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS)" \
        LDFLAGS="$(TARGET_LDFLAGS)" \

define Package/p25-clients/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/P25Gateway/P25Gateway $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/etc/P25Gateway.ini $(1)/etc/P25Gateway.ini	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/p25gateway.init $(1)/etc/init.d/p25gateway

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/P25Parrot/P25Parrot $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/p25parrot.init $(1)/etc/init.d/p25parrot

	$(INSTALL_DIR) $(1)/etc/mmdvm
	$(INSTALL_BIN) ./files/etc/mmdvm/P25Hosts.txt $(1)/etc/mmdvm/

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/usr/sbin/P25Hostsupdate.sh $(1)/usr/sbin/
endef

define Package/p25-clients/conffiles
	/etc/P25Gateway.ini
endef

define Package/p25-clients/postinst
#!/bin/sh
if [ -e /etc/openwrt_release ]; then
	/etc/init.d/p25gateway enable || :
	/etc/init.d/p25parrot enable || :
fi
endef

$(eval $(call BuildPackage,p25-clients,+uclibcxx,+libpthread,+libstdc++))
