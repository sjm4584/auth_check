#!/bin/bash

#Script checks for authentication successes or fails for su, sudo or ssh.

#auth.log logs all authentication shit
filepath=/var/log/auth.log

echo "[-] Where is your log file? "
read log_file
while true; do
  echo ""; echo ""
  echo "[-] What would you like to look for? "
  echo "   [1] Failures to authenticate with SSH"
  echo "   [2] Successes to authenticate with SSH"
  echo "   [3] Failures to authenticate with sudo"
  echo "   [4] Successes to authenticate with sudo"
  echo "   [5] Failures to authenticate with su"
  echo "   [6] Successes to authenticate with su "
  read -a user_input
  
  if [[ $user_input == "1" ]]; then
    echo "[+] Checking for failed SSH attempts..."
    awk '{print $3, $6, $5, $9, $10, $11, $12, $13}' $log_file | grep "Failed"
  elif [[ $user_input == "2" ]]; then
    echo "[+] Checking for successful SSH attempts..."
    awk '{print $3, $6, $5, "user -> ", $9, $10, $11, $12, $13}' $log_file | grep "Accepted"
  elif [[ $user_input == "3" ]]; then
    echo "[+] Checking for failed sudo attempts..."
    awk '{print $3, $9, "password ", $5, "user ->", $6, $15,"\t\t" $19}' /var/log/auth.log | grep "incorrect"
  elif [[ $user_input == "4" ]]; then
    echo "[+] Checking for successful sudo attempts..."
    awk '{print $3, $5, "user ->", $6, $7, "\t\t", $14}' $log_file | grep "COMMAND"
  elif [[ $user_input == "5" ]]; then
    echo "[+] Checking for successful su attempts..."
    awk '{print $3, $6, $7, $8, $9, $10, $11}' $log_file | grep "Successful"
  elif [[ $user_input == "6" ]]; then
    echo "[+] Checking for failed su attempts..."
    awk '{print $3, $6, $7, $8, $9, $10, $11}' $log_file | grep "FAILED"
  else
    echo "[+] Goodbye."
    exit 1
  fi


done
