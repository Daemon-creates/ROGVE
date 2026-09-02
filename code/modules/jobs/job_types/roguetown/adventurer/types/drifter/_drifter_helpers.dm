/// Shared helper items and procs for the Drifter subclass expansion.
/obj/item/roguegem/drifter_fake
	name = "flawless relic gem"
	desc = "A polished bauble sold with far more confidence than honesty."
	sellprice = 0

/obj/item/reagent_containers/glass/bottle/rogue/water/drifter_giants_strength
	name = "Potion of Giant's Strength"
	desc = "A watery brew loudly promised to put steel into the drinker's muscles."

/obj/item/reagent_containers/glass/bottle/rogue/water/drifter_heroic_vigor
	name = "Elixir of Heroic Vigor"
	desc = "An overhyped tonic that tastes faintly of wet cork."

/obj/item/reagent_containers/glass/bottle/rogue/water/drifter_mindfire
	name = "Mindfire Draught"
	desc = "A dramatic-looking bottle whose contents are mostly fit for washing dust from the throat."

/obj/item/clothing/ring/gold/drifter_fake_relic
	name = "sun-saint finger reliquary"
	desc = "A gaudy ring passed off as a saintly relic to the gullible and desperate alike."

/obj/item/clothing/ring/silver/drifter_fake_relic
	name = "moon-martyr reliquary"
	desc = "A tarnished trinket with an impressive story and no holy provenance whatsoever."

/obj/item/paper/scroll/drifter_succession_claim
	name = "Notarized Succession Claim"
	info = "<b>To all persons of consequence:</b><br><br>This parchment attests that the bearer presents a lawful claim to a throne lost by exile, intrigue, or blood. Whether that claim would survive sober inspection is left to the courts of God and man."

/// Returns a player-selected instrument path while mirroring existing adventurer instrument menus.
/proc/drifter_pick_instrument(mob/living/carbon/human/H, prompt = "Choose your instrument.")
	if(!H)
		return /obj/item/rogue/instrument/lute
	var/list/instruments = list("Accordion","Bagpipe","Banjo","Drum","Flute","Guitar","Harmonica","Harp","Hurdy-Gurdy","Jaw Harp","Lute","Psyaltery","Shamisen","Trumpet","Viola","Vocal Talisman")
	var/choice = tgui_input_list(H, prompt, "TAKE UP ARMS", instruments)
	H.set_blindness(0)
	switch(choice)
		if("Accordion")
			return /obj/item/rogue/instrument/accord
		if("Bagpipe")
			return /obj/item/rogue/instrument/bagpipe
		if("Banjo")
			return /obj/item/rogue/instrument/banjo
		if("Drum")
			return /obj/item/rogue/instrument/drum
		if("Flute")
			return /obj/item/rogue/instrument/flute
		if("Guitar")
			return /obj/item/rogue/instrument/guitar
		if("Harmonica")
			return /obj/item/rogue/instrument/harmonica
		if("Harp")
			return /obj/item/rogue/instrument/harp
		if("Hurdy-Gurdy")
			return /obj/item/rogue/instrument/hurdygurdy
		if("Jaw Harp")
			return /obj/item/rogue/instrument/jawharp
		if("Lute")
			return /obj/item/rogue/instrument/lute
		if("Psyaltery")
			return /obj/item/rogue/instrument/psyaltery
		if("Shamisen")
			return /obj/item/rogue/instrument/shamisen
		if("Trumpet")
			return /obj/item/rogue/instrument/trumpet
		if("Viola")
			return /obj/item/rogue/instrument/viola
		if("Vocal Talisman")
			return /obj/item/rogue/instrument/vocals
	return /obj/item/rogue/instrument/lute

/// Picks the closest existing holy symbol for the wearer's patron.
/proc/drifter_patron_symbol(mob/living/carbon/human/H)
	if(!H)
		return /obj/item/clothing/neck/roguetown/psicross/wood
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			return /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			return /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			return /obj/item/clothing/neck/roguetown/psicross/astrata
		if(/datum/patron/divine/noc)
			return /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			return /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			return /obj/item/clothing/neck/roguetown/psicross/dendor
		if(/datum/patron/divine/necra)
			return /obj/item/clothing/neck/roguetown/psicross/necra
		if(/datum/patron/divine/pestra)
			return /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			return /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			return /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			return /obj/item/clothing/neck/roguetown/psicross/eora
		if(/datum/patron/divine/xylix)
			return /obj/item/clothing/neck/roguetown/psicross/xylix
		if(/datum/patron/inhumen/matthios)
			return /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
		if(/datum/patron/inhumen/graggar)
			return /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
		if(/datum/patron/inhumen/baotha)
			return /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
		if(/datum/patron/inhumen/zizo)
			return /obj/item/clothing/neck/roguetown/psicross/inhumen
	return /obj/item/clothing/neck/roguetown/psicross/wood

/// Creates a flat bounty using the same descriptor gathering pattern as other outlaw roles.
/proc/drifter_add_flat_bounty(mob/living/carbon/human/H, amount, reason, employer_name, bandit_status = FALSE)
	if(!H || !H.real_name)
		return
	var/datum/species/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, amount, bandit_status, reason, employer_name)

/// Delayed bounty helper that safely resolves a weakref before trying to post.
/proc/drifter_add_delayed_bounty(datum/weakref/human_ref, amount, reason, employer_name, bandit_status = FALSE)
	var/mob/living/carbon/human/H = human_ref?.resolve()
	if(!H || QDELETED(H))
		return
	drifter_add_flat_bounty(H, amount, reason, employer_name, bandit_status)

/// Gives one random spell from a small, representative multi-tier arcane pool.
/proc/drifter_grant_random_spell(mob/living/carbon/human/H)
	if(!H?.mind)
		return
	var/list/spell_pool = list(
		/obj/effect/proc_holder/spell/invoked/guidance,
		/obj/effect/proc_holder/spell/invoked/longstrider,
		/obj/effect/proc_holder/spell/invoked/stoneskin,
		/obj/effect/proc_holder/spell/invoked/knock,
		/obj/effect/proc_holder/spell/invoked/projectile/ice_shard,
		/obj/effect/proc_holder/spell/invoked/aerosolize,
	)
	var/spell_path = pick(spell_pool)
	H.mind.AddSpell(new spell_path)

/// Gives one random miracle from a patron-agnostic pool that spans several miracle power tiers.
/proc/drifter_grant_random_miracle(mob/living/carbon/human/H)
	if(!H?.mind)
		return
	var/list/miracle_pool = list(
		/obj/effect/proc_holder/spell/invoked/lesser_heal,
		/obj/effect/proc_holder/spell/invoked/heal,
		/obj/effect/proc_holder/spell/invoked/convergence,
		/obj/effect/proc_holder/spell/invoked/stasis,
		/obj/effect/proc_holder/spell/invoked/wound_heal,
		/obj/effect/proc_holder/spell/invoked/blood_heal,
	)
	var/miracle_path = pick(miracle_pool)
	H.mind.AddSpell(new miracle_path)

/// Scuffs a veteran's gear down to almost nothing in a deliberately broad, wearable-only pass.
/proc/drifter_ruin_worn_armor(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/obj/item/I in H.get_equipped_items(TRUE))
		if(!istype(I, /obj/item/clothing))
			continue
		if(!I.max_integrity)
			continue
		if(prob(50))
			I.obj_integrity = 1

