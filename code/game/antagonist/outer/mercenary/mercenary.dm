/datum/antagonist/mercenary
	id = ROLE_MERCENARY
	bantype = ROLE_MERCENARY
	faction_id = FACTION_SERBS
	role_text = "Void Wolf"
	welcome_text = WELCOME_SERBS
	antaghud_indicator = "hudoperative"
	landmark_id = "mercenary-spawn"
	outer = TRUE

	default_access = list(access_mercenary,//This access governs their ship and base
	access_external_airlocks,
	access_maint_tunnels) //Mercs get maintenance access on eris, because being an antag without it is hell
	//They got forged assistant IDs or somesuch
	id_type = /obj/item/card/id/merc


	appearance_editor = FALSE


	possible_objectives = list()
	survive_objective = null

	stat_modifiers = list()



/datum/antagonist/mercenary/equip()
	var/mob/living/L = owner.current

	//Put on the fatigues. Armor not included, they equip that manually from the merc base
	var/decl/hierarchy/outfit/O = outfit_by_type(/decl/hierarchy/outfit/antagonist/mercenary/casual)
	O.equip(L)

	//Set their language, This also adds it to their list
	L.set_default_language(LANGUAGE_ILLYRIAN)

	//Normal mercs can't speak common
	L.remove_language(LANGUAGE_COMMON)

	//And we'll give them a random serbian name to start off with
	var/datum/language/lang = all_languages[LANGUAGE_ILLYRIAN]
	lang.set_random_name(L)

	//the missingg parrt was antag's stats!
	for(var/name in stat_modifiers)
		L.stats.changeStat(name, stat_modifiers[name])

	create_id("Void Wolf")
	..()


/obj/item/card/id/merc
	icon_state = "syndicate"

/obj/item/card/id/merc/New()
	. = ..()
	access = list(access_mercenary,//This access governs their ship and base
	access_external_airlocks,
	access_maint_tunnels)



#undef WELCOME_SERBS
