## GE-Proton7-10 Released

Updated wine to latest bleeding edge
Updated dxvk to latest git
Updated vkd3d-proton to latest git
Corrected VKD3D_FEATURE_LEVEL being in the wrong python script block so it actually loads now.

Thanks to upstream proton devs Rémi Bernon (rbernon), Derek Lesho (Guy1524), Philip Rebohle (doitsujin):

Nioh 2 videos now work
Persona 5 Strikers videos now work

## GE-Proton7-9 Released

Added loader-KeyboardLayouts from staging. This fixes a big performance issue in Overwatch but may also help other games.
Set VKD3D_FEATURE_LEVEL=12_0 by default. This allows some older AMD GPUs to get past the "white screen" bug in Elden Ring
protonfix to set L.A. Noire to use DX11 (it tries DX9 by default) -- Thanks VoodaGod

## GE-Proton7-8 Released

Hotfix:

disable ntdll-CriticalSection from staging, it breaks ffxiv and deep rock galactic
EDIT: 3/5/22 -- I uploaded an incorrect build previously. I have now uploaded the correct build. Please note that the sha512sum has -changed-.

Sorry for the hiccup.

## GE-Proton7-7 Released

HOTFIX:

disabled server-Signal_Thread staging patchset that breaks steamclient in new prefixes for some games (notably Dragonball Fighter Z)
fixed path check for 32 bit smite EAC protonfix
fixed video rendering in RUST

Sigh. One of these days I'll get a release right the first time. That day is not today.

## GE-Proton7-6 Released

Wine-Staging is back! I rebased all of the patch sets from staging that did not cleanly apply and applied them on top of proton-experimental.

A detailed list surrounding staging patches can be found in /patches/protonprep-valve-staging.sh. If it's in the -W list then reasoning is provided. If it's not in the -W list that means it applied cleanly without issues. Note that some patch sets in the -W list are applied manually because they do apply, just not without fuzz.

wine-staging rebased and applied on top of proton-experimental (yes, all of it!)
wine updated to latest proton-experimental
dxvk updated to git
vkd3d-proton updated to git
protonfix added for SMITE to fix incorrect EAC library location (works now, yay)

## GE-Proton7-5 Released

### WINE:
Added NVCUDA patches from staging (required to allow physx to work again -- yay)
Added missing mouse rawinput patch from staging that allows true rawinput values rather than transformed values (this restores the same rawinput functionality of the previous proton-ge staging builds)
Added upstream powrprof patches for FFVII and SpecialK
Removed no longer needed customized mfplat reverts/patches -- upstream proton's work for CoD Blops III now

### Protonfixes:

Add protonfix for Project MIKHAIL: A Muv-Luv War Story
Add protonfix for MotorGP
Add protonfix for Exo One
Remove no longer needed protonfix for Apex Legends

### FFmpeg:

Added missing h264 and AAC decoders (fixes video decoding when shadercache is disabled in some games, such as BL3 Markus intro) (Thanks mmbossoni)

### DXVK:

updated dxvk to git

### VKD3D:

updated vkd3d-proton to git

## GE-Proton7-4 Released
Another hotfix build:

Added HideWineExports patch from wine-staging. Fixes games that need it, notably those using EAC disable workarounds such as:

Jump Force
Dragonball Fighter Z
Naruto to Boruto: Shinobi Striker

Added EAC disable workaround for single player in Naruto to Boruto: Shinobi Striker
Added upstream ldap patch so that build does not fail when using newer ldap library (this is mostly needed for compiling outside of proton build environment)
Fixed build environment submodule symlink issue

## GE-Proton7-3 Released

Another hotfix build.

--Finally-- got the build corruption issue fixed. There was a mixup with the pefixup script and transition from proton 7 stable to proton 7 experimental builds.
Took me a while but I got it sorted and Warframe and the Batman games as well as vcrun are all working properly again.
I quadruple checked on my side this time. What a long day.

## GE-Proton7-1 Released

Why the new naming scheme?

As discussed here:

https://www.patreon.com/posts/63101415

The base for WINE was changed from wine upstream to Proton experimental, and staging currently is not used in this new build. There are several reasons this was done, which are explained in detail in the post above.

I needed a way to express that the base is all Proton7 and to reset the minor versions. Additionally, from previous discussions I've had with some other devs on official proton, they requested that I modify the name so that the GE versions were easier to differentiate, which is why the GE prefix has been moved to the front of the name.

### What exactly has changed?

WINE upstream repo has been changed to Proton experimental bleeding edge.
Wine-staging is no longer used, but we keep it within the repository in case it is discovered that patches are needed from it later on.

### What has remained the same from previous Proton-GE builds?

mfplat implementation and continued work
gstreamer and ffmpeg implementation
protonfixes implementation and continued work
Various game patches which are not included in either upstream wine or proton and continuation to add such patches
dxvk-git and adding new patches or pending PRs as they become available
dxvk is still patched with async
vkd3d-proton-git and adding new patches or pending PRs as they become available

### What's actually fixed in this release compared to the last one?

Elden Ring EAC now works
The crash in various Unity games is resolved
Since we are now using proton's bleeding-edge experimental, we now have -all- of the controller and gamescope related patches. So if something is broken there -- it's an upstream proton bug.
Fixed doubled size issue caused by both dist folder and dist tarball being included. The dist tarball is not necessary and has been removed, returning the build to its original size instead of double.

## Proton-7.3-GE-1 Released

### WINE:

imported rebased fullscreen hack from proton 7.0
imported SDL patches from proton 7.0
imported gamepad patches from proton 7.0
imported racing wheel/ffb patches from proton 7.0
imported several misc. game fixes/patches from proton 7.0
imported gamescope patches from proton 7.0
imported updated mfplat patches from proton 7.0
imported rebased audio patches from proton 7.0
imported rebased mouse focus patches from proton 7.0
imported keyboard translation patches from proton 7.0
imported rebased font patches from proton 7.0
imported EAC patches from proton 7.0
imported network connectivity patches from proton 7.0
Cities XXL fix added (Thanks Alistair Leslie-Hughes)
updated wine + staging to git

### PROTON:

