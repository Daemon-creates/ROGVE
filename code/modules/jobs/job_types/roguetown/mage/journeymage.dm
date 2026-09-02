/datum/job/roguetown/journeymage
	title = "Journeyman Mage"
	flag = JOURNEYMAGE
	department_flag = MAGEGUILD
	selection_color = JCOLOR_COURTIER
	faction = "Station"
	total_positions = 3
	spawn_positions = 3

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	spells = list(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	display_order = JDO_JOURNEYMAGE
	tutorial = "You have long since outgrown your apprenticeship, your name known well enough about the tower that the younger students look to you for guidance. \
		You've yet to earn the right to sit at the Headmaster's table, but your studies have carried you far beyond the basics of the arcyne. \
		Choose your specialty wisely, for it will define you for years to come."
	outfit = /datum/outfit/job/roguetown/journeymage
	whitelist_req = TRUE
	give_bank_account = 30
	min_pq = 2
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/nobility/combat_courtmage.ogg'
	advclass_cat_rolls = list(CTAG_JOURNEYMAGE = 15)
	social_rank = SOCIAL_RANK_MINOR_NOBLE
	job_traits = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_ALCHEMY_EXPERT)
	job_subclasses = list(
		/datum/advclass/journeymage/summoner,
		/datum/advclass/journeymage/alchemist,
		/datum/advclass/journeymage/artificer
	)

/datum/outfit/job/roguetown/journeymage
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltr = /obj/item/storage/keyring/mage
	backl = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/clothing/ring/gold

/datum/advclass/journeymage/summoner
	name = "Summoner"
	tutorial = "Where others chase after fire and lightning, you've turned your studies towards that which is not truly there - binding lesser spirits and conjured constructs to your will. \
		It is delicate work, and a poorly bound conjuration can turn on its caster just as easily as an enemy."
	outfit = /datum/outfit/job/roguetown/journeymage/summoner

	subclass_spellpoints = 28
	category_tags = list(CTAG_JOURNEYMAGE)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/journeymage/summoner/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	beltl = /obj/item/storage/magebag/associate
	r_hand = /obj/item/ritechalk
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 2,
		/obj/item/recipe_book/alchemy,
		/obj/item/recipe_book/magic,
		/obj/item/book/spellbook,
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 5, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.mind?.adjust_spellpoints(6)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

/datum/advclass/journeymage/alchemist
	name = "Alchemist"
	tutorial = "You've dedicated your journeyman years to the transmutation of the world about you, mixing reagent and reagent in search of the perfect concoction. \
		Poison or panacea, the choice - and the consequence - is yours to bear."
	outfit = /datum/outfit/job/roguetown/journeymage/alchemist

	subclass_spellpoints = 24
	category_tags = list(CTAG_JOURNEYMAGE)
	traits_applied = list(TRAIT_SEEDKNOW)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/journeymage/alchemist/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/magegreen
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	beltl = /obj/item/storage/magebag/alchemist
	r_hand = /obj/item/rogueweapon/sickle
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 2,
		/obj/item/seeds/swampweed,
		/obj/item/seeds/pipeweed,
		/obj/item/recipe_book/alchemy,
		/obj/item/recipe_book/magic,
		/obj/item/book/spellbook,
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 5, TRUE)
		H.change_stat(STATKEY_PER, -1)
		H.change_stat(STATKEY_INT, 1)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

/datum/advclass/journeymage/artificer
	name = "Artificer"
	tutorial = "Spells fade the moment they're cast, but a well-wrought enchantment endures. You've spent your years bent over the workbench rather than the spellbook, \
		binding the arcyne into steel, wood and stone so that even the unlearned might wield a sliver of its power."
	outfit = /datum/outfit/job/roguetown/journeymage/artificer

	subclass_spellpoints = 24
	category_tags = list(CTAG_JOURNEYMAGE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_STR = 1,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/craft/engineering = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/journeymage/artificer/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mageorange
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	beltl = /obj/item/storage/magebag/associate
	r_hand = /obj/item/rogueweapon/hammer/iron
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 2,
		/obj/item/recipe_book/alchemy,
		/obj/item/recipe_book/magic,
		/obj/item/book/spellbook,
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/craft/engineering, 5, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
