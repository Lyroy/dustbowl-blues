/datum/sanity/proc/level_up()
	desires.Cut()

	var/skill_points_gained = resting * ( 15 + (3 * SKILL_BOOSTS_PER_INT[owner.stats.getStat(SPECIAL_I, pure = TRUE)]))
	skill_points += skill_points_gained

	player_level += resting

	if(resting > 1)
		perk_points += (ISODD(player_level)) ? round(resting / 2) : round(resting / 2 + 1)
	else
		if(ISEVEN(player_level))
			perk_points++

	owner.playsound_local(get_turf(owner), 'sound/sanity/level_up.ogg', 100)
	to_chat(owner, SPAN_FOBLOCK("You have leveled up!<br>To spend your skill points, use the 'Level Up' option in your IC tab."))

	// owner.pick_individual_objective() //disabling this for now, seems kinda tacky to just do some random task and instantly level up
	resting = 0

/mob/living/carbon/human/verb/level_up()
	set name = "Level up"
	set category = "IC"
	set src = usr

	if(!(src.sanity.skill_points || src.sanity.perk_points))
		to_chat(src, SPAN_NOTICE("You don't have any skill or perk points!"))
		return
	else
		src.sanity.skill_point_window()

/datum/sanity/proc/skill_point_window()
	for(var/TS in ALL_SKILLS)
		skill_additions_list[TS] = 0
	perk_additions_list = list()
	current_category = skill_points > 0 ? "skills" : "perks"
	perk_info_selected = null

	allocate_skill_point_draw()

/datum/sanity/proc/generate_perk_html(var/datum/perk/level/P)
	if(!perk_info_selected) //We select the first perk by default
		perk_info_selected = P.name
	var/extra_style = ""
	if(P.name == perk_info_selected)
		extra_style = ";background-color: darkcyan;"
	if(P.name in perk_additions_list)
		extra_style = ";background-color: green;"
	if(!P.check_requirements(owner))
		extra_style = ";background-color: gray;"
	return "<div style = 'padding:2px[extra_style]' onclick=\"set('selected_perk', '[P.name]');\" class='block'><b>[P.name]</b></div>"

