#!/bin/bash

# Storage Alert and Monitoring Script

echo "=== Storage Alert and Monitoring Utility ==="

# Configuration
THRESHOLD=80  # Disk usage percentage threshold
INODE_THRESHOLD=80  # Inode usage percentage threshold
EMAIL_ALERT=false
EMAIL_ADDRESS="admin@example.com"

# Function to display menu
display_menu() {
    echo ""
    echo "1. Check disk usage"
    echo "2. Check inode usage"
    echo "3. Monitor disk usage"
    echo "4. Find large files"
    echo "5. Check partition details"
    echo "6. View disk history"
    echo "7. Set alert threshold"
    echo "8. Clean disk space"
    echo "0. Exit"
    echo ""
}

# Check disk usage
check_disk_usage() {
    echo ""
    echo "=== Disk Usage Report ==="
    df -h
    
    echo ""
    echo "=== Disk Usage Analysis ==="
    df -h | awk 'NR>1 {
        gsub(/%/, "", $5);
        usage = $5;
        device = $1;
        mount = $6;
        if (usage >= 80) {
            print "WARNING: " device " (" mount ") is " usage "% full";
        } else {
            print "OK: " device " (" mount ") is " usage "% full";
        }
    }'
}

# Check inode usage
check_inode_usage() {
    echo ""
    echo "=== Inode Usage Report ==="
    df -i
    
    echo ""
    echo "=== Inode Usage Analysis ==="
    df -i | awk 'NR>1 {
        gsub(/%/, "", $5);
        usage = $5;
        device = $1;
        mount = $6;
        if (usage >= 80) {
            print "WARNING: " device " (" mount ") inodes are " usage "% used";
        } else {
            print "OK: " device " (" mount ") inodes are " usage "% used";
        }
    }'
}

# Monitor disk usage
monitor_disk_usage() {
    echo ""
    echo "=== Monitoring Disk Usage (Press Ctrl+C to stop) ==="
    
    while true; do
        clear
        echo "=== Disk Usage Monitor - $(date) ==="
        df -h | awk 'BEGIN {print "Filesystem       Size  Used Avail Use% Mounted"} NR>1'
        
        echo ""
        echo "=== Critical Analysis ==="
        df -h | awk 'NR>1 {
            gsub(/%/, "", $5);
            usage = $5;
            device = $1;
            mount = $6;
            if (usage >= 90) {
                print "🔴 CRITICAL: " device " (" mount ") is " usage "% full";
            } else if (usage >= 80) {
                print "⚠️  WARNING: " device " (" mount ") is " usage "% full";
            }
        }'
        
        sleep 5
    done
}

# Find large files
find_large_files() {
    read -p "Enter directory to search (default: /): " dir
    dir=${dir:-/}
    read -p "Enter minimum file size in MB (default: 100): " size
    size=${size:-100}
    
    echo ""
    echo "=== Files larger than ${size}MB in $dir ==="
    find "$dir" -type f -size +${size}M 2>/dev/null -printf '%s %p\n' | sort -rn | head -20 | awk '{print $1/1048576 " MB: " $2}'
}

# Check partition details
partition_details() {
    echo ""
    echo "=== Partition Details ==="
    parted -l 2>/dev/null
    
    if [ $? -ne 0 ]; then
        echo "Detailed partition info (using fdisk):"
        fdisk -l 2>/dev/null | head -30
    fi
}

# View disk history (if available)
view_disk_history() {
    history_file="/tmp/disk_usage_history.log"
    
    echo ""
    echo "=== Disk Usage History ==="
    
    if [ ! -f "$history_file" ]; then
        echo "No history available. Recording current state..."
        echo "$(date) - $(df -h | awk 'NR==2 {print $5}')" >> "$history_file"
    else
        echo "Recent disk usage records:"
        tail -10 "$history_file"
    fi
    
    # Record current state
    df -h | awk 'NR==2' | xargs -I {} sh -c 'echo "$(date) - {}" >> '"$history_file"
}

# Set alert threshold
set_threshold() {
    read -p "Enter disk usage threshold (0-100, default: 80): " new_threshold
    if [[ "$new_threshold" =~ ^[0-9]+$ ]] && [ $new_threshold -le 100 ]; then
        THRESHOLD=$new_threshold
        echo "Threshold set to $THRESHOLD%"
        
        read -p "Enable email alerts? (y/n): " enable_email
        if [ "$enable_email" = "y" ]; then
            read -p "Enter email address: " EMAIL_ADDRESS
            EMAIL_ALERT=true
            echo "Email alerts enabled to $EMAIL_ADDRESS"
        fi
    else
        echo "Invalid threshold value"
    fi
}

# Clean disk space
clean_disk_space() {
    echo ""
    echo "=== Disk Cleanup Options ==="
    echo "1. Clear temporary files (be careful!)"
    echo "2. Clear cache"
    echo "3. Remove old logs"
    echo "4. Remove deleted files"
    
    read -p "Select cleanup option (1-4): " cleanup_choice
    
    case $cleanup_choice in
        1)
            read -p "This will delete temp files. Continue? (y/n): " confirm
            if [ "$confirm" = "y" ]; then
                echo "Cleaning /tmp..."
                # Note: Be very careful with rm commands
                du -sh /tmp
                echo "Skipped actual deletion for safety"
            fi
            ;;
        2)
            echo "Clearing package manager cache..."
            echo "apt-get clean would be executed here (requires sudo)"
            ;;
        3)
            echo "Old logs:"
            find /var/log -name "*.1" -o -name "*.gz" 2>/dev/null | head -10
            echo "Use 'logrotate' to manage old logs"
            ;;
        4)
            echo "Showing deleted files info"
            lsof +L1 2>/dev/null | grep -v "COMMAND" | head -5
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

# Main menu loop
while true; do
    display_menu
    read -p "Select an option: " choice
    
    case $choice in
        1) check_disk_usage ;;
        2) check_inode_usage ;;
        3) monitor_disk_usage ;;
        4) find_large_files ;;
        5) partition_details ;;
        6) view_disk_history ;;
        7) set_threshold ;;
        8) clean_disk_space ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
