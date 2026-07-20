/datum/job/roguetown/baliff
	title = "Baliff"
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

	tutorial = "line 1 \
				line 2 \
				line 3"
	
	outfit = /datum/outfit/job/roguetown/baliff
	display_order = JDO_SHERIFF
	give_bank_account = TRUE
	min_pq = 0 //starting role
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_YEOMAN

	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	job_subclasses = list()

/datum/outfit/job/roguetown/baliff/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	head = /obj/item/clothing/head/roguetown/helmet/citywatch
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/citywatchcaptain
	armor = /obj/item/clothing/suit/roguetown/armor/plate/citywatch
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/citywatch
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/storage/backpack/rogue/satchel
	H.adjust_blindness(-3)
