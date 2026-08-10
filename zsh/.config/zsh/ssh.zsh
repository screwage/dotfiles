ssh-add $(find ~/.ssh -maxdepth 1 -type f -iname 'id_*' ! -name '*.pub') 2>/dev/null
