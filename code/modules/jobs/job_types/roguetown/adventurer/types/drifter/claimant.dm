/datum/advclass/drifter/claimant
	name = "Claimant"
	tutorial = "Whether prince or princess, pretender or trueborn scion, you keep your pedigree hidden beneath road dust and a circlet wrapped in cloth. One day the realm will hear your name again."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/drifter/claimant
	category_tags = list(CTAG_ADVENTURER)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/drifter/claimant/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/paper/scroll/drifter_succession_claim = 1,
		/obj/item/flashlight/flare/torch = 1,
	)

