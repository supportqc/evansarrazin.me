# Titre: WEB2_SAR_PFI
# Auteur: Evan Sarrazin

Projet nodeJS d’application Web transactionnelle
Pour cette partie, vous devrez faire un programme en vous servant des fichiers et exemples que j’ai fait pendant le cours. Il s’agit d’écrire un programme qui démarre un serveur Web afin de réaliser une application complète de gestion de notre collection de livres et d’usagers.

Votre serveur Web doit écouter sur le port 8000 et afficher la page d’accueil permettant de se connecter au programme. La page d’accueil redirige le lecteur sur la page d’identification de l’usager (la page login). Une fois identifié, il faut afficher le menu du site (la page d’accueil), qui permet à l’usager soit de gérer des utilisateurs (dans la BD) ou de gérer ou d’afficher la collection de livres ou encore de se déconnecter (logout) (la page d’accueil affiche 3 choix). Aucune page Web ne doit s’afficher (autre que login) tant que l’usager ne s’est pas identifié correctement avec un mot de passe valide. Voici la page d’accueil à reproduire :

 

Dans ce travail nous allons ajouter la notion de rôles et nous allons accepter trois rôles distincts, soit ‘normal’, ‘admin’ et ‘gestion’. Tous les utilisateurs auront au moins le rôle normal qui est automatiquement ajouté lors de la création. Vous devez modifier les pages de gestions des usagers afin d’y inclure cette nouvelle donnée, le rôle (dans des checkbox). De plus, nous allons inclure une image qui peut être téléversée dans le profil de chaque usager. Il faut permettre d’ajouter et de modifier le rôle et l’image de profil en plus des autres informations des usagers.

La gestion des usagers n’est disponible qu’aux utilisateurs possédant le rôle ‘admin’. Toutes les pages de la section gestion des usagers ne doivent être accessibles qu’aux utilisateurs possédant ce rôle. 

Pour ce qui est du 2e choix du menu « Affichage/Gestion des livres », il permet d’afficher le contenu de la collection livres pour tous les utilisateurs (dans une liste). Les options de gestion des livres ne seront accessibles qu’aux usagers qui possèdent le rôle ‘gestion’. Il faudra donc afficher les livres à tout le monde et permettre de modifier le contenu seulement si l’utilisateur possède le rôle ‘gestion’ (ajout, suppression, modification). Il faut aussi afficher dans une balise img le contenu de url_image de la collection livres. Vous n’avez pas à valider que le fichier image est disponible sur l’URL (juste l’afficher). Vous devriez l’afficher en miniature sur la liste des livres et en plus gros lors de l’affichage des détails. (il faut permettre de changer l’URL lors de la modification d’un livre).

L’affichage et la conception des pages de gestion des usagers (de même que pour les livres) est laissé à votre discrétion. Vous devez permettre l’affichage, l’ajout, la modification et la suppression des usagers. J’imagine très bien une liste des usagers avec des boutons pour modifier et supprimer (avec confirmation). Utilisez votre imagination, bootstrap et « fontawesome » pour afficher d’élégants boutons. 

Naturellement la section route est le point central de votre application Web, car tout se décide dans cette section. Voici les routes que vous devriez avoir :
-	GET « /usagers/login » pour la page de connexion (authentification)
-	GET de la page d’accueil qui va accepter « / » ou « /index » ou encore « /index.html »
-	GET « /usagers/logout » pour déconnecter l’usager
-	GET « /usagers/menu » (afin d’afficher une liste des usagers)
-	GET « /usagers/editer » (afin d’afficher un usager pour le modifier)
-	GET « /usagers/ajouter » (afin d’afficher un usager pour l’ajouter dans la BD)
-	GET « /usagers/supprimer » (afin d’afficher un usager pour confirmer la suppression)
-	GET de la page des livres « /livres/ » (afin d’afficher la liste des livres)
-	GET « /livres/editer » (afin d’afficher un livre pour le modifier)
-	GET « /livres/ajouter » (afin d’afficher un livre pour l’ajouter dans la BD)
-	GET « /livres/supprimer » (afin d’afficher un livre pour confirmer la suppression)
-	Sans oublier les routes POST envoyer à partir des différents formulaires

Aucune de ces pages (sauf login) ne devraient être accessibles si l’utilisateur n’est pas authentifié. Les sections qui se ressemblent d’une page à l’autre devraient se retrouver dans un « layout partiel » (comme par exemple, l’affichage d’un usager pour l’ajout ou encore pour le modifier). Vous pouvez ajouter d’autres routes selon vos besoins, mais les routes identifiées ci-dessus sont obligatoires.

Votre application doit être facile à utiliser et vous devez soigner la présentation. Lors de la remise du travail vous devrez faire une présentation de l’exécution de votre travail au professeur. 

De façon à ce que je puisse me connecter à votre application vous devez me créer un utilisateur dans votre BD qui se nomme ‘Alain Pilon’ et utilise un email ‘alain@gmail.com’ et mot de passe ‘alain9’ (et possède les privilèges : admin, normal et gestion).
