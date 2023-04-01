# CMT
A Custom Configuration Management Tool to configure server with PHP Web Application


## **_Usage_**

* Transfer directory to the destination server using scp 


* CD into the bin directory

  ```bash
  cd CMT/bin
  ```

* Make the script executable

  ```bash
  chmod +x config.sh 
  ```

* Run the config script

  ```bash
  ./config.sh
  ```

## Configurations:

* To install a package, add the package name to the text file labeled "install.txt" inside the "debian_packages" directory. 
* For removing an installed package, add the package names to the "uninstall.txt" file inside the "debian_packages" directory.
* To set metadata and file content, you will need to add key value pairs into the "metadata.txt" file. Key value pairs must be separated by "=" 
