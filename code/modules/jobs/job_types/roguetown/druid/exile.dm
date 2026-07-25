//A criminal who was taken in by the druids.
/datum/job/roguetown/groveexile
	title = "Exile"
	flag = GROVEEXILE
	department_flag = DRUID
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS
	outfit = /datum/outfit/job/roguetown/groveexile
	social_rank = SOCIAL_RANK_PEASANT
	tutorial = "Whatever you did, wherever you fled from, the grove took you in when no one else would. You owe the archdruid your life, and you're not about to squander that debt-- \
	but the grove is watching you all the same, and old habits die hard."

	display_order = JDO_GROVEEXILE
	give_bank_account = TRUE
	min_pq = -20
	max_pq = null
	round_contrib_points = 1
	cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'

	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_GROVEEXILE = 2)
	job_subclasses = list(
		/datum/advclass/groveexile
	)

/datum/advclass/groveexile
	name = "Exile"
	tutorial = "Whatever you did, wherever you fled from, the grove took you in when no one else would. You owe the archdruid your life, and you're not about to squander that debt-- \
	but the grove is watching you all the same, and old habits die hard."
	outfit = /datum/outfit/job/roguetown/groveexile/basic
	category_tags = list(CTAG_GROVEEXILE)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_WIL = -1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/groveexile
	name = "Exile"
	jobtype = /datum/job/roguetown/groveexile
	has_loadout = TRUE

/datum/outfit/job/roguetown/groveexile/basic

/datum/outfit/job/roguetown/groveexile/basic/pre_equip(mob/living/carbon/human/H)
	..()
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/psicross/dendor
	armor = /obj/item/clothing/suit/roguetown/shirt/tribalrag
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/rogueweapon/huntingknife
	pants = /obj/item/clothing/under/roguetown/tights/vagrant
	backpack_contents = list(/obj/item/flint = 1)
	H.ambushable = FALSE

/datum/job/roguetown/groveexile/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")
