# build-and-scp
When developing for an external device from a host (like developing for an embedded system from Yocto/Petalinux), we often need to use the host device's cross compiler to compile our code and scp the executable to the device. This is a simple yet tedious task. This script will do it for you.

# How to use?
1. Download/copy-paste the script to your Linux machine.
2. Set permission: `chmod +x build-and-scp.sh`
3. Run it: `./build-and-scp.sh <compile_path> <env_init_script> <compile_command> <exe_path> <target_path>`
   Arguments:
   1. `compile_path`: The path where you run the compilation command (like `make`, `gcc ...`, `bitbake xxx`, etc.)
   2. `env_init_script`: Some tools like Yocto and Petalinux require you to set up the environment. This is where you will tell the script where the setup script is.
   3. `compile_command`: The command you run at `compile_path` to compile your code.
   4. `exe_path`: The path where the compiled executable goes; this will be the thing being scp-ed to the device.
   5. `target_path`: The destination in the scp command. The script will attempt to delete the existing file if it fails to SCP. Hence, when typing out this argument, make sure to include the executable in the path, e.g. `root@192.168.1.1:~/abc.exe`, not just `root@192.168.1.1:~` which is common in normal SCPs.

Example:  
> ./build-and-scp.sh /home/jonathan/src "bitbake -c compile -f abc" /home/jonathan/build/src/abc.exe root@192.168.1.1:~/abc.exe

# What does the script do?
1. First, it cd into the source code/project folder.
2. Second, it sources the env_init_script.
3. Then, it runs the compile_command.
4. Then, it will try to SCP the generated executable (specified by exe_path) to the target (specified by target_path).
   1. If it fails the first time, it will ssh into the target and delete the file in that location. And SCP again. If it fails again, an error will be thrown.
5. If successful, print the success message and exit.
