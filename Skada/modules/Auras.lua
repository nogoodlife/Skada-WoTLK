local Skada = Skada

--
-- cache frequently used globals
--
local _pairs, _ipairs = pairs, ipairs
local _format, _select, _tostring = string.format, select, tostring
local _GetSpellInfo = GetSpellInfo
local math_min, math_max, math_floor = math.min, math.max, math.floor

--
-- used to reset timers
--
local function setattributes(set)
    if set then
        for i, player in _ipairs(set.players) do
            if player.auras ~= nil then
                for spellid, spell in _pairs(player.auras) do
                    if spell.active > 0 then
                        spell.active = 0
                        spell.started = nil
                    end
                end
            end
        end
    end
end

--
-- once the set is complete, we make sure to stop calculating
--
local function setcomplete(set)
    if set then
        for i, player in _ipairs(set.players) do
            for spellid, spell in _pairs(player.auras) do
                if spell.active > 0 and spell.started then
                    spell.uptime = spell.uptime + math_floor((time() - spell.started) + 0.5)
                    spell.active = 0
                    spell.started = nil
                end
            end
        end
    end
end

--
-- common functions to both modules that handle aura apply/remove log
--
local function log_auraapply(set, aura)
    if not set then
        return
    end

    local player = Skada:get_player(set, aura.playerid, aura.playername, aura.playerflags)
    if not player then
        return
    end

    local now = time()

    if aura.auratype == "BUFF" and not Skada:IsDisabled("Buffs") then
        if not player.auras[aura.spellid] then
            player.auras[aura.spellid] = {
                school = aura.spellschool,
                auratype = aura.auratype,
                active = 1,
                started = now,
                uptime = 0,
                count = 1
            }
        else
            player.auras[aura.spellid].count = player.auras[aura.spellid].count + 1
            player.auras[aura.spellid].active = player.auras[aura.spellid].active + 1
            player.auras[aura.spellid].started = player.auras[aura.spellid].started or now
        end
    elseif aura.auratype == "DEBUFF" and not Skada:IsDisabled("Debuffs") then
        if not player.auras[aura.spellid] then
            player.auras[aura.spellid] = {
                school = aura.spellschool,
                auratype = aura.auratype,
                active = 1,
                started = now,
                uptime = 0,
                count = 1,
                targets = {}
            }
        else
            player.auras[aura.spellid].active = player.auras[aura.spellid].active + 1
            player.auras[aura.spellid].started = player.auras[aura.spellid].started or now
            player.auras[aura.spellid].count = player.auras[aura.spellid].count + 1
        end

        if aura.dstName then
            local targets = player.auras[aura.spellid].targets or {}
            player.auras[aura.spellid].targets = targets

            if not targets[aura.dstName] then
                targets[aura.dstName] = {id = aura.dstGUID, count = 1}
            else
                targets[aura.dstName].count = targets[aura.dstName].count + 1
            end
        end
    end
end

local function log_auraremove(set, aura)
    if set then
        local player = Skada:get_player(set, aura.playerid, aura.playername, aura.playerflags)
        if player and player.auras and aura.spellid and player.auras[aura.spellid] then
            local a = player.auras[aura.spellid]
            if a.active > 0 then
                a.active = a.active - 1

                if a.active == 0 and a.started then
                    a.uptime = a.uptime + math_floor(time() - a.started + 0.5)
                    a.started = nil
                end
            end
        end
    end
end

--
-- common functions handling SPELL_AURA_APPLIED and SPELL_AURA_REMOVED
--

local aura = {}

