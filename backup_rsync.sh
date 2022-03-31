#!/bin/bash

ssh_key="ssh -i /home/phobos/.ssh/id_rsa -o StrictHostKeyChecking=no"
local_dir=/home/phobos/scripts/archive
remote_machine=phobos@{change ip}
remote_dir=/home/phobos

echo "Step 1: Create a non-empty file"
for i in {1..5};do dd if=/dev/urandom of=archive/$i.txt bs=1M count=1;done
echo ""

echo "Step 2: Copying a file to a remote host"
rsync -azv -e "$ssh_key" $local_dir  $remote_machine:$remote_dir
echo ""

echo "Step 3: Add old file on a remote host"
$ssh_key $remote_machine  "dd if=/dev/urandom of=archive/old_file.txt bs=1M count=1 && \
touch -t 201812101830.55 $remote_dir/archive/old_file.txt && ls -lah $remote_dir/archive"
echo ""

echo "Step 4: Delete files on a remote host"
$ssh_key $remote_machine "find $remote_dir/archive -mtime +7 -delete && ls -lah $remote_dir/archive"
echo ""

echo "Done_test1000..."