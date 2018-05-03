#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ysf-clients
#PKG_REV:=HEAD
PKG_REV:=42bb423
PKG_VERSION:=BG5HHP-20180225
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
  DEPENDS:=+uclibcxx +libpthread +libstdcpp +mmdvm-common
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

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/YSFParrot/YSFParrot $(1)/usr/sbin/

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/YSFReflector/YSFReflector $(1)/usr/sbin/

	$(CP) -a files/* $(1)/
endef

define Package/ysf-clients/conffiles
/etc/YSFGateway.ini
/etc/YSFReflector.ini
endef

define Package/ysf-clients/postinst
#!/bin/sh
if [ -e /etc/openwrt_release ]; then
	crontab -l -u root  2>/dev/null |grep YSFHostsupdate >/dev/null
	if [ $$? -ne 0 ]; then
		echo "5 0 * * * /usr/sbin/YSFHostsupdate.sh >/tmp/YSFHostsupdate.log 2>&1 &" >>/etc/crontabs/root
		/etc/init.d/cron restart || :
	fi
fi
exit 0
endef

$(eval $(call BuildPackage,ysf-clients,+uclibcxx,+libpthread,+libstdc++))
