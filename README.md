# FMO-Ore-Monitor
Dual Universe Ore Monitor

# Installation
## Requirements
1. 1xProgramming board, 1xScreen M
2. Separate containers for each ore type

## Using the Export
Copy the export file to your clipboard. Right click your programming board an select Advanced -> Paste Lua configuration from Clipboard.  This should create the named slots and filters for you.  Connect components in the order: screen, ore1, ore2, ore3, ore4

## Manual installation
Connect the programming board to the elements in the following order: screen, ore1, ore2, ore3, ore4. Rename the slots screen, ore1, ore2, ore3, ore4.

On your Programming Board, create a unit.start() filter and add the following code:
```Lua
unit.setTimer("Live",1)
screen.activate()
```
Create a unit.stop() filter and add the following code:
```Lua
screen.clear()
screen.deactivate()
```
Create a unit.tick() filter named "Live" and paste the contents of FMO-Ore_Monitor.lua

## Lua Parameters
* title:  Title of the table
* units:  Table units. 0=T, 1=kL, 2=L, 3=auto kL/L
* autoUnitsThreshold: Threshold in L used to switch between kL and L units when units mode 3 is used.
* ore1Type: Ore type in container ore1
* ore2Type: Ore type in container ore2
* ore3Type: Ore type in container ore3
* ore4Type: Ore type in container ore4
* maxOre1:  Maximum volume for ore1 container.  Skill dependent.
* maxOre2:  Maximum volume for ore2 container.  Skill dependent.
* maxOre3:  Maximum volume for ore3 container.  Skill dependent.
* maxOre4:  Maximum volume for ore4 container.  Skill dependent.
* statusFontSize:  Font size for the status text in vw.
* status1Text:  Text for status 1
* status2Text:  Text for status 2
* status3Text:  Text for status 3
* status4Text:  Text for status 4
* status1Color: Color for status 1
* status2Color: Color for status 2
* status3Color: Color for status 3
* status4Color: Color for status 4
* status1Limit: Bottom % limit for showing status 1 text. 100% -> status1Limit
* status2Limit: Bottom % limit for showing status 2 text. status1Limit -> status2Limit
* status3Limit: Bottom % limit for showing status 3 text. status2Limit -> status3Limit

# Credits
Inspired by the script from thespartacus29: https://github.com/thespartacus29/DualUniverse-OreMonitor
