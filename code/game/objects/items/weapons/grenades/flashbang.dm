/obj/item/grenade/flashbang
	name = "Seinemetall Defense GmbH FBG \"Serra\""
	desc = "A \"Serra\" flashbang grenade. If in any doubt - use it."
	description_info = "Will stun anyone using thermals from double the distance for a normal person, through walls"
	icon_state = "flashbang"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	var/banglet = 0
	matter = list(MATERIAL_STEEL = 2, MATERIAL_SILVER = 1)

/obj/item/grenade/flashbang/prime()
	..()
	for(var/obj/structure/closet/L in hear(7, get_turf(src)))
		if(locate(/mob/living/carbon/, L))
			for(var/mob/living/carbon/M in L)
				flashbang_bang(get_turf(src), M)


	for(var/mob/living/carbon/M in hear(7, get_turf(src)))
		flashbang_bang(get_turf(src), M)

	for(var/mob/living/carbon/human/thermal_user in orange(9, loc))
		if(!thermal_user.glasses)
			return
		var/obj/item/clothing/glasses/potential_thermals = thermal_user.glasses
		if(potential_thermals.overlays == global_hud.thermal)
			flashbang_without_the_bang(get_turf(src), thermal_user)

	for(var/obj/effect/blob/B in hear(8,get_turf(src)))	//Blob damage here
		var/damage = round(30/(get_dist(B,get_turf(src))+1))
		B.take_damage(damage)
		B.update_icon()

	new/obj/effect/sparks(loc)
	new/obj/effect/effect/smoke/illumination(loc, brightness=15)
	qdel(src)

/obj/item/proc/flashbang_without_the_bang(turf/T, mob/living/carbon/M) //Flashbang_bang but bang-less.
	//This really should be in mob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.flash(3, FALSE , TRUE , TRUE, 15)
	else
		M.flash(5, FALSE, TRUE , TRUE)
	M.stats.addTempStat(SPECIAL_A, -3, 10 SECONDS, "flashbang")
	M.stats.addTempStat(SPECIAL_P, -5, 10 SECONDS, "flashbang")
	M.update_icons()

/obj/item/proc/flashbang_bang(var/turf/T, var/mob/living/carbon/M, var/explosion_text = "BANG", var/stat_reduction = TRUE, var/intensity = FALSE) //Bang made into an item proc so lot's of stuff can use it wtihout copy - paste
	to_chat(M, SPAN_DANGER(explosion_text))								// Called during the loop that bangs people in lockers/containers and when banging
	playsound(loc, 'sound/effects/bang.ogg', 50, 1, 5)		// people in normal view.  Could theroetically be called during other explosions.
																// -- Polymorph

//Checking for protections
	var/eye_safety = 0
	var/ear_safety = 0
	var/extra_stat_loss = 0
	if(iscarbon(M))
		eye_safety = M.eyecheck()
		if(ishuman(M))
			if(istype(M:l_ear, /obj/item/clothing/ears/earmuffs) || istype(M:r_ear, /obj/item/clothing/ears/earmuffs))
				ear_safety += 2
			if(istype(M:l_ear, /obj/item/device/radio/headset/headset_sec/bowman) || istype(M:r_ear, /obj/item/device/radio/headset/headset_sec/bowman))
				ear_safety += 2
			if(istype(M:l_ear, /obj/item/device/radio/headset/heads/hos/bowman) || istype(M:r_ear, /obj/item/device/radio/headset/heads/hos/bowman))
				ear_safety += 2
//			if(HULK in M.mutations)
//				ear_safety += 1
			if(istype(M:head, /obj/item/clothing/head/helmet))
				ear_safety += 1
	if(intensity)
		eye_safety += 1

//Flashing everyone
	if(eye_safety < FLASH_PROTECTION_MODERATE)
		M.flash(3, FALSE , TRUE , TRUE , 15 - (15*eye_safety))

//Now applying sound
	var/flash_distance
	var/bang_intensity

	if(loc == M.loc || loc == M)
		flash_distance = 0
	else
		flash_distance = get_dist(M, T) + ear_safety

	switch(flash_distance)
		if(-INFINITY to 3)
			bang_intensity = 1
		if(3 to 6)
			bang_intensity = 2
		if(6 to INFINITY)
			bang_intensity = 3

	if(intensity)
		bang_intensity += intensity

	switch(bang_intensity)
		if(1)
			if(ear_safety <= 0)
				extra_stat_loss = 3
				if ((prob(14) || (M == loc && prob(70))))
					M.adjustEarDamage(rand(1, 10))
					M.confused = max(M.confused,8)
				else
					M.adjustEarDamage(rand(0, 5))
					M.ear_deaf = max(M.ear_deaf,15)
					M.confused = max(M.confused,8)
			else
				extra_stat_loss = 2
				M.confused = max(M.confused,4)
		if(2)
			if(ear_safety <= 0)
				extra_stat_loss = 2
				M.adjustEarDamage(rand(0, 3))
				M.ear_deaf = max(M.ear_deaf,10)
				M.confused = max(M.confused,6)
			else
				M.confused = max(M.confused,2)
		if(3)
			extra_stat_loss = 1
			M.adjustEarDamage(rand(0, 1))
			M.ear_deaf = max(M.ear_deaf,5)
			M.confused = max(M.confused,5)

	//This really should be in mob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.random_organ_by_process(OP_EYES)
		if (E && E.damage >= E.min_bruised_damage)
			to_chat(M, SPAN_DANGER("Your eyes start to burn badly!"))
	if (M.ear_damage >= 15)
		to_chat(M, SPAN_DANGER("Your ears start to ring badly!"))
	else
		if (M.ear_damage >= 5)
			to_chat(M, SPAN_DANGER("Your ears start to ring!"))
	if(stat_reduction)
		M.stats.addTempStat(SPECIAL_A, -3 - extra_stat_loss, 10 SECONDS, "flashbang")
		M.stats.addTempStat(SPECIAL_P, -5 - extra_stat_loss, 10 SECONDS, "flashbang")
	M.update_icons()
