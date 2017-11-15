#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mmdvm-host
#PKG_REV:=HEAD
PKG_REV:=f5521f6
PKG_VERSION:=BG5HHP-20171115
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
#PKG_SOURCE_URL:=https://github.com/g4klx/MMDVMHost
PKG_SOURCE_URL:=https://github.com/mclub/MMDVMHost
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

#include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

define Package/mmdvm-host
  SECTION:=net
  CATEGORY:=Network
  TITLE:=MMDVM Host
  URL:=https://github.com/g4klx/MMDVMHost/
  DEPENDS:=+uclibcxx +libpthread +libstdcpp
endef

define Package/mmdvm-host/description
	The MMDVMHost package for OpenWrt, by BG5HHP
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

ifeq ($(ARCH),mips)
	TARGET_CFLAGS += -DWORDS_BIGENDIAN=1
	TARGET_CPPFLAGS += -DWORDS_BIGENDIAN=1
endif

TARGET_LDFLAGS += \
       -Wl,-rpath-link=$(STAGING_DIR)/usr/lib \

MAKE_FLAGS +=\
        CFLAGS="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS)" \
        LDFLAGS="$(TARGET_LDFLAGS)" \

define Package/mmdvm-host/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/MMDVMHost $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/usr/sbin/mmdvm-remote.sh $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/usr/sbin/mmdvm-update-dmrid.sh $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/usr/sbin/mmdvm-update-dmrid-bm.sh $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/etc/MMDVM.ini $(1)/etc/MMDVM.ini
	$(INSTALL_DIR) $(1)/etc/mmdvm
	$(INSTALL_CONF) ./files/etc/mmdvm/DMRIds.dat $(1)/etc/mmdvm/DMRIds.dat
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/mmdvmhost.init $(1)/etc/init.d/mmdvmhost
endef

define Package/mmdvm-host/conffiles
	/etc/MMDVM.ini
endef

define Package/mmdvm-host/postinst
#!/bin/sh
if [ -e /etc/openwrt_release ]; then
	/etc/init.d/mmdvmhost enable || :
	/usr/sbin/useradd mmdvm || :
fi
endef

$(eval $(call BuildPackage,mmdvm-host,+uclibcxx,+libpthread,+libstdc++))
