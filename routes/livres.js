const express = require("express");
const router = express.Router();
const Livres = require("../modeles/livres");
const mongoose = require("mongoose");
const { estAuthentifie, estAdmin, estGestion } = require("../config/auth");


router.get("/", estAuthentifie, (requete, res) => {
    res.render("livres", { titre: "Gestion des livres", user: requete.user });
  });
  
  router.get("/menu", estAuthentifie, (requete, res) => {
    Livres.find({}, null, { sort: { titre: 1 } })
      .exec()
      .then((livres) => {
        res.render("livres", { livres: livres, user: requete.user });
      })
      .catch((err) => console.log(err));
  });

  //ajouter la route pour /livres/ajouter
    router.get("/ajouter", estAuthentifie, (requete, res) => {
        res.render("ajouter", { titre: "Ajout d'un livre", user: requete.user });
        });

        router.post('/ajouter', (req, res) => {
            const { _id, image, titre, auteur, editeur, langue, isbn, prix, description, nbPage } = req.body;
          
            const newLivre = new Livres({
              _id,
              image,
              titre,
              auteur,
              editeur,
              langue,
              isbn,
              prix,
              description,
              nbPage,
            });
          
            newLivre.save()
              .then(() => {
                req.flash('success_msg', 'Livre ajouté avec succès');
                res.redirect('/livres');
              })
              .catch(err => {
                console.log(err);
                req.flash('error_msg', 'Une erreur s\'est produite lors de l\'ajout du livre');
                res.redirect('/livres');
              });
          });
        
        router.get("/listeLivres", estAuthentifie, (requete, res) => {
            Livres.find({}, null, { sort: { titre: 1 } })
              .exec()
              .then((livres) => {
                res.render("listeLivres", { livres: livres, user: requete.user });
              })
              .catch((err) => console.log(err));
          });



  module.exports = router;