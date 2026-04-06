#!/bin/bash

# Basic Shell Scripting Tutorial

echo "=== Basic Shell Scripting Examples ==="

# 1. Variables
echo ""
echo "1. Variables:"
name="OS Algorithms"
version=1.0
echo "Script Name: $name"
echo "Version: $version"

# 2. Input from user
echo ""
echo "2. User Input:"
read -p "Enter your name: " user_name
echo "Hello, $user_name!"

# 3. Arrays
echo ""
echo "3. Arrays:"
declare -a fruits=("Apple" "Banana" "Orange" "Mango")
echo "Fruits: ${fruits[@]}"
echo "First fruit: ${fruits[0]}"
echo "Number of fruits: ${#fruits[@]}"

# 4. String operations
echo ""
echo "4. String Operations:"
text="Hello World"
echo "Original: $text"
echo "Length: ${#text}"
echo "Substring: ${text:0:5}"
echo "Uppercase: $(echo $text | tr '[:lower:]' '[:upper:]')"

# 5. Arithmetic operations
echo ""
echo "5. Arithmetic Operations:"
a=10
b=5
echo "$a + $b = $((a + b))"
echo "$a - $b = $((a - b))"
echo "$a * $b = $((a * b))"
echo "$a / $b = $((a / b))"
echo "$a % $b = $((a % b))"

# 6. Conditional statements
echo ""
echo "6. Conditional Statements:"
age=25
if [ $age -ge 18 ]; then
    echo "Age $age: Adult"
else
    echo "Age $age: Minor"
fi

# 7. Case statement
echo ""
echo "7. Case Statement:"
day=3
case $day in
    1) echo "Monday" ;;
    2) echo "Tuesday" ;;
    3) echo "Wednesday" ;;
    4) echo "Thursday" ;;
    5) echo "Friday" ;;
    6) echo "Saturday" ;;
    7) echo "Sunday" ;;
esac

# 8. Loops
echo ""
echo "8. For Loop:"
echo "Numbers from 1 to 5:"
for i in {1..5}; do
    echo -n "$i "
done
echo ""

# 9. While loop
echo ""
echo "9. While Loop:"
count=1
echo "Counting from 1 to 3:"
while [ $count -le 3 ]; do
    echo -n "$count "
    count=$((count + 1))
done
echo ""

# 10. Functions
echo ""
echo "10. Functions:"
greet() {
    echo "Welcome to $1!"
}
greet "Shell Scripting"

# 11. File operations
echo ""
echo "11. File Operations:"
test_file="/tmp/test_$$.txt"
echo "Creating file: $test_file"
echo "This is a test file" > $test_file
if [ -f $test_file ]; then
    echo "File exists"
    echo "File content:"
    cat $test_file
    rm $test_file
    echo "File deleted"
fi

# 12. Command substitution
echo ""
echo "12. Command Substitution:"
echo "Current date: $(date)"
echo "Current user: $(whoami)"
echo "Current directory: $(pwd)"

echo ""
echo "=== End of Basic Shell Scripting Examples ==="
