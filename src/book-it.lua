-- BOOK-IT.LUA ============================================================= --
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
    STORIA DELLE ATTIVITA' DI SCAVO SU ZARG",
    H={ { 77,  51, 224, 7,  3 },     -- Chapter 01/11: About this book
        { 77,  62, 224, 7,  8 },     -- Chapter 02/11: How to start Diggers
        { 77,  73, 224, 7, 20 },     -- Chapter 03/11: The Planet Zarg
        { 77,  84, 224, 7, 23 },     -- Chapter 04/11: Race descriptions
        { 77,  95, 224, 7, 31 },     -- Chapter 05/11: Zone descriptions
        { 77, 106, 224, 7, 36 },     -- Chapter 06/11: Flora and fauna
        { 77, 117, 224, 7, 53 },     -- Chapter 07/11: The mining store
        { 77, 128, 224, 7, 55 },     -- Chapter 08/11: Mining apparatus
        { 77, 139, 224, 7, 68 },     -- Chapter 09/11: Zargon bank
        { 77, 150, 224, 7, 72 },     -- Chapter 10/11: Zargon stock market
        { 77, 161, 224, 7, 74 } }    -- Chapter 11/11: Zargon mining history
  -- Page 3 ---------------------------------------------------------------- --
  },{ T="INFORMAZIONI SUL LIBRO\n\z
    \n\z
    Il Libro di Zarg è molto facile da usare. E' fatto di una sostanza \z
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
    Il Libro di Zaro è fatto di una sostanza simile alla carta detta TNT \z
    (Transistor Neurali Testurizzati). Il"
  -- Page 5 ---------------------------------------------------------------- --
  },{ T="processo di creazione di tale sostanza è cosi spaventosamente \z
    complicato che può essere compreso appieno solo dagli Slorghi dotati di \z
    tre cervelli che popolano la Grande Casa dei Mille Pensatori Mormoranti \z
    sul pianeta Cerebralis; quindi non verrà tentata qui alcuna spiegazione \z
    in merito. Basti sapere che, comunque venga creata, la TNT ha avuto \z
    effetti impressionanti, o addirittura rivoluzionari, a detta di alcuni \z
    (bisogna riconoscere, pern, che vi sono persone, solitamente con la \z
    faccia ricoperta di peli sospetti e con un disco dimostrativo registrato \z
    male in tasca, che vanno in giro raccontando cose strane), su tutti i \z
    tipi di libri.\n\z
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
    Prima di cominciare, si consiglia di leggere le sezioni riquardanti i \z
    diversi tipi di ambienti in cui è possibile trovarsi. Ciò sarà utile per \z
    organizzare gli spostamenti sul pianeta."
  -- Page 8 ---------------------------------------------------------------- --
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
  -- Page 9 ---------------------------------------------------------------- --
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
    caratteristiche di ogni razza; le pagine contenenti tali Intormazioni \z
    possono essere girate..."
  -- Page 10 --------------------------------------------------------------- --
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
  -- Page 11 --------------------------------------------------------------- --
  },{ T="Se nel corso delle operazioni di scavo vengono rinvenuti gioielli o \z
    pietre preziose, è possibile venderli alla Banca. Selezionando l'icona \z
    Casa (vedere sul retro) si ritorna al Centro commerciale.\n\z
    \n\z
    Quando si entra nella Banca per la prima volta, al di sopra di ogni \z
    cassiere saranno indicati le pietre preziose e i gioielli che possono \z
    essere venduti. Se si dispone di gioielli di tale tipo, è possibile \z
    chiedere al cassiere qual è il prezzo di acquisto. Se il prezzo sembra \z
    buono, è possibile vendere i gioielli e il valore corrispondente verrà \z
    accreditato sul proprio Conto Corrente di Cassa.\n\z
    Se invece il prezzo non è soddisfacente, o se la Banca non acquista le \z
    pietre di cui si dispone, si può lasciare..."
  -- Page 12 --------------------------------------------------------------- --
  },{ T="...la Banca e ritornarvi successivamente per vedere se viene \z
    offerto un prezzo migliore o se è possibile vendere i preziosi.\n\z
    \n\z
    CARICARE & SALVARE\n\z
    \n\z
    Tra due zone distinte, è possibile salvare il gioco o caricarne uno già \z
    cominciato. Ciò si può fare quando ci si trova alla scrivania del \z
    Controllore. Se si seleziona la cassetta della posta in entrata, si ha \z
    la possibilità di salvare il gioco in quel punto o di caricarne uno già \z
    cominciato."
  -- Page 13 --------------------------------------------------------------- --
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
  -- Page 14 --------------------------------------------------------------- --
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
  -- Page 15 --------------------------------------------------------------- --
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
  -- Page 16 --------------------------------------------------------------- --
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
  -- Page 17 --------------------------------------------------------------- --
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
    ¶ doppia                                            (solo i Fitarg)",
  I={ 5, 140.0, 44.0 }, L=-1.5
  -- Page 18 --------------------------------------------------------------- --
  },{ T="IL PIANETA ZARG\n\z
    \n\z
    Vi sono molte leggende sulla ricchezza mineraria del pianeta Zarg. Il \z
    sottosuolo abbonda di minerali e pietre preziose, quali diamanti, \z
    rubini, smeraldi e oro, ma la devastante attività vulcanica che generò \z
    tale ricchezza, diede origine anche ad una grande quantità di pericoli e \z
    insidie. Di conseguenza, scavare sul pianeta Zarg comporta enormi \z
    rischi. I primi cercatori, spinti da cartelloni pubblicitari spaziali \z
    su cui compariva la scritta 'qui abbondanza di tesori', perirono a \z
    migliaia.\n\z
    \n\z
    Un altro pericolo che i cercatori dovevano affrontare erano le lotte tra \z
    razze rivali di scavatori e l'anarchia...",
  -- Page 19 --------------------------------------------------------------- --
  },{ T="...generale che regnava sul pianeta. Inoltre, le numerose \z
    operazioni di scavo non controllate stavano danneggiando la stabilità \z
    del sottosuolo e voragini enormi si formavano all'improvviso.\n\z
    \n\z
    Le autorità del pianeta decisero di adottare provvedimenti al fine di \z
    risolvere tali problemi. Venne consentito di scavare solo un mese \z
    all'anno, a cominciare dal giorno 412. Per i restanti 17 mesi, le \z
    operazioni di scavo erano vietate.\n\z
    \n\z
    Le autorità, oltre ad adottare la legge del mitico 412, regolarono e \z
    formalizzarono le procedure di scavo sul pianeta. Le seguenti regole \z
    sono ora in vigore:"
  -- Page 20 --------------------------------------------------------------- --
  },{ T="\z
    1. Solo cinque razze di scavatori sono autorizzate a scavare sul \z
       pianeta.\n\z
    2. Ogni scavo deve essere registrato presso il Centro commerciale \z
       minerario di Zarg.\n\z
    3. Tutti i minerali dissotterrati devono essere venduti alla banca di \z
       Zarg.\n\z
    4. Allo scopo di promuovere una sana concorrenza, due razze di scavatori \z
       sono autorizzate a scavare in ogni area del pianeta."
  -- Page 21 --------------------------------------------------------------- --
  },{ T="DESCRIZIONE DELLE RAZZE\n\z
    \n\z
    Habbish. Si tratta di una razza\n\z
    enigmatica ed introversa i cui\n\z
    componenti pare siano assai\n\z
    intelligenti; si dice che abbiano\n\z
    sviluppato poteri speciali di\n\z
    transporto via telpalo. Queste\n\z
    creature incappucciate sono la razza\n\z
    piò debole e benché siano in grado di scavare a lungo, sono assai \z
    impazienti e si stufano rapidamente di scavare preferendo, non appena \z
    possibile, rubacchiare i preziosi rinvenuti da altri.",
    I={ 6, 210.0, 36.0 }
  -- Page 22 --------------------------------------------------------------- --
  },{ T="Gli Habbish rappresentano un ordine mistico guidato dal Capo \z
    Supremo di nome Habborg, un esaltato che ha ordinato ai suoi seguaci di \z
    costruire in suo onore un tempio favoloso, costellato di oro e pietre \z
    preziose. Gli Habbish hanno iniziato i lavori, ma il denaro sta per \z
    venire meno. Devono trovare piò pietre preziose possibile per portare a \z
    termine la costruzione del tempio e ripagare il loro creditore \z
    galattico, il terribile Thungurs cho brandisce la mazza da baseball."
  -- Page 23 --------------------------------------------------------------- --
  },{ T="Grablin\n\z\n\z
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
  -- Page 24 --------------------------------------------------------------- --
  },{ T="L'unica debolezza dei Grablin è il fatto che non possono rinunciare \z
    ad una bevanda micidiale chiamata Grok.\n\z
    Benché si dica che abbia un \"sapore disgustoso\" e un odore \"peggiore \z
    di quello dell'alito dello Scabrosauro sputafuoco che vive negli stagni \z
    di viscidume vorticoso di Sulfuria\" e che sarebbe \"piò utile come \z
    scudo di difesa contro un attacco termonucleare che come bevanda\", i \z
    Grablin non possono farne a meno.\n\z
    \n\z
    Purtroppo, dal momento che oli ingredienti che compongono il Grok \z
    (troppo disgustosi per essere..."
  -- Page 25 --------------------------------------------------------------- --
  },{ T="...menzionati) sono estremamente costosi, i Grablin hanno \z
    costantemente bisogno di soldi. Il loro fine ultimo è di accumulare \z
    abbastanza ricchezza per costruire una distilleria propria. Tuttavia, \z
    dati gli sgradevoli effetti collaterali derivanti dalla distillazione \z
    della bevanda, dovranno prima acquistare un pianeta deserto su cui \z
    costruire la distilleria."
  -- Page 26 --------------------------------------------------------------- --
  },{ T="Quarrior\n\z
    \n\z
    Si tratta di una razza bellicosa\n\z
    paragonabile a veri diamanti grezzi.\n\z
    I Quarrior iniziarono a a cercare\n\z
    minerali nelle cave di pietre prima di\n\z
    intraprendere scavi nelle minere e in\n\z
    superficie.\n\z
    \n\z
    I Quarrior, che sono la razza piò forte, sono anche sabotatori provetti \z
    e molto esperti nell'uso della dinamite. Tuttavia, non si sono ancora \z
    abituati alle scomode condizioni di lavoro; si affaticano rapidamente e \z
    scavano lentamente. Sono estremamente fidati e pazienti, ma privi di \z
    iniziativa.",
    I={ 8, 210.0, 32.0 }
  -- Page 27 --------------------------------------------------------------- --
  },{ T="I Quarrior sono completamente al verde, poiché sono stati \z
    recentemente truffati da un venditore di armi di seconda mano. La loro \z
    ambizione consiste nel costruire un accampamento fortificato in cui \z
    possano allenarsi nel tiro e migliorare la loro capacità di scavare, al \z
    sicuro dai nemici."
  -- Page 28 --------------------------------------------------------------- --
  },{ T="Fitaro\n\z
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
  -- Page 29 --------------------------------------------------------------- --
  },{ T="I fitarg sono gli scavatori piò veloci dopo i Grablin, ma sono in \z
    grado di scavare piò a lungo di tutti gli altri. Scavano volentieri, ma \z
    vengono facilmente distratti da...oggetti in grado di attirare la loro \z
    attenzione. Al di fuori delle minere, si cacciano spesso nei guai a \z
    causa del loro desiderio di collezionare. Non sono particolarmente \z
    aggressivi né capaci di lottare, ma se vengono feriti impiegano la metà \z
    del tempo a guarire rispetto a tutti gli altri.\n\z
    \n\z
    L'ambizione dei Fitarg consiste nell'accumulare abbastanza denaro per \z
    costruire il Museo delle Meraviglie di Metallo (soprannominato \z
    malignamente il Rottamaio), in cui intendono conservare rottami storici \z
    e sculture di natura insolita e istruttiva."
  -- Page 30 --------------------------------------------------------------- --
  },{ T="Flimmer. Rimangono pochissimi segni di questa razza di scavatori \z
    timidi e amanti della pace che scomparve senza lasciare traccia dalla \z
    faccia del pianeta. Ricordati come i migliori scavatori in assoluto, si \z
    narra che i Flimmer abbiano deciso di smettere di scavare dopo che il \z
    loro entusiasmo per tale attività si spense in seguito ad una stagione \z
    particolarmente estenuante. Dopo essersi recati per l'ultima volta alla \z
    Banca di Zaro, dove rinunciarono a tutti i beni terreni, e dopo aver \z
    gettato i loro averi oltre il bancone, provocando una corsa ai diamanti \z
    che sconvolse il mercato galattico, si dispersero per il pianeta ... e \z
    scomparvero.\n\z
    \n\z
    Dove si trovino attualmente i Flimmer rimane un..."
  -- Page 31 --------------------------------------------------------------- --
  },{ T="...mistero, benché i vecchi racconti dei minatori narrino di \z
    sguardi fugaci di timide creature che assomigliano ai Flimmer. Molte di \z
    tali storie sono frutto di dosi eccessive di Grok, ma si crede ancora \z
    che in un angolo remoto del pianeta, molti metri al di sotto della \z
    superficie, vivano i discendenti di tali scavatori. Si consiglia di \z
    tenere gli occhi ben aperti scavando. Chissà, quell'ombra fugace, quello \z
    sguardo appena intravisto in un tunnel buio, sarà forse un Flimmer?"
  -- Page 32 --------------------------------------------------------------- --
  },{ T="DESCRIZIONE DELLE ZONE\n\z
    \n\z
    Prateria Zona pianeggiante con fiumi che solcano i prati verdeggianti. \z
    Nel sottosuolo vi sono altri fiumi, caverne e piccole quantità di rocce \z
    impenetrabili. Studi recenti hanno rivelato la presenza di resti \z
    fossilizzati di grandi creature di origine sconosciuta.\n\z
    \n\z
    Foresta/Giungla Zona prevalentemente pianeggiante caratterizzata da \z
    fiumi sinuosi e piccoli laghi. Il suolo è molto fertile e consente la \z
    crescita di alberi giganteschi e altissimi. Le radici di tali alberi \z
    raggiungono lunghezze eccezionali e penetrano in profondità. Una volta \z
    che tali radici sono cresciute le une intorno alle altre, formano..."
  -- Page 33 --------------------------------------------------------------- --
  },{ T="...spessi grovigli che è impossibile rimuovere o penetrare \z
    scavando.\n\z
    \n\z
    Le bocche delle miniere dovrebbero essere situate it punti abbastanzi \z
    lontani dagli alberi in modo da evitare di incontrare tall radici. In \z
    questa zona adbondano strane storie riguardanti la vita delle piante, ma \z
    non sono ancora state trovate prove che ne confermino l'autenticità.\n\z
    \n\z
    Deserto Arida zona di Zarg caratterizzata da sabbie mobili e dune. Sono \z
    evidenti gli effetti dell'erosione. Enormi formazioni rocciose sono \z
    state sepolte dalla sabbia e compresse in modo da formare terreni \z
    impervi."
  -- Page 34 --------------------------------------------------------------- --
  },{ T="Al di sotto della sabbia si estendono enormi strutture cristalline \z
    dal colori brillianti. Esistono anche laghi e sorgenti d'acqua \z
    sotterranei.\n\z
    \n\z
    Ghiacci Zona freddissima caratterizzata da mari glaciali costellati da \z
    iceberg. Occorre essere estremamente prudenti quando si scava a tali \z
    livelli a causa del pericolo di inondazioni, specialmente in presenza di \z
    iceberg.\n\z
    \n\z
    Isole Zona formata da un vasto arcipelago di isole che circondano un \z
    grande oceano. Tutte le isole si congiungono nelle profondità marine per \z
    formare un'enorme catena montuosa sottomarina."
  -- Page 35 --------------------------------------------------------------- --
  },{ T="Montagne Zona caratterizzata da cime frastagliate e pendii rocciosi \z
    poco sicuri che offrono scarsi spazi adatti per scavare. Tuttavia, tra \z
    le montagne vi sono ampie grotte che offrono opportunità migliori.\n\z
    \n\z
    Al di sotto della superficie rocciosa vi sono depositi di pietre dure \z
    che rendono gli scavi impossibili in alcune zone. E' anche possibile \z
    trovare sorgenti d'acqua sotterranee.\n\z
    \n\z
    Terreno roccioso Zona che assomiglia al Grand Canyon, caratterizzata da \z
    numerosi strapiombi, precipizi e formazioni rocciose precarie. Al di \z
    sotto della superficie vi sono vaste aree di roccia impenetrabile. In \z
    prossimità..."
  -- Page 36 --------------------------------------------------------------- --
  },{ T="...della superficie l'acqua scarseggia, ma piò in profondità \z
    abbondano caverne ricche d'acqua. I corsi di fiumi prosciugati da lungo \z
    tempo hanno creato una serie di grotte e passaggi tra i vari strati di \z
    roccia. Si crede che in tale livello vi siano città perdute, forse \z
    abitate dal fantasmi dei precedenti occupanti."
  -- Page 37 --------------------------------------------------------------- --
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
  -- Page 38 --------------------------------------------------------------- --
  },{ T="Triffidus Carnivorus\n\z
    \n\z
    Vive nella giungla e nelle foreste\n\z
    alberi e piante. Pianta carnivora\n\z
    pericolosissima, dall'appetito\n\z
    insaziabile. E'facilmente\n\z
    riconoscibile per l'insolito\n\z
    colore delle foglie. Dopo essere\n\z
    stato catturato ed esaminato mediante raggi infrarossi la guida di un \z
    esemplare rivelò contenere la guida di un principiante e un paio di \z
    occhiali simili a quelli del Dr. Frinklin.",
    I={ 10, 200.0, 15.0 }
  -- Page 39 --------------------------------------------------------------- --
  },{ T="Fungus Kaleidoscopus\n\z
    \n\z
    Questi funghi, che possono essere\n\z
    trovati in superficie in diversi\n\z
    luoghi, crescono in grossi grappoli.\n\z
    Sono facilmente individuabili a causa\n\z
    della grande cappella rossa a punti\n\z
    bianchi.\n\z
    \n\z
    I risultati di uno studio scientifico hanno dimostrato che gli effetti \z
    provocati dairingestione ol tale Tungo possono variare da individuo a \z
    individuo. Alcuni muoiono semplicemente, altri raddoppiano la propria \z
    forza, mentre altri ancora sembrano frastornati e parlano contusamente \z
    or olratte rosa.",
    I={ 11, 200.0, 32.0 }
  -- Page 40 --------------------------------------------------------------- --
  },{ T="Stegosauro\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Grande dinosauro che vive in caverne sotterranee. E' dotato di pelle \z
    color sabbia e di due corni. Di indole generalmente docile, gli \z
    stegosauri attaccano se provocati o se si sentono in pericolo. Nei \z
    tunnel stretti, lo stegosauro è in grado di annientare i nemici.",
    I={ 12, 96.0, 15.0 }
  -- Page 41 --------------------------------------------------------------- --
  },{ T="Rotorisauro\n\z
    \n\z
    Particolare tipo di dinosauro che vive nei livelli sotterranei, ma che \z
    di tanto in tanto vaga sulla superficie del pianeta. Benché sia \z
    generalmente piuttosto mansueto, se provocato o aggredito è in grado di \z
    infliggere gravi danni agli aggressori.\n\z
    \n\z
    Velocirapitor\n\z
    \n\z
    Dinosauro sorprendentemente feroce che attacca anche senza essere \z
    provocato. Detesta la vista di quasi ogni altra creatura e, nonostante \z
    non raggiunga dimensioni imponenti, è in grado di colpire con la forza \z
    di uno stegosauro."
  -- Page 42 --------------------------------------------------------------- --
  },{ T="Occorre evitarlo ad ogni costo. Se lo si incontra, è opportuno \z
    scappare il piò velocemente possibile o attirarlo verso le miniere degli \z
    avversari e fuggire."
  -- Page 43 --------------------------------------------------------------- --
  },{ T="Ouus Horribilis\n\z
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
  -- Page 44 --------------------------------------------------------------- --
  },{ T="\"E' stato terrificante. Il Capo ci aveva detto di scavare in quel \z
    pezzo di roccia. Ebbene, non mi vergogno a dirlo, non mi piaceva neanche \z
    un po'. C'era qualcosa di strano, sapete... Comunque, cominciammo a \z
    scavare e ci ritrovammo all'interno di una caverna. Mi guardai intorno \z
    facendo luce con la torcia, ma sembrava vuota. \"Andiamo, Bolbo\", \z
    dissi. \"Beviamoci un sorso di Grok\". Ma lui non venne, aveva visto \z
    quell'uovo orribile. \"Lascialo stare\", gli dissi, ma non mi diede \z
    retta. Lo tirò su e quell'essere gli saltò addosso, ooh che cosc \z
    spaventosa, e lo assorbì dentro di sè. Non avevo il coraggio di \z
    guardare. Mi voltai e corsi via. Fu una cosa tremenda, dov'è quella \z
    bottiglia..?\""
  -- Page 45 --------------------------------------------------------------- --
  },{ T="Mammiferi lanuti\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Grande mammiferi che si ritiene vivessero su su Zarg circa un milione \z
    di anni fa. I resti congelati di un esemplare sono stati ritrovati un \z
    anno fa e altri potrebbero essere rinvenuti allo stato fossile nelle \z
    zone dei ghiacci.",
    I={ 14, 96.0, 32.0 }
  -- Page 46 --------------------------------------------------------------- --
  },{ T="La carne dei mammiferi lanuti è stata mangiata dagli esploratori \z
    della regione Artica in preda alla fame:\n\z
    \n\z
    \"Mnmn, un attimo solo ... che smetto di mnmnmn... masticare...\"\n\z
    \"Penso che il vegetarianismo stia per acquisire un nuovo seguace.\"\n\z
    \"Hommm, hommm, Capo Habborg, hommm, hommm.\""
  -- Page 47 --------------------------------------------------------------- --
  },{ T="Pesci\n\z
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
  -- Page 48 --------------------------------------------------------------- --
  },{ T="Anche quanto si narra a proposito del feroce \"picosauro\" deve \z
    essere preso con le molle (forse coltello e forchetta sarebbero piò \z
    comodi)."
  -- Page 49 --------------------------------------------------------------- --
  },{ T="Lombrichi di terra\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Grossi animali di genere oscuro. Si pensa che tali creature timide \z
    vivano nelle pianeta: è possibile verdele solo di rado e non si conosce \z
    granchè circa il loro comportamento. Qui di seguito è riportato il \z
    resoconto di un Quarrior che ha avuto occasione di incontrare un \z
    lombrico di terra.",
    I={ 16, 96.0, 32.0 }
  -- Page 50 --------------------------------------------------------------- --
  },{ T="\"Ci stavamo occupando del nostro lavoro, scavando senza far rumore \z
    (beh, per quanto ciò sia possibile quando si usa la dinamite), e \z
    all'improvviso la terra iniziò a spostarsi sotto ai nostri piedi. Devo \z
    confessare che, per un attimo, mi sentii confuso; ebbi appena il tempo \z
    di pesare prima di cadere all'indietro e battere la testa. Per fortuna, \z
    ciò sembrò essere di quegli ernomi vermi. Sia chiaro che non avevo \z
    paura; afferrai una pala e stavo per affrontarlo... 'Avanti', lo incitai \z
    ma strisciò via verso il tunnel e scomparve. Comunque, penso siano dei \z
    gran fifoni...\""
  -- Page 51 --------------------------------------------------------------- --
  },{ T="Avvistamenti misteriosi!\n\z
    \n\z
    Nel corso degli anni, sono circolate voci circa strani esseri eterei che \z
    popolano le grotte nelle viscere del pianeta Zarg. I minatori che sono \z
    riusciti a risalire in superticie e che hanno avuto modo di raccontare \z
    le loro storie, parlano di fantomatiche apparizioni che si muovevano \z
    lentamente attaccando il gruppo e uccidendo gli uomini. Altri racconti \z
    narrano di creature simili a scavatori dai movimenti rapidissimi che \z
    piombavano giò dai soffitti di grandi grotte e uccidevano con destrezza. \z
    Secondo le storie che vengono raccontate nel numerosi bar del pianeta, \z
    si tratta dei fantasmi dei minatori che furono lasciati morire, mentre \z
    gli Zombi sono li risultato..."
  -- Page 52 --------------------------------------------------------------- --
  },{ T=""
  -- Page 53 --------------------------------------------------------------- --
  },{ T=""
  -- Page 54 --------------------------------------------------------------- --
  },{ T=""
  -- Page 55 --------------------------------------------------------------- --
  },{ T=""
  -- Page 56 --------------------------------------------------------------- --
  },{ T=""
  -- Page 57 --------------------------------------------------------------- --
  },{ T=""
  -- Page 58 --------------------------------------------------------------- --
  },{ T=""
  -- Page 59 --------------------------------------------------------------- --
  },{ T=""
  -- Page 60 --------------------------------------------------------------- --
  },{ T=""
  -- Page 61 --------------------------------------------------------------- --
  },{ T=""
  -- Page 62 --------------------------------------------------------------- --
  },{ T=""
  -- Page 63 --------------------------------------------------------------- --
  },{ T=""
  -- Page 64 --------------------------------------------------------------- --
  },{ T=""
  -- Page 65 --------------------------------------------------------------- --
  },{ T=""
  -- Page 66 --------------------------------------------------------------- --
  },{ T=""
  -- Page 67 --------------------------------------------------------------- --
  },{ T=""
  -- Page 68 --------------------------------------------------------------- --
  },{ T=""
  -- Page 69 --------------------------------------------------------------- --
  },{ T=""
  -- Page 70 --------------------------------------------------------------- --
  },{ T=""
  -- Page 71 --------------------------------------------------------------- --
  },{ T=""
  -- Page 72 --------------------------------------------------------------- --
  },{ T=""
  -- Page 73 --------------------------------------------------------------- --
  },{ T=""
  -- Page 74 --------------------------------------------------------------- --
  },{ T=""
  -- Page 75 --------------------------------------------------------------- --
  },{ T=""
  -- Page 76 --------------------------------------------------------------- --
  },{ T=""
  -- Page 77 --------------------------------------------------------------- --
  },{ T=""
  -- Page 78 --------------------------------------------------------------- --
  },{ T=""
  -- Page 79 --------------------------------------------------------------- --
  },{ T=""
  -- Page 80 --------------------------------------------------------------- --
  },{ T=""
  -- Page 81 --------------------------------------------------------------- --
  },{ T=""
  -- Page 82 --------------------------------------------------------------- --
  },{ T=""
  -- Page 83 --------------------------------------------------------------- --
  },{ T=""
  -- Page 84 --------------------------------------------------------------- --
  },{ T=""
  -- Page 85 --------------------------------------------------------------- --
  },{ T=""
  -- Page 86 --------------------------------------------------------------- --
  },{ T=""
  -- Page 87 --------------------------------------------------------------- --
  },{ T=""
  -- Page 88 --------------------------------------------------------------- --
  },{ T=""
  }
};
-- Imports and exports ----------------------------------------------------- --
return { F = Util.Blank, A = { aBookData_it = aBookData } };
-- End-of-File ============================================================= --
