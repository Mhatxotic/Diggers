-- BOOK-IT.LUA ============================================================= --
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
-- Italian Book data ------------------------------------------------------- --
local aBookData<const> = {
  -- Parameters ------------------------------------------------------------ --
  -- T = The text to display on that page. It is word-wrapped on the fly.
  -- I = The optional illustration to display on that page { iTileId, iX, iY }.
  -- L = The optional line-spacing to use.
  -- H = The optional hotspots to use { { iX, iY, iW, iH, iGotoPage }, ... }
  -- Page 1 ---------------------------------------------------------------- --
  { T="IL LIBRO DI ZARG\n\z
    \n\z
    Tale libro contiene informazioni riguardo a molti aspetti del pianeta \z
    Zarg e fornisce dettagli indispensabili per chiunque desideri \z
    intraprendervi operazioni di scavo. Tali informazioni si trovano nei \z
    capitoli corrispondenti. Per ottenere le informazioni necessarie, fare \z
    clic sul titolo del capitolo corrispondente e la pagina scelta apparirà \z
    sullo schermo. Nel margine sinistro del libro vi sono alcuni pulsanti \z
    che consentono di andare alla pagina desiderata."
  -- Page 2 ---------------------------------------------------------------- --
  },{ T="TITOLI DEI CAPITOLI\n\z
    \n\z
    INFORMAZIONI SUL LIBRO\n\z
    COME AVVIARE DIGGERS (OPZIONI DI GIOCO)\n\z
    IL PIANETA ZARG e IL MITICO 412\n\z
    DESCRIZIONE DELLE RAZZE DI SCAVATORI\n\z
    DESCRIZIONE DELLE ZONE\n\z
    FLORA E FAUNA\n\z
    IL NEGOZIO DEGLI SCAVATORI\n\z
    L'EQUIPAGGIAMENTO DEGLI SCAVATORI\n\z
    LA BANCA DI ZARG\n\z
    LA BORSA DI ZARG\n\z
    STORIA DELLE ATTIVITÀ DI SCAVO SU ZARG",
    H={ { 77,  51, 224, 7,  3 },     -- Chapter 01/11: About this book
        { 77,  62, 224, 7,  8 },     -- Chapter 02/11: How to start Diggers
        { 77,  73, 224, 7, 19 },     -- Chapter 03/11: The Planet Zarg
        { 77,  84, 224, 7, 22 },     -- Chapter 04/11: Race descriptions
        { 77,  95, 224, 7, 34 },     -- Chapter 05/11: Zone descriptions
        { 77, 106, 224, 7, 39 },     -- Chapter 06/11: Flora and fauna
        { 77, 117, 224, 7, 57 },     -- Chapter 07/11: The mining store
        { 77, 128, 224, 7, 59 },     -- Chapter 08/11: Mining apparatus
        { 77, 139, 224, 7, 72 },     -- Chapter 09/11: Zargon bank
        { 77, 150, 224, 7, 76 },     -- Chapter 10/11: Zargon stock market
        { 77, 161, 224, 7, 78 } }    -- Chapter 11/11: Zargon mining history
  -- Page 3 ---------------------------------------------------------------- --
  },{ T="INFORMAZIONI SUL LIBRO\n\z
    \n\z
    Il Libro di Zarg è molto facile da usare. È fatto di una sostanza \z
    rivoluzionaria chiamata TNT che consente di visualizzare le pagine \z
    (vedere TNT). Di conseguenza, è sufficiente che il Libro contenga solo \z
    la copertina, un foglio di TNT e il meccanismo di controllo della TNT \z
    che consiste in 3 smeraldi tagliati e incassati nel dorso del Libro.\n\z
    \n\z
    Il primo smeraldo consente al lettore di consultare l'indice.\n\z
    Il secondo smeraldo consente al lettore di andare alla pagina \z
    successiva.\n\z
    Il terzo smeraldo consente al lettore di tornare alla pagina \z
    precedente."
  -- Page 4 ---------------------------------------------------------------- --
  },{ T="Il lettore potrà andare direttamente alla pagina desiderata \z
    premendo i pulsanti corrispondenti.\n\z
    \n\z
    Per selezionare il capitolo che si vuole leggere basta posizionarsi sul \z
    rispettivo titolo. Ciò consente di accedere alla prima pagina del \z
    capitolo scelto.\n\z
    \n\z
    TNT\n\z
    \n\z
    Il Libro di Zarg è fatto di una sostanza simile alla carta detta TNT \z
    (Transistor Neurali Testurizzati)."
  -- Page 5 ---------------------------------------------------------------- --
  },{ T="Il processo di creazione di tale sostanza è cosi spaventosamente \z
    complicato che può essere compreso appieno solo dagli Slorghi dotati di \z
    tre cervelli che popolano la Grande Casa dei Mille Pensatori Mormoranti \z
    sul pianeta Cerebralis; quindi non verrà tentata qui alcuna spiegazione \z
    in merito. Basti sapere che, comunque venga creata, la TNT ha avuto \z
    effetti impressionanti, o addirittura rivoluzionari, a detta di alcuni \z
    (bisogna riconoscere, però, che vi sono persone, solitamente con la \z
    faccia ricoperta di peli sospetti e con un disco dimostrativo registrato \z
    male in tasca, che vanno in giro raccontando cose strane), su tutti i \z
    tipi di libri.\n\z
    \n\z
    La TNT esercita tre effetti fondamentali facili da spiegare."
  -- Page 6 ---------------------------------------------------------------- --
  },{ T="A. Un foglio di TNT può contenere un numero infinito di parole, il \z
    che consente di ridurre lo spessore dei libri ad un'unica pagina.\n\z
    \n\z
    B. Quando il lettore tocca un foglio di TNT, il suo cervello viene \z
    analizzato per valutarne le capacità elocutorie e di lettura. In una \z
    frazione di nanosecondo, il testo viene presentato nella lingua \z
    preferita del lettore.\n\z
    \n\z
    C. Se viene usato un inchiostro speciale per disegnare su una pagina \z
    alla TNT, quando si apre il libro a tale pagina la figura si muove."
  -- Page 7 ---------------------------------------------------------------- --
  },{ T="Davvero molto appariscente, come rivelano i risultati di un \z
    sondaggio condotto a caso tra i lettori per verificare le reazioni \z
    riguardo alla TNT.\n\z
    \n\z
    \"Una novità priva di senso. Queste maledette figure si muovono in \z
    continuazione. Non avrà alcun successo, torneremo ad usare penna e \z
    calamaio.\"\n\z
    \n\z
    \"È radicale. È, come dire,... rivoluzionario. A proposito, faccio parte \z
    di un gruppo musicale, vuole ascoltare il mio nastro?\""
  -- Page 8 ---------------------------------------------------------------- --
  },{ T="COME AVVIARE DIGGERS\n\z
    \n\z
    L'UFFICIO DEL CONTROLLORE\n\z
    \n\z
    Ogni volta che si inizia un nuovo gioco, si completa un livello o si \z
    termina un gioco già avviato, si ritorna all'Ufficio del Controllore. Il \z
    Controllore richiederà che sia selezionato un livello per dare inizio \z
    alle operazioni di scavo o continuare quelle già intraprese con \z
    successo.\n\z
    \n\z
    Prima di cominciare, si consiglia di leggere le sezioni riguardanti i \z
    diversi tipi di ambienti in cui è possibile trovarsi. Ciò sarà utile per \z
    organizzare gli spostamenti sul pianeta."
  -- Page 9 ---------------------------------------------------------------- --
  },{ T="La prima volta in cui si comincia a giocare, vi saranno solo due \z
    zone disponibili e occorrerà selezionarne una, \"DHOBBS\" o \"AZERG\", \z
    per le operazioni preliminari.\n\z
    Tali zone sono situate nell'angolo superiore sinistro della mappa. Se \z
    uno di tali livelli viene portato a termine con successo, sarà possibile \z
    estendere le operazioni di scavo in una zona adiacente, e iniziare, in \z
    tal modo, a spostarsi sul pianeta.\n\z
    \n\z
    Dopo aver conquistato una zona intera, economicamente o annientando \z
    l'avversario, una bandiera indicante la vittoria sarà innalzata in tale \z
    zona.\n\z
    \n\z
    Dopo aver selezionato la zona desiderata, si ritorna all'Ufficio del \z
    Controllore."
  -- Page 10 --------------------------------------------------------------- --
  },{ T="Se si sta per cominciare un nuovo gioco, il Controllore suggerirà \z
    di scegliere una razza di scavatori in cui investire il proprio denaro.\n\z
    \n\z
    Ogni razza si distingue dalle altre per caratteristiche, obiettivi, \z
    punti di forza e punti deboli. (Consultare il capitolo riguardante le \z
    RAZZE più avanti nel Libro). Si consiglia di studiare le descrizioni \z
    delle razze prima di effettuare la scelta, perché non è consentito \z
    cambiare razza durante il gioco.\n\z
    \n\z
    Nell'area Seleziona Razza, è possibile consultare un riassunto delle \z
    caratteristiche di ogni razza; le pagine contenenti tali informazioni \z
    possono essere girate..."
  -- Page 11 --------------------------------------------------------------- --
  },{ T="...facendo clic nell'angolo destro della pagina. La selezione si \z
    effettua facendo clic in qualsiasi altro punto della pagina.\n\z
    \n\z
    Dopo aver esaminato tali criteri di selezione, si può iniziare il \z
    gioco.\n\z
    \n\z
    LA BANCA\n\z
    \n\z
    La porta sul lato sinistro del corridoio del Centro commerciale di Zarg. \z
    Per una descrizione più dettagliata circa le operazioni bancarie e la \z
    Borsa di Zarg, consultare i capitoli corrispondenti. Ecco, comunque, una \z
    breve spiegazione sul funzionamento del sistema."
  -- Page 12 --------------------------------------------------------------- --
  },{ T="Se nel corso delle operazioni di scavo vengono rinvenuti gioielli o \z
    pietre preziose, è possibile venderli alla Banca. Selezionando l'icona \z
    Casa (vedere sul retro) si ritorna al Centro commerciale.\n\z
    \n\z
    Quando si entra nella Banca per la prima volta, al di sopra di ogni \z
    cassiere saranno indicati le pietre preziose e i gioielli che possono \z
    essere venduti. Se si dispone di gioielli di tale tipo, è possibile \z
    chiedere al cassiere qual è il prezzo di acquisto. Se il prezzo sembra \z
    buono, è possibile vendere i gioielli e il valore corrispondente verrà \z
    accreditato sul proprio Conto Corrente di Cassa."
  -- Page 13 --------------------------------------------------------------- --
  },{ T="Se invece il prezzo non è soddisfacente, o se la Banca non acquista \z
    le pietre di cui si dispone, si può lasciare la Banca e ritornarvi \z
    successivamente per vedere se viene offerto un prezzo migliore o se è \z
    possibile vendere i preziosi.\n\z
    \n\z
    CARICARE & SALVARE\n\z
    \n\z
    Tra due zone distinte, è possibile salvare il gioco o caricarne uno già \z
    cominciato. Ciò si può fare quando ci si trova alla scrivania del \z
    Controllore. Se si seleziona la cassetta della posta in entrata, si ha \z
    la possibilità di salvare il gioco in quel punto o di caricarne uno già \z
    cominciato."
  -- Page 14 --------------------------------------------------------------- --
  },{ T="ICONE DI CONTROLLO\n\z
    \n\z
    \n\z
    Spostamento del personaggio\n\z
    \n\z
    Scavare\n\z
    \n\z
    Casa                                                       \z
    (disponibile solo alla base)\n\z
    \n\z
    STOP\n\z
    \n\z
    Cerca\n\z
    \n\z
    Teletrasporto",
    I={ 1, 184.0, 54.0 }, L=-1.5
  -- Page 15 --------------------------------------------------------------- --
  },{ T="Salta\n\z
    \n\z
    Vai a destra\n\z
    \n\z
    Aspetta\n\z
    \n\z
    Corri a sinistra\n\z
    \n\z
    STOP\n\z
    \n\z
    Corri a destra\n\z
    \n\z
    Torna al menu principle\n\z
    \n\z
    Vai a sinistra",
    I={ 2, 164.0, 24.0 }, L=-1.5
  -- Page 16 --------------------------------------------------------------- --
  },{ T="\n\z
    Istruzioni di scavo\n\z
    \n\z
    \n\z
    Raccogli\n\z
    \n\z
    \n\z
    Posa e registra nell'inventario\n\z
    \n\z
    \n\z
    Cerca\n\z
    \n\z
    \n\z
    Spostati tra i telepali",
    I={ 3, 164.0, 24.0 }, L=-0.75
  -- Page 17 --------------------------------------------------------------- --
  },{ T="                           FINESTRA DI CONTROLLO\n\z
        Conto di cassa                Pietre preziose raccolte\n\z
    \n\z
    \n\z
    \n\z
    ¶                    Resistenza             Chi sta vincendo\n\z
    ¶                           (La bandiera verde rappresenta il computer.\n\z
    ¶                                La bandiera rosa rappresenta l'utente)\n\z
    Condizione dei singoli scavatori\n\z
    ¶     Pericolo OK Annoiato Noia Morto\n\z
    ¶                                    \z
    ¶           Stato scavatori   Libro elettronico\n\z
    \n\z
    \n\z
    ¶                                                                        \z
    ¶                  Posizione\n\z
    Scavatore selezionato  Selezione della macchina        scavatori",
    I={ 4, 96.0, 51.0 }, L=-0.75
  -- Page 18 --------------------------------------------------------------- --
  },{ T="DESCRIZIONE DELLE CARATTERISTICHE DELLE RAZZE\n\z
    \n\z
    Resistenza                              Aggressività\n\z
    \n\z
    Forza                                        Poteri speciali\n\z
    \n\z
    Pazienza                                   Potere di teletrasporto\n\z
    ¶                                                         (solo gli \z
    Habbish)\n\z
    Volocità di scavo\n\z
    \n\z
    Intelligenza                             Velocità di guarigione\n\z
    ¶                                                  doppia (solo i Fitarg)",
  I={ 5, 140.0, 44.0 }, L=-1.5
  -- Page 19 --------------------------------------------------------------- --
  },{ T="IL PIANETA ZARG\n\z
    \n\z
    Vi sono molte leggende sulla ricchezza mineraria del pianeta Zarg. Il \z
    sottosuolo abbonda di minerali e pietre preziose, quali diamanti, \z
    rubini, smeraldi e oro, ma la devastante attività vulcanica che generò \z
    tale ricchezza, diede origine anche ad una grande quantità di pericoli e \z
    insidie. Di conseguenza, scavare sul pianeta Zarg comporta enormi \z
    rischi. I primi cercatori, spinti da cartelloni pubblicitari spaziali \z
    su cui compariva la scritta 'qui abbondanza di tesori', perirono a \z
    migliaia.",
  -- Page 20 --------------------------------------------------------------- --
  },{ T="Un altro pericolo che i cercatori dovevano affrontare erano le \z
    lotte tra razze rivali di scavatori e l'anarchia generale che regnava \z
    sul pianeta. Inoltre, le numerose operazioni di scavo non controllate \z
    stavano danneggiando la stabilità del sottosuolo e voragini enormi si \z
    formavano all'improvviso.\n\z
    \n\z
    Le autorità del pianeta decisero di adottare provvedimenti al fine di \z
    risolvere tali problemi. Venne consentito di scavare solo un mese \z
    all'anno, a cominciare dal giorno 412. Per i restanti 17 mesi, le \z
    operazioni di scavo erano vietate."
  -- Page 21 --------------------------------------------------------------- --
  },{ T="Le autorità, oltre ad adottare la legge del mitico 412, regolarono \z
    e formalizzarono le procedure di scavo sul pianeta. Le seguenti regole \z
    sono ora in vigore:\n\z
    \n\z
    1. Solo cinque razze di scavatori sono autorizzate a scavare sul \z
       pianeta.\n\z
    2. Ogni scavo deve essere registrato presso il Centro commerciale \z
       minerario di Zarg.\n\z
    3. Tutti i minerali dissotterrati devono essere venduti alla banca di \z
       Zarg.\n\z
    4. Allo scopo di promuovere una sana concorrenza, due razze di scavatori \z
       sono autorizzate a scavare in ogni area del pianeta."
  -- Page 22 --------------------------------------------------------------- --
  },{ T="DESCRIZIONE DELLE RAZZE\n\z
    \n\z
    HABBISH...\n\z
    \n\z
    Si tratta di una razza enigmatica\n\z
    ed introversa i cui componenti \n\z
    pare siano assai intelligenti; si\n\z
    dice che abbiano sviluppato poteri\n\z
    speciali di transporto via telpalo.\n\z
    Queste creature incappucciate sono\n\z
    la razza più debole e benché siano in grado di scavare a lungo, sono assai \z
    impazienti e si stufano rapidamente di scavare preferendo, non appena \z
    possibile, rubacchiare i preziosi rinvenuti da altri.",
    I={ 6, 210.0, 36.0 }
  -- Page 23 --------------------------------------------------------------- --
  },{ T="Gli Habbish rappresentano un ordine mistico guidato dal Capo \z
    Supremo di nome Habborg, un esaltato che ha ordinato ai suoi seguaci di \z
    costruire in suo onore un tempio favoloso, costellato di oro e pietre \z
    preziose. Gli Habbish hanno iniziato i lavori, ma il denaro sta per \z
    venire meno. Devono trovare più pietre preziose possibile per portare a \z
    termine la costruzione del tempio e ripagare il loro creditore \z
    galattico, il terribile Thungurs che brandisce la mazza da baseball."
  -- Page 24 --------------------------------------------------------------- --
  },{ T="Gli Habbish osservano un calendario assai particolare e in alcuni \z
    momenti imprevedibili e spesso assai inopportuni, interrompono qualsiasi \z
    attività per raccogliersi in cerchio e intonare inni in onore del Capo \z
    Supremo Habborg. Si demoralizzano facilmente se gli scavi non fruttano e \z
    si inchinano dinanzi al loro capo implorando perdono quando non trovano \z
    pietre preziose."
  -- Page 25 --------------------------------------------------------------- --
  },{ T="GRABLIN...\n\z
    \n\z
    Si tratta di una razza nata per\n\z
    scavare. Sono in grado di scavare\n\z
    molto velocemente e a lungo, senza\n\z
    mai fermarsi. La loro corporatura\n\z
    minuta li rende molto agili \n\z
    all'interno delle miniere,\n\z
    consentendo loro di penetrare in\n\z
    passaggi assai stretti e lavorare in tunnel molto bassi. Per quanto \z
    forti, non sono ottimi lottatori e possono facilmente essere sconfitti \z
    dal Quarrior.",
    I={ 7, 200.0, 24.0 }
  -- Page 26 --------------------------------------------------------------- --
  },{ T="L'unica debolezza dei Grablin è il fatto che non possono rinunciare \z
    ad una bevanda micidiale chiamata Grok.\n\z
    Benché si dica che abbia un \"sapore disgustoso\" e un odore \"peggiore \z
    di quello dell'alito dello Scabrosauro sputafuoco che vive negli stagni \z
    di viscidume vorticoso di Sulfuria\" e che sarebbe \"più utile come \z
    scudo di difesa contro un attacco termonucleare che come bevanda\", i \z
    Grablin non possono farne a meno."
  -- Page 27 --------------------------------------------------------------- --
  },{ T="Purtroppo, dal momento che gli ingredienti che compongono il Grok \z
    (troppo disgustosi per essere menzionati) sono estremamente costosi, i \z
    Grablin hanno costantemente bisogno di soldi. Il loro fine ultimo è di \z
    accumulare abbastanza ricchezza per costruire una distilleria propria. \z
    Tuttavia, dati gli sgradevoli effetti collaterali derivanti dalla \z
    distillazione della bevanda, dovranno prima acquistare un pianeta \z
    deserto su cui costruire la distilleria."
  -- Page 28 --------------------------------------------------------------- --
  },{ T="QUARRIOR...\n\z
    \n\z
    Si tratta di una razza bellicosa\n\z
    paragonabile a veri diamanti grezzi.\n\z
    I Quarrior iniziarono a cercare\n\z
    minerali nelle cave di pietre prima di\n\z
    intraprendere scavi nelle minere e in\n\z
    superficie.\n\z
    \n\z
    I Quarrior, che sono la razza più forte, sono anche sabotatori provetti \z
    e molto esperti nell'uso della dinamite. Tuttavia, non si sono ancora \z
    abituati alle scomode condizioni di lavoro; si affaticano rapidamente e \z
    scavano lentamente. Sono estremamente fidati e pazienti, ma privi di \z
    iniziativa.",
    I={ 8, 210.0, 32.0 }
  -- Page 29 --------------------------------------------------------------- --
  },{ T="I Quarrior sono completamente al verde, poiché sono stati \z
    recentemente truffati da un venditore di armi di seconda mano. La loro \z
    ambizione consiste nel costruire un accampamento fortificato in cui \z
    possano allenarsi nel tiro e migliorare la loro capacità di scavare, al \z
    sicuro dai nemici."
  -- Page 30 --------------------------------------------------------------- --
  },{ T="FITARG...\n\z
    \n\z
    Si tratta di una razza di agili\n\z
    scavatori estremamente curiosi e\n\z
    collezionisti di pezzi di metallo.\n\z
    Hanno un desiderio insaziabile di\n\z
    costruire oggetti con i rottami che\n\z
    raccolgono in continuazione. Di\n\z
    conseguenza, le loro construzioni e\n\z
    macchine sono tutte rattoppate e\n\z
    dalla linea non ben definita.",
    I={ 9, 210.0, 20.0 }
  -- Page 31 --------------------------------------------------------------- --
  },{ T="I Fitarg sono gli scavatori più veloci dopo i Grablin, ma sono in \z
    grado di scavare più a lungo di tutti gli altri. Scavano volentieri, ma \z
    vengono facilmente distratti da oggetti in grado di attirare la loro \z
    attenzione. Al di fuori delle minere, si cacciano spesso nei guai a \z
    causa del loro desiderio di collezionare. Non sono particolarmente \z
    aggressivi né capaci di lottare, ma se vengono feriti impiegano la metà \z
    del tempo a guarire rispetto a tutti gli altri.\n\z
    \n\z
    L'ambizione dei Fitarg consiste nell'accumulare abbastanza denaro per \z
    costruire il Museo delle Meraviglie di Metallo (soprannominato \z
    malignamente il Rottamaio), in cui intendono conservare rottami storici \z
    e sculture di natura insolita e istruttiva."
  -- Page 32 --------------------------------------------------------------- --
  },{ T="FLIMMER...\n\z
    \n\z
    Rimangono pochissimi segni di questa razza di scavatori \z
    timidi e amanti della pace che scomparve senza lasciare traccia dalla \z
    faccia del pianeta. Ricordati come i migliori scavatori in assoluto, si \z
    narra che i Flimmer abbiano deciso di smettere di scavare dopo che il \z
    loro entusiasmo per tale attività si spense in seguito ad una stagione \z
    particolarmente estenuante. Dopo essersi recati per l'ultima volta alla \z
    Banca di Zarg, dove rinunciarono a tutti i beni terreni, e dopo aver \z
    gettato i loro averi oltre il bancone, provocando una corsa ai diamanti \z
    che sconvolse il mercato galattico, si dispersero per il pianeta ... e \z
    scomparvero."
  -- Page 33 --------------------------------------------------------------- --
  },{ T="Dove si trovino attualmente i Flimmer rimane un mistero, benché i \z
    vecchi racconti dei minatori narrino di sguardi fugaci di timide \z
    creature che assomigliano ai Flimmer. Molte di tali storie sono frutto \z
    di dosi eccessive di Grok, ma si crede ancora che in un angolo remoto \z
    del pianeta, molti metri al di sotto della superficie, vivano i \z
    discendenti di tali scavatori. Si consiglia di tenere gli occhi ben \z
    aperti scavando. Chissà, quell'ombra fugace, quello sguardo appena \z
    intravisto in un tunnel buio, sarà forse un Flimmer?"
  -- Page 34 --------------------------------------------------------------- --
  },{ T="DESCRIZIONE DELLE ZONE\n\z
    \n\z
    Prateria - Zona pianeggiante con fiumi che solcano i prati verdeggianti. \z
    Nel sottosuolo vi sono altri fiumi, caverne e piccole quantità di rocce \z
    impenetrabili. Studi recenti hanno rivelato la presenza di resti \z
    fossilizzati di grandi creature di origine sconosciuta.\n\z
    \n\z
    Foresta/Giungla - Zona prevalentemente pianeggiante caratterizzata da \z
    fiumi sinuosi e piccoli laghi. Il suolo è molto fertile e consente la \z
    crescita di alberi giganteschi e altissimi. Le radici di tali alberi \z
    raggiungono lunghezze eccezionali e penetrano in profondità."
  -- Page 35 --------------------------------------------------------------- --
  },{ T="Una volta che tali radici sono cresciute le une intorno alle altre, \z
    formano spessi grovigli che è impossibile rimuovere o penetrare \z
    scavando.\n\z
    \n\z
    Le bocche delle miniere dovrebbero essere situate in punti abbastanzi \z
    lontani dagli alberi in modo da evitare di incontrare tall radici. In \z
    questa zona abbondano strane storie riguardanti la vita delle piante, ma \z
    non sono ancora state trovate prove che ne confermino l'autenticità.\n\z
    \n\z
    Deserto Arida - Zona di Zarg caratterizzata da sabbie mobili e dune. \z
    Sono evidenti gli effetti dell'erosione. Enormi formazioni rocciose sono \z
    state sepolte dalla sabbia e compresse in modo da formare terreni \z
    impervi."
  -- Page 36 --------------------------------------------------------------- --
  },{ T="Al di sotto della sabbia si estendono enormi strutture cristalline \z
    dal colori brillianti. Esistono anche laghi e sorgenti d'acqua \z
    sotterranei.\n\z
    \n\z
    Ghiacci - Zona freddissima caratterizzata da mari glaciali costellati da \z
    iceberg. Occorre essere estremamente prudenti quando si scava a tali \z
    livelli a causa del pericolo di inondazioni, specialmente in presenza di \z
    iceberg.\n\z
    \n\z
    Isole - Zona formata da un vasto arcipelago di isole che circondano un \z
    grande oceano. Tutte le isole si congiungono nelle profondità marine per \z
    formare un'enorme catena montuosa sottomarina."
  -- Page 37 --------------------------------------------------------------- --
  },{ T="Montagne - Zona caratterizzata da cime frastagliate e pendii \z
    rocciosi poco sicuri che offrono scarsi spazi adatti per scavare. \z
    Tuttavia, trale montagne vi sono ampie grotte che offrono opportunità \z
    migliori.\n\z
    \n\z
    Al di sotto della superficie rocciosa vi sono depositi di pietre dure \z
    che rendono gli scavi impossibili in alcune zone. È anche possibile \z
    trovare sorgenti d'acqua sotterranee.\n\z
    \n\z
    Terreno roccioso - Zona che assomiglia al Grand Canyon, caratterizzata \z
    da numerosi strapiombi, precipizi e formazioni rocciose precarie. Al di \z
    sotto della superficie vi sono vaste aree di roccia impenetrabile."
  -- Page 38 --------------------------------------------------------------- --
  },{ T="In prossimità della superficie l'acqua scarseggia, ma più in \z
    profondità abbondano caverne ricche d'acqua. I corsi di fiumi \z
    prosciugati da lungo tempo hanno creato una serie di grotte e passaggi \z
    tra i vari strati di roccia. Si crede che in tale livello vi siano città \z
    perdute, forse abitate dai fantasmi dei precedenti occupanti."
  -- Page 39 --------------------------------------------------------------- --
  },{ T="FLORA E FAUNA\n\z
    \n\z
    In seguito alla scomparsa dell'intera spedizione del '95, guidata da \z
    Frinklin, gli studi antropologici e botanici sul pianeta Zarg sono \z
    stati, purtroppo, interrotti. Di conseguenza, non esistono resoconti \z
    esaurienti circa la flora e la fauna di Zarg (gli appunti e le \z
    fotografie che seguono sono il frutto di resoconti di professionisti e \z
    di testimonianze raccolte) e sicuramente esistono altre specie animali e \z
    vegetali sul pianeta. Chiunque disponesse di ulteriori informazioni è \z
    pregato di scrivere al Professor S. Trepitoso, Torre dei Rampicanti, \z
    Istituto di Vegetazione Galattica di Angelpiero."
  -- Page 40 --------------------------------------------------------------- --
  },{ T="Triffidus Carnivorus...\n\z
    \n\z
    Vive nella giungla e nelle foreste\n\z
    dove cresce in mezzo ad altri alberi\n\z
    e piante.\n\z
    \n\z
    Pianta carnivora pericolosissima,\n\z
    dall'appetito insaziabile. Èfacilmente\n\z
    riconoscibile per l'insolito colore delle foglie.\n\z
    \n\z
    Dopo essere stato catturato ed esaminato mediante raggi infrarossi, lo \z
    stomaco di un esemplare rivelò contenere la guida di un principiante e \z
    un paio di occhiali simili a quelli del Dr. Frinklin.",
    I={ 10, 200.0, 15.0 }
  -- Page 41 --------------------------------------------------------------- --
  },{ T="Fungus Caleidoscopus...\n\z
    \n\z
    Questi funghi, che possono essere\n\z
    trovati in superficie in diversi\n\z
    luoghi, crescono in grossi grappoli.\n\z
    Sono facilmente individuabili a causa\n\z
    della grande cappella rossa a punti\n\z
    bianchi.\n\z
    \n\z
    I risultati di uno studio scientifico hanno dimostrato che gli effetti \z
    provocati dall'ingestione di tale fungo possono variare da individuo a \z
    individuo. Alcuni muoiono semplicemente, altri raddoppiano la propria \z
    forza, mentre altri ancora sembrano frastornati e parlano confusamente \z
    di giraffe rosa.",
    I={ 11, 200.0, 32.0 }
  -- Page 42 --------------------------------------------------------------- --
  },{ T="Stegosauro...\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Grande dinosauro che vive in caverne sotterranee. È dotato di pelle \z
    color sabbia e di due corni. Di indole generalmente docile, gli \z
    stegosauri attaccano se provocati o se si sentono in pericolo. Nei \z
    tunnel stretti, lo stegosauro è in grado di annientare i nemici.",
    I={ 12, 96.0, 15.0 }
  -- Page 43 --------------------------------------------------------------- --
  },{ T="Rotorisauro...\n\z
    \n\z
    Particolare tipo di dinosauro che vive nei livelli sotterranei, ma che \z
    di tanto in tanto vaga sulla superficie del pianeta. Benché sia \z
    generalmente piuttosto mansueto, se provocato o aggredito è in grado di \z
    infliggere gravi danni agli aggressori.\n\z
    \n\z
    Velocirapitor...\n\z
    \n\z
    Dinosauro sorprendentemente feroce che attacca anche senza essere \z
    provocato. Detesta la vista di quasi ogni altra creatura e, nonostante \z
    non raggiunga dimensioni imponenti, è in grado di colpire con la forza \z
    di uno stegosauro."
  -- Page 44 --------------------------------------------------------------- --
  },{ T="Occorre evitarlo ad ogni costo. Se lo si incontra, è opportuno \z
    scappare il più velocemente possibile o attirarlo verso le miniere degli \z
    avversari e fuggire."
  -- Page 45 --------------------------------------------------------------- --
  },{ T="Ovus Horribilis...\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Di origine sconosciuta. Le uniche notizie che se ne hanno sono state \z
    fornite da un minatore, ora in pensione. Ecco il suo resoconto:",
    I={ 13, 96.0, 32.0 }
  -- Page 46 --------------------------------------------------------------- --
  },{ T="\"È stato terrificante. Il Capo ci aveva detto di scavare in quel \z
    pezzo di roccia. Ebbene, non mi vergogno a dirlo, non mi piaceva neanche \z
    un po'. C'era qualcosa di strano, sapete... Comunque, cominciammo a \z
    scavare e ci ritrovammo all'interno di una caverna. Mi guardai intorno \z
    facendo luce con la torcia, ma sembrava vuota. \"Andiamo, Bolbo\", \z
    dissi. \"Beviamoci un sorso di Grok\". Ma lui non venne, aveva visto \z
    quell'uovo orribile. \"Lascialo stare\", gli dissi, ma non mi diede \z
    retta. Lo tirò su e quell'essere gli saltò addosso, ooh che cosa \z
    spaventosa, e lo assorbì dentro di sè. Non avevo il coraggio di \z
    guardare. Mi voltai e corsi via. Fu una cosa tremenda, dov'è quella \z
    bottiglia..?\""
  -- Page 47 --------------------------------------------------------------- --
  },{ T="Mammiferi lanuti...\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Grandi mammiferi che si ritiene vivessero su Zarg circa un milione di \z
    anni fa. I resti congelati di un esemplare sono stati ritrovati un anno \z
    fa e altri potrebbero essere rinvenuti allo stato fossile nelle zone dei \z
    ghiacci.",
    I={ 14, 96.0, 32.0 }
  -- Page 48 --------------------------------------------------------------- --
  },{ T="La carne dei mammiferi lanuti è stata mangiata dagli esploratori \z
    della regione Artica in preda alla fame:\n\z
    \n\z
    \"Mnmn, un attimo solo ... che smetto di mnmnmn... masticare...\"\n\z
    \"Penso che il vegetarianismo stia per acquisire un nuovo seguace.\"\n\z
    \"Hommm, hommm, Capo Habborg, hommm, hommm.\""
  -- Page 49 --------------------------------------------------------------- --
  },{ T="Pesci...\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Si crede che esistano molte specie di pesci. Tuttavia, le storie dei \z
    pescatori non sembrano corrispondere alla realtà. Ben pochi esemplari \z
    sono stati portati all'istituto ed è stato impossibile fare stime \z
    accurate delle dimensioni di tali animali.",
    I={ 15, 96.0, 15.0 }
  -- Page 50 --------------------------------------------------------------- --
  },{ T="Anche quanto si narra a proposito del feroce \"picosauro\" deve \z
    essere preso con le molle (forse coltello e forchetta sarebbero più \z
    comodi)."
  -- Page 51 --------------------------------------------------------------- --
  },{ T="Lombrichi di terra...\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Grossi animali di genere oscuro. Si pensa che tali creature timide \z
    vivano nelle profondità del pianeta: è possibile verdele solo di rado e \z
    non si conosce granchè circa il loro comportamento. Qui di seguito è \z
    riportato il resoconto di un Quarrior che ha avuto occasione di \z
    incontrare un lombrico di terra.",
    I={ 16, 128.0, 20.0 }
  -- Page 52 --------------------------------------------------------------- --
  },{ T="\"Ci stavamo occupando del nostro lavoro, scavando senza far rumore \z
    (beh, per quanto ciò sia possibile quando si usa la dinamite), e \z
    all'improvviso la terra iniziò a spostarsi sotto ai nostri piedi. Devo \z
    confessare che, per un attimo, mi sentii confuso; ebbi appena il tempo \z
    di pesare prima di cadere all'indietro e battere la testa. Per fortuna, \z
    ciò sembrò essere di aiuto mi resi conto che che si trattava di uno di \z
    quegli ernomi vermi. Sia chiaro che non avevo paura; afferrai una pala e \z
    stavo per affrontarlo... 'Avanti', lo incitai, ma strisciò via verso il \z
    tunnel e scomparve. Comunque, penso siano dei gran fifoni...\""
  -- Page 53 --------------------------------------------------------------- --
  },{ T="Avvistamenti misteriosi!\n\z
    \n\z
    Nel corso degli anni, sono circolate voci circa strani esseri eterei che \z
    popolano le grotte nelle viscere del pianeta Zarg. I minatori che sono \z
    riusciti a risalire in superficie e che hanno avuto modo di raccontare \z
    le loro storie, parlano di fantomatiche apparizioni che si muovevano \z
    lentamente attaccando il gruppo e uccidendo gli uomini. Altri racconti \z
    narrano di creature simili a scavatori dai movimenti rapidissimi che \z
    piombavano giò dai soffitti di grandi grotte e uccidevano con destrezza. \z
    Secondo le storie che vengono raccontate nel numerosi bar del pianeta, \z
    si tratta dei fantasmi dei minatori che furono lasciati morire, mentre \z
    gli Zombi sono li risultato..."
  -- Page 54 --------------------------------------------------------------- --
  },{ T="...dei contatti avvenuti fra tali fantasmi e scavatori viventi. È \z
    consigliabile evitare ad ogni costo tali presunte apparizioni. Capite \z
    bene che le autorità non possono permettersi di credere a certe cose.\n\z
    \n\z
    Altre strane presunte apparizioni riguardano piccole creature che \z
    sembrano provenire da un altro pianeta, e che forse sono connesse con \z
    l'Ovus Horribilis. Gli avvistamenti di tali creature non hanno ancora \z
    avuto conferma, dal momento che tutte le spedizioni scientifiche \z
    intraprese in merito sono fallite. Tali creature potrebbero essere \z
    pericolose!"
  -- Page 55 --------------------------------------------------------------- --
  },{ T="Sparpagliati su tutto il pianeta vi sono dei portali mobili, \z
    soprannominati Vortiporte. Tali oggetti curiosi galleggiano dolcemente \z
    nel mondo sotterraneo. Se uno scavatore viene raccolto da uno di questi, \z
    viene immediatamente trasportato in un'area qualsiasi della zona. I \z
    fanatici religiosi della razza degli Habbish sono convinti che le \z
    Vortiporte siano i resti spirituali deoli Habbish che non hanno ottenuto \z
    la piena redenzione e che sono destinati a vagare per il pianeta Zarg in \z
    tale condizione. Altri scavatori non particolarmente interessati alle \z
    questioni spirituali ritengono si tratti semplicemente di una delle \z
    numerose stranezze del pianeta e non si preoccupano di trovare una \z
    spiegazione in merito. Riteniamo che questo secondo punto di vista sia \z
    molto più sensato."
  -- Page 56 --------------------------------------------------------------- --
  },{ T="Vaste aree del pianeta non sono ancora state esplorate, e per tale \z
    motivo le informazioni succitate non sono altro che conoscenze comuni. \z
    Quindi prestate attenzione perché c'è sempre qualcosa di nuovo da \z
    scoprire."
  -- Page 57 --------------------------------------------------------------- --
  },{ T="IL NEGOZIO DEGLI SCAVATORI\n\z
    \n\z
    Nel negozio degli scavatori è possibile trovare un'ampia gamma di \z
    equipaggiamenti. Tutti gli articoli sono stati scelti da uno scavatore \z
    veterano con una conoscenza dettagliata delle pericolose condizioni di \z
    lavoro sotterranee. Buona parte di tali equipaggiamenti è stata \z
    acquistata a prezzi stracciati ad una grande svendita tenutasi in un \z
    piccolo angolo del pianeta Terra chiamato GranBretagna, in cul le minere \z
    rappresentano ormai un lontano ricordo.\n\z
    \n\z
    Quando si entra nel negozio, l'affabile commesso è più che felice di \z
    assistere l'acquirente nella scelta."
  -- Page 58 --------------------------------------------------------------- --
  },{ T="Il suo listino contiene i prezzi e le descrizioni di tutti gli \z
    equipaggiamenti disponibili in magazzino. Un ologramma di ogni articolo \z
    appare automaticamente per permettere al cliente di vedere esattamente \z
    di cosa si tratta prima di concludere l'acquisto.\n\z
    \n\z
    Per scegliere un articolo, fare clic sul simbolo corrispondente e il \z
    prezzo sarà automaticamente addebitato sul conto di cassa.\n\z
    \n\z
    i. Le condizioni economiche possono provocare variazioni di prezzi in \z
    base alla disponibilità dei prodotti.\n\z
    ii. La Direzione si riserva il diritto di apportare qualsiasi modifica \z
    in qualsiasi momento senza preavviso."
  -- Page 59 --------------------------------------------------------------- --
  },{ T="L'EQUIPAGGIAMENTO DEGLI SCAVATORI\n\z
    \n\z
    Barriere contro le inondazioni...\n\z
    \n\z
    Prezzo: 80 crediti. Peso: 10 gronde.\n\z
    \n\z
    Informazioni generali: Le barriere contro le inondazioni possono essere \z
    aperte e chiuse solo da chi le ha installate. Sono estremamente utili \z
    nelle zone in cui vi è pericolo di inondazioni improvvise. Possono \z
    essere utilizzate per proteggere le operazioni di scavo dagli avversari. \z
    Tali barriere sono molto resistenti alla pressione e in grado di \z
    tollerare gran parte dei macchinari di scavo, ma e possibile farle \z
    saltare con grandi quantità di esplosivo.",
    I={ 17, 224.0, 40.0 }
  -- Page 60 --------------------------------------------------------------- --
  },{ T="Telepalo...\n\z
    \n\z
    \n\z
    Prezzo: 260 crediti.\n\z
    Peso: 12 gronde.\n\z
    \n\z
    Informazioni generali: Si tratta forse dell'articolo più importante \z
    dell'equipaggiamento di uno scavatore. Il telepalo consente agli utenti \z
    di spostarsi istantaneamente da un telepalo all'altro. All'inizio delle \z
    operazioni di scavo, a ciascuna razza di scavatori viene fornito un \z
    sistema di teletrasporto. Gli Habbish possono utilizzare i telepali di \z
    tutti gli altri scavatori, mentre le altre razze possono utilizzare \z
    esclusivamente i propri.",
    I={ 18, 196.0, 29.0 }
  -- Page 61 --------------------------------------------------------------- --
  },{ T="Rotaie...\n\z
    \n\z
    \n\z
    \n\z
    Prezzo: 10 crediti.\n\z
    Peso: 3 gronde.\n\z
    \n\z
    Informazioni generali: Le singole porzioni di rotaie sono piuttosto \z
    corte, ma sono vendute in gruppi di cinque. Il peso succitato si \z
    riferisce ad un gruppo di cinque. Le rotaie devono essere collocate \z
    correttamente. Dopo che sono state situate in una data posizione, \z
    formano un legame permanente con il terreno e non possono più essere \z
    spostate, né è possibile scavare in mezzo ad esse.",
    I={ 19, 196.0, 29.0 }
  -- Page 62 --------------------------------------------------------------- --
  },{ T="Locomotore automatico...\n\z
    \n\z
    \n\z
    \n\z
    Prezzo: 100 crediti.\n\z
    Peso: 9 gronde.\n\z
    \n\z
    Informazioni generali: Sofisticato locomotore semovente dotato di \z
    controllo automatico dello sterzo. In grado di contenere grandi quantità \z
    di scavatori o minerali da un luogo all'altro.",
    I={ 20, 196.0, 29.0 }
  -- Page 63 --------------------------------------------------------------- --
  },{ T="Piccola scavatrice...\n\z
    \n\z
    \n\z
    \n\z
    Prezzo: 150 crediti.\n\z
    Peso: 8 gronde.\n\z
    \n\z
    Informazioni generali: Macchina priva di cavo elettrico usata per \z
    scavere gallerie. Soprannominata 'la talpa', è leggera e può essere \z
    transportata a mano. Scava ad una velocità assai maggiore rispetto al \z
    più veloce scavatore dotato di punta a lancia.",
    I={ 21, 196.0, 29.0 }
  -- Page 64 --------------------------------------------------------------- --
  },{ T="Pezzo di ponte...\n\z
    \n\z
    \n\z
    \n\z
    Prezzo: 25 crediti.\n\z
    Peso: 3 gronde.\n\z
    \n\z
    Informazioni generali: Articolo dal valore inestimabile per costruire \z
    ponte su torrenti e fiumi. Molto resistente, è in grado di sorreggere \z
    pesi notevoli. I pezzi di ponte devono essere fissati saldamente su un \z
    terreno sicuro. I ponti sono bersagli vulnerabili; occorre quindi essere \z
    molto prudenti quando li si attraversa.",
    I={ 22, 196.0, 29.0 }
  -- Page 65 --------------------------------------------------------------- --
  },{ T="Imbarcazione pneumatica...\n\z
    \n\z
    \n\z
    \n\z
    Prezzo: 60 crediti.\n\z
    Peso: 5 gronde.\n\z
    \n\z
    Informazioni generali: Imbarcazioni molto resistenti. Possono \z
    trasportare un solo scavatore alla volta. Non adatte per navigare in \z
    mare aperto o per lunghe traversate.",
    I={ 23, 196.0, 29.0 }
  -- Page 66 --------------------------------------------------------------- --
  },{ T="Scavatore verticale...\n\z
    \n\z
    \n\z
    \n\z
    Prezzo: 170 crediti.\n\z
    Peso: 10 gronde.\n\z
    \n\z
    Informazioni generali: Soprannominato 'il cavatappi' per la sua azione \z
    di scavo. Tale macchina può essere usata solo per scavere in senso \z
    verticale. Una volta avviato, il 'cavatappi' continua a scavere \z
    automaticamente per un periodo di tempo prestabilito o fino a quando non \z
    incontra un ostacolo. Prestare molta attenzione se si utilizza tale \z
    congegno in zone con presenza di acqua.",
    I={ 24, 196.0, 29.0 }
  -- Page 67 --------------------------------------------------------------- --
  },{ T="Grande scavatrice...\n\z
    \n\z
    \n\z
    \n\z
    Prezzo: 230 crediti.\n\z
    Peso: 11 gronde.\n\z
    \n\z
    Informazioni generali: Meglio conosciuta come il 'Mostro', tale macchina \z
    è una scavatrice formidabile. È in grado di scavare molto rapidamente \z
    tra le rocce. Quando si utilizza il 'Mostro' occorre essere estremamente \z
    prudenti. Mirare la superficie da forare e avviare il motore. Non \z
    sostare mai davanti al 'Mostro'. Questa macchina può solo scavare in \z
    avanti.",
    I={ 25, 196.0, 29.0 }
  -- Page 68 --------------------------------------------------------------- --
  },{ T="Esplosivi...\n\z
    \n\z
    \n\z
    \n\z
    Prezzo: 20 crediti.\n\z
    Peso: 4 gronde.\n\z
    \n\z
    Informazioni generali: ATTENZIONE: maneggiare con cura. Equipaggiamento \z
    essenziale per far esplodere rocce impenetrabili o per entrare in una \z
    miniera avversaria. Quando si usano esplosivi, il margine di errore \z
    concesso è assai limitato; gli sbagli sono spesso fatali!",
    I={ 26, 196.0, 29.0 }
  -- Page 69 --------------------------------------------------------------- --
  },{ T="Montacarichi...\n\z
    \n\z
    \n\z
    Prezzo: 220 crediti.\n\z
    Peso: 12 gronde.\n\z
    \n\z
    Informazioni generali: Molto utile per trasportare grandi quantità di \z
    minerali, equipaggiamenti o scavatori da un livello completato con \z
    successo all'ingresso della miniera. Una volta installato, il \z
    montacarichi non può più essere spostato. Il montacarichi deve essere \z
    installato correttamente: l'estremità superiore e l'estremità inferiore \z
    DEVONO essere fissate saldamente ad una porzione di terreno adatto, \z
    altrimenti il montacarichi non può funzionare.",
    I={ 27, 196.0, 29.0 }
  -- Page 70 --------------------------------------------------------------- --
  },{ T="Mappa alla TNT...\n\z
    \n\z
    \n\z
    \n\z
    Prezzo: 215 crediti.\n\z
    Peso: 3 gronde.\n\z
    \n\z
    Informazioni generali: Probabilmente l'articolo più utile di cui uno \z
    scavatore possa disporre, a parte la guida! Sfruttando i poteri speciali \z
    della carta alla TNT, tale mappa mostra l'intera zona con tutte le \z
    rispettive caratteristiche ed è costantemente aggiornata.",
    I={ 28, 196.0, 29.0 }
  -- Page 71 --------------------------------------------------------------- --
  },{ T="Kit di pronto soccorso...\n\z
    \n\z
    \n\z
    \n\z
    Prezzo: 60 crediti.\n\z
    Peso: 5 gronde.\n\z
    \n\z
    Informazioni generali: una volta acquistato, i poteri taumaturgici del \z
    kit reintegreranno lentamente le energie del minatore che lo tiene tra \z
    le mani. È possibile passare il kit ad un altro minatore, che può \z
    beneficiare dell'eventuale \"medicina\" rimasta.",
    I={ 29, 196.0, 29.0 }
  -- Page 72 --------------------------------------------------------------- --
  },{ T="LA BANCA DI ZARG\n\z
    \n\z
    Rafforzatasi di recente grazie alla fusione con la Banca di \z
    Cattivilandia, la Banca di Zarg ha aumentato le operazioni disponibili, \z
    introducendo anche operazioni di borsa. Esercita ora il controllo su \z
    tutte le transazioni monetarie del pianeta e ha elaborato un programma \z
    di risparmio per tutti i suoi clienti. La caratteristica leggermente \z
    insolita di tale programma consiste nel fatto che è obbligatorio.\n\z
    \n\z
    Quando uno scavatore apre un conto corrente di cassa, la banca apre un \z
    conto di risparmio a nome di tale cliente. Quindi trasferisce \z
    automaticamente una percentuale del denaro presente sul conto di cassa \z
    sul conto di risparmio."
  -- Page 73 --------------------------------------------------------------- --
  },{ T="Il denaro presente sul conto di risparmio non potrà essere \z
    prelevato fino a quando uno scavatore non decide or lasciare il \z
    planeta.\n\z
    \n\z
    Come spiega un portavoce della Banca: \"Si tratta di una misura di \z
    sicurezza contro i clienti che fuggono dal pianeta lasciandoci i debiti \z
    da pagare\".\n\z
    \n\z
    Quando viene intrapresa un'attività di scavo, la Banca è generalmente \z
    disposta a concedere allo Scavatore Capo un prestito di 100 crediti. \z
    Tuttavia, lo Scavatore Capo deve ripagare tale prestito al termine di \z
    ogni operazione di scavo conclusa con successo nell'ambito di una zona."
  -- Page 74 --------------------------------------------------------------- --
  },{ T="La Banca è disposta a compensare l'eventuale deficit di uno \z
    Scavatore Capo, quando questi intraprende operazioni di scavo nella zona \z
    successiva, affinché disponga almeno di 100 crediti. Ovviamente, se lo \z
    Scavatore Capo dispone di più di 100 crediti, non sarà necessario che la \z
    Banca conceda alcun prestito.\n\z
    \n\z
    La Banca offre anche interessanti condizioni di Permuta per \z
    equipaggiamenti, montacarichi, macchinari, ecc. Quando le operazioni di \z
    scavo in una data zona vengono portate a termine con successo, lo \z
    Scavatore Capo non vuole abbandonare tutto l'equipaggiamento \z
    precedentemente acquistato."
  -- Page 75 --------------------------------------------------------------- --
  },{ T="La Banca incarica quindi i suoi stimatori di recarsi alla miniera, \z
    rimuovere l'equipaggiamento e pagare il 75% del valore allo Scavatore \z
    Capo, a patto che le attrezzature siano in buone condizioni. Ciò \z
    consente allo Scavatore Capo di recuperare parte del denaro investito. \z
    Tale denaro, senza ulteriori deduzioni, viene utilizzato per le \z
    operazioni di scavo nella zona successiva. La Banca ottiene profitti \z
    elevatissimi vendendo l'equipaggiamento come nuovo ad altri scavatori, \z
    ma naturalmente questi sono solo pettegolezzi maligni diffusi da \z
    minatori scontenti e falliti."
  -- Page 76 --------------------------------------------------------------- --
  },{ T="LA BORSA DI ZARG\n\z
    \n\z
    La Borsa di Zarg osserva le leggi della domanda e dell'offerta di tutti \z
    i mercati azionari. È legata ad una rete di mercati sparsi in tutta la \z
    galassia; di conseguenza, lo scambio e i prezzi dei minerali sono spesso \z
    condizionati da transazioni e avvenimenti di altri pianeti.\n\z
    \n\z
    Al di sopra di ogni cassiere appare la figura dei minerali o dei \z
    gioielli attualmente trattati. Selezionando una figura è possibile \z
    conoscere il valore del bene corrispondente. Selezionando il cassiere, \z
    è possibile vendere i minerali o gioielli di cui si dispone."
  -- Page 77 --------------------------------------------------------------- --
  },{ T="Non sarà possibile vendere minerali di altro tipo, ma oli interessi \z
    della Banca variano e minerali di tipo diverso potranno essere venduti \z
    in un altro momento. Anche i prezzi variano di continuo, in base alla \z
    fluttuazione di domanda e offerta. Ad esempio, se viene rinvenuta una \z
    grande quantità di oro, il mercato ne risentirà e il valore di tale \z
    metallo diminuirà.\n\z
    \n\z
    Esiste, tuttavia, una pietra preziosa che non perde mai valore. Si \z
    tratta della Gennite, una pietra rosa molto rara che qualsiasi cassiere \z
    sarà sempre disposto ad acquistare."
  -- Page 78 --------------------------------------------------------------- --
  },{ T="STORIA DELLE ATTIVITÀ DI SCAVO SU ZARG\n\z
    \n\z
    La storia del pianeta Zarg è colorita come le pietre che sono state \z
    trovate nel suo sottosuolo. Le sue ricchezze leggendarie hanno attirato \z
    innumerevoli vagabondi e perdigiorno provenienti da ogni angolo dello \z
    spazio, scavatori, cercatori di fortuna e altri mercanti attratti \z
    dall'idea della ricchezza facile.\n\z
    \n\z
    Purtroopo, i pianeta non rinuncia facilmente alla propria ricchezza e \z
    pochi sono ripartiti più ricchi di quanto non fossero al loro arrivo. \z
    Anzi, molti non sono ripartiti affatto. La causa della ricchezza di Zarg \z
    è anche la causa di molti problemi di scavo."
  -- Page 79 --------------------------------------------------------------- --
  },{ T="La ricchezza del sottosuolo è dovuta ad una violenta attività \z
    vulcanica e tettonica che sconvolge il pianeta per otto mesi all'anno. \z
    Mentre ciò consente la rigenerazione della ricchezza sotterranea, \z
    distrugge nel contempo numerose strutture situate in superficie. Si \z
    crede che i resti di numerose città e civiltà perdute si trovino nelle \z
    viscere del pianeta, in cui furono inghiottite in seguito a tali \z
    sconvolgimenti naturali."
  -- Page 80 --------------------------------------------------------------- --
  },{ T="RAPINE IN PIENO GIORNO\n\z
    \n\z
    La Banca di Zarg è stata oggetto\n\z
    di molti tentativi di rapina. La\n\z
    rapina di maggior successo fu quella\n\z
    intrapresa dal leggendario ladro di\n\z
    gioielli Bel F. Urtos.\n\z
    \n\z
    Indossando un travestimento e contando sulla sua prontezza di spirito, \z
    F. Urtos si spacciò per un ricercatore di guasti inviato dal Presidente \z
    della società Banche Interplanetarie SpA per controllare i sistemi di \z
    sicurezza.",
    I={ 30, 212.0, 28.0 }
  -- Page 81 --------------------------------------------------------------- --
  },{ T="Fu talmente convincente che gli impiegati gli fecero fare una \z
    visita guidata, mostrandogli i sistemi di allarme e fornendogli i \z
    relativi numeri di codice.\n\z
    \n\z
    Calata la notte, il furfante tornò e fece buon uso delle informazioni \z
    ricevute. Quando gli impiegati aprirono la banca la mattina dopo, \z
    trovarono i sotterranei vuoti e il seguente messaggio:\n\z
    \n\z
    Non sono stato io. Sono stati Lucio Del Giorno & Rap Inan   ha, ha, ha, \z
    ha\n\z
    grazie per le pietre, babbei\n\z
    \n\z
    Bel F. Urtos"
  -- Page 82 --------------------------------------------------------------- --
  },{ T="IL CROLLO DEL '94\n\z
    \n\z
    Ricordato anche come Martedì Nero (da non confondere con il Martedì \z
    Nero in cui tutti i sistemi si bloccarono e un Fitarg venne poi \z
    licenziato per aver sottratto microchip dalle macchine. La \z
    giustificazione addotta: \"Sono per la mia collezione\", fu ritenuta \z
    inaccettabile), fu il giorno in cui la Banca venne completamente rasa al \z
    suolo quando una scavatrice 'Mostro', sfuggita al controllo degli \z
    scavatori, andò a sbattere contro le strutture sotterranee \z
    dell'edificio. Milioni di crediti andarono perduti e i ladri non furono \z
    mai presi, anche se per tutto il mese seguente nessun Grablin fu visto \z
    in posizione verticale."
  -- Page 83 --------------------------------------------------------------- --
  },{ T="Antichi consigli sull'attività mineraria e suggerimenti per il \z
    giocatore.\n\z
    Le precedenti spedizioni minerarie sono spesso ritornate con \z
    testimontanze di quelli che sembrano essere graffiti incisi sulle pareti \z
    delle caverne da antichi minatori. L'apparente scopo di questi graffiti \z
    è di informare e consigliare gli eventuali minatori che vogliano seguire \z
    le orme dell'artista.\n\z
    I punti chiave sono:\n\z
    Se siete impazienti di divenire ricchi, potrete guadagnare di più \z
    scavando in gallerie piuttosto che in pozzi profondi.\n\z
    Usate i ponti con saggezza, in quanto essi non solo consentono di \z
    attraversare corsi d'acqua ma vi consentiranno anche di saltare più in \z
    alto e più lontano."
  -- Page 84 --------------------------------------------------------------- --
  },{ T="Non esaurite tutte le vostre energie cercando di scavare attraverso \z
    l'impenetrabile, fate saltare il dannato ostacolo con gli esplosivi, ma \z
    fate attenzione a non allagarvi nel frattempo. Comunque, non potete \z
    aprirvi una via o salvataggio fuori della zona a suon di esplosivi.\n\z
    \n\z
    La sete di sangue ed uccisioni può consentirvi di spazzare via i vostri \z
    nemici, tuttavia la Banca di Zargan tratta in Zogs non in cadaveri, \z
    quindi cercate di perseguire le gemme non la vendetta."
  -- Page 85 --------------------------------------------------------------- --
  },{ T="A parte questi utili suggerimenti, vi consigliamo di:\n\z
      \n\z
    - Salvare la partita ogni qualvolta avete completato una zona.\n\z
      \n\z
    - Vedente sempre i giolelli alla banca immediatamente, per \z
      incrementare al massimo la vostra ricchezza rispetto a quella del \z
      vostro avversario e per evitare il furto dei gioielli sottoterra.\n\z
      \n\z
    - Tenete sempre presente il valore di capitale di tutta l'attrezzatura. \z
      Quest'ultima può dimostrarsi estremamente utile come attività da \z
      scambiare o vendere per iniziare una nuova zona."
  }
};
-- Imports and exports ----------------------------------------------------- --
return { F = Util.Blank, A = { aBookData_it = aBookData } };
-- End-of-File ============================================================= --
