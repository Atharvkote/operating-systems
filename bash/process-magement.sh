#!/bin/bash

# Process Management Script

echo "=== Process Management Utilities ==="

# Function to display menu
display_menu() {
    echo ""
    echo "1. List all processes"
    echo "2. List processes by user"
    echo "3. List processes by name"
    echo "4. Show process details"
    echo "5. Monitor top processes"
    echo "6. Kill a process"
    echo "7. Show process tree"
    echo "8. Get process count"
    echo "9. CPU and Memory usage"
    echo "0. Exit"
    echo ""
}

# List all processes
list_all_processes() {
    echo ""
    echo "=== All Running Processes ==="
    ps aux | head -20
    echo "... (showing first 20, use 'ps aux' for all)"
}

# List processes by user
list_by_user() {
    read -p "Enter username: " username
    echo ""
    echo "=== Processes for user: $username ==="
    ps -u "$username" -o pid,user,comm,%mem,%cpu
}

# List processes by name
list_by_name() {
    read -p "Enter process name: " procname
    echo ""
    echo "=== Processes matching '$procname' ==="
    ps aux | grep -i "$procname" | grep -v grep
}

# Show process details
show_process_details() {
    read -p "Enter Process ID (PID): " pid
    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo "Invalid PID"
        return
    fi
    
    echo ""
    echo "=== Details for PID $pid ==="
    ps -p $pid -o pid,user,comm,state,%mem,%cpu,etime
    
    echo ""
    echo "Open files:"
    lsof -p $pid 2>/dev/null | head -10
}

# Monitor top processes
monitor_top() {
    read -p "Enter number of processes to show (default: 10): " count
    count=${count:-10}
    
    echo ""
    echo "=== Top $count Processes by CPU ==="
    ps aux --sort=-%cpu | head -$((count + 1))
    
    echo ""
    echo "=== Top $count Processes by Memory ==="
    ps aux --sort=-%mem | head -$((count + 1))
}

# Kill a process
kill_process() {
    read -p "Enter Process ID (PID) to kill: " pid
    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo "Invalid PID"
        return
    fi
    
    read -p "Enter signal (default: TERM, options: TERM/KILL): " signal
    signal=${signal:-TERM}
    
    kill -${signal} $pid 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Process $pid terminated with ${signal} signal"
    else
        echo "Failed to kill process $pid"
    fi
}

# Show process tree
show_process_tree() {
    read -p "Enter Process ID or name (default: init): " proc
    proc=${proc:-init}
    
    echo ""
    echo "=== Process Tree ==="
    if [[ "$proc" =~ ^[0-9]+$ ]]; then
        pstree -p $proc 2>/dev/null || ps -ef --forest | grep -E "PID|$proc"
    else
        pstree -p $(pgrep -f "$proc" | head -1) 2>/dev/null || ps -ef --forest | grep -i "$proc"
    fi
}

# Get process count
get_process_count() {
    echo ""
    echo "=== Process Count Statistics ==="
    total=$(ps aux | wc -l)
    echo "Total processes: $total"
    
    user_procs=$(ps -u $(whoami) | wc -l)
    echo "Your processes: $user_procs"
    
    system_procs=$(ps -u root | wc -l)
    echo "System processes: $system_procs"
    
    echo ""
    echo "Processes by state:"
    ps aux | awk '{print $8}' | sort | uniq -c | tail -n +2
}

# CPU and Memory usage
show_usage() {
    echo ""
    echo "=== System CPU and Memory Usage ==="
    
    if [ -f /proc/meminfo ]; then
        echo "Memory Info:"
        grep "MemTotal\|MemAvailable\|MemFree" /proc/meminfo
        
        echo ""
        echo "CPU Info:"
        grep "processor" /proc/cpuinfo | wc -l | xargs echo "Number of CPUs:"
    fi
    
    echo ""
    echo "Top processes by resource usage:"
    ps aux --sort=-%cpu,%mem | head -6
}

# Main menu loop
while true; do
    display_menu
    read -p "Select an option: " choice
    
    case $choice in
        1) list_all_processes ;;
        2) list_by_user ;;
        3) list_by_name ;;
        4) show_process_details ;;
        5) monitor_top ;;
        6) kill_process ;;
        7) show_process_tree ;;
        8) get_process_count ;;
        9) show_usage ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
