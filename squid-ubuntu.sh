#!/bin/bash
PROXY_PORT=3000
sudo apt-get update
sudo apt-get install squid3 apache2-utils -y
sudo htpasswd -i -b -c /etc/squid3/passwd user pass
cat <<__END >>/tmp/s.temp
auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid3/password
auth_param basic children 5
auth_param basic realm Proxy server

acl ncsa_users proxy_auth REQUIRED
http_access allow ncsa_users
__END

cat /etc/squid3/squid.conf >>/tmp/s.temp
cat /tmp/s.temp >/etc/squid3/squid.conf
rm -f /tmp/s.temp
sed -i 's/http_access allow localhost manager/#http_access allow localhost manager/g' /etc/squid3/squid.conf
sed -i "s/http_port 3128/http_port $PROXY_PORT/g" /etc/squid3/squid.conf
squid3
echo "Proxy Service Started"
