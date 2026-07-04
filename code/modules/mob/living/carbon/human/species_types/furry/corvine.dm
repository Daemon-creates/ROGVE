/mob/living/carbon/human/species/corvine
	race = /datum/species/anthromorphsmall/corvine

/datum/species/anthromorphsmall/corvine
	name = "Corvine"
	id = "corvine"
	desc = "<b>Corvine</b><br>\
	A Verminvolk lineage descended from crow and raven stock. Corvine are sharp-eyed and quick-witted, \
	rarely missing a glint of coin or a face they've seen before.<br>\
	(+1 Speed, Eagle Eye Trait)"

	expanded_desc = "A Verminvolk lineage descended from crow and raven stock. Corvine are sharp-eyed and quick-witted, \
	rarely missing a glint of coin or a face they've seen before. Their memory for grudges and debts alike is infamous."

	inherent_traits = list(TRAIT_EAGLE_EYE)
	racial_trait_choices = list(TRAIT_SHARP_EARED, TRAIT_ATHLETE, TRAIT_LONGSTRIDER)
	languages = list(
		/datum/language/common,
	)

/datum/species/anthromorphsmall/corvine/check_roundstart_eligible()
	return FALSE

/datum/species/anthromorphsmall/corvine/qualifies_for_rank(rank, list/features)
	return TRUE
