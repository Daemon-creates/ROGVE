//Sworn protector of the briar.
/datum/job/roguetown/thorn
	title = "Thorn"
	flag = THORN
	department_flag = DRUID
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS
	outfit = /datum/outfit/job/roguetown/thorn
	social_rank = SOCIAL_RANK_YEOMAN
	tutorial = "You have sworn yourself to the briar's protection, whatever the rest of the grove thinks of that choice. Your loyalty is not to Dendor or the archdruid, but to the one who means to change the circle's fate."

	display_order = JDO_THORN
	give_bank_account = TRUE
	min_pq = 3
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'

	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_STEELHEARTED, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_THORN = 2)
	job_subclasses = list(
		/datum/advclass/thorn
	)

/datum/advclass/thorn
	name = "Thorn"
	tutorial = "You have sworn yourself to the briar's protection, whatever the rest of the grove thinks of that choice. Your loyalty is not to Dendor or the archdruid, but to the one who means to change the circle's fate."
	outfit = /datum/outfit/job/roguetown/thorn/basic
	category_tags = list(CTAG_THORN)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_PER = 1,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/thorn
	name = "Thorn"
	jobtype = /datum/job/roguetown/thorn
	has_loadout = TRUE

/datum/outfit/job/roguetown/thorn/basic

/datum/outfit/job/roguetown/thorn/basic/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/rogueweapon/scabbard/sheath = 1)
	H.ambushable = FALSE

/datum/outfit/job/roguetown/thorn/basic/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel(H))

/datum/job/roguetown/thorn/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")
