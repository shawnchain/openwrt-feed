#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ysf-clients
#PKG_REV:=HEAD
PKG_REV:=60b3381
PKG_VERSION:=BG5HHP-20171126
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/g4klx/YSFClients
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

#include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

#YSFPackages
define Package/ysf-clients
  SECTION:=net
  CATEGORY:=Network
  TITLE:=YSFClients
  URL:=https://github.com/g4klx/YSFClients/
  DEPENDS:=+uclibcxx +libpthread +libstdcpp
endef

define Package/ysf-clients/description
	The YSFClient package including YSFGateway,YSFParrot and YSFReflector.
	Build for OpenWrt, by BG5HHP
endef

#define Build/Compile
#$(MAKE) -C $(PKG_BUILD_DIR) \
#        LIBS=" -lgcc -lc -luClibc++" \
#        LDFLAGS="$(EXTRA_LDFLAGS)" \
#        CXXFLAGS="$(TARGET_CFLAGS) $(EXTRA_CPPFLAGS) -nostdinc++" \
#        $(TARGET_CONFIGURE_OPTS) \
#        CROSS="$(TARGET_CROSS)" \
#        ARCH="$(ARCH)" \
#        ;
#endef

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

define Package/ysf-clients/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/YSFGateway/YSFGateway $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/etc/YSFGateway.ini $(1)/etc/YSFGateway.ini	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/ysfgateway.init $(1)/etc/init.d/ysfgateway

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/YSFParrot/YSFParrot $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/ysfparrot.init $(1)/etc/init.d/ysfparrot

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/YSFReflector/YSFReflector $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/etc/YSFReflector.ini $(1)/etc/YSFReflector.ini
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/ysfreflector.init $(1)/etc/init.d/ysfreflector
	$(INSTALL_DIR) $(1)/etc/mmdvm
	$(INSTALL_CONF) ./files/etc/mmdvm/YSFHosts.txt $(1)/etc/mmdvm/

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/usr/sbin/YSFHostsupdate.sh $(1)/usr/sbin/
endef

define Package/ysf-clients/conffiles
	/etc/YSFGateway.ini
	/etc/YSFReflector.ini
endef

define Package/ysf-clients/postinst
#!/bin/sh
if [ -e /etc/openwrt_release ]; then
	/etc/init.d/ysfgateway disable || :
	/etc/init.d/ysfparrot disable || :
	/etc/init.d/ysfreflector disable || :
fi
endef

$(eval $(call BuildPackage,ysf-clients,+uclibcxx,+libpthread,+libstdc++))
