/datum/round_event_control/antagonist/solo/bandits
	name = "Bandits"
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
		TAG_LOOT
	)
	roundstart = TRUE
	antag_flag = ROLE_BANDIT
	max_occurrences = 0
	shared_occurence_type = SHARED_MINOR_THREAT

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES
	base_antags = 5
	maximum_antags = 10

	earliest_start = 0 SECONDS

	weight = 18

	typepath = /datum/round_event/antagonist/solo/bandits
	antag_datum = /datum/antagonist/bandit

/datum/round_event/antagonist/solo/bandits
	var/leader = FALSE

/datum/round_event/antagonist/solo/bandits/start()
	var/datum/job/leader_job = SSjob.GetJob("Bandit Leader")
	var/datum/job/specialist_job = SSjob.GetJob("Bandit Specialist")
	var/datum/job/rabble_job = SSjob.GetJob("Bandit Rabble")

	// Cache the specialist job's configured slot count before we start mutating
	// total_positions below, so it stays the single source of truth for the cap.
	var/max_specialists = initial(specialist_job.total_positions)

	var/leader_count = 0
	var/specialist_count = 0
	var/rabble_count = 0
	SSmapping.retainer.bandit_goal = rand(200,400) + (length(setup_minds) * rand(200,400))
	for(var/datum/mind/antag_mind as anything in setup_minds)
		var/datum/job/J = SSjob.GetJob(antag_mind.current?.job)
		J?.current_positions = max(J?.current_positions-1, 0)
		antag_mind.current.unequip_everything()
		SSjob.AssignRole(antag_mind.current, "Bandit")
		var/assigned_title
		if(!leader_count)
			assigned_title = "Bandit Leader"
			leader_count++
		else if(specialist_count < max_specialists)
			assigned_title = "Bandit Specialist"
			specialist_count++
		else
			assigned_title = "Bandit Rabble"
			rabble_count++

		SSjob.AssignRole(antag_mind.current, assigned_title)
		antag_mind.add_antag_datum(/datum/antagonist/bandit)

		if(assigned_title == "Bandit Specialist")
			SSrole_class_handler.setup_class_handler(antag_mind.current, list(CTAG_BANDIT_SPECIALIST = 20))
			antag_mind.current:advsetup = TRUE
			antag_mind.current.hud_used?.set_advclass()

		leader_job.total_positions = leader_count
		leader_job.spawn_positions = leader_count
		specialist_job.total_positions = specialist_count
		specialist_job.spawn_positions = specialist_count
		rabble_job.total_positions = rabble_count
		rabble_job.spawn_positions = rabble_count

	SSrole_class_handler.bandits_in_round = TRUE

/datum/round_event_control/antagonist/solo/bandits/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return
	var/list/candidates = get_candidates()

	if(length(candidates) < 1)
		return FALSE

	return TRUE
