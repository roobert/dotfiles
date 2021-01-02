# load ssh keys
ssh-add -l|grep 'no identities' > /dev/null 2>&1

if [[ $? = 0 ]]; then
  for id in `find $HOME/.ssh/ -name "id_rsa*" | grep -v 'id_rsa.pub'`; ssh-add $id
  ssh-add -l
fi
