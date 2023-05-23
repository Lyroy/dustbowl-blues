datum/preferences
	var/list/perks = list()

/datum/category_item/player_setup_item/skills/perks
	name = "Perks"
	sort_order = 4

/datum/category_item/player_setup_item/skills/perks/sanitize_character()
	if(pref.perks.len > 2)
		pref.perks = list() // completely reset the perk list

/datum/category_item/player_setup_item/skills/perks/content(var/mob/user)
	var/counter = 0
	. = ""

	. += "<b>Perks:</b><br>"
	if(pref.perks.len < 2)
		. += "<a href='?src=\ref[src];perk_add=1'>Add Perk</a><br>"
	else
		. += "<span class='linkOff'>Add Perk</span><br>"
	for(counter = pref.perks.len, counter >= 1, counter--)
		// . += "<a href='?src=\ref[src];perk_info=[counter]'>\[?\]</a><br>"
		. += "<a href='?src=\ref[src];perk=[counter]'>[pref.perks[counter]]</a><br>"

	. += "<br>You have selected [pref.perks.len] / 2 perks."

/datum/category_item/player_setup_item/skills/perks/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["perk_add"])
		var/new_perk = input(user, "Choose a perk to add:", CHARACTER_PREFERENCE_INPUT_TITLE, null) as null|anything in GLOB.all_perks - pref.perks
		if(new_perk && CanUseTopic(user))
			pref.perks[new_perk] = GLOB.all_perks[new_perk]
		return TOPIC_REFRESH
	else if(href_list["perk"])
		if(CanUseTopic(user))
			var/pos = text2num(href_list["perk"])
			if(pos > 0 && pos <= pref.perks.len)
				pref.perks.Remove(pref.perks[pos])
		return TOPIC_REFRESH