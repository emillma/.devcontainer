echo $(cat /etc/resolv.conf | grep -Po "(?<=nameserver ).*"):0.0 > display.txt
