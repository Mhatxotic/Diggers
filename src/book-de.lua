-- BOOK-DE.LUA ============================================================= --
-- ooooooo.--ooooooo--.ooooo.-----.ooooo.--oooooooooo-oooooooo.----.ooooo..o --
-- 888'-`Y8b--`888'--d8P'-`Y8b---d8P'-`Y8b-`888'---`8-`888--`Y88.-d8P'---`Y8 --
-- 888----888--888--888---------888---------888--------888--.d88'-Y88bo.---- --
-- 888----888--888--888---------888---------888oo8-----888oo88P'---`"Y888o.- --
-- 888----888--888--888----oOOo-888----oOOo-888--"-----888`8b.--------`"Y88b --
-- 888---d88'--888--`88.---.88'-`88.---.88'-888-----o--888-`88b.--oo----.d8P --
-- 888bd8P'--oo888oo-`Y8bod8P'---`Y8bod8P'-o888ooood8-o888o-o888o-8""8888P'- --
-- ========================================================================= --
-- (c) Mhatxotic Design, 2025          (c) Millennium Interactive Ltd., 1994 --
-- ========================================================================= --
-- German Book data -------------------------------------------------------- --
local aBookData<const> = {
  -- Parameters ------------------------------------------------------------ --
  -- T = The text to display on that page. It is word-wrapped on the fly.
  -- I = The optional illustration to display on that page { iTileId, iX, iY }.
  -- L = The optional line-spacing to use.
  -- H = The optional hotspots to use { { iX, iY, iW, iH, iGotoPage }, ... }
  -- Page 1 ---------------------------------------------------------------- --
  { T="DAS BUCH VON ZARG\n\z
    \n\z
    Dieses Buch enthält Informationen über die meisten Merkmale des Planeten \z
    Zarg und ist unerläßlich für alle, die auf dem Planeten Bergbau \z
    betreiben möchten. Anhand der Kapitelüberschriften sind die \z
    Informationen rasch zugänglich. Um die gewünschte Auskunft zu erhalten, \z
    klicken Sie einfach auf die betreffende Kapitelüberschrift, und der \z
    gewählte Bildschirm wird eingeblendet. Am linken Rand des Buches \z
    befindet sich eine Tastenreihe, mit der Sie einen beliebigen Bildschirm \z
    aufrufen können."
  -- Page 2 ---------------------------------------------------------------- --
  },{ T="KAPITELÜBERSCHRIFTEN\n\z
    \n\z
    ZU DIESEM BUCH\n\z
    STARTEN VON DIGGERS (DAS BÜRO DES VERWALTERS)\n\z
    DER PLANET ZARG\n\z
    BESCHREIBUNG DER STÄMME\n\z
    ZONENBESCHREIBUNGEN\n\z
    FLORA UND FAUNA\n\z
    DER BERGBAULADEN\n\z
    ARTIKEL FÜR DEN BERGBAU\n\z
    DIE ZARGONISCHE BANK\n\z
    DIE ZARGONISCHE BÖRSE\n\z
    DIE GESCHICHTE DER ZAGONNISCHEN MINEN",
    H={ { 77,  51, 224, 7,  3 },     -- Chapter 01/11: About this book
        { 77,  62, 224, 7,  8 },     -- Chapter 02/11: How to start Diggers
        { 77,  73, 224, 7, 17 },     -- Chapter 03/11: The Planet Zarg
        { 77,  84, 224, 7, 20 },     -- Chapter 04/11: Race descriptions
        { 77,  95, 224, 7, 34 },     -- Chapter 05/11: Zone descriptions
        { 77, 106, 224, 7, 38 },     -- Chapter 06/11: Flora and fauna
        { 77, 117, 224, 7, 56 },     -- Chapter 07/11: The mining store
        { 77, 128, 224, 7, 58 },     -- Chapter 08/11: Mining apparatus
        { 77, 139, 224, 7, 72 },     -- Chapter 09/11: Zargon bank
        { 77, 150, 224, 7, 76 },     -- Chapter 10/11: Zargon stock market
        { 77, 161, 224, 7, 79 } }    -- Chapter 11/11: Zargon mining history
  -- Page 3 ---------------------------------------------------------------- --
  },{ T="ZU DIESEM BUCH\n\z
    \n\z
    Die Benutzung des Buches von Zarg ist ganz einfach. Das Buch bedient sich \z
    einer supermodernen Substanz namens TNT, um seine Seiten anzuzeigen \z
    (s. TNT). Das Buch braucht daher nur das Deckblatt, ein Blatt TNT und \z
    den Steuerungsmechanismus für TNT (drei geschliffene Smaragde im \z
    Buchrücken) zu enthalten.\n\z
    Mit dem obersten Smaragd wird der Leser zur Indexseite zurückgebracht.\n\z
    Mit dem zweiten Smaragd wird der Leser auf die nächste Seite gebracht.\n\z
    Mit dem dritten Smaragd wird der Leser auf die vorherige Seite \z
    zurückgebracht."
  -- Page 4 ---------------------------------------------------------------- --
  },{ T="Durch einen einfachen Druck auf die betreffende Taste gelangt der \z
    Leser auf die gewünschte Seite Um ein Kapitel auszuwählen, auf die \z
    Überschrift des gewünschten Kapitels zeigen. Der Leser wird dadurch \z
    automatisch zur ersten Seite des betreffenden Kapitels gebracht.\n\z
    \n\z
    T.N.T.\n\z
    \n\z
    Das Buch von Zarg besteht aus einer bemerkenswerten papierähnlichen \z
    Substanz namens TNT (Texturierte Neuraltransistoren). Das \z
    Herstellungsverfahren dieses Papiers ist so furchtbar kompliziert, daß \z
    nur die dreihirnigen Sloags, die das \"Große Zentrum der tausend..."
  -- Page 5 ---------------------------------------------------------------- --
  },{ T="...knisternden Intellekte\" auf dem Planeten Cerebralis bewohnen, \z
    es vollständig verstehen können. Wir wollen daher eine Erklärung erst \z
    gar nicht versuchen. Beschränken wir uns auf die Aussage, daß TNT eine \z
    beeindruckende, manche würden sogar sagen revolutionäre (doch natürlich \z
    finden sich immer ein paar zu solchen Aussagen bereite Leute - \z
    normalerweise mit verdächtigem Haarwuchs im Gesicht und einer schlecht \z
    aufgenommenen Demo-Kassette in der Tasche) Wirkung auf alle Arten von \z
    Büchern hat.\n\z
    \n\z
    TNT weist die drei folgenden Merkmale auf:\n\z
    A. Ein Blatt TNT kann eine unbeschränkte Anzahl Wörter enthalten, \z
    wodurch die Dicke von Büchern auf..."
  -- Page 6 ---------------------------------------------------------------- --
  },{ T="...eine Seite reduziert wird.\n\z
    B. Wenn ein Leser ein Blatt TNT berührt, untersucht dieses sein Gehirn \z
    um seine Sprech - und Lesemuster festzustellen. Nach einer \z
    Tausendstelsekunde erscheint dann der Text in der Lieblingssprache des \z
    Lesers.\n\z
    C. Wenn Zeichner für die Illustrationen auf einer TNT\n\z
    - Seite eine besondere Tinte verwenden, bewegt sich die Illustration \z
    beim Aufschlagen der Seite.\n\z
    Eine ausgesprochen faszinierende Angelegenheit. Die Ergebnisse einer \z
    Umfrage über Leserreaktionen auf TNT sind ebenfalls sehr interessant:\n\z
    \"Neumodischer Quatsch. Die blöden Bilder bewegen sich dauernd im Zeug \z
    herum. Da lob' ich mir meine Feder und Tinte!\""
  -- Page 7 ---------------------------------------------------------------- --
  },{ T="\"Das ist echt stark ... reuolutionär. Ich singe übrigens in einer \z
    Band. Möchten Sie sich eine Aufnahme unserer Musik anhören?\""
  -- Page 8 ---------------------------------------------------------------- --
  },{ T="STARTEN VON DIGGERS\n\z
    \n\z
    DAS BÜRO DES VERWALTERS\n\z
    \n\z
    Jedesmal, wenn Sie ein neues Spiel beginnen oder eine Ebene oder ein \z
    bestehendes Spiel beenden, werden Sie zum Büro des Verwalters \z
    zurückgebracht. Der Verwalter fordert Sie zur Wahl einer Ebene auf, in \z
    der Sie entweder mit den Grabungen beginnen oder mit erfolgreichen \z
    Grabungen fortfahren können.\n\z
    Bevor Sie beginnen, sollten Sie die Kapitel zu den verschiedenen Arten \z
    von Landschaftszonen, auf die Sie später im Buch stoßen könnten, \z
    durchlesen. Dies wird Ihnen bei der Planung Ihrer Bewegungen auf dem \z
    Planeten helfen."
  -- Page 9 ---------------------------------------------------------------- --
  },{ T="Nach der erfolgreichen Beendigung einer Zone, entweder finanziell \z
    oder durch vollständiges Ausmerzen aller Feinde, wird in der \z
    betreffenden Zone eine Siegesflagge gehißt. Nach der Wahl der \z
    gewünschten Zone werden Sie zum Büro des Verwalters zurückgebracht. Wenn \z
    Sie ein neues Spiel beginnen, fordert er Sie dazu auf, einen \z
    Schatzgräberstamm, in den Sie Ihr Geld investieren können, zu wählen.\n\z
    Jeder stamm verfügt über besondere Merkmale, Ziele, Stärken und \z
    Schwächen. (Siehe das Kapitel STÄMME weiter hinten im Buch.) Es \z
    empfiehlt sich, vor dem Treffen einer Wahl die Stammesbeschreibungen \z
    genau durchzulesen, da Sie im ganzen Spiel mit demselben Stamm arbeiten \z
    müssen."
  -- Page 10 ---------------------------------------------------------------- --
  },{ T="Im Stammesauswahlbereich erscheint eine Zusammenfassung der \z
    Merkmale jedes Stammes. Die Buchseite mit Skizze und Informationen wird \z
    durch Klicken in die rechte Ecke der Seite umgeblättert. Sie können den \z
    betreffenden Stamm auswählen, indem Sie auf eine beliebige Stelle auf \z
    der Seite klicken. Wenn Sie Ihre Wahl getroffen haben, können Sie mit \z
    dem Spiel beginnen.\n\z
    \n\z
    DIE BANK\n\z
    \n\z
    Die linke Tür auf dem Flur des Handelszentrums von Zarg. Den \z
    Banktransaktionen und der Börse von Zarg sind weiter hinten in diesem \z
    Buch eigene Kapitel gewidmet. Es folgt hier eine kurze Beschreibung zur \z
    Benutzung des Systems."
  -- Page 11 --------------------------------------------------------------- --
  },{ T="Wenn Sie bei den Grabungen wertvolle Edelsteine oder Mineralien \z
    finden, können Sie diese an die Bank verkaufen. Durch Auswählen des \z
    Heimsymbols (siehe weiter hinten) werden Sie ins Handelszentrum von Zarg \z
    zurückgebracht.\n\z
    Beim Betreten der Bank sehen Sie auf den Anzeigebildschirmen oberhalb \z
    der Fenster der einzelnen Kassierer eine Aufstellung der Mineralien und \z
    Edelsteine, mit denen sie handeln. Wenn sie solche Mineralien oder \z
    Edelsteine besitzen, können Sie den Kassierer nach dem Preis fragen, zu \z
    dem er diese zur Zeit ankauft. Sind Sie mit dem Preis einverstanden. \z
    können Sie die Enesteine verkaufen; der Erlös wird Ihrem Kassenkonto \z
    hinzugefügt."
  -- Page 12 --------------------------------------------------------------- --
  },{ T="Wenn Ihnen der Preis nicht gefällt oder die Kassierer nicht \z
    mit den Mineralien handeln, über die Sie verfügen, können Sie die Bank \z
    verlassen und später zurückkehren, um zu sehen, ob der Preis sich \z
    verbessert hat oder Ihre Edelsteine jetzt gehandelt werden.\n\z
    \n\z
    LADEN & SPEICHERN\n\z
    \n\z
    Zwischen Zonen, wenn Sie vor dem Schreibtisch des Verwalters stehen, \z
    können Sie Ihr Spiel speichern oder ein bereits bestehendes Spiel laden. \z
    Wählen Sie den Ablagekorb, um die entsprechenden Optionen aurzurufen."
  -- Page 13 --------------------------------------------------------------- --
  },{ T="STEUERSYMBOLE\n\z
    \n\z
    \n\z
    Bewegen der Spielfigur\n\z
    \n\z
    Graben\n\z
    \n\z
    Nach Hause zurückkehren                \z
    (nur verfügbar im \n\z
    ¶                                                                 \z
    Basislager)\n\z
    Warten\n\z
    \n\z
    Suchen\n\z
    \n\z
    Teleportieren",
    I={ 1, 178, 54 }, L=-1.5
  -- Page 14 --------------------------------------------------------------- --
  },{ T="Hochspringen\n\z
    \n\z
    Nach rechts gehen\n\z
    \n\z
    Warten\n\z
    \n\z
    Nach links laufen\n\z
    \n\z
    STOP\n\z
    \n\z
    Nach rechts laufen\n\z
    \n\z
    Zurück zum Hauptmenü\n\z
    \n\z
    Nach links gehen",
    I={ 2, 168, 24 }, L=-1.5
  -- Page 15 --------------------------------------------------------------- --
  },{ T="\n\z
    Grabungsrichtungen\n\z
    \n\z
    \n\z
    Aufheben\n\z
    \n\z
    \n\z
    Niederlegen und Inventar\n\z
    \n\z
    \n\z
    Suchen\n\z
    \n\z
    \n\z
    Zwischen Teleport-Polen umschalten",
    I={ 3, 170, 24 }, L=-0.75
  -- Page 16 --------------------------------------------------------------- --
  },{ T="                                     STEUERFELD\n\z
        Kassenkonto                Gesammelte Edelsteine\n\z
    \n\z
    \n\z
    \n\z
    ¶                    Ausdauer             Wer gewinnt\n\z
    ¶                                (Grüne Fahne ist Computer-Spieler\n\z
    ¶                                         Rosa Fahne sind Sie)\n\z
    Verfassung der einzelnen Schatzgräber\n\z
    Gefährdet OK Beschäftigt Gelangweilt Tot\n\z
    ¶                                    \z
    ¶                       Status   Electronishes\n\z
    ¶                                                                        \z
    ¶                 Buch\n\z
    \n\z
    \n\z
    Gewählter Schatzgräber      Auswahl der       Standorte\n\z
    ¶                                                   Maschine",
    I={ 4, 96, 51 }, L=-0.75
  -- Page 17 --------------------------------------------------------------- --
  },{ T="DER PLANET ZARG\n\z
    \n\z
    Der Reichtum an Bodenschätzen auf diesem Planeten ist legendär. Unter \z
    seiner Oberfläche können zahllose Mineralien und Erze, darunter \z
    Diamanten, Rubine, Smaragde und Gold, gefunden werden, doch die starke \z
    vulkanische Tätigkeit, die diese Reichtümer hervorgebracht hat, schuf \z
    gleichzeitig eine Vielzahl an Gefahren. Daher ist der Bergbau auf Zarg \z
    mit großen Schwierigkeiten verbunden. Tausende von Schatzgräbern ließen \z
    sich in der Vergangenheit von Raumkarten mit der Aufschrift 'Hier sind \z
    Schätze vergraben' ins Verderben locken."
  -- Page 18 --------------------------------------------------------------- --
  },{ T="Eine weitere Gefahr für die Arbeiter stellten die Kämpfe zwischen \z
    rivalisierenden Schatzgräberstämmen und die auf dem Planeten allgemein \z
    verbreitete Gesetzlosigkeit dar. Ferner war durch zuviele unüberwachte \z
    Grabungen die unterirdische Stabilität des Planeten gefährdet, und \z
    riesige Risse in der Erdoberfläche tauchten ohne Vorwarnung auf.\n\z
    Die Regierung des Planeten beschloß, Maßnahmen zur Eindämmung dieser \z
    Probleme zu ergreifen. Die erste Maßnahme war die Beschränkung der \z
    erlaubten Grabungszeit auf einen Monat im Jahr. Dieser Monat beginnt am \z
    glorreichen 412. Während der übrigen 17 Monate des Jahres sind Grabungen \z
    verboten."
  -- Page 19 --------------------------------------------------------------- --
  },{ T="Zusätzlich zur Regel des glorreichen 412. hat die Regierung eine \z
    Reihe von Standardvorschriften für den Grabungsprozeß herausgegeben:\n\z
    \n\z
    1. Die Zahl der zum Graben auf dem Planeten autorisierten \z
       Schatzgräberstämme ist auf fünf beschränkt.\n\z
    2. Jede Grabung muß im Mineralien-Handelszentrum von Zarg registriert \z
       werden.\n\z
    3. Alle ausgegrabenen Mineralien müssen bei der Bank von Zarg gegen \z
       Bargeld eingetauscht werden.\n\z
    4. Damit ein gesunder Wettkampfgeist bewahrt bleibt, dürfen in jedem \z
       Gebiet des Planeten zwei Schatzgräberstämme Grabungen vornehmen."
  -- Page 20 --------------------------------------------------------------- --
  },{ T="BESCHREIBUNG DER STÄMME\n\z
    \n\z
    Habich: Ein geheimnisvoller Stamm,\n\z
    dessen Mitglieder sehr intelligent\n\z
    sein sollen und ein spezielles\n\z
    Telepol-Transportmittel entwickelt\n\z
    haben. Die in Kutten gekleideten Habich\n\z
    sind der schwächste Stamm. Obschon\n\z
    sie oft noch lange weitergraben könnten,\n\z
    sind sie sehr ungeduldig, und es wird ihnen\n\z
    schnell langweilig beim Graben. Sie ziehen es vor, von anderen \z
    ausgegrabene Wertgegenstände zu klauen.",
    I={ 6, 210, 41 }
  -- Page 21 --------------------------------------------------------------- --
  },{ T="Die Habich sind ein mystischer Orden, der an den Gott hoher Humbug \z
    glaubt. Dieser hochehrwürdige Vater hat erlassen, daß seine Gefolosleute \z
    in seinem Namen einen riesigen, mit Gold und Edelsteinen besetzten \z
    Tempelkomplex errichten sollen. Die Habich haben zwar der Durchführung \z
    dieses Auftrags begonnen, doch geht ihnen langsam das Geld aus. Sie \z
    müssen daher so viele Wertgegenstände wie möglich ausgraben, um den \z
    Tempel fertigzustellen und die galaktischen Geldeinträger, jene \z
    baseballschlägerschwingenden Muskelprotze, zu bezahlen."
  -- Page 22 --------------------------------------------------------------- --
  },{ T="Die Habich leben in einer äußerst seltsamen Zeitstruktur. Sie \z
    lassen zu allen möglichen und unmöglichen Zeiten alles fallen, um einen \z
    Kreis zu bilden und ihren hohen Herrn Humbug anzubeten. Sie sind schnell \z
    verärgert, wenn ihre Grabungspläne nicht von Erfolg gekrönt sind, und \z
    bitten ihren Gebieter kniend um Vergebung, wenn sie nicht regelmäßig \z
    Wertgegenstände ausgraben."
  -- Page 23 --------------------------------------------------------------- --
  },{ T="DIE GRABLINGE:\n\z
    \n\z
    Besitzen die idealen Qualitäten für\n\z
    den Bergbau. Sie graben sehr schnell\n\z
    und können stundenlang ohne\n\z
    Unterbrechung arbeiten. Da sie so\n\z
    klein sind, verfügen sie über große\n\z
    Mobilität innerhalb der Minen.\n\z
    Sie können sich in engste Risse und Felsspalten zwängen und in Gängen \z
    mit niedrigen Decken arbeiten. Obschon sie stark sind, ist ihre \z
    kämpferische Begabung gering. Die Stieger haben kaum Schwierigkeiten, \z
    sie zu besiegen.",
    I={ 7, 200, 15 }
  -- Page 24 --------------------------------------------------------------- --
  },{ T="Die einzige Schwäche der Grablinge ist das teuflisch starke Getränk \z
    Grok. Obschon diese Flüssigkeit von manchen als \"ekelerregendes Gebräu, \z
    das schlimmer stinkt als der Atem des feuerspeienden Skabrosaurus aus \z
    den schwindelerregenden Schleimschlämmen von Schwefelingen\" und \z
    \"nützlicher als Verteidigungsschild gegen den Thermonuklearkrieg denn \z
    als Getränk\" beschrieben wird, können sich die Grablinge daran nicht \z
    satt trinken."
  -- Page 25 --------------------------------------------------------------- --
  },{ T="Leider brauchen die Grablinge dauernd Geld, da die zum Brauen von \z
    Grok erforderlichen Zutaten (die zu scheußlich sind, um hier im \z
    Einzelnen beschrieben zu werden) ein Vermögen kosten. Ihr großes Ziel \z
    ist es, genügend Geld zum Bau einer eigenen Brauerei anzuhäufen. \z
    Aufgrund der unangenehmen Nebeneffekte, die beim Brauen des Getränks \z
    entstehen, müssen Sie jedoch zuerst einen eigenen verlassenen Planeten \z
    kaufen, auf dem sie die Brauerei ansiedeln können."
  -- Page 26 --------------------------------------------------------------- --
  },{ T="DIE STIEGER:\n\z
    \n\z
    Dieser kriegerische Stamm setzt sich\n\z
    aus harten Kerlen zusammen. Wie ihr\n\z
    Name andeutet, begannen sie ihre Suche\n\z
    nach Reichtum in Steinbrüchen, bevor\n\z
    sie sich weiter im Planeteninnern auf den Bergbau verlegten.\n\z
    \n\z
    Die Stieger sind der stärkste aller Stämme und gleichzeitig Fachleute im \z
    Sabotieren und Sprengen. Sie haben sich jedoch noch nicht so ganz an die \z
    zusammengepferchten unterirdischen Verhältnisse gewöhnt, sind daher sehr \z
    langsam beim Graben und werden schnell müde. Sie sind äußerst und \z
    geduldig, doch es mangelt ihnen an Eigeninitiative.",
    I={ 8, 210, 20 }
  -- Page 27 --------------------------------------------------------------- --
  },{ T="Die Stieger sind total pleite, da sie vor kurzem von einem \z
    Gebrauchtwaffenhändler übers Ohr gehauen wurden. Ihr Traum ist es, ein \z
    befestigtes Lager zu errichten, in dem sie sicher und ungestört von \z
    ihren Feinden ihre Waffenfertigkeit und Grabfähigkeiten üben konnen."
  -- Page 28 --------------------------------------------------------------- --
  },{ T="DIE F'TARGS:\n\z
    \n\z
    Die Mitglieder dieses widerstandsfähigen\n\z
    Schatzgräberstammes sind sehr neugierig\n\z
    sowie leidenschaftliche Schrottsammler.\n\z
    Sie verspüren den unauffhörlichen Drang,\n\z
    aus dem gesammelten Schrott etwas zu\n\z
    bauen. Als Ergebnis davon sehen ihre Bauten\n\z
    und Geräte aus, als ob sie aus allem möglichen\n\z
    Zeug zusammengezimmert wären.",
    I={ 9, 220, 20 }
  -- Page 29 --------------------------------------------------------------- --
  },{ T="Die F'Targs sind die zweitschnellsten Schatzgräber. Sie sind etwas \z
    langsamer als die Grablinge, doch können sie viel länger graben als die \z
    anderen. Das Graben macht Ihnen spaß, doch sie lassen sich leicht durch \z
    Gegenstände ablenken, die ihnen gefallen. Ihr Sammelinstinkt bringt sie \z
    außerhalb der Bergwerke oft in Schwierigkeiten. Sie sind weder sehr \z
    aggressiv, noch gute Kämpfer, doch wenn sie verletzt werden, heilen ihre \z
    Wunden doppelt so schnell wie die aller anderen Schatzgräber."
  -- Page 30 --------------------------------------------------------------- --
  },{ T="Der sehnlichste Wunsch der F'Targs ist es, genügend Geld \z
    anzuhäufen, um ihr geplantes Museum der metallenen Meisterwerke (dem \z
    eine bösartige Seele den unfreundlichen Spitznamen \"Schrotthaufen\" \z
    verlieh) zu bauen. Darin wollen sie zeitlosen Schrott und besonders \z
    interessante Blechskulpturen ausstellen."
  -- Page 31 --------------------------------------------------------------- --
  },{ T="DIE FLIMMERER:\n\z
    \n\z
    Von disem schüchternen und friedliebenden Stamm, dessen Mitglieder \z
    spurlos von der Planetenoberfläche verschwunden sind, ist nur wenig \z
    übriggeblieben. Die Flimmerer, die als die besten Schatzgräber von allen \z
    galten, sollen sich während einer besonders intensiven Grabsaison so \z
    erschöpft haben, daß sie ihre ganze Freude am Graben verloren. Nach \z
    einem letzten Besuch auf der Bank von Zarg, wo sie auf all ihre \z
    weltlichen Besitztümer verzichteten und ihre Güter auf den Schaltertisch \z
    warfen - was eine Diamantenkaufpanik verursachte, die den galaktischen \z
    Markt erschütterte - machten sie sich in die Ferne auf ... und \z
    verschwanden."
  -- Page 32 --------------------------------------------------------------- --
  },{ T="Wo sich die Flimmerer heute aufhalten weiß niemand, obschon man \z
    sich in alten Schatzgräberlegenden erzählt, einige Leute hätten \z
    flüchtige Blicke auf schüchterne Wesen, die wie Flimmerer aussahen, \z
    erhascht. Die meisten dieser Geschichten wurden auf übermäßigen \z
    Grokkonsum zurückgeführt, doch das Gerücht bleibt weiterhin bestehen, \z
    daß irgenwo weit entfernt von hier in den Tiefen unterirdischen Höhlen \z
    des Planeten die Nachkommen dieser Schatzgräber ihr Dasein fristen.\n\z
    Halten sie also beim Graben die Augen offen. Wer weiß, vielleicht ist \z
    jener flüchtige Schatten, der in einem dunklen Gang an Ihnen \z
    vorbeihuschte, in Wahrheit ein flimmerer?"
  -- Page 33 --------------------------------------------------------------- --
  },{ T="BESCHREIBUNG DER STAMMESMERKMALE\n\z
    \n\z
    Ausdauer                                        Aggressivität\n\z
    \n\z
    Stärke                                           Besondere Fähigkeiten\n\z
    \n\z
    Geduld                                            Teleportfähigkeit\n\z
    ¶                                                          (nur Habich)\n\z
    Grabgeschwindigkeit\n\z
    \n\z
    Intelligenz                                     Doppelte\n\z
    ¶                                               Heilungsgeschwindigkeit\n\z
    ¶                                                      (nur f'Targs)",
    I={ 5, 156, 44 }, L=-1.5
  -- Page 34 --------------------------------------------------------------- --
  },{ T="ZONENBESCHREIBUNGEN\n\z
    \n\z
    Grasland: Ein flaches, von Flüssen durchzogenes Savannengebiet. Unter \z
              der Erdoberfläche befinden sich weitere Flüsse, Höhlen und \z
              einige undurchdringliche Felsen. Unter den jüngsten Funden \z
              befanden sich die versteinerten Überreste riesiger Geschöpfe \z
              unbekannten Ursprungs.\n\z
    Wald/Dschungel: Ein zum größten Teil flaches Gebiet mit sich windenden \z
                    Flüssen und kleinen Seen. Die Ackerkrume ist besonders \z
                    reich an Nährstoffen, wodurch das Wachstum riesiger \z
                    Bäume unterstützt wird, die weit in den Himmel ragen. \z
                    Die Baumwurzeln reichen tief in das Erdreich. Dicht \z
                    verwachsenes Wurzelwerk kann weder entfernt noch \z
                    durchbohrt werden."
  -- Page 35 --------------------------------------------------------------- --
  },{ T="Übertageanlagen sollten in Lichtungen zwischen den Bäumen \z
         errichtet werden, um die Wurzeln zu meiden. Es gehen jede Menge \z
         Geschichten über das seltsame Pflanzenleben in dieser Gegend um, \z
         bisher gibt es jedoch keinerlei Beweise.\n\z
    Wüste: Dieser trockenste Bereich des Planeten Zarg ist voller Sand und \z
           Wanderdünen. Die Auswirkung der Erosion ist hier offensichtlich. \z
           Riesige Felsformationen wurden unter dem Sand vergraben und zu \z
           einer undurchlässigen Masse verdichtet.\n\z
           Unter dem sand befinden sich enorme buntschillernde \z
           Kristallstrukturen. Zudem gibt es unterirdische Seen und \z
           Wasserquellen."
  -- Page 36 --------------------------------------------------------------- --
  },{ T="Eis: In diesem gefrierschrankähnlichen Gebiet gibt es klirrend \z
              kalte Seen und zahlreiche Eisberge. Aufgrund der \z
              Überflutungsgefahr sollte man beim Graben auf diesen Ebenen \z
              besondere Vorsicht walten lassen. Dies gilt besonders für die \z
              Eisberge.\n\z
    Inseln: Dieses Gebiet besteht aus einer großen, im weiten Ozean \z
            verstreuten Inselgruppe. Alle Inseln sind unter der \z
            Wasseroberfläche verbunden und bilden somit eine ausgedehnte \z
            Unterwasser-Gebirgskette.\n\z
    Berge: Ein Gebiet mit zerklüfteten Gipfeln und unsicheren, felsigen \z
           Abhängen, indem sich nur wenige zum Graben geeignete Stellen \z
           finden lassen. Überall in dem Gebirge gibt es jedoch \z
           weitreichende Höhlen, die bessere Möglichkeiten für Bergarbeiten \z
           bieten."
  -- Page 37 --------------------------------------------------------------- --
  },{ T="Unter der festen Oberfläche befinden sich zum Teil harte \z
    Felsablagerungen, die das Graben an manchen Stellen unmöglich machen. \z
    Zudem gibt es Wasserquellen.\n\z
    Felsiges Gebiet: Ein Gebiet ähnlich dem Grand Canyon mit zahlreichen \z
    Überhängen, Steilhängen und unsicheren Felsformationen. Unter der \z
    Oberfläche befinden sich riesige, undurchdringliche Felsflächen. Nahe \z
    der Oberfläche gibt es kaum Spuren von Wasser; tief im Erdinnern findet \z
    man jedoch zahlreiche, mit Wasser gefüllte Höhlen. Der Lauf seit langem \z
    versiegter Flüsse schuf eine Reihe zusammenhängender Höhlen und \z
    Durchgänge zwischen den Felsschichten. Gerüchten zufolge soll es auf \z
    dieser Ebene verlorene Städte geben, in denen die Geister der früheren \z
    Bewohner ihr Unwesen treiben."
  -- Page 38 --------------------------------------------------------------- --
  },{ T="FLORA UND FAUNA\n\z
    \n\z
    Das Verschwinden der gesamten Frinklin-Expedition von 95 bedeutete einen \z
    schweren Schlag für die anthropologischen und botanischen Studien des \z
    Planten Zarg. Es bestehen aus diesem Grunde keinerlei schlüssige \z
    Berichte zur Flora und Fauna auf Zarg. Die folgenden Notizen wurden \z
    einer Reihe professioneller Aufzeichnungen und Zeugenberichten \z
    entnommen, es existieren jedoch sicherlich noch andere Tiere und \z
    Pflanzen. Senden Sie bitte Einzelheiten, Exemplare oder Skizzen neuer \z
    Lebensformen an Professor A. Mazonas, Kletterpflanzenturm, \z
    Grzimek-Institut für galaktisches Grünzeug."
  -- Page 39 --------------------------------------------------------------- --
  },{ T="Triffidus Carnivorus\n\z
    \n\z
    In Dschungel- und Waldgebieten\n\z
    beheimatet, wo sie sich mit den\n\z
    Gewächsen vermischt. Extrem\n\z
    bösartige fleischfressende Pflanze,\n\z
    die über einen großen Appetit verfügt.\n\z
    Kann anhand der ungewöhnlichen\n\z
    Blattfarbe identifiziert werden.\n\z
    \n\z
    Im Magen eines eingefangenen Exemplars wurden nach \z
    Infrarot-Untersuchungen ein Führer zum Entdecken gefährlicher Pflanzen \z
    für Anfänger sowie eine Brille ähnlich der von Dr. Frinklin gefunden.",
    I={ 10, 200, 40 }
  -- Page 40 --------------------------------------------------------------- --
  },{ T="Fungus Kaleidoscopus\n\z
    \n\z
    Diese Pilze wachsen an vielen\n\z
    Stellen in großen Mengen. Sie\n\z
    werden leicht an dem roten \"Hut\"\n\z
    mit weißen Punkte erkannt.\n\z
    \n\z
    Wissenschaftliche Studien haben gezeigt, daß der Verzehr dieser Pilze \z
    zahlreiche Auswirkungen haben kann. Einige Menschen starben ganz \z
    einfach, auf einige hatten die Pilze dieselbe Wirkung wie ein \z
    Stärketrank und andere wiederum schienen verwirrt und redeten \z
    unzusammenhängendes Zeug von rosafarbenen Giraffen.",
    I={ 11, 200, 15 }
  -- Page 41 --------------------------------------------------------------- --
  },{ T="Stegosaurus\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Großer Dinosaurier, der in unterirdischen Höhlen beheimatet ist. \z
    Sandfarbene Haut, zwei Hörner. Der im allgemeinen sanftmütige \z
    Stegosaurus greift sofort an, wenn er provoziert oder bedroht wird. In \z
    engen Passagen und Schächten kann der Stegosaurus seine Feinde \z
    vernichtend schlagen.",
    I={ 12, 96, 15 }
  -- Page 42 --------------------------------------------------------------- --
  },{ T="Rotorysaurus\n\z
    \n\z
    Ein eher seltamer Dinosaurier, der die unterirdischen Ebenen bewohnt, \z
    sich jedoch gelegentlich an die Oberfläche des Planeten verirrt. Der \z
    Rotorysaurus gilt als recht gelassen, reagiert jedoch auf Provokation \z
    und Angriff entsprechend und kann seinem Gegner schwere Verletzungen \z
    zufügwn."
  -- Page 43 --------------------------------------------------------------- --
  },{ T="Velociraptor\n\z
    \n\z
    Ein Dinosaurier von außergewöhnlicher Bösartigkeit. Braucht zum Angriff \z
    absolut keine Provokation schon der Anblick einer anderen Kreatur \z
    genügt. Obwohl er von kleinem Wuchs ist, ist seine kraft mit der des \z
    Stegosaurus vergleichbar. Um jeden Preis zu meiden. Wenn man auf einen \z
    Velociraptor trifft, sollte man entweder sofort das Weite suchen, oder \z
    aber ihn in die Minen der Gegner locken und dann weglaufen."
  -- Page 44 --------------------------------------------------------------- --
  },{ T="Eius Horribilis\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Herkunft unbekannt. Die einzige Beschreibung dieser Eier stammt von \z
    einem inzwischen pensionierten Schatzgräber. Hier ist seine \z
    Geschichte:\n\z
    \n\z
    \"Es war einfach schrecklich. Wir sollten diesen Felsbrocken \z
    durchbrechen. Also, ich sag's Ihnen ehrlich, ...",
    I={ 13, 96, 15 }
  -- Page 45 --------------------------------------------------------------- --
  },{ T="...das hat mit überhaupt nicht gefallen. Irgendwas war da faul. \z
    Also, wir haben uns durch den Felsen geschlagen, und dahinter war eine \z
    Höhle. Ich hab' hineingeleuchtet, aber es schien nichts drin zu sein. \z
    Ich hab zu meinem Kumpel gesagt: \"Komm Bolbo, laß uns gehen. Zeit für \z
    einen Grok.\" Aber er ist nicht gekommen. Er hatte nämlich das dreckige \z
    Ei gesehen. \"Laß das doch\", habe ich gesagt, aber er hat nicht auf \z
    mich gehört. Er hat es aufgehoben und dann ist das Ding auf ihn \z
    gesprungen .... es war so furchtbar. Es ist irgendwie in ihn \z
    hineingegangen. Ich konnte nicht hinsehen. Ich hab' mich umgedreht und \z
    bin losgerannt. Es war ganz schrecklich, widerlich. Ham'se mal die \z
    Flasche?\"",
  -- Page 46 --------------------------------------------------------------- --
  },{ T="\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Dickfellige Säugetiere\n\z
    \n\z
    Große Säugetiere, die angeblich vor einer Million Jahren auf Zarg \z
    lebten. Die gefrorenen Überreste dieser Tiere wurden vor einem Jahr \z
    entdeckt, und wahrscheinlich gibt es in den vereisten Gebieten noch mehr.",
    I={ 14, 96, 15 }
  -- Page 47 --------------------------------------------------------------- --
  },{ T="Das Fleisch der dickfelligen Säugetiere wurde won verhungernden \z
    Polarforschern verspeist:\n\z
    \"Mnmn, nur eine ... Sekunde ... ich bin gleich mnmnmnm ... fertig mit \z
    ... kauen ...\"\n\z
    \"Ich glaube, ich werde zum Vegetarier.\"\z
    \"Homm, homm, Herr Humbug, homm, homm.\""
  -- Page 48 --------------------------------------------------------------- --
  },{ T="\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Fisch\n\z
    \n\z
    Auf dem Planeten soll es eine große Vielfalt an Fischen geben. Die \z
    Erzählungen von Anglern haben sich jedoch als etwas unzuverlässig \z
    erwiesen.",
    I={ 15, 96, 15 }
  -- Page 49 --------------------------------------------------------------- --
  },{ T="Nur wenige Exemplare wurden jemals zum Institut gebracht - \z
    \"er ist mir entwischt\" - und präzise Größenschätzungen scheinen \z
    unmöglich zu sein. Geschichten des wilden \"Pikosaurus\" sind ebenfalls \z
    mit Vorsicht (und etwas Zitronensaft) zu genießen."
  -- Page 50 --------------------------------------------------------------- --
  },{ T="\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Sandwürmer\n\z
    \n\z
    Große Landtiere obskuren Geschlechts. Diese scheuen Wesen leben \z
    wahrscheinlich tief unter der Erdoberfläche und werden nur selten \z
    gesehen, so daß man kaum etwas über ihre Verhaltungsmuster weiß. Es \z
    folgt der Bericht eines Stiegers zu seinem Zusammentreffen mit einem \z
    Sandwurm.",
    I={ 16, 96, 15 }
  -- Page 51 --------------------------------------------------------------- --
  },{ T="\"Wir haben ruhig vor uns hingegraben, d. h. so ruhig es geht, wenn \z
    man mit Dynamit arbeitet, als sich auf einmal der Boden unter meinen \z
    Füßen bewegte. Also, ehrlich gesagt hat mich das erst einmal etwas \z
    verwirrt. Ich hatte kaum Zeit nachzudenken, da fiel ich auch schon hin \z
    unt stieß mir den Kopf an. Gott sei Dank hat das aber geholfen, und mir \z
    wurde klar, daß das Viech vor mir so ein Wurm war ganz groß und \z
    überhaupt. Nicht daß ich Angst gehabt hätte - Ich nahm meine Schaufel, \z
    um mit ihm zu kämpfen. \"Komm doch\". hab' ich gesagt, aber er \z
    schängelte sich durch den Schacht und verschwandt. Ein richtiger \z
    Hasenfuß, wenn Sie meine Meinung hören wollen.\"",
  -- Page 52 --------------------------------------------------------------- --
  },{ T="Mysteriöse Erscheinungen\n\z
    \n\z
    Über die Jahre hinweg gab es immer wieder Gerüchte über seltsame \z
    ätherische Wesen, die angeblich die Höhlen unterhalb der Zargoberfläche \z
    bewohnen sollen. Schatzgräber, die zurück an die Oberfläche flohen und \z
    ihre Geschichte erzählen konnten, sprachen von sich bewegenden, \z
    geisterartigen Erscheinungen, die die Gruppe angriffen und die Männer \z
    töteten. In anderen Geschichten heißt es, daß schatzgräberähniiche Wesen \z
    mit hohem Tempo von den Decken großer Höhlen heruntersturzten und die \z
    Männer innerhalb weniger Sekunden dahinmetzelten.",
  -- Page 53 --------------------------------------------------------------- --
  },{ T="In den Bars des Planeten wird erzählt, daß es sich dabei um die \z
    Geister der Schatzgräber handle, die von Claim-Räubern ihrem Schicksal \z
    - und sicheren Tod - überlassen und durch den Kontakt mit lebenden \z
    Schatzgräbern in Zombies verwandelt wurden. Offiziell werden solche \z
    Geschichten natürlich dementiert.\n\z
    \n\z
    In anderen Berichten hieß es, daß kleine. \"außerirdisch-aussehende\" \z
    Geschöpfe gesichtet worden wären, die irgendwie mit dem Eius Horribilis \z
    zusammenhingen. Die Berichte konnten nicht bestätigt werden, da \z
    diesbezügliche wissenschaftliche Expeditionen niemals zurückkehrten. Die \z
    Wesen könnten, so sie denn existieren, gefährlich sein!",
  -- Page 54 --------------------------------------------------------------- --
  },{ T="Über den ganzen Planeten verstreut gibt es mobile Portale, die \z
    gemeinhin Wirbeltore genannt werden. Diese ungewöhnlichen Objekte \z
    schweben sanft durch die unterirdische Welt. Wenn ein Schatzgräber \z
    versehentlich in ein solches Tor gerät, wird er unmittelbar an einen \z
    willkürlich bestimmten Ort innerhalb der Zone transportiert. Die \z
    religiösen Eiferer bei den Habich sind überzeugt, daß die Wirbeltore die \z
    geistigen Überreste jener Habich sind, denen die volle Erleuchtung \z
    versagt blieb, und die dazu verdammt sind, den Planeten Zarg in ihrem \z
    gegenwärtig unvollkommenen Zustand zu durchwandern. Weniger religiös \z
    angehauchte Schatzgräber halten sie für ein weiteres Wunder dieses \z
    wundersamen Planeten und suchen nach keiner Erklärung für ihre \z
    Existenz.... was auch sehr viel vernünftiger ist.",
  -- Page 55 --------------------------------------------------------------- --
  },{ T="Weite Teile des Planeten sind noch nicht karthographisch erfaßt und \z
    zum größten Teil auch noch nicht erforscht, weswegen die oben \z
    aufgeführten Einzelheiten auch nicht umfassend sind. Nehmen Sie sich \z
    also in acht, und seien Sie sich jederzeit bewußt, daß nicht alles so \z
    ist, wie es scheint."
  -- Page 56 --------------------------------------------------------------- --
  },{ T="DER BERGBAULADEN\n\z
    \n\z
    Im Bergbauladen gibt es eine breite Palette an Ausrüstungsgegenständen, \z
    die alle von einem Schatzgräberveteranen ausgewählt wurden, der sich mit \z
    den gefährlichen Bedingungen unter Tage bestens auskennt. Der Großteil \z
    der Ausrüstung wurde zu Schleuderpreisen auf einem Flohmarkt eines \z
    kleinen Erdenterritoriums namens Großbritannien erstanden, wo der \z
    Bergbau nur noch eine entfernte Erinnerung ist.\n\z
    \n\z
    Wenn Sie den Laden betreten, zeigt Ihnen der liebenswürdige \z
    Ladenbesitzer gern, wie man seine Einkäufe tätigt. "
  -- Page 57 --------------------------------------------------------------- --
  },{ T="Sein Bestandsbuch enthält die Preise und Beschreibungen aller \z
    vorrätigen Waren. Damit der Käufer die Waren betrachten kann, erscheint \z
    automatisch ein Hologramm der einzelnen Gegenstände.\n\z
    \n\z
    Um einen Gegenstand zu wählen, klicken Sie einfach auf das entsprechende \z
    Symbol. Der Preis wird automatisch von Ihrem Konto abgebucht.\n\z
    \n\z
    I. Die wirtschaftliche Situation kann Preisschwankungen (abhängig von \z
    der Verfügbarkeit der Waren) zu Folge haben.\n\z
    II. Die Geschäftsleitung behält sich das Recht vor, alles und jedes \z
    jederzeit und ohne Vorwarnung zu ändern."
  -- Page 58 --------------------------------------------------------------- --
  },{ T="ARTIKEL FÜR DEN BERGBAU\n\z
    \n\z
    Schleusentore\n\z
    \n\z
    Preis: 80 Einheiten.\n\z
    Gewicht: 10 Hechel.\n\z
    \n\z
    Allgemeine Informationen: Schleusentoren können nur von demjenigen \z
    geöffnet und geschlossen werden, der sie installiert hat. Besonders \z
    nützlich in Gegenden, in denen die Gefahr von flutartigen \z
    Überschwemmungen besteht. Können zum Schutz von Grabungen vor \z
    rivalisierenden Schatzgräbern verwendet werden.",
    I={ 17, 224, 29 }
  -- Page 59 --------------------------------------------------------------- --
  },{ T="Schleusentore sind extrem widerstandsfähig gegen Druck und halten \z
    den meisten Grabungsmaschinen stand. Sie können jedoch mit sehr viel \z
    Sprengstoff geöffnet werden."
  -- Page 60 --------------------------------------------------------------- --
  },{ T="Telepol\n\z
    \n\z
    \n\z
    \n\z
    Preis: 260 Einheiten.\n\z
    Gewicht: 12 Hechel.\n\z
    \n\z
    Allgemeine Informationen: Wahrscheinlich das wichtigste Gerät eines \z
    jeden Schatzgräbers. Mit dem Telepol kann man direkt von Telepol zu \z
    Telepol reisen. Zu Beginn der Grabungen erhält jeder Schatzgräberstamm \z
    einen Teleport. Habich können die Telepole der anderen \z
    Schatzgräberstämme benutzen. Anderen Schatzgräbern stehen nur die \z
    eigenen Telepole zur Verfügung.",
    I={ 18, 196, 29 }
  -- Page 61 --------------------------------------------------------------- --
  },{ T="Schienen\n\z
    \n\z
    \n\z
    \n\z
    Preis: 10 Einheiten.\n\z
    Gewicht: 3 Hechel.\n\z
    \n\z
    Allgemeine Informationen: Einzelne Schienenstränge sind recht kurz. Sie \z
    werden jedoch in Fünferpacks geliefert, wobei sich das angegebene \z
    Gewicht auf alle fünf bezieht. Die Schienen müssen korrekt verlegt \z
    werden. Wenn sie erst einmal liegen, bilden sie eine feste Verbindung \z
    mit dem Boden und können nicht mehr bewegt oder durchbohrt werden.",
    I={ 19, 196, 29 }
  -- Page 62 --------------------------------------------------------------- --
  },{ T="Automatische Güterwagen\n\z
    \n\z
    \n\z
    \n\z
    Preis: 100 Einheiten.\n\z
    Gewicht: 9 Hechel.\n\z
    \n\z
    Allgemeine Informationen: Ein genialer Güterwagen mit Selbstantrieb und \z
    Selbststeuerung. Kann große Mengen an Mineralien aufnehmen. Ideal für \z
    den schnellen Transport von Schatzgräbern oder Mineralien.",
    I={ 20, 196, 29 }
  -- Page 63 --------------------------------------------------------------- --
  },{ T="Kleine Streckenvortriebsmaschine\n\z
    \n\z
    \n\z
    \n\z
    Preis: 150 Einheiten.\n\z
    Gewicht: 8 Hechel.\n\z
    \n\z
    Alloemeine Informationen: Kabellose Maschine. Spitzname: Maulwurf. \z
    Leicht und tragbar. Bohrt um vieles scheller als der schnellste \z
    schaufelschwingende Schatzgräber.",
    I={ 21, 196, 29 }
  -- Page 64 --------------------------------------------------------------- --
  },{ T="Brückenbauteil\n\z
    \n\z
    \n\z
    \n\z
    Preis: 25 Einheiten.\n\z
    Gewicht: 3 Hechel.\n\z
    \n\z
    Alloemeine Informationen: Unschätzbarer Gegenstand zum Überbrücken von \z
    Flüssen. Extrem stark. Kann schwere Lasten tragen. Das Brückenteil \z
    muß sicher im festen Boden verankert werden. Brücken sind leichte Ziele \z
    beim Überqueren ist besondere Vorsicht geboten.",
    I={ 22, 196, 29 }
  -- Page 65 --------------------------------------------------------------- --
  },{ T="Aufblasbares Boot\n\z
    \n\z
    \n\z
    \n\z
    Preis: 60 Einheiten.\n\z
    Gewicht: 5 Hechel.\n\z
    \n\z
    Alloemeine Informationen: Besonders widerstandsfähig. Tragekapazität: \z
    Ein Schatzgräber. Nicht geeignet bei hohem Seegang oder für längere \z
    Reisen.",
    I={ 23, 196, 29 }
  -- Page 66 --------------------------------------------------------------- --
  },{ T="Vertikaler Bagger\n\z
    \n\z
    \n\z
    \n\z
    Preis: 170 Einheiten.\n\z
    Gewicht: 10 Hechel.\n\z
    \n\z
    Alloemeine Informationen: Aufgrund des Bohrvorgangs oft als \z
    \"Korkzieher\" bezeichnet. Die Maschine kann nur verwendet werden, um \z
    vertikal nach unten zu graben. Wenn der \"Korkzieher\" in Betrieb \z
    gesetzt ist, gräbt er automatisch für eine zuvor festgelegte Zeit oder \z
    bis er auf ein Hindernis auftrifft. In feuchten Gebieten sollte mit dem \z
    Gerät vorsichtig umgegangen werden.",
    I={ 24, 196, 29 }
  -- Page 67 --------------------------------------------------------------- --
  },{ T="Große Streckenvortriebsmaschine\n\z
    \n\z
    \n\z
    \n\z
    Preis: 230 Einheiten.\n\z
    Gewicht: 11 Hechel.\n\z
    \n\z
    Alloemeine Informationen: Diese besser unter dem Namen \"Monster\" \z
    bekannte Maschine ist ein hervorragendes Grabegerät. Es kann sich \z
    ausgesprochen schnell durch Felsen graben. Bei der Handhabung des \z
    \"Monsters\" muß man extrem vorsichtig sein. Zeigen Sie auf den \z
    gewünschte Punkt und starten Sie die Maschine. Stellen Sie sich niemals \z
    vor das \"Monster\". Die Maschine kann nur vorwärts graben.",
    I={ 25, 196, 29 }
  -- Page 68 --------------------------------------------------------------- --
  },{ T="Sprengstoff\n\z
    \n\z
    \n\z
    \n\z
    Preis: 20 Einheiten.\n\z
    Gewicht: 4 Hechel.\n\z
    \n\z
    Alloemeine Informationen: VORSICHT: Hochexplosiv! Unerläßliche \z
    Ausrüstung zum Sprengen von Felsen oder zum Betreten der Minen des \z
    Gegners. Beim Sprengen sollte man möglichst keine Fehler machen, da \z
    diese tödlich enden können!",
    I={ 26, 196, 29 }
  -- Page 69 --------------------------------------------------------------- --
  },{ T="Aufzug\n\z
    \n\z
    Preis: 220 Einheiten.\n\z
    Gewicht: 12 Hechel.\n\z
    \n\z
    Alloemeine Informationen: Besonders nützlich zum Transportieren großer \z
    Mengen an Mineralien, Maschinen oder männern zwischen einem abgebauten \z
    Flöz und den Übertageanlagen. Wenn der Aufzug erst installert ist, kann \z
    er nicht mehr an einen anderen Ort verfrachtet ewrden. Der Aufzug muß \z
    korrekt installiert werden der obere Block und der untere Block MÜSSEN \z
    fest in der Erde verankert werden. Wenn diese Elemente sich nicht in der \z
    richtigen Position befinden, funktioniert der Aufzug nicht.",
    I={ 27, 196, 24 }
  -- Page 70 --------------------------------------------------------------- --
  },{ T="TNT-Karte\n\z
    \n\z
    \n\z
    \n\z
    Preis: 215 Einheiten.\n\z
    Gewicht: 3 Hechel.\n\z
    \n\z
    Alloemeine Informationen: Wahrscheinlich der für den Schatzgräber \z
    nützlichste Gegenstand (mit Ausnahme dieses Führers)! Unter Verwendung \z
    der besonderen Eigenschaften des TNT-Papiers zeigt die Karte die gesamte \z
    Zone mit allen Merkmalen. Wird ständig aktualisiert.",
    I={ 28, 196, 29 }
  -- Page 71 --------------------------------------------------------------- --
  },{ T="Erste-Hilfe-Set\n\z
    \n\z
    \n\z
    \n\z
    Preis: 60 Einheiten.\n\z
    Gewicht: 5 Hechel.\n\z
    \n\z
    Alloemeine Informationen: Nach dem Kauf des Erste-Hilfe-Sets bauen \z
    dessen Heilkräfte das Durchhaltevermögen seines Besitzers langsam wieder \z
    auf. Das Set kann einem anderen Goldgräber gegeben werden, damit dieser \z
    von den verbleibenden \"Medikamenten\" profiteren Kann.",
    I={ 29, 196, 29 }
  -- Page 72 --------------------------------------------------------------- --
  },{ T="DIE ZARGONISCHE BANK\n\z
    \n\z
    Der steile Erfolgskurs der zargonischen Bank wurde durch die jüngste \z
    Fusion mit der Bank von Schlimmland noch unterstützt, so daß sie ihre \z
    Operationen auf eine eigene Börse ausdehnen konnte. Die zargonische Bank \z
    kontrolliert jetzt alle finanziellen Transaktionen auf dem Planeten und \z
    hat einen Sparplan für alle Kunden entworfen. Das etwas ungewönliche an \z
    dem Plan ist, daß er obloatorisch ist.\n\z
    \n\z
    Wenn ein Schatzgräber ein Kassenkontor eröffnet, eröffnet die Bank ein \z
    Hortenkonto für den Kunden. Vom Hortenkonto kann nur dann Geld abgehoben \z
    werden, wenn der Schatzgräber den Planeten verlassen will."
  -- Page 73 --------------------------------------------------------------- --
  },{ T="Ein Sprecher der Bank erklärte: \"Es ist eine Versicherungspolice \z
    gegen Kunden, die den Planeten heimlich verlassen und ihre Schulden \z
    zurücklassen.\n\z
    \n\z
    Wenn die Grabungen aufgenommen werden, ist die Bank durchaus bereit, dem \z
    Hauptverantwortlichen einen Kredit von 100 Einheiten zu gewähren. Am \z
    Ende jeder erfolgreichen Grabung innerhalb einer Zone muß der \z
    Hauptschatzgräber jedoch den Kredit zurückzahlen.\n\z
    \n\z
    Wenn der Hauptschatzgräber die nächste Zone beginnt, gleicht die Bank \z
    ein etwaiges Defizit aus, damit ihm mindestens 100 Einheiten zur \z
    Verfüoung stehen."
  -- Page 74 --------------------------------------------------------------- --
  },{ T="Wenn er natürlich schon 100 Einheiten besitzt, benötiot er keine \z
    Anleihe von der Bank.\n\z
    \n\z
    Die Bank verfolgt auch eine großzügige Politik, wobei Ausrüstung \z
    (Aufzüge, Maschinen usw.) in Zahlung gegeben werden können. Angenommen, \z
    ein Hauptschatzgräber schließt ein Minengebiet erfolgreich ab, dann will \z
    er sicher nicht die gesamte erworbene Ausrüstung zurücklassen. Die Bank \z
    veranlaßt, daß die Mine von Begutachtern besucht wird, die die \z
    Ausrüstung entfernen und dem Hauptschatzgräber ca. 75% des Wertes \z
    zahlen, sofern die Ausrüstung in passablem Zustand ist. Dadurch ist \z
    gewährleistet, daß seine Investitionen wenigsten einen gewissen Ertrag \z
    bringen."
  -- Page 75 --------------------------------------------------------------- --
  },{ T="Der Betrag wird ohne weitere Abzüge in die nächste Zone übernommen. \z
    Die Bank macht natürlich einen extrem hohen Gewinn, wenn sie die \z
    Ausrüstung als new an andere Schatzgräber verkauft, aber das ist \z
    natürlich nur ein gemeines Gerücht, das von verstimmten, finanziell \z
    ruinierten Schatzgräbern in die Welt gesetzt wurde."
  -- Page 76 --------------------------------------------------------------- --
  },{ T="DIE ZARGONISCHE BÖRSE\n\z
    \n\z
    Auf der zargonischen Börse herrscht wie auf jeder anderen Börse das \z
    Prinzip von Angebot und Nachfrage. Die Börse ist über ein Netzwerk mit \z
    anderen Börsen in der Galaxie verbunden, wodurch der Handel mit und die \z
    Preise von Mineralien oft durch die Geschäfte und Vorfälle auf anderen \z
    Planeten beeinflußt werden.\n\z
    \n\z
    Über dem Kopf des Kassierers befindet sich eine Anzeige, auf der die \z
    derzeit von diesem Kassierer gehandelten Mineralien oder Edelsteine \z
    aufgeführt sind."
  -- Page 77 --------------------------------------------------------------- --
  },{ T="Wenn Sie die Anzeige wählen, sehen Sie den Wert des Minerals bzw. \z
    Edelsteins. Wenn Sie den Kassierer wählen, können Sie Ihre Mineralien \z
    oder Edelsteine verkaufen.\n\z
    \n\z
    Es werden immer nur die angezeigten Mineralien oder Edelsteine gekauft; \z
    die Handelsinteressen der Bank sind jedoch flexibel, so daß zu anderen \z
    Zeiten anderen Mineralien angekauft werden. Die Preise ändern sich auch \z
    ständig als Reaktion des Gesetzes von Angebot und Nachfrage. Ein großer \z
    Goldfund überflutet z. B. den Markt und mindert den Goldwert."
  -- Page 78 --------------------------------------------------------------- --
  },{ T="Ein Edelstein behält allerdings immer seinen Wert: Jennit. Jennit ist \z
    ein rosafarbener Edelstein, der sehr selten vorkommt und daher \z
    ausgesprochen kostbar ist.\n\z
    \n\z
    Sämtliche Kassierer kaufen jederzeit mit Freuden Jennit an."
  -- Page 79 --------------------------------------------------------------- --
  },{ T="DIE GESCHICHTE DER ZAGONNISCHEN MINEN\n\z
    \n\z
    Die Geschichte des Planten Zarg ist so schillernd wie die Edelsteine, \z
    die in seinen Bergwerken abgebaut werden. Seine legendären Reichtümer \z
    haben zu jeder Zeit zahlreiche Strandgutjäger, Schatzgräber, \z
    Kopfgeldjäger und andere, den schnellen Wohlstand suchende Händler \z
    angezogen.\n\z
    \n\z
    Leider gibt der Planet seine Schätze jedoch nicht so leicht ab, und nur \z
    wenige verließen inn reicher, als sie ihn betraten. Ja, viele haben ihn \z
    nie mehr verlassen. Der Grund für Zargs Reichtum ist auch der Grund für \z
    die Probleme beim Abbau der Schätze. Sie entstanden durch die heftigen \z
    vulkanischen und tektonischen Aktivitäten, ..."
  -- Page 80 --------------------------------------------------------------- --
  },{ T="...die den Planeten acht Monate im Jahr beuteln. Während dadurch \z
    die Mineralienvorkommen unter der Oberfläche regeneriert werden, \z
    zerstören die Erschütterungen die meisten Strukturen über Tage. Die \z
    Überreste vieler untergegangener Städte und Zivilisationen sollen sich \z
    angeblich noch tief in der Erde befinden, verschwunden in Abgründen und \z
    Schlünden."
  -- Page 81 --------------------------------------------------------------- --
  },{ T="Banküberfall bei Tageslicht\n\z
    \n\z
    Es gab schon viele Versuche, die\n\z
    zargonische Bank auszurauben. Der\n\z
    erfolgreichste Banküberfall wurde\n\z
    von dem legendären Juwelendieb\n\z
    Dieter Ieb durchgeführt.\n\z
    \n\z
    Gut getarnt und im Vertrauen auf seine Intelligenz erschien D. Ieb als \z
    Inspektor, der vom Präsidenten der Interplanetarischen Banken GmbH \z
    geschickt wurde, um die Sicherheitssysteme zu überprüfen. Er war so \z
    überzeugend, daß ihn die Bankangestellten durch die Bank führten, ihm \z
    die Alarmanlagen zeigten und die Codenummern gaben.",
    I={ 30, 212, 28 }
  -- Page 82 --------------------------------------------------------------- --
  },{ T="In der Nacht kam der Bankräuber zurück, um die erlangten \z
    Informationen in der Praxis zu prüfen. Als die Bank am Morgen von den \z
    Angestellten geöffnet wurde, waren die Tresore leer. Nur ein kleiner \z
    Zettel war zu finden, auf dem stand:\n\z
    \n\z
    Das war ich nicht. Es waren Tag S. Licht und Ü. B. Rfall! Ha, ha, ha, \z
    ha. Danke für die Steinchen!\n\z
    \n\z
    D. Ieb"
  -- Page 83 --------------------------------------------------------------- --
  },{ T="Der Zusammenbruch von 94\n\z
    \n\z
    An diesem Tag, der als Schwarzer Dienstag (nicht zu verwechseln mit dem \z
    Düsteren Dienstag, an dem alle Transaktionssysteme zusammenbrachen ein \z
    F'Targ wurde später gefeuert, weil er Mikrochips aus den Computern \z
    genommen hatte. Seine Entschuldigung \"sie sind für meine Sammlung\" \z
    galt als nicht akzeptabel) in die Geschichte einging, wurde die Bank in \z
    ihren Grundfesten erschüttert, als ein aus der Kontrolle geratenes \z
    \"Monster\" (eine große Streckenvortriebsmaschine) die Kellerwände der \z
    Bank durchbrach."
  -- Page 84 --------------------------------------------------------------- --
  },{ T="Millionen von Einheiten gingen verloren. Die Diebe wurde niemals \z
    gefunden. Interessant war jedoch, daß im gesamten darauffolgenden Monat \z
    kein Grablinger zu irgendeinem Zeitpunkt aufrecht gesehen wurde."
  -- Page 85 --------------------------------------------------------------- --
  },{ T="Spieltips und -ratschläge für den Gang durch die alten Minen.\n\z
    \n\z
    Viele Goldgräber sind von ihren Expeditionen zurückgekehrt und haben von \z
    Graffitis in den alten Minen berichtet, die in der Absicht nachfolgenden \z
    Goldgräbern Tips und Ratschläge zu geben auf die Höhlenwände gesprayt \z
    worden sind.\n\z
    \n\z
    Die wichtigsten Tips sind:\n\z
    \n\z
    Wenn Du so schnell wie möglich zu Reichtümern kommen willst, grabe nicht \z
    zu tief."
  -- Page 86 --------------------------------------------------------------- --
  },{ T="Setze Brücken klug ein, denn sie erlauben Dir nicht nur Wasser zu \z
    überqueren, sondern auch höher und weiter zu springen.\n\z
    \n\z
    Verausgabe Dich nicht beim Versuch, Dich durch unbezwingbaren Fels zu \z
    graben, sondern sprenge den verflixten Brocken einfach in die Luft. Aber \z
    aufgepaßt, überflute dabei nicht den ganzen Tunnel, denn Du kannst Dir \z
    keinen Fluchtweg aus der Zone freisprengen.\n\z
    \n\z
    Du kannst zwar Deine Feinde durch blutrünstiges Töten vermindern, aber \z
    vergiß nicht, daß die Bank von Zarga mit Zongs und nicht mit Leichen \z
    handelt. Also suche Edelsteine und nicht Rache."
  -- Page 87 --------------------------------------------------------------- --
  },{ T="Abgesehen von diesen guten Tips solltest Du folgendes nie \z
    vergessen:\n\z
    \n\z
    - Speichere das Spiel nach Beendung jeder Zone.\n\z
    \n\z
    - Bringe Deine Juwelen immer sofort zur Bank, um Deinen Reichtum \z
    gegenüber Deinem Gegner zu maximieren, und um Diebstähle in der Mine zu \z
    vermeiden.\n\z
    \n\z
    - Vergiß nie, wie wertvoll Deine Ausrüstung ist. Du kannst nämlich mit \z
    ihr handeln und so zu einer neuen Zone gelangen."
  }
};
-- Imports and exports ----------------------------------------------------- --
return { F = Util.Blank, A = { aBookData_de = aBookData } };
-- End-of-File ============================================================= --
