#!/bin/bash
hostnamectl set-hostname ${hostname}

echo "127.0.0.1 ${hostname}" >> /etc/hosts



