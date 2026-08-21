/datum/advclass/drifter/ancestry/amazon
	name = "Amazon"
	// No giant-player trait exists in the trait definitions, so this keeps to the other requested themes.
	tutorial = "The road has only sharpened your ferocity. You travel light, strike hard, and carry enough iron to skewer prey before it ever reaches your spear-hand."
	allowed_sexes = list(FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/drifter/amazon
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_CIVILIZEDBARBARIAN, TRAIT_DEATHBYSNUSNU)
	gate_genders = list(FEMALE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/drifter/amazon/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/bikini
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	gloves = /obj/item/clothing/gloves/roguetown/bandages
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/quiver/javelin/iron
	r_hand = /obj/item/ammo_casing/caseless/rogue/javelin/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/ammo_casing/caseless/rogue/javelin/steel = 2, /obj/item/storage/belt/rogue/pouch/coins/poor = 1)

