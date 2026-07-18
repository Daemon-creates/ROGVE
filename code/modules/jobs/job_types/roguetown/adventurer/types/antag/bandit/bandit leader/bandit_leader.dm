/datum/job/roguetown/bandit_leader
	title = "Bandit Leader"
	flag = BANDIT
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	antag_job = TRUE
	allowed_races = RACES_NO_CONSTRUCT
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "Once just another face fallen to the wrong side of the carriage, you've clawed your way to the top of your gang through blood, cunning, or both. \
	Your fellows look to you to lead the camp, plan the raids, and decide who lives and who dies. The bigger the bounty on your head, the more they respect you."

	outfit = /datum/outfit/job/roguetown/bandit_leader
	outfit_female = null

	obsfuscated_job = TRUE

	display_order = JDO_BANDIT
	announce_latejoin = FALSE
	min_pq = 0
	max_pq = null
	round_contrib_points = 5
	allowed_patrons = list(/datum/patron/inhumen/matthios) // Bandits bro, they rob you blind

	social_rank = SOCIAL_RANK_PEASANT
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE //There's only ever one leader; a new one has to earn it in a fresh round
	job_traits = list(TRAIT_SELF_SUSTENANCE, TRAIT_DEATHBYSNUSNU, TRAIT_STEELHEARTED, TRAIT_HEAVYARMOR)
	same_job_respawn_delay = 1 MINUTES
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'

/datum/job/roguetown/bandit_leader/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		H.ambushable = FALSE
	
/datum/outfit/job/roguetown/bandit_leader/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored/black
	pants = /obj/item/clothing/under/roguetown/platelegs
	gloves = /obj/item/clothing/gloves/roguetown/plate
	cloak = /obj/item/clothing/cloak/tabard/blkknight
	neck = /obj/item/clothing/neck/roguetown/gorget
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	armor = /obj/item/clothing/suit/roguetown/armor/plate/blkknight
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blkknight
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/mattcoin
	backpack_contents = list(
					/obj/item/rogueweapon/huntingknife/idagger = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
					)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Master Swordsman","Master Spearman","Master Cleaver","Master Bludgeoner")
		var/weapon_choice = input(H, "Choose your proficiency.", "HOW DOTH THOU LEAD, BANDIT LEADER?") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Master Swordsman")
				beltr = /obj/item/rogueweapon/sword/long/death
				beltl = /obj/item/rogueweapon/scabbard/sword
				backl = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Master Spearman")
				r_hand = /obj/item/rogueweapon/spear/death
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("Master Cleaver")
				beltl = /obj/item/rogueweapon/stoneaxe/battle
				backl = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
			if("Master Bludgeoner")
				beltl = /obj/item/rogueweapon/mace/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/riding, SKILL_LEVEL_EXPERT, TRUE)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_INT, 1)

/datum/outfit/job/roguetown/bandit_leader/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/bandit()
		H.mind.add_antag_datum(new_antag)
		H.grant_language(/datum/language/thievescant)
		H.choose_name_popup("BANDIT LEADER")
		//The leader of the camp is always well and truly wanted, no matter what.
		ADD_TRAIT(H, TRAIT_KNOWNCRIMINAL, TRAIT_GENERIC)
		var/race = H.dna.species
		var/gender = H.gender
		var/list/d_list = H.get_mob_descriptors()
		var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
		var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
		var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
		var/my_crime = input(H, "What is your crime?", "Crime") as text|null
		if(!my_crime)
			my_crime = "Leading a band of Brigands"
		add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, rand(500, 700), TRUE, my_crime, "The Justiciary of [SSmapping.map_adjustment.realm_name]")
		to_chat(H, span_danger("You are playing an Antagonist role. By choosing to spawn as the Bandit Leader, you are expected to actively create conflict with other players regardless of bounty status. Failing to play this role with the appropriate gravitas may result in punishment for Low Roleplay standards."))
