/datum/advclass/drifter/ancestry/witch
	name = "Witch"
	// This class uses a custom requirement so it accepts gnomes of any sex or women of any race.
	tutorial = "They call you witch whether for your herbs, your dead-talk, or your habit of speaking as if clay and twigs might wake under your fingers. The golem-craft is only a tale, but the fear is real enough."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/drifter/witch
	category_tags = list(CTAG_ADVENTURER)
	traits_applied = list(TRAIT_RITUALIST, TRAIT_ALCHEMY_EXPERT, TRAIT_ARCYNE_T2, TRAIT_LITERACY)
	subclass_spellpoints = 6
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)

/datum/advclass/drifter/ancestry/witch/check_requirements(mob/living/carbon/human/H)
	if(!..())
		return FALSE
	if(H.gender == FEMALE)
		return TRUE
	return istype(H.dna?.species, /datum/species/dwarf/gnome)

/datum/outfit/job/roguetown/drifter/witch/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/head/roguetown/roguehood/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/storage/magebag/witch
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/mortar = 1,
		/obj/item/pestle = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1,
	)
	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/armor/corset
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/red
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/command_undead)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead_formation/necromancer)
