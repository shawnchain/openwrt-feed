#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mmdvm-host
PKG_REV:=HEAD
PKG_VERSION:=1.0.0
PKG_RELEASE:=

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/g4klx/MMDVMHost/trunk
#PKG_SOURCE_URL:=https://github.com/g4klx/MMDVMHost/tags/1.0
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=svn

include $(INCLUDE_DIR)/package.mk

define Package/mmdvm-host
  SECTION:=net
  CATEGORY:=Network
  TITLE:=MMDVM Host
  URL:=https://github.com/g4klx/MMDVMHost/
  DEPENDS:=libpthread
endef

define Package/mmdvm-host/description
	The MMDVM Host for OpenWrt
endef

#TARGET_CFLAGS = -std=c99
TARGET_CFLAGS = -std=c++0x

define Package/mmdvm-host/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/MMDVMHost $(1)/usr/sbin/
#	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/aprsutil $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/mmdvmhost.init $(1)/etc/init.d/mmdvmhost
endef

define Package/mmdvm-host/conffiles
endef

define Package/mmdvm-host/postinst
#!/bin/sh
if [ -e /etc/openwrt_release ]; then
	/etc/init.d/mmdvmhost enable || :
fi
endef

$(eval $(call BuildPackage,mmdvm-host))
