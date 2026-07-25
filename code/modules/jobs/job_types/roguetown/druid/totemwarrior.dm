//Sworn protector of the grove.
/datum/job/roguetown/totemwarrior
	title = "Totem Warrior"
	f_title = "Totem Warrior"
	flag = TOTEMWARRIOR
	department_flag = DRUID
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS //gets set to dendor on the outfit anyways
	outfit = /datum/outfit/job/roguetown/totemwarrior
	social_rank = SOCIAL_RANK_YEOMAN
	tutorial = "You have sworn yourself to the grove's defense. Where the archdruid and keeper tend the circle, you stand watch at its edge, spear and shield in hand, ready to meet whatever threatens Dendor's balance."

	display_order = JDO_TOTEMWARRIOR
	give_bank_account = TRUE
	min_pq = 3
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'

	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_WOODWALKER, TRAIT_STEELHEARTED, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_TOTEMWARRIOR = 2)
	job_subclasses = list(
		/datum/advclass/totemwarrior
	)

/datum/advclass/totemwarrior
	name = "Totem Warrior"
	tutorial = "You have sworn yourself to the grove's defense. Where the archdruid and keeper tend the circle, you stand watch at its edge, spear and shield in hand, ready to meet whatever threatens Dendor's balance."
	outfit = /datum/outfit/job/roguetown/totemwarrior/basic
	category_tags = list(CTAG_TOTEMWARRIOR)
	subclass_languages = list(/datum/language/beast)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/druidic = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/totemwarrior
	name = "Totem Warrior"
	jobtype = /datum/job/roguetown/totemwarrior
	allowed_patrons = list(/datum/patron/divine/dendor)
	has_loadout = TRUE

/datum/outfit/job/roguetown/totemwarrior/basic

/datum/outfit/job/roguetown/totemwarrior/basic/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/sack
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	backr = /obj/item/rogueweapon/shield/gilbranze/great
	cloak = /obj/item/clothing/cloak/volfmantle
	backl = /obj/item/rogueweapon/sword/sabre/ancient
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	id = /obj/item/clothing/neck/roguetown/psicross/dendor
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronnfur
	beltr = /obj/item/flashlight/flare/torch/lantern/bronzelamptern
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets
	backpack_contents = list(/obj/item/ritechalk = 1, /obj/item/storage/keyring/churchie = 1)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 6, TRUE)
	H.ambushable = FALSE

/datum/outfit/job/roguetown/totemwarrior/basic/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.put_in_hands(new /obj/item/rogueweapon/spear(H))

/datum/job/roguetown/totemwarrior/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")