local function AuraApplied(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
    local spellid, spellname, spellschool, auratype = ...

    aura.playerid = srcGUID
    aura.playername = srcName
    aura.playerflags = srcFlags

    aura.dstGUID = dstGUID
    aura.dstName = dstName
    aura.dstFlags = dstFlags

    aura.spellid = spellid
    aura.spellname = spellname
    aura.spellschool = spellschool
    aura.auratype = auratype

    Skada:FixPets(aura)
    log_auraapply(Skada.current, aura)
    log_auraapply(Skada.total, aura)
end

local function AuraRemoved(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
    local spellid, spellname, spellschool, auratype = ...

    aura.playerid = srcGUID
    aura.playername = srcName
    aura.playerflags = srcFlags

    aura.dstGUID = dstGUID
    aura.dstName = dstName
    aura.dstFlags = dstFlags

    aura.spellid = spellid
    aura.spellname = spellname
    aura.spellschool = spellschool
    aura.auratype = auratype

    Skada:FixPets(aura)
    log_auraremove(Skada.current, aura)
    log_auraremove(Skada.total, aura)
end

-- ================================================================== --

--
-- to avoid repeating same functions for both modules, we make
-- make sure to create generic functions that will handle things
--

-- main module update function
local function updatefunc(auratype, win, set)
    local nr, max = 1, 0

    for _, player in _ipairs(set.players) do
        -- we collect number and uptime of auras first
        local auracount, aurauptime = 0, 0

        for spellid, spell in _pairs(player.auras) do
            if spell.auratype == auratype then
                auracount = auracount + 1
                aurauptime = aurauptime + spell.uptime

                -- still active?
                if spell.active > 0 and spell.started then
                    aurauptime = aurauptime + math_floor((time() - spell.started) + 0.5)
                end
            end
        end

        if auracount > 0 then
            local maxtime = Skada:PlayerActiveTime(set, player)
            local uptime = math_min(maxtime, aurauptime / auracount)

            local d = win.dataset[nr] or {}
            win.dataset[nr] = d

            d.id = player.id
            d.label = player.name
            d.class = player.class
            d.role = player.role
            d.spec = player.spec

            d.value = uptime
            d.valuetext = _format("%02.1f%% / %u", 100 * uptime / maxtime, auracount)

            if uptime > max then
                max = uptime
            end

            nr = nr + 1
        end
    end

    win.metadata.maxvalue = max
end

-- spells per player list
local function detailupdatefunc(auratype, win, set, playerid)
    local player = Skada:find_player(set, playerid)
    if player then
        local maxtime = Skada:PlayerActiveTime(set, player)
        if maxtime and maxtime > 0 then
            win.metadata.maxvalue = maxtime
            local nr = 1

            for spellid, spell in _pairs(player.auras) do
                if spell.auratype == auratype then
                    local uptime = math_min(maxtime, spell.uptime)

                    if spell.active > 0 and spell.started then
                        uptime = uptime + math_floor((time() - spell.started) + 0.5)
                    end

                    local d = win.dataset[nr] or {}
                    win.dataset[nr] = d

                    local spellname, _, spellicon = _GetSpellInfo(spellid)

                    d.id = spellid
                    d.spellid = spellid
                    d.label = spellname
                    d.icon = spellicon
                    d.spellschool = spell.school

                    d.value = uptime
                    d.valuetext = _format("%02.1f%%", 100 * uptime / maxtime)

                    nr = nr + 1
                end
            end
        end
    end

    -- win.metadata.maxvalue = max
end

-- used to show tooltip
local function aura_tooltip(win, id, label, tooltip, playerid, L)
    local set = win:get_selected_set()
    local player = Skada:find_player(set, playerid)
    if player then
        local aura = player.auras[id]
        if aura then
            local totaltime = Skada:PlayerActiveTime(set, player)

            tooltip:AddLine(player.name .. ": " .. label)

            -- add spell school if provided
            if aura.school then
                local c = Skada.schoolcolors[aura.school]
                local n = Skada.schoolnames[aura.school]
                if c and n then
                    tooltip:AddLine(L[n], c.r, c.g, c.b)
                end
            end

            -- add segment and active times
            tooltip:AddDoubleLine(L["Active Time"], Skada:FormatTime(totaltime), 255, 255, 255)
            tooltip:AddDoubleLine(L["Uptime"], Skada:FormatTime(aura.uptime), 255, 255, 255)
            tooltip:AddDoubleLine(L["Count"], aura.count, 255, 255, 255)
        end
    end
end

-- ================================================================== --

Skada:AddLoadableModule(
    "Buffs",
    nil,
    function(Skada, L)
        if Skada:IsDisabled("Buffs") then
            return
        end

        local mod = Skada:NewModule(L["Buffs"])
        local spellmod = mod:NewModule(L["Buff spell list"])

        function spellmod:Enter(win, id, label)
            self.playerid = id
            self.title = _format(L["%s's buffs"], label)
        end

        function spellmod:Update(win, set)
            detailupdatefunc("BUFF", win, set, self.playerid)
        end

        function mod:Update(win, set)
            updatefunc("BUFF", win, set)
        end

        local function buff_tooltip(win, set, label, tooltip)
            aura_tooltip(win, set, label, tooltip, spellmod.playerid, L)
        end

        function mod:OnEnable()
            spellmod.metadata = {showspots = true, tooltip = buff_tooltip}
            mod.metadata = {showspots = true, click1 = spellmod}

            Skada:RegisterForCL(AuraApplied, "SPELL_AURA_APPLIED", {src_is_interesting = true})
            Skada:RegisterForCL(AuraRemoved, "SPELL_AURA_REMOVED", {src_is_interesting = true})

            Skada:AddMode(self, L["Buffs and Debuffs"])
        end

        function mod:OnDisable()
            Skada:RemoveMode(self)
        end

        function mod:AddPlayerAttributes(player)
            if not player.auras then
                player.auras = {}
            end
        end

        function mod:AddSetAttributes(set)
            set.auras = {}
            setattributes(set)
        end

        function mod:SetComplete(set)
            setcomplete(set)
        end
    end
)

-- ================================================================== --

Skada:AddLoadableModule(
    "Potions",
    function(Skada, L)
        if Skada:IsDisabled("Buffs", "Potions") then
            return
        end

        local mod = Skada:NewModule(L["Potions"])
        local playermod = mod:NewModule(L["Potions list"])

        local potionIDs = {
            [28494] = 22828, -- Insane Strength Potion
            [38929] = 31677, -- Fel mana potion
            [53909] = 40212, -- Potion of Wild Magic
            [53908] = 40211, -- Potion of Speed
            [53750] = 40077, -- Crazy Alchemist's Potion
            [53761] = 40087, -- Powerful Rejuvenation Potion
            [43185] = 33447, -- Healing Potion
            [43186] = 33448, -- Restore Mana
            [53753] = 40081, -- Nightmare Slumber
            [53910] = 40213, -- Arcane Protection
            [53911] = 40214, -- Fire Protection
            [53913] = 40215, -- Frost Protection
            [53914] = 40216, -- Nature Protection
            [53915] = 40217, -- Shadow Protection
            [53762] = 40093, -- Indestructible
            [67490] = 42545 -- Runic Mana Injector
        }

        local _GetItemInfo = GetItemInfo

        --
        -- I have noticed that GetItemInfo sometimes doesn't return any
        -- info about certain potions (mainly Wild Magic), so instead of
        -- having empty data, we use the buff name.
        --
        local function GetPotionInfo(spellid)
            local potionid = potionIDs[spellid] or spellid
            local name, _, _, _, _, _, _, _, _, icon = _GetItemInfo(potionid)
            if not name then
                name, _, icon = _GetSpellInfo(spellid)
            end
            return name, icon
        end

        local cached = {}

        function playermod:Enter(win, id, label)
            self.playerid = id
            self.playername = label
            self.title = _format(L["%s's used potions"], label)
        end

        function playermod:Update(win, set)
            if cached.count > 0 then
                local nr, max = 1, 0

                for name, player in _pairs(cached.players) do
                    if name == self.playername and player.id == self.playerid then
                        for spellid, count in _pairs(player.spells) do
                            local d = win.dataset[nr] or {}
                            win.dataset[nr] = d

                            local potionname, poitionicon = GetPotionInfo(spellid)

                            d.id = spellid
                            d.spellid = spellid
                            d.label = potionname
                            d.icon = poitionicon

                            d.value = count
                            d.valuetext =
                                Skada:FormatValueText(
                                count,
                                mod.metadata.columns.Count,
                                _format("%02.1f%%", 100 * count / player.count),
                                mod.metadata.columns.Percent
                            )

                            if count > max then
                                max = count
                            end

                            nr = nr + 1
                        end
                    end
                end

                win.metadata.maxvalue = max
            end
        end

        function mod:Update(win, set)
            cached = {count = 0, players = {}}
            for _, player in _ipairs(set.players) do
                if player.auras then
                    for spellid, spell in _pairs(player.auras) do
                        if potionIDs[spellid] then
                            cached.count = cached.count + spell.count

                            -- add the player to the list.
                            if not cached.players[player.name] then
                                cached.players[player.name] = {
                                    id = player.id,
                                    class = player.class,
                                    role = player.role,
                                    spec = player.spec
                                }
                            end

                            -- increment both players global potions and individual potion usage.
                            cached.players[player.name].count = (cached.players[player.name].count or 0) + spell.count
                            cached.players[player.name].spells = cached.players[player.name].spells or {}
                            cached.players[player.name].spells[spellid] =
                                (cached.players[player.name].spells[spellid] or 0) + spell.count
                        end
                    end
                end
            end

            local max = 0
            if cached.count > 0 then
                local nr = 1

                for playername, player in _pairs(cached.players) do
                    local d = win.dataset[nr] or {}
                    win.dataset[nr] = d

                    d.id = player.id
                    d.label = playername
                    d.class = player.class
                    d.role = player.role
                    d.spec = player.spec

                    d.value = player.count
                    d.valuetext =
                        Skada:FormatValueText(
                        player.count,
                        self.metadata.columns.Count,
                        _format("%02.1f%%", 100 * player.count / cached.count),
                        self.metadata.columns.Percent
                    )

                    if player.count > max then
                        max = player.count
                    end

                    nr = nr + 1
                end
            end

            win.metadata.maxvalue = max
        end

        function mod:OnEnable()
            self.metadata = {click1 = playermod, columns = {Count = true, Percent = true}}
            Skada:AddMode(self, L["Buffs and Debuffs"])
        end

        function mod:OnDisable()
            Skada:RemoveMode(self)
        end
    end
)

-- ================================================================== --

Skada:AddLoadableModule(
    "Debuffs",
    nil,
    function(Skada, L)
        if Skada:IsDisabled("Debuffs") then
            return
        end

        local mod = Skada:NewModule(L["Debuffs"])
        local spellmod = mod:NewModule(L["Debuff spell list"])
        local targetmod = mod:NewModule(L["Debuff target list"])

        --
        -- used to record debuffs and rely on AuraApplied and AuraRemoved functions
        --
        local function DebuffApplied(timestamp, eventtype, srcGUID, srcName, _, dstGUID, dstName, dstFlags, ...)
            if srcName == nil and #srcGUID == 0 and dstName and #dstGUID > 0 then
                srcGUID = dstGUID
                srcName = dstName

                if eventtype == "SPELL_AURA_APPLIED" then
                    AuraApplied(timestamp, eventtype, srcGUID, srcName, dstFlags, dstGUID, dstName, dstFlags, ...)
                else
                    AuraRemoved(timestamp, eventtype, srcGUID, srcName, dstFlags, dstGUID, dstName, dstFlags, ...)
                end
            end
        end

        function targetmod:Enter(win, id, label)
            self.spellid = id
            self.title = _format(L["%s's <%s> targets"], spellmod.playername, label)
        end

        function targetmod:Update(win, set)
            local player = Skada:find_player(set, spellmod.playerid)
            local max = 0
            if player and player.auras[self.spellid] then
                local nr = 1

                local total = player.auras[self.spellid].count

                for targetname, target in _pairs(player.auras[self.spellid].targets) do
                    local d = win.dataset[nr] or {}
                    win.dataset[nr] = d

                    d.id = target.id
                    d.label = targetname

                    d.value = target.count
                    d.valuetext = _format("%u (%02.1f%%)", target.count, 100 * target.count / total)

                    if target.count > max then
                        max = target.count
                    end

                    nr = nr + 1
                end
            end

            win.metadata.maxvalue = max
        end

        function spellmod:Enter(win, id, label)
            self.playerid = id
            self.playername = label
            self.title = _format(L["%s's debuffs"], label)
        end

        function spellmod:Update(win, set)
            detailupdatefunc("DEBUFF", win, set, self.playerid)
        end

        function mod:Update(win, set)
            updatefunc("DEBUFF", win, set)
        end

        local function debuff_tooltip(win, set, label, tooltip)
            aura_tooltip(win, set, label, tooltip, spellmod.playerid, L)
        end

        function mod:OnEnable()
            spellmod.metadata = {tooltip = debuff_tooltip, click1 = targetmod}
            mod.metadata = {showspots = true, click1 = spellmod}

            Skada:RegisterForCL(
                DebuffApplied,
                "SPELL_AURA_APPLIED",
                {dst_is_interesting_nopets = true, src_is_not_interesting = true}
            )
            Skada:RegisterForCL(
                DebuffApplied,
                "SPELL_AURA_REMOVED",
                {dst_is_interesting_nopets = true, src_is_not_interesting = true}
            )

            Skada:AddMode(self, L["Buffs and Debuffs"])
        end

        function mod:OnDisable()
            Skada:RemoveMode(self)
        end

        function mod:AddPlayerAttributes(player)
            if not player.auras then
                player.auras = {}
            end
        end

        function mod:AddSetAttributes(set)
            set.auras = {}
            setattributes(set)
        end

        function mod:SetComplete(set)
            setcomplete(set)
        end
    end
)

-- ================================================================== --

Skada:AddLoadableModule(
    "Sunder Counter",
    function(Skada, L)
        if Skada:IsDisabled("Debuffs", "Sunder Count") then
            return
        end

        local mod = Skada:NewModule(L["Sunder Counter"])
        local targetmod = mod:NewModule(L["Sunder target list"])

        local cached, sunder = {}

        local function total_sunders(set)
            sunder = sunder or _select(1, _GetSpellInfo(47467))
            local total = 0

            if set then
                for _, player in ipairs(set.players) do
                    if player.class == "WARRIOR" and player.auras then
                        for spellid, spell in _pairs(player.auras) do
                            if sunder == _select(1, _GetSpellInfo(spellid)) then
                                total = total + spell.count
                            end
                        end
                    end
                end
            end

            return total
        end

        local function increment_sunder(set, playerid, playername, playerflags, spellid, dstName)
            local player = Skada:get_player(set, playerid, playername, playerflags)
            if player then
                player.auras = player.auras or {}
                --
                -- if sunder wasn't applied the first time, we make sure to call the
                -- AuraApplied function that will handle applying it.
                --
                if not player.auras[spellid] then
                    --
                    -- otherwise, we simply increment the count
                    AuraApplied(
                        nil,
                        nil,
                        playerid,
                        playername,
                        playerflags,
                        nil,
                        dstName,
                        nil,
                        spellid,
                        nil,
                        1,
                        "DEBUFF"
                    )
                else
                    player.auras[spellid].count = (player.auras[spellid].count or 0) + 1
                    player.auras[spellid].started = time()

                    if player.auras[spellid].targets[dstName] then
                        player.auras[spellid].targets[dstName].count =
                            (player.auras[spellid].targets[dstName].count or 0) + 1
                    end
                end
            end
        end

        local function SunderApplied(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
            local spellid, spellname, spellschool = ...
            if spellname == sunder then
                increment_sunder(Skada.current, srcGUID, srcName, srcFlags, spellid, dstName)
                increment_sunder(Skada.total, srcGUID, srcName, srcFlags, spellid, dstName)
            end
        end

        function targetmod:Enter(win, id, label)
            self.playername = label
            self.title = _format(L["%s's <%s> targets"], label, sunder)
        end

        function targetmod:Update(win, set)
            local max = 0

            if cached.players and self.playername and cached.players[self.playername] then
                local player = cached.players[self.playername]
                local nr = 1

                for targetname, count in _pairs(player.targets) do
                    local d = win.dataset[nr] or {}
                    win.dataset[nr] = d

                    d.id = targetname
                    d.label = targetname

                    d.value = count
                    d.valuetext = _format("%d (%02.1f%%)", count, 100 * count / math_max(1, player.count))

                    if count > max then
                        max = count
                    end

                    nr = nr + 1
                end
            end
            win.metadata.maxvalue = max
        end

        function mod:Update(win, set)
            sunder = sunder or _select(1, _GetSpellInfo(47467))
            cached = {count = 0, players = {}}

            for _, player in _ipairs(set.players) do
                if player.class == "WARRIOR" and player.auras then
                    for spellid, spell in _pairs(player.auras) do
                        if _select(1, _GetSpellInfo(spellid)) == sunder then
                            cached.count = cached.count + spell.count
                            if not cached.players[player.name] then
                                cached.players[player.name] = {
                                    id = player.id,
                                    class = player.class,
                                    role = player.role,
                                    spec = player.spec,
                                    count = spell.count,
                                    targets = {}
                                }
                            else
                                cached.players[player.name].count = cached.players[player.name].count + spell.count
                            end

                            cached.players[player.name].targets = cached.players[player.name].targets or {}

                            for targetname, target in _pairs(spell.targets) do
                                if not cached.players[player.name].targets[targetname] then
                                    cached.players[player.name].targets[targetname] = target.count
                                else
                                    cached.players[player.name].targets[targetname] =
                                        cached.players[player.name].targets[targetname] + target.count
                                end
                            end
                        end
                    end
                end
            end

            local max = 0

            if cached.count > 0 then
                local nr = 1

                for playername, player in _pairs(cached.players) do
                    local d = win.dataset[nr] or {}
                    win.dataset[nr] = d

                    d.id = player.id or playername
                    d.label = playername
                    d.class = player.class
                    d.role = player.role
                    d.spec = player.spec

                    d.value = player.count
                    d.valuetext = _tostring(player.count)

                    if player.count > max then
                        max = player.count
                    end

                    nr = nr + 1
                end
            end

            win.metadata.maxvalue = max
        end

        function mod:OnEnable()
            mod.metadata = {showspots = true, click1 = targetmod}
            Skada:RegisterForCL(SunderApplied, "SPELL_CAST_SUCCESS", {src_is_interesting_nopets = true})
            Skada:AddMode(self, L["Buffs and Debuffs"])
        end

        function mod:OnDisable()
            Skada:RemoveMode(self)
        end

        function mod:OnInitialize()
            sunder = sunder or _select(1, _GetSpellInfo(47467))
        end

        function mod:AddToTooltip(set, tooltip)
            sunder = sunder or _select(1, _GetSpellInfo(47467))
            local total = total_sunders(set)
            if total > 0 then
                tooltip:AddDoubleLine(sunder, total, 1, 1, 1)
            end
        end

        function mod:GetSetSummary(set)
            return total_sunders(set)
        end
    end
)