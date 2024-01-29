# !/bin/bash
 
# Display the operating system type
os_type=$(uname -s)
echo "Operating System Type: $os_type" # system type
echo
echo
 
# Display CPU information
echo "-----------------"
echo "CPU Information"
echo
lscpu
echo
echo
 
# Display memory information
echo
echo "-------------------"
echo "Memory Information"
free -h  # Human-readable format
echo
echo
 
# Display hard disk information
echo
echo "-------------------"
echo "Hard Disk Information"
lsblk
echo
echo
 
echo
echo "-------------------"
echo "Display file system (mounted) information"
df -h
