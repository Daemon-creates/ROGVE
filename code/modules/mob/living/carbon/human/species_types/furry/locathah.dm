/mob/living/carbon/human/species/locathah
	race = /datum/species/anthromorphsmall/locathah

/datum/species/anthromorphsmall/locathah
	name = "Locathah"
	id = "locathah"
	desc = "<b>Locathah</b><br>\
	A Verminvolk lineage descended from fish stock. Locathah breathe as easily underwater as on land, \
	and are rarely found far from a river or coastline.<br>\
	(+1 Speed, Waterbreathing Trait)"

	expanded_desc = "A Verminvolk lineage descended from fish stock. Locathah breathe as easily underwater as on land, \
	and are rarely found far from a river or coastline. They keep company with the Sahuagin more often than most, \
	sharing a taste for the sea and its tongues."

	inherent_traits = list(TRAIT_WATERBREATHING)
	racial_trait_choices = list(TRAIT_SEA_DRINKER, TRAIT_NATURALARMOR, TRAIT_LONGSTRIDER)
	languages = list(
		/datum/language/common,
		/datum/language/abyssal,
	)

/datum/species/anthromorphsmall/locathah/check_roundstart_eligible()
	return FALSE

/datum/species/anthromorphsmall/locathah/qualifies_for_rank(rank, list/features)
	return TRUE
