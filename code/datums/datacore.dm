var/global/list/PDA_Manifest = list()
var/global/ManifestJSON

/hook/startup/proc/createDatacore()
	data_core = new /datum/datacore()
	return 1

/datum/datacore
	var/name = "datacore"
	var/medical[] = list()
	var/general[] = list()
	var/security[] = list()
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/locked[] = list()


/datum/datacore/proc/get_manifest(monochrome, OOC)
	var/list/heads = new()
	var/list/www = new()
	var/list/skm = new()
	var/list/fol = new()
	var/list/tri = new()
	var/list/was = new()
	var/list/rai = new()
	var/list/bos = new()
	var/list/misc = new()
	var/list/isactive = new()
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome?"black":"#DEF; background-color:white; color:black"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: #48C; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: #488;"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: #DEF"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Rank</th><th>Activity</th></tr>
	"}
	var/even = 0
	// sort mobs
	for(var/datum/data/record/t in data_core.general)
		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		var/real_rank = make_list_rank(t.fields["real_rank"])

		if(OOC)
			var/active = 0
			for(var/mob/M in GLOB.player_list)
				if(M.real_name == name && M.client && M.client.inactivity <= 10 * 60 * 10)
					active = 1
					break
			isactive[name] = active ? "Active" : "Inactive"
		else
			isactive[name] = t.fields["p_stat"]
			//world << "[name]: [rank]"
			//cael - to prevent multiple appearances of a player/job combination, add a continue after each line
		var/department = 0
		if(real_rank in command_positions)
			heads[name] = rank
			department = 1
		if(real_rank in wayward_positions)
			www[name] = rank
			department = 1
		if(real_rank in skymarshal_positions)
			skm[name] = rank
			department = 1
		if(real_rank in followers_positions)
			fol[name] = rank
			department = 1
		if(real_rank in tribe_positions)
			tri[name] = rank
			department = 1
		if(real_rank in wastelander_positions)
			was[name] = rank
			department = 1
		if(real_rank in raider_positions)
			rai[name] = rank
			department = 1
		if(real_rank in bos_positions)
			bos[name] = rank
			department = 1
		if(!department && !(name in heads))
			misc[name] = rank

	// Synthetics don't have actual records, so we will pull them from here.
