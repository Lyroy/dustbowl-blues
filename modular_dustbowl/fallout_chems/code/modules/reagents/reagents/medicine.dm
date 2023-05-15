#define stimpak_healing_calc(volume,factor) 100 * volume / ((volume + factor) * (volume < 10 ? 2.5 : 1))

/datum/reagent/medicine/inert_stimpak
	name = "Inert Stimpak Fluid"
	id = "inert_stimpak"
	description = "The remainder of a successful stimpak injection. Takes the body some time to purge."
	taste_description = "blandness"
	reagent_state = LIQUID
	color = "#969696"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	nerve_system_accumulations = 45 //It leaves you kinda woozy

/datum/reagent/medicine/stimpak
	name = "Stimpak Fluid"
	id = "stimpak"
	description = "A mixture of several healing fluids and stimulants, allowing the user to boost their own body's natural regenerative functions."
	taste_description = "toxic burns"
	reagent_state = LIQUID
	color = "#900000"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	nerve_system_accumulations = 0
	//How effective the stim fluid is at healing. Higher is worse.
	var/factor = 15 //15u heal 50hp, 30u heal 66hp
	//If we apply the stimpak debuff on add
	var/cause_slowdown = FALSE

/datum/reagent/medicine/stimpak/on_mob_add(mob/living/carbon/M)
	if(M.ingested && (src in M.ingested.reagent_list))
		//Drinking stimpaks is a really bad idea.
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/tummy = H.random_organ_by_process(OP_STOMACH)
			if(tummy && istype(tummy))
				to_chat(H, "Your [tummy.parent.name] and throat feel like they're burning!")
				create_overdose_wound(tummy, H, /datum/component/internal_wound/organic/heavy_poisoning/chem, "poisoning", TRUE)

		//Toxins woooo!
		M.reagents.add_reagent("toxin",volume*2)
	else if(M.reagents && (src in M.reagents.reagent_list))
		var/brute_loss = M.getBruteLoss()
		var/fire_loss = M.getFireLoss()

		if(brute_loss > 0 || fire_loss > 0)
			//Heals brute and burns, at a proportional rate for each
			var/total_healing = stimpak_healing_calc(volume,factor)
			M.heal_overall_damage(total_healing * (brute_loss / (brute_loss + fire_loss)), total_healing * (fire_loss / (brute_loss + fire_loss)))

		//Becomes inert after use
		M.reagents.add_reagent("inert_stimpak",volume)

		//Apply slowdown if it's a superstim
		if(cause_slowdown)
			if(!M.stats.getPerk(PERK_SUPERSTIM_SLOWDOWN))
				M.stats.addPerk(PERK_SUPERSTIM_SLOWDOWN)

	remove_self(volume)
	return

/datum/reagent/medicine/stimpak/super
	name = "Superstimpak Fluid"
	id = "super_stimpak"
	description = "A potent mixture of several healing fluids and stimulants, allowing the user to boost their own body's natural regenerative functions, yet leaving behind soreness."
	taste_description = "toxic burns"
	color = "#d30000"
	factor = 7 //15u heal 68hp, 30u heal 81hp
	cause_slowdown = TRUE

/datum/reagent/medicine/stimpak/expired
	name = "Expired Stimpak Fluid"
	id = "stimpak_bad"
	description = "A mixture of several healing fluids and stimulants, allowing the user to boost their own body's natural regenerative functions. This one is expired."
	taste_description = "toxic burns"
	color = "#691111"
	factor = 30 //15u heal 33hp, 30u heal 50hp

/datum/reagent/medicine/medx
	name = "Med-X"
	id = "medx"
	description = "A potent morphine-based painkiller that binds to opioid receptors in the brain and central nervous system, reducing the perception of pain \
	as well as the emotional response to pain."
	taste_description = "numbed senses"
	reagent_state = LIQUID
	color = "#730090"
	overdose = 50 //Spawns in needles of 5u each, so it takes 10+ doses
	scannable = TRUE
	nerve_system_accumulations = 40
	addiction_chance = 33

