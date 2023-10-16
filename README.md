wifi
====

This role configures the wifi connections. It is targetted primarilly at Raspberry Pis but should work on other platforms. It handles connections with wpa_supplicant for Raspberry Pi OS < 12 (bookworm) and also connections using NetworkManager for newer releases.

As always: Use at your own risk!

Role Variables
--------------

| Name          | Comment                              | Default value |
|---------------|--------------------------------------|---------------|
| wifi_country  | Set the required country for wifi    | `CH`          |
| wifi_networks | A list of wifi networks to configure | `[]`          |

The `wifi_networks` variable has a list of the following keys:

| Name | Comment                                           |
|------|---------------------------------------------------|
| ssid | The SSID of the wifi connection.                  |
| psk  | The password (pre shared key) for the connection. |
| str  | The name for the connection.                      |

This is a example:

```yaml
wifi_country: CH
wifi_networks:
  - ssid: wifi_ssid_a
    psk: wifi_pw_b
    str: wifi_connection_a
  - ssid: wifi_ssid_b
    psk: wifi_pw_b
    str: wifi_connection_b
```

Example Playbook
----------------
```yaml
- name: Wifi client setup (primarily for raspis)
  hosts: wifi
  collections:
    - oxivanisher.raspberry_pi
  roles:
    - role: oxivanisher.raspberry_pi.wifi
```

License
-------

BSD

Author Information
------------------

This role is part of the [oxivanisher.raspberry_pi](https://galaxy.ansible.com/ui/repo/published/oxivanisher/raspberry_pi/) collection, and the source for that is located on [github](https://github.com/oxivanisher/collection-raspberry_pi).
