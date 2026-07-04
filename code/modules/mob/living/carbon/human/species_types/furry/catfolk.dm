/mob/living/carbon/human/species/catfolk
	race = /datum/species/anthromorphsmall/catfolk

/datum/species/anthromorphsmall/catfolk
	name = "Catfolk"
	id = "catfolk"
	desc = "<b>Catfolk</b><br>\
	A Verminvolk lineage descended from feline stock. Catfolk are light on their feet and quieter still, \
	preferring to let others stumble into trouble first.<br>\
	(+1 Speed, Light Steps Trait)"

	expanded_desc = "A Verminvolk lineage descended from feline stock. Catfolk are light on their feet and quieter still, \
	preferring to let others stumble into trouble first. Distant kin to the desert-born Tabaxi, though considerably \
	smaller and just as proud of it."

	inherent_traits = list(TRAIT_LIGHT_STEP)
	racial_trait_choices = list(TRAIT_CLIMBER, TRAIT_KEEN_EYED, TRAIT_EVASIVE)
	languages = list(
		/datum/language/common,
		/datum/language/merar,
	)

/datum/species/anthromorphsmall/catfolk/check_roundstart_eligible()
	return FALSE

/datum/species/anthromorphsmall/catfolk/qualifies_for_rank(rank, list/features)
	return TRUE
