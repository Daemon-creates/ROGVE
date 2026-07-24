//Second to the archdruid, performer of the rituals that keep the druid's circle healthy.
/datum/job/roguetown/druidkeeper
	title = "Sacrist"
	flag = DRUIDKEEPER
	department_flag = DRUID
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS //gets set to dendor on the outfit anyways
	outfit = /datum/outfit/job/roguetown/druidkeeper
	social_rank = SOCIAL_RANK_YEOMAN
	tutorial = "You are second only to the archdruid, and it is your rituals that keep the circle healthy--the wards renewed, the wildform gifts undiminished, the grove's balance with Dendor unbroken. \
	Should the archdruid fall or falter, it is you who must hold the grove together."

	display_order = JDO_DRUIDKEEPER
	give_bank_account = TRUE
	min_pq = 5
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'

	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_traits = list(TRAIT_SEEDKNOW, TRAIT_RITUALIST, TRAIT_HOMESTEAD_EXPERT, TRAIT_ALCHEMY_EXPERT, TRAIT_MEDICINE_EXPERT)

	advclass_cat_rolls = list(CTAG_DRUIDKEEPER = 1)
	job_subclasses = list(
		/datum/advclass/druidkeeper
	)

/datum/advclass/druidkeeper
	name = "Keeper"
	tutorial = "You are second only to the archdruid, and it is your rituals that keep the circle healthy--the wards renewed, the wildform gifts undiminished, the grove's balance with Dendor unbroken. \
	Should the archdruid fall or falter, it is you who must hold the grove together."
	outfit = /datum/outfit/job/roguetown/druidkeeper/basic
	category_tags = list(CTAG_DRUIDKEEPER)
	subclass_languages = list(/datum/language/beast)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/druidic = SKILL_LEVEL_EXPERT, //Shapeshifting.
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/druidkeeper
	name = "Keeper"
	jobtype = /datum/job/roguetown/druidkeeper
	allowed_patrons = list(/datum/patron/divine/dendor)
	has_loadout = TRUE

/datum/outfit/job/roguetown/druidkeeper/basic

/datum/outfit/job/roguetown/druidkeeper/basic/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/
	backr = /obj/item/rogueweapon/woodstaff
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/dendormask
	id = /obj/item/clothing/neck/roguetown/psicross/dendor //Ring slot amulet for wildform so it is not dropping on the ground.
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
	backpack_contents = list(/obj/item/ritechalk = 2, /obj/item/storage/keyring/churchie = 1, /obj/item/seeds/treesap = 1)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/holy, 5, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/magic/druidic, 5, TRUE)
	H.ambushable = FALSE

/datum/outfit/job/roguetown/druidkeeper/basic/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.put_in_hands(new /obj/item/rogueweapon/woodstaff(H))

/datum/job/roguetown/druidkeeper/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")

	if(H.patron)
		H.reset_clergy_devotion(CLERIC_T3, CLERIC_REGEN_MINOR, TRUE, CLERIC_REQ_3)

	spawn(50)
		if(H && H.client)
			to_chat(H, span_notice("The rituals of the grove fall to me now."))
