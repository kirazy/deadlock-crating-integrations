require("prototypes.shared")

-- Add new tiers based on crating mod

-- iterate through tiers to add entities
for i = 4, DCM.TIERS do
	local machine = table.deepcopy(data.raw["assembling-machine"]["deadlock-machine-packer-entity-1"])
	machine.name = "deadlock-machine-packer-entity-" .. i
	machine.icons[2].tint = DCM.TIER_COLOURS[i]
	machine.minable.result = "deadlock-machine-packer-item-" .. i
	machine.crafting_speed = i
	--machine.module_specification = {
	--	module_info_icon_shift = {0, 0.8},
	--	module_slots = 1
	--	}
	--machine.allowed_effects = {"consumption"}
	--machine.crafting_categories = {"packing"}
	machine.max_health = DCM.get_scale(i, DCM.TIERS, 300, 400)
	local energy_table = DCM.get_energy_table(i, DCM.TIERS, 500, 1000, 0.1, 5 - i)
	machine.energy_usage = energy_table.active
	machine.energy_source = {
		type = "electric",
		usage_priority = "secondary-input",
		drain = energy_table.passive,
		emissions_per_second_per_watt = energy_table.emissions -- replaces old emissions parameter
	}
	--machine.working_sound = {filename = "__DeadlockCrating__/sounds/deadlock-crate-machine.ogg", volume = 0.7}
	machine.animation.layers[3].hr_version.tint = DCM.TIER_COLOURS[i]
	machine.animation.layers[3].tint = DCM.TIER_COLOURS[i]

	machine.working_visualisations[1].animation.hr_version.tint = DCM.brighter_colour(DCM.TIER_COLOURS[i])
	machine.working_visualisations[1].animation.tint = DCM.brighter_colour(DCM.TIER_COLOURS[i])
	machine.working_visualisations[1].light.color = DCM.brighter_colour(DCM.TIER_COLOURS[i])
	--[[ 	machine.animation = {
		layers = {
			{
				hr_version = {
					draw_as_shadow = true,
					filename = "__DeadlockCrating__/graphics/entities/high/crating-shadow.png",
					animation_speed = 1 / i,
					repeat_count = 60,
					height = 192,
					scale = 0.5,
					shift = {1.5, 0},
					width = 384
				},
				draw_as_shadow = true,
				filename = "__DeadlockCrating__/graphics/entities/low/crating-shadow.png",
				animation_speed = 1 / i,
				repeat_count = 60,
				height = 96,
				scale = 1,
				shift = {1.5, 0},
				width = 192
			},
			{
				hr_version = {
					filename = "__DeadlockCrating__/graphics/entities/high/crating-base.png",
					animation_speed = 1 / i,
					priority = "high",
					frame_count = 60,
					line_length = 10,
					height = 192,
					scale = 0.5,
					shift = {0, 0},
					width = 192
				},
				filename = "__DeadlockCrating__/graphics/entities/low/crating-base.png",
				animation_speed = 1 / i,
				priority = "high",
				frame_count = 60,
				line_length = 10,
				height = 96,
				scale = 1,
				shift = {0, 0},
				width = 96
			},
			{
				hr_version = {
					filename = "__DeadlockCrating__/graphics/entities/high/crating-mask.png",
					animation_speed = 1 / i,
					priority = "high",
					repeat_count = 60,
					height = 192,
					scale = 0.5,
					shift = {0, 0},
					width = 192,
					tint = DCM.TIER_COLOURS[i]
				},
				filename = "__DeadlockCrating__/graphics/entities/low/crating-mask.png",
				animation_speed = 1 / i,
				priority = "high",
				repeat_count = 60,
				height = 96,
				scale = 1,
				shift = {0, 0},
				width = 96,
				tint = DCM.TIER_COLOURS[i]
			}
		}
	} ]]
	--[[
	machine.working_visualisations = {
		{
			animation = {
				hr_version = {
					animation_speed = 1 / i,
					blend_mode = "additive",
					filename = "__DeadlockCrating__/graphics/entities/high/crating-working.png",
					frame_count = 30,
					line_length = 10,
					height = 192,
					priority = "high",
					scale = 0.5,
					tint = DCM.brighter_colour(DCM.TIER_COLOURS[i]),
					width = 192
				},
				animation_speed = 1 / i,
				blend_mode = "additive",
				filename = "__DeadlockCrating__/graphics/entities/low/crating-working.png",
				frame_count = 30,
				line_length = 10,
				height = 96,
				priority = "high",
				tint = DCM.brighter_colour(DCM.TIER_COLOURS[i]),
				width = 96
			},
			light = {
				color = DCM.brighter_colour(DCM.TIER_COLOURS[i]),
				intensity = 0.4,
				size = 9,
				shift = {0, 0}
			}
		}
	} ]]
	data:extend {machine}
end

-- crating machine items
for i = 4, DCM.TIERS do
	data:extend {
		{
			type = "item",
			name = "deadlock-machine-packer-item-" .. i,
			subgroup = "production-machine",
			stack_size = 50,
			icons = {
				{icon = "__DeadlockCrating__/graphics/icons/crating-icon-base-" .. DCM.ITEM_ICON_SIZE .. ".png"},
				{icon = "__DeadlockCrating__/graphics/icons/crating-icon-mask-" .. DCM.ITEM_ICON_SIZE .. ".png", tint = DCM.TIER_COLOURS[i]}
			},
			icon_size = DCM.ITEM_ICON_SIZE,
			order = "z" .. i,
			place_result = "deadlock-machine-packer-entity-" .. i,
			flags = {}
		}
	}
end

