/datum/advclass/drifter/wasteoflife
	name = "Waste of Life"
	tutorial = "Home never kept you, purpose never found you, and even the crows look at you with pity. All that remains is hunger, rot, and the knife in your hand."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/drifter/wasteoflife
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_LEPROSY, TRAIT_ROTMAN, TRAIT_NASTY_EATER, TRAIT_CURSE_RESIST, TRAIT_UNSEEMLY)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
	)

/datum/advclass/drifter/wasteoflife/post_equip(mob/living/carbon/human/H)
	..()
	drifter_add_flat_bounty(H, rand(600, 900), "being a waste of lyfe", "The whole realm")

/datum/outfit/job/roguetown/drifter/wasteoflife/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/rogueweapon/huntingknife

