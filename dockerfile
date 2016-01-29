# image construite à partir de l'image debian:wheezy de Docker Hub

FROM debian:wheezy

# dockerfile fait par Clémentine Chasles

MAINTAINER clementine_chasles

# installation du paquet libxml2-utils qui fournit xmllint

RUN apt-get update && apt-get install -y libxml2-utils

# construction d'un répertoire /home/script dans le container qui sera créé avec la commande docker run

RUN mkdir /home/script

# écriture du script de validation XML/XSD dans le fichier script_validationXML.sh à l'intérieur de /home/script
# \n = pour retourner à la ligne dans le script shell
# \$1 = \ est mis pour conserver l'écriture littérale de la variable $1
#      $1 est le nom de la variable shell qui contient le premier paramètre d'un script. Dans celui créé ici, il n'y en a qu'une. 

RUN echo "#!/bin/bash \nxmllint /home/xml/\$1.xml --schema /home/xml/\$1.xsd  --noout" > /home/script/script_validationXML.sh

# droit de lecture, écriture et d'execution sur script_validationXML.sh

RUN chmod 744 /home/script/script_validationXML.sh

# fait de /home/script le répertoire où l'on se trouve quand on crée le container

WORKDIR /home/script
