#
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mmdvm-xlxd-dashboard
#PKG_REV:=HEAD
PKG_REV:=1
PKG_VERSION:=BG5HHP-20180305
PKG_RELEASE:=1

PKG_INSTALL:=$(if $(realpath src/Makefile),1)

include $(INCLUDE_DIR)/package.mk

#YSFPackages
define Package/mmdvm-xlxd-dashboard
  SECTION:=net
  CATEGORY:=Network
  TITLE:=MMDVM XLXD dashboard
  URL:=https://github.com/LX3JL/xlxd
  DEPENDS:=+mmdvm-xlxd
endef

define Package/mmdvm-xlxd-dashboard/description
	The dashboard for XLXD DMR reflector service.
	Build for OpenWrt, by BG5HHP
endef

define Build/Compile
endef

define Package/mmdvm-xlxd-dashboard/install
	$(INSTALL_DIR) $(1)/www/xlxd
	$(CP) -r ./files/www/* $(1)/www/xlxd/
endef

define Package/mmdvm-xlxd-dashboard/conffiles
endef

define Package/mmdvm-xlxd-dashboard/postinst
endef

$(eval $(call BuildPackage,mmdvm-xlxd-dashboard,+mmdvm-xlxd))
