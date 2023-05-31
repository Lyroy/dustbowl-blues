/datum/species/human/anthro
	name = "Anthro"
	name_plural = "Anthros"
	default_form = FORM_ANTHRO
	obligate_form = FALSE
	blurb = "A blank slate for you to make your own species. Go wild!"
	permitted_forms = list(FORM_ANTHRO, FORM_CANINE, FORM_VULPINE, FORM_FENNEC, FORM_SABLEKYNE, FORM_KRIOSAN, FORM_NARAMAD)

/datum/species/human/anthro/get_bodytype()
	return "Anthro"

/datum/species/human/aquatic
	name = "Aquatic"
	name_plural = "Aquatics"
	default_form = FORM_SHARK
	obligate_form = FALSE
	blurb = "A blank slate for you to make your own species. Go wild!"
	permitted_forms = list(FORM_SHARK, FORM_SUDAK, FORM_AXOLOTL)

/datum/species/human/aquatic/get_bodytype()
	return "Aquatic"

/datum/species/lizard
	name = "Lizard"
	name_plural = "Lizards"
	default_form = FORM_LIZARD
	obligate_form = FALSE
	unarmed_types = list(/datum/unarmed_attack/punch, /datum/unarmed_attack/stomp,  /datum/unarmed_attack/kick, /datum/unarmed_attack/bite)
	blurb = "Also known as 'Unathi', lizards are a scaled, reptilian species. They prefer warmer temperatures than most species."
	permitted_forms = list(FORM_LIZARD, FORM_LIZARD_TGSMOOTH, FORM_LIZARD_TGSHARP)
	num_alternate_languages = 2
	name_language = null
	min_age = 18
	max_age = 110

	burn_mod = 0.8
	darksight = 3

	stat_modifiers = list(
		STAT_BIO = 2,
		STAT_COG = 2,
		STAT_MEC = 2,
		STAT_ROB = 2,
		STAT_TGH = 2,
		STAT_VIG = 2
	)

	dark_color = "#660066"
	light_color = "#660066"

	cold_level_1 = 290 //Default 270
	cold_level_2 = 265 //Default 230
	cold_level_3 = 240  //Default 200

	heat_level_1 = 370 //Default 330
	heat_level_2 = 410 //Default 380
	heat_level_3 = 500 //Default 460

	heat_discomfort_level = 370
	heat_discomfort_strings = list(
		"Your scales prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated scales itch."
		)

	cold_discomfort_level = 290
	list/cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your chilly scales stands out in goosebumps."
		)

	// perks = list(PERK_PURGEINFECTIONS, PERK_PURGETOXINS, PERK_CARNIVORE)

	spawn_flags = CAN_JOIN

/datum/species/lizard/get_bodytype()
	return "Lizard"

/datum/species/bug
	name = "Insectoid"
	name_plural = "Insectoids"
	default_form = FORM_MOTH_WHITE
	obligate_form = FALSE
	blurb = "A blank slate for you to make your own species. Go wild!"
	permitted_forms = list(FORM_SPIDER, FORM_MOTH, FORM_MOTH_WHITE)
	num_alternate_languages = 2
	name_language = null
	min_age = 18
	max_age = 110

	brute_mod =     1.25                    // Physical damage multiplier.
	burn_mod =      0.85                    // Burn damage multiplier.
	flash_mod =     3
	taste_sensitivity = TASTE_HYPERSENSITIVE
	darksight = 4

	stat_modifiers = list(
		STAT_BIO = 2,
		STAT_COG = 2,
		STAT_MEC = 2,
		STAT_ROB = 2,
		STAT_TGH = 2,
		STAT_VIG = 2
	)

	dark_color = "#5ac18e"
	light_color = "#5ac18e"

	// perks = list(PERK_HERBIVORE)

	spawn_flags = CAN_JOIN

/datum/species/bug/get_bodytype()
	return "Insectoid"

/datum/species/ghoul
	name = "Ghoul"
	name_plural = "Ghouls"
	default_form = FORM_GHOUL
	obligate_form = TRUE
	unarmed_types = list(/datum/unarmed_attack/punch, /datum/unarmed_attack/stomp,  /datum/unarmed_attack/kick, /datum/unarmed_attack/bite)
	blurb = "Ravaged by radiation, ghouls are heavily mutated humans. They'll probably be resistant to radiation, but be overall weaker. I don't know for sure yet."
	num_alternate_languages = 2
	name_language = null
	min_age = 18
	max_age = 110
	//radiation shit comes later
	darksight = 3

	stat_modifiers = list(
		STAT_BIO = 2,
		STAT_COG = 2,
		STAT_MEC = 2,
		STAT_ROB = 2,
		STAT_TGH = 2,
		STAT_VIG = 2
	)

	dark_color = "#3a411f"
	light_color = "#6d7742"

	spawn_flags = CAN_JOIN

/datum/species/ghoul/get_bodytype()
	return "Ghoul"
