//Macro: MUTATION_GIGANTISM
/datum/genetics/mutation/dwarfism
	name = "Dwarfism"
	key = "MUTATION_DWARFISM"
	desc = "Causes you to become small. VERY small, and more fragile."
	gain_text = "You feel your body getting smaller, and weaker..."
	var/old_size
	var/brute_mod_delta
	var/oxy_mod_delta

/datum/genetics/mutation/dwarfism/onPlayerImplant()
	if(!..())
		return
	var/mob/living/carbon/human/human_holder = container.holder
	//Bigger
	old_size = human_holder.scale_effect
	human_holder.scale_effect = -40
	human_holder.update_icons()

	//Weaker
	human_holder.stats.changeStat(SPECIAL_S, -1)
	human_holder.stats.changeStat(SPECIAL_E, -1)

	brute_mod_delta = (human_holder.brute_mod_perk * 0.2)
	human_holder.brute_mod_perk += brute_mod_delta

	//Less need for air
	oxy_mod_delta = (human_holder.oxy_mod_perk * 0.2)
	human_holder.oxy_mod_perk -= oxy_mod_delta


/datum/genetics/mutation/dwarfism/onPlayerRemove()
	if(!..())
		return
	var/mob/living/carbon/human/human_holder = container.holder
	//Smaller
	human_holder.scale_effect = old_size
	human_holder.update_icons()

	//Weaker
	human_holder.stats.changeStat(SPECIAL_S, 1)
	human_holder.stats.changeStat(SPECIAL_E, 1)

	human_holder.brute_mod_perk -= brute_mod_delta

	//Need less air
	human_holder.oxy_mod_perk += oxy_mod_delta
