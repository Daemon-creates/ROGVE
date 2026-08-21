/datum/advclass/drifter/ancestry/shaman
	name = "Shaman"
	// Naledi's foreigner subclass is mechanically all-races, so this keeps the gate to verified goblins for safety.
	tutorial = "Trance, ash, and little idols are the last pieces of home you still trust. The spirits answer you in scraps, but scraps are enough for a wanderer."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/goblinp)
	allowed_patrons = ALL_PATRONS
	outfit = /datum/outfit/job/roguetown/drifter/shaman
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_RITUALIST, TRAIT_LITERACY)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/drifter/shaman/pre_equip(mob/living/carbon/human/H)
	..()
	neck = drifter_patron_symbol(H)
	cloak = /obj/item/clothing/cloak/tribal
	shirt = /obj/item/clothing/suit/roguetown/shirt/tribalrag
	pants = /obj/item/clothing/under/roguetown/loincloth/brown
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	r_hand = /obj/item/rogueweapon/woodstaff
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/chalk = 1)
	if(H.patron)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
