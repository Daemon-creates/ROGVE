// Dough, and variants thereof for usage in making various baked food items.
// Doesn't include raw variants of bread and others
/*	.................   Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/dough_base
	name = "unfinished dough"
	desc = "With a little more ambition, you will conquer."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi' // I know but we are following Raw as a pre-pender
	icon_state = "dough_base"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/dough_base/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	// Raw dough overhaul (Section 3 Step "add another powder"): any powder
	// finishes the dough, not just flour specifically.
	if(istype(I, /obj/item/reagent_containers/powder))
		var/obj/item/reagent_containers/powder/P = I
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Kneading in more powder..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				var/obj/item/reagent_containers/food/snacks/rogue/dough/D = new(loc)
				// Blend forward the dough's existing color (white + reagent
				// + first powder, from the wetting step) with this second
				// powder's own color.
				D.color = BlendRGB(color || "#FFFFFF", P.color || "#FFFFFF", 0.5)
				D.inherit_provenance_ledger(src)
				D.record_provenance_from(P)
				if(P.reagents)
					P.reagents.trans_to(D, P.reagents.total_volume)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/dough
	name = "dough"
	desc = "The triumph of all bakers."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "dough"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE
	/// Raw dough overhaul: how far along the rise/knead/rise cycle this
	/// dough is. See the DOUGH_* defines in code/__DEFINES/food.dm.
	var/rise_stage = DOUGH_UNRISEN
	/// How much of a quality bonus rising has earned this dough so far.
	/// Carried into the baked loaf's nutrition, see heating_act() below.
	var/dough_quality = 0
	var/rise_timer_id

/obj/item/reagent_containers/food/snacks/rogue/dough/Initialize(mapload)
	. = ..()
	start_rise_timer()

/obj/item/reagent_containers/food/snacks/rogue/dough/Destroy()
	deltimer(rise_timer_id)
	return ..()

/**
 * Raw dough overhaul: dough left alone (on a table, in a bowl, in a pack)
 * rises on its own over time, exactly like drying/curing on the rack -
 * nobody has to stand there kneading it for the whole rise. Once risen it
 * waits for the player to knead it again before it can rise a second time.
 */
/obj/item/reagent_containers/food/snacks/rogue/dough/proc/start_rise_timer()
	deltimer(rise_timer_id)
	rise_timer_id = addtimer(CALLBACK(src, PROC_REF(finish_rise)), game_minutes2deciseconds(DOUGH_RISE_GAME_MINUTES), TIMER_STOPPABLE)

/obj/item/reagent_containers/food/snacks/rogue/dough/proc/finish_rise()
	if(QDELETED(src))
		return
	if(rise_stage != DOUGH_UNRISEN && rise_stage != DOUGH_KNEADED_AGAIN)
		return
	dough_quality = min(dough_quality + 1, 2)
	if(rise_stage == DOUGH_UNRISEN)
		rise_stage = DOUGH_RISEN_ONCE
		name = "risen dough"
		desc = "The dough has puffed up nicely, resting before it's worked again."
	else
		rise_stage = DOUGH_RISEN_TWICE
		name = "twice-risen dough"
		desc = "The dough has doubled over again, fully proofed and ready to bake."