imported build system changes from proton 7.0
updated gstreamer to 1.18.6
updated dxvk to git
updated vkd3d-proton to git
updated dxvk-nvapi to git
removed FAudio from build (it's part of WINE now and works with WMA decoding)
removed jxrlib from build (it's part of WINE now)

### PROTONFIXES:

Added EAC disable workaround to allow Gears5 single-player to work (Thanks ga2mer)
Added EAC disable workaround to allow Jump Force single-player to work (Thanks Nej on discord)
Added EAC disable workaround to allow Dragonball Fighter Z single-player to work (Thanks Nej on discord)
Added EAC disable workaround to allow Elden Ring single-player to work
Added fix for Civ IV: Colonization (Thanks jo-oe)
Added fix for Heavy Rain (Thanks Sterophonick)
Added fix for Putt Putt PBS (Thanks Sterophonick)
Removed Baldur's Gate 3 Launcher disable -- it works now. (Thanks Mershi)
Removed video disable for Black Ops III -- they work now

Some mfplat related test results:

### Working:

borderlands 3
bloodstained ritual of the night
seven: days gone
mortal kombat 11
monster hunter rise
ffxiv
soul calibur vi
Astroneer
American Fugutive
Aven Colony
Scrap Mechanic
nier replicant
power rangers battle for the grid
haven
tokyo xanadu xe+
Resident Evil 3 remake
call of duty: black ops III
biomutant
industry of titan
mutant year zero

### Broken:

spyro - in-game videos play audio in wrong language
Catherine Classic
darksiders warmastered edition
Devil may cry Collection
Battlestar Galactica - Cinematic upside down.
the good life

## Proton-7.2-GE-2 Released

    Hotfix: fix wine mono checksum failure
    fshack: Add faking current resolution ability. Details here: #52 (thanks Dragomir-Ivanov)

## Proton-7.2-GE-1 Released

wine: updated Forza Horizon 5 wine pulseaudio crash on splash screen fix -- properly fixed now rather than reverting. (thanks Paul Goffman)
wine: updated MK11 patch with pending upstream patch for proper TIB handler fix (thanks Paul Goffman)
wine: updated to 7.2
wine-staging: updated to 7.2
wine-staging: winepulse patches updated and re-enabled (wine-staging/wine-staging@c437a01)
dxvk-nvapi: dxvk-nvapi has been updated to latest git -- allows physx to work in games that use it when physx is installed
dxvk: updated to latest git
vkd3d-proton: updated to latest git
FAudio: updated to latest git
protonfixes: protonfix added to allow Batman Arkham Knight to use physx (thanks SveSop)
protonfixes: protonfix added to fix Watch Dogs xaudio2_7 crash (thanks Sterophonick)
protonfixes: winetricks updated

## Proton-7.1-GE-2 Released

-This is a hotfix to restore WMA audio support.

The FAudio author removed GStreamer support -- which is needed for WMA playback.

The reason he did it is because WINE is in the process of upstreaming WMA decode support, but the problem is that decode support is not in WINE yet, and since it was removed from FAudio, no WMA audio is working.

This update restores FAudio GStreamer support so that WMA audio is working again.

## Proton-7.1-GE-1 Released

Wine:

    Add missing patch to fix Forza Horizon 5 login window not accepting mouse focus
    Fixed Forza Horizon 5 crashing after splash screen

Protonfixes:

    protonfix added for Progressbar95 (thanks Benibla124)
    protonfix Resident Evil 5 videos disabled as workaround to allow game to be playable (thanks manueliglesiasgarcia)
    protonfixes klite verb updated version (used for persona 4 golden)
    protonfix added to enable game drive option for Elder Scrolls Online installer. (Note -- the installer works but you have to press space at the black screen, updater and game works perfectly fine after that)

DXVK:

    add pending Resident Evil games patch doitsujin/dxvk#2466

-wine and wine-staging updated to 7.1
-vkd3d-proton updated to git
-dxvk updated to git
-FAudio updated to git

## Proton-7.0rc6-GE-1 Released

Protonfixes:

    Update Oceanhorn protonfix (thanks Iglu47 GloriousEggroll/protonfixes#50)
    Add wmp11 protonfix for most of the Resident Evil series (thanks manueliglesiasgarcia GloriousEggroll/protonfixes#49)
    Remove unnecessary dotnet 4.x protonfix in most titles (thanks manueliglesiasgarcia GloriousEggroll/protonfixes#48)
    Add protonfix for Super Meat Boy (thanks Sterophonick GloriousEggroll/protonfixes#47)
    Add protonfix for Lord of the Rings: War in the North (thanks chelobaka GloriousEggroll/protonfixes#52)

Proton:

    Remove d3d10/d3d10_1 dxvk overrides (ValveSoftware@0ca077d)

Wine:

    Add Monster Hunter Rise patch from upstream proton (ValveSoftware/wine@40f9cba)
    update wine to latest 7.0rc6
    update wine-staging to latest 7.0rc6
    Remove proton pulseaudio patches and reverts. Upstream wine has fixed the crackling audio in Cyberpunk 2077 and various other games so the reverts are no longer needed (https://bugs.winehq.org/show_bug.cgi?id=52225)
    Add Sea of Thieves voice patches from upstream proton

DXVK:

    update dxvk to latest git

vkd3d-proton:

    update vkd3d-proton to latest git

FAudio:

    update faudio to latest git

## Proton-7.0rc3-GE-1 Released

-fixed issue with rockstar launcher stuck on connecting
-fixed Path of Exile crash on launch
-fixed DayZ crash on launch
-fixed Elder Scrolls Online crash on launch
-fixed STEEP crash
-added protonfix for LEGO Batman 2: DC Super Heroes (thanks daddeltrotter)
-removed deprecated styx:master of shadows protonfix (thanks manueliglesiasgarcia)
-updated winetricks to allow removal of no longer needed proton_5 workaround for wmp11 (thanks manueliglesiasgarcia)
-dxvk updated to latest git
-faudio updated to latest git

## Proton-7.0rc2-GE-1 Released

-Biomutant video playback fix imported from proton
-FFXIV Old launcher "Log In" button crash fix imported from proton (transgaming patch +hidewineexports no longer needed)
-FFXIV New player cutscene playback fix imported from proton (game fully works without skipping it now yay)
-Mass Effect Legendary Edition audio fix imported from proton (no longer needs protonfixes workaround)
-Oceanhorn protonfix added - thanks Iglu47!
-Arcania protonfix added - thanks manueliglesiasgarcia!
-Gothic 4 protonfix added - thanks manueliglesiasgarcia!
-The Bureau: XCOM Declassified esync + fsync disabled via protonfix per ValveSoftware#797 (comment) - thanks manueliglesiasgarcia!
-Pending patch added for https://bugs.winehq.org/show_bug.cgi?id=52222 - thanks Bill and rbernon!
-wine and wine-staging updated to 7.0rc2
-DXVK updated to git
-vkd3d-proton updated to git
-faudio updated to git

## Proton-6.21-GE-2 Released

This is a hotfix to apply the following important revert from Valve:

ValveSoftware/Proton@7ce8140

Additionally, the release files for Proton-6.21-GE-1 have been removed to aide in further preventing people from accidentally launching Destiny 2 and getting themselves banned, per the above hotfix.

## Proton-6.21-GE-1 Released

-Proton BattlEye patches added
-Proton CEG patches added
-Proton Forza Horizon 5 patches added
-Proton Guardians of the Galaxy patches added
-Proton Fallout76 patches added
-Proton Baldur's Gate 3 patches added
-Proton Age of Empires IV driver nag fix patch added
-Proton fsync patches updated to futex_waitv version
-Fix for error when using file browser to pick a file location added (this occurred usually in applications when you tried to specify an existing file location)
-Fix for broken mouse input in Borderlands and R6S added (was not present in 6.20, issue appeared in 6.21)
-Fix for the beamng mouse issue updated so that it does not affect non-steam games
-Bcrypt patches updated (steep works again, thanks openglfreak!)
-vulkan childwindow patches updated
-vkd3d Forza Horizon 5 patches added
-vkd3d Guardians of the Galaxy patches added
-vkd3d updated to latest git
-dxvk updated to latest git
-protonfixes uplay overlay disable function has been fixed to apply correctly when used.
-wine mono version updated
-protonfix added for ship graveyard simulator (and prologue, Thanks Alistair Leslie-Hughes!)

Notes:
-Fsync has been disabled on all Uplay titles -- it causes Uplay to hang on "Looking for patches" when initiationg a new prefix. Esync works fine.
-Various Uplay titles that have a vulkan native mode (Rainbow 6 siege) need the overlay disabled in order not to crash. DX11 mode works fine.
-For games that have a protonfix that uses the uplay overlay disable -- if creating a new prefix you will need to relaunch the game a second time. Uplay completely removes any pre-existing configurations on first launch, so any appending to the file gets removed. Upon re-launch the option will be re-appended and uplay will then see it.
-uplay likes to hang out after the game has closed -- make sure you close it in the task manager.

BattlEye games tested and working:

Ark: Survival Evolved

BattlEye games tested and not working:

Mount & Blade: Bannerlord -- hitting this issue: ValveSoftware#3706 (comment)

CEG games tested and working:

Bioshock Infinite
Just Cause 2
Black Ops II Campaign
Sid Meier's Civilization V
Mafia II (Classic)

CEG games tested and not working:

Black Ops II Zombies Mode -- exemption occurs a few seconds after getting to main menu
Black Ops II Multiplayer -- same issue as zombies mode
Warhammer: Space Marine -- bugsplats
Lara Croft and the Guardian of Light -- just hangs in the background infinitely until force killed

## Proton-6.20-GE-1 Released

-wine: Added fix for broken right click camera control in BeamNG.drive
-wine: Revert some upstream commits to re-allow mfplat patches (it was disabled in wine-staging 6.20 due to patches needing a rebase)
-wine: Add patch to fix Eve online launcher (thanks Tr4sk!)
-wine: Add patch to workaround The Good Life video playback (thanks popsUlfr!)
-wine: Add patch to fix Castlevania Advance Collection and a few other Konami "collection" games (thanks Raptor85!)
-wine: rebased proton patches for 6.20
-wine: updated to 6.20
-protonfixes: Added vcrun2019 to Injustice 2 -- fixes multiplayer desync
-protonfixes: Removed no-longer needed .NET installation from Batman Arkham Asylum protonfix (allows it to work again)
-protonfixes: Added xaudio3_7 protonfix for Resident Evil 4 (fixes crash on loading from save)
-protonfixes: Removed no-longer needed xlive override for Fallout 3 (thanks manueliglesiasgarcia!)
-protonfixes: Added workaround that uses Proton 5.0 to install .NET into the prefix for Space Engineers (.NET installation is broken on wine 6.0+, thanks manueliglesiasgarcia! )
-protonfixes: Added vcrun2019 to Madden NFL 21 -- fixes multiplayer desync (thanks Alexithymia2014!)
-protonfixes: Gothic2: account for varying casing in game paths (thanks codicodi!)
-protonfixes: Uplay overlay disabled for Assassin's Creed: Odyssey (thanks PolisanTheEasyNick!)
-protonfixes: mfc42 override added for GT Legends (thanks otokawa-mon!)
-proton-valve: Imported fixes for paradox launcher from proton upstream
-proton-valve: Imported fixes for Nickelodeon All-Star brawl from proton upstream
-proton-valve: Imported fixes for WRC8/9/10 from proton upstream
-proton-valve: Imported fixes for Satisfactory multiplayer from proton upstream
-proton-valve: Imported fixes for Fallout 76 crash from proton upstream
-vkd3d-proton: Update to git
-vkd3d-proton: DXR 1.1 is now experimentally exposed. It can be enabled with VKD3D_CONFIG=dxr11.
-vkd3d-proton: Resizable bar now enabled automatically if available. NOTE: You may need to disable this in eGPU setups to avoid performance issues: VKD3D_CONFIG=no_upload_hvv
-vkd3d-proton: Marvel's Avengers now playable (again)
-dxvk: Update to git
-faudio: Update to git

## Proton-6.19-GE-2 released

-Added protonfix that allows Apex Legends to run (It needed winetricks xact in order to not crash at black screen. This allows it to at least get to the character screen. Still does not allow to join match due to EAC)
-Added protonfix that allows BeamNG.drive to run
-Added patch that allows RaceRoom Racing Experience to run (Thanks Alistair Leslie-Hughes!)

## Proton-6.19-GE-1 released

-Added protonfix for Syberia black screen (runs in a window, you will want to use gamescope to upscale)
-Added protonfix for Japanese version of Tree of Savior (we already had one for the English version, thanks Alistair Leslie-Hughes!)
-Added patches that allow EA Desktop beta client to work (Thanks Esdras Tarsis!)
-Removed deprecated mouse focus patches (no longer used in upstream proton) -- fixes mouse focus issues in some various games.
-Added uuid-dev package to build environment to fix antlr build dependency (thanks Optimus22Prime!)
-Imported proton experimental build environment updates
-Imported proton DLSS patches/updates
-Updated dxvk-nvapi to proton experimental version (for DLSS)
-Updated wine and wine-staging to 6.19
-Updated vkd3d-proton to latest git
-Updated dxvk to latest git
-Updated FAudio to latest git

## Proton-6.18-GE-2 released

-This is a hotfix, I forgot to update the mono version in the proton build environment (whoopsie). Fixes mono install request popup.

## Proton-6.18-GE-1 released

-hotfix added for hitman 2 and death stranding hangs (thanks Paul Goffman!)
-patches added from proton upstream to allow deathloop to run (thanks Paul Goffman!)
-protonfix added to allow crysis remastered to run
-protonfix added for Sonic CD (thanks Chloe Stars!)
-protonfix added for Bejeweled 3 (thanks Chloe Stars!)
-steamhelper patch added so it no longer requires a large revert patch in wine (thanks openglfreak!)
-wine + staging updated to 6.18
-dxvk updated to git
-vkd3d updated to git
-faudio updated to git

Notes:

(1) A large amount of changes have been added in this WINE release for HID gamepad support, as noted:

HID joystick enabled by default.

Two additional pending upstream patches have been added on top of this for better functionality. Currently proton's SDL gamepad patches have been disabled in favor of WINE upstream's HID implementation. I did my usual test with Guilty Gear Strive and everything seems to appear OK. The test is done in the dojo, with one xbox controller and one ps5 controller -- both controllers showed up fully functional for player 1 and 2, and proper button mappings and button images showed and worked.

Another note regarding GG Strive in particular with the testing:
note you have to take some funky steps for 2 player to work in training mode (not linux specific): https://playgame.tips/how-to-play-with-a-friend-in-training

I have not tested any force feedback games and am not sure if patches for that have been added. Unfortunately re-enabling the SDL patches will require a -massive- list of reverts, so for the time being as mentioned, the default HID joystick impementation is being used and proton's SDL patches disabled, at least until proton upstream rebases.

(2) Deathloop seems to very much dislike alt+tabbing out. For me it would freeze the game. Other than that it appeared to be playable.

## Proton-6.16-GE-1 released

Nothing too crazy in this release, mainly just updating to 6.16 and other relevant submodules to latest git

    FSR default sharpness changed from 5 to 2 per AMD recommendations (page 25): https://github.com/GPUOpen-Effects/FidelityFX-FSR/blob/master/docs/FidelityFX-FSR-Overview-Integration.pdf
    protonfixes added to fix black screen in Gothic 1 and 2 -- thanks manueliglesiasgarcia!
    protonfixes added to enable dxvk async for Final Fantaxy XIII and Tomb Raider 2013 -- thanks iWeaker4you!
    Wine + Wine-staging updated to 6.16
    FAudio updated to git
    DXVK updated to git
    VKD3D updated to git

## Proton-6.15-GE-2 released

-Fixed regression that broke TemTem
-Fixed regression(s) that broke Tokyo Xanadu eX+
-Added workaround that skips CoD Black Ops III videos (allows game to be playable).

## Proton-6.15-GE-1 released

NOTE: Due to the symlink updates for steam cloud saves, you will want to remove your old game prefixes so that they are properly regenerated with new symlinks. Your games may not launch otherwise:

Proton Game and Prefix Launch troubleshooting:
https://www.youtube.com/watch?v=uxWJ1xvowMk

Changes:

    Import proper steam cloud save fixes from upstream proton

    Import Project Cars III window focus fixes from upstream proton

    Import Tokyo Xanadu Xe+ ASF fixes from upstream proton

    Import Guilty Gear Strive cloud save path fixes from upstream proton

    Import multiple font fixes from upstream proton

    Fixed crash with Hitman 2

    Added workaround for FFXIV broken login button
    Details:
    There are two executables shipped with FFXIV for the launcher -- ffxivboot.exe and ffxivboot64.exe.
    Each one has a 'new' launcher mode and an 'old' launcher mode. The 'old' launcher mode is what we use to login on linux,
    however it uses mshtml and jscript by default, which break the 'Log In' button.
    The normal way to usually get around this is to just press enter after you input your password,
    but that can be annoying when you accidentally hit the button.

    Added FFXIV frame timing configuration for DXVK to resolve some stuttering, noted here: doitsujin/dxvk#2210

    Re-added missing mfplat stub that was accidentally removed from staging's mfplat patches. This re-fixes some unity games that had broken mfplat in 6.14 (Notably Power Rangers: Battle for the Grid)

    Added pending upstream wine patches for Riftbreaker

    Added pending upstream winelib patch (fixes https://bugs.winehq.org/show_bug.cgi?id=51596)

    vkd3d patch added for Diablo II Resurrected (Note: This was added in case it fixes other games. Running non-steam games with proton is -not- supported).

    Wine + Wine-staging updated to 6.15

    DXVK updated to latest git (fixes Endless Legend and Borderlands 2 crashing)

    vkd3d updated to latest git

    Faudio updated to latest git

    Rebased proton sdl joystick patchset. Removed: winebus: Make it more explicit how we are checking for duplicate devices

## Proton-6.14-GE-2 released

This is just a hotfix. The previous release was missing the protonfixes listed for Metro 2033 and L.A. Noire. I've updated the version as I received complaints over releasing hotfixes without changing the version.

## Proton-6.14-GE-1 released

-Issue with uplay services not connecting fixed from upstream wine
-FFXIV launcher certificate popup box spam fixed from upstream wine
-EVE Online launcher issue fixed from upstream wine
-Added d3dx11_42 protonfix for Metro 2033 (thanks lukashoracek!)
-Added d3dcompiler protonfix for L.A.Noire (thanks manueliglesiasgarcia!)
-Added d3dcompiler protonfix for HighFleet (thanks Alistair Leslie-Hughes!)
-Fixed shutil missing from protonfixes which broke set_ini_options (thanks djazz!)
-Added Microsoft Flight Simulator 2020 fixes from proton
-Re-added revert for 97afac469fbe012e22acc1f1045c88b1004a241f which breaks controllers in some unity games (https://bugs.winehq.org/show_bug.cgi?id=51277)
-dxvk updated
-vkd3d updated
-wine and wine-staging updated to 6.14

## Proton-6.13-GE-1 released

-Added NOSTEAM=1 envvar for FFXIV and FFXIV trial. This allows you to run either the steam OR the standalone version in steam through proton. See the video below for in-depth details: https://youtu.be/SihRNczHn_4
-FFXIV launcher workaround updated (previously used BrowserType, needed Browser instead)
-Rebased proton SDL gamepad patches on top of staging. Fixes various controller mapping issues and force feedback issues
-Steam input profiles now work again due to SDL patch update
-Warframe 5 minute no-controller crash is properly fixed now, steamclient patch is no longer needed finally
-Guilty Gear Strive 2 player mode works with two controllers now
-Grand Theft Auto V save on exit is fixed
-Swords of Legends launcher is fixed
-Resident Evil 8 crash fixed (it was crashing after they updated the game with FSR)
-vkd3d/dx12 resizable bar patches added. Can be enabled with VKD3D_CONFIG=upload_hvv
-AMD FidelityFX Super Resolution (FSR) has been patched in as the fullscreen hack's upscaling backend. Works on most games (not all, there are some caveats). For basic usage in most case only WINE_FULLSCREEN_FSR=1 is needed. The default sharpening of 5 is enough without needing modification, but can be changed with WINE_FULLSCREEN_FSR_STRENGTH=# (0-5) if wanted.
-1080p, 4k, and ultrawide input quality resolutions have been added to the FSR patch. See: https://gpuopen.com/fidelityfx-superresolution/#quality
-Various cloud save location symlink fixes have been added:
    My Documents -> Documents
    Application Data -> AppData/Roaming
    Local Settings/Application Data -> AppData/Local
-Font fixes imported from proton upstream
-DXVK updated
-vkd3d updated
-FAudio updated
-Wine-mono updated to 6.2.2

-A note on controller changes: hotplugging is still a bit wonky. If you unplug a controller then replug it, you may need to restart the game.

## Proton-6.12-GE-1 Released

-Necromunda "glowing" fixed
-Cyberpunk 2077 inventory crash fixed
-Guilty Gear Strive video playback fixed
-Forza Horizon 4 appears playable on Nvidia now (so far from my testing it seems to run now without issue)
-Battlefield 4 multiplayer ping issue fixed -- new ping patch from upstream added https://source.winehq.org/patches/data/207990
-Civilization VI now playable
-RDR2 working again (turns out it worked before, it just needed -fullscreen option otherwise it refused to launch. added in protonfixes now)
-fixed issue where directx and/or other prefix preinstall steps would hang/fail
-added fixes for star wars galactic battlegrounds saga
-dxvk updated to git
-vkd3d updated to git and pending 2.4 pull requests added
-faudio updated

## Proton-6.10-GE-1 Released

-Added UE4 preinstall workaround for Necrumunda
-Added UE4 preinstall workaround for Deliver us the Moon
-Added fix for Guilty Gear XX Accent Core R 2 hang
-Added Horizon Zero Dawn animations patch
-Added FarCry regression hotfix
-Origin seems to be much more stable/reliable now in regards to installation and launching
-Added staging bcrypt patches rebased on top of proton rdr2 patches (allows Steep online mode to work again)
-Added proton nvapi updates
-Added proton QPC performance patches (should help with fps regression)
-Added proton LFH performance patches (should help with frame times)
-dxvk updated with proton latency fixes
-vkd3d updated with proton latency fixes
-faudio updated
-steamclient updated with splitgate fix

## Proton-6.9-GE-2 Released

This build is a hotfix for Resident Evil Village (8)

## Proton-6.9-GE-1 Released

-Removed patch that was causing a lot of the RE8 crashes. Stability should be a lot better now. You may still occasionally get crashes when first opening the game, or during loading, or while changing screen resolution. Apart from that I was able to get through all of the intro cutscenes up to the playable 'van' area (trying not to spoil the game here) at the beginning on both AMD and Nvidia . Nvidia still takes a while to load the game, but it should at least be playable now.
-vcrun2019_ge checksum has been disabled. It's downloaded from Microsoft and changes too often, resulting in regular breakage. Removing the checksum allows it to download and install regardless of if the sha sum has changed. If people are worried about it they can check the sha sum themselves in ~/.cache/winetricks/vcrun2019_ge
-Days Gone is playable now (it takes a while to load, just a warning)
-Marvel's Avengers is playable now
-Mortal Kombat X story mode audio fixed/playable now
-Halo:MCC should no longer force windowed mode (issue it was required for has since been fixed)
-DXVK updated to latest git
-FAudio updated to latest git
-vkd3d updated to latest git
-wine/staging updated to 6.9

## Proton-6.8-GE-2 Released

-Mass Effect Legendary Edition Launcher and ME1 fixes added. All 3 games should be playable.
-DOOM Eternal should no longer hang and resolution change should work again
-Forza Horizon 4 frequency patch added, however this does not seem to improve the crashing :/
-RE8 REENGINE Logo audio is fixed and no longer plays static (game is still crashy)
-RE8 Display menu fixes ported from proton experimental
-Nioh 2 hang fixed (videos still don't play)
-Fallout: New Vegas audio looping fixed
-2k Launcher fixes ported from proton experimental (fixes mafia, mafia II, and others)
-Yakuza 0 - fsync disabled (thanks tgurr!)
-Yakuza Kiwami - fsync disabled (thanks tgurr!)
-LEGO The Lord of the Rings d3dx9_41 override added (thanks alkazar and FigoFrago!)


## Proton-6.8-GE-1 Released

HOTFIX 2:
-Resident Evil Village (8) now works. RE Engine intro logo audio plays static, everything else works fine.
HOTFIX:
-Fixed video distortion issue in RE2 videos (was being caused by the nier replicant patch forcing wrong video format type on all videos)

Changelog:
-Forza Horizon 4 now works
-Nier Replicant now works (Video Playback included)
-Fixed various issues surrounding start.exe Such as ShellExecuteEx failures (causing games not to launch).
-Fixed issue with Borderlands 2 not launching
-Fixed issue with Borderlands 3 hanging on claptrap loading screen
-Fixed audio loop issue in Fallout New Vegas
-Fixed issue with Yu-Gi-Oh Duel Links needing vcrun2019
-Fixed issue with uplay, origin, and other game clients not installing on new prefixes
-Fixed issue with Persona 4 Golden not relaunching after first time.
-Fixed issue with keyboard input not working if a controller is connected.


## Proton-6.5-GE-2 Released

HOTFIX:
-Added wine-mirror/wine@fcb37c9 to resolve start.exe issue
-Added sha512sum file to releases for external update tools

Attached build has been updated.

General Proton fixes:
-Added mouse stutter fix from proton experimental
-Fullscreen hack is back! Works with MK11 finally!
-DXVK updated
-vkd3d updated
-FAudio updated

Game fixes:
-Fixed RDR2 Online mode, works now
-Fixed GTA V forcing players into solo online sessions and making them unable
to join events
-Fixed Sea of Thieves crash on loading after creating a new lobby
-Fixed issue with games exiting and leaving steam in 'running' mode
-Added launcher workaround for Evil Genius 2

MFPlat fixes:
-Fixed MK11 random mid-game/mid-cutscene mfplat crashes (hopefully)

Known issues:
-MK11 will crash in story mode on chapter select if you do not select a level
before one of the video clip animations completes
-Catherine Classic still doesn't work
-Darksiders Warmastered Edition still doesn't work
-Grandia/Grandia II HD Remaster still crash on opening.

## Proton-6.5-GE-1 Released

@GloriousEggroll GloriousEggroll released this 9 hours ago

This release is mainly a big cleanup of the mfplat stuff that was broken and should get most of the things working which were working before in addition to a few new fixes:
MFPlat/Video playback fixes:

-Trials of Mana video playback fixed
-Devil May Cry 5's "History of DMC" video playback fixed
-Power Rangers Battle for the Grid video playback fixed
-Seven: Days Long Gone video playback fixed
-Borderlands 3 Marcus intro video playback fixed
-Resident Evil 2/3 video playback fixed
Other Game fixes:

-Red Dead Redemption 2 single player story mode finally works
-Dragon Star Varnir opening crash fixed -- game is now playable
Component updates:

-DXVK updated
-VKD3D updated
-OpenXR patches updated
-Wine and Wine-Staging updated to 6.5
Still Broken:

-Red Dead Redemption 2 online mode does not work (disconnects)
-GTA V puts users in solo session
-Catherine Classic still hangs at new game loading screen
-Darksiders Warmastered Edition hangs at thq nordiq intro logo
-Grandia/Grandia II HD Remaster still crash on opening.

## Proton-6.4-GE-1

Thanks everyone for being patient with this one. There's still some media foundation related bugs and pending fixes that Derek (mfplat patchset author) is working on, but this release should be good enough to get some new games working that weren't previously (notably MK11, Injustice 2, Need for Speed), At the end of the week wine 6.5 releases so if the media foundation patches are fully resolved by then there will likely be another release. Here are the details on this release for now:
Media Foundation changes/currently known issues:

Working:
-MK11 cutscenes fully working, video+audio in cutscenes works, has slight audio desync. Crypt also works.
-Injustice 2 cutscenes fully working, video+audio in cutscenes works, has slight audio desync

Broken:
-DmC 5's "History of DMC" video is broken again
-Power Rangers Battle for the Grid Story videos broken
-Seven: Days Long Gone Humble Bundle logo video will hang if intros are not skipped
-Borderlands 3 Marcus intro on new game hangs (again)
-RE2/RE3 WMV playback currently broken
Notes:
-As this is a new implementation of the mfplat patches, WMV support and MPEG4 Section 2 support are both missing/not added yet. It is a work in progress, and you may see bugs that were previously fixed. Please be patient as this is a work in progress.
Wine:
-Updated wine + wine-staging to 6.4-git
-Need For Speed atiadlxx fix ported from proton (Need For Speed now runs)
-Crown Trick + Home Behind 2 fix ported from proton
-Hades controller input fix ported from proton
-DualSense/PS5 controller mapping ported from proton
-Additional OpenXR patches ported from proton

-FAudio updated to git
-Wine and Wine-staging updated to git
-vkd3d updated to git
-dxvk updated to git and FarCry 5 texture issue worked around
-Dead or Alive 5 protonfix added (thanks iglu47)
-watchdogs 2 and farcry5 uplay overlay disable protonfixes added (thanks iglu47)
-corefonts fixed in protonfixes (thanks iglu47)
-vcrun2019_ge download url updated in protonfixes
-winetricks updated in protonfixes
-msiexec re-enabled in wine build (thanks fastrizwaan)

All in all, I would say the summary of this build is if you want to play MK11 or Injustice 2, this build is for you, but if you have any games that heavily relied on Media Foundation (mfplat) prior to this, chances are they may be broken in this build. Once Derek gets WMV and MP4S2 implemented along with some cleanups the next build should work nicely regarding mfplat.

## Proton-6.1-GE-2

HOTFIX: 2/7/2021
-removed futex2 patches, they cause warframe's launcher to freeze.
Download link updated
Release notes:

-removed previous steam common redistributables fix for winetricks -- it was causing crashes on arch systems, and winetricks fixed the download urls upstream anyway. This should also fix some issues with games launching once then not launching again.
-updated winetricks in protonfixes
-added tree of savior d3dcompiler_47 override
-fixed crash issue in RE2 and Visage on vega APUs due to dxvk being compiled with gcc9 (resolved with gcc10)
-cyberpunk heap allocation/shared memory patches added, should improve performance
-additional spatial audio patches added from experimental
-futex2 patches added from experimental

## Proton-6.1-GE-1

Hotfix #3: 2/1/2021

Since Microsoft decided to remove the download URLs for DirectX:

https://techcommunity.microsoft.com/t5/windows-it-pro-blog/sha-1-windows-content-to-be-retired-august-3-2020/ba-p/1544373
https://www.reddit.com/r/pcgaming/comments/l79r4x/psa_microsoft_has_removed_directx_download_from/
https://www.reddit.com/r/linux_gaming/comments/l7sax5/microsoft_removed_older_offline_directdownloads/

It broke some of the usual protonfixes/winetricks overrides -- such as d3dx11_43, d3dcompiler_43, xaudio, xactengine, vcrun2015/17/19 and a few others. Luckily for us, Valve ships most of these and it's auto-downloaded on most systems that run Windows or Proton games, under the 'Steamworks Common Redistributables' tool.

With that being said, I've added functionality to proton to detect this folder, and install the overrides from this folder, instead of having to download them from Microsoft. This should save both bandwidth and disk space.

Again, if you have issues with protontricks not being applied to the prefix, make sure you have 'Steamworks Common Redistributables' installed under the 'TOOLS' section of your library in steam.

Download updated.
Hotfix #2: 1/31/2021

-Persona 4 Golden sound actually fixed this time with xactengine3_7 override
-Persona 4 Golden protonfixes k-lite install fixed to use locally written config for unattended install instead of github download
(If this was an issue for you before, please try again with a clean prefix)
-Microsoft Flight Simulator crash on new flight loading fixed (needed missing wmphoto patches)

Download updated.

Hotfix: 1/31/2021

-Small hotfix which adds rebased patch for doitsujin/dxvk#1582. Allows it to be applied to upstream dxvk without reverting doitsujin/dxvk@2d670ec and doitsujin/dxvk@c107345. Not a major change, but not reverting them fixes some validation errors per the commit comment. Download updated.
Updates:

-Persona 4 Golden in-game audio fixed, game should now be fully playable
-Cyberpunk 2077 issue resolved where FPS would be half of that experienced in regular proton (Thanks TKG for finding the dxgi override which resolved it)
-fsync issue causing conhost to pin 1 cpu at 100% resolved (thanks openglfreak Frogging-Family/wine-tkg-git@ddd28ce)
-controller hotplugging fixes imported from proton experimental for Subnautica and DOOM 2016
-Yakuza like a dragon controller detection fix imported from proton experimental
-Warframe controller workaround functionality updated
-dxvk updated
-vkd3d updated
-faudio updated
-wine + wine-staging updated
A note about Warframe controller functionality:

The issue with Warframe via Steam Play/Proton as many people know is that if you do not have a controller plugged in, the game would crash after 5 minutes on the dot. The workaround for this was to run xboxdrv to create a fake controller. About a year ago I created a patch for steamclient that worked around this issue by checking the names of joystick devices (js0,1,2 etc) in /dev/input/. This -sort of- worked. The reason I say sort of, is because some non-gamepad devices such as corsair mice and keyboards register themselves as joysticks.

So the trick was to check the name for anything that didn't have 'keyboard' or 'mouse' in the name. This however, did not work, as other devices such as steering wheels and flight controllers also got passed as 'gamepads'. Since steering wheels and flight controllers are not used in Warframe.. this again led to the crash.

I've now edited the patch again, this time steamclient's controller interface (which causes the crash), will not load in Warframe unless the device name contains 'controller' or 'pad'. I tested this with xbox, ps4, switch, and logitech controllers, as well as off-brand controllers, both wired, bluetooth, and ms xbox wireless, all were recognized ok, and the interface did not load with my steering wheel or hotas flight stick.

The purpose of this patch is to allow Warframe to run -with out- needing xboxdrv, so that it will not crash. If you experience warframe crashing after 5 minutes on the dot, please let me know, as I'd like to know more about your joystick devices in /dev/input and possibly add an exception if needed.

Please keep in mind this detection system only affects Warframe. Outside of Warframe controllers and other devices will act as they would normally in Valve's proton.
A note about Skyrim SE Script Extender (skse64):

The patch for SKSE has been removed, per:

https://bugs.winehq.org/show_bug.cgi?id=44893#c17

The author of SKSE admitted a bug in skse and and fixed it upstream in skse:

--- quote ---
I reached out to the SKSE team about this and Ian Patterson confirmed that there
had been a bug with calculating the minimum safe address and corrected it in
F4SE, but somehow it was not corrected for SKSE.
--- quote ---

This has since been fixed here:

ianpatt/skse64@4a1e121

However a new version of SKSE has not been released yet so the fix is not in it. The fix was added Dec 28 but the current SKSE build available at https://skse.silverlock.org/ is from August.

I've recompiled it and supplied it here (with sources) until the Author releases a new version:

https://drive.google.com/file/d/1I6tgvZDaSs2JPXkHdWJwuZVwzF0OSpzz/view?usp=sharing

Seems to work for me. Game launches and my mods work. If a specific mod doesn't work but others do it's likely an issue with that mod specifically more so than SKSE. Please note I'm providing this to get mods working for the majority of people without needing patching, and -not- responsible if any specific single mod does not work. The latest version of SkyUI seems to work here for me.
Known issues:

-The build uses proton's new runtime, which runs within a container, therefore all of the current Proton 5.13 issues also apply here.

ValveSoftware#4289

-MK11 Story mode and Cinematics do not work
-Injustice 2 Cinematics do not work
-Catherine Classic is not working
-Darksiders Warmastered Edition intro + cutscenes do not work
-Black Ops III does not work
-Grandia and Grandia II do not work

## Proton-6.0-GE-1

Game Fixes:

Persona 4 Golden now playable but with issue -- in-game audio is broken. Cutscenes and cutscene audio are working.
Fixed issue that prevented Death Stranding from running in 5.21
Fixed issue with video playback in DmC 5 (again)
Fixed issue preventing controllers from being detected in some games on certain distros
Controller Hot Plugging now working
Controller patches completely rebased from 5.13
Mangohud now working
Vulkan device select layer now working
Wine updated to Wine-Staging 6.0
gstreamer libraries updated to 1.18.3
vkd3d updated to 2.1-037efbd to contain Dirt 5 fix
dxil-spirv submodule in vkd3d updated to contain latest Horizon Zero Dawn fixes.
DXVK updated, contains F1 game fixes
DXVK pending pull requests 1582,1673,1759,1805 added:

doitsujin/dxvk#1582
doitsujin/dxvk#1673
doitsujin/dxvk#1759
doitsujin/dxvk#1805

Should contain most of the fixes from Proton-5.13 from Valve, if something is missing let me know in discord.

Proton Fixes:

added klite verb with ini for custom silent install for Persona 4 Golden
updated Persona 4 Golden protonfixes script

Known Issues:

-The build uses proton's new runtime, which runs within a container, therefore all of the current Proton 5.13 issues also apply here.

ValveSoftware#4289

-Red Dead Redemption 2 still does not work. Unfortunately the syscall patches in current proton do not work with upstream wine.
-Fullscreen hack is still currently disabled.
Known mfplat+quartz issues:

-Catherine Classic is not working
-Black Ops III is not working
-Injustice 2 cutscenes broken currently
-Darksiders Warmastered Edition intro+cutscenes broken currently


## Proton-5.11-GE-3-MF

Fixes:
-Re-enable rawinput (seems staging had it disabled in the previous build)
-Re-enable FakeDLLs and SECCOMP (seems staging had it disabled in the previous build) - needed for Doom Eternal,Detroit:BH, Origin
-Re-enable HideWineExports (seems staging had it disabled in the previous build) - needed for FFXIV
-Fix issue with not being able to regain focus after alt+tab in various games
-Fix issue with GTA V keyboard input not working
-Fix issue with rawinput not working properly within a virtual desktop
-Fix issue with Warframe and SWTOR not rendering correctly in dxvk on nvidia
-Added patch that allows Indiana Jones and the Emperor's Tomb to run
-Added patch that allows MGS: Ground Zeroes to run (keyboard+mouse input is currently broken, needs more work. Works with controller)
-Added workaround for Warframe launcher rendering all black in wined3d mode (game still crashes in wined3d) - Thanks Iglu47
-README has been overhauled. Thank you TheEvilSkeleton!

## Proton-5.11-GE-2-MF

GloriousEggroll released this Jun 29, 2020

This is a minor hotfix/stability release:

-Fixed issue with steam overlay causing mouse lag after 30+ minutes (issue present since 5.9, was missing from rawinput patches)
-Fixed issue with mouse hitting 'invisible walls' (issue present since 5.9, was missing from rawinput patches)
-Fixed issue with prefixes not generating properly causing some games not to be able to save due to the recent user name changes
-Ashes of the Singularity now works, vulkan renderer does not. Need to use DX11/12
-Jurassic World: Evolution now works

NOTE: If you want to allow your save games to work when using proton within lutris, you need to set WINEUSERNAME environment variable
NOTE: If you want proton's media foundation to work in lutris, you need to set GST_PLUGIN_SYSTEM_PATH_1_0 and WINE_GST_REGISTRY_DIR environment variables.


## Proton-5.11-GE-1-MF

GloriousEggroll released this Jun 26, 2020

Game fixes:
-Origin 5.11 hang fixed
-Origin fixes ported from Proton 5.0.9
-Path of Exile Vulkan Renderer in-game swap fixed (for radv you will need mesa-git for upstream graphical glitch fixes)
-StarCitizen hang fixed
-Divinity Original Sin 2 hang fixed
-Mount and Blade: Bannerlord launcher fix added
-Persona 4 protonfixes fixed (thanks Pobega)
-Warframe launcher download hang fixed (broke in 5.10, still does not show progress bar)
-Sea of Thieves proper websockets implementation patches added (no longer needs win7)
-Partial fix for Catherine -- game now opens and can reach menus. Hangs on new game, waiting on EVR implementation in wine
-Deep Rock Galactic (and other games) libffi dependency fixed that was causing various crashes -- note, please do not use steam-native if you are on arch, steam-runtime should always be used.
-Protonfixes added for Assetto Corsa, should now work OOTB

Build additions:
-'wmp9_x86_64' winetricks verb imported to protonfixes from upstream winetricks that allows wmp9 to be installed in 64 bit prefixes
-hotfix added to use normal username instead of 'steamuser' when run with non-steam games. This also seems to fix issues with origin and other platforms not being able to save game (such as running Jedi Fallen Order origin version in lutris with proton)
-vkd3d updated
-dxvk updated
-FAudio updated

Build removals:
-Temporary removal of fshack, currently breaks MK11
-Temporary removal of esync, 5.10+ did a large rework of ntdll which broke compatibility with esync. The patchset needs to be rebased. It is currently disabled in staging.
-Temporary removal of fsync - fsync relies on esync. No esync = no fsync.

Known issues but playable:
-MK11 - no audio in custscenes -- needs SAR fixes, online matches broken
-Injustice 2 - no audio in custscenes -- needs SAR fixes
-Broken sound in Borderlands 3 Marcus new game intro -- can be skipped.
-Age of Empires II WMV videos don't play
-Street Fighter V intro videos don't play

Still broken:
-Seven (hangs on new game)
-Catherine (hangs on new game)
-Soul Calibur VI (hangs at main menu, needs SAR fixes)
-Nioh videos don't play, gameplay untested

Marking this as release as it has a lot of regression fixes and should be quite stable, despite the ongoing media foundation work and esync/fsync being disabled.


## Proton-5.9-GE-2-MF

GloriousEggroll released this Jun 06, 2020

--HOTFIX--
6/10/2020 7:17 PM MST:
After reviewing the issue tracker again for Sea of Thieves I found via ga2mer's comments that it becomes working/playable after login if the prefix is set to Win7. I tested this and it did indeed allow me to login and get past the previous journal issue/became playable. I've added a hotfix in protonfixes that should do this automagically. Updated Proton-5.9-GE-2-MF.tar.gz again.
--HOTFIX--
6/10/2020 10:15 AM MST:
I accidentally applied part 1 of a 2 part patch for RE3 twice instead of both 1st and 2nd parts, so I just corrected that and recompiled + reattached Proton-5.9-GE-2-MF.tar.gz. RE3 credits should work now

Hi all, I'm marking this as another pre-release as we still have some audio issues with media foundation, and a few other pending issues, however we also have quite a few fixes:

-Fullscreen hack is disabled still for compatibility with MK11.
-Rawinput re-enabled
-Nier/sekiro winex11 patch re-enabled
-winevulkan patches re-enabled
-The weird Skyrim mouse reverse input issue was fixed in 5.10, so I've backported it.
-There is some heavy work being done on wined3d and dxgi, which causes some additional issues, so TOXIKK and Killer Instinct require wined3d to currently run properly. Protonfixes have been added to do that automatically, so those games both work with wined3d currently.
-There is also some heavy work being done on ntdll in 5.10+, which cause esync and fsync patchsets to not be compatible. Due to this, I'm currently working with 5.9 and backporting specific changes necessary to retain esync and fsync compatibility.
-A dxgi native override was also added in protonfixes so that Metal Gear Solid V: Phantom Pain now works
-A fix has been added for the RE3 credits crash - thanks vitorhnn!
-A fix has been added for the MK11 and Injustice 2 video color issue - thanks vitorhnn!
-A partial fix for websockets has been added for Sea of Thieves so that login now works, however it is currently crashing after login on 'Opening the Journal' - thanks ga2mer!
-5.10 media foundation patches have been backported
-Remi Bernon's free range memory allocation patches have been backported which increases performance in We Happy Few and some other games.
-Proton 5.0.8 changes backported
-DXVK updated
-vkd3d updated
-FAudio updated

Known issues:
-Fullscreen hack still disabled for the time being to retain compatiblity with MK11
-Path of Exile cannot switch to vulkan renderer when using RADV, but works with AMDVLK. This is something else tied to fullscreen hack, as patching in fullscreen hack allows it to switch. RADV currently has a lot of graphical glitches with PoE anyway, so for the time being AMDVLK is the better option to use.
-Soul Calibur VI still hangs at intro due to incomplete SAR work in media foundation
-Injustice 2 and MK11 cut scene audio is missing due to incomplete SAR work in media foundation
-Borderlands 3 Marcus intro on new game audio is distorted due to incomplete SAR work in media foundation, but is skippable.
-Seven still only plays intro audio, no video, and crashes after starting new game due to incomplete SAR work in media foundation.
-libffi6 is still needed for some rolling release distros such as arch
-As mentioned, due to work being done with wined3d, dxgi is in an odd state. If a game works in proton, but does not work in proton-ge, try adding WINEDLLOVERRIDES=dxgi=n %command% to the options. If it works, let me know and I can add a protonfixes override for it.

Currently I would say this should be ok to use for most games except Soul Calibur VI and Seven


## Proton-5.9-GE-1-NR

GloriousEggroll released this on May 28, 2020

-Fullscreen hack was found to be the cause of Mortal Kombat 11 not working. This also requires a few other patches to be disabled such as some additional vulkan patches and raw input, as well as the Sekiro patch. Fullscreen hack used to work with this game, so this is just a temporary disable until I can figure out what in the patchset is causing MK11 to not work.
-Spyro audio is fully working now
-BL3 Markus intro has audio issues still but is skippable
-Soul Calibur VI freezes at the intro screen currently due to an issue with SAR audio.
-Seven actually launches now. Audio for intro movie plays but shows black screen. New game results in crash, again due to SAR audio.
-PC Building Simulator no longer freezes when running 3dmark on low settings. It just skips the video.


## Proton-5.8-GE-2-MF

GloriousEggroll released this on May 13, 2020

This is an update to 5.8-GE-1 in regards to media foundation work:

Completed:
-RE3: Bathroom scene fixed
-Dangonronpa v3 fixed
-Power Rangers Battle for the grid chipmunk voices fixed
-Monster Hunter World tutorial movies fixed
-Super Lucky's Tale -- Fixed an issue with bink videos not playing in GE builds which work in proton

WIP (work in progress):
Borderlands 3 Marcus intro video
Darksiders Warmastered Edition opening videos play now play, but New Game movie crashes
Street Fighter V intro videos don't play
Seven intro videos don't play

Todo:
-Age of Empires II WMV videos don't play - check if MF or quartz
-Catherine Classic does not play, opens small black box for game window - check if MF or quartz
-Nioh videos don't play - check if MF or quartz


## Proton-5.8-GE-1-MF

GloriousEggroll released this May 10, 2020

Overall fixes:
-Fix for ValveSoftware#2929 added, fixes crash in Dark Souls 3, Sekiro, Nier: Automata
-GTA IV should be fully playable now, patches imported from upstream proton
-Street Fighter V should be fully playable now, patches imported from upstream proton
-HideWineExports=Y registration added for FFXIV, fixes license issue
-Homeworld Remastered Collection should be playable without custom launcher necessary
-Updated steep patch for wine 5.8
-fixed proton controller patch issues -- should now have full proton controller patchset and functionality to match upstream proton
-patch added that fixes overwatch breakage in 5.7
-patch added that fixes star citizen breakage in 5.7
-patch added that fixes Path of Exile flicker in 5.7
-FFXV patch is now working again, game should be playable
-Monster Hunter World patches added which enable DX12 mode with vkd3d
MF (Media Foundation) specific fixes:
-Resident Evil 2 videos fixed, should now be fully playable, also works in DX12/vkd3d
-Spyro Reignited Trilogy videos fixed, should now be fully playable
-Remnant: From the Ashes videos fixed, should now be fully playable
-Soul Calibur VI videos fixed, should now be fully playable
-Street Fighter V videos fixed, should now be fully playable
-Deep Rock Galactic videos fixed, should now be fully playable
-BlazBlue Centralfiction videos fixed, should now be fully playable
-Bloodstained: Ritual of the night intro videos fixed, should now be fully playable
-Crazy Machines 3 videos fixed, should now be fully playable


## Proton-5.6-GE-2

GloriousEggroll released this Apr 14, 2020

-This is a hotfix that reverts the fullscreen hack changes, as they introduced a regression with mouse stutter on movement after a period of time. What this means:
-Fullscreen hack is still enabled, it's just using proton's version, not customized for staging
-Staging's winex11.drv-mouse-coorrds and rawinput patchsets have been disabled
-Proton's rawinput patchset has been re-enabled.

Normally I'd wait to release smaller changes like this, but the regression made some games basically unplayable. This should allow games to be played at least without the mouse stutter.


## Proton-5.6-GE-1

GloriousEggroll released this Apr 13, 2020

This is a pre-release continuation of the mfplat work done by Guy1524 (Derek) along with some additional fixes.

Wine + Wine-staging:
-Update to 5.6 release

mfplat:
-Add partial WMV playback support (Should allow RE2 and RE3 movies to play)
-Add gst-plugins-ugly and wmv playback patch to build

protonfixes:
-Add dxgi=n override for Darksiders Warmastered Edition, game seems to crash with wine's dxgi when using dxvk
-Add Divinity Original Sin 2 symlink fix update - fixes black screen on first launch
-Add SECCOMP override for RE3, needed by Denuvo
-Add SECCOMP override for DOOM Eternal, needed by Denuvo

proton:
-Add Proton 5.0.6 alpha patches
-Add Proton 5.0.6 alpha DOOM Eternal Audio patches
-fixed build system to include dist folder directly instead of tarball. This fixes the issue with sometimes having to hit the play button twice, or some issues people have on their system where the dist tarball never extracts.
-fullscreen hack patches modified to work with staging's winex11.drv-mouse-coorrds and rawinput patch sets

Notes:
-Spyro is still broken
-MHW Tutorials are still broken
-BL3 usually wants to set Direct12, which crashes. This generally leads to a popup asking you to restore default settings (confirm/hit yes). You will then need to relaunch the game and go in the games settings and change it to DirectX11 manually. After that DirectX11 should stick as the default mode.
-RE2 Crashes in DX12 with vkd3d at main menu, you'll need to set DirectX11 in re2_config.ini for DX11 with DXVK
-RE3 Seems to work with DX12 and vkd3d with minor interface graphical glitches. Can set DirectX11 in re3_config.ini for DX11 with DXVK
-FFXV seems to be working again

Again, I must note that 'pre-release' builds are basically alpha-testing builds. While they may contain a lot of fixes, some things may also be broken that normally are not.

Specifically in this regard - proton normally disables 'mfplay' which allows media foundation movies in many games (WMV and MP4) to just be skipped automatically. Since we enable this without full functionality, some games, such as Spyro or MHW, may hang when a movie tries to play.

If you wish to re-disable media foundation to use this version with your other games, you can use WINEDLLOVERRIDES=mfplay=n %command% in the game's launch options.


## Proton-5.5-GE-1

GloriousEggroll released this Apr 5, 2020

So I'd like to preface that this is a pre-release that has a massive amount of media foundation/mfplat wine patches. A huge thank you goes to Derek Lesho (Guy1524: https://github.com/Guy1524/wine) as well as Nikolay Sivov and Sergio Gómez Del Real all from CodeWeavers for getting this stuff working and taking the time to help me get it working with the correct dependencies in proton.

What this does is allows mp4 playback in MANY titles, including UE4 -and- Unity engine games. This fixes a lot (not all, but a lot) of issues surrounding media foundation/mfplat without the need for the 'mf-install' workaround that has legal issues and limitations, and is much safer for us to ship.

Tested fixes:
-Fixed borderlands 3 lilith in-head videos and 'watch the monitor' video bug
-Fixes Remnant: From the Ashes intro videos, intro menu, character menu
-Fixes intro video on Bloodstained: Ritual of the Night
-Fixes mp4 playback issues related to Crazy Machines 3

Still broken:
-Borderlands 3 intro narrative with Marcus's voice on new game does not play
-Spyro is still broken
-Probably some other mp4 related titles

Additional updates:
-A small patch has been added that should fix sunset overdrive from crashing on launch: https://source.winehq.org/patches/data/182631
-Two warframe launcher regressions have been fixed
-Mouse input fix patches which were added to wine-staging for Mount & Blade II: Bannerlord: https://bugs.winehq.org/show_bug.cgi?id=36873
-Lots of gstreamer plugin related work has been done/added in order to get media foundation stuff working. This was also cleared with aeikum and kisak from Valve personally, and deemed -ok- to include in my repository. This means it is safe to continue to link in Valve's issue trackers, unlike the 'mf-install' workaround. HURRAY!

Additional notes:
-Not -all- mp4s are fixed. There are still some that have problematic formats that are being worked on.
-Also coming down the pipe soon will be WMV playback fixes. This is to be handled after the mp4 issues are sorted.

Enjoy!


## Proton-5.4-GE-3

GloriousEggroll released this Mar 25, 2020

-wine 5.4 updated to latest git which includes some fixes/updates winevulkan to 1.2.134. DOOM Eternal seems to work fine with it when not blocked by Denuvo.
-Added ValveSoftware/wine#86 for more winevulkan compatibility
-Added https://source.winehq.org/patches/data/181826 for more winevulkan compatibility
-FAudio reverted to 20.03 stable release as some audio issues were reported
-Warframe controller patch updated to strictly only take effect when warframe is running, since the issue doesn't seem to affect other games.
-proton controller patches have been disabled (again) in favor of standard wine+wine-staging's, after reports of 'ghost' input and/or periodic input loss. SDL patches are still in applied.


## Proton-5.4-GE-2

GloriousEggroll released this Mar 22, 2020

This is more of a clean-up release although some new stuff/fixes have been added, mainly for DOOM Eternal

-Updated wine + staging to 5.4-git/upstream for DOOM Eternal
-Added ValveSoftware/wine#85 VK_KHR_get_surface_capabilities2 and fake support for VK_EXT_full_screen_exclusive for DOOM Eternal
-Added ValveSoftware/wine#83 which fixes some crashes in DARK SOULS III (374320), Nier: Automata (524220), Sekiro: Shadows Die Twice (814380)
-Added some missing registry entries that prevented Batman: Arkham Knight from starting on a clean prefix
-Cleaned up/removed unused mf_install verb in protonfixes in preparation for newer mfplat alpha patches (coming soon)
-Removed '-wolcen lords of mayhem 'blob head' fix' as the game devs fixed it internally per update 1.0.10.0
-Removed 'plasma systray fix' as it didn't really benefit anything, and actually interfered with some games.
-Removed Detroit:Become Human patch as it's already been upstreamed
-Cleaned up some duplicate patches and updated our current patches to work with latest wine-git+staging/git
-Updated vkd3d
-Updated dxvk
-Updated FAudio

Notes on DOOM Eternal:

    DOOM Eternal currently requires vulkan-loader/vulkan-icd-loader 1.2.135
    For AMD also requires mesa-git .
    ACO did not work for me with DOOM Eternal when I tried it, but llvm worked fine.
    To get rid of pre-launch GPU notices such as (HDR not supported), open DOOMEternal/launcherData/launcher.cfg and change all of these to 0:

rgl_showAMDStartupWarning 0
rgl_showIntelStartupWarning 0
rgl_showNvidiaStartupWarning 0


## Proton-5.4-GE-1

GloriousEggroll released this Mar 16, 2020

-controller fix for warframe - allows controller profiles to be loaded only if a controller is plugged in. fixes crash if no controller plugged in after 5 min.
-vkd3d updated, allows WoW to be played using proton via lutris (disable dxvk in lutris)
-more metro exodus vkd3d fixes
-wolcen lords of mayhem 'blob head' fix
-detroit: become human patch added
-need for speed world launcher patch added
-wine+ wine-staging updated to 5.4
-dxvk updated to latest git
-faudio updated to latest git
-fixes from Proton 5.0.4 imported

Known issues:

-MHW broken since last patch.
-MK11 broken since wine 5.0
-Injustice 2 broken since wine 5.0 (did not work here, but have had it reported working in 4.21)
-Borderlands 3 does not work with vkd3d yet


## Proton-5.2-GE-2

GloriousEggroll released this Feb 23, 2020

This is a pre-release to fix Fallout New Vegas from crashing on main menu.
-fixes a missing portion of the fullscreen hack
-dxvk updated
-more metro exodus vkd3d fixes
-wine 5.2 updated to latest git


## Proton-5.2-GE-1

GloriousEggroll released this Feb 19, 2020

This is a pre-release to fix the Warframe Launcher bug introduced in 2/18's update.


## Proton-5.1-GE-2

GloriousEggroll released this Feb 17, 2020

This is mainly a hotfix + feature release build.

Hotfix:
-Fixed warframe requiring a controller to be plugged in. That's right, you no longer need xboxdrv! I spent the weekend debugging it and was finally able to come up with a bit of a hacky workaround, but it works for now until valve addresses the issue (it has to do with the way lsteamclient handles controllers)

Feature:
-vkd3d branch is latest from codeweavers + DXIL changes by Hans Kristian (who has been doing a lot of vkd3d submissions) + metro exodus commits that both Hans and Doitsujin (creator of dxvk) have been working on together. The previous release had Hans's DXIL changes, this just adds the Metro changes on top of it. With that being said, expect some minor graphical glitches in vkd3d with Metro Exodus

Additions:
-This commit: ValveSoftware#3518 has been merged. This was a previous open PR from Guy1542, but it had a bug that would cause clustertruck and a few others not to launch. The new PR is by joshie (d9vk dev) and works now

-dxvk update to latest git
-faudio updated to latest git

Known issues:
-Just Cause 3 not able to save
-Batman Arkham Knight grappling hook not working
-MK11 hanging at launch (again)


## Proton-5.1-GE-1

GloriousEggroll released this Feb 10, 2020

-added fullscreen hack rebase from proton 5
-added updated steamclient rebase from proton 5 so that jc3 and batman AK denuvo problems work
-added updated monster hunter world patch that limits the changes to monster hunter world
-added proton patch that sets prefixes to win10 by default
-added dsound surround sound patches from proton 5
-proton dxvk wine integration patches added so that vkd3d works ootb without PROTON_USE_WINED3D
-reenabled proton's gamepad changes in favor over staging's (for now. let me know in discord if issues occur)
-updated to include proton's gstreamer and glib integration work
-added plasma systray patch
-fixed proton compatibility for staging patchset winex11.drv-mouse-coorrds
-disabled winex11-_NET_ACTIVE_WINDOW temporarily (not working correctly)
-disabled winex11-WM_WINDOWPOSCHANGING temporarily (depends on winex11-_NET_ACTIVE_WINDOW)
-updated dxvk to 1.5.4 official
-updated FAudio
-updated vkd3d

Known issues:
-Just Cause 3 not able to save
-Please note, vkd3d is very new and still does not work for DirectX 12 on all games.


## Proton-5.0-GE-1

GloriousEggroll released this Jan 30, 2020

-fixed issue with uplay games not recognizing they were being launched from steam
-fixed issue with farcry 5 hanging at launch
-fixed issue with stuttering in various games introduced by staging's ntdll-ForceBottomUpAlloc patches (darksiders 3, farcry 5)
-raw input patches finally fixed and enabled
-fixed issue with the MK11/skyrim skyui patch trying to allocate 119t virtual memory
-added patches that allow For Honor and steep to launch and work in single-player mode
-added patch that fixes battlenet beta crashing with win10 set in winecfg
-added patch that fixes fullscreen mode in steep
-added patch that fixes performance regression in Monster Hunter World caused by Iceborn DLC release.
-fixed proton compatibility for staging patchset winex11-MWM_Decorations (fixes https://bugs.winehq.org/show_bug.cgi?id=42117 which affects battlenet)
-fixed proton compatibility for staging patchset winex11-_NET_ACTIVE_WINDOW (fixes https://bugs.winehq.org/show_bug.cgi?id=2155 which affects some older games and apps)
-added proton's internal wined3d dxvk integration changes
-updated dxvk
-updated faudio
-changed vkd3d repository to one regularly worked on.

Edit:
-added fix for loading hang for endless legend
-added black ops 2 launch crash fix
-added winex11-WM_WINDOWPOSCHANGING patch from staging
-fixed an issue with proton not using d3d9 override (whoopsie)

Disabled the following for now, has an issue that causes windows to open and immediately close:
-proton compatibility for staging patchset winex11.drv-mouse-coorrds (fixes https://bugs.winehq.org/show_bug.cgi?id=46309 which affects origin)
