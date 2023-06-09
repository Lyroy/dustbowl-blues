// --- POULTICES ---
// Poultices take longer to metabolize when compared to powders, and their effects are weaker, but longer lasting (resulting in overall extra healing)
// They also tend to have a secondary helpful effect.
// Metabolism should always be REM * 0.2 and NSA should be 15
/datum/reagent/poultice
	reagent_type = "Poultice"
	reagent_state = SEMILIQUID
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.2 //Poultices are even slower
	scannable = TRUE
	nerve_system_accumulations = 15

/datum/reagent/poultice/bloodsap_poultice
	name = "Bloodsap poultice"
	id = "bloodsap_poultice"
	description = "An even thicker mixture of bloodsap, with its clotting capabilities greatly enhanced."
	taste_description = "sweetness"
	taste_mult = 3
	color = "#7C2828"


/datum/reagent/poultice/bloodsap_poultice/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	. = ..()
	M.heal_organ_damage(0.08 * effect_multiplier, 0, 1.2 * effect_multiplier)
	M.add_chemical_effect(CE_BLOODCLOT, 0.30)


/datum/reagent/poultice/singetree_poultice
	name = "Singetree poultice"
	id = "singetree_poultice"
	description = "Singetree powder that has been mixed with a thickening solution. While not as fast acting, it greatly aids in fighting infections."
	taste_description = "dryness"
	taste_mult = 3
	color = "#A87B26"

/datum/reagent/poultice/singetree_poultice/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	. = ..()
	M.heal_organ_damage(0, 0.08 * effect_multiplier, 0, 1.2 * effect_multiplier)
	M.add_chemical_effect(CE_ANTIBIOTIC, 5)

/datum/reagent/poultice/toxgarlic_poultice
	name = "Ghoul Garlic poultice"
	id = "toxgarlic_poultice"
	description = "A disgusting-looking thick liquid with small chunks of garlic in it. Although it makes the user smell like a decaying corpse, it is renowned for shielding from the effects of radiation."
	taste_description = "savory garlic"
	taste_mult = 3
	color = "#90aa8d"

/datum/reagent/poultice/toxgarlic_poultice/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	. = ..()
	M.add_chemical_effect(CE_ANTITOX, 1.4)
	M.add_chemical_effect(CE_ANTIRADIATION, 20)

/datum/reagent/poultice/stareberry_poultice
	name = "Stareberry mush"
	id = "stareberry_poultice"
	description = "Delicious stareberries mixed into a thick liquid. "
	taste_description = "delicious berries"
	taste_mult = 3
	color = "#5658a3"

/datum/reagent/poultice/stareberry_poultice/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	. = ..()
	M.stats.addTempStat(SPECIAL_A, 1, STIM_TIME, "stareberry") //Does not stack with stareberry powder
	M.stats.addTempStat(SPECIAL_I, 1, STIM_TIME, "stareberry")
	M.AdjustSleeping(-0.7)
	M.drowsyness = max(0, M.drowsyness - 1.3)