if data.raw.item["ultimate-transport-belt-beltbox"] then
	-- RECIPES for the machines
	data:extend {
		{
			type = "recipe",
			name = "deadlock-machine-packer-recipe-4",
			enabled = false,
			ingredients = {
				{"deadlock-machine-packer-item-3", 1},
				{"turbo-transport-belt-beltbox", 4},
				{"steel-plate", 10}
			},
			result = "deadlock-machine-packer-item-4",
			energy_required = 9.0
		},
		{
			type = "recipe",
			name = "deadlock-machine-packer-recipe-5",
			enabled = false,
			ingredients = {
				{"deadlock-machine-packer-item-4", 1},
				{"ultimate-transport-belt-beltbox", 4},
				{"steel-plate", 10}
			},
			result = "deadlock-machine-packer-item-5",
			energy_required = 10.0
		}
	}
else
	data:extend {
		{
			type = "recipe",
			name = "deadlock-machine-packer-recipe-4",
			enabled = false,
			ingredients = {
				{"deadlock-machine-packer-item-3", 2},
				{"express-transport-belt-beltbox", 4},
				{"steel-plate", 10}
			},
			result = "deadlock-machine-packer-item-4",
			energy_required = 9.0
		},
		{
			type = "recipe",
			name = "deadlock-machine-packer-recipe-5",
			enabled = false,
			ingredients = {
				{"deadlock-machine-packer-item-4", 2},
				{"express-transport-belt-beltbox", 4},
				{"steel-plate", 20}
			},
			result = "deadlock-machine-packer-item-5",
			energy_required = 10.0
		}
	}
end

-- here we adjust the previous tiers

if data.raw.recipe["deadlock-machine-packer-recipe-1"] then
	local t1_crater_ingredients = {
		{"transport-belt-beltbox", 8},
		{"steel-plate", 10}
	}
	data.raw.recipe["deadlock-machine-packer-recipe-1"].ingredients = t1_crater_ingredients
end
if data.raw.recipe["deadlock-machine-packer-recipe-2"] then
	local t2_crater_ingredients = {
		{"deadlock-machine-packer-item-1", 1},
		{"fast-transport-belt-beltbox", 4},
		{"steel-plate", 10}
	}
	data.raw.recipe["deadlock-machine-packer-recipe-2"].ingredients = t2_crater_ingredients
end
if data.raw.recipe["deadlock-machine-packer-recipe-3"] then
	local t3_crater_ingredients = {
		{"deadlock-machine-packer-item-2", 1},
		{"express-transport-belt-beltbox", 4},
		{"steel-plate", 10}
	}
	data.raw.recipe["deadlock-machine-packer-recipe-3"].ingredients = t3_crater_ingredients
end

function getCraftingSpeed(level)
	return level * settings.startup["bobmods-logistics-beltspeedperlevel"].value / 15
end

if settings.startup["bobmods-logistics-beltoverhaulspeed"] and settings.startup["bobmods-logistics-beltoverhaulspeed"].value then
	-- yellow
	if data.raw["assembling-machine"]["deadlock-machine-packer-entity-1"] then
		data.raw["assembling-machine"]["deadlock-machine-packer-entity-1"].crafting_speed = getCraftingSpeed(2)
	end
	-- red
	if data.raw["assembling-machine"]["deadlock-machine-packer-entity-2"] then
		data.raw["assembling-machine"]["deadlock-machine-packer-entity-2"].crafting_speed = getCraftingSpeed(3)
	end
	-- blue
	if data.raw["assembling-machine"]["deadlock-machine-packer-entity-3"] then
		data.raw["assembling-machine"]["deadlock-machine-packer-entity-3"].crafting_speed = getCraftingSpeed(4)
	end
	-- purple
	if data.raw["assembling-machine"]["deadlock-machine-packer-entity-4"] then
		data.raw["assembling-machine"]["deadlock-machine-packer-entity-4"].crafting_speed = getCraftingSpeed(5)
	end
	-- green
	if data.raw["assembling-machine"]["deadlock-machine-packer-entity-5"] then
		data.raw["assembling-machine"]["deadlock-machine-packer-entity-5"].crafting_speed = getCraftingSpeed(6)
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

for i = 1, DCM.TIERS do
	if data.raw["assembling-machine"]["deadlock-machine-packer-entity-" .. i] then
		data.raw["assembling-machine"]["deadlock-machine-packer-entity-" .. i].fast_replaceable_group = "crating-machine"
		if (i < 5) then
			data.raw["assembling-machine"]["deadlock-machine-packer-entity-" .. i].next_upgrade = "deadlock-machine-packer-entity-" .. i + 1
		else
			data.raw["assembling-machine"]["deadlock-machine-packer-entity-" .. i].next_upgrade = ""
		end
		data.raw.item["deadlock-machine-packer-item-" .. i].subgroup = "production-machine-packing"
	end
end

-- research
for i = 4, 5 do
	local recipeeffects = {
		[1] = {
			type = "unlock-recipe",
			recipe = "deadlock-machine-packer-recipe-" .. i
		}
	}
	local research = table.deepcopy(data.raw.technology[DCM.TECH_PREFIX .. 3])
	research.effects = recipeeffects
	research.icons = {
		{icon = "__DeadlockCrating__/graphics/icons/crating-icon-base-128.png"},
		{icon = "__DeadlockCrating__/graphics/icons/crating-icon-mask-128.png", tint = DCM.TIER_COLOURS[i]}
	}
	research.name = DCM.TECH_PREFIX .. i
	research.unit.count = research.unit.count * 2
	research.prerequisites = {DCM.TECH_PREFIX .. i - 1}
	research.upgrade = false
	data:extend({research})
end
