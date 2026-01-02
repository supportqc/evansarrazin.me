//
//  TarotDeck.swift
//  TarotMystique
//
//  Deck complet de 78 cartes avec significations détaillées
//

import Foundation

class TarotDeck {
    /// Deck complet (78 cartes)
    static let fullDeck: [TarotCard] = majorArcana + minorArcana

    /// Arcanes Majeurs uniquement (22 cartes)
    static let majorArcana: [TarotCard] = [
        // 0 - Le Mat / The Fool
        TarotCard(
            id: UUID(),
            number: 0,
            nameFr: "Le Mat",
            nameEn: "The Fool",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "Le Mat représente le début d'un voyage spirituel, l'innocence, la spontanéité et le potentiel illimité. C'est la carte de celui qui ose faire le premier pas dans l'inconnu avec confiance et curiosité.",
                upright: "Nouveau départ, aventure, spontanéité, foi en l'avenir, liberté d'esprit. Vous êtes sur le point de commencer quelque chose de nouveau et d'excitant. Osez suivre votre intuition et votre cœur, même si le chemin semble incertain. C'est le moment de prendre des risques calculés et d'embrasser l'inconnu avec optimisme.",
                reversed: "Imprudence, naïveté, comportement irresponsable, peur du changement. Attention à ne pas agir de manière trop impulsive sans considérer les conséquences. Il est possible que vous hésitiez à faire le saut nécessaire par peur de l'échec. Trouvez l'équilibre entre spontanéité et prudence.",
                love: "Droite : Nouvelle romance, rencontre inattendue, relation libre et spontanée. Inversée : Engagement difficile, immaturité émotionnelle, peur de l'intimité.",
                career: "Droite : Nouveau projet, changement de carrière, entrepreneuriat, créativité. Inversée : Manque de direction professionnelle, décisions hâtives, instabilité.",
                health: "Droite : Vitalité, nouveau régime de santé, esprit jeune. Inversée : Négligence de la santé, accidents dus à l'inattention.",
                spirituality: "Droite : Éveil spirituel, confiance en l'univers, foi innocente. Inversée : Déconnexion spirituelle, scepticisme excessif.",
                advice: "Ayez confiance en vous et en l'univers. Parfois, il faut sauter dans le vide pour découvrir que vous pouvez voler. Restez ouvert aux nouvelles expériences mais gardez un minimum de vigilance."
            ),
            keywords: ["Nouveaux départs", "Innocence", "Aventure", "Foi", "Spontanéité"],
            symbolism: "Le Mat porte un baluchon contenant ses expériences passées, un chien blanc (fidélité) l'accompagne, et il se tient au bord d'une falaise, symbolisant le saut de foi nécessaire à tout nouveau commencement."
        ),

