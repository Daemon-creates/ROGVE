/datum/job/roguetown/custodian
	title = "Custodian"
	flag = CUSTODIAN
	department_flag = MAGEGUILD
	selection_color = JCOLOR_COURTIER
	faction = "Station"
	total_positions = 4
	spawn_positions = 4

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_MAGEARMOR, TRAIT_ARCYNE_T1)
	tutorial = "You are sworn, in order: first to the vault, that harmful Zizoid artifacts locked within never see the light of day; \
		second to the Headmaster, whose word is law within these walls; \
		third to the mages of the tower, whose safety is your charge; \
		and lastly to the tower itself, that its halls remain standing for the mages yet to come. \
		You are a Paragon of Noc and a protectorate of the arcyne, and you rarely leave the tower's grounds - save to retrieve some arcyne relic before it falls into the wrong hands."
	display_order = JDO_CUSTODIAN
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/custodian
	advclass_cat_rolls = list(CTAG_CUSTODIAN = 20)

	give_bank_account = 22
	min_pq = 3
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_YEOMAN
	cmode_music = 'sound/music/cmode/nobility/combat_courtmage.ogg'
	job_subclasses = list(
		/datum/advclass/custodian
	)

/datum/outfit/job/roguetown/custodian
	job_bitflag = BITFLAG_ROYALTY

/datum/advclass/custodian
	name = "Custodian"
	tutorial = "You are sworn, in order: first to the vault, that harmful Zizoid artifacts locked within never see the light of day; \
		second to the Headmaster, whose word is law within these walls; \
		third to the mages of the tower, whose safety is your charge; \
		and lastly to the tower itself, that its halls remain standing for the mages yet to come. \
		You are a Paragon of Noc and a protectorate of the arcyne, and you rarely leave the tower's grounds - save to retrieve some arcyne relic before it falls into the wrong hands."
	outfit = /datum/outfit/job/roguetown/custodian/basic

	category_tags = list(CTAG_CUSTODIAN)
	subclass_spellpoints = 6
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/custodian/basic/pre_equip(mob/living/carbon/human/H)
	..()
	// No shields - Custodians rely on their polearms and armor alone.
	head = /obj/item/clothing/head/roguetown/helmet/bascinet
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/custodian
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants/orange
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	cloak = /obj/item/clothing/cloak/ordinatorcape
	belt = /obj/item/storage/belt/rogue/leather
	r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/silver
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
	)

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/custodian
	name = "custodial gambeson"
	color = "#e98738"
	detail_color ="#720a24"
	picked = TRUE
