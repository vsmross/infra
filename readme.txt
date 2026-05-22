What I have done so far

1. Used my personal AWS account to create AWS instance it is of (t3.small) type
2. This instance created manually, gave name "dev-machine-001"
3. Connected to ssh web console by clikcing on Connect button "sudo su -" command to switch to root user
4. Installed below tools
    a. git bash
          * Configure git ssh to connect to repository
          * Perform various git tasks like:
              -> git clone
              -> git pull/commit/push
              -> git config changes
    b. terraform
    c. ngnix server
        commands to install nginx
        install
            "sudo dnf install nginx -y"
        start and enable
            "sudo systemctl start nginx"
            "sudo systemctl enable nginx"
        check status
            "sudo systemctl status nginx"
        Test in browser
            "http://<your-ec2-public-ip>"
    d. Step-by-step: 
        Self-signed SSL for Nginx # Amazon Linux 2023
            "sudo dnf install -y openssl"   
        Generate self-signed certificate
            sudo mkdir -p /etc/nginx/ssl
            sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout /etc/nginx/ssl/nginx.key \
            -out /etc/nginx/ssl/nginx.crt


This repository is created to build AWS infrastructure using terraform
1. lets begin with creating ec2 instance with ngnix web server
