/datum/perk/level
	/// Required level to take this perk
	var/req_level = 1
	/// List of required stats to take the perk. It follows the pattern [STAT] = Amount
	var/list/req_stats = list()
	/// List of required perks to get this perk.
	var/list/req_perks = list()
	/// Image that shows up when selecting perks.
	var/img = 'html/images/stats/unknown.png'

/datum/perk/level/proc/check_requirements(var/mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(req_level && H.sanity.player_level < req_level)
		return FALSE
	if(req_stats.len)
		for(var/s in req_stats)
			if(H.stats.getStat(s, TRUE, "NO") < req_stats[s])
				return FALSE
	if(req_perks.len)
		for(var/perk in req_perks)
			if(!(H.stats.getPerk(perk)))
				return FALSE
	return TRUE

/datum/perk/level/comprehension
	name = "Comprehension"
	desc = "You pay much closer attention to the smaller details when reading. You gain 50% more skill points when reading books and double with magazines."
	req_level = 1
	req_stats = list(SPECIAL_I = 6)

/datum/perk/level/strong_back
	name = "Strong Back"
	desc = "AKA Mule. You do not get slowed down by duffelbags."
	req_level = 1
	req_stats = list(SPECIAL_S = 5, SPECIAL_E = 5)

/datum/perk/level/awareness
	name = "Awareness"
	desc = "With Awareness, you are given detailed information about any critter you examine. You see their exact hit points and information about any weapon they are equipped with."
	req_level = 2
	req_stats = list(SPECIAL_P = 5)

/datum/perk/level/cautious_nature
	name = "Cautious Nature"
	desc = "You keep an eye out for danger when you're walking about, giving you a chance to avoid traps and mines you have not yet detected."
	req_level = 2
	req_stats = list(SPECIAL_P = 6)

/datum/perk/level/quick_pockets
	name = "Quick Pockets"
	desc = "You have learned to better store your equipment on your person. With this perk, you can use your backpack without taking it off."
	req_level = 2
	req_stats = list(SPECIAL_A = 5)

/datum/perk/level/retention
	name = "Retention"
	desc = "The bonuses granted by skill magazines last three times as long."
	req_level = 2
	req_stats = list(SPECIAL_I = 5)

/datum/perk/level/educated
	name = "Educated"
	desc = "You gain five more skill points every time you gain a level."
	req_level = 4
	req_stats = list(SPECIAL_I = 4)

/datum/perk/level/entomologist
	name = "Entomologist"
	desc = "You do an additional 50% damage against mutated insects."
	req_level = 4
	req_stats = list(SPECIAL_I = 4, SKILL_SUR = 45)

