#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <compile_path> <env_init_script> <compile_command> <exe_path> <target_path>"
    printf "\nExample: ./build-and-scp.sh /home/jonathan/src/io2000 init-build-cbc9000-ti \"bitbake -c compile -f platformd\" /path/to/build/src/infos/platform-infos root@10.106.171.240:~"
    printf "\n"
    exit 1
fi

# Assign the arguments to variables for better readability
compile_path=$1
env_init_script=$2
compile_command=$3
exe_path=$4
target_path=$5

# Navigate to the compile path
cd "$compile_path"

# Initialize the environment and the compile command in the same subshell
bash -c "source $env_init_script && $compile_command"

# Check if the compile command was successful
if [ "$?" -ne 0 ]; then
   echo "Compilation failed."
   exit 1
fi

# Use scp to copy the executable to the target path
scp "$exe_path" "$target_path"

# Check if the scp command was successful
if [ "$?" -ne 0 ]; then
    echo "Failed to copy the executable to the target path."
    exit 1
fi

echo "Successfully compiled and copied the executable to the target path."

# Copy-and-paste-able example:
# ./build-and-scp.sh /home/jonathan/src/io2000 init-build-cbc9000-ti "bitbake -c compile -f platformd" /home/jonathan/src/io2000/build/cbc9000-ti/tmp/work/aarch64-eaton-linux/platformd/1.0+gitAUTOINC+4b42382605-r1/build/src/infos/platform-infos root@10.106.171.240:~
