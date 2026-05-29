#!/bin/bash

## Установка HAP на Ubuntu

# update apt
sudo apt-get update

# install haproxy
sudo apt-get install -y haproxy

# start haproxy
sudo service haproxy start

# config haproxy - add frontend and backend with balance roundrobin using echo
sudo echo "frontend my_http_front
bind *:80
default_backend my_httpd_back

frontend my_secret_front
bind *:8080
default_backend my_secret_back

backend my_httpd_back
balance roundrobin
server myweb1 192.168.1.10:80
server myweb2 192.168.1.11:80

backend my_secret_back
balance roundrobin
server mysecretweb 192.168.1.12:80" | sudo tee -a /etc/haproxy/haproxy.cfg

# restart haproxy
sudo service haproxy restart


