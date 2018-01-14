#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mmdvm-cal
#PKG_REV:=HEAD
PKG_REV:=f89561e
PKG_VERSION:=BG5HHP-20180114
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/g4klx/MMDVMCal
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define Package/mmdvm-cal
  SECTION:=net
  CATEGORY:=Network
  TITLE:=MMDVM Calibrate
  URL:=https://github.com/g4klx/MMDVMCal/
  DEPENDS:=+libpthread +libstdcpp
endef

define Package/mmdvm-cal/description
	The MMDVMCal package for OpenWrt, by BG5HHP
endef

TARGET_CFLAGS += -std=c++0x -D_OPENWRT=1

ifeq ($(ARCH),mips)
	TARGET_CFLAGS += -DWORDS_BIGENDIAN=1
	TARGET_CPPFLAGS += -DWORDS_BIGENDIAN=1
endif

TARGET_LDFLAGS += \
       -Wl,-rpath-link=$(STAGING_DIR)/usr/lib \

MAKE_FLAGS +=\
        CFLAGS="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS)" \
        LDFLAGS="$(TARGET_LDFLAGS)" \

define Package/mmdvm-cal/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/MMDVMCal $(1)/usr/sbin/
endef

define Package/mmdvm-cal/conffiles
endef

define Package/mmdvm-cal/postinst
endef

$(eval $(call BuildPackage,mmdvm-cal,+libpthread,+libstdc++))
