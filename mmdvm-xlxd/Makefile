#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mmdvm-xlxd
PKG_REV:=HEAD
#PKG_REV:=6a23450
PKG_VERSION:=BG5HHP-20180224
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/LX3JL/xlxd
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

#include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

#YSFPackages
define Package/mmdvm-xlxd
  SECTION:=net
  CATEGORY:=Network
  TITLE:=MMDVM XLXD
  URL:=https://github.com/LX3JL/xlxd
  DEPENDS:=+uclibcxx +libpthread +libstdcpp
endef

define Package/mmdvm-xlxd/description
	The XLXD DMR reflector service.
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

define Package/mmdvm-xlxd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/xlxd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/etc/XLXD.ini $(1)/etc/XLXD.ini	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/xlxd.init $(1)/etc/init.d/xlxd
endef

define Package/mmdvm-xlxd/conffiles
/etc/XLXD.ini
endef

define Package/mmdvm-xlxd/postinst
endef

$(eval $(call BuildPackage,mmdvm-xlxd,+uclibcxx,+libpthread,+libstdc++))
