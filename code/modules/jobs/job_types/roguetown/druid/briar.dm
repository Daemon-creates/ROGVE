//Dedicated opposition to the archdruid; means to steer the druid's circle to a different god than Dendor.
//Not necessarily a Dendorite, and not opposed through combat--through persuasion that it would benefit the circle.
//Still counted among the druid faction.
/datum/job/roguetown/briar
	title = "Briar"
	flag = BRIAR
	department_flag = DRUID
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS
	outfit = /datum/outfit/job/roguetown/briar
	social_rank = SOCIAL_RANK_YEOMAN
	tutorial = "You dwell within the grove, sworn to its keeping same as any druid--but you do not believe Dendor is the god the circle ought to serve. \
	You mean to see the grove turn to a different patron, and you intend to win that change through words and deeds, not the edge of a blade."

	display_order = JDO_BRIAR
	give_bank_account = TRUE
	min_pq = 5
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'

	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_traits = list(TRAIT_SEEDKNOW, TRAIT_OUTDOORSMAN, TRAIT_RITUALIST, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_BRIAR = 1)
	job_subclasses = list(
		/datum/advclass/briar
	)

/datum/advclass/briar
	name = "Briar"
	tutorial = "You dwell within the grove, sworn to its keeping same as any druid--but you do not believe Dendor is the god the circle ought to serve. \
	You mean to see the grove turn to a different patron, and you intend to win that change through words and deeds, not the edge of a blade."
	outfit = /datum/outfit/job/roguetown/briar/basic
	category_tags = list(CTAG_BRIAR)
	subclass_languages = list(/datum/language/beast)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/druidic = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/briar
	name = "Briar"
	jobtype = /datum/job/roguetown/briar
	has_loadout = TRUE

/datum/outfit/job/roguetown/briar/basic

/datum/outfit/job/roguetown/briar/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/dendormask
	backr = /obj/item/rogueweapon/woodstaff
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	backl = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/sickle
	pants = /obj/item/clothing/under/roguetown/loincloth/brown
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/holy, 5, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/magic/druidic, 5, TRUE)
	H.ambushable = FALSE

/datum/job/roguetown/briar/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")
