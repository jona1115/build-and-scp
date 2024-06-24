# build-and-scp
When developing for a external device from a host (like developing for a embedded system from Yocto/Petalinux), we often need to use the host device's cross compiler to compile our code, and scp the executable to the device. This is a simple task yet tedious. This script will do it for you.

# How to use?
1. Download/copy-paste the script to your device.
2. Set permission: `chmod +x build-and-scp.sh`
3. Run it: `./build-and-scp.sh <compile_path> <env_init_script> <compile_command> <exe_path> <target_path>`
   Arguments:
   1. `compile_path`: The path where you run the compilation command (like `make`, `gcc ...`, `bitbake xxx`, etc.)
   2. `env_init_script`: Some tools like Yocto and Petalinux requires you to set up the environment. This is where you will tell the script where the set up script is.
   3. `compile_command`: The command you run at `compile_path` to compile your code.
   4. `exe_path`: The path where the compiled executable go, this will be the thing being scp-ed to the device.
   5. `target_path`: The destination in the scp command.
Example: ./build-and-scp.sh /home/jonathan/src "bitbake -c compile -f abc" /home/jonathan/build/src/abc.exe root@192.168.1.1:~