// for drawing the window
/datum/sanity/proc/allocate_skill_point_draw()
	var/data = ""
	var/skill_data = {"
		Your skills:<br>
	"}

	var/total_points_allocated = 0

	for(var/TS in ALL_SKILLS)
		skill_data += "[TS]:  [owner.getStatStats(TS)] + <a href='?src=\ref[src];skill_allocation=[TS]'>[skill_additions_list[TS]]</a><br>"
		total_points_allocated += skill_additions_list[TS]

	data += "<center><a [current_category == "skills" ? "class='linkOff'" : ""] href='?src=\ref[src];category=skills'>Skills ([skill_points - total_points_allocated] left)</a>"
	data += "<a [current_category == "perks" ? "class='linkOff'" : ""] href='?src=\ref[src];category=perks'>Perks ([perk_points - perk_additions_list.len] left)</a></center><hr>"

	if(current_category == "skills")
		data += "[skill_data]"
		data += "<br>You've allocated [total_points_allocated] / [skill_points] skill points."
	if(current_category == "perks")
		data += "<style>div.block{margin: 3px 0px;padding: 4px 0px;}"
		data += "span.color_holder_box{display: inline-block; width: 20px; height: 8px; border:1px solid #000; padding: 0px;}</style>"

		data +=  "<script language='javascript'> [js_byjax] function set(param, value) {window.location='?src=\ref[src];'+param+'='+value;}</script>"
		data += "<table style='max-height:400px;height:410px;'>"
		data += "<tr style='vertical-align:top'>"
		data += "<td><div style='max-width:230px;width:230px;height:100%;overflow-y:auto;border-right:1px solid;padding:3px'>"
		for(var/P as null|anything in GLOB.selectable_perks)
			if((locate(GLOB.selectable_perks[P]) in owner.stats.perks))
				continue
			data += generate_perk_html(GLOB.selectable_perks[P])
		data += "</div></td>"
		data += "<td style='margin-left:10px;width-max:400px;width:400px;'>"
		data +="<div class = 'roleDescription' style = 'height:400px; width:400px; margin-left:auto; margin-right:auto;'>"
		data += "<table style='float:left;table-layout: fixed;' cellpadding='0' cellspacing='0'>"
		data += "<tr>"

		if(perk_info_selected)
			var/datum/perk/level/perk_for_info = GLOB.selectable_perks[perk_info_selected]
			// little preview image
			owner << browse_rsc(perk_for_info.img, "perk_image_[perk_info_selected].png")
			data += "<td style='width: 400px;overflow: hidden;display: inline-block;white-space: nowrap; text-align:center;'><img src='perk_image_[perk_info_selected].png'></td>"

			// stat description
			data += "<tr>"
			data += "<td style = 'width: 400px;vertical-align: top;'>"
			data += "<h1 style='text-align: center;padding-top: 5px;padding-bottom: 0px; width: 400px;'>[perk_for_info.name]</h1>" // stat title
			data += "<hr>"
			data += "[perk_for_info.desc]</td></tr>" // description
			if(perk_for_info.req_stats || perk_for_info.req_level > 1)
				data += "<tr><td><hr><b>Requirements:</b><br>"
				if(perk_for_info.req_level > 1)
					data += "Level [perk_for_info.req_level]<br>"
				for(var/i in perk_for_info.req_stats)
					data += "[i] [perk_for_info.req_stats[i]] "
				data += "</td></tr>"
			data += "<tr><td><br><center>"
			if(!perk_for_info.check_requirements(owner))
				data += "<a class='linkOff' style='width:100px;' href='?src=\ref[src];'>You don't meet the requirements for this perk</a></center>"
			else if(perk_for_info.name in perk_additions_list)
				data += "<a class='linkOn' style='width:100px;' href='?src=\ref[src];unselect_perk=[perk_info_selected];'>Unselect</a></center>"
			else
				data += "<a style='width:100px;' href='?src=\ref[src];choose_perk=[perk_info_selected];'>Select</a></center>"
			data += "</table>"

		data += "</div></td></tr></tr></table>"

	data += "<a href='?src=\ref[src];submit_skill_allocation=1'>Submit</a> <a href='?src=\ref[src];reset_skill_allocation=1'>Reset</a>"

	var/datum/browser/B = new(owner, "SkillPointBrowser","Level Up", 800, 600)
	B.set_content(data)
	B.set_window_options("can_minimize=0")
	B.open()

// for interacting with the window
/datum/sanity/Topic(href, href_list)
	// skill point allocation
	if(href_list["category"])
		current_category = href_list["category"]
		allocate_skill_point_draw()
		return 1
	if(href_list["selected_perk"])
		perk_info_selected = href_list["selected_perk"]
		allocate_skill_point_draw()
		return 1
	if(href_list["skill_allocation"])
		var/new_s = 0
		var/total_points_allocated = 0

		// get input
		new_s = input(owner, "Enter how many points you would like to allocate for [href_list["skill_allocation"]].", CHARACTER_PREFERENCE_INPUT_TITLE, skill_additions_list[href_list["skill"]]) as num
		new_s = sanitize_integer(new_s, 0, 60)

		// cap the input
		if((owner.getStatStats(href_list["skill"]) + new_s) > SKILL_LEVEL_MAX)
			new_s -= new_s - (SKILL_LEVEL_MAX - owner.getStatStats(href_list["skill"])) // subtract input by how much it goes over the max skill level

		// find out how many total points the player will have allocated with the input
		for(var/TS in ALL_SKILLS)
			if(TS == href_list["skill_allocation"])
				continue
			total_points_allocated += skill_additions_list[TS]
		total_points_allocated += new_s

		// make sure it isnt fucking insane, and if it isnt put the new allocated points value into skill_additions_list
		if(skill_points >= total_points_allocated)
			skill_additions_list[href_list["skill_allocation"]] = new_s
		else
			to_chat(owner, SPAN_WARNING("You've allocated more than [skill_points] skill points!"))

		// we have to refresh the window manually
		allocate_skill_point_draw()
		return 1

	// perk allocation
	else if(href_list["choose_perk"])
		if(perk_points - perk_additions_list.len <= 0)
			to_chat(owner, SPAN_WARNING("You can't select more perks!"))
		else
			var/perkname = href_list["choose_perk"]
			if(CanUseTopic(owner) && !(locate(GLOB.selectable_perks[perkname]) in perk_additions_list))
				perk_additions_list[perkname] = GLOB.selectable_perks[perkname]
		allocate_skill_point_draw()
		return 1

	else if(href_list["unselect_perk"])
		if(CanUseTopic(owner))
			perk_additions_list.Remove(href_list["unselect_perk"])
		allocate_skill_point_draw()
		return 1

	// the buttons on the bottom
	else if(href_list["reset_skill_allocation"])
		if(CanUseTopic(owner))
			for(var/TS in ALL_SKILLS)
				skill_additions_list[TS] = 0
		allocate_skill_point_draw()
		return 1

	else if(href_list["submit_skill_allocation"])
		// check for any bullshit values just to make sure
		var/total_points_allocated = 0
		for(var/TS in ALL_SKILLS)
			total_points_allocated += skill_additions_list[TS]

		// values are not okay, dont do anything
		if(!(total_points_allocated || perk_additions_list.len))
			to_chat(owner, SPAN_NOTICE("You've haven't used any points!"))
			return 1
		if(total_points_allocated > skill_points)
			to_chat(owner, SPAN_WARNING("You've allocated more than [skill_points] skill points!"))
			return 1
		if(perk_additions_list.len > perk_points)
			to_chat(owner, SPAN_WARNING("You've chosen more than [perk_points] perks to add!"))
			return 1
		// the player should be able to not use perk points incase they dont actually wanna do anything with them

		if(skill_points >= total_points_allocated)
			// values are okay, change the players stats
			to_chat(owner, SPAN_NOTICE("You've sucessfully allocated your skill points!"))

			for(var/TS in ALL_SKILLS)
				owner.stats.changeStat_withcap(TS, skill_additions_list[TS])

			for(var/newperk in perk_additions_list)
				var/datum/perk/perk_to_add = perk_additions_list[newperk] // can byond just be normal about arrays?
				owner.stats.addPerk(perk_to_add.type)

			skill_points -= total_points_allocated // remove points spent
			perk_points -= perk_additions_list.len

			// and then close the window
			owner << browse(null, "window=SkillPointBrowser")

		return 1

// good god this is a fucking nightmare
