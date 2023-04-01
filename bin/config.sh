#!/usr/bin/env bash

# ---------------------------------------------
# This is a rudimentariy coonfiguration management
# tool for production services with a simple php application
# ---------------------------------------------

# Check for package manager updates
# sudo apt-get update

# --------------------------
# Remove Debian Packages
# -------------------------
# Runs only if uninstall list is not empty
if [ -s ../debian_packages/uninstall.txt ]; then
  echo "Uninstalling Packages"
  # Populate our removal_list array
  declare -a removal_list
  while IFS='\n' read -r value; do
    removal_list+=( "${value}" )
  done < "../debian_packages/uninstall.txt"

  # Iterate removal_list. Remove if not already removed.
  for rm_pkg in "${removal_list[@]}"
  do
    if dpkg -l | grep -i "${rm_pkg}"; then
      sudo apt-get remove "${rm_pkg}" # Remove package
      sudo apt-get autoremove # Remove packages installed by other packages that aren't needed
      sudo apt-get clean # Removes .deb files no longer installed.
    fi
  done
fi

# --------------------------
# Install Debian Packages
# --------------------------

# Runs only if install list is not empty
if [ -s ../debian_packages/install.txt ]; then
  echo "Installing Packages"
  # Populate our install_list array
  declare -a install_list
  while IFS='\n' read -r value; do
    install_list+=( "${value}" )
  done < "../debian_packages/install.txt"

  # Iterate install_list array. Install if not already installed.
  for in_pkg in "${install_list[@]}"
  do
    if ! dpkg -l | grep "${in_pkg}"; then
      sudo apt-get install -y "${in_pkg}"
      if [ "${in_pkg}" == "mysql-server" ]; then
        # Create the MySQL database
        sudo mysql_install_db

        # Secure our installation by removing insecure defaults
        sudo mysql_secure_installation
      fi
    fi
  done
fi






# --------------------------
# Setting Metadata and Content
# --------------------------

# Replace default index.html with index.php if the file exists
if [ -f "/var/www/html/index.html" ]; then
  echo "Adding PHP Application configuration!"
  sudo rm /var/www/html/index.html
  touch /var/www/html/index.php
fi

if [ -s ../metadata.txt ]; then
  echo "Setting Metadata content!"
  declare -A metadata
  while IFS== read -r key value; do
    metadata[$key]=$value
  done < "../metadata.txt"
  sudo chmod "${metadata[permissions]}" "${metadata[file]}"
  sudo chown "${metadata[owner]}" "${metadata[file]}"
  sudo chgrp "${metadata[group]}" "${metadata[file]}"
  sudo echo "${metadata[content]}" > "${metadata[file]}"
fi

# --------------------------
#  Restart
# --------------------------
# needrestart


# --------------------------
#  Verify Application
# --------------------------
status_code=$(curl --write-out %{http_code} --silent --output /dev/null http://54.226.14.130)

if [[ "$status_code" -ne 200 ]] ; then
  echo "Application not running!"
else
  echo "Application running Successfully!"
fi