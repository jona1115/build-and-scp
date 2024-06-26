#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <compile_path> <env_init_script> <compile_command> <exe_path> <target_path>"
    printf "\nExample: ./build-and-scp.sh /home/jonathan/src init-environment.sh \"bitbake -c compile -f abc\" /home/jonathan/build/src/abc.exe root@192.168.1.1:~"
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
    echo "Failed to copy the executable to the target path. Trying to delete the remote file and copy again."
    ssh ${target_path%:*} "rm -f ${target_path#*:}"
    scp "$exe_path" "$target_path"
    if [ "$?" -ne 0 ]; then
        echo "Failed to copy the executable to the target path even after deleting the remote file."
        exit 1
    fi
fi

echo "Successfully compiled and copied the executable to the target path."

# Copy-and-paste-able example:
# ./build-and-scp.sh /home/jonathan/src "bitbake -c compile -f abc" /home/jonathan/build/src/abc.exe root@192.168.1.1:~
