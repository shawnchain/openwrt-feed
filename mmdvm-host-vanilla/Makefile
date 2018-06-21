#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mmdvm-host-vanilla
#PKG_REV:=HEAD
#PKG_REV:=34ceb91
PKG_REV:=JitterBuffer
PKG_VERSION:=20180621
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/g4klx/MMDVMHost
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define Package/mmdvm-host-vanilla
  SECTION:=net
  CATEGORY:=Network
  TITLE:=MMDVM Host Vanilla
  URL:=https://github.com/g4klx/MMDVMHost/
  DEPENDS:=+libpthread +libstdcpp +mmdvm-common
endef

define Package/mmdvm-host-vanilla/description
	The original MMDVMHost package for OpenWrt, maintained by BG5HHP
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

define Package/mmdvm-host-vanilla/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/MMDVMHost $(1)/usr/sbin/
	$(CP) -a files/* $(1)/
endef

define Package/mmdvm-host-vanilla/conffiles
/etc/MMDVM.ini
endef

define Package/mmdvm-host-vanilla/postinst
#!/bin/sh
if [ -e /etc/openwrt_release ]; then
	uci set mmdvm.@mmdvmhost[0].enabled=1 && uci commit mmdvm || :
	cat /etc/rc.local |grep "mmdvm-network-helper.sh" >/dev/null
	if [ $$? -ne 0 ]; then
		#insert the helper command before exit 0
		echo "Updating /etc/rc.local ... "
		sed -i '/exit 0/ i /usr/sbin/mmdvm-network-helper.sh & 2>/dev/null' /etc/rc.local
	fi
fi
exit 0
endef

$(eval $(call BuildPackage,mmdvm-host-vanilla,+libpthread,+libstdc++,+mmdvm-common))
