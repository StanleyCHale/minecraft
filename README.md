# Project Part 2 - Minecraft Server in AWS with Terraform
## CS 312 - System Administration
Stanley Hale
6/3/2024


This document covers how to setup and configure a Minecraft server for Amazon Web Services’ EC2 instances using terraform. 
Video demonstration can be found [here](https://media.oregonstate.edu/media/t/1_64c162l2)

## 1.) Requirements
Install the following for this to work:
Install the Terraform CLI: [Install](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
Install the AWS CLI: [Install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
Obviously you will need and aws account. In this case I am using and educational account for a learner lab, so things might be different for non-educational accounts.

## 2.) Overview
As a brief overview of what we are doing to get this to work is:
* Setup our aws credentials to work with terraform
* Create a script that will launch our server
* Create a script that will setup a service file on our server (So it will launch the minecraft server on reboot)
* Create a terraform file that will create and setup a vpc, subnet, elastic ip, and an ec2 instance that will:
    * Upload our script files to the ec2 instance
    * Install Java 17
    * Download Spigot 1.20.4
    * Run our setup script
    * Run our launch script
    * Output our server's ip

## 3.) How to setup aws credentials

## 4.) How to run
First of all clone this repository into whatever directory you want (I did this in a local mobaxterm terminal in the home directory)

## 5.) Sources
