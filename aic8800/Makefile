include $(TOPDIR)/rules.mk

PKG_NAME:=aic8810
PKG_RELEASE=1

PKG_LICENSE:=GPLv2
PKG_LICENSE_FILES:=

PKG_SOURCE_URL:=https://github.com/nbfalcon/aic8800.git
PKG_MIRROR_HASH:=017a880faeda1948ec7fee35f5f4964c272ec236c93a0e9a023187736d991ff9
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2024-08
PKG_SOURCE_VERSION:=e7689bdc06960b09c9612c0a092f0e19a7ceeba3

PKG_MAINTAINER:=Jordan Ngako <breloo.jn@gmail.com>
PKG_BUILD_PARALLEL:=1

STAMP_CONFIGURED_DEPENDS := $(STAGING_DIR)/usr/include/mac80211-backport/backport/autoconf.h

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/aic8810
  SUBMENU:=Wireless Drivers
  TITLE:=Driver for Aicsemi aic8800 Wi-Fi usb dongle
  DEPENDS:=+kmod-mac80211 +kmod-cfg80211 +kmod-usb-core +@DRIVER_11AC_SUPPORT +aic8800-firmware-D80-usb
  KCONFIG:= \
        CONFIG_CFG80211_WEXT=y \
		CONFIG_WEXT_CORE=y
  FILES:=\
	$(PKG_BUILD_DIR)/aic_load_fw/aic_load_fw.ko \
	$(PKG_BUILD_DIR)/aic8800_fdrv/aic8800_fdrv.ko 
  AUTOLOAD:=$(call AutoProbe,aic_load_fw)
  AUTOLOAD:=$(call AutoProbe,aic8800_fdrv,)
  PROVIDES:=kmod-aic8810
endef

define KernelPackage/aic8810/install
	# Install custom wifi detect wrapper
	$(INSTALL_DIR) $(1)/lib/wifi
	$(INSTALL_BIN) ./files/aic8800.sh $(1)/lib/wifi/aic8800.sh
endef


NOSTDINC_FLAGS := \
	$(KERNEL_NOSTDINC_FLAGS) \
	-I$(PKG_BUILD_DIR) \
	-I$(PKG_BUILD_DIR)/include \
	-I$(STAGING_DIR)/usr/include/mac80211-backport \
	-I$(STAGING_DIR)/usr/include/mac80211-backport/uapi \
	-I$(STAGING_DIR)/usr/include/mac80211 \
	-I$(STAGING_DIR)/usr/include/mac80211/uapi \
	-include backport/backport.h \
	-Wno-error=address \
	-Wno-error=stringop-overread \
	-Wno-error=unused-variable 

NOSTDINC_FLAGS+=-DCONFIG_IOCTL_CFG80211 -DRTW_USE_CFG80211_STA_EVENT -DBUILD_OPENWRT -DCONFIG_WEXT_CORE
define Build/Prepare
	$(call Build/Prepare/Default)
	# Move contents of src into PKG_BUILD_DIR
	[ -d $(PKG_BUILD_DIR)/src ] && mv $(PKG_BUILD_DIR)/src/* $(PKG_BUILD_DIR)/ && rmdir $(PKG_BUILD_DIR)/src || true
endef

define Build/Compile
	+$(KERNEL_MAKE) $(PKG_JOBS) \
		M="$(PKG_BUILD_DIR)" \
		NOSTDINC_FLAGS="$(NOSTDINC_FLAGS)" \
		modules
endef

$(eval $(call KernelPackage,aic8810))
