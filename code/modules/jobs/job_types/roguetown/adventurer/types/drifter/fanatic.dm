/datum/advclass/drifter/fanatic
	name = "Fanatic"
	tutorial = "The road has stripped away everything but conviction. You carry your creed in ash and powder now, trusting that flame will preach where words fail."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/drifter/fanatic
	category_tags = list(CTAG_ADVENTURER)
	maximum_possible_slots = 3
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/drifter/fanatic/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_danger("You carry a ruinous quantity of explosives. Play the role with care, and expect your choices to set the tone for every nearby soul."))
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/tntstick
	beltr = /obj/item/tntstick
	backl = /obj/item/storage/backpack/rogue/satchel
	r_hand = /obj/item/satchel_bomb
	l_hand = /obj/item/satchel_bomb
	backpack_contents = list(
		/obj/item/satchel_bomb = 1,
		/obj/item/tntstick = 1,
		/obj/item/flashlight/flare/torch = 1,
	)

