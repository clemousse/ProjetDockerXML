# Application permettant de valider un XML et son XSD sur une machine supportant Docker

##1. Installation de Docker

Rendez-vous sur le site **<https://docs.docker.com/>** et choississez l'installation de Docker adéquate en fonction de votre système d'exploitation.

Docker ne tourne que sous Linux et les configurations requises sont les suivantes :

* Debian Wheezy et plus
* Kernel 3.10

Cependant, on peut installer une Docker ToolBox pour créer une machine virtuelle Linux qui permettra l'accès à Docker sur Mac OS X et Windows en respectant les configurations ci-dessous :

* Mac OS X 10.8 Mountain Lion et plus.
* Windows 7 et plus

Avant de puller une image, si votre Docker fonctionne derrière un proxy, pensez à le configurer :

* un exemple sous Debian Wheezy, dans le répertoire /etc/default/, il s'agit du fichier **docker** :

![Configuration proxy](snapshots/proxy.png)

Pour ne pas avoir de problème de proxy par la suite tout au long de votre travail, lancez le container **[klabs/forgetproxy](https://hub.docker.com/r/klabs/forgetproxy/)** (accessible sur Docker Hub) en tâche de fond (-d) :

>docker run -d --net=host --privileged -e http_proxy=http://***myproxy***:3128 -e https_proxy=http://***myproxy***:3128 klabs/forgetproxy

Dans le cas où nous sommes à l'ENSG, ***myproxy*** sera ***10.0.4.2***

*NB : Une fois votre travail terminé, il vous faudra rétablir les règles de proxy par défaut avant de supprimer votre container :*

>*docker run --net=host --privileged klabs/forgetproxy stop*

##2. Création du dockerfile (qui permet de construire l'image)

![Dockerfile](snapshots/dockerfile.png)

**Pour construire l'image à partir du répertoire dans lequel se trouve le dockerfile et dans lequel on est (grâce au ".") :**

>docker build -t clementine:xml .

![Résultat docker build partie 1](snapshots/docker_build1.png)
![Résultat docker build partie 2](snapshots/docker_build2.png)

... et l'image est bien là !

![Résultat docker images](snapshots/docker_images.png)

##3. Création du container et exécution de la validation xml

>docker run -v ***votreRepertoireFichier***:/home/xml clementine:xml ./script_validationXML.sh ***nomFichier***

***votreRepertoireFichier*** = indiquez le chemin absolu de vos fichiers xml et xsd qui doivent se situer dans le même répertoire

Grâce à -v, toutes les données écrites dans ***votreRepertoireFichier*** seront copiées dans /home/xml. Docker a ainsi monté le répertoire
de la machine hôte ***votreRepertoireFichier*** sur /home/xml dans le container pour que les deux puissent communiquer entre eux.

**clementine:xml** est le nom de l'image disponible sur Docker Hub => repository:tag

**./script_validationXML.sh** correspond à l'éxecution du script "script_validationXML.sh".
***nomFichier*** est le paramètre qui sera donné à la variable $1. (cf. dockerfile).

un exemple :

>docker run -v /home/gtsi/test:/home/xml clementine:xml ./script_validationXML.sh annuaire

![Résultat docker run](snapshots/docker_run.png)

... et le container est bien créé en effet !

![Résultat docker ps](snapshots/docker_ps.png)

##3. Sources diverses (parmi tant d'autres...)

###Sur le fonctionnement général de Docker :
  - <https://docs.docker.com/>
  - <https://www.wanadev.fr/>

###Pour les problèmes de proxy : 
  - <http://blog.kaliop.com/blog/2015/05/26/docker-dans-la-vraie-vie-les-parties-delicates/#ancre1>

###Pour l'installation et l'utilisation de xmllint :
  - <https://packages.debian.org/fr/sid/libxml2-utils>
  - <http://blog.touv.fr/2005/06/xmllint-un-couteau-suisse-pour-les.html>
  - <http://xmlsoft.org/xmllint.html>
  - <http://www.developpez.net/forums/d172298/autres-langages/xml-xsl-soap/valider/contributions-valider-xml-xsd/>
  - <http://flowingmotion.jojordan.org/2011/10/08/3-steps-to-download-xmllint/>

###Pour construire un dockerfile :
  - <http://putaindecode.io/fr/articles/docker/dockerfile/>
  - <http://blog.ippon.fr/2014/10/20/docker-pour-les-nu-pour-les-debutants/>

###Pour le langage shell et la construction du script : 
  - <https://openclassrooms.com/courses/reprenez-le-controle-a-l-aide-de-linux/introduction-aux-scripts-shell>





