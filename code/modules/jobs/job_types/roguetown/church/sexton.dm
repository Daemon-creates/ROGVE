/datum/job/roguetown/sexton
	title = "Sexton"
	flag = SEXTON
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = ALL_AGES_LIST

	tutorial = "The Church’s sacred relics and holy objects do not tend to themselves. As Sexton, you are charged with keeping the reliquary vault well stocked. The Archbishop expects to see a house rich in devotion, and so it falls to you to ensure the shelves never look bare when his agents come to inspect and to keep the Church’s payments flowing."

	outfit = /datum/outfit/job/roguetown/sexton
	display_order = JDO_SEXTON
	give_bank_account = TRUE
	min_pq = -5
	max_pq = null
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_YEOMAN

	//A church officer, not nobility.
	virtue_restrictions = list(/datum/virtue/utility/noble)

	job_traits = list(TRAIT_RITUALIST, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_SEXTON = 2)
	job_subclasses = list(
		/datum/advclass/sexton
	)

/datum/advclass/sexton
	name = "Sexton"
	tutorial = "The Church’s sacred relics and holy objects do not tend to themselves. As Sexton, you are charged with keeping the reliquary vault well stocked. The Archbishop expects to see a house rich in devotion, and so it falls to you to ensure the shelves never look bare when his agents come to inspect and to keep the Church’s payments flowing."
	outfit = /datum/outfit/job/roguetown/sexton/basic
	category_tags = list(CTAG_SEXTON)
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/sexton/basic/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/psicross
	head = /obj/item/clothing/head/roguetown/roguehood
	armor = /obj/item/clothing/suit/roguetown/shirt/robe
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/keyring/churchie
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/ritechalk = 2)

/datum/job/roguetown/sexton/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
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
