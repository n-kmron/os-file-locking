#!/bin/bash
#NOM    : Demo
#CLASSE : File Locking
#OBJET  : réservé au makefile
#AUTEUR : Cameron Noupoue

C='\033[44m'
E='\033[32m\033[1m'
W='\033[31m\033[1m'
N='\033[0m'
DIR_PATH=$(pwd)

# Fonction pour attendre l'appui sur la touche "Entrée"
pause() {
  read -p "Appuyez sur Entrée pour continuer..."
}

# Nettoyer le fichier balance.dat et mettre la valeur à 100
echo "100" > "balance.dat"

# Démonstration des scripts a.sh et b_non-cooperative.sh
echo "Démonstration de l'acquisition d'un verrou sur un fichier par un processus mais dont l'autre processus n'est pas coopératif"
echo -e "${E}Remarque${N} : Cette démo exécute les scripts a.sh et b_non-cooperative.sh à la suite de l'autre. Le fichier balance.dat sera ensuite lu et affiché."
echo "-----------------------------------------------------------------------"

pause 

# Exécution de a.sh en arrière-plan
echo
echo -e "Exécution de ${E}a.sh${N} en arrière-plan :"
"./a.sh" &

# Attendre 1 seconde
sleep 1

# Exécution de b_non-cooperative.sh en arrière-plan
echo
echo -e "Exécution de ${E}b_non-cooperative.sh${N} en arrière-plan :"
"./b_non-cooperative.sh" &

# Attendre que les deux processus se terminent
wait

# Lire et afficher le contenu de balance.dat
echo -e "Lecture et affichage de ${E}balance.dat${N} :"
cat "balance.dat"
echo -e "On observe que la valeur de la balance est de 180, ce qui n'est pas celle attendue, car b a pris la valeur de la balance avant que celle-ci n'ait été traitée par a."
echo "Programme terminé"
echo "-----------------------------------------------"

# Nettoyer le fichier balance.dat et mettre la valeur à 100
echo "100" > "balance.dat"

pause

# Démonstration des scripts a.sh et b.sh
echo "Démonstration de l'acquisition d'un verrou sur un fichier par deux processus coopératifs"
echo -e "${E}Remarque${N} : Cette démo exécute les scripts a.sh et b.sh à la suite de l'autre. Le fichier balance.dat sera ensuite lu et affiché."
echo "-----------------------------------------------------------------------"

pause

# Exécution de a.sh en arrière-plan
echo
echo -e "Exécution de ${E}a.sh${N} en arrière-plan :"
"./a.sh" &

# Attendre 1 seconde
sleep 1

# Exécution de b.sh en arrière-plan
echo
echo -e "Exécution de ${E}b.sh${N} en arrière-plan :"
"./b.sh" &

# Attendre que les deux processus se terminent
wait

# Lire et afficher le contenu de balance.dat
echo -e "Lecture et affichage de ${E}balance.dat${N} :"
cat "balance.dat"
echo -e "On observe que la valeur de la balance est de 160, ce qui attendu, car b a été contraint d'attendre que a libère le verrou qu'il a acquis sur le fichier balance."
echo "Programme terminé"
echo "-----------------------------------------------"

pause

# Démonstration de l'output lslocks
echo -e "Affichage simple et aperçu de la commande ${E}lslocks${N} par rapport à votre environnement"
echo -e "Veillez à lancer le logiciel ${E}Firefox${N} pour comprendre la commande et avoir des locks en rapport avec firefox"
pause
lslocks | grep 'firefox'
echo "Pour mieux comprendre cet affichage, voici une aide"
echo -e "${E}COMMAND${N}: Le nom de la commande ou du processus qui a émis le verrou sur le fichier."
echo -e "${E}PID${N}: PID du processus qui a émis le verrou."
echo -e "${E}TYPE${N}: Le type de verrouillage émis sur le fichier (il peut être FLOCK (créé avec flock) ou POSIX (créé avec fcntl))."
echo -e "${E}SIZE${N}: La taille du verrou en octets."
echo -e "${E}MODE${N}: Les droits d'accès (lecture, écriture ou * si le processus est bloqué)."
echo -e "${E}M${N}: Vaut 1 si le verrou est obligatoire (mandatory), 0 si requis coopérativité (1)."
echo -e "${E}START${N}: L'offset à partir duquel le verrou commence dans le fichier."
echo -e "${E}END${N}: L'offset jusqu'où le verrou s'étend dans le fichier."
echo -e "${E}PATH${N}: Le chemin complet du fichier verrouillé."
echo "Programme terminé"
echo "-----------------------------------------------"

pause

# Démonstration de l'AS fnctl
echo -e "Démonstration de l'${E}AS fnctl${N} dans le cadre d'un Advisory Lock avec un fichier database locale"
echo -e "Le programme lance 2 process : un père et un fils qui tenteront d'avoir accès au fichier database.txt afin d'y écrire des données"
echo -e "${E}ATTENTION${N} Veillez à mettre des espaces après vos mots pour les distinguer dans la DB et lorsque vous avez fini avec un process, entrez 'quit' pour terminé l'un des deux process"
pause
./fnctl
cat "database.txt"

echo "Programme terminé"

make clean
