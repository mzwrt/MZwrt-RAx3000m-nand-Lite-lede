# 开启 irqbalance
cat <<EOL >> package/base-files/files/etc/uci-defaults/99-irqbalance-settings
#!/bin/sh
# 开启 irqbalance
# 修改 option enabled '0' 为 option enabled '1'
sed -i "s/option enabled '0'/option enabled '1'/g" /etc/config/irqbalance

# 取消 option interval '10' 前面的 # 号
sed -i "s/#option interval '10'/option interval '10'/g" /etc/config/irqbalance

exit 0
EOL


cat <<EOL >> package/base-files/files/etc/uci-defaults/99-MzWrt-settings
#!/bin/sh

# 设置主机名
uci set system.@system[0].hostname='MzWrt'

# 修改默认IP
uci set network.lan.ipaddr='192.168.10.1'

# 设置 2.4GHz 频段的国家为中国
uci set wireless.radio0.country='CN'
# 设置 5GHz 频段的国家为中国
uci set wireless.radio1.country='CN'

# 信道设置
uci set wireless.radio0.channel='auto'  # 设置 2.4GHz 信道为 13
uci set wireless.radio1.channel='auto'  # 设置 5GHz 信道为 36

# 设置 2.4GHz 频段的无线模式（支持 802.11n，20MHz 或 40MHz，最大带宽 40MHz）
uci set wireless.radio0.htmode='HE40'  # 设置 2.4GHz 频段为 40MHz 带宽

# 设置 5GHz 频段的无线模式为 HE160（最大带宽 160MHz）
uci set wireless.radio1.htmode='HE160'  # 设置 5GHz 带宽为 160MHz

# 开启 Beamforming 功能
uci set wireless.radio0.beamforming='1'  # 开启 2.4GHz 的 Beamforming
uci set wireless.radio1.beamforming='1'  # 开启 5GHz 的 Beamforming

# 开启 MU-MIMO 支持
uci set wireless.radio0.mu_mimo='1'  # 开启 2.4GHz 的 MU-MIMO
uci set wireless.radio1.mu_mimo='1'  # 开启 5GHz 的 MU-MIMO

# 开启 OFDMA 支持
uci set wireless.radio0.ofdma='1'    # 开启 2.4GHz 的 OFDMA
uci set wireless.radio1.ofdma='1'    # 开启 5GHz 的 OFDMA

# 设置 2.4GHz SSID 名称为 MzWrt-2.4G
uci set wireless.default_radio0.ssid='MzWrt-2.4G'

# 设置 5GHz SSID 名称为 MzWrt-5G
uci set wireless.default_radio1.ssid='MzWrt-5G'

# 提交无线配置
uci commit wireless

# 重启网络
# /etc/init.d/network restart

# 提交修改的默认IP
uci commit network

# 如果您确实需要重启系统或修改主机名，也可以执行
# 提交主机名配置
uci commit system
# 重启系统
# /etc/init.d/system restart

EOL

cat <<EOL >> package/base-files/files/etc/sysctl.conf
vm.swappiness=10
vm.vfs_cache_pressure=50

fs.nr_open=1200000
fs.file-max=200000

# Enable TCP SYN cookies
net.ipv4.tcp_syncookies=1

# Increase the maximum number of connections in the backlog
net.core.somaxconn=65535

# Increase the maximum number of queued packets
net.core.netdev_max_backlog=1000

# Increase buffer sizes for TCP
net.core.rmem_default=65536
net.core.wmem_default=65536
net.core.rmem_max=16777216
net.core.wmem_max=16777216

# TCP settings
net.ipv4.tcp_max_syn_backlog=4096
net.ipv4.tcp_synack_retries=1
net.ipv4.tcp_keepalive_time=1800
net.ipv4.tcp_keepalive_intvl=15
net.ipv4.tcp_keepalive_probes=5
net.ipv4.tcp_fin_timeout=10
net.ipv4.tcp_max_orphans=65536
net.ipv4.tcp_mem=50576 64768 98152
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.tcp_orphan_retries=0
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_timestamps=1
net.ipv4.tcp_sack=1
net.ipv4.tcp_rfc1337=1

EOL
