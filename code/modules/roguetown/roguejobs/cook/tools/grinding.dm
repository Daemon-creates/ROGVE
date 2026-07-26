#define BASE_GRIND_TIME 1 SECONDS
/obj/item/millstone // Previous structure path means it cannot be crafted on tables
	name = "millstone"
	desc = "A millstone used to grind grain into flour."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "millstone"
	density = FALSE
	anchored = FALSE
	blade_dulling = DULLING_BASH
	max_integrity = 400
	var/list/obj/item/to_grind = list()

/obj/item/millstone/attackby(obj/item/W, mob/living/user, params)
	var/datum/skill/craft/cooking/cs = user?.get_skill_level(/datum/skill/craft/cooking)
	if(W.mill_result)
		var/scaled_grind_time = BASE_GRIND_TIME / get_cooktime_divisor(cs)
		if(do_after(user, scaled_grind_time, target = src))
			new W.mill_result(get_turf(loc))
			qdel(W)
		return

	if(try_slap_craft_process(user, W, src, CAN_GRIND, GENERIC_GRIND_GAME_MINUTES, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(create_provenance_flour)), "grinding"))
		return
	..()

#undef BASE_GRIND_TIME