/datum/reagent/medicine/medx/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_PAINKILLER, 60)

/datum/reagent/medicine/medx/overdose(mob/living/carbon/M, alien)
	. = ..()
	//Mess up a random organ and also your brain for being a dummy
	M.adjustBrainLoss(1)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/list/organs_sans_brain = H.internal_organs - H.internal_organs_by_efficiency[BP_BRAIN]
		if(LAZYLEN(organs_sans_brain))
			create_overdose_wound(pick(organs_sans_brain), H, /datum/component/internal_wound/organic/heavy_poisoning)

/datum/reagent/medicine/calmex
	name = "Calmex"
	id = "calmex"
	description = "A variety of pre-War light tranquilizers. It doesn't work as a painkiller when administered. However, it still carries a high enough dosage to cause a boost of some survival senses that are ordinarily dulled by reasoning. "
	taste_description = "sweet grapes"
	reagent_state = LIQUID
	color = "#bb2edf"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	nerve_system_accumulations = 25
	addiction_chance = 20

/datum/reagent/medicine/calmex/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_VIG, STAT_LEVEL_ADEPT, STIM_TIME, "calmex")

/datum/reagent/medicine/fixer
	name = "Fixer"
	id = "fixer"
	description = "Purges all addictions, at the cost of making the user nauseous."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#e7d001"
	scannable = TRUE
	metabolism = REM/2
	nerve_system_accumulations = -35

/datum/reagent/medicine/fixer/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	var/mob/living/carbon/C = M
	if(istype(C) && C.metabolism_effects.addiction_list.len)
		if(prob(5 * effect_multiplier + dose))
			var/datum/reagent/R = pick(C.metabolism_effects.addiction_list)
			to_chat(C, SPAN_NOTICE("You dont crave [R.name] anymore."))
			C.metabolism_effects.addiction_list.Remove(R)
			qdel(R)
	M.make_dizzy(10)
	if(prob(10))
		M.vomit()

/datum/reagent/medicine/fixer/on_mob_delete(mob/living/L)
	..()
	var/mob/living/carbon/C = L
	if(dose >= 10)
		if(istype(C))
			C.remove_all_addictions()

/datum/reagent/medicine/radx
	name = "Rad-X"
	id = "radx"
	description = "A potent anti-radiation medicine that bolsters the user's protection against radiation. Does not help with existing radiation poisoning."
	taste_description = "blandness"
	reagent_state = LIQUID
	color = "#902e00"
	overdose = 9999 //You can't overdose on Rad-X
	scannable = TRUE
	nerve_system_accumulations = 0

/datum/reagent/medicine/radx/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_ANTIRADIATION, 33) //33% protection against rads

/datum/reagent/medicine/radaway
	name = "RadAway"
	id = "radaway"
	description = "RadAway is a chemical solution that bonds with radioactive particles and removes them from the user's system. May cause nausea, diarrhea, stomach pains and headaches."
	taste_description = "toxic waste"
	reagent_state = LIQUID
	color = "#902e00"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	nerve_system_accumulations = 15

/datum/reagent/medicine/radaway/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.radiation = max(M.radiation - (3 * effect_multiplier), 0)
	M.add_chemical_effect(CE_ONCOCIDAL, 1)
	if(prob(50))
		M.add_side_effect("Headache", 11)
		M.add_side_effect("Bad Stomach", 11)
	if(prob(10))
		M.vomit()

/datum/reagent/medicine/hydra
	name = "Hydra"
	id = "hydra"
	description = "A wasteland chem with a strong, bitter scent. Acts on bone fractures, mending them slowly."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#aa6a17"
	overdose = 15
	metabolism = REM * 1.5
	scannable = TRUE
	nerve_system_accumulations = 50
	addiction_chance = 10

/datum/reagent/medicine/hydra/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_BLOODCLOT, 0.1)
	M.add_chemical_effect(CE_BONE_MEND, 0.5)
