/datum/job/roguetown/townwatch
	title = "Town Watch"
	flag = GUARDSMAN
	department_flag = GARRISON
	faction = "Station"
	total_positions = 6
	spawn_positions = 6
	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	advclass_cat_rolls = list(CTAG_ROOKIE = 20)
	job_traits = list()

	tutorial = "You are a watchman. You carry the stick. The Duke's word is law, and it spoken through the studded end \
	of your cudgel. You deal with the townspeople, you see the desperation in their faces. The nobles waste away \
	up there, but you are the one that gets your boots wet. Listen to the Mayor and the Bailiff, follow their direction."
	
	outfit = /datum/outfit/job/roguetown/townwatch
	display_order = JDO_TOWNGUARD
	give_bank_account = TRUE
	min_pq = 0 //starting role
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_PEASANT

	cmode_music = 'sound/music/combat_citywatch.ogg'
	job_subclasses = list()

/datum/outfit/job/roguetown/townwatch/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	neck = /obj/item/clothing/neck/roguetown/coif/padded
	cloak = /obj/item/clothing/cloak/stabard/guardhood/town
	armor = /obj/item/clothing/suit/roguetown/armor/leather/cuirass
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/rope/chain
	gloves = /obj/item/clothing/gloves/roguetown/leather
	beltr = /obj/item/rogueweapon/mace/cudgel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/prelit
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	H.adjust_blindness(-3)