        // 1 - Le Bateleur / The Magician
        TarotCard(
            id: UUID(),
            number: 1,
            nameFr: "Le Bateleur",
            nameEn: "The Magician",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "Le Bateleur incarne la manifestation, le pouvoir de création et la maîtrise des éléments. Il possède tous les outils nécessaires pour transformer ses intentions en réalité concrète.",
                upright: "Pouvoir personnel, manifestation, créativité, compétence, confiance. Vous avez toutes les ressources et capacités nécessaires pour réussir. C'est le moment d'agir avec intention et de canaliser votre énergie vers vos objectifs. Votre volonté et votre concentration peuvent créer des miracles.",
                reversed: "Manipulation, manque de confiance, talents gaspillés, tromperie, blocage créatif. Vous doutez peut-être de vos capacités ou utilisez vos talents de manière peu éthique. Attention aux illusions et à l'auto-sabotage.",
                love: "Droite : Charisme, séduction, communication claire, pouvoir d'attraction. Inversée : Manipulation émotionnelle, mensonges, charme superficiel.",
                career: "Droite : Compétences exceptionnelles, leadership, innovation, négociation réussie. Inversée : Manque de compétences, malhonnêteté professionnelle, opportunités manquées.",
                health: "Droite : Guérison par la volonté, médecine holistique, vitalité. Inversée : Négligence de la santé, faux diagnostics.",
                spirituality: "Droite : Pouvoir de manifestation, connexion avec l'univers, alchimie spirituelle. Inversée : Manipulation spirituelle, ego spirituel.",
                advice: "Vous possédez tous les outils dont vous avez besoin. Utilisez vos talents avec intégrité et intention claire. La magie réside dans votre capacité à agir avec confiance et détermination."
            ),
            keywords: ["Manifestation", "Pouvoir", "Compétence", "Action", "Concentration"],
            symbolism: "Le Bateleur se tient devant une table avec les quatre symboles des suites mineures (Bâton, Coupe, Épée, Denier), représentant sa maîtrise des quatre éléments. Son bâton levé canalise l'énergie du ciel vers la terre."
        ),

        // 2 - La Papesse / The High Priestess
        TarotCard(
            id: UUID(),
            number: 2,
            nameFr: "La Papesse",
            nameEn: "The High Priestess",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "La Papesse représente l'intuition, les mystères cachés, la sagesse intérieure et le subconscient. Elle est la gardienne des secrets et de la connaissance ésotérique.",
                upright: "Intuition, sagesse intérieure, mystère, inconscient, patience. Écoutez votre voix intérieure et faites confiance à votre intuition. Les réponses que vous cherchez se trouvent en vous, pas à l'extérieur. Il est temps de méditer et de vous connecter à votre moi profond. Certaines choses doivent rester cachées pour le moment.",
                reversed: "Secrets cachés, manque d'intuition, déconnexion spirituelle, superficialité. Vous ignorez peut-être votre intuition ou êtes submergé par trop de secrets. Reconnectez-vous à votre sagesse intérieure et à votre guidance spirituelle.",
                love: "Droite : Connexion intuitive profonde, mystère romantique, amour platonique. Inversée : Secrets dans la relation, manque de communication, froideur émotionnelle.",
                career: "Droite : Recherche, étude, travail dans les coulisses, carrières spirituelles. Inversée : Informations cachées, manque de clarté professionnelle.",
                health: "Droite : Guérison intuitive, médecine alternative, santé reproductive. Inversée : Symptômes non diagnostiqués, déséquilibres hormonaux.",
                spirituality: "Droite : Développement psychique, méditation profonde, connexion divine. Inversée : Blocages psychiques, confusion spirituelle.",
                advice: "Faites une pause et écoutez. Les réponses viendront dans le silence. Faites confiance à votre intuition et ne révélez pas tous vos secrets. Certaines connaissances doivent être gardées sacrées."
            ),
            keywords: ["Intuition", "Mystère", "Sagesse", "Subconscient", "Secrets"],
            symbolism: "Assise entre deux piliers (Boaz et Jachin), elle garde l'accès au temple de la connaissance sacrée. La lune à ses pieds symbolise le royaume de l'inconscient et du rêve."
        ),

        // 3 - L'Impératrice / The Empress
        TarotCard(
            id: UUID(),
            number: 3,
            nameFr: "L'Impératrice",
            nameEn: "The Empress",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "L'Impératrice incarne l'abondance, la fertilité, la créativité et la nature nourricière. Elle représente la Mère Divine et toutes les formes de création et de croissance.",
                upright: "Abondance, fertilité, beauté, nature, créativité, sensualité. Période de croissance et de prospérité dans tous les domaines. Connectez-vous à votre nature créative et nourricière. L'abondance est à portée de main, que ce soit matériellement, émotionnellement ou spirituellement. Prenez soin de vous et des autres.",
                reversed: "Blocages créatifs, dépendance, négligence, infertilité, manque d'abondance. Vous pourriez négliger vos besoins ou ceux de vos proches. Reconnectez-vous à la nature et à votre côté nourricier. Attention à la surprotection ou au matérialisme excessif.",
                love: "Droite : Romance passionnée, grossesse, amour maternel, relations épanouies. Inversée : Dépendance affective, surprotection, difficultés à concevoir.",
                career: "Droite : Créativité florissante, succès dans les arts, abondance financière. Inversée : Blocage créatif, échec de projet, manque de ressources.",
                health: "Droite : Grossesse, vitalité, santé florissante, guérison rapide. Inversée : Problèmes de fertilité, déséquilibres, suralimentation.",
                spirituality: "Droite : Connexion avec la Terre Mère, rituels de fertilité, abondance spirituelle. Inversée : Déconnexion de la nature, matérialisme spirituel.",
                advice: "Nourrissez votre créativité et prenez soin de vous. L'abondance vient naturellement quand vous êtes aligné avec la nature et vos cycles créatifs. Soyez généreux mais fixez des limites saines."
            ),
            keywords: ["Abondance", "Fertilité", "Créativité", "Nature", "Nurture"],
            symbolism: "Entourée de nature luxuriante et de grains dorés, l'Impératrice porte une couronne d'étoiles et tient un sceptre. Elle symbolise la terre fertile et l'énergie féminine créatrice."
        ),

        // 4 - L'Empereur / The Emperor
        TarotCard(
            id: UUID(),
            number: 4,
            nameFr: "L'Empereur",
            nameEn: "The Emperor",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "L'Empereur représente l'autorité, la structure, le contrôle et le leadership. Il incarne le Père Divin, établissant l'ordre et la stabilité à travers la discipline et le pouvoir.",
                upright: "Leadership, autorité, structure, stabilité, discipline, logique. Établissez des règles claires et prenez le contrôle de votre vie. Votre autorité naturelle et votre capacité à structurer vous mèneront au succès. Soyez un leader responsable et utilisez votre pouvoir avec sagesse.",
                reversed: "Tyrannie, rigidité, contrôle excessif, manque de discipline, faiblesse. Vous pourriez être trop autoritaire ou au contraire manquer de structure dans votre vie. Trouvez l'équilibre entre contrôle et flexibilité. Attention à l'abus de pouvoir.",
                love: "Droite : Relation stable, partenaire protecteur, engagement sérieux. Inversée : Domination, rigidité émotionnelle, manque d'engagement.",
                career: "Droite : Promotion, leadership, réussite professionnelle, entrepreneuriat structuré. Inversée : Boss tyrannique, manque d'autorité, problèmes de gestion.",
                health: "Droite : Discipline de santé, régime structuré, force physique. Inversée : Stress lié au contrôle, tension, rigidité corporelle.",
                spirituality: "Droite : Spiritualité structurée, pratiques disciplinées, sagesse paternelle. Inversée : Dogmatisme spirituel, rigidité dans les croyances.",
                advice: "Établissez des fondations solides et prenez vos responsabilités. Le vrai pouvoir vient de la discipline et de la structure, pas de la domination. Soyez le leader stable que vous aimeriez suivre."
            ),
            keywords: ["Leadership", "Autorité", "Structure", "Discipline", "Stabilité"],
            symbolism: "Assis sur un trône de pierre orné de têtes de bélier (Bélier), l'Empereur tient un ankh (vie) et un orbe (domination mondiale). Il représente le pouvoir terrestre et l'ordre établi."
        ),

        // 5 - Le Pape / The Hierophant
        TarotCard(
            id: UUID(),
            number: 5,
            nameFr: "Le Pape",
            nameEn: "The Hierophant",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "Le Pape symbolise la tradition, l'éducation spirituelle, les institutions et la conformité sociale. Il est le pont entre le divin et l'humain, le gardien de la sagesse traditionnelle.",
                upright: "Tradition, enseignement spirituel, conformité, institutions, guidance. Cherchez la sagesse dans les traditions éprouvées et les enseignements établis. Un mentor ou une institution pourrait vous guider. Respectez les conventions sociales et les rituels établis. L'apprentissage formel est favorisé.",
                reversed: "Rébellion, non-conformité, innovation, rejet des traditions, manque de guidance. Vous remettez peut-être en question les dogmes établis et cherchez votre propre voie spirituelle. C'est bien, mais attention à ne pas rejeter toute sagesse traditionnelle. Trouvez votre propre vérité.",
                love: "Droite : Mariage traditionnel, bénédiction familiale, valeurs partagées. Inversée : Relation non conventionnelle, conflit de valeurs, liberté relationnelle.",
                career: "Droite : Éducation formelle, carrière dans l'enseignement, travail institutionnel. Inversée : Carrière non conventionnelle, rejet de la hiérarchie.",
                health: "Droite : Médecine traditionnelle, traitement conventionnel, routine santé. Inversée : Médecines alternatives, rejet du système médical.",
                spirituality: "Droite : Religion organisée, enseignement spirituel, rituels traditionnels. Inversée : Spiritualité personnelle, rejet du dogme, nouvelle approche.",
                advice: "Apprenez des traditions mais ne soyez pas leur esclave. Un bon enseignant ou une communauté spirituelle peut accélérer votre croissance. Respectez les conventions utiles mais questionnez celles qui ne servent plus."
            ),
            keywords: ["Tradition", "Enseignement", "Conformité", "Spiritualité", "Institutions"],
            symbolism: "Assis entre deux piliers, le Pape bénit deux disciples agenouillés. Ses clés croisées représentent l'accès aux mystères spirituels et terrestres."
        ),

        // 6 - L'Amoureux / The Lovers
        TarotCard(
            id: UUID(),
            number: 6,
            nameFr: "L'Amoureux",
            nameEn: "The Lovers",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "L'Amoureux représente les choix importants, les relations, l'harmonie et l'union. Cette carte symbolise l'amour véritable mais aussi les décisions qui façonnent notre destinée.",
                upright: "Amour véritable, choix importants, union, harmonie, valeurs partagées. Une décision cruciale vous attend, souvent liée aux relations ou aux valeurs personnelles. Écoutez votre cœur mais aussi votre raison. Les partenariats sont favorisés. Alignez vos choix avec vos valeurs profondes.",
                reversed: "Désalignement, mauvais choix, conflit de valeurs, désharmonie relationnelle. Vous pourriez faire face à un dilemme moral ou à un conflit dans une relation. Examinez si vos actions reflètent vos valeurs. Attention aux compromis qui trahissent votre intégrité.",
                love: "Droite : Amour profond, âme sœur, relation harmonieuse, engagement. Inversée : Rupture, incompatibilité, conflit relationnel, infidélité.",
                career: "Droite : Partenariat d'affaires réussi, choix de carrière aligné, collaboration. Inversée : Conflit avec partenaire, mauvaise décision professionnelle.",
                health: "Droite : Équilibre santé, choix sains, harmonie corps-esprit. Inversée : Déséquilibre, choix malsains, conflit interne.",
                spirituality: "Droite : Union spirituelle, choix alignés avec l'âme, guidance divine. Inversée : Conflit spirituel, valeurs contradictoires.",
                advice: "Faites des choix qui honorent votre vérité la plus profonde. En amour comme dans la vie, cherchez l'harmonie et l'alignement avec vos valeurs. Les meilleures décisions viennent du cœur ET de la raison."
            ),
            keywords: ["Amour", "Choix", "Union", "Harmonie", "Valeurs"],
            symbolism: "Un homme et une femme nus sous un ange (souvent Raphaël), symbolisant l'innocence, le choix conscient et la bénédiction divine. L'arbre de la connaissance et l'arbre de vie représentent les choix moraux."
        ),

        // 7 - Le Chariot / The Chariot
        TarotCard(
            id: UUID(),
            number: 7,
            nameFr: "Le Chariot",
            nameEn: "The Chariot",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "Le Chariot symbolise la victoire, la détermination, le contrôle et le mouvement vers l'avant. C'est la maîtrise de soi et la capacité à surmonter les obstacles par la volonté.",
                upright: "Victoire, détermination, contrôle, ambition, mouvement. Vous êtes sur la voie du succès grâce à votre détermination et votre discipline. Gardez le cap malgré les obstacles. Votre volonté et votre confiance vous mèneront à la victoire. Restez concentré sur vos objectifs.",
                reversed: "Perte de contrôle, obstacles, manque de direction, agressivité. Vous pourriez vous sentir bloqué ou en conflit avec vous-même. Vos forces intérieures tirent dans des directions opposées. Reprenez le contrôle et clarifiez votre direction avant d'avancer.",
                love: "Droite : Conquête amoureuse, relation dynamique, voyage romantique. Inversée : Relation déséquilibrée, conflit de direction, séparation.",
                career: "Droite : Promotion, succès ambitieux, victoire professionnelle, voyage d'affaires. Inversée : Obstacles professionnels, manque de focus, échec de projet.",
                health: "Droite : Énergie vitale, discipline santé, récupération rapide. Inversée : Épuisement, perte de contrôle, accidents.",
                spirituality: "Droite : Maîtrise spirituelle, voyage spirituel, victoire sur l'ego. Inversée : Conflit intérieur, ego déséquilibré.",
                advice: "Maîtrisez vos forces opposées et dirigez-les vers votre objectif. La victoire nécessite discipline, focus et détermination inébranlable. Avancez avec confiance, vous avez ce qu'il faut pour réussir."
            ),
            keywords: ["Victoire", "Détermination", "Contrôle", "Volonté", "Mouvement"],
            symbolism: "Un guerrier victorieux dans un chariot tiré par deux sphinx (noir et blanc), symbolisant les forces opposées maîtrisées. Les étoiles sur son dais représentent la guidance céleste."
        ),

        // 8 - La Force / Strength
        TarotCard(
            id: UUID(),
            number: 8,
            nameFr: "La Force",
            nameEn: "Strength",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "La Force représente le courage intérieur, la compassion, la patience et la maîtrise douce. C'est la force du cœur qui dompte les passions sauvages par l'amour et non par la violence.",
                upright: "Courage, compassion, patience, maîtrise de soi, force intérieure. Votre vraie force vient de la compassion et de la patience, pas de la force brute. Domptez vos peurs et vos passions avec douceur. Vous avez le courage de faire face à n'importe quelle situation. La persévérance tranquille triomphe.",
                reversed: "Doute de soi, faiblesse, insécurité, manque de courage. Vous manquez peut-être de confiance en vous ou utilisez la force de manière inappropriée. Reconnectez-vous à votre courage intérieur. La vraie force vient de la vulnérabilité et de l'authenticité.",
                love: "Droite : Amour patient, relation équilibrée, passion maîtrisée. Inversée : Insécurité relationnelle, jalousie, manque de confiance.",
                career: "Droite : Leadership compatissant, persévérance, victoire par la patience. Inversée : Manque d'assertivité, abus de pouvoir, burnout.",
                health: "Droite : Guérison par la force intérieure, vitalité, résilience. Inversée : Épuisement émotionnel, maladie liée au stress.",
                spirituality: "Droite : Maîtrise spirituelle, courage spirituel, compassion divine. Inversée : Doute spirituel, peur de l'ombre.",
                advice: "Votre plus grande force est votre capacité à rester calme et compatissant face aux défis. Domptez vos démons intérieurs avec amour, pas avec violence. La patience et la douceur sont des superpouvoirstars."
            ),
            keywords: ["Courage", "Compassion", "Patience", "Force intérieure", "Maîtrise"],
            symbolism: "Une femme couronnée de fleurs ferme doucement la gueule d'un lion, symbolisant la domination de l'esprit sur les instincts animaux par l'amour plutôt que par la force."
        ),

        // 9 - L'Ermite / The Hermit
        TarotCard(
            id: UUID(),
            number: 9,
            nameFr: "L'Ermite",
            nameEn: "The Hermit",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "L'Ermite symbolise l'introspection, la solitude, la sagesse et la recherche intérieure. C'est le sage qui trouve la vérité dans le silence et l'isolement.",
                upright: "Introspection, solitude, sagesse, guidance intérieure, contemplation. Période de retrait nécessaire pour trouver vos réponses. Cherchez la vérité en vous-même plutôt qu'à l'extérieur. Un mentor sage pourrait apparaître. Prenez du temps seul pour la réflexion profonde. L'illumination vient du silence.",
                reversed: "Isolement excessif, solitude non désirée, rejet de l'aide, paranoïa. Vous vous isolez peut-être trop ou refusez la guidance dont vous avez besoin. Trouvez l'équilibre entre solitude ressourçante et connexion sociale. Attention à l'ermitage mental.",
                love: "Droite : Période de célibat, réflexion sur les relations, amour mature. Inversée : Solitude émotionnelle, rejet de l'intimité, isolement.",
                career: "Droite : Travail indépendant, recherche, carrière de conseil/mentor. Inversée : Isolement professionnel, refus de collaboration.",
                health: "Droite : Guérison par la méditation, repos nécessaire, sagesse corporelle. Inversée : Dépression, négligence sociale de la santé.",
                spirituality: "Droite : Éveil spirituel, méditation profonde, quête de vérité. Inversée : Isolement spirituel, rejet de la communauté spirituelle.",
                advice: "Parfois, vous devez vous retirer du bruit du monde pour entendre votre vérité intérieure. La solitude choisie est un cadeau précieux. Cherchez la lumière dans l'obscurité de l'introspection."
            ),
            keywords: ["Introspection", "Solitude", "Sagesse", "Guidance", "Contemplation"],
            symbolism: "Un vieil homme sage portant une lanterne contenant une étoile à six branches (sceau de Salomon) au sommet d'une montagne enneigée. Sa lumière guide ceux qui cherchent la vérité."
        ),

        // 10 - La Roue de Fortune / Wheel of Fortune
        TarotCard(
            id: UUID(),
            number: 10,
            nameFr: "La Roue de Fortune",
            nameEn: "Wheel of Fortune",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "La Roue de Fortune représente les cycles, le destin, les changements de fortune et la nature impermanente de la vie. Ce qui monte doit redescendre, et vice versa.",
                upright: "Chance, cycles, destin, changements positifs, opportunités. La fortune tourne en votre faveur. Les cycles de votre vie évoluent naturellement vers une phase plus positive. Saisissez les opportunités qui se présentent. Acceptez que le changement est la seule constante. Le karma positif revient.",
                reversed: "Malchance, résistance au changement, cycles négatifs, revers de fortune. La roue tourne peut-être contre vous temporairement. Ne résistez pas aux changements inévitables. C'est un cycle qui passera. Apprenez les leçons de cette période difficile.",
                love: "Droite : Tournant positif, nouvelle phase relationnelle, destin amoureux. Inversée : Cycle difficile, relation instable, rupture karmique.",
                career: "Droite : Promotion inattendue, opportunité chanceuse, succès cyclique. Inversée : Revers professionnel, perte d'opportunité, cycle bas.",
                health: "Droite : Amélioration soudaine, cycle de guérison, chance médicale. Inversée : Rechute, cycle de maladie, malchance sanitaire.",
                spirituality: "Droite : Évolution spirituelle, karma positif, synchronicités. Inversée : Leçons karmiques difficiles, cycles spirituels négatifs.",
                advice: "Acceptez les hauts et les bas de la vie avec équanimité. Ce qui semble être de la malchance aujourd'hui pourrait être une bénédiction déguisée. Restez aligné avec le flux de l'univers et faites confiance au timing divin."
            ),
            keywords: ["Cycles", "Destin", "Chance", "Changement", "Karma"],
            symbolism: "Une roue avec des symboles alchimiques, entourée de créatures mythiques (ange, aigle, lion, taureau). La roue tourne constamment, symbolisant l'impermanence et les cycles éternels."
        ),

        // 11 - La Justice / Justice
        TarotCard(
            id: UUID(),
            number: 11,
            nameFr: "La Justice",
            nameEn: "Justice",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "La Justice représente l'équité, la vérité, la loi et les conséquences de nos actions. Elle symbolise l'équilibre karmique et la responsabilité personnelle.",
                upright: "Équité, vérité, loi, karma, responsabilité, clarté. Les décisions justes et les actions éthiques sont récompensées. La vérité sera révélée. Les affaires légales tournent en votre faveur si vous êtes honnête. Assumez la responsabilité de vos choix. L'équilibre sera rétabli.",
                reversed: "Injustice, mensonge, déséquilibre, manque de responsabilité. Vous pourriez faire face à l'injustice ou éviter les conséquences de vos actions. Soyez honnête avec vous-même. Les mensonges seront exposés. Rétablissez l'équilibre moral.",
                love: "Droite : Relation équitable, honnêteté, décisions relationnelles justes. Inversée : Relation déséquilibrée, mensonges, divorce.",
                career: "Droite : Contrats justes, décisions légales favorables, promotion méritée. Inversée : Problèmes légaux, injustice au travail, malhonnêteté.",
                health: "Droite : Diagnostic correct, équilibre santé, karma santé positif. Inversée : Diagnostic erroné, déséquilibre, conséquences de mauvaises habitudes.",
                spirituality: "Droite : Karma équilibré, vérité spirituelle, justice divine. Inversée : Karma négatif, mensonges à soi-même.",
                advice: "Soyez absolument honnête et juste dans toutes vos actions. Les conséquences de vos choix reviendront vers vous. Recherchez l'équilibre et l'équité. La vérité triomphe toujours à long terme."
            ),
            keywords: ["Équité", "Vérité", "Loi", "Karma", "Responsabilité"],
            symbolism: "Une figure couronnée tient une épée (vérité) et une balance (équité), assise entre deux piliers. Elle représente l'impartialité et la loi divine."
        ),

        // 12 - Le Pendu / The Hanged Man
        TarotCard(
            id: UUID(),
            number: 12,
            nameFr: "Le Pendu",
            nameEn: "The Hanged Man",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "Le Pendu symbolise le sacrifice, la nouvelle perspective, la suspension et le lâcher-prise. Parfois, il faut tout laisser aller pour voir la vérité.",
                upright: "Nouvelle perspective, sacrifice, lâcher-prise, suspension, attente. Période de pause nécessaire pour gagner une nouvelle vision. Le sacrifice actuel apportera une illumination future. Changez votre point de vue. Acceptez l'attente et la patience. La sagesse vient de la suspension.",
                reversed: "Sacrifice inutile, résistance, stagnation, victimisation. Vous résistez peut-être à une pause nécessaire ou vous sacrifiez trop. Arrêtez de jouer la victime. Le martyre n'est pas toujours noble. Libérez-vous de la stagnation.",
                love: "Droite : Amour sacrificiel, nouvelle perspective relationnelle, pause. Inversée : Sacrifice unilatéral, relation stagnante, martyre.",
                career: "Droite : Pause de carrière, sacrifice pour croissance future, formation. Inversée : Stagnation professionnelle, sacrifice sans retour.",
                health: "Droite : Repos nécessaire, guérison par l'inaction, nouvelle approche. Inversée : Maladie prolongée, résistance au traitement.",
                spirituality: "Droite : Illumination spirituelle, sacrifice de l'ego, méditation. Inversée : Stagnation spirituelle, martyre spirituel.",
                advice: "Parfois, ne rien faire est l'action la plus puissante. Lâchez prise et laissez l'univers travailler. Un changement de perspective peut tout transformer. Acceptez la pause avec grâce."
            ),
            keywords: ["Sacrifice", "Nouvelle perspective", "Pause", "Lâcher-prise", "Illumination"],
            symbolism: "Un homme suspendu par un pied à un arbre en forme de T, serein malgré sa position inversée. Son halo indique l'illumination gagnée par le sacrifice volontaire."
        ),

        // 13 - La Mort / Death
        TarotCard(
            id: UUID(),
            number: 13,
            nameFr: "La Mort",
            nameEn: "Death",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "La Mort symbolise la transformation, les fins nécessaires, le renouveau et les transitions majeures. Rarement littérale, elle marque la fin d'un cycle et le début d'un nouveau.",
                upright: "Transformation, fin, renouveau, transition, libération. Une phase importante de votre vie se termine pour permettre un nouveau départ. Lâchez ce qui ne vous sert plus. La transformation est nécessaire et inévitable. De la mort de l'ancien naît le nouveau. Embrassez le changement.",
                reversed: "Résistance au changement, stagnation, peur de la fin, attachement. Vous résistez peut-être à une transformation nécessaire par peur de l'inconnu. L'attachement au passé vous empêche d'avancer. Acceptez la fin pour permettre le renouveau.",
                love: "Droite : Fin de relation, transformation profonde, nouveau départ. Inversée : Relation stagnante, refus de lâcher prise, peur de la rupture.",
                career: "Droite : Fin d'emploi, changement de carrière, transformation professionnelle. Inversée : Peur du changement professionnel, stagnation.",
                health: "Droite : Transformation santé, fin de mauvaises habitudes, guérison. Inversée : Résistance au changement de mode de vie.",
                spirituality: "Droite : Mort de l'ego, renaissance spirituelle, transformation profonde. Inversée : Peur de la transformation spirituelle.",
                advice: "N'ayez pas peur des fins, elles sont nécessaires pour les nouveaux départs. Lâchez ce qui est mort ou mourant dans votre vie. La transformation peut être difficile mais elle est le chemin vers la renaissance."
            ),
            keywords: ["Transformation", "Fin", "Renouveau", "Transition", "Libération"],
            symbolism: "Un squelette en armure sur un cheval blanc, portant une bannière noire avec une rose blanche. Le soleil se lève entre deux tours, symbolisant la vie qui continue après la mort."
        ),

        // 14 - La Tempérance / Temperance
        TarotCard(
            id: UUID(),
            number: 14,
            nameFr: "La Tempérance",
            nameEn: "Temperance",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "La Tempérance représente l'équilibre, la modération, la patience et l'alchimie. C'est l'art de mélanger les opposés pour créer l'harmonie parfaite.",
                upright: "Équilibre, modération, patience, harmonie, guérison. Trouvez le juste milieu en toutes choses. La patience et la modération apportent l'harmonie. Mélangez différents aspects de votre vie avec sagesse. La guérison vient de l'équilibre. Avancez avec patience et mesure.",
                reversed: "Déséquilibre, excès, impatience, manque d'harmonie. Vous pourriez être dans les extrêmes plutôt que dans l'équilibre. Ralentissez et trouvez la modération. L'impatience crée le chaos. Rétablissez l'harmonie dans votre vie.",
                love: "Droite : Relation équilibrée, harmonie, guérison relationnelle. Inversée : Déséquilibre relationnel, incompatibilité, impatience.",
                career: "Droite : Collaboration harmonieuse, équilibre travail-vie, patience récompensée. Inversée : Workaholisme, déséquilibre professionnel.",
                health: "Droite : Guérison holistique, équilibre santé, modération. Inversée : Excès, déséquilibre, santé compromise.",
                spirituality: "Droite : Alchimie spirituelle, équilibre énergétique, guidance angélique. Inversée : Déséquilibre spirituel, pratiques extrêmes.",
                advice: "La vie est un acte d'équilibre délicat. Évitez les extrêmes et cherchez la voie du milieu. La patience et la modération sont des vertus puissantes. Harmonisez tous les aspects de votre être."
            ),
            keywords: ["Équilibre", "Modération", "Patience", "Harmonie", "Alchimie"],
            symbolism: "Un ange verse de l'eau entre deux coupes, un pied sur terre et un dans l'eau, symbolisant l'équilibre entre matériel et spirituel, conscient et inconscient."
        ),

        // 15 - Le Diable / The Devil
        TarotCard(
            id: UUID(),
            number: 15,
            nameFr: "Le Diable",
            nameEn: "The Devil",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "Le Diable représente l'attachement matériel, l'addiction, l'illusion et l'ombre. Il symbolise les chaînes que nous nous imposons et le pouvoir de nous en libérer.",
                upright: "Attachement, addiction, matérialisme, illusion, ombre. Vous êtes peut-être prisonnier de vos propres désirs ou addictions. Examinez vos attachements malsains. Les chaînes qui vous lient sont souvent des illusions. Regardez votre ombre en face. Le pouvoir de vous libérer est en vous.",
                reversed: "Libération, rupture des chaînes, prise de conscience, détachement. Vous commencez à vous libérer de vos addictions et attachements. La prise de conscience de vos schémas négatifs est le premier pas vers la liberté. Continuez à affronter votre ombre.",
                love: "Droite : Relation toxique, dépendance affective, passion obsessive. Inversée : Libération d'une relation toxique, guérison.",
                career: "Droite : Travail aliénant, obsession du succès matériel, corruption. Inversée : Libération professionnelle, éthique retrouvée.",
                health: "Droite : Addictions, comportements destructeurs, santé compromise. Inversée : Surmonter les addictions, guérison.",
                spirituality: "Droite : Attachement matériel, illusions spirituelles, travail de l'ombre. Inversée : Libération spirituelle, transcendance.",
                advice: "Examinez honnêtement vos attachements et addictions. Les chaînes que vous portez sont souvent de votre propre création. Vous avez le pouvoir de vous libérer. Affrontez votre ombre pour trouver la lumière."
            ),
            keywords: ["Attachement", "Addiction", "Illusion", "Ombre", "Matérialisme"],
            symbolism: "Une figure diabolique domine deux amants enchaînés, mais leurs chaînes sont lâches - ils peuvent se libérer s'ils le souhaitent. La torche inversée symbolise l'ignorance."
        ),

        // 16 - La Maison Dieu / The Tower
        TarotCard(
            id: UUID(),
            number: 16,
            nameFr: "La Maison Dieu",
            nameEn: "The Tower",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "La Maison Dieu symbolise le bouleversement soudain, la destruction nécessaire, la révélation et le changement radical. Les fondations fausses doivent s'effondrer pour reconstruire sur la vérité.",
                upright: "Bouleversement, destruction, révélation, changement soudain, chaos. Un événement soudain va bouleverser votre vie, détruisant les illusions et les structures basées sur de fausses fondations. Bien que douloureux, c'est nécessaire pour votre évolution. La vérité sera révélée brutalement. Acceptez le chaos comme catalyseur de changement.",
                reversed: "Résistance au changement, catastrophe évitée, peur du bouleversement. Vous résistez peut-être à un changement nécessaire ou vous avez évité de justesse une catastrophe. La leçon reste à apprendre. N'ignorez pas les signes avant-coureurs.",
                love: "Droite : Rupture soudaine, révélation de mensonges, fin brutale. Inversée : Relation évitant les problèmes, peur de la confrontation.",
                career: "Droite : Licenciement soudain, échec de projet, bouleversement professionnel. Inversée : Catastrophe professionnelle évitée de peu.",
                health: "Droite : Crise santé soudaine, accident, révélation médicale. Inversée : Maladie évitée, avertissement santé.",
                spirituality: "Droite : Éveil brutal, effondrement de croyances, révélation spirituelle. Inversée : Résistance à l'éveil, déni spirituel.",
                advice: "Parfois, tout doit s'effondrer pour que vous puissiez reconstruire sur des fondations authentiques. Acceptez le bouleversement comme une opportunité de transformation radicale. De la destruction naît la renaissance."
            ),
            keywords: ["Bouleversement", "Destruction", "Révélation", "Chaos", "Libération"],
            symbolism: "Une tour frappée par la foudre, sa couronne explosant, des figures tombant dans le vide. Symbolise la destruction de structures artificielles et l'illumination soudaine et violente."
        ),

        // 17 - L'Étoile / The Star
        TarotCard(
            id: UUID(),
            number: 17,
            nameFr: "L'Étoile",
            nameEn: "The Star",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "L'Étoile représente l'espoir, l'inspiration, la guérison et la connexion spirituelle. Après la tempête de la Tour, l'Étoile apporte la paix, le renouveau et la foi en l'avenir.",
                upright: "Espoir, inspiration, guérison, paix, foi en l'avenir. Période de calme et de guérison après la tempête. L'inspiration coule librement. Vos rêves et aspirations sont à portée de main. Ayez foi en l'avenir. L'univers conspire en votre faveur. La sérénité est retrouvée.",
                reversed: "Désespoir, manque d'inspiration, perte de foi, déconnexion. Vous avez peut-être perdu espoir ou foi en l'avenir. Reconnectez-vous à vos rêves et à votre guidance intérieure. La guérison demande du temps. Ne perdez pas espoir.",
                love: "Droite : Amour inspirant, guérison relationnelle, espoir romantique renouvelé. Inversée : Désillusion amoureuse, perte d'espoir.",
                career: "Droite : Inspiration créative, opportunités futures brillantes, guérison professionnelle. Inversée : Manque d'inspiration, désespoir professionnel.",
                health: "Droite : Guérison profonde, vitalité renouvelée, espoir santé. Inversée : Guérison lente, perte d'espoir.",
                spirituality: "Droite : Connexion spirituelle profonde, guidance divine, espoir spirituel. Inversée : Désespoir spirituel, déconnexion.",
                advice: "Gardez espoir même dans les moments les plus sombres. Vous êtes guidé et protégé. Laissez votre inspiration couler librement. La guérison et le renouveau sont à portée de main. Ayez foi."
            ),
            keywords: ["Espoir", "Inspiration", "Guérison", "Foi", "Sérénité"],
            symbolism: "Une femme nue verse de l'eau d'une cruche sur la terre et dans un étang, sous une grande étoile à huit branches entourée de sept petites étoiles. Symbolise le flux d'inspiration divine et la connexion entre ciel et terre."
        ),

        // 18 - La Lune / The Moon
        TarotCard(
            id: UUID(),
            number: 18,
            nameFr: "La Lune",
            nameEn: "The Moon",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "La Lune représente l'illusion, l'intuition, le subconscient et les peurs cachées. Elle symbolise le royaume des rêves, des émotions profondes et des vérités voilées.",
                upright: "Illusion, intuition, rêves, peurs, subconscient. Les choses ne sont pas ce qu'elles semblent. Faites confiance à votre intuition pour naviguer dans l'incertitude. Vos peurs et anxiétés remontent à la surface pour être guéries. Explorez votre subconscient. Attention aux illusions et aux tromperies.",
                reversed: "Clarté retrouvée, vérité révélée, peurs surmontées, libération. Les illusions se dissipent et la vérité émerge. Vos peurs perdent leur pouvoir. Vous sortez de la confusion. La clarté mentale revient progressivement.",
                love: "Droite : Confusion relationnelle, secrets, illusions amoureuses. Inversée : Vérité révélée, clarification relationnelle.",
                career: "Droite : Incertitude professionnelle, tromperie au travail, confusion. Inversée : Clarté professionnelle, vérité exposée.",
                health: "Droite : Anxiété, troubles du sommeil, diagnostic incertain. Inversée : Anxiété diminuée, clarté sur la santé.",
                spirituality: "Droite : Rêves intenses, travail sur l'ombre, voyage psychique. Inversée : Clarté spirituelle, peurs transcendées.",
                advice: "Naviguez dans l'incertitude avec votre intuition comme guide. Explorez vos peurs pour les transcender. Ne croyez pas tout ce que vous voyez - les illusions sont puissantes. Faites confiance au processus même dans l'obscurité."
            ),
            keywords: ["Illusion", "Intuition", "Peurs", "Subconscient", "Mystère"],
            symbolism: "Une lune pleine illumine un chemin entre deux tours, avec un chien et un loup hurlant, et une écrevisse émergeant d'un étang. Symbolise le voyage à travers les territoires de l'inconscient."
        ),

        // 19 - Le Soleil / The Sun
        TarotCard(
            id: UUID(),
            number: 19,
            nameFr: "Le Soleil",
            nameEn: "The Sun",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "Le Soleil représente le succès, la joie, la vitalité et la clarté. C'est la carte la plus positive du tarot, symbolisant l'accomplissement, la confiance et l'illumination.",
                upright: "Succès, joie, vitalité, clarté, accomplissement. Période de joie pure et de réussite. Votre vraie nature brille de mille feux. La confiance et l'optimisme sont à leur apogée. Tout devient clair et lumineux. Célébrez vos victoires. La vie est belle et généreuse.",
                reversed: "Optimisme tempéré, retard de succès, joie diminuée. Votre joie ou votre succès pourrait être temporairement voilé, mais le soleil brillera à nouveau. Ne perdez pas votre optimisme. Les nuages passent toujours.",
                love: "Droite : Amour joyeux, relation épanouissante, grossesse, mariage. Inversée : Bonheur relationnel retardé, problèmes temporaires.",
                career: "Droite : Succès éclatant, reconnaissance, promotion, accomplissement. Inversée : Succès retardé, reconnaissance limitée.",
                health: "Droite : Vitalité excellente, guérison rapide, énergie débordante. Inversée : Fatigue temporaire, récupération lente.",
                spirituality: "Droite : Illumination spirituelle, joie divine, connexion solaire. Inversée : Blocage spirituel temporaire.",
                advice: "Embrassez la joie et célébrez votre succès sans culpabilité. Laissez votre lumière briller pour inspirer les autres. La vie est généreuse quand vous vous alignez avec votre vérité. Profitez de ce moment radieux."
            ),
            keywords: ["Succès", "Joie", "Vitalité", "Clarté", "Accomplissement"],
            symbolism: "Un soleil radieux brille sur un enfant nu sur un cheval blanc, entouré de tournesols. Symbolise l'innocence retrouvée, la joie pure et la victoire de la lumière sur l'obscurité."
        ),

        // 20 - Le Jugement / Judgement
        TarotCard(
            id: UUID(),
            number: 20,
            nameFr: "Le Jugement",
            nameEn: "Judgement",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "Le Jugement représente le réveil, le renouveau, l'appel supérieur et le jugement karmique. C'est le moment de l'évaluation de soi et de la réponse à un appel spirituel.",
                upright: "Réveil, renouveau, appel supérieur, absolution, jugement. Période de renaissance profonde et d'éveil spirituel. Vous êtes appelé à un but plus élevé. Le passé est pardonné et vous renaissez. Répondez à votre vocation. Évaluez votre vie honnêtement et évoluez.",
                reversed: "Doute de soi, auto-jugement sévère, appel ignoré, regrets. Vous êtes peut-être trop dur envers vous-même ou ignorez votre appel intérieur. Pardonnez-vous et pardonnez aux autres. Écoutez votre vocation. Lâchez les regrets et avancez.",
                love: "Droite : Réconciliation, pardon, amour renouvelé, âmes retrouvées. Inversée : Incapacité à pardonner, jugement relationnel.",
                career: "Droite : Nouvelle vocation, évaluation positive, second souffle professionnel. Inversée : Doute professionnel, appel ignoré.",
                health: "Droite : Guérison miraculeuse, renaissance santé, vitalité renouvelée. Inversée : Auto-sabotage santé, récupération difficile.",
                spirituality: "Droite : Éveil spirituel majeur, appel divin, ascension. Inversée : Résistance à l'éveil, culpabilité spirituelle.",
                advice: "Répondez à l'appel de votre âme. Le moment de votre renaissance est arrivé. Pardonnez-vous et libérez-vous du passé. Écoutez votre vocation supérieure et ayez le courage de la suivre."
            ),
            keywords: ["Réveil", "Renouveau", "Appel", "Absolution", "Renaissance"],
            symbolism: "Un ange (souvent Gabriel) sonne la trompette, réveillant les morts qui sortent de leurs tombes bras levés. Symbolise le jugement final, le réveil de la conscience et la renaissance spirituelle."
        ),

        // 21 - Le Monde / The World
        TarotCard(
            id: UUID(),
            number: 21,
            nameFr: "Le Monde",
            nameEn: "The World",
            type: .major,
            orientation: .upright,
            meaning: CardMeaning(
                general: "Le Monde représente l'accomplissement, l'intégration, la complétude et le succès total. C'est la carte finale du voyage du Mat, symbolisant la réalisation et l'unité cosmique.",
                upright: "Accomplissement, intégration, succès, voyage, complétude. Vous avez atteint un niveau majeur d'accomplissement et de complétude. Le cycle se termine avec succès. Vous êtes en harmonie avec l'univers. Célébrez votre réussite. Un nouveau cycle plus élevé peut maintenant commencer. Le monde vous appartient.",
                reversed: "Incompletion, manque de clôture, succès retardé, résistance. Vous êtes proche de l'accomplissement mais quelque chose manque encore. Ne précipitez pas la fin. Terminez ce que vous avez commencé avant de passer au suivant. La patience est nécessaire.",
                love: "Droite : Relation accomplie, union parfaite, amour cosmique, voyage romantique. Inversée : Relation incomplète, engagement difficile.",
                career: "Droite : Succès total, reconnaissance internationale, carrière accomplie. Inversée : Succès retardé, projet inachevé.",
                health: "Droite : Santé optimale, guérison complète, bien-être total. Inversée : Guérison incomplète, derniers obstacles.",
                spirituality: "Droite : Illumination, unité cosmique, accomplissement spirituel. Inversée : Dernier pas vers l'illumination.",
                advice: "Célébrez vos accomplissements et reconnaissez combien vous avez parcouru de chemin. Vous êtes complet et entier. Intégrez toutes vos expériences avec gratitude. Un nouveau cycle va bientôt commencer au niveau supérieur."
            ),
            keywords: ["Accomplissement", "Complétude", "Succès", "Intégration", "Unité"],
            symbolism: "Une figure danse dans une couronne de lauriers, tenant deux baguettes, entourée des quatre créatures des évangiles. Symbolise l'accomplissement total, l'intégration des quatre éléments et l'unité cosmique."
        )
    ]

    /// Arcanes Mineurs (56 cartes)
    static let minorArcana: [TarotCard] = generateMinorArcana()

    /// Génère les 56 Arcanes Mineurs
    private static func generateMinorArcana() -> [TarotCard] {
        var cards: [TarotCard] = []
        var cardNumber = 22

        for suit in Suit.allCases {
            // As à 10
            for rank in 1...10 {
                cards.append(createMinorCard(suit: suit, rank: rank, number: cardNumber))
                cardNumber += 1
            }

            // Valet, Chevalier, Reine, Roi
            let courtCards = [(11, "Valet", "Page"), (12, "Chevalier", "Knight"),
                              (13, "Reine", "Queen"), (14, "Roi", "King")]
            for (rank, nameFr, nameEn) in courtCards {
                cards.append(createMinorCard(suit: suit, rank: rank, number: cardNumber,
                                            customNameFr: nameFr, customNameEn: nameEn))
                cardNumber += 1
            }
        }

        return cards
    }

    /// Crée une carte mineure avec significations
    private static func createMinorCard(suit: Suit, rank: Int, number: Int,
                                       customNameFr: String? = nil,
                                       customNameEn: String? = nil) -> TarotCard {
        let rankNameFr = customNameFr ?? (rank == 1 ? "As" : "\(rank)")
        let rankNameEn = customNameEn ?? (rank == 1 ? "Ace" : "\(rank)")

        let meaning = generateMinorMeaning(suit: suit, rank: rank)

        return TarotCard(
            id: UUID(),
            number: number,
            nameFr: "\(rankNameFr) de \(suit.rawValue)",
            nameEn: "\(rankNameEn) of \(suit.rawValue == "Bâtons" ? "Wands" : suit.rawValue == "Coupes" ? "Cups" : suit.rawValue == "Épées" ? "Swords" : "Pentacles")",
            type: .minor(suit: suit, rank: rank),
            orientation: .upright,
            meaning: meaning,
            keywords: generateKeywords(suit: suit, rank: rank),
            symbolism: generateSymbolism(suit: suit, rank: rank)
        )
    }

    /// Génère les significations pour les cartes mineures
    private static func generateMinorMeaning(suit: Suit, rank: Int) -> CardMeaning {
        // Significations basées sur les interprétations classiques
        let element = suit.element

        switch rank {
        case 1: // As
            return CardMeaning(
                general: "L'As de \(suit.rawValue) représente un nouveau départ dans le domaine de l'\(element). C'est le potentiel pur et la semence de toutes les possibilités de cette suite.",
                upright: "Nouveau départ, potentiel pur, opportunité, don, semence. Une nouvelle opportunité se présente dans le domaine de l'\(element). Saisissez cette chance de commencer quelque chose de nouveau et d'excitant.",
                reversed: "Opportunité manquée, faux départ, blocage, potentiel gaspillé. L'opportunité pourrait être retardée ou vous hésitez à la saisir. Examinez vos résistances.",
                love: suit == .cups ? "Nouveau départ amoureux, offre d'amour." : "Nouvelle phase relationnelle.",
                career: "Nouvelle opportunité professionnelle, projet prometteur, début.",
                health: "Nouveau régime de santé, vitalité renouvelée, potentiel de guérison.",
                spirituality: "Nouveau départ spirituel, éveil, don spirituel.",
                advice: "Saisissez cette nouvelle opportunité avec enthousiasme et confiance. Le potentiel est illimité si vous osez faire le premier pas."
            )
        case 2:
            return CardMeaning(
                general: "Le Deux de \(suit.rawValue) représente la dualité, le choix, le partenariat ou l'équilibre dans le domaine de l'\(element).",
                upright: "Équilibre, partenariat, choix, dualité, coopération. Trouvez l'équilibre ou faites un choix important. Les partenariats sont favorisés.",
                reversed: "Déséquilibre, conflit, indécision, rupture de partenariat. Rétablissez l'harmonie ou prenez une décision.",
                love: "Partenariat amoureux, choix relationnel, équilibre.",
                career: "Collaboration, décision professionnelle, équilibre travail-vie.",
                health: "Équilibre santé, choix de traitement.",
                spirituality: "Équilibre spirituel, dualité sacrée.",
                advice: "Cherchez l'équilibre et la coopération. Les décisions importantes demandent réflexion et harmonie."
            )
        case 3:
            return CardMeaning(
                general: "Le Trois de \(suit.rawValue) représente la croissance, l'expansion et la collaboration dans le domaine de l'\(element).",
                upright: "Croissance, expansion, collaboration, créativité, célébration. Les choses se développent positivement. Travaillez avec d'autres pour de meilleurs résultats.",
                reversed: "Ralentissement, conflits de groupe, créativité bloquée. Les collaborations rencontrent des obstacles.",
                love: "Relation qui grandit, triangle amoureux possible, célébration.",
                career: "Travail d'équipe, croissance professionnelle, collaboration fructueuse.",
                health: "Amélioration santé, croissance, guérison progressive.",
                spirituality: "Croissance spirituelle, communauté spirituelle.",
                advice: "Cultivez vos projets avec patience et collaboration. La croissance naturelle ne peut être précipitée."
            )
        default:
            // Significations génériques pour les autres rangs
            return CardMeaning(
                general: "Le \(rank) de \(suit.rawValue) dans l'élément \(element).",
                upright: "Énergie positive de \(suit.rawValue).",
                reversed: "Énergie inversée de \(suit.rawValue).",
                love: "Influence amoureuse de \(suit.rawValue).",
                career: "Influence professionnelle de \(suit.rawValue).",
                health: "Influence santé de \(suit.rawValue).",
                spirituality: "Influence spirituelle de \(suit.rawValue).",
                advice: "Suivez la sagesse de \(suit.rawValue)."
            )
        }
    }

    private static func generateKeywords(suit: Suit, rank: Int) -> [String] {
        switch rank {
        case 1: return ["Nouveau départ", "Potentiel", "Opportunité"]
        case 2: return ["Équilibre", "Choix", "Partenariat"]
        case 3: return ["Croissance", "Expansion", "Collaboration"]
        default: return [suit.rawValue, suit.element, "Rang \(rank)"]
        }
    }

    private static func generateSymbolism(suit: Suit, rank: Int) -> String {
        return "\(rank) \(suit.rawValue) arrangés selon les principes de l'élément \(suit.element)."
    }
}
