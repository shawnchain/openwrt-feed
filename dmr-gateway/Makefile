#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dmr-gateway
#PKG_REV:=HEAD
PKG_REV:=aa4c906
PKG_VERSION:=BG5HHP-20180228
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/g4klx/DMRGateway
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

#include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

#YSFPackages
define Package/dmr-gateway
  SECTION:=net
  CATEGORY:=Network
  TITLE:=DMRGateway
  URL:=https://github.com/g4klx/DMRGateway/
  DEPENDS:=+uclibcxx +libpthread +libstdcpp
endef

define Package/dmr-gateway/description
	The DMRGateway package for amateur radio with DMR.
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

define Package/dmr-gateway/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/DMRGateway $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/etc/DMRGateway.ini $(1)/etc/DMRGateway.ini	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/dmrgateway.init $(1)/etc/init.d/dmrgateway
	$(INSTALL_DIR) $(1)/etc/mmdvm
	$(INSTALL_DATA) ./files/etc/XLXHosts.txt $(1)/etc/mmdvm/
	$(INSTALL_DATA) ./files/etc/XLXHosts_private.txt $(1)/etc/mmdvm/
	$(INSTALL_DIR) $(1)/etc/mmdvm/Audio
	$(INSTALL_DATA) ./files/etc/Audio/en_US.* $(1)/etc/mmdvm/Audio/
endef

define Package/dmr-gateway/conffiles
/etc/DMRGateway.ini
endef

define Package/dmr-gateway/postinst
#!/bin/sh
if [ -e /etc/openwrt_release ]; then
	/etc/init.d/dmrgateway stop  || :
	/etc/init.d/dmrgateway disable  || :
fi
exit 0
endef

$(eval $(call BuildPackage,dmr-gateway,+uclibcxx,+libpthread,+libstdc++))
