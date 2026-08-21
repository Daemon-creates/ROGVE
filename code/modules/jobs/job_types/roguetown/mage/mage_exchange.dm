/datum/job/roguetown/mageexchange
	title = "Foreign Exchange Mage"
	flag = MAGEEXCHANGE
	department_flag = MAGEGUILD
	selection_color = JCOLOR_COURTIER
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_races = ACCEPTED_RACES
	spells = list(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	advclass_cat_rolls = list(CTAG_MAGEEXCHANGE = 20)

	tutorial = "You've traveled far from your homeland to study within these walls, drawn by the tower's renown even across borders and seas. \
		You've picked up enough of the Imperial tongue to follow along with your tutors, though your own mouth still refuses to shape its sounds properly - \
		you'll have to make do with your mother tongue, and whatever patience your hosts can spare you."

	outfit = /datum/outfit/job/roguetown/mageexchange
	display_order = JDO_MAGEEXCHANGE
	give_bank_account = TRUE

	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/nobility/combat_courtmage.ogg'
	advjob_examine = TRUE
	social_rank = SOCIAL_RANK_YEOMAN
	job_traits = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T2)
	job_subclasses = list(
		/datum/advclass/mageexchange
	)

/datum/outfit/job/roguetown/mageexchange
	beltl = /obj/item/storage/magebag/associate
	beltr = /obj/item/storage/keyring/mageapprentice

/datum/outfit/job/roguetown/mageexchange/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		backl = /obj/item/storage/backpack/rogue/satchel
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		beltr = /obj/item/storage/keyring/mageapprentice
		belt = /obj/item/storage/belt/rogue/leather/cloth/bandit
		pants = /obj/item/clothing/under/roguetown/skirt/knee/colored
		shoes = /obj/item/clothing/shoes/roguetown/sandals
	else if(should_wear_masc_clothes(H))
		backl = /obj/item/storage/backpack/rogue/satchel
		belt = /obj/item/storage/belt/rogue/leather/cloth/bandit
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/chalk = 1,
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.mind?.adjust_spellpoints(3)
	if(H.mind)
		var/list/heritages = list(
			"Etruscan" = /datum/language/etruscan,
			"Grenzelhoftian" = /datum/language/grenzelhoftian,
			"Otavan" = /datum/language/otavan,
			"Kazenguni" = /datum/language/kazengunese,
			"Aavnic" = /datum/language/aavnic,
			"Sandspeak" = /datum/language/celestial,
		)
		var/heritage_choice = input(H, "Choose your homeland's tongue", "HERITAGE") as anything in heritages
		var/datum/language/heritage_lang = heritages[heritage_choice]
		if(heritage_lang)
			H.grant_language(heritage_lang)
			var/datum/language_holder/LH = H.get_language_holder()
			LH.only_speaks_language = heritage_lang
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/mageexchange
	name = "Foreign Exchange Mage"
	tutorial = "You've traveled far from your homeland to study within these walls, drawn by the tower's renown even across borders and seas. \
		You've picked up enough of the Imperial tongue to follow along with your tutors, though your own mouth still refuses to shape its sounds properly - \
		you'll have to make do with your mother tongue, and whatever patience your hosts can spare you."
	outfit = /datum/outfit/job/roguetown/mageexchange/basic

	category_tags = list(CTAG_MAGEEXCHANGE)
	subclass_spellpoints = 18
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)
