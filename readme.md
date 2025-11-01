![Diggers logo](/docs/diggers.png?raw=true "Diggers logo")

# Diggers Fan Remake for MacOS, Linux and Windows

## Contents…
 1. [Screenshots](#screenshots)…
 2. [About](#about)…
 3. [System Requirements](#system-requirements)…
 4. [Downloading](#downloading)…
 5. [Running](#running)…
 6. [Story](#story)…
 7. [Objectives](#objectives)…
 8. [Setup](#setup)…
 9. [Controls](#controls)…
10. [Advanced](#advanced)…
11. [Modding](#modding)…
12. [FAQ](#faq)…
13. [Credits](#credits)…
14. [Contributing](#contributing)…

## Screenshots…
![Screenshots](/docs/diggers.webp?raw=true "Screenshots")

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## About…
Diggers is a puzzle video game for the Amiga CD32 in which the player takes control of a mining team excavating a planet for precious minerals. It was later released for the Amiga 1200 and DOS. Diggers was bundled with the CD32 at launch, along with a 2D platformer entitled Oscar on the same CD. A sequel, Diggers 2: Extractors, was released for DOS in 1995.

The game is set on the planet Zarg, where four races are vying for the gems and ores buried there. The four races are: the Habbish, who dig quickly and have high endurance, yet are impatient and prone to wander off; Grablins, who dig the fastest, have good stamina but are weak fighters; Quarriors, who are slow diggers but strong fighters; and the F'Targs, who are mediocre but regain their health quickly. The player chooses one of the four races, then sends out five man teams to mine a region. There are 34 regions in all, with two accessible at the beginning of the game. Each region has an amount of money the player must amass in order to beat it and open up the adjacent territories. Time plays a role, as there is always a computer controlled opposing race in the region, competing with the player to be the first to achieve the monetary goal.

The gameplay is similar in some ways to Lemmings, with the player issuing orders to his five miners, not directly controlling them. The stages themselves are viewed from the side - the mineshafts that extend throughout the levels give the impression of an anthill. The player commands his units to dig and, when needed, perform more specific actions such as picking up gems and fighting enemy diggers. The races have various personalities, and will occasionally do things without the player commanding them to; this can range from good (such as fighting an enemy) to very bad (walking into a deep pool of water and drowning). As the miners dig, rubies, gold, emeralds, and diamonds will appear.

At any time the player can teleport a miner back to the starting point and send him to the 'Zargon Stock Exchange', in order to trade the finds for money. Only three commodities are traded at one time, and the prices for each fluctuate depending on how much of a particular item has recently been sold. Here the player may also visit a shop and buy special mining tools, such as dynamite, automated drillers and bridge components. The miners themselves are expendable (though a monetary loss will be incurred for each lost worker), with a fresh set of five available each time a new level is entered.

This Diggers fan remake was started in 2006 as a [basic Win32 C application](https://github.com/Mhatxotic/Diggers/releases/tag/Diggers-R00) using DirectDraw, DirectSound and DirectMedia then rewritten from scratch in C++ from the ground up with a new fully customisable engine called *Mhatxotic Engine* to utilise open source, cross-platform technologies and conformed to ISO coding standards.

Diggers is a completely playable game from start to finish but will always be a work-in-progress since it is difficult and incredibly time consuming to work on a game single-handedly and there are always issues with upstream code due to the balancing of modernisation and compatibility. However, the following information is the current estimated status of the game…

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## System Requirements…
| | Minimum | Recommended | Note |
| --- | --- | --- | --- |
| **Processor** | Dual-Core 2GHz  | Multi-Core 2GHz+ | Multithreaded! |
| **System** *(Windows)* | XP *(SP3 X86/SP2 X64)* | 7/8.X/1X+ *(X64)* | 32 and 64bit executable. |
| **Memory** *(Windows)* | 16MB *(XP/X86)* | 128MB+ *(Win7/X64)* | Close estimate. |
| **System** *(MacOS)* | 10.15 *(Intel)* / 11 *(Arm)* | 11.0+ *(Arm)* | FAT Universal executable. |
| **Memory** *(MacOS)* | 256MB *(Intel)* | 512MB *(Arm)* | Close estimate. |
| **System** *(Linux)* | Ubuntu 24.04 *(X64)* | Mint 22.1+ *(X64)* | See below for packages. |
| **Memory** *(Linux)* | 16MB | 128MB+ | Wild estimate. |
| **Graphics** | NV GF8K/ATI R600 | NV GF8K+/ATI R600+ | OpenGL 3.2 compatible. |
| **Audio** | Any sound device | Any sound device | OpenAL 1.1 compatible. |
| **Input** | Keyboard and mouse | Keyboard and mouse | Supports joystick! |
| **Disk Space** | 48MB (Read-Only) | 64MB (Read+Write) | Portable! |
| **Network** | None | None | Unused. |

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## Downloading…
You can always get the latest version of this project [here](https://github.com/Mhatxotic/Diggers/releases).

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## Running…

### Windows version…
Running the Windows version should be trivial. Just double click on the executable file. All the files required for the game are stored inside the executable. Persistent data is stored in the directory where the executable is or if that directory is not writable then at `C:\Users\<Username>\AppData\Roaming\Mhatxotic Design\Diggers`.

### Linux version…
The Linux version is linked against the `libglfw3` external package that you need to install for the game to work. This can be installed with `sudo apt-get install libglfw3`. You can read about the libraries used in the [engine documentation](https://github.com/Mhatxotic/Engine?tab=readme-ov-file#credits). Simply run the game with `./diggers.elf` in a terminal or press `ALT+F2` to bring up the run dialog box to find the aforementioned executable. All the files required for the game are stored inside the executable. Persistent data is stored in the directory where the executable is or if that directory is not writable then at `~/.local/Mhatxotic Design/Diggers`. The Linux version is compatible with the Ubuntu and Mint distributions and should be compatible with all other Ubuntu based distributions. Compatibility with other Ubuntu and non-Ubuntu distributions is unknown at this time so please contact us if our binaries are compatible or incompatible so we can build a compatibility list.

### MacOS version…
Opening the `.dmg` file disk image will require you to bypass Gatekeeper. To bypass Gatekeeper, simply run the `Terminal.app` and `chdir` to the directory where you downloaded the disk image with `chdir ~/Downloads` and then execute the following command to remove the quarantine flag from the disk image archive with `xattr -d com.apple.quarantine Diggers-R<x>-MacOS-Universal.dmg` where `<x>` is the version of this application. You should then be able to mount the disk image and run the game without any issue. All the files required for the game are stored inside the `Diggers.app/Contents/Resources/diggers.adb` archive. Persistent data is stored at `~/Library/Application Support/Mhatxotic Design/Diggers`.

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## Story…
This is no ordinary day on the planet, Zarg. Today is the glorius 412th. The day that each year, signals the commencement of one months frenzied digging. Four races of diggers, are tunneling their way to the Zargon Mineral Trading centre. they each, have an ambition, that requires them to mine as much as the planets mineral wealth, as possible.

Observing the quarrelsome diggers from afar, is a mysterious stranger. Each of the races are hoping that this stranger, will control their mining operations. His expertise, will be vital, in guiding them along the long, dangerous path that leads to their ultimate goal. His first step, is to register, at the Zargon Mineral Trading centre.

As the diggers wait nervously, the stranger heads toward the trading centre. for him, the ultimate test. the greatest challenge of his life lies ahead. the rewards for success, will be wealth unlimited. the results of failure, are unthinkable!

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## Objectives…
Guide one of the four available races to raising 17,500 Zogs by mining valuable minerals across 34 zones in order to build their dream creation.

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## Setup…
Press `F1` at any time in the game to access the setup screen, `F2` to configure the key binds, `F3` to show the acknowledgements, `F11` to centre the window to the monitor or `F12` to write a direct frame buffer screenshot to disk.

### Configuration screen…
* **Monitor**
  - Allows you to change the monitor the game will be displayed on. This is only useful if you have multiple monitors. Use 'Primary Monitor' if you don't care or have only one monitor.
* **Display State**
  * Allows you to play the game in full-screen or windowed mode.
  * **Windowed mode**
    - Play the game in a resizable/decorated window. You can control the size of this window by the appropriate window size option below.
  * **Borderless Full**
    - Play the game in a full-screen borderless window.
  * **Exclusive Full**
    - Play the game in exclusive full-screen mode. You can change the resolution with the appropriate full-screen size option below.
* **Full-Resolution**
  * Changes the full-screen resolution to play the game in. This option shows 'Disabled' if 'Display State' is not set to 'Exclusive full-screen mode'.
* **Window Size**
  * Changes the size of the window when 'Display State' is set to
  * **Windowed mode**
    - Disabled if not set as such.
  * **Automatic**
    - Sets the size of the window automatically that is appropriate for your desktop resolution.
* **Frame-Limiter**
  * Most games like this one will normally try to render the graphics as fast as possible this results in straining of the GPU with unneccesary screen tearing, power usage and heat. You only need to ever unlock the FPS to benchmarking reasons only as your monitor will only display frames at a fixed rate (normally 60fps [or 60hz]), thus it is advisable to turn this on to ensure longevity of your equipment. There will also be additional strain on the CPU as well as it sends commands to the GPU as fast as possible as well. Options available are...
  * **Adaptive VSync**
    - Turn on vertical synchronization only when the frame rate of the software exceeds the display's refresh rate, disabling it otherwise. That eliminates the stutter that occurs as the rendering engine frame rate drops below the display's refresh rate.
  * **None**
    - Renders as fast as possible.
  * **VSync only**
    - The video card is prevented from doing anything visible to the display memory until after the monitor finishes its current refresh cycle.
  * **Double VSync only**
    - Same as *VSync only* but limits to half the refresh rate.
  * **Adaptive VSync & Suspend**
    - Same as *Adaptive VSync* but adds a one millisecond suspend to the engine thread on the processor.
  * **Suspend Only**
    - Sane as *None* but only adds a one millisecond suspend to the engine thread on the processor.
  * **VSync & Suspend**
    - Same as *VSync only* and adds a one millisecond suspend to the engine thread on the processor.
  * **Double VSync & Suspend**
    - Same as *Double VSync only* and adds a one millisecond suspend to the engine thread on the processor.
* **Texture Filter**
  * Allows you to apply bilinear filtering to the game.
  * **Yes**
    - Bilinear filtering enabled by the GPU.
  * **No**
    - Point filtering (Retro and fastest).
* **Audio Device**
  - Allows you to select which device you want the game sound to play on. Leave it on 'Default' if you don't care. Note that if the device becomes unavailable. The game engine will try to re-initialise it, and if the device does not respond. The default audio device will be used. There may be a few seconds before any sort of detection occurs due to the way OpenAL works.
* **Volumes**
  - Self-explanitory. 100% is full volume (0 dB) and 0% is digital mute. Try not to use high volumes or there will be significant clipping on Windows XP systems, or annoying auto-normalisation of music and sound on Windows 7+ systems. Try to keep the values at three-quarters, i.e. 75%.

### Buttons…
* **APPLY**
  - Save the changes and set the new values.
* **DONE**
  - Return to game without saving or applying any changes.
* **RESET**
  - Resets all the settings to default and applys the default values.
* **BINDS**
  - Show the keyboard binds configuration screen.
* **ABOUT**
  - Show the acknowledgements.

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## Controls…
You can control the game with just a mouse which is novice difficulty like the Amiga computer and DOS version. Adding use of the keyboard alongside the mouse makes the game quite easy to play. Playing with a controller is hard as it will basically emulate the mouse like the Amiga CD32 version of the game did.

### Basic controls…
All scenes out of the game will usually allow `any button` to select any point of interest which will normally be accompanied by a tooltip in the bottom-right hand corner of the screen and the `mouse wheel`, `L1`, `L2`, `R1` or `R2 game controller buttons` to cycle quickly through multiple choices on some screens.

In-game, the `left mouse button` or `first game controller button` will select the point of interest under the cursor and the `right mouse button` or `second game controller button` will bring up a menu for the selected in-game object. Pressing the `START` button will pause and unpause the game.

Pressing the `SELECT BUTTON` to enter the setup screen at any time.

To see a complete keyboard shortcut listing, press the `F2` key at any time.

### Cursors…
If you move the cursor and the cursor becomes anything but an arrow graphic, then than particular item on the screen is selectable, e.g.
* 4 small arrows pointing to the centre…
  - Select/Perform action/Go here.
* 1 small arrow with `EXIT` underneath…
  - Exit out of particular area.
* 1 small arrow with `OK` underneath…
  - Accept/Select/Perform action/Go here.
* Arrow cursor pointing up/down/left or right…
  - Scroll.
* A ticking clock…
  - All control is blocked temporarily.

### In-game hud…
The hud is explained as follows from left to right…

* Money (4 digits)…
  - Shows how much currency you have. You must grab gems by digging for them, stealing them from your opponent, and then ordering the digger home to enter the trade centre, entering the bank, and selling your gems. Making enough currency wins the zone. You can also spend currency at the shop to buy items that will assist you on your operations. You always start a zone with a loaned 100 Zogs plus capital carried over from the previous zone.
* Inventory and health…
  - This part of the hud displays the gems and other items in your inventory which you can drop at any time by going to the digger inventory menu. You can click on any item here to instantly drop it to the ground.
  - The health bar shows the health of your digger. It maxes out at 100% and will slowly regenerate if you stand still. It will turn orange if low and then turn red on imminent death. The heart changes speed depending on amount of health. There are damage indicators above your digger for when for when your digger loses (white) or gains health (green).
* Digger status…
  - This part of the hud shows what the selected digger is doing. This corresponds to the menu operation chosen.
* Digger buttons and indicators…
  - The numbers are clickable buttons which will quickly centre the view around the specified digger. You cannot click on the button if the corresponding digger has perished.
  - The indicators above the buttons indicate what the digger is doing…
    * Green: Digger is stopped and doing nothing.
    * Orange: Digger is moving.
    * Red: Digger is busy and cannot take orders until the current job is complete or is in danger.
    * Blue: The digger is in danger and the player must take action to save them from imminent death.
    * Black: The digger is impatient and the player must take action before they decide to do something else on their own.
* Utility buttons…
  - Cog: Centres around all your dropped and deployed inventory.
  - Hand: Shows all your diggers stats and inventory.
  - Arrows: Shows the position of all your diggers and what they're doing.
  - Question: Shows statistics and prediction information about the current zone operations.
  - Page: Displays the book.

### Anywhere in the game (not configurable)…
* `Alt`+`F4` on Windows and Linux or `Cmd`+`Q` on a Mac…
  - Instant quit. Any game progress is lost but engine settings and ALREADY SAVED game progress will be written to disk in a `.udb` file.
* `Alt`+`Enter`…
  - Switch between borderless or exclusive full-Screen and decorated window mode which will persist through app restarts.
* `World`+`F` on a Mac…
  - Switch between native full-screen and decorated window mode which may persist through app restarts using native functionality. Using the MacOS options disables the `Alt`+`Enter` logic and you have to exit native full-screen mode to be able to use that shortcut again.

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## Advanced…
If for some reason you're an advanced-user or admin and need to fine tune how the game engine works, we have some command-line parameters that might be useful and you can overload as much as the operating system allows…

* (*Win32*): `diggers cvar=value [cvar=value [...]]`
* (*Linux*): `./diggers.elf cvar=value [cvar=value [...]]`
* (*MacOS*): `open /Applications/Diggers.app --args cvar=value [cvar=value [...]]` or `./diggers.mac cvar=value [cvar=value [...]]`

### Examples…
* `diggers.exe vid_fs=1`
  - Will make the engine startup in full-screen.
* `diggers.exe vid_fs=0 win_border=0`
  - Will make the engine startup in window mode and hide the window border.

You can change cvars by opening up the console with the `GRAVE` key (key under `ESCAPE` key). In the release version of the game, the console is semi-permanantly disabled, you can re-enable the console by using `con_disabled=0` to re-enable it. CVars can obviously be overloaded onto the command-line, not just one setting. This key may not be available on most keyboards so you can change it by changing the `con_key1` or `con_key2` var. This is a GLFW specific [key code](https://www.glfw.org/docs/3.4/group__keys.html). Once you're in the console, type `cmdlist` for the commands you can use or `cvarlist` for the settings you can change and escape key to clear the text input or to close the console.

### Diggers CVars…
* `gam_data?` *(string)*
  - Save game data, where `?` is between `1` and `4`.
* `gam_intro` *(boolean)*
  - Enable (`1`) or disable (`0`) introduction video.
* `gam_key_*` *(unsigned integer)*
  - In-game key values which there are too many to list, so `*` represents the key function acronym. This is a [GLFW_KEY](https://www.glfw.org/docs/3.4/group__keys.html) integer. Set to `0` to disable.
* `gam_lang` *(string)*
  - Force a language. Keep empty to use the system detected language. Current valid values are `en` and `fr` with `de` and `it` in-development. Specifying an invalid language will default back to `en`.
* `gam_setup` *(boolean)*
  - Show configuration at startup (`1`) or skip configuration screen at startup (`0`). Always automatically sets to `0` when setup is shown.
* `gam_slowdown` *(boolean)*
  - Emulate Amiga slowdown (`1`) or use normal PC speed (`0`).
* `gam_test` *(integer)*
  - Debug all parts of the game (see main.lua).

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## Modding…
All the assets for the default release of Diggers is contained inside the `diggers.elf` binary on Linux, `diggers.exe` on Windows and in a separate `.adb` file on MacOS alongside the `diggers.mac` binary which is a non-solid maximum compression 7-zip file. If you know how the Quake or Half-Life engine works then overriding internal files operates similar to the engine. You can easily override any of the assets by mimicking the directory structure on disk or in another external `.adb` file alongside the executable file. The `.adb` files are sorted by name at startup and checked in reverse order so if you have an archive called `diggers.adb`, `diggers1.adb` then another archive called `diggers0.adb`, since the files are enumerated alphabetically, `diggers1.adb` and all its assets will take precedence over the prior archives `diggers0.adb` and `diggers.adb` in that order.

### Graphics…
Basic support for scaled textures is supported. To use, you add a text file called `scale.txt` to the `tex` directory which contains a simple integer of the scaling factor of your texture pack (i.e. `2`) which modifies the main frame buffer to be double the size, then all your textures (keeping the same filename structure as the game) have to be enlarged using that factor from the games' original texture size (e.g. `tex/sprites.png` is `512x512` pixel dimensions by default, so if the factor is `2` then your new texture size must be `1024x1024` pixels) so you can add more detail. Do not change any positioning of any of the tiles because the tile positions are scaled using the same factor too. You can put all these files in a `.adb` (7-zip) file to override the original games data files but you must not use a `solid` mode archive or load times will be crippled. Do not modify or include `tex/smask.png` or `tex/lmask.png` in your archives as these binary tile sets are used for the mask collision system which is not scaled. The limit is capped to `16` even though the theoretical limit is `25` (if GPU supports `16384x16384` pixel textures) as the largest texture is `tex/bookpage.png` at `640x640` pixels at 1X scale. You also do not have to keep the 8-bit palette texture format so you can use 32-bit depth textures if you like. As long as `LibPNG` supports the format you want, the engine should be able to process it.

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## F.A.Q.…
* **Q. This does not [look](https://www.youtube.com/watch?v=9w7v3TXBEGY) like the original game.**
  - A. The original game was in a `320x200` resolution which is not an aspect ratio of `16:9` or even `4:3` like most modern displays are and adaptations had to be made to support all display types and most of the old textures had to be updated to be compatible with OpenGL. If you can help upgrade the textures to make them look better (up to `16x` scale of the original) then that would be awesome!
* **Q. I got an error, strange behaviour or found a bug.**
  - A. You can start the game with the `log_file=...` (filename) and the `log_level=4` parameters to give a pretty detailed log of what the app is doing so you can send me that along with as much info as possible such as the `.log` `.crt` `.dbg` and `.udb` files that the app generates. Neither of these files will contain any personal information, only technical information to help me squash the problem.
* **Q. I've picked the wrong game-engine settings and the game crashed/won't start.**
  - A. Try specifying the parameter `sql_defaults=1` command-line option to reset all the engine settings to default. If this doesn't work you'll have to delete the `.udb` file or set `sql_defaults=2` and start again from scratch thus losing all your Diggers saved game data. All that said though, the game shouldn't really crash though so please send me any logs/crash dumps you may have.
* **Q. Can I [speed run](https://en.wikipedia.org/wiki/Speedrunning) or [T.A.S.](https://en.wikipedia.org/wiki/Tool-assisted_speedrun) this game?**
  - A. This game is overkill on RNG but you can set the seed that makes the `math.random()` function predictable on the command-line with the `lua_randomseed=value` argument so hopefully you can use that to your advantage.
* **Q. What's with the fog?**
  - A. The point of the fog was to only limit the visible area like the original versions of the game would show.

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## Credits…
### Diggers for Amiga, CD32 and DOS…
| Title | Author(s) |
| --- | --- |
| **Programmed by** | *Mike Froggatt* (PC) and *Toby Simpson* (Amiga). |
| **Additional DOS programming** | *Keith Hook*. |
| **Original design and Amiga programming** | *Toby Simpson*. |
| **Graphics** | *Jason Wilson*. |
| **Music and effects** | *Richard Joseph* and *Graham King*. |
| **Additional graphics** | *Tony Heap* and *Jason Riley*. |
| **Narrative text** | *Martin Oliver*. |
| **Additional design** | *Michael Hayward*, *Ian Saunter* and *Tony  Fagelman*. |
| **Level design** | *Toby Simpson* and *Tony Fagelman*. |
| **Quality assurance** | *Steve Murphy*, *Paul Dobson* and *Kelly Thomas*. |
| **Intro and outro sequence** | *Mike Ball* and *Mike Froggatt*. |
| **Book production** | *Alan Brand*, *Steve Loughran*, *Matrin Oliver* and *Tony Fagelman*. |
| **Special thanks** | *Chris Ludwig*, *Wayne Lutz*, *Dave Pocock*, *Sharon McGuffie* and *Ben Simpson*. |
| **Produced by** | *Tony Fagelman* and *Millennium*. |

### Diggers fan remake for Windows, MacOS and Linux…
| Title | Credit(s) |
| --- | --- |
| **Complete conversion** | By *Mhat* of *Mhatxotic Design*. |
| **Lobby music** | *Nugem B.* ([with permission](https://youtu.be/GFsHnxVRI8s)). |
| **Credits music** | *4U 07:00 V2001* by *Enuo*. |
| **Game over music loop** | *1000 Years Of Funk* by *Dimitri D. L.*. |
| **Special thanks** | [ModArchive.Org](https://www.modarchive.org) and [AmigaRemix.Com](https://www.amigaremix.com). |

### Remake credits…
| Credit | Reason |
| --- | --- |
| **Your name here.** |

### Engine credits…
Please read [this document](https://github.com/Mhatxotic/Engine?tab=readme-ov-file#credits) on the third party software used in this game.

## Contributing…
Thank you for your interest in contributing to the [Diggers](https://github.com/Mhatxotic/Diggers) project. If you decide to contribute code in any way — whether that may be via [issues](https://github.com/Mhatxotic/Diggers/issues), [discussions](https://github.com/Mhatxotic/Diggers/discussions), [pull requests](https://github.com/Mhatxotic/Diggers/pulls) or any other medium then by doing so you accept that you give full and permanent permission for us to use and modify your code as we see fit. As gratitude, your (nick)name or organisation will be credited in the [credits](#credits) section in this file and in the credits section of the game.

<sup><sub><sup><sub>[↑ Top](#contents)</sub></sup></sub></sup>
## Copyright © 2006-2025 Mhatxotic Design. All Rights Reserved.
