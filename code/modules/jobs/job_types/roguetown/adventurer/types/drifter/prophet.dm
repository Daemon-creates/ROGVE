/datum/advclass/drifter/prophet
	name = "Prophet"
	tutorial = "Visions drove you from every roof that might have claimed you. Now you drift from shrine to shrine with relics, riddles, and a certainty that somebody, somewhere, must listen."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	allowed_patrons = ALL_PATRONS
	outfit = /datum/outfit/job/roguetown/drifter/prophet
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_RITUALIST, TRAIT_LITERACY)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
	)

/datum/advclass/drifter/prophet/post_equip(mob/living/carbon/human/H)
	..()
	drifter_grant_random_spell(H)
	drifter_grant_random_miracle(H)

/datum/outfit/job/roguetown/drifter/prophet/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	neck = drifter_patron_symbol(H)
	belt = /obj/item/storage/belt/rogue/leather/rope
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/clothing/ring/gold/drifter_fake_relic = 1,
		/obj/item/clothing/ring/silver/drifter_fake_relic = 1,
		/obj/item/chalk = 1,
	)

