/datum/advclass/drifter/ancestry/kuldjargh
	name = "Kuldjargh"
	// "Hammerfell" is flavor text only here; the closest verified gates are mountain dwarf and humen.
	tutorial = "A hard-weathered wanderer from cold hills and harsher kin, you cling to old raider glories, fur on your shoulders and iron in your fists."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/dwarf/mountain, /datum/species/human/northern)
	outfit = /datum/outfit/job/roguetown/drifter/kuldjargh
	category_tags = list(CTAG_ADVENTURER)
	gate_ancestries = list(/datum/species/dwarf, /datum/species/human/northern)
	gate_races = list(SKIN_COLOR_HAMMERHOLD)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/drifter/kuldjargh/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/horned
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
	belt = /obj/item/storage/belt/rogue/leather
	r_hand = /obj/item/rogueweapon/stoneaxe/handaxe
	backr = /obj/item/rogueweapon/shield/wood
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/storage/belt/rogue/pouch/coins/poor = 1)

