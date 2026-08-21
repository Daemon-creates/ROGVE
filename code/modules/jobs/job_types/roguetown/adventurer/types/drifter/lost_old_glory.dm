/datum/advclass/drifter/lost_old_glory
	name = "Lost Old Glory"
	tutorial = "You still dress the part of a knight, even if the years have hollowed your renown and left your thoughts circling darker roads. All that's left is habit, memory, and steel on failing straps."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	outfit = /datum/outfit/job/roguetown/drifter/lost_old_glory
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_MANIAC_AWOKEN, TRAIT_PSYCHOSIS, TRAIT_HEAVYARMOR)
	cmode_music = 'sound/music/combat_knight.ogg'
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/advclass/drifter/lost_old_glory/post_equip(mob/living/carbon/human/H)
	..()
	drifter_ruin_worn_armor(H)

/datum/outfit/job/roguetown/drifter/lost_old_glory/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	gloves = /obj/item/clothing/gloves/roguetown/chain
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	cloak = /obj/item/clothing/cloak/stabard
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	beltr = /obj/item/rogueweapon/sword/long
	backr = /obj/item/rogueweapon/shield/tower/metal
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/storage/belt/rogue/pouch/coins/poor = 1)

