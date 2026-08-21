GLOBAL_LIST_EMPTY(billagerspawns)

GLOBAL_VAR_INIT(adventurer_hugbox_duration, 40 SECONDS)
GLOBAL_VAR_INIT(adventurer_hugbox_duration_still, 3 MINUTES)

/datum/job/roguetown/adventurer
	title = "Drifter"
	flag = ADVENTURER
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 20
	spawn_positions = 20
	allowed_races = RACES_ALL_KINDS
	tutorial = "A drifter is claimed by no hall and remembered by no hearth. You wander because standing still never suited you, carrying old trades, old sins, and old dreams from one road to the next while the realm decides what use it has for you."
	class_categories = TRUE

	outfit = null
	outfit_female = null

	display_order = JDO_ADVENTURER
	show_in_credits = FALSE
	min_pq = 0
	max_pq = null

	advclass_cat_rolls = list(CTAG_ADVENTURER = 20)
	PQ_boost_divider = 10

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = TRUE
	same_job_respawn_delay = 1 MINUTES

	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	job_traits = list(TRAIT_OUTLANDER)

	job_subclasses = list(
		/datum/advclass/drifter/busker,
		/datum/advclass/drifter/minstrel,
		/datum/advclass/drifter/trader,
		/datum/advclass/drifter/charlatan,
		/datum/advclass/drifter/wasteoflife,
		/datum/advclass/drifter/bogwalker,
		/datum/advclass/drifter/disgracedknight,
		/datum/advclass/drifter/boggard_deserter,
		/datum/advclass/drifter/town_watch_deserter,
		/datum/advclass/drifter/manatarms_deserter,
		/datum/advclass/drifter/prophet,
		/datum/advclass/drifter/clad_scavenger,
		/datum/advclass/drifter/lost_old_glory,
		/datum/advclass/drifter/claimant,
		/datum/advclass/drifter/fanatic,
		/datum/advclass/drifter/ancestry/kuldjargh,
		/datum/advclass/drifter/ancestry/miner_knight,
		/datum/advclass/drifter/ancestry/witch,
		/datum/advclass/drifter/ancestry/shaman,
		/datum/advclass/drifter/ancestry/goblin_knight,
		/datum/advclass/drifter/ancestry/steppeman,
		/datum/advclass/drifter/ancestry/dweller,
		/datum/advclass/drifter/ancestry/amazon,
		/datum/advclass/drifter/ancestry/maneater,
	)

/mob/living/carbon/human/proc/adv_hugboxing_start()
	to_chat(src, span_warning("I will be in danger once I start moving."))
	status_flags |= GODMODE
	ADD_TRAIT(src, TRAIT_PACIFISM, HUGBOX_TRAIT)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(adv_hugboxing_moved))
	//Lies, it goes away even if you don't move after enough time
	if(GLOB.adventurer_hugbox_duration_still)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_end)), GLOB.adventurer_hugbox_duration_still)

/mob/living/carbon/human/proc/adv_hugboxing_moved()
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	to_chat(src, span_danger("I have [DisplayTimeText(GLOB.adventurer_hugbox_duration)] to begone!"))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_end)), GLOB.adventurer_hugbox_duration)

/mob/living/carbon/human/proc/adv_hugboxing_end()
	if(QDELETED(src))
		return
	//hugbox already ended
	if(!(status_flags & GODMODE))
		return
	status_flags &= ~GODMODE
	REMOVE_TRAIT(src, TRAIT_PACIFISM, HUGBOX_TRAIT)
	to_chat(src, span_danger("My joy is gone! Danger surrounds me."))
