/datum/job/roguetown/wapprentice
	title = "Apprentice Mage"
	flag = MAGEASSOCIATE
	department_flag = MAGEGUILD
	faction = "Station"
	total_positions = 5
	spawn_positions = 5

	allowed_races = ACCEPTED_RACES
	spells = list(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	advclass_cat_rolls = list(CTAG_WASSOCIATE = 20)

	tutorial = "Your master once saw potential in you, although you are uncertain if they still do, given how rigorous and difficult your studies have been. The path to using magic is a treacherous and untamed one, and you are still decades away from calling yourself even a journeyman in the field. Listen and serve, and someday you will earn your hat."

	outfit = /datum/outfit/job/roguetown/wapprentice

	display_order = JDO_MAGEASSOCIATE
	give_bank_account = TRUE

	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/nobility/combat_courtmage.ogg'
	advjob_examine = TRUE // So that Court Magicians can know if they're teachin' a Apprentice or if someone's a bit more advanced of a player. Just makes the title show up as the advjob's name.
	social_rank = SOCIAL_RANK_YEOMAN
	job_traits = list(TRAIT_ALCHEMY_EXPERT, TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3)
	job_subclasses = list(
		/datum/advclass/wapprentice/black,
		/datum/advclass/wapprentice/white,
		/datum/advclass/wapprentice/red,
		/datum/advclass/wapprentice/blue,
		/datum/advclass/wapprentice/green
	)

/datum/outfit/job/roguetown/wapprentice
	if(should_wear_femme_clothes(H))
		backl = /obj/item/storage/backpack/rogue/satchel
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/sofiavest
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		beltr = /obj/item/storage/keyring/mageapprentice
		belt = /obj/item/storage/belt/rogue/leather/cloth/bandit
		pants = /obj/item/clothing/under/roguetown/skirt/knee/colored
		shoes = /obj/item/clothing/shoes/roguetown/sandals
	else if(should_wear_masc_clothes(H))
		backl = /obj/item/storage/backpack/rogue/satchel
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter
		belt = /obj/item/storage/belt/rogue/leather/cloth/bandit
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	beltl = /obj/item/storage/magebag/associate
	beltr = /obj/item/storage/keyring/mageapprentice
	r_hand = /obj/item/rogueweapon/woodstaff

/datum/advclass/wapprentice/black
	name = "Black Mage"
	tutorial = "You were once an apprentice, though through your studies and practice you've mastered the basics of the arcyne. You've turned yourself towards the destructive end of the arts, learning to bend the elements into weapons. You now spend your days working under your master, honing your skills so that you might one day be considered a true master yourself."
	outfit = /datum/outfit/job/roguetown/wapprentice/black

	category_tags = list(CTAG_WASSOCIATE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1
	)
	subclass_spellpoints = 21
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wapprentice/black/pre_equip(mob/living/carbon/human/H)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/sofiavest/black
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/black
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1,
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.mind?.adjust_spellpoints(6)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/wapprentice/white
	name = "White Mage"
	tutorial = "Rather than the destructive arts, you found yourself drawn to the gentler side of the arcyne - the mending of flesh and the warding away of harm. Your master tolerates your soft heart so long as your poultices and wards keep the household standing."
	outfit = /datum/outfit/job/roguetown/wapprentice/white

	category_tags = list(CTAG_WASSOCIATE)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
	)
	subclass_spellpoints = 21
	subclass_skills = list(
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/wapprentice/white/pre_equip(mob/living/carbon/human/H)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/sofiavest/white
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/white
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1,
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_WIL, 1)
		H.mind?.adjust_spellpoints(6)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/wapprentice/red
	name = "Red Mage"
	tutorial = "Never one to focus on a single discipline, you've split your studies between blade and spell, a jack of all trades and master of none. Your master often chides you for spreading yourself too thin, but you've never let that stop you."
	outfit = /datum/outfit/job/roguetown/wapprentice/red

	category_tags = list(CTAG_WASSOCIATE)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1 // this is just a carrot for the folk who are mad enough to take this role...
	)
	subclass_spellpoints = 18
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wapprentice/red/pre_equip(mob/living/carbon/human/H)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/sofiavest/red
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/red
	r_hand = /obj/item/rogueweapon/sword/short
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/chalk = 1,
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.mind?.adjust_spellpoints(3)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/wapprentice/blue
	name = "Blue Mage"
	tutorial = "You've spent your studies less on casting and more on the collecting of knowledge itself, poring over tomes and scraps of half-forgotten lore. Your master finds your curiosity useful, if occasionally reckless."
	outfit = /datum/outfit/job/roguetown/wapprentice/blue

	category_tags = list(CTAG_WASSOCIATE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_WIL = 1
	)
	subclass_spellpoints = 21
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wapprentice/blue/pre_equip(mob/living/carbon/human/H)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/sofiavest/blue
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/blue
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1,
		/obj/item/book/rogue = 1,
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.mind?.adjust_spellpoints(6)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/wapprentice/green
	name = "Green Mage"
	tutorial = "During your studies, you became less focused on the arcyne and instead turned yourself to your true passion, alchemy. Through the art of transmutation, you have learned that the elements (much like the arcyne) can be maniupulated and bent to your will."
	outfit = /datum/outfit/job/roguetown/wapprentice/green

	category_tags = list(CTAG_WASSOCIATE)
	traits_applied = list(TRAIT_SEEDKNOW)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_WIL = 1
	)
	subclass_spellpoints = 18
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wapprentice/green/pre_equip(mob/living/carbon/human/H)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/sofiavest/green
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/green
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/seeds/swampweed = 1,
		/obj/item/seeds/pipeweed = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/rogueweapon/sickle
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		H.change_stat(STATKEY_PER, -1)
		H.change_stat(STATKEY_INT, 1)
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/black
	color = "#353535"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/white
	color = "#e8e8e0"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/red
	color = "#b8252c"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/blue
	color = "#4756d8"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter/green
	color = "#759259"

/obj/item/clothing/suit/roguetown/shirt/robe/sofiavest/black
	color = "#353535"

/obj/item/clothing/suit/roguetown/shirt/robe/sofiavest/white
	color = "#e8e8e0"

/obj/item/clothing/suit/roguetown/shirt/robe/sofiavest/red
	color = "#b8252c"

/obj/item/clothing/suit/roguetown/shirt/robe/sofiavest/blue
	color = "#4756d8"

/obj/item/clothing/suit/roguetown/shirt/robe/sofiavest/green
	color = "#759259"
