include $(TOPDIR)/rules.mk

PKG_NAME:=aic8800-firmware
PKG_VERSION:=2025.1.10
PKG_RELEASE:=1
PKG_LICENSE:=ISC
PKG_LICENSE_FILES:=LICENSE
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/radxa-pkg/aic8800.git
PKG_SOURCE_VERSION:=8b8f90587527fec5d3803908cb2545379459eaa9  # commit hash
PKG_MIRROR_HASH:=8d81ac8b7a397109b72ed46d6ffe188682d6ff7959b4e335ab6e62cde43c2308 

PKG_MAINTAINER:=Jordan Ngako <breloo.jn@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/aic8800-firmware
  SECTION:=firmware
  CATEGORY:=Firmware
  URL:=https://github.com/radxa-pkg/aic8800.git
  TITLE:=Wifi firmware for aicsemi chips 
endef

define Build/Compile
	
endef
define Package/aic8800-firmware
  SECTION:=firmware
  CATEGORY:=Firmware
  URL:=https://github.com/radxa-pkg/aic8800-firmware.git
  TITLE:=Wifi firmware for aicsemi chips 
endef

define Package/aic8800-firmware-D80-usb
  $(Package/aic8800-firmware)
  TITLE:=Firmware for the aic8800 usb chip with device id: 0D80.
endef

define Package/aic8800-firmware-D80-usb/description
Firmware for the aic8800 usb chip with device id: 0D80. 
endef

define Package/aic8800-firmware-D80-usb/install
	$(INSTALL_DIR) $(1)/lib/firmware/aicsemi
	$(CP) $(PKG_BUILD_DIR)/src/USB/driver_fw/fw/aic8800D80/* $(1)/lib/firmware/aicsemi
endef

$(eval $(call BuildPackage,aic8800-firmware-D80-usb))
$(eval $(call BuildPackage,aic8800-firmware))
