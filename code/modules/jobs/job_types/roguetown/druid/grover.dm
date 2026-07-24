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
	tutorial = "The grove gave you a roof and a full belly when you had neither, and all it asks in return is your labor. You chop the wood, tend the beasts, and haul what needs hauling. \
	It isn't glamorous, but it's honest, and the druids treat you fairly enough for it."

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
	tutorial = "The grove gave you a roof and a full belly when you had neither, and all it asks in return is your labor. You chop the wood, tend the beasts, and haul what needs hauling. \
	It isn't glamorous, but it's honest, and the druids treat you fairly enough for it."
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
	belt = /obj/item/storage/belt/rogue/leather/rope
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/flashlight/flare/torch
	beltl = /obj/item/rogueweapon/sickle
	backl = /obj/item/storage/backpack/rogue/satchel
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backpack_contents = list(/obj/item/rogueweapon/hoe = 1, /obj/item/flint = 1)
	H.ambushable = FALSE

/datum/job/roguetown/grover/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")
