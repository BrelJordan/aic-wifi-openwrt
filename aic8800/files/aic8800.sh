#!/bin/sh
. /lib/functions.sh

wifi_config() {
    local wireless_config="/etc/config/wireless"

    # Only proceed if wireless config exists
    if [ -f "$wireless_config" ];
    then

    echo "AIC8800 wrapper: Checking for invalid USB paths..."

    # Loop through each wifi-device section
    config_load wireless
    config_foreach fix_radio_path wifi-device

    else

    touch /etc/config/wireless
	ucode /lib/wifi/mac80211.uc | uci -q batch

	for driver in $DRIVERS; do (
		if eval "type detect_$driver" 2>/dev/null >/dev/null; then
			eval "detect_$driver" || echo "$driver: Detect failed" >&2
		else
			echo "$driver: Hardware detection not supported" >&2
		fi
	); done

    fi

}

fix_radio_path() {
    local section="$1"
    local path

    config_get path "$section" path

    # Only process paths that start with 'platform/'
    case "$path" in
        platform/*) ;;
        *) return 0 ;;
    esac

    local full_path="/sys/devices/$path"

    # If path exists, nothing to do
    [ -e "$full_path" ] && return 0

    echo "-> Path '$full_path' for section '$section' is invalid, searching for AIC8800..."

    # Look for a new valid AIC8800 USB path
    for prod_path in $(find /sys/devices/platform/ -name product 2>/dev/null); do
        if [ "$(cat "$prod_path" 2>/dev/null)" = "AIC 8800D80" ]; then
            new_path="${prod_path%/product}"
            rel_path="${new_path#/sys/devices/}"
            echo "-> Found replacement path: $rel_path"

            uci set wireless."$section".path="$rel_path"
            return 0
        fi
    done

    echo "-> No matching AIC8800 device found for '$section'"
}

# Always commit once at the end (to reduce flash writes)
uci commit wireless
