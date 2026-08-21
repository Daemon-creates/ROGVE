/datum/job/roguetown/bailiff
	title = "Bailiff"
	flag = SHERIFF
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	advclass_cat_rolls = list(CTAG_ROOKIE = 20)
	job_traits = list()

	tutorial = "You were never afraid to get your hands dirty. Now, you're telling your watchmen to do it for you. You answer to the Mayor, he's busy \
	entertaining the nobles. You have work to do. Organize your men, let no harm come to the businesses and institutions of this town. You did not \
	get this far for nothing. Let your ambitions not be stifled by the underlying misery of this place. Take orders directly from the Marshal... if he's there at all."
	
	outfit = /datum/outfit/job/roguetown/bailiff
	display_order = JDO_SHERIFF
	give_bank_account = TRUE
	min_pq = 0 //starting role
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_YEOMAN

	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	job_subclasses = list()

/datum/outfit/job/roguetown/bailiff/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	head = /obj/item/clothing/head/roguetown/chaperon/noble/bailiff
	cloak = /obj/item/clothing/cloak/stabard/guardhood/town
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/leather
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	wrists = /obj/item/rope/chain
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain
	beltr = /obj/item/rogueweapon/mace/cudgel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern/prelit
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	H.adjust_blindness(-3)

