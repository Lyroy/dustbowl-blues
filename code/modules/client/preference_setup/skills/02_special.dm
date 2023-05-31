//Many thanks to Jamini/Occulus-Eris for coding and bug testing/improving this stat via cilent system

/datum/preferences
	var/SCORE_S = 1
	var/SCORE_P = 1
	var/SCORE_E = 1
	var/SCORE_C = 1
	var/SCORE_I = 1
	var/SCORE_A = 1
	var/SCORE_L = 1

/datum/category_item/player_setup_item/skills/special
	name = "SPECIAL"
	sort_order = 2

/datum/category_item/player_setup_item/skills/special/load_character(var/savefile/S)
	from_file(S["SCORE_S"],pref.SCORE_S)
	from_file(S["SCORE_P"],pref.SCORE_P)
	from_file(S["SCORE_E"],pref.SCORE_E)
	from_file(S["SCORE_C"],pref.SCORE_C)
	from_file(S["SCORE_I"],pref.SCORE_I)
	from_file(S["SCORE_A"],pref.SCORE_A)
	from_file(S["SCORE_L"],pref.SCORE_L)

/datum/category_item/player_setup_item/skills/special/save_character(var/savefile/S)
	to_file(S["SCORE_S"],pref.SCORE_S)
	to_file(S["SCORE_P"],pref.SCORE_P)
	to_file(S["SCORE_E"],pref.SCORE_E)
	to_file(S["SCORE_C"],pref.SCORE_C)
	to_file(S["SCORE_I"],pref.SCORE_I)
	to_file(S["SCORE_A"],pref.SCORE_A)
	to_file(S["SCORE_L"],pref.SCORE_L)

/datum/category_item/player_setup_item/skills/special/sanitize_character()
	pref.SCORE_S = sanitize_integer(pref.SCORE_S, 1, 10, initial(pref.SCORE_S))
	pref.SCORE_P = sanitize_integer(pref.SCORE_P, 1, 10, initial(pref.SCORE_P))
	pref.SCORE_E = sanitize_integer(pref.SCORE_E, 1, 10, initial(pref.SCORE_E))
	pref.SCORE_C = sanitize_integer(pref.SCORE_C, 1, 10, initial(pref.SCORE_C))
	pref.SCORE_I = sanitize_integer(pref.SCORE_I, 1, 10, initial(pref.SCORE_I))
	pref.SCORE_A = sanitize_integer(pref.SCORE_A, 1, 10, initial(pref.SCORE_A))
	pref.SCORE_L = sanitize_integer(pref.SCORE_L, 1, 10, initial(pref.SCORE_L))

	if(calculate_special_points() > 40)
		pref.SCORE_S = 1
		pref.SCORE_P = 1
		pref.SCORE_E = 1
		pref.SCORE_C = 1
		pref.SCORE_I = 1
		pref.SCORE_A = 1
		pref.SCORE_L = 1

/datum/category_item/player_setup_item/skills/special/content(var/mob/user)
	. += "<b>SPECIAL:</b><br/>"
	. += "<a href='?src=\ref[src];special_info=S'>\[?\]</a>Strength:  <a href='?src=\ref[src];special=S;text=Strength'>[pref.SCORE_S]</a><br>"
	. += "<a href='?src=\ref[src];special_info=P'>\[?\]</a>Perception:  <a href='?src=\ref[src];special=P;text=Perception'>[pref.SCORE_P]</a><br>"
	. += "<a href='?src=\ref[src];special_info=E'>\[?\]</a>Endurance:  <a href='?src=\ref[src];special=E;text=Endurance'>[pref.SCORE_E]</a><br>"
	. += "<a href='?src=\ref[src];special_info=C'>\[?\]</a>Charisma:  <a href='?src=\ref[src];special=C;text=Charisma'>[pref.SCORE_C]</a><br>"
	. += "<a href='?src=\ref[src];special_info=I'>\[?\]</a>Intelligence:  <a href='?src=\ref[src];special=I;text=Intelligence'>[pref.SCORE_I]</a><br>"
	. += "<a href='?src=\ref[src];special_info=A'>\[?\]</a>Agility:  <a href='?src=\ref[src];special=A;text=Agility'>[pref.SCORE_A]</a><br>"
	. += "<a href='?src=\ref[src];special_info=L'>\[?\]</a>Luck:  <a href='?src=\ref[src];special=L;text=Luck'>[pref.SCORE_L]</a><br>"
	. += "<br/>"
	. += "You have used [calculate_special_points()] / 40 SPECIAL points"

/datum/category_item/player_setup_item/skills/special/proc/calculate_special_points()
	return (pref.SCORE_S + pref.SCORE_P + pref.SCORE_E + pref.SCORE_C + pref.SCORE_I + pref.SCORE_A + pref.SCORE_L)

/datum/category_item/player_setup_item/skills/special/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["special"])
		var/new_s = 0
		new_s = input(user, "Enter a value between 1 and 10 for your [href_list["text"]].", CHARACTER_PREFERENCE_INPUT_TITLE, pref.vars["SCORE_[href_list["special"]]"]) as num
		if(CanUseTopic(user))
			var/old_s = pref.vars["SCORE_[href_list["special"]]"]
			pref.vars["SCORE_[href_list["special"]]"] = max(min(round(new_s), 10), 1)
			if(calculate_special_points() > 40)
				pref.vars["SCORE_[href_list["special"]]"] = old_s
			return TOPIC_REFRESH
	else if(href_list["special_info"])
		switch(href_list["special_info"])
			if("S")
				pref.selected_info_stat = new /datum/stat/special/strength
			if("P")
				pref.selected_info_stat = new /datum/stat/special/perception
			if("E")
				pref.selected_info_stat = new /datum/stat/special/endurance
			if("C")
				pref.selected_info_stat = new /datum/stat/special/charisma
			if("I")
				pref.selected_info_stat = new /datum/stat/special/intelligence
			if("A")
				pref.selected_info_stat = new /datum/stat/special/agility
			if("L")
				pref.selected_info_stat = new /datum/stat/special/luck
		return TOPIC_REFRESH

	return ..()
