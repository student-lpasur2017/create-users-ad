# Voir : http://www.supinfo.com/articles/single/342-ajout-utilisateur-active-directory-aide-fichier-csv
# Import d'un fichier csv dont le delimiteur est un " ; ". On l'importe dans une variable dont va la parcourir plus tard
$users = import-csv -Path ".\users.csv" -delimiter ";"

# Initialisation variables
$premiereLettrePnom = ""
 # /!\ Pour la var $pass en-dessous de ce commentaire, powershell ne valide pas le type de variable. à voir
# $pass =$( ConvertFrom-SecureString -SecureString $(ConvertTo-SecureString "0p3nW1n" -AsPlainText -Force) -SecureKey 16) # La cmdlet "ConvertTo-SecureString" permet de convertir une chaine plaintext en system.secure et la cmdlet "ConvertFrom-SecureString" chiffre le type system.secure
$pass = Read-Host("Saisir MDP ( /!\ Saisie sans redemander la saisie du MDP. Vous avez une et unique chance) ") -AsSecureString
#---------- Selection du chemin OU (de l'AD) pour gerer les chemins dynamiquements ----------
$dcVoulu= Read-Host("Quel site voulez vous ? Exemple : 'alsace' ou  'paris' ")
#$ouPath="ou=Direction Alsace,DC="+$dcVoulu+",dc=OPENWIN,dc=COM"

# Creation des OU (groupe) pour les utilisateurs
dsadd ou "ou=Direction Alsace,DC=Alsace,dc=OPENWIN,dc=COM"
dsadd ou "ou=Commercial,DC=Alsace,dc=OPENWIN,dc=COM"
dsadd ou "ou=Secretariat,DC=Alsace,dc=OPENWIN,dc=COM"
dsadd ou "ou=Informatique,DC=Alsace,dc=OPENWIN,dc=COM"


# Parcours le contenu du fichier dans la vars $users. La vars doit etre sous forme de tableau(?)
Foreach ($user in $users)
{
  # Fonction qui ajoute les utilisateurs
  function ajout_user{
    # Ajout des utilisateurs
      # Remarque : N'ajoute pas les mdp car probleme de type de valeur
    New-ADuser -Name $nomComplet -GivenName $nom -SamAccountName $nameCompte -UserPrincipalName  $compteCo -SurName $prenom -Path $ou -AccountPassword $pass -EmailAddress  $email -PassThru | Enable-ADAccount # (pour activer compte) #-WhatIf

  }

  # /!\ Ne pas mettre d'accent dans les noms et prenoms /!\
  $nom = $user.firstname             # Definition du nom du user en cherchant dans la var $user et en precisant la colonne avec firstname
  $prenom = $user.lastname           # Definition du prenom du user en cherchant dans la var $user et en precisant la colonne avec lastname
  $ou = $user.ou                     # Definition de l'ou du user en cherchant dans la var $user et en precisant la colonne avec ou
  $email = $user.email               # Definition de l'email

  # nom du compte de l'utilisateur
  $premiereLettrePnom = $prenom.Substring($prenom.Length1,1)     # On recupere uniquement la premiere lettre du prenom
  $nameCompte = ($premiereLettrePnom+$nom).ToLower() # nom user pour se connecter et utilise le flag -SamAccountName et rendre tout en minuscule avec ToLower().

  # Compte utilisateur pour se connecter en utilisant -UserPrincipalName
  $compteCo = ($nameCompte+"@"+"alsace.openwin.com").ToLower() # Rendre tout en minuscule

  # Nom complet
  $nomComplet = $nameCompte     # Definition du nom complet - Premiere lettre du prenom et nom

  # Switch qui permet d'ajouter les utilisateurs en fonctions de l'OU. Pour ca
  switch ($dcVoulu)
  {
    # Si le choix de $dcvoulu est "paris" alors on applique les instructions suivantes
    "paris" {
      # test la presence de dc=paris dans le fichier csv. Si c'est le cas, alors l'utilisateur sera ajoute.
      $testOU=Select-String -InputObject $ou -Pattern "DC=paris"
      If ($testOU)
      {
        # Ajout d'un utilisateur en appelant la fonction ajout_user
        ajout_user
      }
    }
    # Si le choix de $dcvoulu est "alsace" alors on applique les instructions suivantes
    "alsace" {
      # test la presence de dc=paris dans le fichier csv. Si c'est le cas, alors l'utilisateur sera ajoute.
      $testOU=Select-String -InputObject $ou -Pattern "DC=alsace"
      If ($testOU)
      {
        # Ajout d'un utilisateur en appelant la fonction ajout_user
        ajout_user
      }
    }
  }
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
