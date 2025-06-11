#!/bin/bash
set -e


LOGFILE="/tmp/setup.log"
exec > >(tee -a "$LOGFILE") 2>&1

yum update -y
amazon-linux-extras enable java-openjdk11
yum clean metadata
yum install -y java-19-openjdk


cd /home/ec2-user
git clone https://github.com/techeazy-consulting/techeazy-devops.git
cd techeazy-devops
chmod +x gradlew


./gradlew build
nohup ./gradlew bootRun &


sleep 30
curl -f http://localhost:80 || echo "App not responding"


BUCKET_NAME="${S3_BUCKET_NAME}"
aws s3 cp /tmp/setup.log s3://$BUCKET_NAME/logs/setup.log || echo "Log upload failed"
aws s3 cp /var/log/cloud-init.log s3://$BUCKET_NAME/logs/cloud-init.log || echo "Cloud-init log upload failed"


shutdown -h +10 &


# this is just for PR