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
  },{ T=""
  -- Page 22 --------------------------------------------------------------- --
  },{ T=""
  -- Page 23 --------------------------------------------------------------- --
  },{ T=""
  -- Page 24 --------------------------------------------------------------- --
  },{ T=""
  -- Page 25 --------------------------------------------------------------- --
  },{ T=""
  -- Page 26 --------------------------------------------------------------- --
  },{ T=""
  -- Page 27 --------------------------------------------------------------- --
  },{ T=""
  -- Page 28 --------------------------------------------------------------- --
  },{ T=""
  -- Page 29 --------------------------------------------------------------- --
  },{ T=""
  -- Page 30 --------------------------------------------------------------- --
  },{ T=""
  -- Page 31 --------------------------------------------------------------- --
  },{ T=""
  -- Page 32 --------------------------------------------------------------- --
  },{ T=""
  -- Page 33 --------------------------------------------------------------- --
  },{ T=""
  -- Page 34 --------------------------------------------------------------- --
  },{ T=""
  -- Page 35 --------------------------------------------------------------- --
  },{ T=""
  -- Page 36 --------------------------------------------------------------- --
  },{ T=""
  -- Page 37 --------------------------------------------------------------- --
  },{ T=""
  -- Page 38 --------------------------------------------------------------- --
  },{ T=""
  -- Page 39 --------------------------------------------------------------- --
  },{ T=""
  -- Page 40 --------------------------------------------------------------- --
  },{ T=""
  -- Page 41 --------------------------------------------------------------- --
  },{ T=""
  -- Page 42 --------------------------------------------------------------- --
  },{ T=""
  -- Page 43 --------------------------------------------------------------- --
  },{ T=""
  -- Page 44 --------------------------------------------------------------- --
  },{ T=""
  -- Page 45 --------------------------------------------------------------- --
  },{ T=""
  -- Page 46 --------------------------------------------------------------- --
  },{ T=""
  -- Page 47 --------------------------------------------------------------- --
  },{ T=""
  -- Page 48 --------------------------------------------------------------- --
  },{ T=""
  -- Page 49 --------------------------------------------------------------- --
  },{ T=""
  -- Page 50 --------------------------------------------------------------- --
  },{ T=""
  -- Page 51 --------------------------------------------------------------- --
  },{ T=""
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
