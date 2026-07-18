/datum/advclass/bandit_specialist/armorer // the camp's smith - keeps everyone's steel and plate in fighting shape
	name = "Armorer"
	tutorial = "Whether apprenticed or self-taught, you know your way around a forge. The camp needs someone to keep their blades sharp and their plate dent-free, \
	and looting a smithy or two along the way has left you with the tools and the ore to do just that."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit_specialist/armorer
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_TRAINED_SMITH)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN, //needed for getting into hideout
	)

/datum/outfit/job/roguetown/bandit_specialist/armorer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_notice("I start with a stash of ore and bars for keeping the camp's gear in fighting shape."))
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/hammer/iron
	beltl = /obj/item/rogueweapon/tongs
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/backpack
	id = /obj/item/mattcoin
	backpack_contents = list(
					/obj/item/flint = 1,
					/obj/item/rogueore/coal = 2,
					/obj/item/rogueore/iron = 4,
					/obj/item/flashlight/flare/torch/lantern = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					)
	H.adjust_blindness(-3)
	if(H.mind)
		var/molds = list(
			"Iron sword mold" = /obj/item/mold/sword,
			"Iron axe mold" = /obj/item/mold/axe,
			"Iron mace mold" = /obj/item/mold/mace,
			"Iron knife mold" = /obj/item/mold/knife,
			"Iron polearm mold" = /obj/item/mold/polearm,
			"Iron plate" = /obj/item/mold/plate,
		)
		var/mold_choice = input(H, "Choose your starting mold.", "Select") as anything in molds
		r_hand = molds[mold_choice]
	H.set_blindness(0)

/datum/outfit/job/roguetown/bandit_specialist/armorer/post_equip(mob/living/carbon/human/H)
	. = ..()
	for(var/datum/bounty/b in GLOB.head_bounties)
		if(b.target == H.real_name || b.target_hidden == H.real_name)
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_CON, 1)
