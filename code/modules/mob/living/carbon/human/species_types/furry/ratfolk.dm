/mob/living/carbon/human/species/ratfolk
	race = /datum/species/anthromorphsmall/ratfolk

/datum/species/anthromorphsmall/ratfolk
	name = "Ratfolk"
	id = "ratfolk"
	desc = "<b>Ratfolk</b><br>\
	A Verminvolk lineage descended from rodent stock. Ratfolk are quick, resourceful, and able to \
	stomach food that would sicken most other people.<br>\
	(+1 Speed, Keen Ears Trait)"

	expanded_desc = "A Verminvolk lineage descended from rodent stock. Ratfolk are quick, resourceful, and able to \
	stomach food that would sicken most other people. They are found scurrying through every corner of civilization, \
	rarely turning down an opportunity for coin or a meal."

	inherent_traits = list(TRAIT_KEENEARS)
	racial_trait_choices = list(TRAIT_TOXIN_RESIST, TRAIT_CLIMBER, TRAIT_WILD_EATER)
	languages = list(
		/datum/language/common,
		/datum/language/beast,
	)

/datum/species/anthromorphsmall/ratfolk/check_roundstart_eligible()
	return FALSE

/datum/species/anthromorphsmall/ratfolk/qualifies_for_rank(rank, list/features)
	return TRUE
