# Import d'un fichier csv dont le delimiteur est un " ; ". On l'importe dans une variable dont va la parcourir plus tard
$users = import-csv -Path "Chemin/du/fichier.csv" -delimiter ";"

Foreach ($user in $users)
{
  $pass =""                          # Definition du mot de passe pour l'user
  $nom = $user.firstname             # Definition du nom du user en cherchant dans la var $user et en precisant la colonne avec firstname
  $prenom = $user.lastname           # Definition du prenom du user en cherchant dans la var $user et en precisant la colonne avec lastname
  $ou = $user.ou                     # Definition de l'ou du user en cherchant dans la var $user et en precisant la colonne avec ou

  # Ajout des utilisateurs
  New-ADuser -name $nom -givename $prenom -Path $ou
}

echo "Import termine"
