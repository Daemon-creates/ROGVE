/datum/advclass/drifter/clad_scavenger
	name = "Clad Scavenger"
	tutorial = "You have no oath, no banner, and no matching set of armor. Every plate, glove, and helm was found, traded, or torn from a corpse unlucky enough to drop it."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/drifter/clad_scavenger
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/drifter/clad_scavenger/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = null
	if(prob(70))
		shoes = pick(/obj/item/clothing/shoes/roguetown/boots/leather, /obj/item/clothing/shoes/roguetown/boots/leather/reinforced, /obj/item/clothing/shoes/roguetown/boots/armor/iron)
	if(prob(70))
		gloves = pick(/obj/item/clothing/gloves/roguetown/angle, /obj/item/clothing/gloves/roguetown/chain/iron, /obj/item/clothing/gloves/roguetown/plate/iron)
	if(prob(70))
		head = pick(/obj/item/clothing/head/roguetown/helmet, /obj/item/clothing/head/roguetown/helmet/kettle, /obj/item/clothing/head/roguetown/helmet/sallet, /obj/item/clothing/head/roguetown/helmet/horned, /obj/item/clothing/head/roguetown/helmet/nomadhelmet)
	if(prob(70))
		armor = pick(/obj/item/clothing/suit/roguetown/armor/gambeson, /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat, /obj/item/clothing/suit/roguetown/armor/brigandine/light, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron, /obj/item/clothing/suit/roguetown/armor/plate/half/iron)
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/rogueweapon/huntingknife = 1)

