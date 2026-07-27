// -------------- RAISINS -----------------
/obj/item/reagent_containers/food/snacks/rogue/raisins
	name = "raisins"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "raisins5"
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried fruit" = 1)
	faretype = FARE_POOR
	foodtype = GRAIN
	eat_effect = null
	rotprocess = null
	food_process_tags = CAN_GRIND | CAN_PICKLE | CAN_CANDY

/obj/item/reagent_containers/food/snacks/rogue/raisins/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "raisins4"
	if(bitecount == 2)
		icon_state = "raisins3"
	if(bitecount == 3)
		icon_state = "raisins2"
	if(bitecount == 4)
		icon_state = "raisins1"

/obj/item/reagent_containers/food/snacks/rogue/raisins/CheckParts(list/parts_list, datum/crafting_recipe/R)
	..()
	for(var/obj/item/reagent_containers/food/snacks/M in parts_list)
		color = M.filling_color
		if(M.reagents)
			M.reagents.remove_reagent(/datum/reagent/consumable/nutriment, M.reagents.total_volume)
			M.reagents.trans_to(src, M.reagents.total_volume)
		qdel(M)

/obj/item/reagent_containers/food/snacks/rogue/raisins/generic
	name = "raisins"
	desc = "Fruit that has been dried for preservation."

/proc/create_provenance_dried_fruit(obj/item/reagent_containers/food/snacks/source, atom/location)
	var/obj/item/reagent_containers/food/snacks/rogue/raisins/generic/D = new(location)
	D.apply_provenance_from(source, suffix = "raisins", base_desc = D.desc)
	if(source.filling_color)
		D.color = source.filling_color
	if(source.reagents)
		source.reagents.trans_to(D, source.reagents.total_volume)
	return D

/obj/item/reagent_containers/food/snacks/rogue/driedveg
	name = "dry vegetable"
	desc = "A vegetable, dried out on a rack for preservation."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "turnip"
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried vegetable" = 1)
	faretype = FARE_POOR
	foodtype = VEGETABLES
	eat_effect = null
	rotprocess = null
	food_process_tags = CAN_GRIND | CAN_PICKLE | CAN_CANDY


/proc/create_provenance_dry_vegetable(obj/item/reagent_containers/food/snacks/source, atom/location)
	var/obj/item/reagent_containers/food/snacks/rogue/driedveg/D = new(location)
	D.apply_provenance_from(source, prefix = "dry", base_desc = D.desc)
	if(source.filling_color)
		D.color = source.filling_color
	if(source.reagents)
		source.reagents.trans_to(D, source.reagents.total_volume)
	return D

/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette/dried
	name = "dried meat"
	desc = "Meat, dried out on a rack until tough and long-keeping."
	food_process_tags = CAN_GRIND | CAN_PICKLE | CAN_CANDY

/proc/create_provenance_dried_meat(obj/item/reagent_containers/food/snacks/source, atom/location)
	var/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette/dried/M = new(location)
	M.apply_provenance_from(source, prefix = "dried", base_desc = M.desc)
	if(source.reagents)
		source.reagents.trans_to(M, source.reagents.total_volume)
	return M
/proc/get_generic_dry_generator(obj/item/reagent_containers/food/snacks/ingredient)
	if(ingredient.foodtype & FRUIT)
		return CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(create_provenance_dried_fruit))
	if(ingredient.foodtype & VEGETABLES)
		return CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(create_provenance_dry_vegetable))
	return CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(create_provenance_dried_meat))
