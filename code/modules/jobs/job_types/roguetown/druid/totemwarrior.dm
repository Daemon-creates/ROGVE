//Sworn protector of the grove.
/datum/job/roguetown/totemwarrior
	title = "Totem Warrior"
	f_title = "Totem Warrior"
	flag = TOTEMWARRIOR
	department_flag = DRUID
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS //gets set to dendor on the outfit anyways
	outfit = /datum/outfit/job/roguetown/totemwarrior
	social_rank = SOCIAL_RANK_YEOMAN
	tutorial = "You have sworn yourself to the grove's defense. Where the archdruid and keeper tend the circle, you stand watch at its edge, spear and shield in hand, ready to meet whatever threatens Dendor's balance."

	display_order = JDO_TOTEMWARRIOR
	give_bank_account = TRUE
	min_pq = 3
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'

	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_traits = list(TRAIT_OUTDOORSMAN, TRAIT_WOODWALKER, TRAIT_STEELHEARTED, TRAIT_HOMESTEAD_EXPERT)

	advclass_cat_rolls = list(CTAG_TOTEMWARRIOR = 2)
	job_subclasses = list(
		/datum/advclass/totemwarrior,
		/datum/advclass/totemwarrior/bear,
		/datum/advclass/totemwarrior/volf,
		/datum/advclass/totemwarrior/zad,
	)

/datum/advclass/totemwarrior
	name = "Totem Warrior"
	tutorial = "You have sworn yourself to the grove's defense. Where the archdruid and keeper tend the circle, you stand watch at its edge, spear and shield in hand, ready to meet whatever threatens Dendor's balance."
	outfit = /datum/outfit/job/roguetown/totemwarrior/basic
	category_tags = list(CTAG_TOTEMWARRIOR)
	subclass_languages = list(/datum/language/beast)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/druidic = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/totemwarrior
	name = "Totem Warrior"
	jobtype = /datum/job/roguetown/totemwarrior
	allowed_patrons = list(/datum/patron/divine/dendor)
	has_loadout = TRUE

/datum/outfit/job/roguetown/totemwarrior/basic

/datum/outfit/job/roguetown/totemwarrior/basic/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/sack
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	backr = /obj/item/rogueweapon/shield/gilbranze/great
	cloak = /obj/item/clothing/cloak/volfmantle
	beltl = /obj/item/rogueweapon/sword/sabre/ancient
	neck = /obj/item/clothing/neck/roguetown/psicross/dendor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronnfur
	beltr = /obj/item/flashlight/flare/torch/lantern/bronzelamptern
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 6, TRUE)
	H.ambushable = FALSE

/datum/outfit/job/roguetown/totemwarrior/basic/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.put_in_hands(new /obj/item/rogueweapon/spear(H))

/datum/job/roguetown/totemwarrior/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")

//Way of the Bear - a tanky totem warrior who wades into the thick of it and refuses to fall.
/datum/advclass/totemwarrior/bear
	name = "Way of the Bear"
	tutorial = "You have taken up the mantle of the bear totem, Dendor's own bulwark. Where others fall back, you plant your feet. Hide as tough as bark and a will as unshakable as an ancient oak, you are the wall the grove hides behind."
	outfit = /datum/outfit/job/roguetown/totemwarrior/bear
	category_tags = list(CTAG_TOTEMWARRIOR)
	subclass_languages = list(/datum/language/beast)
	traits_applied = list(TRAIT_NATURALARMOR, TRAIT_CRITICAL_RESISTANCE)
	subclass_stats = list(
		STATKEY_CON = 4,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = -2
	)
	subclass_skills = list(
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/druidic = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/totemwarrior/bear/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/sack
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	backr = /obj/item/rogueweapon/shield/gilbranze/great
	cloak = /obj/item/clothing/cloak/darkcloak/bear
	beltl = /obj/item/rogueweapon/sword/sabre/ancient
	neck = /obj/item/clothing/neck/roguetown/psicross/dendor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronnfur
	beltr = /obj/item/flashlight/flare/torch/lantern/bronzelamptern
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/combat/shields, 6, TRUE)
	H.ambushable = FALSE

/datum/outfit/job/roguetown/totemwarrior/bear/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.put_in_hands(new /obj/item/rogueweapon/mace/warhammer/steel(H))

//Way of the Volf - a savage totem warrior who fights tooth and claw.
/datum/advclass/totemwarrior/volf
	name = "Way of the Volf"
	tutorial = "You have taken up the mantle of the volf totem, Dendor's fang. The wolf's hunger lives in you now, sharpening your teeth and quickening your hands into claws. Let the wilds see you as the predator you've become."
	outfit = /datum/outfit/job/roguetown/totemwarrior/volf
	category_tags = list(CTAG_TOTEMWARRIOR)
	subclass_languages = list(/datum/language/beast)
	traits_applied = list(TRAIT_STRONGBITE, TRAIT_BITERHELM)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 1,
		STATKEY_CON = 1,
		STATKEY_INT = -2
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/druidic = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/totemwarrior/volf/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/sack
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	cloak = /obj/item/clothing/cloak/volfmantle
	neck = /obj/item/clothing/neck/roguetown/psicross/dendor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronnfur
	beltr = /obj/item/flashlight/flare/torch/lantern/bronzelamptern
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets

	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 6, TRUE)
	H.ambushable = FALSE
	H.AddSpell(new /obj/effect/proc_holder/spell/self/claws)

/datum/outfit/job/roguetown/totemwarrior/volf/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.put_in_hands(new /obj/item/rogueweapon/whip(H))

//Way of the Zad - a totem warrior who hangs back and strikes from afar.
/datum/advclass/totemwarrior/zad
	name = "Way of the Zad"
	tutorial = "You have taken up the mantle of the zad totem, Dendor's watchful eye. You've learned to read the forest floor, set snares for what stalks it, and put an arrow through anything before it ever gets close."
	outfit = /datum/outfit/job/roguetown/totemwarrior/zad
	category_tags = list(CTAG_TOTEMWARRIOR)
	subclass_languages = list(/datum/language/beast)
	traits_applied = list(TRAIT_PERFECT_TRACKER, TRAIT_WILDERNESSGUIDE, TRAIT_ZJUMP)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_STR = -2
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/druidic = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/totemwarrior/zad/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/sack
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	cloak = /obj/item/clothing/cloak/raincloak/feather_cloak
	neck = /obj/item/clothing/neck/roguetown/psicross/dendor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	beltr = /obj/item/flashlight/flare/torch/lantern/bronzelamptern
	beltl = /obj/item/quiver/arrows
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/combat/bows, 6, TRUE)
	H.ambushable = FALSE

/datum/outfit/job/roguetown/totemwarrior/zad/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.put_in_hands(new /obj/item/rogueweapon/huntingknife(H))
