#!/bin/sh
#nvram set ntp_ready=0
mkdir -p /tmp/dnsmasq.dom
logger -t "为防止dnsmasq启动失败，创建/tmp/dnsmasq.dom/"

# ap relay monitor [simonchen]
if [ ! -x /etc/storage/sh_ezscript.sh ]; then
	cp /etc_ro/sh_ezscript.sh /etc/storage/sh_ezscript.sh
fi
if [ -x /etc/storage/ap_script.sh ]; then
	/etc/storage/ap_script.sh >/dev/null 2>&1 &
else
	cp /etc_ro/ap_script.sh /etc/storage/ap_script.sh
fi

smartdns_conf="/etc/storage/smartdns_custom.conf"
dnsmasq_Conf="/etc/storage/dnsmasq/dnsmasq.conf"
smartdns_Ini="/etc/storage/smartdns_conf.ini"
sdns_port=$(nvram get sdns_port)
if [ $(nvram get sdns_enable) = 1 ] ; then
   if [ -f "$smartdns_conf" ] ; then
       sed -i '/去广告/d' $smartdns_conf
       sed -i '/adbyby/d' $smartdns_conf
       sed -i '/no-resolv/d' "$dnsmasq_Conf"
       sed -i '/server=127.0.0.1#'"$sdns_portd"'/d' "$dnsmasq_Conf"
       sed -i '/port=0/d' "$dnsmasq_Conf"
       rm  -f "$smartdns_Ini"
   fi
logger -t "自动启动" "正在启动SmartDNS"
/usr/bin/smartdns.sh start
fi

if [ $(nvram get caddy_enable) = 1 ] ; then
logger -t "自动启动" "正在启动文件管理"
/usr/bin/caddy.sh start
fi

logger -t "自动启动" "正在检查路由是否已连接互联网！"
count=0
while :
do
	ping -c 1 -W 1 -q www.baidu.com 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	ping -c 1 -W 1 -q 202.108.22.5 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	sleep 5
	ping -c 1 -W 1 -q www.google.com 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	ping -c 1 -W 1 -q 8.8.8.8 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	sleep 5
	count=$((count+1))
	if [ $count -gt 18 ]; then
		break
	fi
done

if [ $(nvram get adbyby_enable) = 1 ] ; then
logger -t "自动启动" "正在启动adbyby plus+"
/usr/bin/adbyby.sh start
fi

if [ $(nvram get koolproxy_enable) = 1 ] ; then
logger -t "自动启动" "正在启动koolproxy"
/usr/bin/koolproxy.sh start
fi

if [ $(nvram get aliddns_enable) = 1 ] ; then
logger -t "自动启动" "正在启动阿里ddns"
/usr/bin/aliddns.sh start
fi

if [ $(nvram get ss_enable) = 1 ] ; then
logger -t "自动启动" "正在启动科学上网"
/usr/bin/shadowsocks.sh start
fi

if [ $(nvram get adg_enable) = 1 ] ; then
logger -t "自动启动" "正在启动adguardhome"
/usr/bin/adguardhome.sh start
fi

if [ $(nvram get wyy_enable) = 1 ] ; then
logger -t "自动启动" "正在启动音乐解锁"
/usr/bin/unblockmusic.sh start
fi

if [ $(nvram get zerotier_enable) = 1 ] ; then
logger -t "自动启动" "正在启动zerotier"
/usr/bin/zerotier.sh start
fi
if [ $(nvram get frpc_enable) = 1 ] ; then
logger -t "自动启动" "正在启动frp client"
/usr/bin/frp.sh start
fi
if [ $(nvram get aliyundrive_enable) = 1 ] ; then
logger -t "自动启动" "正在启动阿里云盘"
/usr/bin/aliyundrive-webdav.sh start
fi
