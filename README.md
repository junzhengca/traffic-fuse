# traffic-fuse

A script to automatically shutdown your Linux server based on traffic usage.

⚠️ You should not use this for applications that requires high availability, as it will **shutdown** your server if the traffic usage is too high.

## Installation

Create a system crontab to run the script every 5 minutes, replace `eth0` with your network interface and `1000000000` with the maximum traffic usage in bytes for the 5 minute interval.

```bash
sudo echo "*/5 * * * * root /path/to/fuse.sh eth0 1000000000" > /etc/cron.d/traffic-fuse
```

You are done, the system will now shutdown if the traffic usage is above the threshold you set for the 5 minute interval. In this case, 1GB.

## Notes

We compute both RX and TX traffic, so both download and upload traffic will be considered.
