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
    echo "Wifi reconnect hack ran for NetworkManager"
}

function reconnect_wpa_supplicant() {
    /sbin/wpa_cli -i wlan0 reconfigure
    echo "Wifi reconnect hack ran for wpa_supplicant"
}

if ip link show | grep wlan0 >/dev/null 2>&1;
then
  if check_ping_failure;
  then
      echo "Pinging the gateway failed, reconnecting the wifi interface is required"
      if systemctl is-active --quiet NetworkManager.service;
      then
          reconnect_NetworkManager
      elif systemctl is-active --quiet wpa_supplicant.service;
      then
          reconnect_wpa_supplicant
      else
          echo "Unknown network managmet service"
      fi
  else
      echo "Pinging the gateway was successful, not reconnecting the wifi interface."
  fi
else
  echo "No wlan0 interface found ... this should probably be investigated"
fi
