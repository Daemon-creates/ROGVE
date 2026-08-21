/datum/advclass/drifter/ancestry/steppeman
	name = "Steppeman"
	// The Gronn foreigner subclass is mechanically all-races, so this keeps the gate to the explicit half-orc route.
	tutorial = "You are a road-thin rider from the eastern grasslands, carrying the habits of the steppe long after its companies and clans ceased to claim you."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/halforc)
	outfit = /datum/outfit/job/roguetown/drifter/steppeman
	category_tags = list(CTAG_ADVENTURER)
	subclass_languages = list(/datum/language/aavnic)
	gate_races = list(SKIN_COLOR_GRONN, SKIN_COLOR_AVAR)
	gate_ancestries = list(/datum/species/halforc)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/drifter/steppeman/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/papakha
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/quiver/javelin/iron
	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/sabre/steppesman
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/steppesman
	backpack_contents = list(/obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/rogueweapon/whip/nagaika = 1)

