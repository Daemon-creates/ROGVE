/mob/living/carbon/human/species/grung
	race = /datum/species/anthromorphsmall/grung

/datum/species/anthromorphsmall/grung
	name = "Grung"
	id = "grung"
	desc = "<b>Grung</b><br>\
	A Verminvolk lineage descended from toad stock. Grung secrete a mild toxin through their skin, \
	rendering them resistant to poisons that would fell most others.<br>\
	(+1 Speed, Toxin Resistance Trait)"

	expanded_desc = "A Verminvolk lineage descended from toad stock. Grung secrete a mild toxin through their skin, \
	rendering them resistant to poisons that would fell most others. They favour damp, hidden places and are \
	rarely seen far from water."

	inherent_traits = list(TRAIT_TOXIN_RESIST)
	racial_trait_choices = list(TRAIT_VENOMOUS, TRAIT_CLIMBER, TRAIT_CALTROPIMMUNE)
	languages = list(
		/datum/language/common,
		/datum/language/beast,
	)

/datum/species/anthromorphsmall/grung/check_roundstart_eligible()
	return FALSE

/datum/species/anthromorphsmall/grung/qualifies_for_rank(rank, list/features)
	return TRUE
