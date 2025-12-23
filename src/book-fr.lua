-- BOOK-FR.LUA ============================================================= --
-- ooooooo.--ooooooo--.ooooo.-----.ooooo.--oooooooooo-oooooooo.----.ooooo..o --
-- 888'-`Y8b--`888'--d8P'-`Y8b---d8P'-`Y8b-`888'---`8-`888--`Y88.-d8P'---`Y8 --
-- 888----888--888--888---------888---------888--------888--.d88'-Y88bo.---- --
-- 888----888--888--888---------888---------888oo8-----888oo88P'---`"Y888o.- --
-- 888----888--888--888----oOOo-888----oOOo-888--"-----888`8b.--------`"Y88b --
-- 888---d88'--888--`88.---.88'-`88.---.88'-888-----o--888-`88b.--oo----.d8P --
-- 888bd8P'--oo888oo-`Y8bod8P'---`Y8bod8P'-o888ooood8-o888o-o888o-8""8888P'- --
-- ========================================================================= --
-- (c) Mhatxotic Design, 2026          (c) Millennium Interactive Ltd., 1994 --
-- ========================================================================= --
-- French Book data -------------------------------------------------------- --
local aBookData<const> = {
  -- Parameters ------------------------------------------------------------ --
  -- T = The text to display on that page. It is word-wrapped on the fly.
  -- I = The optional illustration to display on that page { iTileId, iX, iY }.
  -- L = The optional line-spacing to use.
  -- H = The optional hotspots to use { { iX, iY, iW, iH, iGotoPage }, ... }
  -- Page 1 -------------------------------------------------------------- --
  { T="LE LIVRE DE ZARG\n\z
    \n\z
    Ce livre renferme des informations sur la plupart des aspects de \z
    la planète Zarg et fournit des détails d'une importance capitale \z
    pour quiconque souhaite y entreprendre des opérations minières. Les \z
    informations sont répertoriées par chapitre. Pour obtenir celle que \z
    vous désirez, cliquez sur le titre de chapitre correspondant. La \z
    page choisie s'affiche. La marge gauche du livre contient une série \z
    de boutons qui vous permet de tourner les pages pour vous rendre à \z
    l'endroit voulu."
  -- Page 2 -------------------------------------------------------------- --
  },{ T="TITRES DE CHAPITRES\n\z
    \n\z
    À PROPOS DE CE LIVRE\n\z
    COMMENT COMMENCER DIGGERS (OPTIONS DE JEU)\n\z
    LA PLANÈTE ZARG et LE 412e GLORIEUX\n\z
    DESCRIPTION DE LA COURSE DES MINEURS\n\z
    DESCRIPTION DES ZONES\n\z
    FLORE ET FAUNE\n\z
    LE MAGASIN D'APPROVISIONNEMENT\n\z
    ÉQUIPEMENT DU MINEUR\n\z
    LA BANQUE DE ZARG\n\z
    LA BOURSE DE ZARG\n\z
    L'HISTOIRE MINIÈRE DE ZARG",
    H={ { 77,  51, 224, 7,  3 },     -- Chapter 01/11: About this book
        { 77,  62, 224, 7,  8 },     -- Chapter 02/11: How to start Diggers
        { 77,  73, 224, 7, 19 },     -- Chapter 03/11: The Planet Zarg
        { 77,  84, 224, 7, 22 },     -- Chapter 04/11: Race descriptions
        { 77,  95, 224, 7, 34 },     -- Chapter 05/11: Zone descriptions
        { 77, 106, 224, 7, 39 },     -- Chapter 06/11: Flora and fauna
        { 77, 117, 224, 7, 60 },     -- Chapter 07/11: The mining store
        { 77, 128, 224, 7, 62 },     -- Chapter 08/11: Mining apparatus
        { 77, 139, 224, 7, 76 },     -- Chapter 09/11: Zargon bank
        { 77, 150, 224, 7, 80 },     -- Chapter 10/11: Zargon stock market
        { 77, 161, 224, 7, 82 } }    -- Chapter 11/11: Zargon mining history
  -- Page 3 -------------------------------------------------------------- --
  },{ T="À PROPOS DE CE LIVRE\n\z
    \n\z
    Utiliser le liure de Zarg est un jeu d'enfant. Pour afficher ses \z
    pages, le livre utilise une substance révolutionnaire appelée le TNT \z
    (voir la section TNT), grâce à laquelle il ne requiert pour \z
    fonctionner qu'une couverture, un feuille de TNT et son mécanisme \z
    de contrôle (trois émeraudes taillées et incrustées dans la tranche).\n\z
    \n\z
    La première émeraudeen haut renvoie le lecteur à la page d'index.\n\z
    La deuxième émeraude le fait passer à la page suivante.\n\z
    La troisième émeraude le fait revenir à la page précédente."
  -- Page 4 -------------------------------------------------------------- --
  },{ T="Pour accéder à la page de votre choix, il vous suffit d'appuyer \z
    sur les boutons corresponoants.\n\z
    \n\z
    Pour sélectionner un chapitrer, pointez sur le titre correspondant. \z
    Vous accédez ainsi à la première page de ce chapture.\n\z
    \n\z
    LE T.N.T.\n\z
    \n\z
    Le Livre de Zarg est fait d'une substance remarquable semblable au \z
    papier, et appelée TNT (Transistors Neuraux Texturés). Le processus \z
    de création de ce..."
  -- Page 5 -------------------------------------------------------------- --
  },{ T="...papier est d'une complexité tellement ahurissante que seuls \z
    les Sloargs à triple cerveau vivant dans le Grand Hall des Mille \z
    Esprits Furtifs de la planète Cerebralis sont capables de le \z
    comprendre, de sorte que nous ne nous lancerons dans aucune \z
    explication à ce sujet. Sachez toutefois que, quel que soit son mode \z
    de fabrication, le TNT exerce sur toutes sortes de livres un effet \z
    impressionnant - d'aucuns disent même révolutionnaire, mais il est \z
    toujours des originaux, généralement reconnaissables à leur pilosité \z
    faciale suspecte et à la disquette de démo mal enregistrée qui dépasse \z
    de leur poche, pour déclarer ce genre de choses."
  -- Page 6 -------------------------------------------------------------- --
  },{ T="Les effets du TNT sont au nombre de trois et faciles à \z
    comprendre.\n\z
    \n\z
    A. Une feuille de TNT peut contenir un nombre infini de mots, \z
       réduisant ainsi l'épaisseur d'un livre à une page.\n\z
    \n\z
    B. Lorsqu'un lecteur touche une feuille de TNT, cette substance \z
       balaie son cerveau pour en définir le mode de discours et de \z
       lecture. Il lui suffit alors d'une nano-seconde pour présenter le \z
       texte dans le langage préféré du lecteur.\n\z
    \n\z
    C. Lorsqu'ne illustration est dessinée avec une encre spéciale sur une \z
       page de TNT, cette illustration se déplace quand la page s'ouvre."
  -- Page 7 -------------------------------------------------------------- --
  },{ T="C'est vraiment incroyable. D'ailleurs, les résultats d'une \z
    enquête menée sur les réactions des lecteurs au TNT sont tout aussi \z
    renversants.\n\z
    \n\z
    \"Ça, ce sontencore des sornettes à la mode. Ces fichues images ne \z
    peuvent pas s'arrêter de bouger. Ça ne marchera jamais, j'en mettrais \z
    ma tête à couper.\"\n\z
    \n\z
    \"C'est radical, vous savez.... révolutionnaire. Au fait, je fais \z
    partie d'un groupe, vous voulez écouter ma cassette?\""
  -- Page 8 -------------------------------------------------------------- --
  },{ T="COMMENT DEMARRER DIGGERS\n\z
    \n\z
    LE BUREAU DU CONTRÔLEUR\n\z
    \n\z
    A chaque fois que vous commencez un nouveau jeu ou terminez un niveau \z
    ou un eu jeu en cours, vous revenez au bureau du contrôleur. Celui-ci \z
    vous invite à sélectionner un niveau sur lequel commencer vos \z
    recherches ou poursuivre vos opérations fructueuses de chercheur \z
    d'or.\n\z
    \n\z
    Avant de commencer, nous vous recommandons de lire les passages \z
    traitant des différents types de zones géographiques que vous pouvez \z
    rencontrer au cours du livre. Cela vous aidera à prévoir vos \z
    déplacements sur planète.\n\z"
  -- Page 9 -------------------------------------------------------------- --
  },{ T="La première fois que vous commencez à jouer, vous ne pouvez \z
    sélectionner qu'une ou deux zones pour votre première opération \z
    minière: soit \"DHOBBS\", soit \"AZERG\". Ces zones se trouvent dans \z
    le coin supérieur gauche de la carte. Si vous terminez sans faute l'un \z
    de ces niveaux, vous pouvez continuer et étendre le champ de vos \z
    recherches à l'une des zones adjacentes de votre choix, en progressant \z
    ainsi sur la planéte.\n\z
    \n\z
    Une fois une zone exploitée, que ce soit en monnayant vos efforts ou \z
    en liquidant votre adversaire, un drapeau est planté pour marquer le \z
    succès de votre entreprise."
  -- Page 10 ------------------------------------------------------------- --
  },{ T="Après avoir sélectionné la zone de votre choix, vous revenez \z
    aut bureau du contrôleur. Si uous commencez un nouveau jeu, il vous \z
    suggèrera de choisir une race de mineurs dans laquelle investir votre \z
    argent.\n\z
    \n\z
    Chaque race possède ses caractéristiques particulières, ses propres \z
    objectifs, ses forces et ses points faibles (consultez le chapitre \z
    RACES de ce livre). Nous vous conseillons de lire attentivement ces \z
    descriptions avant de faire votre choix, car vous devrez conserver la \z
    race choisie tout au long du jeu.\n\z
    \n\z
    La zone de sélection des races vous permet de consulter un résumé des \z
    caractéristiques de chacune; ..."
  -- Page 11 ------------------------------------------------------------- --
  },{ T="...pour afficher la page suivante, cliquez dans le coin \z
    supérieur droit. Pour sélectionner un élément, cliquez sur la page.\n\z
    \n\z
    Une fois les sélections effectuées, vous pouvez démarrer le jeu.\n\z
    \n\z
    LA BANQUE\n\z
    \n\z
    C'est la porte gauche dans le couloir du Centre de commerce de Zarg.\n\z
    Pour une description plus détaillée des opérations bancaires et de la \z
    bourse de Zarg, consultez les chapitres correspondants de ce manuel. \z
    Voici une courte description du système."
  -- Page 12 ------------------------------------------------------------- --
  },{ T="Si, au cours de vos opérations minières, vous découvrez des \z
    bijoux ou des minéraux précieux, vous pouvez les vendre à la banque. \z
    Sélectionnez l'icône de retour (voir au verso) pour être revenir au \z
    Centre de commerce de Zarg.\n\z
    \n\z
    La première fois que vous entrerez dans la banque, vous verrez, sur \z
    les écrans qui surplombent chacun des guichets, afficher les cotes des \z
    différents minéraux et pierres précieuses. Si vous possédez l'un de \z
    ces minéraux, vous pouvez demander son prix d'achat actuel à l'un des \z
    guichetiers et, si le prix indiqué vous semble..."
  -- Page 13 ------------------------------------------------------------- --
  },{ T="...intéressant, le vendre à la banque. La valeur de cette vente \z
    est ajoutée à votre compte courant Cash. Si le prix indiqué ne vous \z
    convient pas, vous pouvez toujours attendre que les cours augmentent \z
    ou, le cas échéant, que votre marchandise fasse l'objet de transactions."
  -- Page 14 ------------------------------------------------------------- --
  },{ T="CHARGEMENT ET SAUVEGARDE DE JEU\n\z
    \n\z
    Vous pouvez charger un nouveau jeu ou sauvegarder votre eu en cours \z
    lorsque vous vous trouvez entre deux zones, c'est-à-dire au guichet du \z
    contrôleur.\n\z
    \n\z
    Cliquez sur le bac de rangement pour sélectionner l'option désirée."
  -- Page 15 ------------------------------------------------------------- --
  },{ T="ICÔNES DE CONTRÔLE\n\z
    \n\z
    \n\z
    Mouvements des personnages\n\z
    \n\z
    Creuser\n\z
    \n\z
    Retour (disponible uniquement au campement)\n\z
    \n\z
    Arrêt\n\z
    \n\z
    Rechercher\n\z
    \n\z
    Téléporter",
    I={ 1, 250.0, 54.0 }, L=-1.5
  -- Page 16 ------------------------------------------------------------- --
  },{ T="Sauter\n\z
    \n\z
    Marcher vers la droite\n\z
    \n\z
    Attendre\n\z
    \n\z
    Courir vers la gauche\n\z
    \n\z
    Arrêtez de bouger\n\z
    \n\z
    Courir vers la droite\n\z
    \n\z
    Retour au menu principal\n\z
    \n\z
    Marcher vers la gauche",
    I={ 2, 170.0, 24.0 }, L=-1.5
  -- Page 17 ------------------------------------------------------------- --
  },{ T="\n\z
    Direction d'excavation\n\z
    \n\z
    \n\z
    Ramasser\n\z
    \n\z
    \n\z
    Déposer dans le stock\n\z
    \n\z
    \n\z
    Rechercher\n\z
    \n\z
    \n\z
    Passage d'un pôle de télékinésie à l'autre",
    I={ 3, 178.0, 24.0 }, L=-0.75
  -- Page 18 ------------------------------------------------------------- --
  },{ T="                            PUPITRE DE COMMANDE\n\z
        Compte Cash                         Pierres précieuses ramassées\n\z
    \n\z
    \n\z
    \n\z
    ¶                    Endurance           Le gagnant\n\z
    ¶                                (Le drapeau vert représente \z
    l'ordinateur \n\z
    ¶                                         Vous êtes le drapeau rose)\n\z
    Etat individuel des mineurs\n\z
    ¶ Danger OK Occupé S'ennuie Mort\n\z
    ¶                    \z
    ¶                               Inventaire   Livre électronique\n\z
    \n\z
    \n\z
    \n\z
    Mineur sélectionné      Sélection de machine      Emplacements",
    I={ 4, 96.0, 51.0 }, L=-0.75
  -- Page 19 ------------------------------------------------------------- --
  },{ T="LA PLANÈTE ZARG\n\z
    \n\z
    La richesse minérale de la planète Zarg est légendaire. Le sous-sel de \z
    Zarg renferme d'importantes quantités de minerais et de pierres \z
    précieuses comme le diamant, le rubis, l'émeraude et l'or. Cependant, \z
    l'énorme activité volcanique de la planète qui a donné naissance à ces \z
    richesses est également la source de multiples dangers, et il est très \z
    périlleux de creuser le sol de la planète Zarg. Leurrés par des \z
    inscriptions figurant sur les cartes telles que: \"Ici repose un \z
    trésor\", c'est par milliers que périrent les premiers mineurs.\n\z
    \n\z
    Mais un danger supplémentaire guette les pionniers : les..."
  -- Page 20 ------------------------------------------------------------- --
  },{ T="...affrontements entre mineurs de races rivales et le climat \z
    général d'impunité qui règne sur la planète. De plus, une \z
    exploitation anarchique prolongée des ressources souterraines de Zarg \z
    a porté attente à la stabilité du sous-sol et de gigantesques gouffres \z
    ont ainsi fait leur apparition sans crier gare.\n\z
    \n\z
    Les autorités de la planète ont alors décidé de prendre des mesures \z
    pour canaliser ces problèmes. Les premiers résultats de leur \z
    délibérations ont abouti à limiter le droit de creuser à un seul mois \z
    par an, à compter du 412e Glorieux. Pendant les 17 mois restants, \z
    toute opération de fouilles est désormais interdite."
  -- Page 21 ------------------------------------------------------------- --
  },{ T="En plus de l'instauration de cette régle du 412e Glorieux, les \z
    autorités ont également procédé à l'épuration et à la normalisation \z
    des procédures minières de la planète. Désormais, les règles en \z
    vigueur sont les suivantes:\n\z
    \n\z
    1. Seules cinq races de mineurs sont autorisées à creuser/\n\z
    2. Chaque opération de fouilles doit être enregistrée au Centre de \z
       commerce de Zarg.\n\z
    3. Tous les minéraux extraits doivent être échangés contre du liquide \z
       à la banque de Zarg.\n\z
    4. Pour encourager une compétition saine entre les pionniers, chaque \z
       section de sous-sol peut être exploitée par deux races de mineurs."
  -- Page 22 ------------------------------------------------------------- --
  },{ T="DESCRIPTION DES RACES\n\z
    \n\z
    Les Krishniches représentent une\n\z
    espèce énigmatique et secrète que\n\z
    l'on dit très rusée, et qui s'est\n\z
    dotée peu à peu de pouvoirs spéciaux\n\z
    de télékinésie pour passer d'un pôle\n\z
    à l'autre. Ces créatures à capuchons,\n\z
    qui sont les plus faibles de toutes,\n\z
    sont dépourvues de toute patience et bien que capables de creuser \z
    longtemps, elles perdent vite tout intérêt dans cet exercice et \z
    préfèrent souvent se livrer au chapardage des richesses mises au jour \z
    par les autres.",
    I={ 6, 210.0, 34.0 }
  -- Page 23 ------------------------------------------------------------- --
  },{ T="L'ordre mystique des Krishniches est soumis au tout-puissant Lord \z
    Hure, être exalté qui a décrété que son peuple devait lui ériger un \z
    temple fabuleux décoré d'or et de pierres précieuses. Les Krishniches \z
    ont commencé ce travail, mais se retrouvent maintenant à court \z
    d'argent. Ils ont besoin de trouver autant de pierres précieuses que \z
    possible pour pouvoir terminer le temple et payer les récupérateurs \z
    galactiques, les Thungurs aux redoutables battes de base-ball.\n\z
    \n\z
    Les Krishniches obéissent à un calendrier des plus étranges, qui leur \z
    dicte, aux heures les plus imprévisibles et souvent les plus \z
    saugrenues, de tout planter là, de se réunir en cercle et de chanter à \z
    la gloire du Lord Hure."
  -- Page 24 ------------------------------------------------------------- --
  },{ T="Ils se fâchent facilement quand leurs fouilles \z
    s'avèrent infructueuses et se prosternent devant leur maítre pour \z
    obtenir son pardon."
  -- Page 25 ------------------------------------------------------------- --
  },{ T="Les Diosos sont les mineurs idéaux.\n\z
    Très rapides, ils peuvent creuser très\n\z
    longtemps sans s'arrêter. Leur petite\n\z
    taille les privilégie pour circuler à\n\z
    l'intérieur des mines: ils peuvent\n\z
    s'introouire dans d'étroites fissures\n\z
    et travailler dans des tunnels au\n\z
    plafond très bas. Malgré leur \n\z
    force, ce sont de piètres combattants, dont les Carriers ont \z
    facilement raison.\n\z
    \n\z
    Les Dipsos n'ont qu'un seul point faible : leur goût pour le Irrox. \z
    poisson d'une concentration diabolique. Les Dipsos ne connaissent pas \z
    de limites quand il s'agit de...",
    I={ 7, 214.0, 15.0 }
  -- Page 26 ------------------------------------------------------------- --
  },{ T="...ce breuvage, pourtant décrit comme ayant un \"goût \z
    inimaginable\", une odeur pire que l'haleine enflammée d'un \z
    scabrosaure sorti de la vase fétide des mares de Sulphurie\" et \"plus \z
    propre à servir de bouclier en cas de guerre thermonucléaire qu'à \z
    étancher la soif\".\n\z
    \n\z
    Les ingrédients (dont la description serait ici indécente) sont \z
    cependant tellement coûteux que les Dipsos sont constamment en manque \z
    d'argent. Leur ultime objectif est d'amasser une richesse suttisante \z
    pour monter leur propre brasserie, ce qui suppose qu'ils possèdent au \z
    préalable leur propre planéte déserte, en raison des effets \z
    secondaires indésirables entraínés par la fabrication de ce brevage."
  -- Page 27 ------------------------------------------------------------- --
  },{ T="La dureté des belliqueux Carriers n'a\n\z
    d'égale que celle du diamant. Comme\n\z
    leur nom le laisse supposer, les\n\z
    carriers ont commencé à chercher\n\z
    des richesses dans les carrières\n\z
    avant de creuser mines à ciel ouvert\n\z
    puis de véritables mines souterraines.\n\z
    \n\z
    De la race la plus forte, les carriers sont par ailleurs experts en \z
    sabotage et sont passés maítres dans l'art de la dynamite. Toutefois, \z
    ils n'ont pas encore réussi à s'adapter parfaitement aux conditions \z
    inconfortables du travail de mine, se fatiguent facilement et creusent \z
    lentement.",
    I={ 8, 210.0, 20.0 }
  -- Page 28 ------------------------------------------------------------- --
  },{ T="D'une patience et d'un sérieux remarquables, ils manouent \z
    cependant d'initiative.\n\z
    \n\z
    Ayant récemment été victimes de la malhonnêteté d'un trafiquant \z
    d'armes, les carriers sont maintenant fauchés comme les blés. Ils \z
    ont pour objectif de construire un camp fortifié où ils pourraient \z
    s'entraíner au maniement des armes et de la pioche à l'abri de leurs \z
    ennemis."
  -- Page 29 ------------------------------------------------------------- --
  },{ T="Les Manouches, race de mineurs très\n\z
    résistants, sont extrêmement curieux\n\z
    et grands collectionneurs de ferraille.\n\z
    Ils sont constamment habités d'un ardent\n\z
    désir de construire à partir des déchets\n\z
    qu'ils passent leur temps à récupérer,\n\z
    ce qui donne toujours aux bâtiments et\n\z
    machines qu'ils conçoivent des allures\n\z
    rafistolées.\n\z
    \n\z
    Les Manouches sont les mineurs les plus rapides après les Dipsos \z
    et possédent une endurance bien supérieure à celle de ces derniers. \z
    Ils aiment creuser mais se laissent facilement distraire par les \z
    objets qui leur plaisent.",
    I={ 9, 220.0, 16.0 }
  -- Page 30 ------------------------------------------------------------- --
  },{ T="Leur goût pour la brocante leur attire souvent des problèmes à \z
    l'extérieur de la mine. Ils ne sont ni très agressifs, ni très bons \z
    combattants, mais leurs blessures guérissent deux fois plus vite que \z
    celles des autres mineurs.\n\z
    \n\z
    L'objectif des Manouches est de rassembler assez d'argent pour pouvoir \z
    construire leur propre Musée des Merveilles Métalliques (surnommé non \z
    sans ironie le Tas de Ferraille), pour abriter déchets historiques et \z
    sculptures de nature inhabituelle ou créative."
  -- Page 31 ------------------------------------------------------------- --
  },{ T="Les Follets représentent la dernière espèce dérivée de cette \z
    race timorée et pacifique de mineurs qui disparut sans laisser de \z
    traces de la surface de la planète. On raconte que les Follets, \z
    considérés comme les meilleurs mineurs qui soient, ont creusé leur \z
    propre tombe, s'épuisant eux-mêmes et épuisant leur enthousiasme à \z
    force de travail au cours d'une saison de fouilles particulièrement \z
    exténuante. Après une dernière visite à la banque de Zarg où ils \z
    abandonnèrent la totalité de leur biens terrestres en faisant passer \z
    toute leur richesse de l'autre côté du guichet - entraínant ainsi une \z
    ruée sur le diamant qui ébranla le marché galactique - ils \z
    traversérent la planète et disparurent."
  -- Page 32 ------------------------------------------------------------- --
  },{ T="La disparition des Follets reste un mystère. D'anciennes légendes \z
    de mineurs rapportent cependant de brèves apparitions de créatures \z
    timides rappelant les Follets. Ces histoires sont partols attribuées à \z
    des abus de Grok, mais elles entretiennent l'idée que dans une région \z
    reculée de la planéte, à des profondeurs extraordinaires des \z
    descendants de cette race de mineurs vivent encore. Alors, ouvrez \z
    l'œil lorsque vous creusez: qui sait, cette ombre tremblotante et \z
    furtive dans les ténèbres de ce tunnel, si c'était un Follet?"
  -- Page 33 ------------------------------------------------------------- --
  },{ T="DESCRIPTION DES CARACTÉRISTIQUES DE RACE\n\z
    \n\z
    Endurance                                    Agressivité\n\z
    \n\z
    Force                                            Attributs spéciaux\n\z
    \n\z
    Patience                                       Pouvoir de télékinésie\n\z
    ¶                                             (Krishniches seulement)\n\z
    Vitesse de travail\n\z
    \n\z
    Intelligence                                 Guérison rapide\n\z
    ¶                                                 (Manouches seulement)",
    I={ 5, 150.0, 44.0 }, L=-1.5
  -- Page 34 ------------------------------------------------------------- --
  },{ T="DESCRIPTION DES ZONES\n\z
    \n\z
    Les prairies: savanne arrosée de cours d'eau qui séparent les bandes \z
    de terre. Le sous-sol de cette zone renferme d'autres rivières et \z
    cauernes ainsi que quelques roches impénétrables. De récentes \z
    découvertes ont mis au jour les restes fossilisés de grandes créatures \z
    d'origine inconnue.\n\z
    \n\z
    Forêt/Jungle: région principalement constituée de plaines interrompues \z
    par des rivières aux vastes meandres et de petits lacs. La surface de \z
    cette région est très riche en éléments nutritifs et donne naissance \z
    à des arbres gigantesques dont les cimes percent le \z
    ciel et les racines interminables pénètrent au plus profond de la..."
  -- Page 35 ------------------------------------------------------------- --
  },{ T="...terre, formant, un entremêlement de nöeuds si épais qu'aucune \z
    pioche ne peut les briser ni les soulever.\n\z
    \n\z
    L'entrée des mines doit donc être creusée dans des clairières \z
    dépourvues de ces ramifications souterraines. On raconte sur cette \z
    région d'étranges histoires de vie végétale particulière, mais aucune \z
    preuve n'est encore venue les confirmer.\n\z
    \n\z
    Le désert: cette région aride de Zarg est constituée de sahles \z
    mouvants ot de dunes. Les effets de l'érosion y sont manifestes: le \z
    sable a enseveli et d'énormes blocs de roche en forteresses invincibles."
  -- Page 36 ------------------------------------------------------------- --
  },{ T="Le sable est percé d'énormes structures de cristal couleurs vives \z
    et la terre habiteé de lacs et sources d'eau souterraines.\n\z
    \n\z
    La glace: il régne un climat glacial dans cette région de mers froides \z
    peuplées d'icebergs, un climat glacial. Creuser à ces niveaux de jeu \z
    requiert des précautions particulières en raison des risques \z
    d'inondations, surtout dans les icebergs.\n\z
    \n\z
    Les îles: il s'aqit d'un archipel étendu dont les îles sont \z
    éparpillées sur un vaste océan. Ces îles sont toutes reliées entre \z
    elles bien au-dessous de la surface de l'eau, formant ainsi une \z
    gigantesque chaíne de montagnes sous-marine."
  -- Page 37 ------------------------------------------------------------- --
  },{ T="Les montagnes sont constituées de pics élevés et de pentes \z
    rocailleuses instables qui offrent peu de sites propres à \z
    l'exploitation minière. Disséminées entre les montagnes se trouvent \z
    cependant de vastes grottes plus appropriées à ce travail.\n\z
    \n\z
    Dans certaines régions, l'écorce déjà épaisse de la surface recouvre \z
    en plus des couches de roche dure qui rendent les fouilles \z
    impossibles. Le sol renferme également des sources d'eau.\n\z
    \n\z
    Le désert de rocs rappelle le Grand Canyon; il est..."
  -- Page 38 ------------------------------------------------------------- --
  },{ T="...surplombé de falaises, strié de précipices et jonché de blocs \z
    rocheux à l'équilibre précaire. Juste en dessous de la surface sont \z
    logés des roches impénétrables. L'eau y est très rare à la surface \z
    mais elle remplit dans les profondeurs des grottes entières. Les lits \z
    de longues rivières asséchées forment un réseau de grottes imbriquées \z
    les unes dans les autres et de passages entre les couches de roches. \z
    On dit que ce niveau contient des cités perdues hantées peut-être par \z
    leurs anciens habitants."
  -- Page 39 ------------------------------------------------------------- --
  },{ T="LA FLORE ET LA FAUNE\n\z
    \n\z
    La disparition pure et simple de toute l'expédition Frinklin en '95 a \z
    porté un coup sévère aux recherches anthropologiques et botaniques de \z
    la planète Zarg, car on ne dispose en conséquence d'aucun rapport \z
    exhaustif sur la flore et la faune de Zarg. Les notes et illustrations \z
    ci-dessous proviennent d'une série de témoignages tantôt de \z
    spécialistes, tantôt d'amateurs, et il ne fait aucun doute que la \z
    planète compte d'autres formes de vie animale et végétale."
  -- Page 40 ------------------------------------------------------------- --
  },{ T="Nous nous permettons de vous rappeler que si vous disposez \z
    d'informations, d'échantillons ou d'esquisses relatives à de nouvelles \z
    formes de vie, vous pouvez les envouer au professeur Mazone, Tour \z
    Devis, Institut de Verdure Galactique Tazieff."
  -- Page 41 ------------------------------------------------------------- --
  },{ T="Triffidus Carnivorus...\n\z
    \n\z
    Pousse dans les régions couvertes\n\z
    de jungle et de forêt. où elle se\n\z
    mêle au feuillage des autres arbres\n\z
    et plantes.\n\z
    \n\z
    Plante carnivore d'une férocité\n\z
    extrême et d'un grand appétit, elle se reconnaít à la couleur \z
    inhabituelle de ses feuilles.",
    I={ 10, 200.0, 15.0 }
  -- Page 42 ------------------------------------------------------------- --
  },{ T="À la suite de la capture et de l'examen à l'infrarouge d'un \z
    spécimen de cette espèce, il a été trouvé dans son estomac un guide du \z
    petit botaniste expliquant comment reconnaítre les plantes \z
    dangereuses, ainsi qu'une paire de lunettes dont la description \z
    correspond à celle des lunettes du Dr. Frinklin."
  -- Page 43 ------------------------------------------------------------- --
  },{ T="Fungus Kaleidoscopus...\n\z
    \n\z
    Poussant à la surface de la terre\n\z
    dans des endroits variés, ces\n\z
    champignons forment des\n\z
    agglomérats importants, facilement\n\z
    reconnaissables grâce à leur grand\n\z
    chapeau rouge parsemé de taches\n\z
    blanches.\n\z
    \n\z
    Au cours d'une étude scientifique, des résultats ont prouvé que la \z
    consommation de ces champignons a des effets très divers selon les \z
    individus. Certains y ont succombés...",
    I={ 11, 200.0, 15.0 }
  -- Page 44 ------------------------------------------------------------- --
  },{ T="...purement et simplement, d'autres sont devenus deux fois plus \z
    forts qu'avant, d'autres encore ont commencé à se comporter de façon \z
    étrange, tenant des discours inintelligibles sur des girafes roses."
  -- Page 45 ------------------------------------------------------------- --
  },{ T="Stégosaurus...\n\z
    \n\z
    Gros dinosaure vivant\n\z
    dans des grottes\n\z
    souterraines.\n\z
    Doté d'une peau\n\z
    couleur sable et\n\z
    de deux cornes.\n\z
    \n\z
    En général docile, le stégosaure charge si vous le provoquez ou le \z
    menacez.\n\z
    \n\z
    Dans les tunnels étroits, il peut littéralement écraser ses ennemis.",
    I={ 12, 134.0, 25.0 }
  -- Page 46 ------------------------------------------------------------- --
  },{ T="Rotorysaurus...\n\z
    \n\z
    Dinosaure peu courant vivant dans les niveaux souterrains de la \z
    planète, bien, qu'il lui arrive de se retrouver à la surface après \z
    s'être égaré. Considéré normalement comme assez placide, il peut \z
    cependant infliger de sévères dégâts à celui qui l'aura provoqué ou \z
    attaqué.\n\z
    \n\z
    Vélocirapteur...\n\z
    \n\z
    Dinosaure habité d'une méchanceté sidérante. N'attend aucunement \z
    d'être provoqué pour attaquer. Abhorre purement et simplement la vue \z
    de la plupart des autres..."
  -- Page 47 ------------------------------------------------------------- --
  },{ T="...créatures. Malgré son gabarit relativement modeste, il peut \z
    frapper avec la force d'un stégosaure. Evitez-le à tout prix et, si \z
    vous le rencontrez, fuyez aussi vite que vous le pouvez, ou attirez-le \z
    vers les mines de vos adversaires avant de vous enfuir."
  -- Page 48 ------------------------------------------------------------- --
  },{ T="Oeufus Horribilis...\n\z
    \n\z
    La seule description\n\z
    dont on dispose\n\z
    de ces oeufs\n\z
    de provenance\n\z
    inconnue est celle\n\z
    d'un mineur maintenant\n\z
    à la retraite.\n\z
    \n\z
    Voici son témoignage:\n\z
    \"C'était l'horreur. Le gars a dit qu'on d'vait creuser dans c'te \z
    roche. Ben vous voulez que j'vous oise, ça m'disait déjà rien qui \z
    vaille: ça sentait l'roussi.",
    I={ 13, 134.0, 25.0 }
  -- Page 49 ------------------------------------------------------------- --
  },{ T="Y'avait quec'chose qu'y allait pas, ch'ais pas quoi.... Enfin \z
    bref, c'est pas que ch'ois un fana, mais on a quand même continué, et \z
    on s'est r'trouvés dans une grotte. J'ai éclairé avec ma lampe, mais \z
    ça avait l'air vide. \"Allez Bolbo, on va pas moisir ici\". que j'lui \z
    fais, \"J'prendrais bien un p'tit coup de Grok\". Mais y réagissait \z
    pas, il avait aperçu c't'espèce de gros ïuf sale. \"Laisse ça\", jui \z
    fais, mais il écoutait pas. Pis voilà qu'il le ramasse, et alors ce \z
    truc lui a sauté à la figure, Oh nom de nom de nom de nom, c'tait \z
    horrib', c'machin s'est comme absorbé en lui rentrant d'dans. J'ai pas \z
    pu r'garder, j'me suis r'tourné et ch'uis parti en courant. C'tait \z
    carrément horrib.... mais où est c'te fichue bouteille?!\""
  -- Page 50 ------------------------------------------------------------- --
  },{ T="Mammifères laineux...\n\z
    \n\z
    Gros mammifères ayant\n\z
    sans doute vecu sur\n\z
    Zarg il y a un milton\n\z
    d'années. Les restes\n\z
    gelés de l'un de ces\n\z
    animaux ont été\n\z
    découverts il y a un an, et il n'est pas exclu que l'on découvre des \z
    créatures pétrifiées dans d'autres régions glacées. Des explorateurs \z
    quit mouraient de faim dans l'Arctique ont déjà consommé de la viande \z
    de mammifères laineux.",
    I={ 14, 142.0, 15.0 }
  -- Page 51 ------------------------------------------------------------- --
  },{ T="Ecoutons ce qu'ils en disent:\n\z
    \"Mnmn, laissez-moi juste ... une seconde pour finir mnmnmn... \z
    ma bouchée...\"\n\z
    \"Je crois que le végétarisme est sur le point de faire un nouvel \z
    adepte.\"\n\z
    \"Hommm, hommm, Lord Hure, hommm, hommm.\""
  -- Page 52 ------------------------------------------------------------- --
  },{ T="Poissons...\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    On a recensé l'existence de nombreuses variétés de poissons. Cependant \z
    ce qu'affirment les pêcheurs à la ligne s'est avéré parfois quelque \z
    peu fantaisiste et le peu de spécimens rapportés à l'institut \z
    (\"Il a filé!\") ne permet pas de confirmer leurs dires.",
    I={ 15, 96.0, 15.0 }
  -- Page 53 ------------------------------------------------------------- --
  },{ T="Par ailleurs, les dimensions prêtées aux poissons se sont \z
    révélées impossibles. Faites bien la part du vrai et du faux (et aussi \z
    de la chair et des arêtes) en ce qui concerne les légendes qui courent \z
    à propos du \"pikosaure\"."
  -- Page 54 ------------------------------------------------------------- --
  },{ T="\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Les vers des sables\n\z
    \n\z
    Ce sont des créatures énormes de sexe indéterminé. Timides, ces \z
    animaux vivent dans les profondeurs de la terre, de sorte qu'on ne \z
    les voit que rarement et que l'on ne sait que peu de choses sur leur \z
    comportement. Voici le témoignange d'un carrier après sa rencontre \z
    avec un ver des sables.",
    I={ 16, 96.0, 15.0 }
  -- Page 55 ------------------------------------------------------------- --
  },{ T="Nous étions tout à notre travail, creusant tranquillement - \z
    enfin, si on peut travailler tranquillement avec de la dynamite - \z
    quand, tout-à-coup, la terre s'est mise à trembler sous mes pieds. \z
    J'avoue que pendant une minute, j'ai été complètement désemparé. Mais \z
    avant que j'ai le temps de réfléchir à ce qui se passait, je suis \z
    tombé à à la renverse et me suis fracturé le crâne. Bizarrement, cela \z
    m'a remis les idées en place et j'ai vu qu'il s'agissait de l'un de \z
    ces gros vers - vraiment gros, et tout. Notez bien que je n'avais pas \z
    peur: je me suis emparé d'une pelle et j'étais sur le point de \z
    m'occuper de lui.... \"Arrive un peu ici...\", je lui dis, \z
    mais tout ce qu'il a fait c'est s'enfoncer dans le sable et \z
    disparaítre - Je me demande si c'est de là que vient leur nom, vous \z
    savez: vert de peur? A mon avis ils sont plutôt peureux.....\""
  -- Page 56 ------------------------------------------------------------- --
  },{ T="Apparitions mystérieuses!\n\z
    \n\z
    Au cours des années, des rumeurs se sont mises à circuler à propos \z
    d'étranges êtres aériens habitant dans des cavernes au plus profond de \z
    la planète Zarg. Les mineurs qui ont pu échapper à ces créatures et \z
    regagner la surface en étant encore capables de relater leur aventure \z
    ont évoqué l'apparition de formes fantomatiques aux mouvement lents \z
    qui se sont attaquées au groupe et ont tué les hommes. D'autres récits \z
    parlent de créatures extrêmement rapides aux cavernes, fondant sur \z
    leurs proies et les tuant instantanément. Les histoires répétées par \z
    les pionniers..."
  -- Page 57 ------------------------------------------------------------- --
  },{ T="...d'un bar à l'autre de la planète racontent que que ces êtres \z
    sont les fantômes des mineurs tués par les chercheurs d'or sans \z
    concession, et les zombies sont le résultat du contact de ces fantômes \z
    avec les mineurs vivants. Quoi qu'il en soit, nous vous conseillons \z
    d'éviter à tout prix ces apparitions. Ce n'est pas que les autorités \z
    croient en ce genre de choses, mais enfin, .... vous comprenez....\n\z
    \n\z
    On relate d'autres rencontres bizarres avec des créatures qui semblent \z
    \"venues d'ailleurs\" et vaguement apparentées à Oeufus Horribilis. \z
    Ces manifestations n'ont cependant pas été confimées, toutes les \z
    expéditions organisées afin d'éclaircir ces rumeurs ayant \z
    mystérieusement disparu. Alors, prudence!"
  -- Page 58 ------------------------------------------------------------- --
  },{ T="La planète est parsemée de portails surnommés \"ports \z
    tourbillonnants\". Ces objets surprenants flottent tranquillement à \z
    travers le monde souterrain, et tout mineur prisonner de l'un d'eux \z
    est immédiatement emporté au hasard vers une région de cette zone. Les \z
    fanatiques de la religion krishniche sont convaincus que les ports \z
    tourbillonnants incarnent les restes spirituels des Krishniches à \z
    l'âme imparfaitement éclairée destinés à errer dans la planète Zarg \z
    sous cette forme incomplète. D'autres mineurs aux moindres \z
    préoccupations intellectuelles considèrent simplement ces portails \z
    comme un mystère de plus sur cette planète étrange et ne..."
  -- Page 59 ------------------------------------------------------------- --
  },{ T="...cherchent à trouver aucune explication à leur existence. ce \z
    qui nous semble être une approche beaucoup plus raisonnable.\n\z
    \n\z
    La planète Zarg possède encore de vastes régions non répertoriées et, \z
    dans une large mesure, inconnues des habitants. Les informations \z
    fournies plus haut ne représentent donc rien de plus qu'un résumé de \z
    l'état actuel des connaissances. Alors lancez-vous dans l'aventure.... \z
    en vous rappelant que le monde renferme plus de choses que vous n'en \z
    voyez!"
  -- Page 60 ------------------------------------------------------------- --
  },{ T="LE MAGASIN D'APPROVISIONNEMENT\n\z
    \n\z
    Le magasin d'approvisionnement offre un large éventail de matériel de \z
    fouilles. Le stock a été entièrement choisi par un vétéran de la \z
    profession possédant une connaissance parfaite des conditions de vie \z
    souterraines. La plus grande partie du matériel a été achetée lors \z
    d'une vente-déballage sur un petit territoire de la Terre appelée la \z
    Grande-Bretagne, où l'activité minière n'est plus aujourd'hui qu'un \z
    vague souvenir.\n\z
    \n\z
    Lorsque vous pénétrez dans le magasin, le vendeur affable est trop \z
    heureux de pouvoir vous guider à travers les différentes étapes du \z
    processus d'achat. Son..."
  -- Page 61 ------------------------------------------------------------- --
  },{ T="...livre de magasin contient le prix et la description de tout \z
    l'équipement en stock. Un hologramme de chaque article permet à \z
    l'acheteur éventuel de voir comment il se présente.\n\z
    \n\z
    Pour choisir un article, cliquez simplement sur le symbole approprié. \z
    La somme correspondant à son prix est automatiquement débitée de votre \z
    compte Cash.\n\z
    \n\z
    i. La conjoncture économique peut entraíner une hausse des prix \z
       de ces produits indépendamment de l'offre disponible.\n\z
    ii. La direction se réserve le droit de modifier tout et n'importe \z
        quoi sans préavis."
  -- Page 62 ------------------------------------------------------------- --
  },{ T="ÉQUIPEMENT DU MINEUR\n\z
    \n\z
    Portes anti-inondation...\n\z
    \n\z
    Prix: 80 crédits.\n\z
    Poids: 10 essouffles.\n\z
    \n\z
    Informations générales: la porte anti-inondation ne peut être ouverte \z
    ou fermée que par celui qui l'a installée. Elle est extrêmement utile \z
    dans les régions à risque d'inondations éclair. Peut également servir \z
    à protéger votre exploitation de vos rivaux. Les portes \z
    anti-inondation résistent très bien à la pression et à l'action de la \z
    plupart des machines à forer, mais sont impuissantes face à une \z
    lourde charge d'explosifs.",
    I={ 17, 196.0, 29.0 }
  -- Page 63 ------------------------------------------------------------- --
  },{ T="Telepole\n\z
    \n\z
    \n\z
    \n\z
    Prix: 260 crédits.\n\z
    Poids: 12 essouffles.\n\z
    \n\z
    Informations générales: sans doute l'élément essentiel de l'équipement \z
    du mineur. Le télépole permet à son utilisateur de passer \z
    instantanément d'un télépôle à l'autre. Au début des opérations \z
    minières, chaque race de mineurs reçoit un télépôle. Les Krishniches \z
    peuvent se servir des télépôles des autres mineurs. Les autres races \z
    ne peuvent utlliser que le leur.",
    I={ 18, 196.0, 29.0 }
  -- Page 64 ------------------------------------------------------------- --
  },{ T="Rails de chemin de fer...\n\z
    \n\z
    \n\z
    \n\z
    Prix: 10 crédits.\n\z
    Poids: 3 essouffles.\n\z
    \n\z
    Informations générales: les sections individuelles de rails sont \z
    relativement courtes, mals se vendent par lot de 5. Le poids indiqué \z
    ci-dessus correspond donc à 5 sections. Il est important de \z
    positionner les rails convenablement dès le départ: une fois posés, \z
    ils sont définitivement reliés au sol et impossibles à déplacer ou à \z
    transpercer d'un cop de pioche",
    I={ 19, 196.0, 29.0 }
  -- Page 65 ------------------------------------------------------------- --
  },{ T="Wagon automatique...\n\z
    \n\z
    \n\z
    \n\z
    Prix: 100 crédits.\n\z
    Poids: 9 essouffles.\n\z
    \n\z
    Informations générales: wagon de conception très ingénieuse, \z
    autopropulsé et à pilotage automatique. Peut transporter \z
    d'importantes quantités de matériel. Idéal pour le transport rapide \z
    des mineurs ou des minéraux d'un site à l'autre.",
    I={ 20, 196.0, 29.0 }
  -- Page 66 ------------------------------------------------------------- --
  },{ T="Petite foreuse...\n\z
    \n\z
    \n\z
    \n\z
    Prix: 150 crédits.\n\z
    Poids: 8 essouffles.\n\z
    \n\z
    Informations générales: machine sans fil. Surnommée la \"taupe\". \z
    Légère et portable. Creuse beaucoup plus vite que le plus rapide des \z
    mineurs.",
    I={ 21, 196.0, 29.0 }
  -- Page 67 ------------------------------------------------------------- --
  },{ T="Section de pont...\n\z
    \n\z
    \n\z
    \n\z
    Prix: 25 crédits.\n\z
    Poids: 3 essouffles.\n\z
    \n\z
    Informations genérales: article très précieux pour franchir ruisseaux \z
    et rivières Extrêmement résistant, peut supporter des charges \z
    importantes. Une section de pont doit être fermement ancrée dans le \z
    sol. Attention: les ponts sont des cibles vulnérables - passez-les \z
    avec prudence.",
    I={ 22, 196.0, 29.0 }
  -- Page 68 ------------------------------------------------------------- --
  },{ T="Canot pneumatique...\n\z
    \n\z
    \n\z
    \n\z
    Prix: 60 crédits.\n\z
    Poids: 5 essouffles.\n\z
    \n\z
    Informations générales: objets à longue durée de vie. Capacité de \z
    transport limitée à une personne. N'est pas conçu pour les mers \z
    agitées ou les longues traversées.",
    I={ 23, 196.0, 29.0 }
  -- Page 69 ------------------------------------------------------------- --
  },{ T="Excavatrice verticale...\n\z
    \n\z
    \n\z
    \n\z
    Prix: 170 crédits.\n\z
    Poids: 10 essouffles.\n\z
    \n\z
    Informations genérales: surnommée le \"tire-bouchon\" à cause de son \z
    mode de forage. Cette machine ne sert qu'à creuser verticalement et \z
    vers le bas. Une fois mis en route, le \"tire-bouchon\" creuse de \z
    façon automatique pendant un temps déterminé jusqu'à ce qu'il \z
    rencontre un obstacle. Abstenez-vous de l'utiliser dans les zones au \z
    sol détrempé.",
    I={ 24, 196.0, 29.0 }
  -- Page 70 ------------------------------------------------------------- --
  },{ T="Grande foreuse...\n\z
    \n\z
    \n\z
    \n\z
    Prix: 230 crédits.\n\z
    Poids: 11 essouffles.\n\z
    \n\z
    Informations générales: plus connue sous le nom de \"Monstre\", cette \z
    machine est un formidable outil de forage. Peut creuser dans la roche \z
    à une vitesse remarquable. À ne manier qu'avec une précaution extrême. \z
    Pour commencer à creuser, pointez sur l'endroit choisi. Ne vous mettez \z
    jamais devant le \"monstre\". Cette machine ne fore que vers l'avant",
    I={ 25, 196.0, 29.0 }
  -- Page 71 ------------------------------------------------------------- --
  },{ T="Explosifs...\n\z
    \n\z
    \n\z
    \n\z
    Prix: 20 crédits.\n\z
    Poids: 4 essouffles.\n\z
    \n\z
    Informations générales: ATTENTION: à manier avec précaution. Un \z
    matériel d'une importance primordiale pour faire sauter les rochers \z
    résistants à la pioche ou pour forcer l'entrée d'une mine rivale. Le \z
    maniement des explosifs ne laisse que peu de place à l'improvisation. \z
    et la moindre erreur peut être fatale!",
    I={ 26, 196.0, 29.0 }
  -- Page 72 ------------------------------------------------------------- --
  },{ T="Monte-charge...\n\z
    \n\z
    \n\z
    \n\z
    Prix: 220 crédits.\n\z
    Poids: 12 essouffles.\n\z
    \n\z
    Informations generales: particulièrement utile pour transporter \z
    d'importantes quantités de matériel, de minéraux ou de personnes \z
    entre les veines et l'entrée de la mine.",
    I={ 27, 196.0, 29.0 }
  -- Page 73x ------------------------------------------------------------- --
  },{ T="Une fois installé, le monte-charge occupe sa place définitive et \z
    ne peut être transféré à un endroit différent.\n\z
    \n\z
    Assurez-vous de positionner correctement le monte-charge, le bloc \z
    supérieur en haut et la partie basse fermement ancrée dans une section \z
    de sol solide; le bon positionnement de ces éléments est \z
    indispensable à la mise en route de la machine."
  -- Page 74 ------------------------------------------------------------- --
  },{ T="Cacte au TNT...\n\z
    \n\z
    \n\z
    \n\z
    Prix: 215 crédits.\n\z
    Poids: 3 essouffles.\n\z
    \n\z
    Informations generales: l s'agit probablement de l'élément le plus \z
    utile pour un mineur, exception faite du guide bien sûr! Cette carte, \z
    qui utilise les propriétés du papier TNT, montre l'ensemble de la zone \z
    concernée avec toutes ses caractéristiques et fait l'objet d'une mise \z
    à jour régulière.",
    I={ 28, 196.0, 29.0 }
  -- Page 75 ------------------------------------------------------------- --
  },{ T="Trousse de secours...\n\z
    \n\z
    \n\z
    \n\z
    Prix: 60 crédits.\n\z
    Poids: 5 essouffles.\n\z
    \n\z
    Informations générales: une fois en votre possession, les pouvoirs \z
    guérisseurs de la trousse vous rendront lentement toute votre vigueur \z
    physique. Les mineurs peuvent se passer cette trousse et profiter des \z
    médicaments restants.",
    I={ 29, 196.0, 29.0 }
  -- Page 76 ------------------------------------------------------------- --
  },{ T="LA BANQUE DE ZARG\n\z
    \n\z
    Ayant récemment fait l'objet d'une fusion avec la Société Minérale, la \z
    banque de Zarg s'est rapidement développée en étendant le champ de ses \z
    activités aux opérations boursières. Elle contrôle désormais toutes \z
    les transactions financières de la planète et a mis au point un plan \z
    d'épargne pour tous ses clients. Le seul aspect inhabituel de ce plan \z
    est son caractère obligatoire.\n\z
    \n\z
    Lorsqu'un mineur ouvre un compte courant Cash à la banque de Zarg, \z
    celle-ci ouvre automatiquement un compte Planque au nom de ce même \z
    client, sur lequel est transféré, pour y être épargné, un pourcentage \z
    de...",
  -- Page 77 ------------------------------------------------------------- --
  },{ T="...la somme du compte Cash. La somme ainsi mise de côté ne peut \z
    être débloquée que si le client concerné veut quitter la planète.\n\z
    \n\z
    \"C'est une garantie contre les clients qui s'évadent de la planète en \z
    nous laissant des dettes\", nous a expliqué un représentant de la \z
    banque.\n\z
    \n\z
    Pour le lancement d'une opération de fouilles, la banque est toute \z
    prête à accorder au Maítre des mines un prêt de 100 crédits, à \z
    condition toutefois que ce crédit soit remboursé à l'issue de chaque \z
    opération de fouilles positive sur une zone."
  -- Page 78 ------------------------------------------------------------- --
  },{ T="En retour, la banque couvre toute perte subie par le Maítre des \z
    mines au moment d'entamer la zone suivante pour s'assurer que l'équipe \z
    dispose d'au moins 100 crédits. Si le maître des mines possède déjà \z
    plus de 100 crédits, il n'a bien entendu pas besoin des services de la \z
    banque.\n\z
    \n\z
    La banque offre également des conditions généreuses de financement en \z
    équipement, monte-charge, foreuse, etc. Un Maítre des mines, partant \z
    dans l'idée qu'il terminera avec succès la zone entamée, hésite à \z
    abandonner tout le matériel achete une fois l'opération menée à bien. \z
    La banque s'occupe donc de la récupération du matériel en envouant des \z
    experts chargés de retirer le matériel de..."
  -- Page 79 ------------------------------------------------------------- --
  },{ T="...la mine et de verser au Maítre des mines 75% de la valeur \z
    estimée des équipements récupérables. Le Maítre des mines se voit \z
    ainsi rembourser une partie des fonds investis en matériel, fonds \z
    réutilisés sans autre déduction pour la zone suivante. On dit que la \z
    banque réalise par ailleurs d'importants bénéfices en revendant le \z
    matériel usagé comme neuf à d'autres expéditions minières; mais ce ne \z
    sont bien sûr que des rumeurs mal intentionnées répandues par des \z
    mineurs peu chanceux et rendus amers par leur défaite."
  -- Page 80 ------------------------------------------------------------- --
  },{ T="LA BOURSE DE ZARG\n\z
    \n\z
    La bourse de Zarg obéit aux lois de l'offre et de la demande comme \z
    n'importe quelle autre place financière. Elle est reliée à un réseau \z
    d'autres marchés dans toute la galaxle, de sorte que le commerce et \z
    les cours des minéraux y sont souvent affectés par les échanges et \z
    incidents qui interviennent sur d'autres planètes.\n\z
    \n\z
    Au-dessus de chaque guichet de la banque sont affichés les cours des \z
    différents minéraux ou pierres précieuses faisant l'objet de \z
    transactions. Pour vendre l'un de vos minéraux ou pierres précieuses, \z
    sélectionnez  l'écran d'affichage."
  -- Page 81 ------------------------------------------------------------- --
  },{ T="Seuls les substances affichées font l'objet de transactions, \z
    mais, les intérêts commerciaux de la banque évoluant rapidement, vous \z
    trouverez certainement votre bonheur plus tard. Les cours des \z
    marchandises changent constamment en fonction de l'offre et de la \z
    demande; ainsi, la découverte d'un gisement d'or abondant entraíne une \z
    baisse des cours de ce métal.\n\z
    \n\z
    Si les pierres précieuses conservent toujours leur valeur, il en est \z
    une en particulier, la rose jennite, qui, en raison de sa rareté, sera \z
    toujours la bienvenue aux guichets de la banque."
  -- Page 82 ------------------------------------------------------------- --
  },{ T="HISTOIRE DES MINES DE ZARG\n\z
    \n\z
    L'histoire de la planète Zarg est aussi colorée que les pierres de son \z
    sous sol. Ses richesses légendaires ont attiré un nombre faramineux \z
    d'embarcations spatiales de fortune chargées de toutes sortes de \z
    chercheurs d'or, chasseurs de primes et autres marchands de fortune.\n\z
    \n\z
    Malheureusement, la planète garde jalousement ses trésors et rares \z
    sont ceux qui sont repartis plus riches qu'ils n'étaient arrivés. \z
    Beaucoup ne sont simplement jamais repartis. Ce qui fait la richesse \z
    de Zarg est en effet aussi la cause de nombreux problèmes \z
    d'exploitation minières. Les gisements minéraux souterrains sont..."
  -- Page 83 ------------------------------------------------------------- --
  },{ T="...générés par une activité volcanique et tectonique violente qui \z
    secoue la planète de convulsions pendant huit à douze mois. Si cette \z
    activité renouvelle les gisements minéraux en sous-sol, elle anéantit \z
    la plupart des structures à l'air libre. On suppose ainsi que le \z
    sous-sol de Zarg renferme les ruines de cités et de civilisations \z
    entières ensevelies lors des soulèvements géologiques."
  -- Page 84 ------------------------------------------------------------- --
  },{ T="ATTAQUES DE BANQUES\n\z
    \n\z
    La banque de Zarg a fait l'objet\n\z
    de nombreuses attaques, la plus\n\z
    célèbre étant celle du voleur de\n\z
    bijoux Paul O' Lémain.\n\z
    \n\z
    Caché sous un déguisement et\n\z
    confiant en l'impact de son humour\n\z
    tranchant, O' Lémain se fit passer pour un agent envoyé par le \z
    président des Banques Interplanétaires, chargé de rétablir l'ordre et \z
    de tester les systèmes de sécurité. Il fut si convaincant que le \z
    personnel lui fit même faire une visite guidée de la banque, lui \z
    indiqua l'emplacement des...",
    I={ 30, 212.0, 29.0 }
  -- Page 85 ------------------------------------------------------------- --
  },{ T="...sytèmes d'alarme et lui fournit les codes secrets.\n\z
    \n\z
    La nuit suivante, le malfrat revint sur les lieux de la visite pour \z
    faire bon usage des informations récoltées et le lendemain matin. \z
    lorsque les employés de la banque ouvrirent les portes, ils \z
    trouvérent les coffres vides et le billet suivant:\n\z
    \n\z
    Ce n'est pas moi, c'est D. Lice & Alban Quête   hé, hé, hé, hé... !\n\z
    Merci pour les jolis p'tits cailloux.\n\z
    \n\z
    Paul O' Lemain"
  -- Page 86 ------------------------------------------------------------- --
  },{ T="LE CRASH DE '94\n\z
    \n\z
    Connu aussi sous le nom de \"Mardi Noir\" (ne pas confondre avec le \z
    Mardi Blanc, jour où tous les systèmes s'interrompirent - un Manouche \z
    fut mis à la porte pour avoir extrait des puces des ordinateurs.\z
    Interrogé sur les raisons de son geste, il répondit \"J'les \z
    collectionne\", excuse jugée insuffisante). Le Mardi Blanc vit la \z
    banque ébranlée jusque dans ses fondations lorsqu'une foreuse \z
    \"monstre\", incontrôlée, fit irruption dans les salles souterraines \z
    renfermant les coffres. Des millions de crédits disparurent ce jour-là \z
    et l'on ne retrouva jamais trace des voleurs - mais pendant tout le \z
    mols suivant, pas un Dipso ne tenalt sur ses jambes."
  -- Page 87 ------------------------------------------------------------- --
  },{ T="Conseils d'un ancien mineur et astuces pour le joueur.\n\z
    \n\z
    Lors de précédentes expéditions dans les mines, les hommes ont \z
    rapporté des parties d'anciens graffiti provenant des murs des \z
    cavernes. Ces graffiti semblent avoir pour but d'informer et de \z
    conseiller les mineurs empruntant les pas de l'artiste.\n\z
    \n\z
    Les messages sont les suivants:\n\z
    Si vous êtes pressé de devenir riche, creusez er surface plutôt qu'en \z
    profondeur.\n\z
    \n\z
    Empruntez les ponts intelligemment car ceux-ci ne servent pas \z
    seulement à aller d'une rive à l'autre mais..."
  -- Page 88 ------------------------------------------------------------- --
  },{ T="...aussi vous donnent aussi le pouvoir de sauter plus haut et \z
    plus loin.\n\z
    Ne vous épuisez pas inutilement à creuser des gros blocs, faites-les \z
    sauter avec des explosifs, mais prenez garde à l'eau. Vous ne pouvez \z
    pas vous dégager une voie de secours en dehors de la zone.\n\z
    \n\z
    La soif de sang et le crime peuvent servir à éliminer vos ennemis \z
    mais la monnaie d'échange à la banque de Zarg est le zog, pas le \z
    cadavre, alors accumulez des trésors plutôt que la revanche."
  -- Page 89 ------------------------------------------------------------- --
  },{ T="En plus de ces messages sonores, nous vous conseillons de:\n\z
      \n\z
    - Sauvegardez le jeu une fois parvenu à la fin d'une zone.\n\z
      \n\z
    - Vendez les bijoux immédiatement à la banque pour que vos richesses \z
      soient supérieures à celle de votre adversaire et pour empêcher que \z
      quelqu'un ne vous les vole sous terre.\n\z
      \n\z
    - N'oubliez pas la valeur marchande de votre équipement car vous \z
      pouvez le vendre au début d'une nouvelle zone."
  }
};
-- Imports and exports ----------------------------------------------------- --
return { F = Util.Blank, A = { aBookData_fr = aBookData } };
-- End-of-File ============================================================= --
