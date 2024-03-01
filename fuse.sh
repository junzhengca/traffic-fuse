#!/bin/bash

# Set default interface if not provided
INTERFACE=${1:-eth0}
# Set the threshold to 1GB if not provided
THREASHOLD_BYTES=${2:-1000000000}

# Get current RX and TX bytes
RX1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

# If the file doesn't exist, create them and store the
# current RX and TX bytes.
if [ ! -f /tmp/fuse_rx_diff ]; then
    echo $RX1 > /tmp/fuse_rx_diff
fi
if [ ! -f /tmp/fuse_tx_diff ]; then
    echo $TX1 > /tmp/fuse_tx_diff
fi

# Get previous RX and TX bytes stored in a file
RX2=$(cat /tmp/fuse_rx_diff)
TX2=$(cat /tmp/fuse_tx_diff)

# Calculate the difference between current and previous RX and TX bytes in bash
RX_DIFF=$((RX1 - RX2))
TX_DIFF=$((TX1 - TX2))

# Store the current RX and TX bytes in a file
echo $RX1 > /tmp/fuse_rx_diff
echo $TX1 > /tmp/fuse_tx_diff

# Print the difference
echo "RX: $RX_DIFF bytes"
echo "TX: $TX_DIFF bytes"

# If total diff is less than the threshold, do nothing, otherwise shutdown
if [ $((RX_DIFF + TX_DIFF)) -gt $THREASHOLD_BYTES ]; then
    echo "Threshold exceeded, shutting down"
    shutdown -h now
else
    echo "Threshold not exceeded, doing nothing"
fi
