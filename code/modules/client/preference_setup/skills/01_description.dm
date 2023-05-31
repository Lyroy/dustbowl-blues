/datum/preferences
	var/datum/stat/selected_info_stat = null
	var/datum/stat/selected_info_perk = null

/datum/category_item/player_setup_item/skills/description_box
	name = "Descriptions"
	sort_order = 1

/datum/category_item/player_setup_item/skills/description_box/content(var/mob/user)
	. = ""
	if(pref.selected_info_stat)
		. += create_stat_description(user, pref.selected_info_stat)
	else if(pref.selected_info_perk)
		. += create_perk_description(user, pref.selected_info_perk)


/datum/category_item/player_setup_item/skills/description_box/proc/create_stat_description(var/mob/user, var/datum/stat/selected_info_stat)
	. = ""
	. += "<div class = 'roleDescription' style = 'height:150px; width:65%; margin-left:auto; margin-right:auto;'>"
	. += "<table style='float:left;table-layout: fixed;' cellpadding='0' cellspacing='0'>"
	. += "<tr>"

	// little preview image
	user << browse_rsc(selected_info_stat.img, "stat_image_[selected_info_stat.name].png")
	. += "<td style='width: 140px;overflow: hidden;display: inline-block;white-space: nowrap;'><img src='stat_image_[selected_info_stat.name].png'></td>"

	// stat description
	. += "<td style = 'width: 100%;vertical-align: top;'>"
	. += "<h1 style='text-align: center;padding-top: 5px;padding-bottom: 0px;'>[selected_info_stat.name]</h1>" // stat title
	. += "<hr>"
	. += "[selected_info_stat.desc]</td></tr></table>" // description
	. += "</div>"

/datum/category_item/player_setup_item/skills/description_box/proc/create_perk_description(var/mob/user, var/datum/perk/level/selected_info_perk)
	. = ""
	. += "<div class = 'roleDescription' style = 'height:150px; width:65%; margin-left:auto; margin-right:auto;'>"
	. += "<table style='float:left;table-layout: fixed;' cellpadding='0' cellspacing='0'>"
	. += "<tr>"

	// little preview image
	user << browse_rsc(selected_info_perk.img, "stat_image_[selected_info_perk.name].png")
	. += "<td style='width: 140px;overflow: hidden;display: inline-block;white-space: nowrap;'><img src='stat_image_[selected_info_perk.name].png'></td>"

	// stat description
	. += "<td style = 'width: 100%;vertical-align: top;'>"
	. += "<h1 style='text-align: center;padding-top: 5px;padding-bottom: 0px;'>[selected_info_perk.name]</h1>" // stat title
	. += "<hr>"

	// Here we have a right-floating textbox that shows user's stats
	. += "<div style='border: 1px solid grey; float: right; margin-right: 20px; padding: 8px; line-height: 120%;'> <h1 style='padding: 0px;'>Required Stats:</h1>"
	if (selected_info_perk.req_stats.len)
		. += "<ul>"
		for (var/a in selected_info_perk.req_stats)
			. += "<li>[a]: [selected_info_perk.req_stats[a]]</li>"
		. += "</ul>"
	else
		. += "None"
	. += "<h1 style='padding: 0px;'>Required Perks:</h1>"
	if (selected_info_perk.req_perks.len)
		. += "<ul>"
		for (var/a in selected_info_perk.req_perks)
			var/datum/perk/P = a
			. += "<li>[initial(P.name)]</li>"
		. += "</ul>"
	else
		. += "None"
	. += "</div>"

	. += "[selected_info_perk.desc]</td></tr></table>" // description
	. += "</div>"
