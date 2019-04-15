-- Here we need to add the tiers
DCM = {}

----------------------------
-- copy from original mod, change:

-- size of machine icons and crate background
DCM.ITEM_ICON_SIZE = 32

-- how many crates to use up a whole vanilla stack
DCM.STACK_DIVIDER = 5

-- how many tiers of tech?
DCM.TIERS = 5
-- there are kind-of 4 tiers - all imported mod items go in tier 4 - only affects crafting tab
DCM.TAB_TIERS = DCM.TIERS + 1

-- which items can be crated, in which tier
DCM.ITEM_TIER = {
	[4] = { "wood", "iron-ore", "copper-ore", "stone", "coal", "iron-plate", "copper-plate", "steel-plate", "stone-brick" },
	[5] = { "copper-cable", "iron-gear-wheel", "iron-stick", "sulfur", "plastic-bar", "solid-fuel", "electronic-circuit", "advanced-circuit" },
}

DCM.TIER_COLOURS = {
	[1] = {r=210, g=180, b=80},
	[2] = {r=210, g=60, b=60},
    [3] = {r=80, g=180, b=210},
    [4] =  {r=165,g=10,b=225},
    [5] =  {r=10,g=225,b=25},
}


DCM.TECH_PREFIX = "deadlock-crating-"



-- for calculating scales of energy, health etc.
function DCM.get_scale(this_tier, tiers, lowest, highest)
	return lowest + ((highest - lowest) * ((this_tier - 1) / (tiers - 1)))
end

-- Energy and pollution. They just couldn't make it easy, could they
function DCM.get_energy_table(this_tier, tiers, lowest, highest, passive_multiplier, pollution)
	local total = DCM.get_scale(this_tier, tiers, lowest, highest)
	local passive_energy_usage = total * passive_multiplier
	local active_energy_usage = total * (1 - passive_multiplier)
	return {
		passive = passive_energy_usage .. "KW", -- passive energy drain as a string
		active = active_energy_usage .. "KW", -- active energy usage as a string
		emissions = pollution / active_energy_usage / 1000, -- pollution/s/W
	}
end

-- brighter version of tier colour for working vis glow & lights
function DCM.brighter_colour(c)
	local w = 240
	return { r = math.floor((c.r + w)/2), g = math.floor((c.g + w)/2), b = math.floor((c.b + w)/2) }
end
