require('prototypes.shared')

-- here we adjust the previous tiers

if data.raw.recipe["deadlock-machine-packer-recipe-1"] then
	local t1_crater_ingredients  = {
		{"transport-belt-beltbox",8},
		{"steel-plate",10}
	}
	data.raw.recipe["deadlock-machine-packer-recipe-1"].ingredients = t1_crater_ingredients
end
if data.raw.recipe["deadlock-machine-packer-recipe-2"] then
	local t2_crater_ingredients  = {
		{"deadlock-machine-packer-item-1",1},
		{"fast-transport-belt-beltbox",4},
		{"steel-plate",10}
	}
	data.raw.recipe["deadlock-machine-packer-recipe-2"].ingredients = t2_crater_ingredients
end
if data.raw.recipe["deadlock-machine-packer-recipe-3"] then
	local t3_crater_ingredients  = {
		{"deadlock-machine-packer-item-2",1},
		{"express-transport-belt-beltbox",4},
		{"steel-plate",10}
	}
	data.raw.recipe["deadlock-machine-packer-recipe-3"].ingredients = t3_crater_ingredients
end

function getCraftingSpeed(level)
	return level * settings.startup["bobmods-logistics-beltspeedperlevel"].value / 15
end

if settings.startup["bobmods-logistics-beltoverhaulspeed"].value then
    -- yellow
    if data.raw["assembling-machine"]["deadlock-machine-packer-entity-1"] then
        data.raw["assembling-machine"]["deadlock-machine-packer-entity-1"].crafting_speed = getCraftingSpeed(2)
    end
    -- red
    if data.raw["assembling-machine"]["deadlock-machine-packer-entity-2"] then
        data.raw["assembling-machine"]["deadlock-machine-packer-entity-2"].crafting_speed =  getCraftingSpeed(3)
    end
    -- blue
    if data.raw["assembling-machine"]["deadlock-machine-packer-entity-3"] then
        data.raw["assembling-machine"]["deadlock-machine-packer-entity-3"].crafting_speed =  getCraftingSpeed(4)
	end
	-- purple
	if data.raw["assembling-machine"]["deadlock-machine-packer-entity-4"] then
        data.raw["assembling-machine"]["deadlock-machine-packer-entity-4"].crafting_speed =  getCraftingSpeed(5)
	end
	-- green
	if data.raw["assembling-machine"]["deadlock-machine-packer-entity-5"] then
        data.raw["assembling-machine"]["deadlock-machine-packer-entity-5"].crafting_speed =  getCraftingSpeed(6)
	end
	
end
data:extend({{
type = "item-subgroup", name = "production-machine-packing", 	group = "production", order = "a-1"}})


for i = 1, DCM.TIERS do 
	if data.raw["assembling-machine"]["deadlock-machine-packer-entity-"..i] then
		data.raw["assembling-machine"]["deadlock-machine-packer-entity-"..i].fast_replaceable_group = "crating-machine"
		if(i < 5) then
			data.raw["assembling-machine"]["deadlock-machine-packer-entity-"..i].next_upgrade ="deadlock-machine-packer-entity-"..i+1
		else
			data.raw["assembling-machine"]["deadlock-machine-packer-entity-"..i].next_upgrade = ""
		end
		data.raw.item["deadlock-machine-packer-item-"..i].subgroup = "production-machine-packing"
	end
end


 -- research prerequisites per tier
 local prereqs = {
	[1] = {"automation", "electric-engine", "stack-inserter"},
	[2] = {"automation-2", "deadlock-crating-1"},
	[3] = {"automation-3", "deadlock-crating-2"},
}

 -- research
 for i=4,5 do
	local recipeeffects = {
		[1] = {type = "unlock-recipe",
			recipe = "deadlock-machine-packer-recipe-"..i
		},
	}
	local research = table.deepcopy(data.raw.technology[DCM.TECH_PREFIX .. 3])
	research.effects = recipeeffects
	research.icons = {
		{ icon = "__DeadlockCrating__/graphics/icons/crating-icon-base-128.png" },
		{ icon = "__DeadlockCrating__/graphics/icons/crating-icon-mask-128.png", tint = DCM.TIER_COLOURS[i] },
	}
	research.name = DCM.TECH_PREFIX..i
	research.unit.count = research.unit.count * 2
	research.prerequisites ={DCM.TECH_PREFIX .. i-1}
	research.upgrade = false
	data:extend({research})
end



