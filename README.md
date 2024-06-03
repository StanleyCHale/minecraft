# Project Part 2 - Minecraft Server in AWS with Terraform
## CS 312 - System Administration
Stanley Hale
6/3/2024


This document covers how to setup and configure a Minecraft server for Amazon Web Services’ EC2 instances using terraform. 
Video demonstration can be found [here](https://media.oregonstate.edu/media/t/1_64c162l2)

## 1.) Requirements
Obviously you will need and aws account. In this case I am using and educational account for a learner lab, so things might be different for non-educational accounts.
You will need to install the following for this to work:
* Install the Terraform CLI: [Install](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* Install the AWS CLI: [Install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* MobaXterm (Or whatever terminal you want to use): [Install](https://mobaxterm.mobatek.net/download.html)
* Nano (Or whatever text editor you want): [Install](https://www.nano-editor.org)


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

## 3.) How to run
### How to setup aws credentials
I stored my aws credentials in my MobaXTerm user's `~/.ssh/` directory.
Since I have an aws learner lab I can start the lab and on the same panel there is an option to `AWS Details`.
After clicking that it should bring up information on the right side pane. You will need to clickon `Show` where it says `AWS CLI` and copy everything in that drop down.
Now head back to our terminal and run these commands to open your editor and paste what we copied in: 
```
mkdir ~/.aws
touch ~/.aws/credentials
nano ~/.aws/credentials
```

### Create a new ssh key
Now we need to head into our aws managment console and create a new key with the key name `minecraft-key` and create as a `.pem` file.
Upon completion you should have a file downloaded named `minecraft-key.pem`.

Now that we have our key we will need to head back to our terminal and create the `~/.ssh` directory and create a new file in there name `server.pem` that will have the contents of the `minecraft-key` file we just downloaded.
```
mkdir ~/.ssh
touch ~/.ssh/server.pem
nano ~/.ssh/server.pem
```

### Run our Terraform file
Now that we have our credentials all setup we will need to clone this repository which can be done with the following command:
```
git clone <repo url>
```

Once we have it cloned there should be a new directory named `minecraft`.Navigate into that directory.
Now we will need to initialize terraform, which can be done with this command
```
terraform init
```
With terraform initialized we can setup our terraform plan by running the following command:
```
terraform plan --out /temp/mc
```
Now that our plan has been created and saved we can apply that plan and actually create our minecraft server instance!
```
terraform apply /temp/mc
```

### Connect to your Server!
It will take a while, but you should see the output of the instance's terminal. When the terraform file is finished you will see that the server's IP will be printed to the terminal.
This means that the instance has been succesfully created and setup, but you will have to wait 5+ minutes for the minecraft server to finish initializing and generating a world before you can connect to it.
After you wait a while you should see that you can connect to the server using that IP and start playing minecraft! Hooray, congrats!
The minecraft server will automatically restart upon rebooting the ec2 instance, so no need to SSH into it!

### Destroying your Instance
If you want to destroy (Not shutdown) your ec2 instance you can run the following command:
```
terraform destroy
```

## 4.) Sources
Here is a list of resoureces I used in the processs of creating this project:
* Terraform aws wiki: [Here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
* Terraform creating ec2 isntances tutorial: [Here](https://spacelift.io/blog/terraform-ec2-instance)
* Hashicorp's own wiki: [Here](https://developer.hashicorp.com/terraform/language/resources/provisioners/file)
* I also got some help form chatgpt with troubleshooting: [Here](https://chatgpt.com)
