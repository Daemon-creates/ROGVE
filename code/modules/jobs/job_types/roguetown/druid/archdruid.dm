//Head of the druid grove. One of eight roles in the druid grove faction alongside druidkeeper.dm, totemwarrior.dm,
//exile.dm, grover.dm, briar.dm and thorn.dm (see the parent church/druid.dm for the rank-and-file Druid role).
/datum/job/roguetown/archdruid
	title = "Archdruid"
	f_title = "Archdruidess"
	flag = ARCHDRUID
	department_flag = DRUID
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS //gets set to dendor on the outfit anyways
	outfit = /datum/outfit/job/roguetown/archdruid
	social_rank = SOCIAL_RANK_MINOR_NOBLE
	tutorial = "You were born in this grove into the hands of the Mother Druid herself. You've watched this town grow around you, and you've never \
	left this spot. You've spent the entirety of your life guiding these poor souls through Dendor's realm, now you're wondering how it will be when \
	you are gone. Protect the tree at all costs, spare your people from the wrath of Dendor-- lest your bones be broken and twisted into unnatural shapes."
	give_bank_account = TRUE
	min_pq = 15
	max_pq = null
	round_contrib_points = 5
	cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'

	//Head of the grove or not, you're still clergy of a sort, not nobility.
	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_traits = list(TRAIT_SEEDKNOW, TRAIT_OUTDOORSMAN, TRAIT_RITUALIST, TRAIT_HOMESTEAD_EXPERT, TRAIT_WILDERNESSGUIDE, TRAIT_WOODWALKER, TRAIT_STEELHEARTED)

	advclass_cat_rolls = list(CTAG_ARCHDRUID = 1)
	job_subclasses = list(
		/datum/advclass/archdruid
	)

/datum/advclass/archdruid
	name = "Archdruid"
	tutorial = "You were born in this grove into the hands of the Mother Druid herself. You've watched this town grow around you, and you've never \
	left this spot. You've spent the entirety of your life guiding these poor souls through Dendor's realm, now you're wondering how it will be when \
	you are gone. Protect the tree at all costs, spare your people from the wrath of Dendor-- lest your bones be broken and twisted into unnatural shapes."
	outfit = /datum/outfit/job/roguetown/archdruid
	category_tags = list(CTAG_ARCHDRUID)
	subclass_languages = list(/datum/language/beast)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 3,
		STATKEY_PER = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/druidic = SKILL_LEVEL_MASTER, //Shapeshifting.
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
	)

/datum/outfit/job/roguetown/archdruid
	name = "Archdruid"
	jobtype = /datum/job/roguetown/archdruid
	allowed_patrons = list(/datum/patron/divine/dendor)
	has_loadout = TRUE


/datum/outfit/job/roguetown/archdruid/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	mask = /obj/item/clothing/mask/rogue/sack
	head = /obj/item/clothing/head/roguetown/helmet/sallet/beastskull
	backr = /obj/item/rogueweapon/woodstaff/riddle_of_steel/serpent
	cloak = /obj/item/clothing/cloak/darkcloak/minotaur/grey
	neck = /obj/item/clothing/neck/roguetown/psicross/dendor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth
	pants = /obj/item/clothing/under/roguetown/trou/leather/gronn
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/holy, 6, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/magic/druidic, 6, TRUE)
	H.ambushable = FALSE

/obj/item/clothing/cloak/darkcloak/minotaur/grey
	color = "#6c6c6c"
	name = "wendigo cloak"

/datum/outfit/job/roguetown/archdruid/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.put_in_hands(new /obj/item/rogueweapon/woodstaff(H))

/datum/job/roguetown/archdruid/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")

	spawn(50)
		if(H && H.client)
			_delayed_path_choice(H)

/datum/job/roguetown/archdruid/proc/grant_old_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	REMOVE_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.reset_clergy_devotion(CLERIC_T4, CLERIC_REGEN_MAJOR, TRUE, CLERIC_REQ_4)
	to_chat(H, span_notice("I remain on the old path of devotion."))

/datum/job/roguetown/archdruid/proc/grant_radical_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	ADD_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.miracle_points += 3
	H.church_favor += 1600
	H.reset_clergy_devotion(CLERIC_T4, CLERIC_REGEN_MAJOR, TRUE, CLERIC_REQ_4)
	to_chat(H, span_notice("I embrace the radical path."))

/datum/job/roguetown/archdruid/proc/_delayed_path_choice(mob/living/carbon/human/H)
	if(!H || !H.client || !H.mind)
		return

	var/choice = alert(H, "Choose your path.", "Druidic Doctrine", "Loyalist", "Radical")

	if(choice == "Radical")
		grant_radical_path(H)
	else
		grant_old_path(H)
