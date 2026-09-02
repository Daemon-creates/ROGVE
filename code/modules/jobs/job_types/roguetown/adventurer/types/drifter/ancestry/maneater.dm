/datum/advclass/drifter/ancestry/maneater
	name = "Man-eater"
	// Drakian is not a verified species here; dracon is used as the closest existing draconic stand-in alongside kobold, lamia, and lizardfolk.
	tutorial = "Desert roads know your appetite and the dunes keep your old sins buried shallow. Steel, fang, or both, you are a hunger in traveler-shape."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/kobold, /datum/species/lamia, /datum/species/lizardfolk, /datum/species/dracon)
	outfit = /datum/outfit/job/roguetown/drifter/maneater
	category_tags = list(CTAG_ADVENTURER)
	gate_ancestries = list(
		/datum/species/dracon,
		/datum/species/kobold,
		/datum/species/lamia,
		/datum/species/lizardfolk
	)
	gate_religions = list(/datum/patron/inhumen/graggar)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/drifter/maneater/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/nomad
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/nomad
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/nomad
	pants = /obj/item/clothing/under/roguetown/loincloth/brown
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	r_hand = /obj/item/rogueweapon/greataxe/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/storage/belt/rogue/pouch/coins/poor = 1)

