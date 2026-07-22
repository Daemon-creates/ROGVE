
/datum/job/roguetown/mayor
	title = "Mayor"
	flag = LORD
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_NOBLE
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_TOLERATED_UP
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "Whether you are a crooked politician or a true benefactor, you are the Mayor of the city of Rockhill and oversees both Lowtown and Hightown, the cityfolk now turn to you for guidance on smaller matters. \
				The Duke may hold the official title, but with the Sheriff under your command, will you submit to the weight of tradition or reshape the very idea of authority?"
	whitelist_req = TRUE
	outfit = /datum/outfit/job/roguetown/mayor
	display_order = JDO_LORD
	min_pq = 5
	max_pq = null
	give_bank_account = 100
	can_leave_round = FALSE

/datum/outfit/job/roguetown/mayor
	name = "Mayor"
	jobtype = /datum/job/roguetown/mayor

/datum/outfit/job/roguetown/mayor/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/nightman
	r_hand = /obj/item/gun/ballistic/firearm/arquebus_pistol
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/armor
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/ammopouch
	beltl = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/rogue/satchel
