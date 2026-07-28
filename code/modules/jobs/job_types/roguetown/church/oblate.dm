/datum/job/roguetown/oblate
	title = "Oblate"
	flag = OBLATE
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)

	tutorial = "Born to a noble house, you were given up to the Church as a child--whether to settle a debt, avoid a scandal, or simply because your family had one mouth too many to feed. Disinherited and stripped of your birthright, you were raised within these walls. Nobility runs in your blood, but your title belongs to the Church now."

	outfit = /datum/outfit/job/roguetown/oblate
	display_order = JDO_OBLATE
	give_bank_account = TRUE
	min_pq = -5
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_NOBLE

	//You've been disinherited and given up to the Church. Your blood is noble, but your standing in this world is not.
	virtue_restrictions = list(/datum/virtue/utility/noble)

	advclass_cat_rolls = list(CTAG_OBLATE = 2)
	job_subclasses = list(
		/datum/advclass/oblate
	)
	job_traits = list(TRAIT_NOBLE, TRAIT_HOMESTEAD_EXPERT)

/datum/advclass/oblate
	name = "Oblate"
	tutorial = "Born to a noble house, you were given up to the Church as a child--whether to settle a debt, avoid a scandal, or simply because your family had one mouth too many to feed. Disinherited and stripped of your birthright, you were raised within these walls. Nobility runs in your blood, but your title belongs to the Church now."
	outfit = /datum/outfit/job/roguetown/oblate/basic
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_OBLATE)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/music = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/oblate/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/psicross
	if(should_wear_femme_clothes(H))
		head = /obj/item/clothing/head/roguetown/armingcap
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights
	belt = /obj/item/storage/belt/rogue/leather/rope
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	beltl = /obj/item/storage/keyring/churchie
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/book/rogue/bibble = 1)

/datum/job/roguetown/oblate/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")
	//Title stuff. This is super sloppy.
	var/prev_real_name = H.real_name
	var/prev_name = H.name
	//Default fallback title.
	var/title = "Devotee"
	//Actual titles now, based on pronouns.
	switch(H.pronouns)
		if(SHE_HER)
			title = "Sister"
		if(SHE_HER_M)
			title = "Sister"
		if(HE_HIM)
			title = "Brother"
		if(HE_HIM_F)
			title = "Brother"
	//Now apply the actual title.
	H.real_name = "[title] [prev_real_name]"
	H.name = "[title] [prev_name]"
