-- ASSETS.LUA ============================================================== --
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
-- Assets metadata --------------------------------------------------------- --
local oAssetsData<const> = {
  -- Explanation ----------------------------------------------------------- --
  -- T = Type value for LoadResources() from aTypes{} table in main.hpp.
  -- F = The base file name of the asset
  -- P = The parameters to send to the second stage handle loader function.
  -- Sprites --------------------------------------------------------------- --
  sprites = { T=1, F="sprites", P={ 16, 16, 0, 0, 0 } },
  -- Large font data ------------ TW  TH  PX  PY  TF  CT  CS  CD ----------- --
  font16 = { T=3, F="font16", P={ 20, 20,  4,  4,  0, 96, 32, 63,
    -- 032 033 034 035 036 037 038 039 040 041 042 043 044 045 046 047 048 049
    --      !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /   0   1
    {   4,  5,  8, 11,  9, 11, 10,  4,  5,  5,  9,  9,  4, 13,  3, 11, 13, 12,
    -- 050 051 052 053 054 055 056 057 058 059 060 061 062 063 064 065 066 067
    --  2   3   4   5   6   7   8   9   :   ;   <   =   >   ?   @   A   B   C
       13, 14, 13, 13, 13, 13, 13, 13,  3, 13, 11, 12, 11, 13, 13, 16, 16, 13,
    -- 068 069 070 071 072 073 074 075 076 077 078 079 080 081 082 083 084 085
    --  D   E   F   G   H   I   J   K   L   M   N   O   P   Q   R   S   T   U
       15, 16, 16, 15, 16, 15, 13, 16, 15, 17, 17, 13, 16, 16, 17, 14, 16, 16,
    -- 086 087 088 089 090 091 092 093 094 095 096 097 098 099 100 101 102 103
    --  V   W   X   Y   Z   [   \   ]   ^   _   `   a   b   c   d   e   f   g
       16, 16, 16, 16, 16,  9, 12,  9, 12, 12,  8, 16, 15, 14, 15, 14, 14, 14,
    -- 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121
    --  h   i   j   k   l   m   n   o   p   q   r   s   t   u   v   w   x   y
       15,  9, 13, 15, 13, 16, 15, 13, 14, 15, 14, 14, 14, 14, 12, 16, 12, 15,
    -- 122 123 124 125 126 127
    --  z   {   |   }   ~   �
       14, 10,  7, 10, 11, 11 } } },
  -- Small font data ---------- TW  TH  PX  PY  TF  CT  CS  CD  AUTOFILL --- --
  font8 = { T=3, F="font8", P={  6,  8,  2,  4,  0, 96, 32, 63, {} } },
  -- Tiny font data ----------- TW  TH  PX  PY  TF  CT  CS  CD  AUTOFILL --- --
  font5 = { T=3, F="font5", P={  4,  6,  4,  2,  0, 96, 32, 63, {} } },
  -- Speech font data ----------- TW  TH  PX  PY  TF  CT  CS  CD ----------- --
  font10 = { T=3, F="font10", P={  8, 11,  0,  0,  0,308, 32, 63,
    -- 032 033 034 035 036 037 038 039 040 041 042 043 044 045 046 047 048 049
    --      !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /   0   1
    {   2,  2,  4,  7,  4,  8,  6,  2,  4,  4,  7,  6,  2,  5,  2,  5,  5,  4,
    -- 050 051 052 053 054 055 056 057 058 059 060 061 062 063 064 065 066 067
    --  2   3   4   5   6   7   8   9   :   ;   <   =   >   ?   @   A   B   C
        4,  4,  5,  4,  4,  4,  4,  4,  2,  3,  5,  6,  5,  5,  8,  5,  5,  5,
    -- 068 069 070 071 072 073 074 075 076 077 078 079 080 081 082 083 084 085
    --  D   E   F   G   H   I   J   K   L   M   N   O   P   Q   R   S   T   U
        5,  5,  5,  6,  6,  4,  6,  6,  5,  6,  6,  5,  5,  5,  6,  5,  6,  5,
    -- 086 087 088 089 090 091 092 093 094 095 096 097 098 099 100 101 102 103
    --  V   W   X   Y   Z   [   \   ]   ^   _   `   a   b   c   d   e   f   g
        6,  6,  6,  6,  5,  3,  5,  3,  4,  4,  3,  4,  4,  4,  4,  4,  4,  4,
    -- 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121
    --  h   i   j   k   l   m   n   o   p   q   r   s   t   u   v   w   x   y
        4,  2,  4,  5,  2,  6,  4,  4,  4,  4,  4,  4,  4,  4,  4,  6,  4,  4,
    -- 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139
    --  z   {   |   }   ~   ⌂   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?
        4,  4,  2,  4,  6,  6,  5,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,
    -- 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157
    --  ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?
        4,  4,  4,  2,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,
    -- 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175
    --  ?   ?   ?   ¡   ¢   £   ¤   ¥   ¦   §   ¨   ©   ª   «   ¬   ?   ®   ¯
        4,  4,  4,  2,  5,  5,  6,  4,  2,  4,  4,  8,  4,  5,  4,  1,  8,  4,
    -- 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193
    --  °   ±   ²   ³   ´   µ   ¶   ·   ¸   ¹   º   »   ¼   ½   ¾   ¿   À   Á
        4,  4,  4,  4,  4,  4,  0,  4,  4,  4,  4,  5,  8,  8,  8,  5,  5,  5,
    -- 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211
    --  Â   Ã   Ä   Å   Æ   Ç   È   É   Ê   Ë   Ì   Í   Î   Ï   Ð   Ñ   Ò   Ó
        5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  4,  4,  4,  4,  6,  6,  5,  5,
    -- 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229
    --  Ô   Õ   Ö   ×   Ø   Ù   Ú   Û   Ü   Ý   Þ   ß   à   á   â   ã   ä   å
        5,  5,  5,  4,  7,  5,  5,  5,  5,  6,  4,  5,  4,  4,  4,  5,  4,  4,
    -- 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247
    --  æ   ç   è   é   ê   ë   ì   í   î   ï   ð   ñ   ò   ó   ô   õ   ö   ÷
        4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  5,  4,  4,  4,  5,  4,  4,
    -- 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265
    --  ø   ù   ú   û   ü   ý   þ   ÿ   ?   œ   ?   ?   ?   ?   ?   ?   ?   ?
        6,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,
    -- 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283
    --  ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?
        4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,
    -- 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301
    --  ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?
        4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,
    -- 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319
    --  ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?
        4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,
    -- 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337
    --  ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?   ?
        4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,
    -- 338 339
    --  ?   œ
        4,  6 } } },
  -- intro.lua ------------------------------------------------------------- --
  intro = { T = 8, F = "intro" },
  -- intro.lua, title.lua, tcredits.lua ------------------------------------ --
  title = { T = 10, F = "title", P = { 0, {
      0,   0, 512, 240, -- [00] Zarg background
    227, 240,  58, 208, -- [01] Diggers box logo used for scrolling
      0, 240, 162,  41, -- [02] Diggers title logo
      0, 344, 150, 168, -- [03] Quit game sign post button
    344, 344, 168, 168, -- [04] Start game sign post button
    496, 240,  16,  16, -- [05] Intro tile to cover sides
  } } },
  -- tcredit.lua ----------------------------------------------------------- --
  titlem = { T = 7, F = "title" },
  -- cntrl.lua, file.lua, lobby.lua, race.lua ------------------------------ --
  lobbyc = { T = 10, F = "lobbyc", P = { 0, {
      0,   0, 304, 200, -- [00] Lobby graphic
      0, 200, 238,  56, -- [01] Foliage graphic left
    305,  75, 207, 184, -- [02] Foliage graphic right
    324,   0,  94,  74, -- [03] Fire animation graphic B
    418,   0,  94,  74  -- [04] Fire animation graphic C
  } } },
  -- file.lua -------------------------------------------------------------- --
  file = { T = 2, F = "file", P = { 0 } },
  -- cntrl.lua ------------------------------------------------------------- --
  cntrl = { T = 10, F = "cntrl",  P = { 0, {
      0,   0, 304, 200, -- [00] Controller background screen
    164, 200, 156,  23, -- [01] Controller speech bubble
    376,   0, 136,  82, -- [02] Controller talking <2/4> (1/4 in tile 0)
    376,  82, 136,  82, -- [03] Controller talking <3/4>
    376, 164, 136,  82, -- [04] Controller talking <4/4>
    304,  44,  28,  18, -- [05] Fish swimming <2/5> (1/5 in tile 0)
    332,  44,  28,  18, -- [06] Fish swimming <3/5>
    304,  62,  28,  18, -- [07] Fish swimming <4/5>
    332,  62,  28,  18, -- [08] Fish swimming <5/5>
    311,   0,  45,  40, -- [09] Map flashing <2/2> (1/2 in tile 0)
    356,   0,  20,  44, -- [10] Race flashing <2/2> (1/2 in tile 0)
     90, 200,  74,  31, -- [11] Book flashing <2/2> (1/2 in tile 0)
      0, 200,  90,  26, -- [12] File flashing <2/2> (1/2 in tile 0)
  } } },
  -- scene.lua ------------------------------------------------------------- --
  scene = { T = 2, F = false, P = { 0 } }, -- File filled in at runtime
  scenez = { T = 2, F = "scene", P = { 0 } },
  -- end.lua, ending.lua, scene.lua ---------------------------------------- --
  scenem = { T = 7, F = "select" },
  -- shop.lua -------------------------------------------------------------- --
  shopm = { T = 7, F = "shop" },
  shop = { T = 10, F = "shop", P = { 0, {
      0,   0,  65,  65, -- [00] Flood gate hologram
     66,   0,  65,  65, -- [01] Train for rails hologram
    132,   0,  65,  65, -- [02] Lift hologram
    198,   0,  65,  65, -- [03] Explosives hologram
    264,   0,  65,  65, -- [04] Large tunneller hologram
    330,   0,  65,  65, -- [05] Corkscrewn hologram
    396,   0,  65,  65, -- [06] TNT map hologram
      0,  66,  65,  65, -- [07] Inflatable boat hologram
     66,  66,  65,  65, -- [08] Bridge piece hologram
    132,  66,  65,  65, -- [09] Small tunneller hologram
    198,  66,  65,  65, -- [10] Track for train hologram
    264,  66,  65,  65, -- [11] Telepole hologram
    330,  66,  65,  65, -- [12] First-ad hologram
    396,  66,  65,  65, -- [13] Holographic animation <1/7>
      0, 132,  65,  65, -- [14] Holographic animation <2/7>
     66, 132,  65,  65, -- [15] Holographic animation <3/7>
    132, 132,  65,  65, -- [16] Holographic animation <4/7>
    198, 132,  65,  65, -- [17] Holographic animation <5/7>
    264, 132,  65,  65, -- [18] Holographic animation <6/7>
    330, 132,  65,  65, -- [19] Holographic animation <7/7>
    208, 312, 304, 200, -- [20] Shop background
      0, 418, 112,  23, -- [21] Shopkeeper speech bubble
      0, 264,  48,  48, -- [22] Shopkeeper talking animation <1/4>
     49, 264,  48,  48, -- [23] Shopkeeper talking animation <2/4>
     98, 264,  48,  48, -- [24] Shopkeeper talking animation <3/4>
    147, 264,  48,  48, -- [25] Shopkeeper talking animation <4/4>
      0, 442, 128,  70, -- [26] Shop product display panel
    196, 264,  54,  39, -- [27] Holographic emitter device
    345, 282,  55,  28, -- [28] Floor lights animation <1/3>
    401, 282,  55,  28, -- [29] Floor lights animation <2/3>
    457, 282,  55,  28, -- [30] Floor lights animation <3/3>
    313, 220,  39,  20, -- [31] Warehouse door animation <1/15>
    353, 220,  39,  20, -- [32] Warehouse door animation <2/15>
    393, 220,  39,  20, -- [33] Warehouse door animation <3/15>
    433, 220,  39,  20, -- [34] Warehouse door animation <4/15>
    473, 220,  39,  20, -- [35] Warehouse door animation <5/15>
    313, 241,  39,  20, -- [36] Warehouse door animation <6/15>
    353, 241,  39,  20, -- [37] Warehouse door animation <7/15>
    393, 241,  39,  20, -- [38] Warehouse door animation <8/15>
    433, 241,  39,  20, -- [39] Warehouse door animation <9/15>
    473, 241,  39,  20, -- [40] Warehouse door animation <10/15>
    313, 262,  39,  20, -- [41] Warehouse door animation <11/15>
    353, 262,  39,  20, -- [42] Warehouse door animation <12/15>
    393, 262,  39,  20, -- [43] Warehouse door animation <13/15>
    433, 262,  39,  20, -- [44] Warehouse door animation <14/15>
    473, 262,  39,  20, -- [45] Warehouse door animation <15/15>
      0, 313,  64,  32, -- [46] Forklift truck moving animation <1/11>
     65, 313,  64,  32, -- [47] Forklift truck moving animation <2/11>
    130, 313,  64,  32, -- [48] Forklift truck moving animation <3/11>
      0, 346,  64,  32, -- [49] Forklift truck moving animation <4/11>
     65, 346,  64,  32, -- [50] Forklift truck moving animation <5/11>
    130, 346,  64,  32, -- [51] Forklift truck moving animation <6/11>
      0, 379,  64,  32, -- [52] Forklift truck moving animation <7/11>
     65, 379,  64,  32, -- [53] Forklift truck moving animation <8/11>
    130, 379,  64,  32, -- [54] Forklift truck moving animation <9/11>
    137, 412,  64,  32, -- [55] Forklift truck moving animation <10/11>
    137, 445,  64,  32, -- [56] Forklift truck moving animation <11/11>
  } } },
  -- bank.lua -------------------------------------------------------------- --
  bankm = { T = 7, F = "bank" },
  bank = { T = 10, F = "bank", P = { 0, {
      0,   0, 304, 200, -- [00] Bank background scene
      0, 200, 112,  23, -- [01] Banker speech bubble
    304,   0,  63,  88, -- [02] Grablin banker talking <2/4> (1/4 in tile 0)
    367,   0,  63,  88, -- [03] Grablin banker talking <3/4>
    430,   0,  63,  88, -- [04] Grablin banker talking <4/4>
    304,  88,  63,  88, -- [05] Habbish banker talking <2/4> (1/4 in tile 0)
    367,  88,  63,  88, -- [06] Habbish banker talking <3/4>
    430,  88,  63,  88, -- [07] Habbish banker talking <4/4>
    304, 176,  63,  88, -- [08] F'Targ banker talking <2/4> (1/4 in tile 0)
    367, 176,  63,  88, -- [09] F'Targ banker talking <3/4>
    430, 176,  63,  88  -- [10] F'Targ banker talking <4/4>
  } } },
  -- book.lua -------------------------------------------------------------- --
  bookcover = { T = 10, F = "bookcover", P = { 0, {
      0,   0, 304, 200, -- [00] Book cover
  } } },
  bookpage = { T = 10, F = "bookpage", P = { 0, {
      0,   0, 304, 200, -- [00] Blank page
    624,   0,  16, 111, -- [01] Control icons (Page 14)
    608,   0,  16, 150, -- [02] Control icons (Page 15)
    576, 150,  64, 153, -- [03] Control icons (Page 16)
      0, 521, 162, 119, -- [04] Hud (Page 17)
    499, 313, 141,  90, -- [05] Characteristic icons (Page 18)
    160, 200,  84,  99, -- [06] Habbish (Page 23)
     75, 200,  85, 102, -- [07] Grablin (Page 26)
    244, 200,  81,  76, -- [08] Quarrior (Page 28)
      0, 200,  74, 109, -- [09] F'Targ (Page 30)
      0, 309,  92, 100, -- [10] Pirana Plant (Page 38)
     92, 303,  91,  92, -- [11] Mushroom (Page 39)
    304,   0, 176, 102, -- [12] Stegosaurus (Page 40)
    304, 102, 168,  97, -- [13] Eggs (Page 43)
      0, 409, 164, 101, -- [14] Mammoth (Page 45)
    325, 199, 186, 114, -- [15] Sailor (Page 47)
    184, 300, 156,  97, -- [16] Worm (Page 49)
    191, 522,  53,  52, -- [17] Flood Gate (Page 57)
    458, 590,  47,  47, -- [18] Telepole (Page 58)
    389, 595,  53,  37, -- [19] Track for train (Page 60)
    256, 534,  55,  37, -- [20] Train for rails (Page 61)
    324, 592,  50,  40, -- [21] Small tunneller (Page 62)
    257, 589,  53,  50, -- [22] Bridge (Page 63)
    190, 588,  54,  51, -- [23] Boat (Page 64)
    525, 523,  46,  47, -- [24] Corkscrew (Page 65)
    454, 525,  54,  41, -- [25] Large tunneller (Page 67)
    391, 523,  45,  48, -- [26] Explosives (Page 68)
    324, 520,  51,  53, -- [27] Lift (Page 69)
    588, 524,  51,  45, -- [28] Map (Page 71)
    526, 594,  44,  36, -- [28] First-aid kit (Page 72)
    480,   0,  76,  84, -- [29] Wanted (Page 82)
  } } },
  -- book.lua, lobby.lua, cntrl.lua, race.lua, ending.lua ------------------ --
  zmtc = { T = 2, F = "zmtc", P = { 0 } },
  -- book.lua, lobby.lua --------------------------------------------------- --
  lobbym = { T = 7, F = "lobby" },
  -- lobby.lua ------------------------------------------------------------- --
  lobbyo = { T = 10, F = "lobbyo", P = { 0, {
      0,   0, 304, 200, -- [00] Lobby open graphic
    304,   0,  94,  74, -- [01] Fire animation graphic <2/3> (1/3 in tile 0)
    304,  74,  94,  74  -- [02] Fire animation graphic <3/3>
  } } },
  -- map.lua --------------------------------------------------------------- --
  map = { T = 10, F = "map", P = { 0, {
      0,   0, 672, 350, -- [00] Operations map
    640,   0,  32,  32, -- [01] Completion flag
    640,  32,  32,  32  -- [02] Selection flag
  } } },
  -- race.lua -------------------------------------------------------------- --
  race = { T = 10, F = "race", P = { 0, {
      0,   0, 304, 200, -- [00] Race page background
    320,   0,  64, 128, -- [01] F'Targ portrait
    384,   0,  64, 128, -- [02] Habbish portrait
    448,   0,  64, 128, -- [03] Grablin portrait
    320, 128,  64, 128, -- [04] Quarrior portrait
    384, 128,  64, 128, -- [05] Selected race stamp
      0, 200, 160,  16, -- [06] F'Targ label
      0, 216, 160,  16, -- [07] Habbish label
      0, 232, 160,  16, -- [08] Grablin label
    160, 200, 160,  16, -- [09] Quarrior label
    304,   0,  16,  16, -- [09] First-aid special indicator
    304,  16,  16,  16, -- [10] Digging special indicator
    304,  32,  16,  16, -- [11] Teleport special indicator
    304,  48,  16,  16  -- [12] Strength special indicator
  } } },
  -- game.lua -------------------------------------------------------------- --
  mapt = { T = 5, F = false },
  mapo = { T = 11, F = false },
  game = { T = 1, F = false, P = { 16, 16, 0, 0, 0 } },
  gamem = { T = 7, F = "game" },
  gamecm = { T = 7, F = false },
  -- end.lua, lose.lua ----------------------------------------------------- --
  losem = { T = 7, F = "lose" },
  -- tntmap.lua ------------------------------------------------------------ --
  tntmap = { T = 2, F = "tntmap", P = { 0 } },
  -- score.lua ------------------------------------------------------------- --
  scorem = { T = 7, F = "score" },
  -- end.lua, post.lua ----------------------------------------------------- --
  post = { T = 10, F = "end", P = { 0, {
      0,   0, 159,  95, -- [00] All player diggers died (lose)
    159,   0, 159,  95, -- [01] All opponent diggers died (win)
    318,   0, 159,  95, -- [02] Player raised the cash (win)
      0,  95, 159,  95, -- [03] Opponent raised the cash (lose)
    208, 232, 304,  24  -- [04] Map post mortem status graphic
  } } },
  -- post.lua -------------------------------------------------------------- --
  postm = { T = 7, F = "win" },
  -- ending.lua ------------------------------------------------------------ --
  ending2 = { T = 1, F = false, P = { 428, 240, 0, 0, 0 } },
  ending3 = { T = 8, F = "outro" },
  -- credit.lua ------------------------------------------------------------ --
  credits = { T = 2, F = "vignette", P = { 0 } },
  -- setup.lua ------------------------------------------------------------- --
  setupm = { T = 7, F = "setup" }
};-- End ------------------------------------------------------------------- --
-- Base code scripts that are to be loaded (don't modify the order)
local aBaseScripts<const> = {
  { T=9, F="data"    }, { T=9, F="blit"    }, { T=9, F="input"   },
  { T=9, F="audio"   }, { T=9, F="bank"    }, { T=9, F="book"    },
  { T=9, F="book-de" }, { T=9, F="book-en" }, { T=9, F="book-fr" },
  { T=9, F="book-it" }, { T=9, F="cntrl"   }, { T=9, F="credit"  },
  { T=9, F="debug"   }, { T=9, F="editor"  }, { T=9, F="end"     },
  { T=9, F="ending"  }, { T=9, F="fail"    }, { T=9, F="file"    },
  { T=9, F="game"    }, { T=9, F="intro"   }, { T=9, F="lobby"   },
  { T=9, F="map"     }, { T=9, F="pause"   }, { T=9, F="post"    },
  { T=9, F="race"    }, { T=9, F="scene"   }, { T=9, F="score"   },
  { T=9, F="shop"    }, { T=9, F="title"   }, { T=9, F="tcredit" },
  { T=9, F="tntmap"  }, { T=9, F="setup"   },
};
-- Base fonts that are to be loaded (and scaled) --------------------------- --
local aBaseFonts<const> = { oAssetsData.font16, oAssetsData.font8,
  oAssetsData.font5, oAssetsData.font10 };
local aBaseTextures<const> = { oAssetsData.sprites };
-- Base masks that are to be loaded ---------------------------------------- --
local aBaseMasks<const> = {
  { T=6, F="lmask", P={ 16, 16 } },
  { T=6, F="smask", P={ 16, 16 } }
};
-- Base sound effects that are to be loaded -------------------------------- --
local aBaseSounds<const> = {
  { T=4, F="click"    }, { T=4, F="dftarg"   }, { T=4, F="dgrablin" },
  { T=4, F="dhabbish" }, { T=4, F="dquarior" }, { T=4, F="dig"      },
  { T=4, F="alert"    }, { T=4, F="tnt"      }, { T=4, F="gem"      },
  { T=4, F="gclose"   }, { T=4, F="gopen"    }, { T=4, F="jump"     },
  { T=4, F="punch"    }, { T=4, F="teleport" }, { T=4, F="kick"     },
  { T=4, F="select"   }, { T=4, F="sale"     }, { T=4, F="switch"   },
  { T=4, F="hololoop" }, { T=4, F="holo"     }
};
-- Add all these to all the base assets to load ---------------------------- --
local aBaseAssetsCategories<const> =
  { aBaseScripts, aBaseFonts, aBaseTextures, aBaseMasks, aBaseSounds };
-- Build base assets to load ----------------------------------------------- --
local aBaseAssets<const> = { };
for iBaseIndex = 1, #aBaseAssetsCategories do
  local aAssets<const> = aBaseAssetsCategories[iBaseIndex];
  for iAssetIndex = 1, #aAssets do
    aBaseAssets[1 + #aBaseAssets] = aAssets[iAssetIndex];
  end
end
-- Calculate starting indexes of each base asset --------------------------- --
local iBaseScripts<const> = 1;
local iBaseFonts<const> = iBaseScripts + #aBaseScripts;
local iBaseTextures<const> = iBaseFonts + #aBaseFonts;
local iBaseMasks<const> = iBaseTextures + #aBaseTextures;
local iBaseSounds<const> = iBaseMasks + #aBaseMasks;
-- Return all the assets data to main.lua ---------------------------------- --
return oAssetsData, aBaseAssets, iBaseScripts, iBaseFonts,
       iBaseTextures, iBaseMasks, iBaseSounds, aBaseSounds;
-- End-of-File ============================================================= --
