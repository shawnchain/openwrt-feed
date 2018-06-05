#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dmr-host
#PKG_REV:=HEAD
PKG_REV:=dmr-only
PKG_VERSION:=BG5HHP-20180604
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/mclub/MMDVMHost
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define Package/dmr-host
  SECTION:=net
  CATEGORY:=Network
  TITLE:=DMR Host
  URL:=https://github.com/g4klx/MMDVMHost/
  DEPENDS:=+libpthread +libstdcpp +mmdvm-common
endef

define Package/dmr-host/description
	The MMDVM DRMHost package for OpenWrt, by BG5HHP
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

TARGET_CFLAGS += -std=c++0x -D_OPENWRT=1
TARGET_CFLAGS += -DDMR_REPEATER_ACCESS_CONTROL=1

ifeq ($(ARCH),mips)
	TARGET_CFLAGS += -DWORDS_BIGENDIAN=1
	TARGET_CPPFLAGS += -DWORDS_BIGENDIAN=1
endif

TARGET_LDFLAGS += \
       -Wl,-rpath-link=$(STAGING_DIR)/usr/lib \

MAKE_FLAGS +=\
        CFLAGS="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS)" \
        LDFLAGS="$(TARGET_LDFLAGS)" \

define Package/dmr-host/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/MMDVMHost $(1)/usr/sbin/DMRHost
	$(CP) -a files/* $(1)/
endef

define Package/dmr-host/conffiles
/etc/DMRHost.ini
/etc/mmdvm/DMRIds.dat
endef

define Package/dmr-host/postinst
#!/bin/sh
if [ -e /etc/openwrt_release ]; then
	uci set mmdvm.@dmrhost[0].enabled=1 && uci commit mmdvm || :
	cat /etc/rc.local |grep "mmdvm-network-helper.sh" >/dev/null
	if [ $$? -ne 0 ]; then
		#insert the helper command before exit 0
		echo "Updating /etc/rc.local ... "
		sed -i '/exit 0/ i /usr/sbin/mmdvm-network-helper.sh & 2>/dev/null' /etc/rc.local
	fi
fi
exit 0
endef

$(eval $(call BuildPackage,dmr-host,+libpthread,+libstdc++,+mmdvm-common))
