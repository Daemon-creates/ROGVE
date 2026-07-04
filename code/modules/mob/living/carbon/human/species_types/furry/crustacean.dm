/mob/living/carbon/human/species/crustacean
	race = /datum/species/akula/crustacean

/datum/species/akula/crustacean
	name = "Crustacean"
	id = "crustacean"
	desc = "<b>Crustacean</b><br>\
	A Sahuagin lineage descended from crab and lobster stock. Crustacean are thick-shelled and \
	sturdy, weathering blows that would stagger their kin.<br>\
	(+1 Constitution, +1 Willpower, Waterbreathing, Natural Armor Trait)"

	expanded_desc = "A Sahuagin lineage descended from crab and lobster stock. Crustacean are thick-shelled and \
	sturdy, weathering blows that would stagger their kin. Their hardened carapaces make them sought after as \
	sailors and dockhands willing to take a beating without complaint."

	inherent_traits = list(TRAIT_WATERBREATHING, TRAIT_NATURALARMOR)
	racial_trait_choices = list(TRAIT_IRON_GRIP, TRAIT_CALTROPIMMUNE, TRAIT_BRUTE)

/datum/species/akula/crustacean/check_roundstart_eligible()
	return FALSE

/datum/species/akula/crustacean/qualifies_for_rank(rank, list/features)
	return TRUE
