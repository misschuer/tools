user=$(id -un)
sshDir=~/.ssh
keyFile=$sshDir/authorized_keys
ssh-keygen -t rsa -C "$user@gg" -f $user.key

touch $keyFile
cat $sshDir/$user.key.pub >> $keyFile
chmod 700 $sshDir/
chmod 600 $keyFile
sz $sshDir/$user.key
