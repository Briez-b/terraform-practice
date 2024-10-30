#!/bin/bash
sudo apt update
sudo apt install -y apache2

# Download the images from S3 bucket
sudo curl -o /var/www/html/index.html https://s3.eu-central-1.amazonaws.com/bryshten.com/index.html

# Start Apache and enable it on boot
sudo systemctl restart apache2
sudo systemctl enable apache2