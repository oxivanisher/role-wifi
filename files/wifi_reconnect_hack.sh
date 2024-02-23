#!/bin/bash

function check_ping_failure() {
    local ip=$(ip route | grep default | grep wlan0 | awk '{print $3}')
    local count=3
    local failed_count=0

    for (( i=1; i<=$count; i++ )); do
        if ! ping -c1 -W1 "$ip" >/dev/null 2>&1; then
            ((failed_count++))
            sleep 1
        fi
    done

    if [ $failed_count -eq $count ]; then
        return 0  # All pings failed
    else
        return 1  # At least one ping succeeded
    fi
}

function reconnect_NetworkManager() {
    /usr/bin/nmcli radio wifi off
    /usr/bin/sleep 3
    /usr/bin/nmcli radio wifi on
    echo "oXi wifi reconnect hack ran for NetworkManager"
}

function reconnect_wpa_supplicant() {
    /sbin/wpa_cli -i wlan0 reconfigure
    echo "oXi wifi reconnect hack ran for wpa_supplicant"
}

if ip route | grep default | grep wlan0 >/dev/null 2>&1;
then
  if check_ping_failure;
  then
      # pinging the gateway failed, reconnecting is required
      if systemctl is-active --quiet NetworkManager.service;
      then
          reconnect_NetworkManager
      elif systemctl is-active --quiet wpa_supplicant.service;
      then
          reconnect_wpa_supplicant
      else
          # unknown network managmet service
          :
      fi
  else
      # pinging the gateway was successful.
      :
  fi
else
  # no wlan0 interface found ... this should probably be investigated
  :
fi
