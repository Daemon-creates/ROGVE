
/obj/item/clothing/suit/roguetown/armor/plate/half/baotha
	name = "baothan cuirass"
	desc = "A mighty muscled cuirass. Powerful Baothan Magycks protect the exposed flesh that glints tantalising between plates."
	icon = 'icons/roguetown/clothing/special/baotha.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/baotha.dmi'
	icon_state = "baothachest"
	item_state = "baothachest"
	body_parts_covered = CHEST|VITALS|GROIN
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	// max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	// peel_threshold = 5	//-Any- weapon will require 5 peel hits to peel coverage off of this armor.

// /obj/item/clothing/suit/roguetown/armor/plate/half/baotha/Initialize(mapload)
// 	. = ..()
// 	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

// /obj/item/clothing/suit/roguetown/armor/plate/half/baotha/dropped(mob/living/carbon/human/user)
// 	. = ..()
// 	if(QDELETED(src))
// 		return
// 	qdel(src)

/obj/item/clothing/under/roguetown/platelegs/baotha
	max_integrity = ARMOR_INT_LEG_ANTAG
	name = "baothan leg-plates"
	desc = "Powerful Baothan Magycks protect the exposed flesh that glints tantalising between the plates."
	icon = 'icons/roguetown/clothing/special/baotha.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/baotha.dmi'
	icon_state = "baotha_legs"
	armor = ARMOR_ASCENDANT
	body_parts_covered = LEGS|FEET|GROIN
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PICK)

// /obj/item/clothing/under/roguetown/platelegs/baotha/Initialize(mapload)
// 	. = ..()
// 	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
// 	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "ARMOR")

// /obj/item/clothing/under/roguetown/platelegs/baotha/dropped(mob/living/carbon/human/user)
// 	. = ..()
// 	if(QDELETED(src))
// 		return
// 	qdel(src)

// /obj/item/clothing/under/roguetown/platelegs/baotha/Initialize(mapload)
// 	. = ..()
// 	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP)

/obj/item/clothing/wrists/roguetown/bracers/baotha
	name = "baothan bracers"
	desc = "Gilded bracers that protect the arms and, through powerful Baothan Magic, the hands."
	body_parts_covered = ARMS|HANDS
	icon = 'icons/roguetown/clothing/special/baotha.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/baotha.dmi'
	icon_state = "baothabracers"
	item_state = "baothabracers"
	sleeved = 'icons/roguetown/clothing/special/onmob/baotha.dmi'
	alternate_worn_layer = WRISTS_LAYER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PICK)
	max_integrity = ARMOR_INT_SIDE_ANTAG

/obj/item/clothing/suit/roguetown/armor/leather/studded/baotha
	name = "baothan straps"
	desc = "Black leather wraps tightly around flesh, cold studs digging in, leaving marks."
	icon = 'icons/roguetown/clothing/special/baotha.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/baotha.dmi'
	icon_state = "baothashirt"
	item_state = "baothashirt"
	armor = ARMOR_LEATHER_STUDDED
	sleeved = null
	body_parts_covered =  CHEST | GROIN | VITALS | LEGS | ARMS |NECK | HANDS | FEET
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	armor_class = ARMOR_CLASS_LIGHT
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	cold_protection = CHEST | LEGS | ARMS
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	alternate_worn_layer = PANTS_LAYER+1

/obj/item/clothing/head/roguetown/helmet/heavy/baotha
	name = "helm of desire"
	desc = "Look upon thy beauty and despair"
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT|HIDEHAIR|HIDEFACIALHAIR
	icon = 'icons/roguetown/clothing/special/baotha.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/baotha64.dmi'
	icon_state = "baothahelmet"
	item_state = "baothahelmet"
	bloody_icon = 'icons/effects/blood64.dmi'
	max_integrity = ARMOR_INT_HELMET_ANTAG
	worn_x_dimension = 32
	worn_y_dimension = 48
	bloody_icon = 'icons/effects/blood64.dmi'
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "VISAGE")

// /obj/structure/ritualcircle/baotha/proc/baothaarmor(mob/living/carbon/human/target)
// 	if(!HAS_TRAIT(target, TRAIT_DEPRAVED))
// 		loc.visible_message(span_cult("THE RITE REJECTS ONE NOT OF THE CHANGEME"))
// 		return
// 	target.Stun(60)
// 	target.Knockdown(60)
// 	to_chat(target, span_userdanger("DELECTABLE PAIN!"))
// 	target.emote("Agony")
// 	playsound(loc, 'sound/combat/newstuck.ogg', 50)
// 	if(HAS_TRAIT(target, TRAIT_INFINITE_STAMINA) || (target.mob_biotypes & MOB_UNDEAD))
// 		loc.visible_message(span_cult("Great hooks come from the rune, embedding into [target]'s ankles, pulling them onto the rune. Then, into their wrists. As their black, rotten lux is torn from their chest, the very essence of their body surges to form it into armor. "))
// 		target.Paralyze(120)
// 	else
// 		loc.visible_message(span_cult("Great hooks come from the rune, embedding into [target]'s ankles, pulling them onto the rune. Then, into their wrists. Their lux is torn from their chest, and reforms into armor. "))
// 	spawn(20)
// 		playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
// 		target.equipOutfit(/datum/outfit/job/roguetown/baothaarmor)
// 		target.apply_status_effect(/datum/status_effect/debuff/devitalised)
// 		if(!HAS_TRAIT(target, TRAIT_OVERTHERETIC))
// 			ADD_TRAIT(target, TRAIT_OVERTHERETIC, TRAIT_MIRACLE)
// 		spawn(40)
// 			to_chat(target, span_purple("CHANGEME."))

/datum/outfit/job/roguetown/baothaarmor/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/baotha
	shirt = /obj/item/clothing/suit/roguetown/armor/leather/studded/baotha
	pants = /obj/item/clothing/under/roguetown/platelegs/baotha
	wrists = /obj/item/clothing/wrists/roguetown/bracers/baotha
	head = /obj/item/clothing/head/roguetown/helmet/heavy/baotha
	// backr = CHANGEMEWEAPONGOESHERE
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending/lesser)
