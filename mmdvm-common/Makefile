#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mmdvm-common
PKG_VERSION:=BG5HHP-20180502
PKG_RELEASE:=1

#PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/mmdvm-common
  SECTION:=net
  CATEGORY:=Network
  TITLE:=MMDVM Common
  MAINTAINER:=BG5HHP <bg5hhp@hamclub.net>
  URL:=https://mmdvm.cc/
  DEPENDS:=+shadow-useradd
endef

define Package/mmdvm-common/description
	The MMDVM common package for OpenWrt, by BG5HHP
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile/Default

endef
Build/Compile = $(Build/Compile/Default)

define Package/mmdvm-common/install
	$(CP) -a files/* $(1)/
endef

define Package/mmdvm-common/conffiles
/etc/config/mmdvm
/etc/mmdvm/DMRIds.dat
endef

define Package/mmdvm-common/postinst
#!/bin/sh
if [ -e /etc/openwrt_release ]; then
	crontab -l -u root  2>/dev/null |grep mmdvm-update-dmrid-bm >/dev/null
	if [ $$? -ne 0 ]; then
		echo "Updating crontab ... "
		echo "0 2 * * * /usr/sbin/mmdvm-update-dmrid-bm.sh >/tmp/mmdvm-update-dmrid-bm.log 2>&1 &" >>/etc/crontabs/root
		/etc/init.d/cron restart || :
	fi
fi
exit 0
endef

$(eval $(call BuildPackage,mmdvm-common))
