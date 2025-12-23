-- BOOK-EN.LUA ============================================================= --
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
-- English Book data ------------------------------------------------------- --
local aBookData<const> = {
  -- Parameters ------------------------------------------------------------ --
  -- T = The text to display on that page. It is word-wrapped on the fly.
  -- I = The optional illustration to display on that page { iTileId, iX, iY }.
  -- L = The optional line-spacing to use.
  -- H = The optional hotspots to use { { iX, iY, iW, iH, iGotoPage }, ... }
  -- Page 1 ---------------------------------------------------------------- --
  { T="THE BOOK OF ZARG\n\z
    \n\z
    This book contains information about most aspects of the planet Zarg \z
    and provides vital details for anyone wishing to set up mining \z
    operations upon it. This information is listed under chapter headings. \z
    To obtain the information you require, simply click on the appropriate \z
    chapter heading and the chosen page will appear. In the left hand \z
    margin of the book is a row of buttons that enable you to turn to any \z
    page you require.",
  -- Page 2 ---------------------------------------------------------------- --
  },{ T="CHAPTER HEADINGS\n\z
    \n\z
    ABOUT THIS BOOK\n\z
    HOW TO START DIGGERS (OPTIONS FOR THE GAME)\n\z
    THE PLANET ZARG and THE GLORIOUS 412th\n\z
    DIGGERS RACE DESCRIPTIONS\n\z
    ZONE DESCRIPTIONS\n\z
    FLORA AND FAUNA\n\z
    THE MINING STORE\n\z
    MINING APPARATUS\n\z
    ZARGON BANK\n\z
    ZARGON STOCK MARKET\n\z
    ZARGON MINING HISTORY",
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
  },{ T="ABOUT THIS BOOK\n\z
    \n\z
    The Book of Zarg is simplicity itself to use. The Book uses a \z
    revolutionary substance called TNT to display its pages. (See TNT.) \z
    Consequently, the Book only needs to contain the cover, one sheet of \z
    TNT and the control mechanism for TNT: three cut emeralds that are \z
    embedded into the spine of the Book.\n\z
    \n\z
    The top emerald returns the reader to the index page.\n\z
    The 2nd emerald moves the reader to the next page.\n\z
    The third emerald takes the reader back to the previous page."
  -- Page 4 ---------------------------------------------------------------- --
  },{ T="Simply pressing the relevant buttons will allow the reader to skip \z
    to the page of their choice.\n\z
    \n\z
    Chapter selection is made by choosing which chapter they would like to \z
    read and simply pointing at the heading. This will take the reader to \z
    the first page of that chapter.\n\z
    \n\z
    TNT\n\z
    \n\z
    The Book of Zarg is made of a remarkable paper-like substance known as \z
    TNT (Texturised Neural Transistors). The process of creating this \z
    paper is so mind-bogglingly complicated that it is only fully..."
  -- Page 5 ---------------------------------------------------------------- --
  },{ T="...understood by the three-brained Sloargs that inhabit the Great \z
    Hall of a Thousand Rustling Intellects on the planet Cerebralis, \z
    therefore an explanation will not be attempted. Suffice it to say that \z
    however it is done, TNT has had an impressive, some may say \z
    revolutionary (but then you always get some people - normally with \z
    suspicious facial hair and a poorly recorded demo tape in their \z
    pockets - who say that sort of thing) effect on all kinds of books.\n\z
    \n\z
    TNT's effects are threefold and simple to explain.\n\z
    \n\z
    A. One sheet of TNT can contain an infinite number of words, thereby \z
       reducing the thickness of books to one page."
  -- Page 6 ---------------------------------------------------------------- --
  },{ T="B. When a reader touches a sheet of TNT, it scans their brain to \z
       ascertain speech and reading patterns. A fraction of a nanosecond \z
       later it then presents the text in the reader's preferred language.\n\z
    \n\z
    C. If an illustrator uses a special ink to draw on a page of TNT, when \z
       that page is opened, the illustration moves.\n\z
    \n\z
    Eye-catching indeed, and the results of a random survey of readers' \z
    reactions to TNT are equally illuminating."
  -- Page 7 ---------------------------------------------------------------- --
  },{ T="\"New fangled nonsense. Blasted pictures won't stop moving. It'll \z
    never catch on, give me my quill and ink any day.\"\n\z
    \n\z
    \"That's radical. It's like, you know, it's revolutionary. I'm in a \z
    band by the way, do you want to hear my tape?\""
  -- Page 8 ---------------------------------------------------------------- --
  },{ T="HOW TO START DIGGERS\n\z
    \n\z
    THE CONTROLLER'S OFFICE\n\z
    \n\z
    Every time you start a new game, complete a level, or terminate an \z
    existing game, you will be returned to the Controller's Office. The \z
    Controller will prompt you to select a level to either begin your \z
    mining operations or continue those successful operations.\n\z
    \n\z
    Before you begin, we recommend you read the sections on the different \z
    types of environmental zones you may encounter later in the Book. It \z
    will help in planning your movement across the planet."
  -- Page 9 ---------------------------------------------------------------- --
  },{ T="When you first start the game, you will only be able to select \z
    one of two zones for your initial operation, either \"DHOBBS\" or \z
    \"AZERG.\" These are situated in the top left hand corner of the map. \z
    If you successfully complete one of these levels you may continue \z
    expanding your mining operation into any adjacent zones, and so work \z
    your way around the planet.\n\z
    \n\z
    When you successfully complete a zone, either economically or through \z
    wiping out your opponent, a flag of success will be raised on that \z
    zone."
  -- Page 10 --------------------------------------------------------------- --
  },{ T="After selecting the zone of your choice, you are returned back to \z
    the Controller's Office. If you are starting a new game, he will suggest \z
    you now choose a race of diggers in which to invest your money. Each \z
    race has different characteristics, different goals, different strengths \z
    and weaknesses. (See chapter on RACES later in the Book. We recommend \z
    you study the race descriptions before you make your choice, as you must \z
    use the same race throughout the game.\n\z
    \n\z
    In the Race Selection area, you can view a summary of the \z
    characteristics of each race, the sketched page and information can be \z
    turned by clicking in the right hand corner of the page. Selection is \z
    made by clicking"
  -- Page 11 --------------------------------------------------------------- --
  },{ T="anywhere else on the page.\n\z
    \n\z
    Once you have proceeded through these selection criteria you can begin \z
    the game.\n\z
    \n\z
    THE BANK\n\z
    \n\z
    The left hand door in the corridor of the Zargon Trading Centre.\n\z
    For a more detailed description of the Banking operations and the \z
    Zargon Stock Exchange, see the relevant chapters further in this book. \z
    But here is a brief description of how to use the system."
  -- Page 12 --------------------------------------------------------------- --
  },{ T="If during your mining operations you mine some precious jewels or \z
    minerals you can sell them at the Bank. By selecting the home icon \z
    (see overleaf) you are transported back to the Zargon Trading Centre.\n\z
    \n\z
    When you first enter the Bank, the display screens above each of the \z
    tellers' windows will show a representation of which minerals and \z
    jewels they are trading in. If you have any jewels of the type \z
    displayed, you may ask the teller what price he is currently paying \z
    for those minerals. If you feel that it is a good price, you can sell \z
    the jewels, and the value will be added to your Current Cash Account. \z
    If you do not feel it is a good price, or they are not trading"
  -- Page 13 --------------------------------------------------------------- --
  },{ T="the minerals you are carrying, then you can leave the Bank and \z
    return at a later date to see if they are offering a better price or \z
    are trading in those jewels."
  -- Page 14 --------------------------------------------------------------- --
  },{ T="CONTROL ICONS\n\z
    \n\z
    \n\z
    Character Movement\n\z
    \n\z
    Digging\n\z
    \n\z
    Home                                             \z
    (only available at base camp)\n\z
    \n\z
    Wait\n\z
    \n\z
    Search\n\z
    \n\z
    Teleport",
    I={ 1, 164.0, 54.0 }, L=-1.5
  -- Page 15 --------------------------------------------------------------- --
  },{ T="Jump\n\z
    \n\z
    Walk Right\n\z
    \n\z
    Wait\n\z
    \n\z
    Run left\n\z
    \n\z
    Stop\n\z
    \n\z
    Run Right\n\z
    \n\z
    Return to main menu\n\z
    \n\z
    Walk left",
    I={ 2, 164.0, 24.0 }, L=-1.5
  -- Page 16 --------------------------------------------------------------- --
  },{ T="\n\z
    Digging directions\n\z
    \n\z
    \n\z
    Pick up\n\z
    \n\z
    \n\z
    Put down and inventory\n\z
    \n\z
    \n\z
    Search\n\z
    \n\z
    \n\z
    Cycles between teleports",
    I={ 3, 164.0, 24.0 }, L=-0.75
  -- Page 17 --------------------------------------------------------------- --
  },{ T="                                     CONTROL PANEL\n\z
        Cash Account                Items and gems collected\n\z
    \n\z
    \n\z
    \n\z
    ¶                    Stamina             Who is winning\n\z
    ¶                                (Green flag is computer player \n\z
    ¶                                         Pink flag is you)\n\z
    State of individual diggers\n\z
    ¶     Panic OK Busy Bored Dead\n\z
    ¶                                    \z
    ¶      Diggers status   Electronic Book\n\z
    \n\z
    \n\z
    \n\z
    Digger selected      Machine selection      Diggers location",
    I={ 4, 96.0, 51.0 }, L=-0.75
  -- Page 18 --------------------------------------------------------------- --
  },{ T="DESCRIPTION OF RACE CHARACTERISTICS\n\z
    \n\z
    Stamina                                         Aggressiveness\n\z
    \n\z
    Strength                                        Specials\n\z
    \n\z
    Patience                                        Teleport power\n\z
    ¶                                                      (Habbish only)\n\z
    Digging speed\n\z
    \n\z
    Intelligence                                    Double healing\n\z
    ¶                                                      (F'Targs only)",
    I={ 5, 140.0, 44.0 }, L=-1.5
  -- Page 19 --------------------------------------------------------------- --
  },{ T="LOADING & SAVING\n\z
    \n\z
    Between zones you are able to save your game or load an existing game. \z
    This is done when you are standing at the controller's desk. Selecting \z
    the filing tray will give you the option to save the game at that point \z
    or load an existing game."
  -- Page 20 --------------------------------------------------------------- --
  },{ T="THE PLANET ZARG\n\z
    \n\z
    Stories of the Planet Zarg's mineral wealth are legendary. Large amounts \z
    of minerals and ores, including diamonds, rubies, emeralds and gold can \z
    be found below the planet's surface; the enormous volcanic activity that \z
    created these riches also threw up a large number of perils and hazards. \z
    As a result, mining the Planet Zarg is an extremely hazardous operation. \z
    Early diggers lured by labels on space charts saying 'here be treasures' \z
    perished in their thousands.\n\z
    \n\z
    Another hazard facing workers was the fighting between rival races of \z
    diggers and the general lawlessness on"
  -- Page 21 --------------------------------------------------------------- --
  },{ T="the planet. In addition, too much uncontrolled digging was \z
    damaging the planet's subterranean stability and huge chasms were \z
    beginning to appear without warning.\n\z
    \n\z
    The planet's authorities decided to act to contain these problems. The \z
    first result of their deliberations was to allow only one month's \z
    digging per year, beginning on the glorious 412th. For the remaining \z
    17 months a year, mining operations are forbidden.\n\z
    \n\z
    As well as the rule of the glorious 412th, the authorities have also \z
    cleaned up and formalised digging procedures on the planet. The \z
    following rules now also apply:"
  -- Page 22 --------------------------------------------------------------- --
  },{ T="1. Only five races of diggers are permitted to dig on the \z
       planet.\n\z
       \n\z
    2. Each dig must be registered at the Zargon Mineral Trading Centre.\n\z
       \n\z
    3. All minerals mined must be exchanged for cash at the Zargon Bank.\n\z
       \n\z
    4. To encourage healthy competition, two races of diggers are allowed \z
       to mine each area of the planet."
  -- Page 23 --------------------------------------------------------------- --
  },{ T="RACE DESCRIPTIONS\n\z
    \n\z
    The Habbish\n\z
    An enigmatic secretive breed who\n\z
    are rumoured to be extremely\n\z
    clever and have developed special\n\z
    telepole transportation powers.\n\z
    These cowled creatures are the\n\z
    weakest of the races and although\n\z
    they could continue digging for a\n\z
    long time, they are very impatient and soon lose interest in digging, \z
    preferring wherever possible to pilfer valuables mined by others.",
    I={ 6, 210.0, 41.0 }
  -- Page 24 --------------------------------------------------------------- --
  },{ T="The Habbish are a mystical order ruled by their Lord High \z
    Habborg. This exalted being has decreed that his followers must build \z
    a fabulous temple complex, encrusted with gold and jewels in his name. \z
    The Habbish have begun this work, but money is running out. They need \z
    to mine as many valuables as possible in order to complete the temple \z
    and pay off the galactic repo-men, the baseball bat wielding \z
    Thungurs.\n\z
    \n\z
    The Habbish are ruled by a most peculiar calendar and at various \z
    unpredictable and often inconvenient times, they will drop everything \z
    to gather into a circle and chant to the Lord High Habborg. They \z
    become easily upset if their digging plans are unsuccessful and bow to \z
    their master for forgiveness if they do not regularly mine valuables."
  -- Page 25 --------------------------------------------------------------- --
  },{ T="The Grablins\n\z
    Ideally suited to mining. They are\n\z
    very fast diggers and can keep\n\z
    digging for long periods of time\n\z
    without stopping. Their small size\n\z
    makes them very mobile about the\n\z
    mines as they can squeeze into\n\z
    narrow fissures and work in low\n\z
    tunnels. Although strong, they are not very good fighters and can be \z
    easily defeated by the Quarriors.\n\z
    \n\z
    The Grablins' only weakness is for the fiendishly strong drink, Grok. \z
    Although described by others as an \"unaquirable taste\" with a smell \z
    \"worse than the...",
    I={ 7, 200.0, 15.0 }
  -- Page 26 --------------------------------------------------------------- --
  },{ T="...breath of a fire-breathing Scabrosaur from the swirling slime \z
    pools of Sulphuria\" and \"more useful as a defensive shield against \z
    thermonuclear war than as a drink\", the Grablins cannot get enough of \z
    the stuff.\n\z
    \n\z
    Unfortunately, because the ingredients that make up Grok (ingredients \z
    too unfeasibly disgusting to be mentioned here) are extremely \z
    expensive, the Grablins constantly need money.\n\z
    \n\z
    Their ultimate aim is to amass enough riches to build their own \z
    brewery. However, due to the unpleasant side effects of brewing the \z
    drink, they first have to buy their own deserted planet on which to \z
    site their brewery."
  -- Page 27 --------------------------------------------------------------- --
  },{ T="The Quarriors\n\z
    This warlike race are a bunch of\n\z
    real rough diamonds. As their name\n\z
    suggests, the Quarriors began\n\z
    searching for riches in quarries\n\z
    before graduating downwards to\n\z
    open cast mining and then into digging.\n\z
    \n\z
    The strongest of all the races, the Quarriors are also expert \z
    saboteurs and dynamite with dynamite. However, the Quarriors have not \z
    yet adapted well to cramped mining conditions; they tire easily and \z
    are slow at digging. They are extremely reliable and patient, but \z
    lack initiative.",
    I={ 8, 210.0, 20.0 }
  -- Page 28 --------------------------------------------------------------- --
  },{ T="The Quarriors are flat broke as they were recently tricked by a \z
    second-hand arms salescreature. Their ambition is to build a fortified \z
    encampment where they can practice weapons and digging skills safe \z
    from their enemies."
  -- Page 39 --------------------------------------------------------------- --
  },{ T="The F'Targs\n\z
    This resilient race of diggers\n\z
    are extremely curious and great\n\z
    collectors of scrap metal. They have\n\z
    an insatiable desire to build things\n\z
    from the scraps they are always\n\z
    picking up. As a result, their\n\z
    buildings and machines all have a\n\z
    shambolic patched-up appearance.\n\z
    \n\z
    The F'Targs are the second fastest diggers. They are slower than the \z
    Grablins but can continue mining much longer than the others. They \z
    enjoy digging but can be distracted by objects that take their fancy.",
    I={ 9, 210.0, 20.0 }
  -- Page 30 --------------------------------------------------------------- --
  },{ T="Their desire to collect often gets them into trouble outside the \z
    mines. They are not very aggressive or good at fighting but if hurt, \z
    they can heal themselves twice as quickly as any other diggers.\n\z
    \n\z
    The F'Targs' ambition is to collect enough money to build their \z
    proposed Museum of Metal Marvels (unkindly nicknamed the Scrapheap) in \z
    which they wish to house historic scrap and sculptures of an unusual \z
    or enlightening nature."
  -- Page 31 --------------------------------------------------------------- --
  },{ T="ZONE DESCRIPTIONS\n\z
    \n\z
    Grassland - a flat savannah area with rivers breaking up the swathes \z
    of grass. Below ground are more rivers, caverns and a small amount of \z
    impenetrable rocks. Recent finds include fossilised remains of large \z
    creatures of unknown origin.\n\z
    \n\z
    Forest/Jungle - mainly flat area broken up by undulating rivers and \z
    small lakes. The top soil in this area is extremely rich in nutrients \z
    and supports the growth of giant trees that reach high up into the \z
    sky. The roots of these trees grow to an enormous length and depth in \z
    the earth. Where roots have grown"
  -- Page 32 --------------------------------------------------------------- --
  },{ T="around each other, they form thick entanglements that are too \z
    strong to be dug through or removed. Pit heads should be set up in \z
    clearings between trees to avoid these roots. Wild stories of strange \z
    plant life in this area abound, but no proof has yet been found to \z
    confirm them.\n\z
    \n\z
    Desert - shifting sands and dunes cover this arid area of Zarg. The \z
    effects of erosion are evident here. Huge rock formations have been  \z
    buried by the sand and compressed into impervious strength."
  -- Page 33 --------------------------------------------------------------- --
  },{ T="Huge, brightly-coloured crystal structures stretch under the sand. \z
    Underground lakes and water sources exist below the surface.\n\z
    \n\z
    Ice - this is an area of freezing conditions with ice-cold seas and \z
    many ice-bergs. Particular care should be taken when digging within \z
    these levels because of the danger of flooding, especially in \z
    Icebergs.\n\z
    \n\z
    Islands - this area is made up of a vast archipelago of islands dotted \z
    around a large ocean. All islands are joined deep below the water's \z
    surface to form a huge sub-aqua mountain range."
  -- Page 34 --------------------------------------------------------------- --
  },{ T="Mountains - area of jagged peaks and unstable rocky slopes which \z
    offers few places suitable for digging. However, scattered through the \z
    mountains are large caves which may provide better opportunities for \z
    operations.\n\z
    \n\z
    Below the tough surface are deposits of hard rock which make digging \z
    impossible in some areas. Water sources can also be found below \z
    ground.\n\z
    \n\z
    Rocky Ground - an area resembling the Grand Canyon, it has numerous \z
    overhangs, precipices and precarious rock formations. Below the \z
    surface are large areas of impenetrable rock. Very little water is \z
    evident near the surface but deep in the earth, water filled caverns \z
    abound."
  -- Page 35 --------------------------------------------------------------- --
  },{ T="The course of long dried up rivers has created series of \z
    interlocked caves and passages between rock layers. Lost cities are \z
    believed to be in this level, possibly haunted by their former \z
    occupants."
  -- Page 36 --------------------------------------------------------------- --
  },{ T="FLORA AND FAUNA\n\z
    \n\z
    The disappearance of the entire Frinklin Expedition of '95 dealt a \z
    severe blow to anthropological and botanical studies on the Planet \z
    Zarg. As a result, no conclusive report on Zarg's flora and fauna \z
    exists - the following notes and pictures have been taken from a \z
    variety of professional and eye witness reports - and it is certain \z
    that other plant and animal life exists on the planet. Please send \z
    details, samples or sketches of new life forms to Professor A. Mazon, \z
    Tower of Creepers, Attenborough Institute of Galactic Greenery."
  -- Page 37 --------------------------------------------------------------- --
  },{ T="Triffidus Carnivorous...\n\z
    \n\z
    Lives in jungle and forest areas\n\z
    where it blends in with other\n\z
    trees and foliage. Extremely\n\z
    ferocious carnivorous plant,\n\z
    possessing a large appetite. Can be\n\z
    identified by its unusual leaf colour.\n\z
    Upon capture and infra-red studying, one specimen's stomach was found \z
    to contain a beginner's guide to spotting dangerous plants and a pair \z
    of spectacles of a similar prescription to Dr Frinklin's.",
    I={ 10, 200.0, 15.0 }
  -- Page 38 --------------------------------------------------------------- --
  },{ T="Fungus Kaleidoscopus...\n\z
    \n\z
    Found on the surface in a\n\z
    variety of locations, these fungi grow\n\z
    in large clusters. Easily\n\z
    recognised by large red 'hat'\n\z
    with white spots. During a\n\z
    scientific study, results showed that eating the mushrooms can have a \z
    wide variety of effects upon some simply died, some became twice as \z
    strong while others seemed distracted and talked gibberish about pink \z
    giraffes.",
    I={ 11, 200.0, 15.0 }
  -- Page 39 --------------------------------------------------------------- --
  },{ T="\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Stegosaurus...\n\z
    \n\z
    Large dinosaur that lives in subterranean caves. Sandy coloured \z
    skin, two horns.\n\z
    Normally docile, Stegosaurus will charge if provoked or threatened. \z
    In narrow tunnels Stegosaurus is capable of",
    I={ 12, 96.0, 15.0 }
  -- Page 40 --------------------------------------------------------------- --
  },{ T="crushing victories over enemies.\n\z
    \n\z
    Rotorysaurus...\n\z
    \n\z
    A rather strange dinosaur, who inhabits the subterranean levels but \z
    occasionally strays to the surface of the planet. Generally considered \z
    to be rather placid; however, if provoked or attacked can turn and \z
    inflict severe damage on its aggressors.\n\z
    \n\z
    Velociraptor...\n\z
    \n\z
    A dinosaur of quite astounding viciousness. Needs absolutely no \z
    provocation to attack. Simply hates the..."
  -- Page 41 --------------------------------------------------------------- --
  },{ T="...sight of almost all other creatures, and although small in \z
    stature can deliver a blow with the strength of a Stegosaurus. Avoid \z
    at all costs. If encountered, run away very quickly, or lure into your \z
    opponent's mines, then run away."
  -- Page 42 --------------------------------------------------------------- --
  },{ T="\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Eggus Horribilis\n\z
    \n\z
    Provenance unknown. The only description of these eggs is supplied by \z
    a miner, now retired. His story is below.\n\z
    \n\z
    \"It was 'orrible. The guvnor said we should dig into",
    I={ 13, 96.0, 15.0 }
  -- Page 43 --------------------------------------------------------------- --
  },{ T="this bit of rock. Well, I don't mind telling you, I didn't like \z
    it, not one bit. Something was wrong you know, it wasn't quite right \z
    ... Anyway, not that I'm one to go on, we dug through this rock and \z
    found ourselves in a cave. I flashed the light around but it seemed \z
    empty. \"Let's go Bolbo,\" I said. \"Time for Grok break.\" Well he \z
    didn't come, he'd seen this dirty great egg. \"Leave it alone,\" I \z
    said, but he didn't listen. He picked it up and this thing leapt out \z
    at him. ooh it was 'orrible, it sort of absorbed itself into him. I \z
    couldn't watch, I turned and ran. It was a terrible thing, where's \z
    that bottle ...?\""
  -- Page 44 --------------------------------------------------------------- --
  },{ T="\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Woolly Mammals\n\z
    \n\z
    Large mammals who are thought to have lived on Zarg a million years \z
    ago. The frozen remains of one of these beasts was discovered one year \z
    ago and more may be discovered in a petrified condition in icy areas. \z
    Woolly",
    I={ 14, 96.0, 15.0 }
  -- Page 45 --------------------------------------------------------------- --
  },{ T="mammal meat has been eaten by starving Arctic explorers:\n\z
    \"Mnmn, just give me a ... second to stop mnmnmn ... chewing ...\"\n\z
    \"I think vegetarianism is about to get a new convert.\"\n\z
    \"Hommm, hommm, Lord Habborg, hommm, hommm.\""
  -- Page 46 --------------------------------------------------------------- --
  },{ T="\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Fish\n\z
    \n\z
    Many varieties of fish are believed to exist. However anglers' stories \z
    have proved somewhat unreliable. Few examples have ever been brought \z
    to the institute, \"it",
    I={ 15, 96.0, 15.0 }
  -- Page 47 --------------------------------------------------------------- --
  },{ T="got away\" - and accurate size estimates have proved impossible. \z
    Tales of the ferocious \"Pikosaurus\" must also be taken with a pinch \z
    of salt (and maybe freshly squeezed lemon)."
  -- Page 48 --------------------------------------------------------------- --
  },{ T="\n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    \n\z
    Sand Worms\n\z
    \n\z
    Large land-locked beasts of obscure gender. These shy creatures are \z
    believed to live deep underground, they are rarely seen and little is \z
    known of their behavioural patterns. The following is a Quarrior's \z
    account of his encounter with a sand worm.",
    I={ 16, 96.0, 15.0 }
  -- Page 49 --------------------------------------------------------------- --
  },{ T="\"We were minding our own business, tunnelling away quietly - \z
    well, as quiet as you can get with dynamite and suddenly the floor \z
    starts moving below me. I don't mind telling you that it confused me \z
    for a minute, I hardly had time to think before I fell back and \z
    cracked my head. Luckily that seemed to help and I realised it was one \z
    of them wormy things - big an' all, it was. Mind you I wasn't \z
    frightened, I grabbed a shovel and was about to take it on. \"Come \z
    on.\" I said to it, but it just sort of wormed its way down the tunnel \z
    and disappeared - I wonder if that's how it got its name, you know \z
    wormed? ... Anyway, I reckon they're chicken...\""
  -- Page 50 --------------------------------------------------------------- --
  },{ T="Mysterious sightings!\n\z
    \n\z
    Over the years, rumours have surfaced about strange ethereal beings \z
    inhabiting the caverns deep under the planet Zarg. Miners who have \z
    escaped back to the surface and who could retell their stories speak \z
    of slow moving ghostly apparitions attacking the group, killing the \z
    men, further stories talk of digger like creatures with great speed \z
    swooping down out of the roofs of large caverns and killing swiftly. \z
    Mining stories that are retold in the many bars on the planet, say \z
    that the Ghosts are from those miners who were left to die by claim \z
    jumpers, and the Zombies are the result of those ghosts' contact with \z
    living diggers."
  -- Page 51 --------------------------------------------------------------- --
  },{ T="Our advice is to avoid these supposed apparitions at all costs. \z
    Not that the authorities belleve in such things, you understand.\n\z
    \n\z
    Other strange reported sights include small 'alien' looking creatures \z
    who seem to be connected in some way with the Eggus Horribilus, \z
    sightings of these are unconfirmed as all scientific expeditions to \z
    investigate these rumours have failed to return. They could be \z
    dangerous!\n\z
    \n\z
    Scattered throughout the planet are moving portals, nicknamed \z
    Swirlyports. These unusual objects float gently through the \z
    subterranean world."
  -- Page 52 --------------------------------------------------------------- --
  },{ T="If a digger is caught in one of these he is instantly transported \z
    to a random area in the zone. The religious zealots of the Habbish are \z
    convinced that the Swirlyports are the spiritual remains of those \z
    Habbish who have not gained full enlightenment and are destined to \z
    wander the Planet Zarg in their present unfulfilled state. Other less \z
    spiritually minded diggers put them down to yet another wonder of this \z
    strange planet, and do not seek an explanation for their existence. A \z
    much more sensible approach, we think.\n\z
    \n\z
    Large areas of the planet remain uncharted and largely undiscovered, \z
    and for this reason the above details are no more than current \z
    intelligence. So take heed and be aware that there is always more than \z
    meets the eye."
  -- Page 53 --------------------------------------------------------------- --
  },{ T="THE MINING STORE\n\z
    \n\z
    A wide variety of mining equipment is available in the Mining Store. \z
    All the stock has been chosen by a veteran miner with detailed \z
    knowledge of the dangerous conditions underground. The majority of the \z
    equipment was bought at knockdown prices from a rocket boot sale on a \z
    small Earth territory called Britain, where mining is now a distant \z
    memory.\n\z
    \n\z
    When entering the Mining Store, the affable shopkeeper is only too \z
    happy to guide you through the buying process. His stock book \z
    contains prices and descriptions of all equipment in stock. A hologram \z
    of each piece of"
  -- Page 54 --------------------------------------------------------------- --
  },{ T="equipment automatically appears to enable the buyer to view his \z
    potential purchase.\n\z
    \n\z
    To choose a particular item, simply click on the appropriate symbol \z
    and its price will be automatically debited from your CASH account.\n\z
    \n\z
    i. Economic conditions can cause these prices to fluctuate dependent \z
       on availability of products.\n\z
    \n\z
    ii. The Management reserve the right to change everything and anything \z
        at anytime and without warning."
  -- Page 55 --------------------------------------------------------------- --
  },{ T="MINING EQUIPMENT\n\z
    \n\z
    Flood gates...\n\z
    \n\z
    Price: 80 credits.\n\z
    Weight: 10 groads.\n\z
    \n\z
    General Information: Flood gates can be opened or closed only by their \z
    installers. Extremely useful in areas with flash-flood dangers. Can be \z
    used to secure mining operations from rival diggers. Flood gates are \z
    extremely resilient to pressure and can withstand most digging \z
    machines, but they can be opened by large amounts of explosives",
    I={ 17, 196.0, 29.0 }
  -- Page 56 --------------------------------------------------------------- --
  },{ T="Telepole...\n\z
    \n\z
    \n\z
    \n\z
    Price: 260 credits.\n\z
    Weight: 12 groads.\n\z
    \n\z
    General Information: Possibly THE most vital piece of equipment for \z
    any digger. The telepole allows its user to travel between telepoles \z
    instantly. At the beginning of mining operations, each race of diggers \z
    is supplied with a teleport. Habbish can use any of the other diggers' \z
    telepoles. Other diggers can only use their telepoles.",
    I={ 18, 196.0, 29.0 }
  -- Page 57 --------------------------------------------------------------- --
  },{ T="Train Track...\n\z
    \n\z
    \n\z
    \n\z
    Price: 10 credits.\n\z
    Weight: 3 groads.\n\z
    \n\z
    General Information: Individual sections of train track are quite \z
    short, but are provided in lengths of 5. The weight given is for a \z
    pack of 5. Track must be positioned correctly. Once laid in position, \z
    it forms a permanent bond with the ground and cannot be moved, nor can \z
    it be dug through.",
    I={ 19, 196.0, 29.0 }
  -- Page 58 --------------------------------------------------------------- --
  },{ T="Automatic Mine Cart...\n\z
    \n\z
    \n\z
    \n\z
    Price: 100 credits.\n\z
    Weight: 8 groads.\n\z
    \n\z
    General Information: An ingenious self-propelling and self-steering \z
    mine cart capable of holding large amounts of minerals. Ideal for \z
    quick transport of diggers or minerals between locations.",
    I={ 20, 196.0, 29.0 }
  -- Page 59 --------------------------------------------------------------- --
  },{ T="Small Tunnelling Machine...\n\z
    \n\z
    \n\z
    \n\z
    Price: 150 credits.\n\z
    Weight: 8 groads.\n\z
    \n\z
    General Information: Cordless machine. Nicknamed 'the mole', this \z
    tunnelling machine is light and portable. Drills many times quicker \z
    than the fastest spade-wielding digger.",
    I={ 21, 196.0, 29.0 }
  -- Page 60 --------------------------------------------------------------- --
  },{ T="Single Bridge Bit...\n\z
    \n\z
    \n\z
    \n\z
    Price: 25 credits.\n\z
    Weight: 3 groads.\n\z
    \n\z
    General Information: Invaluable item to bridge streams and rivers. \n\z
    Extremely strong, can take heavy loads. Bridge bit must be securely \z
    anchored on firm ground. Bridges are vulnerable targets - caution must \z
    be exercised when crossing them.",
    I={ 22, 196.0, 29.0 }
  -- Page 61 --------------------------------------------------------------- --
  },{ T="Inflatable Boat...\n\z
    \n\z
    \n\z
    \n\z
    Price: 60 credits.\n\z
    Weight: 5 groads.\n\z
    \n\z
    General Information: Extremely durable crafts. Carrying capacity is \z
    limited to one digger. Unsuitable for rough seas or long voyages.",
    I={ 23, 196.0, 29.0 }
  -- Page 62 --------------------------------------------------------------- --
  },{ T="Vertical Digger...\n\z
    \n\z
    \n\z
    \n\z
    Price: 170 credits.\n\z
    Weight: 10 groads.\n\z
    \n\z
    General Information: Nicknamed 'the corkscrew' because of its drilling \z
    action. This machine can only be used to dig vertically downwards. \z
    Once started, the 'corkscrew' continues drilling automatically for a \z
    set period of time or until it hits an obstacle. Beware using this \z
    equipment in watery areas.",
    I={ 24, 196.0, 29.0 }
  -- Page 63 --------------------------------------------------------------- --
  },{ T="Large Tunnelling Machine...\n\z
    \n\z
    \n\z
    \n\z
    Price: 230 credits.\n\z
    Weight: 11 groads.\n\z
    \n\z
    General Information: Better known as the 'Monster' this machine is a \z
    formidable digging tool.\n\z
    Able to dig through rocks extremely quickly. Extreme caution should be \z
    exercised when operating the 'Monster'. Point at surface to be \z
    drilled and start up. Do not stand in front of the 'Monster' at any \z
    time.",
    I={ 25, 196.0, 29.0 }
  -- Page 64 --------------------------------------------------------------- --
  },{ T="Explosives...\n\z
    \n\z
    \n\z
    \n\z
    Price: 20 credits.\n\z
    Weight: 4 groads.\n\z
    \n\z
    General Information: WARNING: Handle with care.\n\z
    Vital equipment for blasting through solid rocks or for entering a \z
    rivals' mine.\n\z
    There is very little margin for error when using explosives, mistakes \z
    are often fatal!",
    I={ 26, 196.0, 29.0 }
  -- Page 65 --------------------------------------------------------------- --
  },{ T="Lift...\n\z
    \n\z
    \n\z
    Price: 220 credits.\n\z
    Weight: 12 groads.\n\z
    \n\z
    General Information: Extremely useful for transporting large amounts \z
    of minerals, equipment or diggers between successful seam and mine \z
    head. Once in position, the lift is permanently sited and cannot be \z
    moved to another location. Lift must be installed correctly - the head \z
    block at the top of the lift and the foot block at the bottom MUST be \z
    firmly anchored in a block of plain earth. Without these elements in \z
    the correct position, the lift will refuse to function.",
    I={ 27, 196.0, 29.0 }
  -- Page 66 --------------------------------------------------------------- --
  },{ T="TNT Map...\n\z
    \n\z
    \n\z
    \n\z
    Price: 215 credits.\n\z
    Weight: 3 groads.\n\z
    \n\z
    General Information: Probably the most useful item a digger can have, \z
    apart from the guide! Utilising the special abilities of TNT paper, \z
    the map shows the entire zone with all its features and is constantly \z
    updated.",
    I={ 28, 196.0, 29.0 }
  -- Page 67 --------------------------------------------------------------- --
  },{ T="First Aid Kit...\n\z
    \n\z
    \n\z
    \n\z
    Price: 60 credits.\n\z
    Weight: 5 groads.\n\z
    \n\z
    General Information: Once purchased, the healing powers of the kit \z
    will slowly replenish the stamina of the digger holding it. It is \z
    possible to give the kit to another digger who may benefit from any \z
    remaining \'medicine\'.",
    I={ 29, 196.0, 29.0 }
  -- Page 68 --------------------------------------------------------------- --
  },{ T="ZARGON BANK\n\z
    \n\z
    Recently strengthened by a merger with the Badland Bank, the Zargon \z
    Bank has gone from strength to strength and has expanded its \z
    operations to include stock market facilities. The Zargon Bank now \z
    controls all money transactions on the planet and has devised a \z
    savings plan for all its customers. The slightly unusual thing about \z
    this plan is that it is mandatory.\n\z
    \n\z
    When a digger opens a current CASH account, the bank opens a savings \z
    STASH account for that customer. The bank will then automatically \z
    transfer a percentage of all CASH and save it in the STASH account."
  -- Page 69 --------------------------------------------------------------- --
  },{ T="Money cannot be taken from the STASH account until a digger wishes \z
    to leave the planet.\n\z
    \n\z
    A Bank spokescreature, explained \"It's an insurance policy against \z
    customers absconding from the planet and leaving us with debts.\"\n\z
    \n\z
    When a mining operation is first started, the Bank is quite prepared \z
    to make a loan of 100 credits to the Master Miner. However, the Master \z
    Miner must repay the loan at the end of each successful digging \z
    operation within a zone."
  -- Page 70 --------------------------------------------------------------- --
  },{ T="The Bank is then prepared to make up any deficit that a Master \z
    Miner may have, when starting the next Zone, to ensure that they have at \z
    least 100 credits. Obviously, if the Master Miner has more than 100 \z
    credits already, then they will not require the services of the Bank in \z
    providing a loan.\n\z
    \n\z
    The Bank also operates a generous Trade-in policy for capital \z
    equipment, (lifts, mining machines, etc). Assuming a Master Miner is \z
    successful in completing a mining area, they would not wish to leave \z
    behind all the equipment purchased to complete their operations. \z
    Therefore, the Bank arranges for its valuers to visit the mine, \z
    remove the equipment, and pay about 75% of its value, assuming it is \z
    in a salvageable condition, to the Master Miner. "
  -- Page 71 --------------------------------------------------------------- --
  },{ T="This ensures that the Master Miner sees some return on his \z
    investment in equipment. This amount is carried forward without further \z
    deductions when spending on the next zone. Also the Bank makes an \z
    extremely large profit selling the equipment as new back to other mining \z
    operations, but of course that is only a vicious rumour spread about by \z
    disgruntled, bankrupt miners."
  -- Page 72 --------------------------------------------------------------- --
  },{ T="ZARGON STOCK MARKET\n\z
    \n\z
    The Zargon Stock Market follows the rules of supply and demand like \z
    all other stock markets. It is linked to a network of other markets \z
    throughout the galaxy, as a result mineral trading and mineral prices \z
    are often affected by dealings and incidents on other planets.\n\z
    \n\z
    Above the bank tellers is a display showing the minerals or jewels \z
    currently being traded by that teller. Selecting the display shows \z
    you the value for that mineral or jewel. Selecting the teller will \z
    enable you to sell any mineral or jewel that you may have."
  -- Page 73 --------------------------------------------------------------- --
  },{ T="No other minerals or jewels will be bought at that time but the \z
    bank's dealing interests are flexible and it will buy other minerals \z
    at other times. Prices too are constantly changing in response to the \z
    law of supply and demand. For example: a big find of gold will flood \z
    the market and lower the gold's value.\n\z
    \n\z
    One precious stone always retains its value; however, Jennite, a pink \z
    jewel, is extremely rare and hence very valuable and so you will find \z
    that any of the tellers will be keen to trade in it at all times."
  -- Page 74 --------------------------------------------------------------- --
  },{ T="ZARGON MINING HISTORY\n\z
    \n\z
    The history of the planet Zarg is as colourful as the jewels that have \z
    been mined from below its surface. Its legendary riches have attracted \z
    an enormous number of space jetsam and flotsam, diggers, bounty \z
    hunters and other get rich quick merchants.\n\z
    \n\z
    Unfortunately, the planet does not give up its wealth easily and very \z
    few have left richer than when they arrived. Indeed, many have not \z
    left at all. The cause of Zarg's wealth is also the cause of many \z
    mining problems. The underground riches are caused by violent volcanic \z
    and tectonic activity that convulse the planet for eight months a year."
  -- Page 75 --------------------------------------------------------------- --
  },{ T="While this regenerates mineral wealth below the surface, it \z
    destroys most structures above ground. The remains of many lost cities \z
    and civilisations are believed to be deep underground, where they were \z
    swallowed up by the planet's upheavals."
  -- Page 76 --------------------------------------------------------------- --
  },{ T="DAYLIGHT ROBBERY\n\z
    \n\z
    The Zargon Bank has been the subject of many attempted robberies. The \z
    most successful robbery was carried out by the legendary jewel thief \z
    Larson E.\n\z
    \n\z
    Wearing a disguise and relying on sharp wits, Larson E. posed as a \z
    trouble shooter sent by the President of Interplanetary Banks Inc to \z
    check their security systems. So convincing was he that the staff gave \z
    him a guided tour, showing their alarms and giving him code numbers."
  -- Page 77 --------------------------------------------------------------- --
  },{ T="That night the bank robber returned to make good use of the \z
    information. When the staff opened up in the morning they found the \z
    vaults empty and the following note.\n\z
    \n\z
    \"It wasn't me,\n\z
    It was D.A. Lite & Rob Berry.\n\z
    He he he,\n\z
    Thanks for the rocks suckers.\"\n\z
    \n\z
    Larson E.",
    I={ 30, 212.0, 74.0 }
  -- Page 78 --------------------------------------------------------------- --
  },{ T="THE CRASH OF '94\n\z
    \n\z
    Also known as Black Tuesday (not to be confused with blank Tuesday \z
    when all the dealing systems failed - a F'Targ was later sacked for \z
    taking micro chips from machines. His excuse \"they're for my \z
    collection\" was deemed unacceptable) the bank was rocked to its \z
    foundations when a runaway 'Monster', digging machine smashed into the \z
    underground vaults.\n\z
    \n\z
    Millions of credits went missing and the thieves were never traced, \z
    although for the entire following month no Grablin was seen vertical."
  -- Page 79 --------------------------------------------------------------- --
  },{ T="Ancient Mining Advice and Player Tips...\n\z
    \n\z
    Past digging expeditions have often returned with records of what \z
    appears to be ancient mining graffiti etched into cavern walls. The \z
    apparent purpose of the graffiti being to inform and advise miners who \z
    may follow in the artist's footsteps."
  -- Page 80 --------------------------------------------------------------- --
  },{ T="The key points being:\n\z
      \n\z
    - If you are impatient for riches you will reap more by mining in strips \z
      than deep shafts.\n\z
      \n\z
    - Use bridges wisely as they can not only cross water but will \z
      empower you to jump higher and further.\n\z
      \n\z
    - Don't exhaust yourself trying to dig through the immovable, blow the \z
      darn thing out with explosives, but mind you don't flood yourself in \z
      the process. However you can't blow an escape route out of the zone."
  -- Page 81 --------------------------------------------------------------- --
  },{ T="- Blood lust and killing may wipe out your trade; the Zargan Bank \z
      trades in Zogs not bodies, so dig for gems not revenge.\n\z
    \n\z
    Other than this sound advice you would be well advised to:\n\z
      \n\z
    - Save the game every time you have completed a zone.\n\z
      \n\z
    - Always trade jewels at the bank immediately to maximise your wealth \z
      against that of your opponent, and to prevent theft of jewels below \z
      ground.\n\z
    \n\z
    - Always be mindful of the capital value of all equipment. They can \z
      prove extremely useful as assets to be traded to start a new zone."
  }
};
-- Imports and exports ----------------------------------------------------- --
return { F = Util.Blank, A = { aBookData_en = aBookData } };
-- End-of-File ============================================================= --