/*	for(var/mob/living/silicon/ai/ai in SSmobs.mob_list)
		bot[ai.name] = "Artificial Intelligence"

	for(var/mob/living/silicon/robot/robot in SSmobs.mob_list)
		// No combat/syndicate cyborgs, no drones.
		if(robot.module && robot.module.hide_on_manifest)
			continue

		bot[robot.name] = "[robot.modtype] [robot.braintype]"*/
	/*
	if(bot.len > 0)
		dat += "<tr><th colspan=3>Silicon</th></tr>"
		for(name in bot)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[bot[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	*/
	if(heads.len > 0)
		dat += "<tr><th colspan=3>Heads</th></tr>"
		for(name in heads)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[heads[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(www.len > 0)
		dat += "<tr><th colspan=3>Wayward Winds</th></tr>"
		for(name in www)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[www[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(skm.len > 0)
		dat += "<tr><th colspan=3>Sky Marshals</th></tr>"
		for(name in skm)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[skm[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(fol.len > 0)
		dat += "<tr><th colspan=3>Followers of the Apocalypse</th></tr>"
		for(name in fol)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[fol[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(tri.len > 0)
		dat += "<tr><th colspan=3>Placeholder Tribe</th></tr>"
		for(name in tri)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[tri[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(was.len > 0)
		dat += "<tr><th colspan=3>Wastelanders</th></tr>"
		for(name in was)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[was[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(rai.len > 0)
		dat += "<tr><th colspan=3>Raiders</th></tr>"
		for(name in rai)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[rai[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(bos.len > 0)
		dat += "<tr><th colspan=3>Brotherhood Outcasts</th></tr>"
		for(name in bos)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[bos[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(misc.len > 0)
		dat += "<tr><th colspan=3>Miscellaneous</th></tr>"
		for(name in misc)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[misc[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even

	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/datum/datacore/proc/manifest()
	spawn()
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			manifest_inject(H)
		return

/datum/datacore/proc/manifest_modify(var/name, var/assignment)
	ResetPDAManifest()
	var/datum/data/record/foundrecord
	var/real_title = assignment

	for(var/datum/data/record/t in data_core.general)
		if (t)
			if(t.fields["name"] == name)
				foundrecord = t
				break

	if(foundrecord)
		foundrecord.fields["rank"] = assignment
		foundrecord.fields["real_rank"] = real_title

/datum/datacore/proc/manifest_inject(var/mob/living/carbon/human/H)
	if(H.mind && !player_is_antag(H.mind, only_offstation_roles = 1))
		var/assignment = GetAssignment(H)

		var/id = generate_record_id()
		//General Record
		var/datum/data/record/G = CreateGeneralRecord(H, id)
		G.fields["name"]		= H.real_name
		G.fields["real_rank"]	= H.mind.assigned_role
		G.fields["rank"]		= assignment
		G.fields["age"]			= H.age
		G.fields["fingerprint"]	= md5(H.dna.uni_identity)
		if(H.mind.initial_account)
			G.fields["pay_account"]	= H.mind.initial_account.account_number
		G.fields["email"]		= H.mind.initial_email_login["login"]
		G.fields["p_stat"]		= "Active"
		G.fields["m_stat"]		= "Stable"
		G.fields["sex"]			= H.gender
		if(H.gen_record && !jobban_isbanned(H, "Records"))
			G.fields["notes"] = H.gen_record

		//Medical Record
		var/datum/data/record/M = CreateMedicalRecord(H.real_name, id)
		M.fields["b_type"]		= H.b_type
		M.fields["b_dna"]		= H.dna.unique_enzymes
		//M.fields["id_gender"]	= gender2text(H.identifying_gender)
		if(H.med_record && !jobban_isbanned(H, "Records"))
			M.fields["notes"] = H.med_record

		//Security Record
		var/datum/data/record/S = CreateSecurityRecord(H.real_name, id)
		if(H.sec_record && !jobban_isbanned(H, "Records"))
			S.fields["notes"] = H.sec_record

		//Locked Record
		var/datum/data/record/L = new()
		L.fields["id"]			= md5("[H.real_name][H.mind.assigned_role]")
		L.fields["name"]		= H.real_name
		L.fields["rank"] 		= H.mind.assigned_role
		L.fields["age"]			= H.age
		L.fields["fingerprint"]	= md5(H.dna.uni_identity)
		L.fields["sex"]			= H.gender
		///L.fields["id_gender"]	= gender2text(H.identifying_gender)
		L.fields["b_type"]		= H.b_type
		L.fields["b_dna"]		= H.dna.unique_enzymes
		L.fields["enzymes"]		= H.dna.SE // Used in respawning
		L.fields["identity"]	= H.dna.UI // "
		L.fields["image"]		= getFlatIcon(H)	//This is god-awful
		if(H.exploit_record && !jobban_isbanned(H, "Records"))
			L.fields["exploit_record"] = H.exploit_record
		else
			L.fields["exploit_record"] = "No additional information acquired."
		locked += L
	return

/proc/generate_record_id()
	return add_zero(num2hex(rand(1, 65535)), 4)	//no point generating higher numbers because of the limitations of num2hex

/proc/get_id_photo(var/mob/living/carbon/human/H, var/assigned_role)

	var/icon/preview_icon = new(H.stand_icon)
	var/icon/temp

	var/datum/sprite_accessory/hair_style = GLOB.hair_styles_list[H.h_style]
	if(hair_style)
		temp = new/icon(hair_style.icon, hair_style.icon_state)
		temp.Blend(H.hair_color, ICON_ADD)

	hair_style = GLOB.facial_hair_styles_list[H.h_style]
	if(hair_style)
		var/icon/facial = new/icon(hair_style.icon, hair_style.icon_state)
		facial.Blend(H.facial_color, ICON_ADD)
		temp.Blend(facial, ICON_OVERLAY)

	preview_icon.Blend(temp, ICON_OVERLAY)


	var/datum/job/J = SSjob.GetJob(H.mind.assigned_role)
	if(J)
		var/t_state
		temp = new /icon(H.form.get_mob_icon("uniform", t_state), t_state)

		temp.Blend(new /icon(H.form.get_mob_icon("shoes", t_state), t_state), ICON_OVERLAY)
	else
		temp = new /icon(H.form.get_mob_icon("uniform", "grey"), "grey")
		temp.Blend(new /icon(H.form.get_mob_icon("shoes", "black"), "black"), ICON_OVERLAY)

	preview_icon.Blend(temp, ICON_OVERLAY)

	qdel(temp)

	return preview_icon

/datum/datacore/proc/CreateGeneralRecord(var/mob/living/carbon/human/H, var/id)
	ResetPDAManifest()
	var/icon/front
	var/icon/side
	if(H)
		front = getFlatIcon(H, SOUTH)
		side = getFlatIcon(H, WEST)
	else
		var/mob/living/carbon/human/dummy = new()
		front = new(get_id_photo(dummy), dir = SOUTH)
		side = new(get_id_photo(dummy), dir = WEST)
		qdel(dummy)

	if(!id) id = text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
	var/datum/data/record/G = new /datum/data/record()
	G.name = "Employee Record #[id]"
	G.fields["name"] = "New Record"
	G.fields["id"] = id
	G.fields["rank"] = "Unassigned"
	G.fields["real_rank"] = "Unassigned"
	G.fields["sex"] = "Male"
	G.fields["age"] = "Unknown"
	G.fields["fingerprint"] = "Unknown"
	G.fields["p_stat"] = "Active"
	G.fields["m_stat"] = "Stable"
	G.fields["species"] = "Human"
	G.fields["photo_front"]	= front
	G.fields["photo_side"]	= side
	G.fields["notes"] = "No notes found."
	general += G

	return G

/datum/datacore/proc/CreateSecurityRecord(var/name, var/id)
	ResetPDAManifest()
	var/datum/data/record/R = new /datum/data/record()
	R.name = "Security Record #[id]"
	R.fields["name"] = name
	R.fields["id"] = id
	R.fields["criminal"]	= "None"
	R.fields["mi_crim"]		= "None"
	R.fields["mi_crim_d"]	= "No minor crime convictions."
	R.fields["ma_crim"]		= "None"
	R.fields["ma_crim_d"]	= "No major crime convictions."
	R.fields["notes"]		= "No notes."
	R.fields["notes"] = "No notes."
	data_core.security += R

	return R

/datum/datacore/proc/CreateMedicalRecord(var/name, var/id)
	ResetPDAManifest()
	var/datum/data/record/M = new()
	M.name = "Medical Record #[id]"
	M.fields["id"]			= id
	M.fields["name"]		= name
	M.fields["b_type"]		= "AB+"
	M.fields["b_dna"]		= md5(name)
	M.fields["mi_dis"]		= "None"
	M.fields["mi_dis_d"]	= "No minor disabilities have been declared."
	M.fields["ma_dis"]		= "None"
	M.fields["ma_dis_d"]	= "No major disabilities have been diagnosed."
	M.fields["alg"]			= "None"
	M.fields["alg_d"]		= "No allergies have been detected in this patient."
	M.fields["cdi"]			= "None"
	M.fields["cdi_d"]		= "No diseases have been diagnosed at the moment."
	M.fields["notes"] = "No notes found."
	data_core.medical += M

	return M

/datum/datacore/proc/ResetPDAManifest()
	if(PDA_Manifest.len)
		PDA_Manifest.Cut()

/proc/find_general_record(field, value)
	return find_record(field, value, data_core.general)

/proc/find_medical_record(field, value)
	return find_record(field, value, data_core.medical)

/proc/find_security_record(field, value)
	return find_record(field, value, data_core.security)

/*/proc/GetAssignment(var/mob/living/carbon/human/H)
	if(H.mind.assigned_role)
		return H.mind.assigned_role
	else if(H.job)
		return H.job
	else
		return "Unassigned"
*/
/var/list/acting_rank_prefixes = list("acting", "temporary", "interim", "provisional")

/proc/make_list_rank(rank)
	for(var/prefix in acting_rank_prefixes)
		if(findtext(rank, "[prefix] ", 1, 2+length(prefix)))
			return copytext(rank, 2+length(prefix))
	return rank

/datum/datacore/proc/get_manifest_json()
	if(PDA_Manifest.len)
		return
	var/heads[0]
	var/www[0]
	var/skm[0]
	var/fol[0]
	var/tri[0]
	var/was[0]
	var/rai[0]
	var/bos[0]
	var/misc[0]
	for(var/datum/data/record/t in data_core.general)
		var/name = sanitize(t.fields["name"])
		var/rank = sanitize(t.fields["rank"])
		var/real_rank = make_list_rank(t.fields["real_rank"])

		var/isactive = t.fields["p_stat"]
		var/department = 0
		var/depthead = 0 			// Department Heads will be placed at the top of their lists.
		if(real_rank in command_positions)
			heads[++heads.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			depthead = 1
			if(rank=="Premier" && heads.len != 1)
				heads.Swap(1, heads.len)

		if(real_rank in wayward_positions)
			www[++www.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && www.len != 1)
				www.Swap(1, www.len)

		if(real_rank in skymarshal_positions)
			skm[++skm.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && skm.len != 1)
				skm.Swap(1, skm.len)

		if(real_rank in followers_positions)
			fol[++fol.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && fol.len != 1)
				fol.Swap(1, fol.len)

		if(real_rank in tribe_positions)
			tri[++tri.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && tri.len != 1)
				tri.Swap(1, tri.len)

		if(real_rank in wastelander_positions)
			was[++was.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && was.len != 1)
				was.Swap(1, was.len)

		if(real_rank in raider_positions)
			rai[++rai.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && rai.len != 1)
				rai.Swap(1, rai.len)

		if(real_rank in bos_positions)
			bos[++bos.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && bos.len != 1)
				bos.Swap(1, bos.len)

		/*
		if(real_rank in nonhuman_positions)
			bot[++bot.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
		*/

		if(!department && !(name in heads))
			misc[++misc.len] = list("name" = name, "rank" = rank, "active" = isactive)


	PDA_Manifest = list(
		"heads" = heads,
		"www" = www,
		"skm" = skm,
		"fol" = fol,
		"tri" = tri,
		"bos" = bos,
		"was" = was,
		"rai" = rai,
		"misc" = misc
		)
	ManifestJSON = json_encode(PDA_Manifest)
	return
