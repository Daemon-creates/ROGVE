/datum/advclass/drifter/trader
	name = "Trader"
	tutorial = "You are no guild merchant, merely a wanderer with enough coin to keep moving. Roads, ferries, and camp markets are your true home."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/drifter/trader
	category_tags = list(CTAG_ADVENTURER)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/drifter/trader/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich = 2,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
	)

