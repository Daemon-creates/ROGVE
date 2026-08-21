/datum/advclass/drifter/ancestry/miner_knight
	name = "Miner Knight"
	// No bespoke "malumite" ancestry gate exists; this uses the closest verified dwarf-or-humen restriction.
	tutorial = "You descend into stone in maille and plate, half prospector and half sworn breaker of the deep. Whatever kingdom once employed you is far behind."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/dwarf/mountain, /datum/species/human/northern)
	outfit = /datum/outfit/job/roguetown/drifter/miner_knight
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/drifter/miner_knight/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	belt = /obj/item/storage/belt/rogue/leather/steel
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/pick
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/storage/belt/rogue/pouch/coins/poor = 1)

