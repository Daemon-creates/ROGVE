/datum/advclass/drifter/charlatan
	name = "Charlatan"
	tutorial = "You sell hope by the bottle, miracles by the fistful, and relics by the lie. The road is kinder to a silver tongue than it is to an honest soul."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/drifter/charlatan
	category_tags = list(CTAG_ADVENTURER)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_LCK = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/drifter/charlatan/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/bucklehat
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/purple
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/rogueweapon/scabbard/sheath
	r_hand = /obj/item/rogueweapon/huntingknife/idagger
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/water/drifter_giants_strength = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/water/drifter_heroic_vigor = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/water/drifter_mindfire = 1,
		/obj/item/roguegem/drifter_fake = 5,
		/obj/item/clothing/ring/gold/drifter_fake_relic = 1,
		/obj/item/clothing/ring/silver/drifter_fake_relic = 1,
	)

