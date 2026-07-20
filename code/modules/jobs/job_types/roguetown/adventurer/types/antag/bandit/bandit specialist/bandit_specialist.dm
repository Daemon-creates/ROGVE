/datum/job/roguetown/bandit_specialist
	title = "Bandit Specialist"
	flag = BANDIT
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	antag_job = TRUE
	allowed_races = RACES_ALL_KINDS
	tutorial = "You bring a trade to the camp that the rank and file can't match - be it faith, steel, or salves. \
	The rabble follow the Leader's word, but they come to you when they need something only a specialist can provide."

	outfit = null
	outfit_female = null

	obsfuscated_job = TRUE

	display_order = JDO_BANDIT
	announce_latejoin = FALSE
	min_pq = 0
	max_pq = null
	round_contrib_points = 5
	allowed_patrons = list(/datum/patron/inhumen/matthios) // Bandits bro, they rob you blind

	advclass_cat_rolls = list(CTAG_BANDIT = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE //no endless stream of bandits, unless the migration waves deem it so
	job_traits = list(TRAIT_SELF_SUSTENANCE, TRAIT_DEATHBYSNUSNU, TRAIT_STEELHEARTED)
	same_job_respawn_delay = 1 MINUTES
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	job_subclasses = list(
		/datum/advclass/bandit_specialist/zealot,
		/datum/advclass/bandit_specialist/armorer,
		/datum/advclass/bandit_specialist/sawbones,
	)

/datum/job/roguetown/bandit_specialist/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		H.ambushable = FALSE

/datum/outfit/job/roguetown/bandit_specialist/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting

/datum/outfit/job/roguetown/bandit_specialist/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/bandit()
		H.mind.add_antag_datum(new_antag)
		H.grant_language(/datum/language/thievescant)
		H.choose_name_popup("BANDIT")
		bandit_select_bounty(H)
