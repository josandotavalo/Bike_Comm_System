#!/bin/bash

sudo systemctl stop ntp
sudo ntpdate -u 3.ec.pool.ntp.org
sudo ntpdate -u 3.south-america.pool.ntp.org
sudo ntpdate -u 0.south-america.pool.ntp.org
sudo systemctl start ntp

sudo ntpq -p
