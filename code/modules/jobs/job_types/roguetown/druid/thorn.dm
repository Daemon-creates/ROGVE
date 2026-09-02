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
	tutorial = "You dance like Saiga, you howl like a volf, but you are no Fian. You are sworn to protect the Briar and their greater ambition, whatever that means for the world. You are to lay down your very life for their cause."

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
	tutorial ="You dance like Saiga, you howl like a volf, but you are no Fian. You are sworn to protect the Briar and their greater ambition, whatever that means for the world. You are to lay down your very life for their cause."
	outfit = /datum/outfit/job/roguetown/thorn
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


/datum/outfit/job/roguetown/thorn/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/sack
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	backr = /obj/item/rogueweapon/shield/gilbranze/great
	cloak = /obj/item/clothing/cloak/volfmantle
	beltl = /obj/item/rogueweapon/sword/sabre/ancient
	neck = /obj/item/clothing/neck/roguetown/psicross/dendor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronnfur
	beltr = /obj/item/flashlight/flare/torch/lantern/bronzelamptern
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 6, TRUE)
	H.ambushable = FALSE

/datum/outfit/job/roguetown/thorn/choose_loadout(mob/living/carbon/human/H)
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
