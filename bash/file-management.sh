#!/bin/bash

# File Management Script

echo "=== File Management Utilities ==="

# Function to display menu
display_menu() {
    echo ""
    echo "1. List files"
    echo "2. Create a new file"
    echo "3. Display file content"
    echo "4. Copy a file"
    echo "5. Move/Rename a file"
    echo "6. Delete a file"
    echo "7. Find files"
    echo "8. File properties"
    echo "9. Compare two files"
    echo "0. Exit"
    echo ""
}

# List files
list_files() {
    read -p "Enter directory path (default: current): " dir
    dir=${dir:-.}
    echo ""
    echo "Files in $dir:"
    ls -lh "$dir"
}

# Create a new file
create_file() {
    read -p "Enter filename to create: " filename
    if [ -z "$filename" ]; then
        echo "Filename cannot be empty"
        return
    fi
    
    read -p "Enter content (or press Enter for empty file): " content
    if [ -z "$content" ]; then
        touch "$filename"
    else
        echo "$content" > "$filename"
    fi
    echo "File '$filename' created successfully"
}

# Display file content
display_content() {
    read -p "Enter filename to display: " filename
    if [ ! -f "$filename" ]; then
        echo "File not found: $filename"
        return
    fi
    echo ""
    echo "=== Content of $filename ==="
    cat "$filename"
    echo "=========================="
}

# Copy a file
copy_file() {
    read -p "Enter source filename: " source
    read -p "Enter destination filename: " destination
    
    if [ ! -f "$source" ]; then
        echo "Source file not found: $source"
        return
    fi
    
    cp "$source" "$destination"
    echo "File copied from '$source' to '$destination'"
}

# Move/Rename a file
move_file() {
    read -p "Enter source filename: " source
    read -p "Enter destination filename: " destination
    
    if [ ! -f "$source" ]; then
        echo "Source file not found: $source"
        return
    fi
    
    mv "$source" "$destination"
    echo "File moved from '$source' to '$destination'"
}

# Delete a file
delete_file() {
    read -p "Enter filename to delete: " filename
    if [ ! -f "$filename" ]; then
        echo "File not found: $filename"
        return
    fi
    
    read -p "Are you sure? (y/n): " confirm
    if [ "$confirm" = "y" ]; then
        rm "$filename"
        echo "File '$filename' deleted successfully"
    else
        echo "Deletion cancelled"
    fi
}

# Find files
find_files() {
    read -p "Enter search pattern: " pattern
    read -p "Enter directory to search (default: current): " dir
    dir=${dir:-.}
    
    echo ""
    echo "Files matching '$pattern' in '$dir':"
    find "$dir" -name "*$pattern*" -type f 2>/dev/null
}

# File properties
file_properties() {
    read -p "Enter filename: " filename
    if [ ! -f "$filename" ]; then
        echo "File not found: $filename"
        return
    fi
    
    echo ""
    echo "=== Properties of $filename ==="
    echo "Size: $(du -h "$filename" | cut -f1)"
    echo "Lines: $(wc -l < "$filename")"
    echo "Words: $(wc -w < "$filename")"
    echo "Characters: $(wc -c < "$filename")"
    echo "Modified: $(stat -f%Sm -t%Y-%m-%d\ %H:%M:%S "$filename" 2>/dev/null || stat -c%y "$filename")"
    echo "Permissions: $(ls -l "$filename" | awk '{print $1}')"
    echo "Owner: $(ls -l "$filename" | awk '{print $3}')"
    echo "=============================="
}

# Compare two files
compare_files() {
    read -p "Enter first filename: " file1
    read -p "Enter second filename: " file2
    
    if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then
        echo "One or both files not found"
        return
    fi
    
    echo ""
    echo "=== Comparing $file1 and $file2 ==="
    diff "$file1" "$file2"
    if [ $? -eq 0 ]; then
        echo "Files are identical"
    else
        echo "Files are different"
    fi
}

# Main menu loop
while true; do
    display_menu
    read -p "Select an option: " choice
    
    case $choice in
        1) list_files ;;
        2) create_file ;;
        3) display_content ;;
        4) copy_file ;;
        5) move_file ;;
        6) delete_file ;;
        7) find_files ;;
        8) file_properties ;;
        9) compare_files ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
