require("prototypes.shared")

-- Add new tiers based on crating mod

-- iterate through tiers to add entities
for tier = 4, DCM.TIERS do
	local machine = table.deepcopy(data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "1"])
	machine.name = DCM.MACHINE_PREFIX .. tier
	machine.icons[2].tint = DCM.TIER_COLOURS[tier]

	machine.minable.result = DCM.MACHINE_PREFIX .. tier
	machine.crafting_speed = tier
	machine.module_specification.module_slots = tier - 2
	machine.max_health = DCM.get_scale(tier, DCM.TIERS, 300, 400)
	local energy_table = DCM.get_energy_table(tier, DCM.TIERS, 500, 1000, 0.1, 5 - tier)
	machine.energy_usage = energy_table.active
	machine.energy_source = {
		type = "electric",
		usage_priority = "secondary-input",
		drain = energy_table.passive,
		emissions_per_second_per_watt = energy_table.emissions -- replaces old emissions parameter
	}
	machine.animation.layers[3].hr_version.tint = DCM.TIER_COLOURS[tier]
	machine.animation.layers[3].tint = DCM.TIER_COLOURS[tier]
	machine.animation.layers[2].hr_version.tint = DCM.TIER_COLOURS[tier]
	machine.animation.layers[2].tint = DCM.TIER_COLOURS[tier]

	machine.working_visualisations[1].animation.hr_version.tint = DCM.brighter_colour(DCM.TIER_COLOURS[tier])
	machine.working_visualisations[1].animation.tint = DCM.brighter_colour(DCM.TIER_COLOURS[tier])
	machine.working_visualisations[1].light.color = DCM.brighter_colour(DCM.TIER_COLOURS[tier])
	data:extend {machine}
end

-- crating machine items
for tier = 4, DCM.TIERS do
	data:extend {
		{
			type = "item",
			name = DCM.MACHINE_PREFIX .. tier,
			subgroup = "production-machine",
			stack_size = 50,
			icons = {
				{
					icon = "__DeadlockCrating__/graphics/icons/mipmaps/crating-icon-base.png",
					icon_size = DCM.ITEM_ICON_SIZE,
					icon_mipmaps = 4
				},
				{
					icon = "__DeadlockCrating__/graphics/icons/mipmaps/crating-icon-mask.png",
					icon_size = DCM.ITEM_ICON_SIZE,
					tint = DCM.TIER_COLOURS[tier],
					icon_mipmaps = 4
				}
			},
			icon_size = DCM.ITEM_ICON_SIZE,
			order = "z" .. tier,
			place_result = DCM.MACHINE_PREFIX .. tier,
			flags = {}
		}
	}
end

-- RECIPES for the machines
data:extend {
	{
		type = "recipe",
		name = DCM.MACHINE_PREFIX .. "4",
		enabled = false,
		ingredients = {
			{DCM.MACHINE_PREFIX .. "3", 1},
			{DCM.LOADER_FOUR, 4},
			{"steel-plate", 10}
		},
		result = DCM.MACHINE_PREFIX .. "4",
		energy_required = 9.0
	},
	{
		type = "recipe",
		name = DCM.MACHINE_PREFIX .. "5",
		enabled = false,
		ingredients = {
			{DCM.MACHINE_PREFIX .. "4", 1},
			{DCM.LOADER_FIVE, 4},
			{"steel-plate", 10}
		},
		result = DCM.MACHINE_PREFIX .. "5",
		energy_required = 10.0
	}
}

-- here we adjust the previous tiers

if data.raw.recipe[DCM.MACHINE_PREFIX .. "1"] then
	local t1_crater_ingredients = {
		{DCM.LOADER_ONE, 8},
		{"steel-plate", 10}
	}
	data.raw.recipe[DCM.MACHINE_PREFIX .. "1"].ingredients = t1_crater_ingredients
end
if data.raw.recipe[DCM.MACHINE_PREFIX .. "2"] then
	local t2_crater_ingredients = {
		{DCM.MACHINE_PREFIX .. "1", 1},
		{DCM.LOADER_TWO, 4},
		{"steel-plate", 10}
	}
	data.raw.recipe[DCM.MACHINE_PREFIX .. "2"].ingredients = t2_crater_ingredients
end
if data.raw.recipe[DCM.MACHINE_PREFIX .. "3"] then
	local t3_crater_ingredients = {
		{DCM.MACHINE_PREFIX .. "2", 1},
		{DCM.LOADER_THREE, 4},
		{"steel-plate", 10}
	}
	data.raw.recipe[DCM.MACHINE_PREFIX .. "3"].ingredients = t3_crater_ingredients
end

function getCraftingSpeed(level)
	return level * settings.startup["bobmods-logistics-beltspeedperlevel"].value / 15
end

if
	settings.startup["bobmods-logistics-beltoverhaulspeed"] and
		settings.startup["bobmods-logistics-beltoverhaulspeed"].value
 then
	-- yellow
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "1"] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "1"].crafting_speed = getCraftingSpeed(2)
	end
	-- red
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "2"] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "2"].crafting_speed = getCraftingSpeed(3)
	end
	-- blue
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "3"] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "3"].crafting_speed = getCraftingSpeed(4)
	end
	-- purple
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "4"] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "4"].crafting_speed = getCraftingSpeed(5)
	end
	-- green
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "5"] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. "5"].crafting_speed = getCraftingSpeed(6)
	end
end
data:extend(
	{
		{
			type = "item-subgroup",
			name = "production-machine-packing",
			group = "production",
			order = "a-1"
		}
	}
)

for tier = 1, DCM.TIERS do
	if data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. tier] then
		data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. tier].fast_replaceable_group = "crating-machine"
		if (tier < 5) then
			data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. tier].next_upgrade = DCM.MACHINE_PREFIX .. tier + 1
		else
			data.raw["assembling-machine"][DCM.MACHINE_PREFIX .. tier].next_upgrade = ""
		end
		data.raw.item[DCM.MACHINE_PREFIX .. tier].subgroup = "production-machine-packing"
	end
end

-- research
for tier = 4, 5 do
	local recipeeffects = {
		[1] = {
			type = "unlock-recipe",
			recipe = DCM.MACHINE_PREFIX .. tier
		}
	}
	local research = table.deepcopy(data.raw.technology[DCM.TECH_PREFIX .. 3])
	research.effects = recipeeffects
	research.icons = {
		{icon = "__DeadlockCrating__/graphics/icons/square/crating-icon-base-128.png"},
		{icon = "__DeadlockCrating__/graphics/icons/square/crating-icon-mask-128.png", tint = DCM.TIER_COLOURS[tier]}
	}
	research.name = DCM.TECH_PREFIX .. tier
	research.unit.count = research.unit.count * 2
	research.prerequisites = {DCM.TECH_PREFIX .. tier - 1}
	research.upgrade = false
	data:extend({research})
end
