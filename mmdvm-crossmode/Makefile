#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mmdvm-crossmode
#PKG_REV:=HEAD
PKG_REV:=d231273
PKG_VERSION:=BG5HHP-20180605
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/juribeparada/MMDVM_CM
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

#include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

#YSFPackages
define Package/mmdvm-crossmode
  SECTION:=net
  CATEGORY:=Network
  TITLE:=MMDVM CrossMode
  URL:=https://github.com/juribeparada/MMDVM_CM/
  DEPENDS:=+uclibcxx +libpthread +libstdcpp +mmdvm-common
endef

define Package/mmdvm-crossmode/description
	The mmdvm-crossmode package including the daemons for converting cross-mode conversion.
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

define Package/mmdvm-crossmode/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/YSF2P25/YSF2P25 $(1)/usr/sbin/
  $(INSTALL_BIN) $(PKG_BUILD_DIR)/YSF2DMR/YSF2DMR $(1)/usr/sbin/
	$(CP) -a files/* $(1)/
endef

define Package/mmdvm-crossmode/conffiles
/etc/YSF2P25.ini
/etc/YSF2DMR.ini
endef

define Package/mmdvm-crossmode/postinst
endef

$(eval $(call BuildPackage,mmdvm-crossmode,+uclibcxx,+libpthread,+libstdc++))
