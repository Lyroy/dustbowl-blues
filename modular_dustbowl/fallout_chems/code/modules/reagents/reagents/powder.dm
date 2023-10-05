// --- POWDERS ---
// Powders are slow-acting chemicals acquired from wasteland plants. "Powder" can be anything obtained from a plant, like sap.
// They are precursors to poultices and pre-war chemicals.
// Metabolism should always be REM * 0.4 and NSA should be 10
/datum/reagent/powder
	reagent_type = "Powder"
	reagent_state = SOLID
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.4 //Powders are slow
	scannable = TRUE
	nerve_system_accumulations = 10

//Precursor to Stimpaks and Med-X
/datum/reagent/powder/bloodsap_powder
	name = "Bloodsap"
	id = "bloodsap_powder"
	description = "The thick, red sap of the Bloodvine. It aids the natural regeneration of the body when ingested."
	taste_description = "sweetness"
	taste_mult = 3
	color = "#5E0B0B"

/datum/reagent/powder/bloodsap_powder/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	. = ..()
	M.heal_organ_damage(0.10 * effect_multiplier, 0, 1.5 * effect_multiplier)
	M.add_chemical_effect(CE_BLOODCLOT, 0.15)

//Precursor to Stimpaks and Buffout
/datum/reagent/powder/singetree_powder
	name = "Singetree powder"
	id = "singetree_powder"
	description = "Singetree leaves ground into a sticky powder. Known to help alleviate burns if ingested."
	taste_description = "dryness"
	taste_mult = 3
	color = "#855600"

/datum/reagent/powder/singetree_powder/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	. = ..()
	M.heal_organ_damage(0, 0.10 * effect_multiplier, 0, 1.5 * effect_multiplier)

//Precursor to Rad-X and RadAway
/datum/reagent/powder/toxgarlic_powder
	name = "Ghoul Garlic powder"
	id = "toxgarlic_powder"
	description = "A finely ground mixture of dried bulbs from the mutated garlic known as Ghoul Garlic, with a pungent odor and bitter taste. Greatly aids in detoxification when ingested."
	taste_description = "rotten garlic"
	taste_mult = 3
	color = "#658062"

/datum/reagent/powder/toxgarlic_powder/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	. = ..()
	M.add_chemical_effect(CE_ANTITOX, 2)

//Precursor to Steady and Mentats
/datum/reagent/powder/stareberry_powder
	name = "Stareberry mush"
	id = "stareberry_powder"
	description = "Mushed stareberries that have turned into a fine paste. They aid in staying awake and focusing."
	taste_description = "delicious berries"
	taste_mult = 3
	color = "#292A6D"

/datum/reagent/powder/stareberry_powder/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	. = ..()
	M.stats.addTempStat(SPECIAL_A, 1, STIM_TIME, "stareberry")
	M.stats.addTempStat(SPECIAL_I, 1, STIM_TIME, "stareberry")
	M.AdjustSleeping(-1)
	M.drowsyness = max(0, M.drowsyness - 2)
