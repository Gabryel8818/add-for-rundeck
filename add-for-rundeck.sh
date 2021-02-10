#!/bin/bash

reduce(){
	local LOOP=$(vagrant status | grep running | awk -F" " '{ print $1 }' ) #Busca as máquinas ativas
	for M in $LOOP
	do
	  echo "Passando na máquina $M"; vagrant ssh "$M" -c "$CMD"; sleep 1.5; clear
	done # roda o comando na variável $CMD para todos as máquinas ativas
}


CMD="sudo useradd --system --shell /bin/bash --create-home --home-dir /var/lib/rundeck rundeck" # adiciona o usuário rundeck como subshell
reduce;

KEY="vagrant ssh automation -c 'sudo cat /root/keys/rundeck.pub'" #Chave pública do usuário rundeck
CMD="sudo -u rundeck -s /bin/bash -c \" mkdir -p ~/.ssh; echo '$KEY' > ~/.ssh/authorized_keys\"" # Cria o diretorio .ssh e adiciona a chave para authorized_keys
reduce;

CMD="sudo sed s/vagrant/rundeck/ /etc/sudoers.d/vagrant | sudo tee /etc/sudoers.d/rundeck" #Permite que o usuário rundeck rode comandos sem senha pelo ssh
for M in $(vagrant status | grep running | cut -d' ' -f1); do vagrant ssh $M -c "$CMD"; done

