# Voir : http://www.supinfo.com/articles/single/342-ajout-utilisateur-active-directory-aide-fichier-csv
# Import d'un fichier csv dont le delimiteur est un " ; ". On l'importe dans une variable dont va la parcourir plus tard
$users = import-csv -Path ".\users.csv" -delimiter ";"

# Creation des OU (groupe) pour les utilisateurs
dsadd ou "ou=Direction Alsace,DC=Alsace,dc=OPENWIN,dc=COM"
dsadd ou "ou=Commercial,DC=Alsace,dc=OPENWIN,dc=COM"
dsadd ou "ou=Commercial,DC=Alsace,dc=OPENWIN,dc=COM"
dsadd ou "ou=Secretariat,DC=Alsace,dc=OPENWIN,dc=COM"
dsadd ou "ou=Informatique,DC=Alsace,dc=OPENWIN,dc=COM"

# Parcours le contenu du fichier dans la vars $users. La vars doit etre sous forme de tableau(?)
Foreach ($user in $users)
{
  $pass = "0p3nW1n"                  # Definition du mot de passe pour l'user
  # /!\ Ne pas mettre d'accent dans les noms et prenoms /!\
  $nom = $user.firstname             # Definition du nom du user en cherchant dans la var $user et en precisant la colonne avec firstname
  $prenom = $user.lastname           # Definition du prenom du user en cherchant dans la var $user et en precisant la colonne avec lastname
  $ou = $user.ou                     # Definition de l'ou du user en cherchant dans la var $user et en precisant la colonne avec ou
  $email = $user.email               # Definition de l'email
  # -SamAccountName                 # nom user pour se co
  # -UserPrincipalName # $samaccount+@alsace.openwin.fr
  $nomComplet = $nom+" "+$prenom     # Definition du nom complet - Premiere lettre du prenom et nom

  # Ajout des utilisateurs
    # Remarque : N'ajoute pas les mdp car probleme de type de valeur
  New-ADuser -Name $nomComplet -GivenName $nom -SurName $prenom -Path $ou -EmailAddress $email # PassThru | Enable-ADAccount (pour activer compte) # -AccountPassword $pass #-WhatIf
}

echo " "
echo " "
echo " "
echo " "
echo " "
echo "Import termine !"
echo " "
echo " "
echo " "
echo " "
echo " "
