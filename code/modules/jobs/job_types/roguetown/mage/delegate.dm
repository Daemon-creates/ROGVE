/datum/job/roguetown/magedelegate
	title = "Delegate"
	flag = MAGEDELEGATE
	department_flag = MAGEGUILD
	selection_color = JCOLOR_COURTIER
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_NO_CONSTRUCT
	allowed_sexes = list(MALE, FEMALE)
	spells = list(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	display_order = JDO_MAGEDELEGATE
	tutorial = "You are the Headmaster's right hand, entrusted to see that their will is carried out even in their absence. \
		Where the Headmaster sets the course of the tower's studies, it falls to you to see that the day-to-day matters - discipline, provisions, and the training of the younger mages - do not fall to ruin. \
		Should the Headmaster's seat ever fall empty, all eyes will turn to you."
	outfit = /datum/outfit/job/roguetown/magedelegate
	whitelist_req = TRUE
	give_bank_account = 40
	min_pq = 3
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/nobility/combat_courtmage.ogg'
	advclass_cat_rolls = list(CTAG_MAGEDELEGATE = 2)
	social_rank = SOCIAL_RANK_MINOR_NOBLE
	// Can't get very far as a delegate if you can't chant spells now can you?
	vice_restrictions = list(/datum/charflaw/mute)

	job_traits = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_SEEPRICES, TRAIT_INTELLECTUAL, TRAIT_ALCHEMY_EXPERT)
	job_subclasses = list(
		/datum/advclass/magedelegate
	)

/datum/advclass/magedelegate
	name = "Delegate"
	tutorial = "You are the Headmaster's right hand, entrusted to see that their will is carried out even in their absence. \
		Where the Headmaster sets the course of the tower's studies, it falls to you to see that the day-to-day matters - discipline, provisions, and the training of the younger mages - do not fall to ruin. \
		Should the Headmaster's seat ever fall empty, all eyes will turn to you."
	outfit = /datum/outfit/job/roguetown/magedelegate/basic

	subclass_spellpoints = 30
	category_tags = list(CTAG_MAGEDELEGATE)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3,
		STATKEY_LCK = 1,
		STATKEY_STR = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/magedelegate
	job_bitflag = BITFLAG_ROYALTY
	has_loadout = TRUE

/datum/outfit/job/roguetown/magedelegate/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 5, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.mind?.adjust_spellpoints(6)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

/datum/outfit/job/roguetown/magedelegate/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/talkstone
	mask = /obj/item/clothing/neck/roguetown/collar/feldcollar
	armor = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/loudmouth
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltr = /obj/item/storage/keyring/mage
	beltl = /obj/item/storage/magebag/associate
	id = /obj/item/clothing/ring/gold
	r_hand = /obj/item/rogueweapon/woodstaff/riddle_of_steel
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/poison,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/recipe_book/alchemy,
		/obj/item/recipe_book/magic,
		/obj/item/book/spellbook,
	)
