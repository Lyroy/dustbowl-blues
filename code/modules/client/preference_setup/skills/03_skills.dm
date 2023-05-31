/datum/preferences
	var/BOOST_ATH = FALSE
	var/BOOST_LOC = FALSE
	var/BOOST_MED = FALSE
	var/BOOST_REP = FALSE
	var/BOOST_SCI = FALSE
	var/BOOST_SUR = FALSE

	var/BOOST_BIG = FALSE
	var/BOOST_ENE = FALSE
	var/BOOST_EXP = FALSE
	var/BOOST_MEL = FALSE
	var/BOOST_SMA = FALSE
	var/BOOST_UNA = FALSE

/datum/category_item/player_setup_item/skills/skill_boosts
	name = "Skills"
	sort_order = 3

/datum/category_item/player_setup_item/skills/skill_boosts/load_character(var/savefile/S)
	from_file(S["BOOST_ATH"],pref.BOOST_ATH)
	from_file(S["BOOST_LOC"],pref.BOOST_LOC)
	from_file(S["BOOST_MED"],pref.BOOST_MED)
	from_file(S["BOOST_REP"],pref.BOOST_REP)
	from_file(S["BOOST_SCI"],pref.BOOST_SCI)
	from_file(S["BOOST_SUR"],pref.BOOST_SUR)

	from_file(S["BOOST_BIG"],pref.BOOST_BIG)
	from_file(S["BOOST_ENE"],pref.BOOST_ENE)
	from_file(S["BOOST_EXP"],pref.BOOST_EXP)
	from_file(S["BOOST_MEL"],pref.BOOST_MEL)
	from_file(S["BOOST_SMA"],pref.BOOST_SMA)
	from_file(S["BOOST_UNA"],pref.BOOST_UNA)

/datum/category_item/player_setup_item/skills/skill_boosts/save_character(var/savefile/S)
	to_file(S["BOOST_ATH"],pref.BOOST_ATH)
	to_file(S["BOOST_LOC"],pref.BOOST_LOC)
	to_file(S["BOOST_MED"],pref.BOOST_MED)
	to_file(S["BOOST_REP"],pref.BOOST_REP)
	to_file(S["BOOST_SCI"],pref.BOOST_SCI)
	to_file(S["BOOST_SUR"],pref.BOOST_SUR)

	to_file(S["BOOST_BIG"],pref.BOOST_BIG)
	to_file(S["BOOST_ENE"],pref.BOOST_ENE)
	to_file(S["BOOST_EXP"],pref.BOOST_EXP)
	to_file(S["BOOST_MEL"],pref.BOOST_MEL)
	to_file(S["BOOST_SMA"],pref.BOOST_SMA)
	to_file(S["BOOST_UNA"],pref.BOOST_UNA)

/datum/category_item/player_setup_item/skills/skill_boosts/sanitize_character()
	if(calculate_skill_boosts() > allowed_skill_boosts())
		pref.BOOST_ATH = FALSE
		pref.BOOST_LOC = FALSE
		pref.BOOST_MED = FALSE
		pref.BOOST_REP = FALSE
		pref.BOOST_SCI = FALSE
		pref.BOOST_SUR = FALSE

		pref.BOOST_BIG = FALSE
		pref.BOOST_ENE = FALSE
		pref.BOOST_EXP = FALSE
		pref.BOOST_MEL = FALSE
		pref.BOOST_SMA = FALSE
		pref.BOOST_UNA = FALSE

