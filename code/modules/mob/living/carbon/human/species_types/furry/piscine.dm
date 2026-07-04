/mob/living/carbon/human/species/piscine
	race = /datum/species/akula/piscine

/datum/species/akula/piscine
	name = "Piscine"
	id = "piscine"
	desc = "<b>Piscine</b><br>\
	A Sahuagin lineage descended from ordinary fish stock. Piscine are lean and quick in the water, \
	but never quite took to the old tongue of the deep the way their Sharkfolk kin did.<br>\
	(+1 Constitution, +1 Willpower, Waterbreathing)"

	expanded_desc = "A Sahuagin lineage descended from ordinary fish stock. Piscine are lean and quick in the water, \
	but never quite took to the old tongue of the deep the way their Sharkfolk kin did. What they lack in the \
	Abyssal tongue, they make up for in speed and evasiveness."

	inherent_traits = list(TRAIT_WATERBREATHING)
	racial_trait_choices = list(TRAIT_LONGSTRIDER, TRAIT_EVASIVE, TRAIT_KEEN_EYED)
	languages = list(
		/datum/language/common,
	)

/datum/species/akula/piscine/check_roundstart_eligible()
	return FALSE

/datum/species/akula/piscine/qualifies_for_rank(rank, list/features)
	return TRUE