/// Raw dough overhaul: punching the risen dough down and kneading it again lets it rise a second time, for a further quality bonus.
/obj/item/reagent_containers/food/snacks/rogue/dough/attack_hand(mob/living/user)
	if(rise_stage == DOUGH_RISEN_ONCE)
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
		to_chat(user, span_notice("Kneading the risen dough back down..."))
		if(do_after(user, short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			rise_stage = DOUGH_KNEADED_AGAIN
			name = "kneaded dough"
			desc = "Punched down and ready to rise once more."
			start_rise_timer()
		return
	return ..()

/obj/item/reagent_containers/food/snacks/rogue/dough/heating_act(atom/A)
	. = ..()
	if(istype(., /obj/item/reagent_containers/food/snacks/rogue/bread) && dough_quality)
		var/obj/item/reagent_containers/food/snacks/rogue/bread/B = .
		B.dough_quality = dough_quality
		if(B.reagents)
			B.reagents.add_reagent(/datum/reagent/consumable/nutriment, dough_quality * 2)

/obj/item/reagent_containers/food/snacks/rogue/dough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("Kneading butter into the dough..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/butterdough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Kneading the dough and adding raisins..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				var/obj/item/reagent_containers/food/snacks/rogue/rbread_half/half = new(loc)
				if(I.provenance)
					half.record_provenance_from(I)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/butterdough))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Kneading the dough into an elongated shape..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strudeldough(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Rolling [src] into cracker dough."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	else if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/butterdough))

		return
	else

		var/obj/item/reagent_containers/food/snacks/mixin = I
		if(!istype(mixin))
			return ..()
		if(isturf(loc) && found_table)
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Kneading [mixin] into the dough..."))

			var/datum/skill/craft/cooking/cs = user?.get_skill_level(/datum/skill/craft/cooking)
			var/mixin_time = game_minutes2deciseconds(GENERIC_MIXIN_GAME_MINUTES) / get_cooktime_divisor(cs)
			if(do_after(user, mixin_time, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				add_provenance_source(mixin, suffix = "dough", base_desc = initial(desc))
				if(mixin.reagents)
					mixin.reagents.trans_to(src, mixin.reagents.total_volume)
				qdel(mixin)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))

/*	.................   Smalldough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/doughslice
	name = "smalldough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "doughslice"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bun
	cooked_smell = /datum/pollutant/food/bun
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("dough" = 1)

/obj/item/reagent_containers/food/snacks/rogue/doughslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("Adding fresh cheese..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesebun_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/doughslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Combining dough..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/dough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/astrata))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("Pressing the shape of Astrata's cross into the bun..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/crossbun_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross)) // This is gonna be messy cuz other are subtypes
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("Pressing the shape of the psycross into the bun..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/psycrossbun_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/dough))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Kneading the dough into an elongated shape..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strudeldough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	else
		return ..()

/*	.................   Butterdough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdough
	name = "butterdough"
	desc = "What is a triumph, to a legacy?"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough"
	color = "#feffc1"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin
	cooked_smell = /datum/pollutant/food/muffin
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/butterdough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Working egg into the dough, shaping it into a cake..."))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/cake_base(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	else
		return ..()

/*	.................   Butterdough piece   ................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	name = "butterdough piece"
	desc = "A slice of pedigree, to create lines of history."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdoughslice"
	color = "#feffc1"
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/frybread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pastry
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL

// Dough + rolling pin on table = flat dough. RT got some similar proc for this.
/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Flattening [src]..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/piedough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Adding raisins to the dough..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/biscuit_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	if(I.get_sharpness())
		if(!isdwarf(user))
			to_chat(user, span_warning("You lack knowledge of dwarven pastries!"))
			return
		else
			if(isturf(loc)&& (found_table))
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
				to_chat(user, span_notice("Cutting the dough in strips and making a prezzel..."))
				if(do_after(user,short_cooktime, target = src))
					add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
					new /obj/item/reagent_containers/food/snacks/rogue/foodbase/prezzel_raw(loc)
					qdel(src)
			else
				to_chat(user, span_warning("You need to put [src] on a table to cut it!"))
	else
		..()

/*	.................   Piedough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/piedough
	name = "piedough"
	desc = "The beginning of greater things to come."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "piedough"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	cooked_smell = /datum/pollutant/food/pie_base
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/piedough/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/truffles))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/mushroom)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/fish)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/meat)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/crab))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/crab)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/poison)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/berry)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/apple)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/potato)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced))//This produces 3 instead of 2 so it'd be obvious go to.
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/cabbage)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/piedough/proc/prepare_handpie(obj/item/I, mob/living/user, handpie_path)
	playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	to_chat(user, span_notice("Making a handpie..."))
	if(do_after(user,short_cooktime, target = src))
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
		var/handpie = new handpie_path(get_turf(user))
		user.put_in_hands(handpie)
		qdel(I)
		qdel(src)

/*	.................   Strudel Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/strudeldough
	name = "strudeldough"
	desc = "An empty shell of a greatness to come."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "strudel_raw"
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE
	process_step = 1

/obj/item/reagent_containers/food/snacks/rogue/strudeldough/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Filling the dough with apples.."))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "half-filled strudel"
			desc = "A strudel form mostly filled with apples. Still missing it's other part."
			process_step = 2
			record_provenance_from(I)
			qdel(I)
			return
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/nut))
		if(process_step != 2)
			return
		to_chat(user, span_notice("Finishing the filling with rocknut.."))
		if(do_after(user, short_cooktime, target = src))
			name = "filled strudel"
			desc = "A strudel filled to the brim with apples and nuts. Now to only bake it."
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/strudel
			process_step = 3
			record_provenance_from(I)
			qdel(I)
			return
	else if(istype(I, /obj/item/reagent_containers/food/snacks))
		if(process_step == 1)
			to_chat(user, span_notice("Filling the dough with [I].."))
			if(do_after(user, short_cooktime, target = src))
				playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
				name = "half-filled strudel"
				desc = "A strudel form mostly filled with ingredients. Still missing it's other part."
				process_step = 2
				record_provenance_from(I)
				qdel(I)
				return
		else if(process_step == 2)
			to_chat(user, span_notice("Finishing the filling with [I].."))
			if(do_after(user, short_cooktime, target = src))
				name = "filled strudel"
				desc = "A strudel filled to the brim with mixed ingredients. Now to only bake it."
				cooked_type = /obj/item/reagent_containers/food/snacks/rogue/strudel/generic
				process_step = 3
				record_provenance_from(I)
				qdel(I)
				return
		return
	else
		return ..()
