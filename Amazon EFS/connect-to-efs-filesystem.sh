# Install amazon-efs-utils on EC2
sudo yum -y install amazon-efs-utils

# Create mount directory and mount file system
sudo mkdir /mnt/efs
sudo mount -t efs fs-d82ea12e:/ /mnt/efs

# Change into mount directory and create directory and file on file system
cd /mnt/efs
sudo mkdir test-directory
sudo chown ec2-user test-directory
cd test-directory
touch test-file.txt
ls -la