#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=p25-clients
#PKG_REV:=HEAD
PKG_REV:=6e6ce17
PKG_VERSION:=BG5HHP-20180502
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=https://github.com/g4klx/P25Clients
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:=git

include $(INCLUDE_DIR)/package.mk

#P25Packages
define Package/p25-clients
  SECTION:=net
  CATEGORY:=Network
  TITLE:=P25Clients
  URL:=https://github.com/g4klx/P25Clients/
  DEPENDS:=+libpthread +libstdcpp +mmdvm-common
endef

define Package/p25-clients/description
	The P25Clients package including P25Gateway,P25Parrot.
	Build for OpenWrt, by BG5HHP
endef

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

define Package/p25-clients/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/P25Gateway/P25Gateway $(1)/usr/sbin/

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/P25Parrot/P25Parrot $(1)/usr/sbin/

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/P25Reflector/P25Reflector $(1)/usr/sbin/

	$(CP) -a files/* $(1)/
endef

define Package/p25-clients/conffiles
/etc/P25Gateway.ini
/etc/P25Reflector.ini
endef

define Package/p25-clients/postinst
#!/bin/sh
if [ -e /etc/openwrt_release ]; then
	crontab -l -u root  2>/dev/null |grep P25Hostsupdate >/dev/null
	if [ $$? -ne 0 ]; then
		echo "15 2 * * * /usr/sbin/P25Hostsupdate.sh >/tmp/P25Hostsupdate.log 2>&1 &" >>/etc/crontabs/root
		/etc/init.d/cron restart || :
	fi
fi
exit 0
endef

$(eval $(call BuildPackage,p25-clients,+libpthread,+libstdc++,+mmdvm-common))
