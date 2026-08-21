//Sheltered at the grove and paid in room and board for menial labor tasks.
/datum/job/roguetown/grover
	title = "Grover"
	flag = GROVER
	department_flag = DRUID
	faction = "Station"
	total_positions = 5
	spawn_positions = 5

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS
	outfit = /datum/outfit/job/roguetown/grover
	social_rank = SOCIAL_RANK_PEASANT
	tutorial = "A humble townsman or perhaps a hermit, you chose to make the grove your home. It gave to you, so now you much give back. Keep the grove running as there is always labor to be done-- may the Wyldsman Prince rejoice in your efforts."

	display_order = JDO_GROVER
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 1
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'

	job_traits = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_NOSTINK)

	advclass_cat_rolls = list(CTAG_GROVER = 5)
	job_subclasses = list(
		/datum/advclass/grover
	)

/datum/advclass/grover
	name = "Grover"
	tutorial = "A humble townsman or perhaps a hermit, you chose to make the grove your home. It gave to you, so now you much give back. Keep the grove running as there is always labor to be done-- may the Wyldsman Prince rejoice in your efforts."
	outfit = /datum/outfit/job/roguetown/grover/basic
	category_tags = list(CTAG_GROVER)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_INT = -1,
	)
	subclass_skills = list(
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/grover
	name = "Grover"
	jobtype = /datum/job/roguetown/grover
	has_loadout = TRUE

/datum/outfit/job/roguetown/grover/basic

/datum/outfit/job/roguetown/grover/basic/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/psicross/dendor
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/fur
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/rogueweapon/sickle
	pants = /obj/item/clothing/under/roguetown/trou/leather/gronn
	H.ambushable = FALSE

/datum/job/roguetown/grover/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")
