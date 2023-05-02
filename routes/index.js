const express = require('express');
const router = express.Router();


// ajout des routes pour l'authentification

router.get('/', (requete, reponse) => 
    reponse.render('index', {titre: 'mon beau site Web'}));
    router.get("/usagers/login", (requete, reponse) => reponse.render("login"));
    router.get("/index", (requete, res) => res.redirect("/menu"));
    router.get("/menu", (requete, reponse) => reponse.render("menu"));




router.get('/logout', (requete, reponse, next) => {
    requete.logout(((err)=>{
        if (err) {
            return next(err);
        }
        requete.flash('success_msg', 'Vous êtes déconnecté');
        reponse.redirect('/');
    }));
});

module.exports = router;