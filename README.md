# create-users-ad
Creation des utilisateurs avec powershell dans l'Active Directory en important un fichier csv

# Condition d'utilisation
Il est possible d'importer un fichier csv tout site confondu.  Le script ajoutera les utilisateurs fera en fonction de l'appartenance du site (du DC). Cependant, il faudra réécrire certaines "OU" qui sont statiques et non dynamiques comme :

        - La création des OU avec dsadd
        - La variable "$compteCo" pour la connection
