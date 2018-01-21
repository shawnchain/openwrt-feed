#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mmdvm-host
#PKG_REV:=HEAD
PKG_REV:=606a7ae
PKG_VERSION:=BG5HHP-20180114
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
#PKG_SOURCE_URL:=https://github.com/g4klx/MMDVMHost
PKG_SOURCE_URL:=https://github.com/mclub/MMDVMHost
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

define Package/mmdvm-host
  SECTION:=net
  CATEGORY:=Network
  TITLE:=MMDVM Host
  URL:=https://github.com/g4klx/MMDVMHost/
  DEPENDS:=+libpthread +libstdcpp
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

define Package/mmdvm-host/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/MMDVMHost $(1)/usr/sbin/
	$(CP) -a files/* $(1)/
endef

define Package/mmdvm-host/conffiles
/etc/MMDVM.ini
/etc/config/mmdvm
/etc/mmdvm/DMRIds.dat
endef

define Package/mmdvm-host/postinst
#!/bin/sh
if [ -e /etc/openwrt_release ]; then
	uci set mmdvm.@mmdvmhost[0].enabled=1 && uci commit mmdvm || :
fi

crontab -l -u root  2>/dev/null |grep mmdvm-update-dmrid-bm >/dev/null
if [ $$? -ne 0 ]; then
	echo "5 0 * * * /usr/sbin/mmdvm-update-dmrid-bm.sh >/tmp/mmdvm-update-dmrid-bm.log 2>&1 &" >>$(1)/etc/crontabs/root
	/etc/init.d/cron restart || :
fi
exit 0
endef

$(eval $(call BuildPackage,mmdvm-host,+libpthread,+libstdc++))
