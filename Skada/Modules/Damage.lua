assert(Skada, "Skada not found!")

local _pairs, _ipairs, _select = pairs, ipairs, select
local _format, math_max = string.format, math.max
local _UnitGUID, _UnitClass = UnitGUID, Skada.UnitClass
local _GetSpellInfo = Skada.GetSpellInfo or GetSpellInfo

-- list of miss types
local misstypes = {"ABSORB", "BLOCK", "DEFLECT", "DODGE", "EVADE", "IMMUNE", "MISS", "PARRY", "REFLECT", "RESIST"}

-- ================== --
-- Damage Done module --
-- ================== --

Skada:AddLoadableModule("Damage", function(Skada, L)
	if Skada:IsDisabled("Damage") then return end

	local mod = Skada:NewModule(L["Damage"])
	local playermod = mod:NewModule(L["Damage spell list"])
	local spellmod = playermod:NewModule(L["Damage spell details"])
	local targetmod = mod:NewModule(L["Damage target list"])

	local dpsmod = Skada:NewModule(L["DPS"])

	local LBB = LibStub("LibBabble-Boss-3.0"):GetLookupTable()

	--
	-- holds the name of targets used to record useful damage
	--
	local groupName, validTarget

	--
	-- the instance difficulty is only called once to reduce
	-- useless multiple calls that return the same thing
	-- This value is set to nil on SetComplete
	--
	local instanceDiff

	local function get_raid_diff()
		if not instanceDiff then
			local _, instanceType, difficulty, _, _, dynamicDiff, isDynamic = GetInstanceInfo()
			if instanceType == "raid" and isDynamic then
				if difficulty == 1 or difficulty == 3 then -- 10man raid
					instanceDiff = (dynamicDiff == 0) and "10n" or ((dynamicDiff == 1) and "10h" or "unknown")
				elseif difficulty == 2 or difficulty == 4 then -- 25main raid
					instanceDiff = (dynamicDiff == 0) and "25n" or ((dynamicDiff == 1) and "25h" or "unknown")
				end
			else
				local insDiff = GetInstanceDifficulty()
				if insDiff == 1 then
					instanceDiff = "10n"
				elseif insDiff == 2 then
					instanceDiff = "25n"
				elseif insDiff == 3 then
					instanceDiff = "10h"
				elseif insDiff == 4 then
					instanceDiff = "25h"
				end
			end
		end

		return instanceDiff
	end

	local valkyrsTable
	local valkyr10hp, valkyr25hp = 1900000, 2992000

	local function log_extra_data(spell, dmg, set, player)
		if not (spell and dmg) then return end

		spell.totalhits = (spell.totalhits or 0) + 1
		spell.amount = (spell.amount or 0) + dmg.amount

		if spell.max == nil or dmg.amount > spell.max then
			spell.max = dmg.amount
		end

		if (spell.min == nil or dmg.amount < spell.min) and not dmg.missed then
			spell.min = dmg.amount
		end
		if dmg.critical then
			spell.critical = (spell.critical or 0) + 1
			spell.criticalamount = (spell.criticalamount or 0) + dmg.amount

			if not spell.criticalmax or dmg.amount > spell.criticalmax then
				spell.criticalmax = dmg.amount
			end

			if not spell.criticalmin or dmg.amount < spell.criticalmin then
				spell.criticalmin = dmg.amount
			end
		elseif dmg.missed ~= nil then
			spell[dmg.missed] = (spell[dmg.missed] or 0) + 1
		elseif dmg.glancing then
			spell.glancing = (spell.glancing or 0) + 1
		elseif dmg.crushing then
			spell.crushing = (spell.crushing or 0) + 1
		else
			spell.hit = (spell.hit or 0) + 1
			spell.hitamount = (spell.hitamount or 0) + dmg.amount
			if not spell.hitmax or dmg.amount > spell.hitmax then
				spell.hitmax = dmg.amount
			end
			if not spell.hitmin or dmg.amount < spell.hitmin then
				spell.hitmin = dmg.amount
			end
		end

		if dmg.absorbed then
			spell.absorbed = (spell.absorbed or 0) + dmg.absorbed
			if set and set.damagedone then
				set.damagedone.absorbed = (set.damagedone.absorbed or 0) + dmg.absorbed
			end
			if player and player.damagedone then
				player.damagedone.absorbed = (player.damagedone.absorbed or 0) + dmg.absorbed
			end
		end

		if dmg.blocked then
			spell.blocked = (spell.blocked or 0) + dmg.blocked
			if set and set.damagedone then
				set.damagedone.blocked = (set.damagedone.blocked or 0) + dmg.blocked
			end
			if player and player.damagedone then
				player.damagedone.blocked = (player.damagedone.blocked or 0) + dmg.blocked
			end
		end

		if dmg.resisted then
			spell.resisted = (spell.resisted or 0) + dmg.resisted
			if set and set.damagedone then
				set.damagedone.resisted = (set.damagedone.resisted or 0) + dmg.resisted
			end
			if player and player.damagedone then
				player.damagedone.resisted = (player.damagedone.resisted or 0) + dmg.resisted
			end
		end

		-- add the damage overkill
		if (dmg.overkill or 0) > 0 then
			spell.overkill = (spell.overkill or 0) + dmg.overkill
			if set and set.damagedone then
				set.damagedone.overkill = (set.damagedone.overkill or 0) + dmg.overkill
			end
			if player then
				player.damagedone.overkill = (player.damagedone.overkill or 0) + dmg.overkill
			end
		end
	end

	local function log_damage(set, dmg, tick)
		local player = Skada:get_player(set, dmg.playerid, dmg.playername, dmg.playerflags)
		if not player then return end

		player.damagedone = player.damagedone or {amount = 0}
		player.damagedone.amount = (player.damagedone.amount or 0) + dmg.amount
		set.damagedone = set.damagedone or {amount = 0}
		set.damagedone.amount = (set.damagedone.amount or 0) + dmg.amount

		local spellname = dmg.spellname
		local spell = player.damagedone.spells and player.damagedone.spells[spellname]
		if not spell then
			player.damagedone.spells = player.damagedone.spells or {}
			spell = {id = dmg.spellid, school = dmg.spellschool, amount = 0}
			player.damagedone.spells[spellname] = spell
		elseif dmg.spellschool and dmg.spellschool ~= spell.school then
			spellname = spellname .. " (" .. (Skada.schoolnames[dmg.spellschool] or OTHER) .. ")"
			if not player.damagedone.spells[spellname] then
				player.damagedone.spells[spellname] = {id = dmg.spellid, school = dmg.spellschool, amount = 0}
			end
			spell = player.damagedone.spells[spellname]
		end

		spell.isdot = tick or nil -- DoT
		log_extra_data(spell, dmg, set, player)

		if dmg.dstName then
			spell.targets = spell.targets or {}
			spell.targets[dmg.dstName] = spell.targets[dmg.dstName] or {id = dmg.dstGUID, amount = 0}
			log_extra_data(spell.targets[dmg.dstName], dmg)

			player.damagedone.targets = player.damagedone.targets or {}
			player.damagedone.targets[dmg.dstName] = player.damagedone.targets[dmg.dstName] or {id = dmg.dstGUID, amount = 0}
			log_extra_data(player.damagedone.targets[dmg.dstName], dmg)

			set.damagedone.targets = set.damagedone.targets or {}
			set.damagedone.targets[dmg.dstName] = (set.damagedone.targets[dmg.dstName] or 0) + dmg.amount

			if not spell.targets[dmg.dstName].class then
				local class = _select(2, _UnitClass(dmg.dstGUID, dmg.dstFlags))
				spell.targets[dmg.dstName].class = class
				player.damagedone.targets[dmg.dstName].class = class
			end

			-- add useful damage.
			if validTarget[dmg.dstName] then
				local altname = groupName[validTarget[dmg.dstName]]

				-- same name, ignore to not have double damage.
				if altname == dmg.dstName then return end

				-- useful damage on Val'kyrs
				if dmg.dstName == LBB["Val'kyr Shadowguard"] then
					local diff = get_raid_diff()

					-- useful damage accounts only on heroic mode.
					if diff == "10h" or diff == "25h" then
						-- we make sure to always have a table.
						valkyrsTable = valkyrsTable or {}

						-- valkyr's max health depending on the difficulty
						local maxhp = diff == "10h" and valkyr10hp or valkyr25hp

						-- we make sure to add our valkyr to the table
						if not valkyrsTable[dmg.dstGUID] then
							valkyrsTable[dmg.dstGUID] = maxhp - dmg.amount
						else
							--
							-- here, the valkyr was already recorded, it reached half its health
							-- but the player still dpsing it. This counts as useless damage.
							--
							if valkyrsTable[dmg.dstGUID] < maxhp / 2 then
								spell.targets[L["Valkyrs overkilling"]] = spell.targets[L["Valkyrs overkilling"]] or {amount = 0}
								log_extra_data(spell.targets[L["Valkyrs overkilling"]], dmg)

								player.damagedone.targets[L["Valkyrs overkilling"]] = player.damagedone.targets[L["Valkyrs overkilling"]] or {amount = 0}
								log_extra_data(player.damagedone.targets[L["Valkyrs overkilling"]], dmg)
								return
							end

							-- deducte the damage
							valkyrsTable[dmg.dstGUID] = valkyrsTable[dmg.dstGUID] - dmg.amount
						end
					end
				end

				-- if we are on BPC, we attempt to catch overkilling
				local amount = (validTarget[dmg.dstName] == LBB["Blood Prince Council"]) and dmg.overkill or dmg.amount

				spell.targets[altname] = spell.targets[altname] or {amount = 0}
				log_extra_data(spell.targets[altname], dmg)

				player.damagedone.targets[altname] = player.damagedone.targets[altname] or {amount = 0}
				log_extra_data(player.damagedone.targets[altname], dmg)

				set.damagedone.targets[altname] = (set.damagedone.targets[altname] or 0) + amount
			end
		end
	end

	local dmg = {}

	local function SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		if srcGUID ~= dstGUID then
			local spellid, spellname, spellschool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = ...

			dmg.playerid = srcGUID
			dmg.playername = srcName
			dmg.playerflags = srcFlags

			dmg.dstGUID = dstGUID
			dmg.dstName = dstName
			dmg.dstFlags = dstFlags

			dmg.spellid = spellid
			dmg.spellname = spellname
			dmg.spellschool = spellschool
			dmg.amount = amount

			dmg.overkill = overkill
			dmg.resisted = resisted
			dmg.blocked = blocked
			dmg.absorbed = absorbed
			dmg.critical = critical
			dmg.glancing = glancing
			dmg.crushing = crushing
			dmg.missed = nil

			Skada:FixPets(dmg)

			log_damage(Skada.current, dmg, eventtype == "SPELL_PERIODIC_DAMAGE")
			log_damage(Skada.total, dmg, eventtype == "SPELL_PERIODIC_DAMAGE")
		end
	end

	local function SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		SpellDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, 6603, L["Auto Attack"], 1, ...)
	end

	local function SpellMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		if srcGUID ~= dstGUID then
			local spellid, spellname, spellschool, misstype, amount = ...

			dmg.playerid = srcGUID
			dmg.playername = srcName
			dmg.playerflags = srcFlags

			dmg.dstGUID = dstGUID
			dmg.dstName = dstName
			dmg.dstFlags = dstFlags

			dmg.spellid = spellid
			dmg.spellname = spellname
			dmg.spellschool = spellschool
			dmg.amount = 0

			dmg.overkill = 0
			dmg.resisted = nil
			dmg.blocked = nil
			dmg.absorbed = nil
			dmg.critical = nil
			dmg.glancing = nil
			dmg.crushing = nil
			dmg.missed = misstype

			Skada:FixPets(dmg)

			log_damage(Skada.current, dmg)
			log_damage(Skada.total, dmg)
		end
	end

	local function SwingMissed(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		SpellMissed(nil, nil, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, 6603, L["Auto Attack"], 1, ...)
	end

	local function getDPS(set, player)
		local amount = player.damagedone and player.damagedone.amount or 0
		return amount / math_max(1, Skada:PlayerActiveTime(set, player)), amount
	end

	local function getRaidDPS(set)
		local amount = set.damagedone and set.damagedone.amount or 0
		if set.time > 0 then
			return amount / math_max(1, set.time), amount
		else
			return amount / math_max(1, (set.endtime or time()) - set.starttime), amount
		end
	end

	local function damage_tooltip(win, id, label, tooltip)
		local set = win:get_selected_set()
		local player = Skada:find_player(set, id)
		if player then
			local totaltime = Skada:GetSetTime(set)
			local activetime = Skada:PlayerActiveTime(set, player)
			tooltip:AddDoubleLine(L["Activity"], _format("%02.1f%%", 100 * activetime / totaltime), 1, 1, 1)
			tooltip:AddDoubleLine(L["Segment Time"], Skada:FormatTime(totaltime), 1, 1, 1)
			tooltip:AddDoubleLine(L["Active Time"], Skada:FormatTime(Skada:PlayerActiveTime(set, player, true)), 1, 1, 1)
		end
	end

	local function dps_tooltip(win, id, label, tooltip)
		local set = win:get_selected_set()
		local player = Skada:find_player(set, id)
		if player then
			local totaltime = Skada:GetSetTime(set)
			local activetime = Skada:PlayerActiveTime(set, player)
			local dps, amount = getDPS(set, player)
			tooltip:AddLine(player.name .. " - " .. L["DPS"])
			tooltip:AddDoubleLine(L["Segment Time"], Skada:FormatTime(totaltime), 1, 1, 1)
			tooltip:AddDoubleLine(L["Active Time"], Skada:FormatTime(Skada:PlayerActiveTime(set, player, true)), 1, 1, 1)
			tooltip:AddDoubleLine(L["Damage done"], Skada:FormatNumber(player.damagedone.amount), 1, 1, 1)
			tooltip:AddDoubleLine(Skada:FormatNumber(amount) .. "/" .. Skada:FormatTime(activetime), Skada:FormatNumber(dps), 1, 1, 1)
		end
	end

	local function playermod_tooltip(win, id, label, tooltip)
		local player = Skada:find_player(win:get_selected_set(), win.playerid)
		if player and player.damagedone then
			local spell = player.damagedone.spells and player.damagedone.spells[id]
			if spell then
				tooltip:AddLine(player.name .. " - " .. label)

				if spell.school then
					local c = Skada.schoolcolors[spell.school]
					local n = Skada.schoolnames[spell.school]
					if c and n then tooltip:AddLine(n, c.r, c.g, c.b) end
				end

				if spell.max and spell.min then
					tooltip:AddDoubleLine(L["Minimum hit:"], Skada:FormatNumber(spell.min), 1, 1, 1)
					tooltip:AddDoubleLine(L["Maximum hit:"], Skada:FormatNumber(spell.max), 1, 1, 1)
				end
				tooltip:AddDoubleLine(L["Average hit:"], Skada:FormatNumber((spell.amount or 0) / spell.totalhits), 1, 1, 1)
				tooltip:AddDoubleLine(L["Total hits:"], tostring(spell.totalhits), 1, 1, 1)
			end
		end
	end

	local function targetmod_tooltip(win, id, label, tooltip)
		local player = Skada:find_player(win:get_selected_set(), win.playerid)
		if player and player.damagedone then
			local target = player.damagedone.targets and player.damagedone.targets[label]
			if target then
				tooltip:AddLine(_format(L["%s's damage on %s"], player.name, label))

				-- real total
				local total = (target.amount or 0)
				local overkill, absorbed, blocked, resisted

				if (target.overkill or 0) > 0 then
					overkill = target.overkill
					total = total + target.overkill
				end

				if (target.absorbed or 0) > 0 then
					absorbed = target.absorbed
					total = total + target.absorbed
				end

				if (target.blocked or 0) > 0 then
					blocked = target.blocked
					total = total + target.blocked
				end

				if (target.resisted or 0) > 0 then
					resisted = target.resisted
					total = total + target.resisted
				end

				tooltip:AddDoubleLine(L["Total"], Skada:FormatNumber(total), 1, 1, 1)
				tooltip:AddDoubleLine(L["Damage"], Skada:FormatNumber(target.amount or 0), 1, 1, 1)

				if overkill then
					tooltip:AddDoubleLine(L["Overkill"], _format("%s (%02.1f%%)", Skada:FormatNumber(overkill), 100 * overkill / math_max(total)), 1, 1, 1)
				end

				if absorbed then
					tooltip:AddDoubleLine(ABSORB, _format("%s (%02.1f%%)", Skada:FormatNumber(absorbed), 100 * absorbed / math_max(total)), 1, 1, 1)
				end
				if blocked then
					tooltip:AddDoubleLine(BLOCK, _format("%s (%02.1f%%)", Skada:FormatNumber(blocked), 100 * blocked / math_max(total)), 1, 1, 1)
				end
				if resisted then
					tooltip:AddDoubleLine(RESIST, _format("%s (%02.1f%%)", Skada:FormatNumber(resisted), 100 * resisted / math_max(total)), 1, 1, 1)
				end

				if target.max and target.min then
					tooltip:AddDoubleLine(L["Minimum hit:"], Skada:FormatNumber(target.min), 1, 1, 1)
					tooltip:AddDoubleLine(L["Maximum hit:"], Skada:FormatNumber(target.max), 1, 1, 1)
				end

				tooltip:AddLine(" ")
				tooltip:AddLine(_format(L["%s's damage breakdown"], label))
				tooltip:AddDoubleLine(L["Total hits:"], target.totalhits or 0, 1, 1, 1)
				if (target.hit or 0) > 0 then
					tooltip:AddDoubleLine(HIT, _format("%d (%02.1f%%)", target.hit, 100 * target.hit / math_max(1, target.totalhits or 0)), 1, 1, 1)
				end
				if (target.critical or 0) > 0 then
					tooltip:AddDoubleLine(CRIT_ABBR, _format("%d (%02.1f%%)", target.critical, 100 * target.critical / math_max(1, target.totalhits or 0)), 1, 1, 1)
				end
				for _, misstype in _ipairs(misstypes) do
					if (target[misstype] or 0) > 0 then
						local title = _G[misstype] or _G["ACTION_SPELL_MISSED" .. misstype] or misstype
						tooltip:AddDoubleLine(title, _format("%d (%02.1f%%)", target[misstype], 100 * target[misstype] / math_max(1, target.totalhits or 0)), 1, 1, 1)
					end
				end
			end
		end
	end

	local function spellmod_tooltip(win, id, label, tooltip)
		if label == CRIT_ABBR or label == HIT or label == ABSORB or label == BLOCK or label == RESIST then
			local player = Skada:find_player(win:get_selected_set(), win.playerid)
			if player and player.damagedone then
				local spell = player.damagedone.spells and player.damagedone.spells[win.spellname]
				if spell then
					tooltip:AddLine(player.name .. " - " .. win.spellname)

					if spell.school then
						local c = Skada.schoolcolors[spell.school]
						local n = Skada.schoolnames[spell.school]
						if c and n then tooltip:AddLine(n, c.r, c.g, c.b) end
					end

					if label == CRIT_ABBR and spell.criticalamount then
						tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(spell.criticalmin), 1, 1, 1)
						tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(spell.criticalmax), 1, 1, 1)
						tooltip:AddDoubleLine(L["Average"], Skada:FormatNumber(spell.criticalamount / spell.critical), 1, 1, 1)
					elseif label == HIT and spell.hitamount then
						tooltip:AddDoubleLine(L["Minimum"], Skada:FormatNumber(spell.hitmin), 1, 1, 1)
						tooltip:AddDoubleLine(L["Maximum"], Skada:FormatNumber(spell.hitmax), 1, 1, 1)
						tooltip:AddDoubleLine(L["Average"], Skada:FormatNumber(spell.hitamount / spell.hit), 1, 1, 1)
					elseif label == ABSORB and (spell.absorbed or 0) > 0 then
						tooltip:AddDoubleLine(L["Amount"], Skada:FormatNumber(spell.absorbed), 1, 1, 1)
					elseif label == BLOCK and (spell.blocked or 0) > 0 then
						tooltip:AddDoubleLine(L["Amount"], Skada:FormatNumber(spell.blocked), 1, 1, 1)
					elseif label == RESIST and (spell.resisted or 0) > 0 then
						tooltip:AddDoubleLine(L["Amount"], Skada:FormatNumber(spell.resisted), 1, 1, 1)
					end
				end
			end
		end
	end

	function playermod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = _format(L["%s's damage"], label)
	end

	function playermod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)

		if player then
			win.title = _format(L["%s's damage"], player.name)
			local total = _select(2, getDPS(set, player))

			if total > 0 and player.damagedone.spells then
				local maxvalue, nr = 0, 1

				for spellname, spell in _pairs(player.damagedone.spells) do
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = spellname
					d.spellid = spell.id
					d.label = spellname
					d.text = spellname .. (spell.isdot and L["DoT"] or "")
					d.icon = _select(3, _GetSpellInfo(spell.id))
					d.spellschool = spell.school

					d.value = spell.amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(spell.amount),
						mod.metadata.columns.Damage,
						_format("%02.1f%%", 100 * spell.amount / total),
						mod.metadata.columns.Percent
					)

					if spell.amount > maxvalue then
						maxvalue = spell.amount
					end
					nr = nr + 1
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	function targetmod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = _format(L["%s's targets"], label)
	end

	function targetmod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)

		if player then
			win.title = _format(L["%s's targets"], player.name)
			local total = _select(2, getDPS(set, player))

			if total > 0 and player.damagedone.targets then
				local maxvalue, nr = 0, 1

				for targetname, target in _pairs(player.damagedone.targets) do
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = target.id or targetname
					d.label = targetname
					d.class = target.class or "MONSTER"

					d.value = target.amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(target.amount),
						mod.metadata.columns.Damage,
						_format("%02.1f%%", 100 * target.amount / total),
						mod.metadata.columns.Percent
					)

					if target.amount > maxvalue then
						maxvalue = target.amount
					end

					nr = nr + 1
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	local function add_detail_bar(win, nr, title, value, total)
		local d = win.dataset[nr] or {}
		win.dataset[nr] = d

		d.id = title
		d.label = title
		d.value = value
		d.valuetext = Skada:FormatValueText(
			total and Skada:FormatNumber(value) or value,
			mod.metadata.columns.Damage,
			_format("%02.1f%%", 100 * value / math_max(1, total or win.metadata.maxvalue)),
			mod.metadata.columns.Percent
		)
		nr = nr + 1
		return nr
	end

	function spellmod:Enter(win, id, label)
		win.spellname = label
		win.title = _format(L["%s's <%s> damage"], win.playername or UNKNOWN, label)
	end

	function spellmod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)

		if player then
			win.title = _format(L["%s's <%s> damage"], player.name, win.spellname or UNKNOWN)

			local spell
			if player.damagedone and player.damagedone.spells and player.damagedone.spells[win.spellname] then
				spell = player.damagedone.spells[win.spellname]
			end

			if spell then
				win.metadata.maxvalue = spell.totalhits

				local nr = 1

				if (spell.overkill or 0) > 0 then
					local total = (spell.amount or 0) + spell.overkill
					nr = add_detail_bar(win, nr, L["Overkill"], spell.overkill, total)
				end

				if (spell.hit or 0) > 0 then
					nr = add_detail_bar(win, nr, HIT, spell.hit)
				end
				if (spell.critical or 0) > 0 then
					nr = add_detail_bar(win, nr, CRIT_ABBR, spell.critical)
				end
				if (spell.glancing or 0) > 0 then
					nr = add_detail_bar(win, nr, L["Glancing"], spell.glancing)
				end
				if (spell.crushing or 0) > 0 then
					nr = add_detail_bar(win, nr, L["Crushing"], spell.crushing)
				end
				for _, misstype in _ipairs(misstypes) do
					if (spell[misstype] or 0) > 0 then
						nr = add_detail_bar(win, nr, _G[misstype] or _G["ACTION_SPELL_MISSED" .. misstype] or misstype, spell[misstype])
					end
				end
			end
		end
	end

	function dpsmod:Update(win, set)
		win.title = L["DPS"]
		local total = getRaidDPS(set)

		if total > 0 then
			local maxvalue, nr = 0, 1

			for _, player in _ipairs(set.players) do
				local amount = getDPS(set, player)

				if amount > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = player.name
					d.class = player.class or "PET"
					d.role = player.role or "DAMAGER"
					d.spec = player.spec or 1

					d.value = amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(amount),
						self.metadata.columns.DPS,
						_format("%02.1f%%", 100 * amount / total),
						self.metadata.columns.Percent
					)

					if amount > maxvalue then
						maxvalue = amount
					end
					nr = nr + 1
				end
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:Update(win, set)
		win.title = L["Damage"]
		local total = _select(2, getRaidDPS(set))

		if total > 0 then
			local maxvalue, nr = 0, 1

			for _, player in _ipairs(set.players) do
				local dps, amount = getDPS(set, player)

				if amount > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = player.name
					d.class = player.class or "PET"
					d.role = player.role or "DAMAGER"
					d.spec = player.spec or 1

					d.value = amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(amount),
						self.metadata.columns.Damage,
						Skada:FormatNumber(dps),
						self.metadata.columns.DPS,
						_format("%02.1f%%", 100 * amount / total),
						self.metadata.columns.Percent
					)

					if amount > maxvalue then
						maxvalue = amount
					end

					nr = nr + 1
				end
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	local function feed_personal_dps()
		if Skada.current then
			local player = Skada:find_player(Skada.current, _UnitGUID("player"))
			if player then
				return Skada:FormatNumber(getDPS(Skada.current, player)) .. " " .. L["DPS"]
			end
		end
	end

	local function feed_raid_dps()
		if Skada.current then
			return Skada:FormatNumber(getRaidDPS(Skada.current)) .. " " .. L["RDPS"]
		end
	end

	--
	-- we make sure to fill our groupName and validTarget tables
	-- used to record damage on useful targets
	--
	function mod:OnInitialize()
		if not groupName then
			groupName = {
				[LBB["The Lich King"]] = L["Useful targets"],
				[LBB["Professor Putricide"]] = L["Oozes"],
				[LBB["Blood Prince Council"]] = L["Princes overkilling"],
				[LBB["Lady Deathwhisper"]] = L["Adds"],
				[LBB["Halion"]] = L["Halion and Inferno"]
			}
		end

		if not validTarget then
			validTarget = {
				-- The Lich King fight
				[LBB["The Lich King"]] = LBB["The Lich King"],
				[LBB["Raging Spirit"]] = LBB["The Lich King"],
				[LBB["Ice Sphere"]] = LBB["The Lich King"],
				[LBB["Val'kyr Shadowguard"]] = LBB["The Lich King"],
				[L["Wicked Spirit"]] = LBB["The Lich King"],
				-- Professor Putricide
				[L["Gas Cloud"]] = LBB["Professor Putricide"],
				[L["Volatile Ooze"]] = LBB["Professor Putricide"],
				-- Blood Prince Council
				[LBB["Prince Valanar"]] = LBB["Blood Prince Council"],
				[LBB["Prince Taldaram"]] = LBB["Blood Prince Council"],
				[LBB["Prince Keleseth"]] = LBB["Blood Prince Council"],
				-- Lady Deathwhisper
				[L["Cult Adherent"]] = LBB["Lady Deathwhisper"],
				[L["Empowered Adherent"]] = LBB["Lady Deathwhisper"],
				[L["Reanimated Adherent"]] = LBB["Lady Deathwhisper"],
				[L["Cult Fanatic"]] = LBB["Lady Deathwhisper"],
				[L["Deformed Fanatic"]] = LBB["Lady Deathwhisper"],
				[L["Reanimated Fanatic"]] = LBB["Lady Deathwhisper"],
				[L["Darnavan"]] = LBB["Lady Deathwhisper"],
				-- Halion
				[LBB["Halion"]] = LBB["Halion"],
				[L["Living Inferno"]] = LBB["Halion"]
			}
		end
	end

	function mod:OnEnable()
		spellmod.metadata = {tooltip = spellmod_tooltip}
		playermod.metadata = {post_tooltip = playermod_tooltip, click1 = spellmod}
		targetmod.metadata = {tooltip = targetmod_tooltip}
		self.metadata = {
			showspots = true,
			post_tooltip = damage_tooltip,
			click1 = playermod,
			click2 = targetmod,
			columns = {Damage = true, DPS = true, Percent = true}
		}

		dpsmod.metadata = {
			showspots = true,
			tooltip = dps_tooltip,
			click1 = playermod,
			click2 = targetmod,
			columns = {DPS = true, Percent = true}
		}

		Skada:RegisterForCL(SpellDamage, "DAMAGE_SHIELD", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "DAMAGE_SPLIT", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "RANGE_DAMAGE", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_BUILDING_DAMAGE", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_DAMAGE", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_EXTRA_ATTACKS", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellDamage, "SPELL_PERIODIC_DAMAGE", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SwingDamage, "SWING_DAMAGE", {src_is_interesting = true, dst_is_not_interesting = true})

		Skada:RegisterForCL(SpellMissed, "DAMAGE_SHIELD_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellMissed, "RANGE_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellMissed, "SPELL_BUILDING_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellMissed, "SPELL_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SpellMissed, "SPELL_PERIODIC_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})
		Skada:RegisterForCL(SwingMissed, "SWING_MISSED", {src_is_interesting = true, dst_is_not_interesting = true})

		Skada:AddFeed(L["Damage: Personal DPS"], feed_personal_dps)
		Skada:AddFeed(L["Damage: Raid DPS"], feed_raid_dps)

		Skada:AddMode(self, L["Damage done"])
		Skada:AddMode(dpsmod, L["Damage done"])
	end

	function mod:OnDisable()
		Skada:RemoveFeed(L["Damage: Personal DPS"])
		Skada:RemoveFeed(L["Damage: Raid DPS"])
		Skada:RemoveMode(self)
		Skada:RemoveMode(dpsmod)
	end

	function mod:AddToTooltip(set, tooltip)
		local dps, amount = getRaidDPS(set)
		tooltip:AddDoubleLine(L["Damage"], Skada:FormatNumber(amount), 1, 1, 1)
		tooltip:AddDoubleLine(L["DPS"], Skada:FormatNumber(dps), 1, 1, 1)
	end

	function dpsmod:GetSetSummary(set)
		return Skada:FormatNumber(getRaidDPS(set))
	end

	function mod:GetSetSummary(set)
		local dps, amount = getRaidDPS(set)
		return Skada:FormatValueText(
			Skada:FormatNumber(amount),
			self.metadata.columns.Damage,
			Skada:FormatNumber(dps),
			self.metadata.columns.DPS
		)
	end

	function mod:AddSetAttributes(set)
		instanceDiff, valkyrsTable = nil, nil
	end

	function mod:SetComplete(set)
		-- clear set.
		if set.damagedone and set.damagedone.amount == 0 then
			set.damagedone.targets = nil
		end
		-- clear players.
		for _, player in _ipairs(set.players) do
			if player.damagedone and player.damagedone.amount == 0 then
				player.damagedone.spells = nil
				player.damagedone.targets = nil
			end
		end
		instanceDiff, valkyrsTable = nil, nil
	end
end)

-- =========================== --
-- Damage done by spell module --
-- =========================== --

Skada:AddLoadableModule("Damage done by spell", function(Skada, L)
	if Skada:IsDisabled("Damage", "Damage done by spell") then return end

	local mod = Skada:NewModule(L["Damage done by spell"])
	local sourcemod = mod:NewModule(L["Damage spell sources"])

	local cached = {}

	function sourcemod:Enter(win, id, label)
		win.spellname = label
		win.title = _format(L["%s's sources"], label)
	end

	function sourcemod:Update(win, set)
		if win.spellname and cached[win.spellname] then
			win.title = _format(L["%s's sources"], win.spellname)
			local total = cached[win.spellname].amount or 0

			if total > 0 then
				local maxvalue, nr = 0, 1

				for playername, player in _pairs(cached[win.spellname].players) do
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = playername
					d.class = player.class or "PET"
					d.role = player.role or "DAMAGER"
					d.spec = player.spec or 1

					d.value = player.amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(player.amount),
						mod.metadata.columns.Damage,
						_format("%02.1f%%", 100 * player.amount / math_max(1, total)),
						mod.metadata.columns.Percent
					)

					if player.amount > maxvalue then
						maxvalue = player.amount
					end
					nr = nr + 1
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	--
	-- Be ware that this module uses a bit of memory because it's
	-- reading and caching spells.
	-- For performance purposes, it is set to only display the data
	-- for a selected set and not for the total.
	-- NOTE: use at your own risk
	--
	function mod:Update(win, set)
		win.title = L["Damage done by spell"]

		if win and win.selectedset ~= "total" then
			cached = wipe(cached or {})

			for _, player in _ipairs(set.players) do
				if player.damagedone and player.damagedone.spells then
					for spellname, spell in _pairs(player.damagedone.spells) do
						if spell.amount > 0 then
							if not cached[spellname] then
								cached[spellname] = {
									id = spell.id,
									school = spell.school,
									amount = spell.amount,
									isdot = spell.isdot,
									players = {}
								}
							else
								cached[spellname].amount = cached[spellname].amount + spell.amount
							end

							-- add the players
							if not cached[spellname].players[player.name] then
								cached[spellname].players[player.name] = {
									id = player.id,
									class = player.class,
									spec = player.spec,
									role = player.role,
									amount = spell.amount
								}
							else
								cached[spellname].players[player.name].amount = cached[spellname].players[player.name].amount + spell.amount
							end
						end
					end
				end
			end

			local maxvalue, nr = 0, 1

			for spellname, spell in _pairs(cached) do
				local d = win.dataset[nr] or {}
				win.dataset[nr] = d

				d.id = spellname
				d.spellid = spell.id
				d.label = spellname
				d.text = spellname .. (spell.isdot and L["DoT"] or "")
				d.icon = _select(3, _GetSpellInfo(spell.id))
				d.spellschool = spell.school

				d.value = spell.amount
				d.valuetext = Skada:FormatValueText(
					Skada:FormatNumber(spell.amount),
					self.metadata.columns.Damage,
					_format("%02.1f%%", 100 * spell.amount / math_max(1, set.damagedone.amount or 0)),
					self.metadata.columns.Percent
				)

				if spell.amount > maxvalue then
					maxvalue = spell.amount
				end
				nr = nr + 1
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:OnEnable()
		sourcemod.metadata = {showspots = true}
		self.metadata = {
			showspots = true,
			click1 = sourcemod,
			columns = {Damage = true, Percent = true}
		}
		Skada:AddMode(self, L["Damage done"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self)
	end
end)

-- ==================== --
-- Useful Damage module --
-- ==================== --
--
-- this module uses the data from Damage module and
-- show the "effective" damage and dps by substructing
-- the overkill from the amount of damage done.
--

Skada:AddLoadableModule("Useful damage", function(Skada, L)
	if Skada:IsDisabled("Damage", "Useful damage") then return end

	local mod = Skada:NewModule(L["Useful damage"])

	local function getDPS(set, player)
		local amount = player.damagedone and ((player.damagedone.amount or 0) - (player.damagedone.overkill or 0)) or 0
		return amount / math_max(1, Skada:PlayerActiveTime(set, player)), amount
	end

	local function getRaidDPS(set)
		local amount = set.damagedone and ((set.damagedone.amount or 0) - (set.damagedone.overkill or 0)) or 0
		if set.time > 0 then
			return amount / math_max(1, set.time), amount
		else
			return amount / math_max(1, (set.endtime or time()) - set.starttime), amount
		end
	end

	function mod:Update(win, set)
		win.title = L["Useful damage"]
		local total = _select(2, getRaidDPS(set))

		if total > 0 then
			local maxvalue, nr = 0, 1

			for _, player in _ipairs(set.players) do
				local dps, amount = getDPS(set, player)

				if amount > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = player.name
					d.class = player.class or "PET"
					d.role = player.role or "DAMAGER"
					d.spec = player.spec or 1

					d.value = amount
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(amount),
						self.metadata.columns.Damage,
						Skada:FormatNumber(dps),
						self.metadata.columns.DPS,
						_format("%02.1f%%", 100 * amount / total),
						self.metadata.columns.Percent
					)

					if amount > maxvalue then
						maxvalue = amount
					end

					nr = nr + 1
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	function mod:OnEnable()
		mod.metadata = {showspots = true, columns = {Damage = true, DPS = true, Percent = true}}
		Skada:AddMode(self, L["Damage done"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self)
	end

	function mod:GetSetSummary(set)
		local dps, amount = getRaidDPS(set)
		return Skada:FormatValueText(
			Skada:FormatNumber(amount),
			self.metadata.columns.Damage,
			Skada:FormatNumber(dps),
			self.metadata.columns.DPS
		)
	end
end)

-- =============== --
-- Overkill module --
-- =============== --

Skada:AddLoadableModule("Overkill", function(Skada, L)
	if Skada:IsDisabled("Damage", "Overkill") then return end

	local mod = Skada:NewModule(L["Overkill"])
	local playermod = mod:NewModule(L["Overkill spell list"])

	function playermod:Enter(win, id, label)
		win.playerid, win.playername = id, label
		win.title = _format(L["%s's overkill"], label)
	end

	function playermod:Update(win, set)
		local player = Skada:find_player(set, win.playerid, win.playername)

		if player then
			win.title = _format(L["%s's overkill"], player.name)
			local total = player.damagedone and player.damagedone.overkill or 0

			if total > 0 and player.damagedone.spells then
				local maxvalue, nr = 0, 1

				for spellname, spell in _pairs(player.damagedone.spells) do
					if (spell.overkill or 0) > 0 then
						local d = win.dataset[nr] or {}
						win.dataset[nr] = d

						d.id = spell.id
						d.spellid = spell.id
						d.label = spellname
						d.text = spellname .. (spell.isdot and L["DoT"] or "")
						d.icon = _select(3, _GetSpellInfo(spell.id))
						d.spellschool = spell.school

						d.value = spell.overkill
						d.valuetext = Skada:FormatValueText(
							Skada:FormatNumber(spell.overkill),
							mod.metadata.columns.Damage,
							_format("%02.1f%%", 100 * spell.overkill / total),
							mod.metadata.columns.Percent
						)

						if spell.overkill > maxvalue then
							maxvalue = spell.overkill
						end
						nr = nr + 1
					end
				end

				win.metadata.maxvalue = maxvalue
			end
		end
	end

	function mod:Update(win, set)
		win.title = L["Overkill"]
		local total = set.damagedone and set.damagedone.overkill or 0

		if total > 0 then
			local maxvalue, nr = 0, 1

			for _, player in _ipairs(set.players) do
				if player.damagedone and (player.damagedone.overkill or 0) > 0 then
					local d = win.dataset[nr] or {}
					win.dataset[nr] = d

					d.id = player.id
					d.label = player.name
					d.class = player.class or "PET"
					d.role = player.role or "DAMAGER"
					d.spec = player.spec or 1

					d.value = player.damagedone.overkill
					d.valuetext = Skada:FormatValueText(
						Skada:FormatNumber(player.damagedone.overkill),
						self.metadata.columns.Damage,
						_format("%02.1f%%", 100 * player.damagedone.overkill / total),
						self.metadata.columns.Percent
					)

					if player.damagedone.overkill > maxvalue then
						maxvalue = player.damagedone.overkill
					end

					nr = nr + 1
				end
			end

			win.metadata.maxvalue = maxvalue
		end
	end

	function mod:OnEnable()
		self.metadata = {
			showspots = true,
			click1 = playermod,
			columns = {Damage = true, Percent = true}
		}
		Skada:AddMode(self, L["Damage done"])
	end

	function mod:OnDisable()
		Skada:RemoveMode(self, L["Damage done"])
	end
end)