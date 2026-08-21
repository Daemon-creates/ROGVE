/datum/advclass/drifter/disgracedknight
	name = "Disgraced Knight"
	tutorial = "You were caught in your liege's bedchamber with their spouse, and the flight from that crime only piled blood upon scandal. Now you wander in borrowed rags, waiting for the gallows to remember your name."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/drifter/disgracedknight
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_NOBLE)
	cmode_music = 'sound/music/combat_knight.ogg'
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/advclass/drifter/disgracedknight/post_equip(mob/living/carbon/human/H)
	..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(drifter_add_delayed_bounty), WEAKREF(H), rand(250, 450), "murder", "An outraged liege"), game_minutes2deciseconds(48 * 60))

/datum/outfit/job/roguetown/drifter/disgracedknight/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
	pants = /obj/item/clothing/under/roguetown/tights/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/half
