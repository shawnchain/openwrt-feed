#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ysf2p25
#PKG_REV:=HEAD
PKG_REV:=f2e297c
PKG_VERSION:=BG5HHP-20180502
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/juribeparada/YSF2P25
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

#include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

#YSFPackages
define Package/ysf2p25
  SECTION:=net
  CATEGORY:=Network
  TITLE:=YSF2P25
  URL:=https://github.com/juribeparada/YSF2P25/
  DEPENDS:=+uclibcxx +libpthread +libstdcpp +mmdvm-common
endef

define Package/ysf2p25/description
	The YSF2P25 package including the daemon for converting YSF to P25 reflector.
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

define Package/ysf2p25/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/YSF2P25 $(1)/usr/sbin/
	$(CP) -a files/* $(1)/
endef

define Package/ysf2p25/conffiles
/etc/YSF2P25.ini
endef

define Package/ysf2p25/postinst
endef

$(eval $(call BuildPackage,ysf2p25,+uclibcxx,+libpthread,+libstdc++))
