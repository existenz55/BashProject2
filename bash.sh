#!/bin/bash
 
# Array to hold menu options
options=(
 1 "See the date"
 2 "View the calendar"
 3 "Delete a file"
 4 "Show system specification"
 5 "Trace route of an IP packet"
 6 "Exit"
)
 
# Function to display the current date
showDate() {
   dialog --msgbox "Current Date: $(date)" 10 50
}
 
# Function to display the calendar
showCalendar() {
   dialog --msgbox "$(cal)" 15 30
}
 
# Function to delete a file
deleteFile() {
   # Get the directory of the file to be deleted
   path=$(dialog --title "File to delete" \
       --inputbox "Enter file path" 10 50 3>&1 1>&2 2>&3 3>&-) # 3>&1 1>&2 2>&3 3>&- means we do not have to make a file to hold the choice and then make a variable to hold the contents of that temporary file and then remove it
 
   # Check if user input is not empty
   if [ -n "$path" ]; then
       # Check if the directory exists
       if [ -d "$path" ]; then
           # Create an array to hold the menu options
           options=()
           counter=1
 
           # Fill the array with files from the directory
           for file in "$path"/*; do
               if [ -f "$file" ]; then
                  options+=("$counter" "$(basename "$file")")
                  counter=$((counter+1)) # increment counter
               fi
           done
 
           # Display the menu for file selection
          choice=$(dialog --title "Select a file to delete" \
                          --menu "Choose a file:" 15 60 4 \
                          "${options[@]}" \
                          3>&1 1>&2 2>&3 3>&-) # 3>&1 1>&2 2>&3 3>&- means we do not have to make a file to hold the choice and then make a variable to hold the contents of that temporary file and then remove it
 
           # Check if a file was selected
           if [ $? -eq 0 ]; then
              selectedFile="${options[$((choice*2-1))]}"
               dialog --yesno "Are you sure you want to delete $selectedFile?" 10 40
               if [ $? -eq 0 ]; then
                   rm -f "$path/$selectedFile"
                  dialog --msgbox "$selectedFile has been deleted." 10 40
                  showMenu
               else
                  dialog --msgbox "Deletion cancelled." 10 40
               fi
           else
               dialog --msgbox "No file selected." 10 40
           fi
       else
           dialog --msgbox "That directory does not exist" 10 40
       fi
   else
       dialog --msgbox "No directory entered" 10 40
   fi
}
 
showSystemSpecs() {
       # run the second script to get system specifications
       dialog --msgbox "$(./second_part.sh)" 60 100
}
 
# Function to trace the route a packet takes to user's ip address of choice
traceRoute() {
   ipAdress=$(dialog --title "Trace Route" \
       --inputbox "Enter IP address to trace route" 10 50 \
       3>&1 1>&2 2>&3 3>&-)
 
   if [ -n "$ipAdress" ]; then
       dialog --msgbox "$(traceroute $ipAdress)" 20 70
   else
       dialog --msgbox "No IP address entered" 10 40
   fi
}
 
# Function to display the main menu
showMenu() {
   while true; do
       # Capture the user's choice from the dialog menu, redirecting any error messages to the terminal
      CHOICE=$(dialog --clear \
                      --backtitle "My Menu" \
                      --title "Main Menu" \
                      --menu "Choose an option:" \
                      15 50 4 \
                      "${options[@]}"\
                      2>&1 >/dev/tty)
 
       case $CHOICE in
           1)
              showDate
               ;;
           2)
              showCalendar
               ;;
           3)
              deleteFile
               ;;
           4)
              showSystemSpecs
               ;;
           5)
               traceRoute
               ;;
           6)
               clear
               break
               ;;
           *)
               clear
               # Handle case where user presses Esc or Cancel
               break
               ;;
       esac
   done
}
 
 
# Start the script by displaying the main menu
showMenu
