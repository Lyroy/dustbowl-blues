/datum/job/wastelander
	title = "Wastelander"
	flag = ASSISTANT
	department = FACTION_WASTELANDERS
	department_flag = WASTELANDERS
	faction = MAP_FACTION
	total_positions = -1
	spawn_positions = -1
	supervisors = "Yourself"
	difficulty = "Hard."
	selection_color = "#dddddd"
	initial_balance = 800
	wage = WAGE_NONE
	alt_titles = list("Wanderer")

	outfit_type = /decl/hierarchy/outfit/job/wastelander

	stat_modifiers = list(
		SKILL_ATH = SKILL_LEVEL_ADEPT,
		SKILL_LOC = SKILL_LEVEL_BASIC,
		SKILL_MED = SKILL_LEVEL_BASIC,
		SKILL_REP = SKILL_LEVEL_BASIC,
		SKILL_SUR = SKILL_LEVEL_ADEPT,
		SKILL_SMA = 10,
		SKILL_BIG = 10,
		SKILL_EXP = 10,
		SKILL_ENE = 10,
		SKILL_MEL = 10,
		SKILL_UNA = 10
	)

	description = "The true Fallout experience. You are a wanderer, a lone wolf, someone that has seen the dangers of the Panhandle Wasteland and \
	has decided to brave it rather than hide among others.<br>\
<br>\
Perhaps you're a former vault dweller, sent on a quest or exiled from what used to be their home.<br>\
Perhaps you're a tribal, chosen and called to action by an old prophecy.<br>\
Perhaps you're a lone wanderer, in search of family and friends.<br>\
Perhaps you're a courier, knowledgeable of the kind of people that inhabit this land and their tendency to double-cross others.<br>\
Perhaps you're a sole survivor, the world you knew wiped out and leaving you to find a new place to call home.<br>\
<br>\
Your story is yours to write. What matters is that you're here now - find some purpose.<br>\
To form connections, strive to help out anyone you can. Or at least, anyone who offers you a paying job.<br>\
Find a way to make caps, stay out of trouble, and survive."

/obj/landmark/join/start/wastelander
	name = "Wastelander"
	icon_state = "player-grey"
	join_tag = /datum/job/wastelander
