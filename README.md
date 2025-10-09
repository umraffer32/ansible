# ansible
Let's have some fun with ansible! I will start by pinging my 3 workers.

Update the /etc/ssh/sshd_config:
password auth yes
root login yes
public key yes

Update the password:
passwd root "thepassword"
