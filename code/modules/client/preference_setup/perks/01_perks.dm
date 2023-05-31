datum/preferences
	var/perk

/datum/category_item/player_setup_item/perks
	name = "Perks"
	sort_order = 1
	var/chosen_perk
	var/perk_info_selected

/datum/category_item/player_setup_item/perks/load_character(var/savefile/S)
	from_file(S["perk"], pref.perk)
	chosen_perk = pref.perk
	perk_info_selected = chosen_perk

/datum/category_item/player_setup_item/perks/save_character(var/savefile/S)
	to_file(S["perk"], chosen_perk)

/datum/category_item/player_setup_item/perks/sanitize_character()


/datum/category_item/player_setup_item/perks/proc/generate_perk_html(var/datum/perk/level/P)
	var/extra_style = ""
	if(P.name == perk_info_selected)
		extra_style = ";background-color: darkcyan;"
	if(P.name == chosen_perk)
		extra_style = ";background-color: green;"
	//this is where the check will go for seeing if we qualify for the perk
	//if(blahblah)
	//	extra_style = ";background-color: gray;"
	return "<div style = 'padding:2px[extra_style]' onclick=\"set('selected_perk', '[P.name]');\" class='block'><b>[P.name]</b></div>"


/datum/category_item/player_setup_item/perks/content(var/mob/user)
	var/dat = list()

	dat += "<style>div.block{margin: 3px 0px;padding: 4px 0px;}"
	dat += "span.color_holder_box{display: inline-block; width: 20px; height: 8px; border:1px solid #000; padding: 0px;}</style>"

	dat +=  "<script language='javascript'> [js_byjax] function set(param, value) {window.location='?src=\ref[src];'+param+'='+value;}</script>"
	dat += "<table style='max-height:400px;height:410px; margin-left:250px; margin-right:250px'>"
	dat += "<tr style='vertical-align:top'>"
	dat += "<td><div style='max-width:230px;width:230px;height:100%;overflow-y:auto;border-right:1px solid;padding:3px'>"
	for(var/datum/perk/level/P as null|anything in GLOB.level_one_perks)
		dat += generate_perk_html(GLOB.level_one_perks[P])
	dat += "</div></td>"
	dat += "<td style='margin-left:10px;width-max:400px;width:400px;'>"
	dat +="<div class = 'roleDescription' style = 'height:400px; width:400px; margin-left:auto; margin-right:auto;'>"
	dat += "<table style='float:left;table-layout: fixed;' cellpadding='0' cellspacing='0'>"
	dat += "<tr>"

	if(perk_info_selected)
		var/datum/perk/level/perk_for_info = GLOB.level_one_perks[perk_info_selected]
		// little preview image
		user << browse_rsc(perk_for_info.img, "perk_image_[perk_info_selected].png")
		dat += "<td style='width: 400px;overflow: hidden;display: inline-block;white-space: nowrap; text-align:center;'><img src='perk_image_[perk_info_selected].png'></td>"

		// stat description
		dat += "<tr>"
		dat += "<td style = 'width: 400px;vertical-align: top;'>"
		dat += "<h1 style='text-align: center;padding-top: 5px;padding-bottom: 0px; width: 400px;'>[perk_for_info.name]</h1>" // stat title
		dat += "<hr>"
		dat += "[perk_for_info.desc]</td></tr>" // description
		if(perk_for_info.req_stats || perk_for_info.req_level > 1)
			dat += "<tr><td><hr><b>Requirements:</b><br>"
			if(perk_for_info.req_level > 1)
				dat += "Level [perk_for_info.req_level]<br>"
			for(var/i in perk_for_info.req_stats)
				dat += "[i] [perk_for_info.req_stats[i]] "
			dat += "</td></tr>"
		dat += "<tr><td><br><center>"
		if(chosen_perk == perk_info_selected)
			dat += "<a class='linkOn' style='width:100px;' href='?src=\ref[src];choose_perk=[perk_info_selected];'>Selected</a></center>"
		else
			dat += "<a style='width:100px;' href='?src=\ref[src];choose_perk=[perk_info_selected];'>Select</a></center>"
		dat += "</table>"

	dat += "</div></td></tr></tr></table>"

	return jointext(dat,null)

/datum/category_item/player_setup_item/perks/OnTopic(var/href,var/list/href_list, var/mob/user)
	pref.categoriesChanged = "Perks"

	if(href_list["selected_perk"])
		perk_info_selected = href_list["selected_perk"]
		return TOPIC_REFRESH
	if(href_list["choose_perk"])
		chosen_perk = href_list["choose_perk"]
		return TOPIC_REFRESH