/datum/category_item/player_setup_item/skills/skill_boosts/content(var/mob/user)
	. += "<b>Skills:</b><br/>"
	. += "<i>Boosting a skill grants it 15 extra points!</i><br/>"
	. += "<a href='?src=\ref[src];skill_info=ATH'>\[?\]</a>Athletics:  <a href='?src=\ref[src];[!pref.BOOST_ATH ? "boost=ATH'>Boost" : "unboost=ATH' class='linkOn'>Unboost"]</a><br>"
	. += "<a href='?src=\ref[src];skill_info=LOC'>\[?\]</a>Lockpick:  <a href='?src=\ref[src];[!pref.BOOST_LOC ? "boost=LOC'>Boost" : "unboost=LOC' class='linkOn'>Unboost"]</a><br>"
	. += "<a href='?src=\ref[src];skill_info=MED'>\[?\]</a>Medicine:  <a href='?src=\ref[src];[!pref.BOOST_MED ? "boost=MED'>Boost" : "unboost=MED' class='linkOn'>Unboost"]</a><br>"
	. += "<a href='?src=\ref[src];skill_info=REP'>\[?\]</a>Repair:  <a href='?src=\ref[src];[!pref.BOOST_REP ? "boost=REP'>Boost" : "unboost=REP' class='linkOn'>Unboost"]</a><br>"
	. += "<a href='?src=\ref[src];skill_info=SCI'>\[?\]</a>Science:  <a href='?src=\ref[src];[!pref.BOOST_SCI ? "boost=SCI'>Boost" : "unboost=SCI' class='linkOn'>Unboost"]</a><br>"
	. += "<a href='?src=\ref[src];skill_info=SUR'>\[?\]</a>Survival:  <a href='?src=\ref[src];[!pref.BOOST_SUR ? "boost=SUR'>Boost" : "unboost=SUR' class='linkOn'>Unboost"]</a><br>"
	. += "<a href='?src=\ref[src];skill_info=BIG'>\[?\]</a>Big Guns:  <a href='?src=\ref[src];[!pref.BOOST_BIG ? "boost=BIG'>Boost" : "unboost=BIG' class='linkOn'>Unboost"]</a><br>"
	. += "<a href='?src=\ref[src];skill_info=ENE'>\[?\]</a>Energy Weapons:  <a href='?src=\ref[src];[!pref.BOOST_ENE ? "boost=ENE'>Boost" : "unboost=ENE' class='linkOn'>Unboost"]</a><br>"
	. += "<a href='?src=\ref[src];skill_info=EXP'>\[?\]</a>Explosives:  <a href='?src=\ref[src];[!pref.BOOST_EXP ? "boost=EXP'>Boost" : "unboost=EXP' class='linkOn'>Unboost"]</a><br>"
	. += "<a href='?src=\ref[src];skill_info=MEL'>\[?\]</a>Melee Weapons:  <a href='?src=\ref[src];[!pref.BOOST_MEL ? "boost=MEL'>Boost" : "unboost=MEL' class='linkOn'>Unboost"]</a><br>"
	. += "<a href='?src=\ref[src];skill_info=SMA'>\[?\]</a>Small Guns:  <a href='?src=\ref[src];[!pref.BOOST_SMA ? "boost=SMA'>Boost" : "unboost=SMA' class='linkOn'>Unboost"]</a><br>"
	. += "<a href='?src=\ref[src];skill_info=UNA'>\[?\]</a>Unarmed:  <a href='?src=\ref[src];[!pref.BOOST_UNA ? "boost=UNA'>Boost" : "unboost=UNA' class='linkOn'>Unboost"]</a><br>"
	. += "<br/>"
	. += "You have boosted [calculate_skill_boosts()] / [allowed_skill_boosts()] skills<hr>"

/datum/category_item/player_setup_item/skills/skill_boosts/proc/calculate_skill_boosts()
	return max(0,(pref.BOOST_ATH + pref.BOOST_LOC + pref.BOOST_MED + pref.BOOST_REP + pref.BOOST_SCI + pref.BOOST_SUR + \
			pref.BOOST_BIG + pref.BOOST_ENE + pref.BOOST_EXP + pref.BOOST_MEL + pref.BOOST_SMA + pref.BOOST_UNA))

/datum/category_item/player_setup_item/skills/skill_boosts/proc/allowed_skill_boosts()
	return 5 + SKILL_BOOSTS_PER_INT[pref.SCORE_I]

/datum/category_item/player_setup_item/skills/skill_boosts/proc/available_skill_boosts()
	return allowed_skill_boosts() - calculate_skill_boosts()

/datum/category_item/player_setup_item/skills/skill_boosts/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["boost"])
		if(available_skill_boosts())
			pref.vars["BOOST_[href_list["boost"]]"] = TRUE
			return TOPIC_REFRESH

	else if(href_list["unboost"])
		pref.vars["BOOST_[href_list["unboost"]]"] = FALSE
		return TOPIC_REFRESH

	else if(href_list["skill_info"])
		pref.selected_info_perk = null
		switch(href_list["skill_info"])
			if("ATH")
				pref.selected_info_stat = new /datum/stat/athletics
			if("LOC")
				pref.selected_info_stat = new /datum/stat/lockpick
			if("MED")
				pref.selected_info_stat = new /datum/stat/medicine
			if("REP")
				pref.selected_info_stat = new /datum/stat/repair
			if("SCI")
				pref.selected_info_stat = new /datum/stat/science
			if("SUR")
				pref.selected_info_stat = new /datum/stat/survival
			if("BIG")
				pref.selected_info_stat = new /datum/stat/big_guns
			if("ENE")
				pref.selected_info_stat = new /datum/stat/energy_guns
			if("EXP")
				pref.selected_info_stat = new /datum/stat/explosives
			if("MEL")
				pref.selected_info_stat = new /datum/stat/melee_weapons
			if("SMA")
				pref.selected_info_stat = new /datum/stat/small_guns
			if("UNA")
				pref.selected_info_stat = new /datum/stat/unarmed
		return TOPIC_REFRESH

	return ..()
