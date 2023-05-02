const express = require('express');
const nodeJSpath = require('path');
const fs = require('fs');
const router = express.Router();
const passport = require('passport');
const bcrypt = require('bcryptjs');
const Usagers = require('../modeles/usagers');
const mongoose = require('mongoose');
const { estAuthentifie, estAdmin, forwardAuthenticated } = require('../config/auth');



router.get("/", estAuthentifie, (requete, reponse) => {
    reponse.render("usagers", {
      titre: "Gestion des usagers",
      user: requete.user,
    });
  });

router.post('/login', (req, rep, next)=>{
    passport.authenticate('local', {
        successRedirect: '../menu',
        failureRedirect: '/',
        failureFlash: true
    })(req, rep, next);
});

router.get('/menu', estAuthentifie, (requete, reponse) => {
    Usagers.find({}, null, {sort: {login: 1}}).exec()
    .then(usagers=>reponse.render('listeUsagers', {
        titre: 'Liste des usagers',
        usagers,
        user: requete.user 
    }))
    .catch(err=>console.log(err));
});

router.get('/register', estAdmin, (requete, reponse) =>  
    reponse.render('register', {titre: 'Ajout d\'un usagers'}));

router.post('/register', estAdmin, (requete, reponse) => {
    const {nom, login, password, password2, admin, gestion} = requete.body;
    const {originalname, destination, filename, size, path, mimetype} = requete.files[0];
    const maxFileSize = 1024*10;
    const mimetypePermis = ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/webp'];
    let errors = [];
    let roles = ['normal'];
    if (admin === 'on')
        roles.push('admin');
    if (gestion === 'on')
        roles.push('gestion');

    if (size > maxFileSize) {
        errors.push( {msg: `La taille du fichier est trop grande (max ${maxFileSize} octets)`} );
    } else {
        if (!mimetypePermis.includes(mimetype)) {
            errors.push( {msg: 'Format de fichier non accepté'} );
        }
    }
    if (!nom || !login || !password || !password2) {
        errors.push({msg: 'Remplir toutes les cases du formulaire'});
    }
    if (password !== password2) {
        errors.push({msg: 'Les mots de passe ne correspondent pas'});
    }
    if (password.length < 4) {
        errors.push({msg: 'Le mot de passe doit avoir au moins 4 caractères'});
    }
    if (errors.length > 0) {
        supprimerFichier(path);
        reponse.render('register', {
            errors,
            titre: 'Ajout d\'un usager',
            nom,
            login,
            password,
            password2,
            admin,
            gestion
        });
    } else {
        Usagers.findOne({login: login})
        .then(user=>{
            if (user) {
                supprimerFichier(path);
                errors.push({msg: 'Ce courriel existe déjà'});
                reponse.render('register', {
                    errors,
                    titre: 'Ajout d\'un usager',
                    nom,
                    login,
                    password,
                    password2,
                    admin, 
                    gestion
                });
            } else {
                const newUser = new Usagers({
                    _id: new mongoose.Types.ObjectId(),
                    nom, 
                    login,
                    pwd: password,
                    role: roles
                });
                console.log('voici l\'usager a mettre en BD', newUser);
                bcrypt.genSalt(10, (err, salt)=>{
                    bcrypt.hash(newUser.pwd, salt, (err, hash)=>{
                        if (err) throw err;
                        newUser.fichierImage = conserverFichier(path, filename);
                        newUser.pwd = hash;
                        newUser.save()
                        .then(user=>{
                            requete.flash('success_msg', 'Usager inscrit à la BD!');
                            reponse.redirect('/usagers');
                        })
                        .catch(err=>console.log(err));
                    });
                });
            }
        })
    }
});

//Editer un usager
router.get("/editer/:id", estAdmin, (requete, reponse) => {
    const id = requete.params.id;
  
    Usagers.findById(id)
      .exec()
      .then((usager) => {
        reponse.render("editer", {
          titre: "Modifier un usager",
          usager,
        });
      })
      .catch((err) => console.log(err));
  });
  
router.post("/editer", estAdmin, (requete, reponse) => {
    const { login, nom, admin, gestion, id } = requete.body;
    const { originalname, destination, filename, size, path, mimetype } =
      requete.files[0];
    const maxFileSize = 1024 * 10;
    const mimetypePermis = [
      "image/png",
      "image/jpg",
      "image/jpeg",
      "image/gif",
      "image/webp",
      "css",
    ];
    let errors = [];
    let roles = ["normal"];
    if (admin === "on") roles.push("admin");
    if (gestion === "on") roles.push("gestion");
  
    if (size > maxFileSize) {
      errors.push({
        msg: `La taille du fichier est trop grande (max ${maxFileSize} octets)`,
      });
    } else {
      if (!mimetypePermis.includes(mimetype)) {
        errors.push({ msg: "Format de fichier non accepté" });
      }
    }
    if (errors.length > 0) {
      supprimerFichier(path);
      reponse.render("editer", {
        errors,
        titre: "Ajout d'un usager",
        nom,
        login,
        password,
        password2,
        admin,
        gestion,
      });
    } else {
      Usagers.findOneAndUpdate(
        { _id: id },
        {
          login,
          nom,
          role: roles,
          fichierImage: conserverFichier(path, filename),
        },
        { new: true }
      )
        .then((usager) => {
          requete.flash("success_msg", "Usager inscrit à la BD!");
          reponse.redirect("/usagers/menu");
        })
        .catch((err) => console.log(err));
    }
  });

//Supprimer un usager
router.get('/supprimer/:id', estAdmin, (requete, reponse) => {
    Usagers.findById(requete.params.id).exec()
    .then(usager=>reponse.render('usagers/supprimer', {
        titre: 'Suppression d\'un usager',
        usager,
        user: requete.user
    }))
    .catch(err=>console.log(err));
});

router.post('/supprimer', estAdmin, (requete, reponse) => {
    const usager = {
        _id: requete.body.id,
        nom: requete.body.nom,
        login: requete.body.login,
        pwd: requete.body.password,
        role: requete.body.role
    };
    Usagers.findByIdAndRemove(usager._id).exec()
    .then(usager=>{
        supprimerFichier(usager.fichierImage);
        requete.flash('success_msg', 'Usager supprimé de la BD!');
        reponse.redirect('/usagers');
    }
    )
    .catch(err => {
        console.log(err);
        reponse.redirect('/usagers');
    });
});


//Fonctions
function supprimerFichier(path) {
    let nomFichier = nodeJSpath.join(__dirname, '..', path );
    fs.unlink(nomFichier, (err)=>{
        if (err) 
            console.log(err);
        else
            console.log('fichier supprimé:', nomFichier);
    });
}
function conserverFichier(path, filename) {
    let nomFichier = nodeJSpath.join(__dirname, '..', path);
    let nouveauNom = nodeJSpath.join(__dirname, '..', 'images', filename);
    fs.rename(nomFichier, nouveauNom, (err) => {
        if (err)
            console.log(err);
        else
            console.log('fichier déplacé vers ', nouveauNom);
    });
    return filename;
}
module.exports = router;