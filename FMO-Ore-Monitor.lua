-- Inspired by the script from thespartacus29: https://github.com/thespartacus29/DualUniverse-OreMonitor
-- Ore slots must be named ore1 - ore4
-- Slot for screen must be named screen
-- Connect in order: screen, ore1, ore2, ore3, ore4
-- Update Lua Parameters with the ore names and your max container volumes
-- This script should run under a tick filter named "Live"
-- The "Live" tick filter should be initialized in unit.start()
version=0.4

-- Exports --------------------------------------------
local title = "T1 Ore Status" --export: Title of table

local units = 1 --export: Use 0 for T, 1 for KL or 2 for L

local ore1Type = "hematite" --export: Ore type in first container
local ore2Type = "bauxite"  --export: Ore type in second container
local ore3Type = "quartz"   --export: Ore type in third container
local ore4Type = "coal"     --export: Ore type in fourth container

local maxOre1 = 89.60 --export: This is the maximum volume allowed in container in kL. Skill dependent, update as needed
local maxOre2 = 89.60 --export: This is the maximum volume allowed in container in kL. Skill dependent, update as needed
local maxOre3 = 89.60 --export: This is the maximum volume allowed in container in kL. Skill dependent, update as needed
local maxOre4 = 89.60 --export: This is the maximum volume allowed in container in kL. Skill dependent, update as needed

local statusFontSize = 5           --export: Status text font size in vw
local status1Text    = "Good"      --export: Status text for level 1
local status2Text    = "Low"       --export: Status text for level 2
local status3Text    = "Very Low"  --export: Status text for level 3
local status4Text    = "Critical"  --export: Status text for level 4
local status1Color   = "#008000" --export: Color for status text level 1
local status2Color   = "#FFFF00" --export: Color for status text level 2
local status3Color   = "#FF4500" --export: Color for status text level 3
local status4Color   = "#FF0000" --export: Color for status text level 4
local status1Limit   = 50          --export: Between 100% and this value will show status text 1
local status2Limit   = 30          --export: Between status 1 limit and this value will show status text 2
local status3Limit   = 25          --export: Between status 2 limit and this value will show status text 3
-------------------------------------------------------

local statusText  = {status1Text, status2Text, status3Text, status4Text}
local statusColor = {status1Color, status2Color, status3Color, status4Color}
local statusLimit = {100, status1Limit, status2Limit, status3Limit, 0}

local rows = {ore1Type, ore2Type, ore3Type, ore4Type}

local maxVol = {
    [ore1Type] = maxOre1,
    [ore2Type] = maxOre2,
    [ore3Type] = maxOre3,
    [ore4Type] = maxOre4
}

local oreMass = {
    [ore1Type] = ore1.getItemsMass(),
    [ore2Type] = ore2.getItemsMass(),
    [ore3Type] = ore3.getItemsMass(),
    [ore4Type] = ore4.getItemsMass()
}

-- Densities with 3 places have been determined with container.getItemsMass() of 1L
-- The others I don't currently have access to, so the values come from their descriptions
local density = {
    hematite   = 5.040,
    bauxite    = 1.281,
    quartz     = 2.650,
    coal       = 1.346,
    limestone  = 2.711,
    malachite  = 4.000,
    chromite   = 4.540,
    natron     = 1.550,
    acanthite  = 7.200,
    garnierite = 2.600,
    petalite   = 2.412,
    pyrite     = 5.010,
    cobaltite  = 6.33,
    cryolite   = 2.95,
    gold       = 19.30,
    kolbeckite = 2.37,
    columbite  = 5.38,
    illmenite  = 4.55,
    rhodonite  = 3.76,
    vanadinite = 6.95
}

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    if numDecimalPlaces ~= nil then
        return math.floor(num * mult + 0.5) / mult
    else
        return math.floor((num * mult + 0.5) / mult)
    end
end

function oreStatus(percent, statusLimit, statusText, statusColor)
    for i = 1, #statusLimit-1 do
        if percent <= statusLimit[i] and percent >= statusLimit[i+1] then
            return '<td class="tablerow status'..i..'">'..statusText[i]..'</td>'
        end
    end
    if percent > 100 then
        return '<td class="tablerow status1">'..statusText[1]..'</td>'
    else
        value = #statusLimit-1
        return '<td class="tablerow status'..value..'">'..statusText[value]..'</td>'
    end
end

function oreRow(ore, density, mass, max, oreUnits)
    local liters = mass / density
    local total
    local unitSuffix
    if oreUnits == 0 then
        total = round(mass / 1000, 1)
        unitSuffix = "T"
    elseif oreUnits == 1 then
        total = round(liters / 1000, 1)
        unitSuffix = "KL"
    else
        total = round(liters, 1)
        unitSuffix = "L"
    end
    local percent = math.ceil(((math.ceil(liters - 0.5) / (max * 1000)) * 100))
    local status = oreStatus(percent, statusLimit, statusText, statusColor)

    return [[
        <tr>
            <td class="tablerow">]] ..
                ore:sub(1, 1):upper() ..
                ore:sub(2):lower() ..
                [[</td>
            <td class="tablerow">]] ..
                total ..
                unitSuffix ..
            [[</td>
            <td class="tablerow">]] ..
                percent ..
            [[%</td>]] ..
                status .. [[
        </tr>
    ]]
end

local oreRowsHtml = ""
for i = 1, #rows do
    oreRowsHtml = oreRowsHtml .. oreRow(rows[i], density[rows[i]], oreMass[rows[i]], maxVol[rows[i]], units)
end

html =
[[
<style>
    .title {
        font-size: 8.5vw;
        text-align: center;
        font-family: "Consolas";
        font-weight: 900;
        margin-top: 3vw;
    }
    .table {
        font-family: "Consolas";
        margin-left: auto;
        margin-right: auto;
        width: 80%;
        font-size: 4vw;
    }
    .tableheader {
        font-size: 4.7vw;
        background-color: blue;
        color: white;
    }
    .tablerow {
        text-align: center;
        font-weight: 900;
        font-size: 4.7vw;
        padding: 0px;
    }
    .status1 {
        font-size: ]]..statusFontSize..[[vw;
        color: ]]..status1Color..[[;
    }
    .status2 {
        font-size: ]]..statusFontSize..[[vw;
        color: ]]..status2Color..[[;
    }
    .status3 {
        font-size: ]]..statusFontSize..[[vw;
        color: ]]..status3Color..[[;
    }
    .status4 {
        font-size: ]]..statusFontSize..[[vw;
        color: ]]..status4Color..[[;
    }
</style>
<div class="title"> ]] ..
    title .. [[
</div>
<table class="table">
    </br>
    <tr class="tableheader">
        <th>Ore</th>
        <th>Qty</th>
        <th>Levels</th>
        <th>Status</th>
    ]] ..
    oreRowsHtml .. [[
</table>
</div>
]]

screen.setHTML(html)
