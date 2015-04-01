#!/bin/bash
url="192.168.15.138:5000/time"
TIME="$(curl -s "$url")"
sudo date -s "$(curl -s "$url")"
echo $TIME
