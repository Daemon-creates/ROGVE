/datum/job/roguetown/bogmaster
	title = "Bog Master"
	flag = BOGGUARD
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	advclass_cat_rolls = list(CTAG_ROOKIE = 20)
	job_traits = list()

	tutorial = "You've survived for quite some time, but your days are numbered. You know what lies beyond-- death and darkness for miles. \
	Think about what it takes to keep your men alive. You were once part of the Duke's retinue, now you're organizing parolees and fresh recruits. \
	This is your gate. You will not compromise, you will not falter. Just one more week."
	
	outfit = /datum/outfit/job/roguetown/bogmaster
	display_order = JDO_BOGMASTER
	give_bank_account = TRUE
	min_pq = 0 //starting role
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_YEOMAN

	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	job_subclasses = list()

/datum/outfit/job/roguetown/bogmaster/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	cloak = /obj/item/clothing/cloak/stabard/bog
	backl = /obj/item/rogueweapon/shield/tower
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	beltr = /obj/item/rogueweapon/mace/steel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern/prelit
	pants = /obj/item/clothing/under/roguetown/splintlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	H.adjust_blindness(-3)
