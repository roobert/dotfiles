# load ssh keys

if ssh-add -l|grep 'no identities' > /dev/null 2>&1
then
  for id in `find $HOME/.ssh/ -name "id_rsa*" -and -not -name "*.pub"`
  do
    ssh-add $id
  done

  ssh-add -l
fi

