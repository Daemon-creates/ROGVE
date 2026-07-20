// The Bandit "job" is split across three separate roles, defined in this folder:
//  - bandit_leader.dm      ("Bandit Leader"),      1 slot, no subclasses
//  - bandit_specialist.dm  ("Bandit Specialist"),  3 slots, subclasses: Zealot, Armorer, Sawbones
//  - bandit_rabble.dm      ("Bandit Rabble"),      6 slots, no subclasses
// This file just holds the procs shared between all three of them.
// Also there's like THREE bandit.dms now I'm so sorry. This one is latejoin bandits, the one in villain is the antag datum, and the one in the 'antag' folder is an old adventurer class we don't use. Good luck!

// Changed up proc from Wretch to suit bandits bit more
/proc/bandit_select_bounty(mob/living/carbon/human/H)
	var/wanted = list("Yes", "No")
	var/wanted_choice = input(H, "Are you wanted by the kingdom?", "You will be more skilled from your experience") as anything in wanted
	switch(wanted_choice)
		if("Yes")
			ADD_TRAIT(H, TRAIT_KNOWNCRIMINAL, TRAIT_GENERIC)
		if("No")
			to_chat(H, span_warning("I am still relatively new to the gang. My crimes have gone unnoticed so far, but I lack experience."))
			return null
	var/bounty_poster = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in list("The Justiciary of [SSmapping.map_adjustment.realm_name]", "The Grenzelhoftian Holy See")
	var/bounty_severity = input(H, "How notorious are you?", "Bounty Amount") as anything in list("Small Game", "Highwayman", "Realm Boogeyman")
	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	var/bounty_total = rand(200, 600)
	var/my_crime = input(H, "What is your crime?", "Crime") as text|null
	if (!my_crime)
		my_crime = "Brigandry"
	switch(bounty_severity)
		if("Small Game")
			bounty_total = rand(200, 300)
		if("Highwayman")
			bounty_total = rand(300, 400)
		if("Vale Boogeyman")
			bounty_total = rand(500, 600)
	if(bounty_severity == "Small Game")
		add_bounty_obscure(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, TRUE, my_crime, bounty_poster)
	else if(bounty_severity == "Highwayman")
		add_bounty_noface(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, TRUE, my_crime, bounty_poster)
	else
		add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, TRUE, my_crime, bounty_poster)
		var/skillbuff = input(H, "Your experience grants you a boon", "Choose An Attribute") as anything in list("Strength", "Perception", "Intelligence", "Constitution", "Willpower", "Speed")
		switch(skillbuff)
			if("Strength")
				H.change_stat(STATKEY_STR, 1)
			if("Perception")
				H.change_stat(STATKEY_PER, 1)
			if("Intelligence")
				H.change_stat(STATKEY_INT, 1)
			if("Constitution")
				H.change_stat(STATKEY_CON, 1)
			if("Willpower")
				H.change_stat(STATKEY_WIL, 1)
			if("Speed")
				H.change_stat(STATKEY_SPD, 1)
	to_chat(H, span_danger("You are playing an Antagonist role. By choosing to spawn as a Bandit, you are expected to actively create conflict with other players regardless of bounty status. Failing to play this role with the appropriate gravitas may result in punishment for Low Roleplay standards."))

// Only the Rabble slots scale with the round's population. The Leader (1) and Specialist (3) slot counts stay fixed.
/proc/update_bandit_slots()
	var/datum/job/rabble_job = SSjob.GetJob("Bandit Rabble")
	if(!rabble_job)
		return

	var/player_count = length(GLOB.joined_player_list)
	var/slots = 6

	//Add 1 slot for every 12 players over 42.
	if(player_count > 42)
		var/extra = floor((player_count - 42) / 12)
		slots += extra

	//6 slots minimum, 10 maximum.
	slots = min(slots, 10)

	rabble_job.total_positions = slots
	rabble_job.spawn_positions = slots
