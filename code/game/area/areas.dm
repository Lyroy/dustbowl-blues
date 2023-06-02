#define STARTUP_STAGE 1
#define MAIN_STAGE 2
#define WIND_DOWN_STAGE 3
#define END_STAGE 4
//weather defines

// Areas.dm

// ===
/area
	var/global/global_uid = 0
	var/uid
	var/tmp/camera_id = 0 // For automatic c_tag setting
	//Keeping this on the default plane, GAME_PLANE, will make area underlays fail to render on FLOOR_PLANE.
	plane = BLACKNESS_PLANE
	layer = AREA_LAYER
	var/ship_area = FALSE

	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0
	var/static_equip
	var/static_light = 0
	var/static_environ
	var/force_full_lighting = FALSE

	/// For space, the asteroid, lavaland, etc. Used with blueprints or with weather to determine if we are adding a new area (vs editing a station room)
	var/outdoors = FALSE

	/// Is this area considered underground? As in, is it not the top most Z level of a map? Used for determining if the day/night system should touch this area.
	var/underground = FALSE

	/// A normally empty cache used to store turf adjacencies for day/night lighting effects.
	var/list/adjacent_day_night_turf_cache

	/// This caches the openspace turfs above this area that get updated whenever the day/night lighting changes
	var/list/open_over_area_day_night

/**
 * Called when an area loads
 */
/area/New()
	uid = ++global_uid
	all_areas += src
	if (ship_area)
		ship_areas[src] = TRUE //Adds ourselves to the list of all ship areas

	// Some atoms would like to use power in Initialize()
	if(!requires_power)
		power_light = 0
		power_equip = 0
		power_environ = 0

	sanity = new(src)

	return ..()

/*
 * Initalize this area
 *
 * returns INITIALIZE_HINT_LATELOAD
 */
/area/Initialize()
	icon_state = ""

	if(!requires_power || !apc)
		power_light = 0
		power_equip = 0
		power_environ = 0

	. = ..()

	return INITIALIZE_HINT_LATELOAD

/**
 * Sets machine power levels in the area
 */
/area/LateInitialize()
	power_change() // all machines set to current power level, also updates icon

/area/proc/get_cameras()
	var/list/cameras = list()
	for (var/obj/machinery/camera/C in src)
		cameras += C
	return cameras

/area/proc/get_camera_tag(var/obj/machinery/camera/C)
	return "[name] #[camera_id++]"

/area/proc/atmosalert(danger_level, var/alarm_source)
	if (danger_level == 0)
		atmosphere_alarm.clearAlarm(src, alarm_source)
	else
		atmosphere_alarm.triggerAlarm(src, alarm_source, severity = danger_level)

	//Check all the alarms before lowering atmosalm. Raising is perfectly fine.
	for (var/obj/machinery/alarm/AA in src)
		if (!(AA.stat & (NOPOWER|BROKEN)) && !AA.shorted && AA.report_danger_level)
			danger_level = max(danger_level, AA.danger_level)

	if(danger_level != atmosalm)
		if (danger_level < 1 && atmosalm >= 1)
			//closing the doors on red and opening on green provides a bit of hysteresis that will hopefully prevent fire doors from opening and closing repeatedly due to noise
			air_doors_open()
		else if (danger_level >= 2 && atmosalm < 2)
			air_doors_close()

		atmosalm = danger_level
		for (var/obj/machinery/alarm/AA in src)
			AA.update_icon()

		return 1
	return 0

/area/proc/air_doors_close()
	if(!air_doors_activated)
		air_doors_activated = 1
		for(var/obj/machinery/door/firedoor/D in all_doors)
			spawn()
				D.close()

/area/proc/air_doors_open()
	if(air_doors_activated)
		air_doors_activated = 0
		for(var/obj/machinery/door/firedoor/D in all_doors)
			spawn()
				D.open()


/area/proc/fire_alert()
	if(!fire)
		fire = 1	//used for firedoor checks
		updateicon()
		mouse_opacity = 0
		for(var/obj/machinery/door/firedoor/D in all_doors)
			spawn()
				D.close()

/area/proc/fire_reset()
	if (fire)
		fire = 0	//used for firedoor checks
		updateicon()
		mouse_opacity = 0
		for(var/obj/machinery/door/firedoor/D in all_doors)
			spawn()
				D.open()

/area/proc/readyalert()
	if(!eject)
		eject = 1
		updateicon()
	return

/area/proc/readyreset()
	if(eject)
		eject = 0
		updateicon()
	return

/area/proc/partyalert()
	if (!( party ))
		party = 1
		updateicon()
		mouse_opacity = 0
	return

/area/proc/partyreset()
	if (party)
		party = 0
		mouse_opacity = 0
		updateicon()
		for(var/obj/machinery/door/firedoor/D in src)
			D.open()
	return

/area/proc/updateicon()

	///////weather
/*
	var/weather_icon
	for(var/V in SSweather.processing)
		var/datum/weather/W = V
		if(W.stage != END_STAGE && (src in get_areas(/area)))
			W.update_areas()
			weather_icon = TRUE
	if(!weather_icon)
		icon_state = null
*/
	////////////weather

	if ((fire || eject || party || atmosalm == 2) && (!requires_power||power_environ) && !istype(src, /area/space))//If it doesn't require power, can still activate this proc.
		if(fire)
			for(var/obj/machinery/light/L in src)
				if(istype(L, /obj/machinery/light/small))
					continue
				L.set_red()
		else if (atmosalm == 2)
			for(var/obj/machinery/light/L in src)
				if(istype(L, /obj/machinery/light/small))
					continue
				L.set_blue()
		else if(!fire && eject && !party && !(atmosalm == 2))
			for(var/obj/machinery/light/L in src)
				if(istype(L, /obj/machinery/light/small))
					continue
				L.set_red()
		else if(party && !fire && !eject && !(atmosalm == 2))
			icon_state = "party"
	else
	//	new lighting behaviour with obj lights
		icon_state = null
		for(var/obj/machinery/light/L in src)
			if(istype(L, /obj/machinery/light/small))
				continue
			L.reset_color()


/*
#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
*/

/area/proc/powered(var/chan)		// return true if the area has power to given channel

	if(!requires_power)
		return 1
	if(always_unpowered)
		return 0
	switch(chan)
		if(STATIC_EQUIP)
			return power_equip
		if(STATIC_LIGHT)
			return power_light
		if(STATIC_ENVIRON)
			return power_environ

	return 0

// called when power status changes
/area/proc/power_change()
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change()			// reverify power status (to update icons etc.)
	SEND_SIGNAL(src, COMSIG_AREA_APC_POWER_CHANGE)
	if (fire || eject || party)
		updateicon()

/area/proc/usage(var/chan)
	var/used = 0
	switch(chan)
		if(TOTAL)
			used += static_light + static_equip + static_environ + used_equip + used_light + used_environ
		if(STATIC_EQUIP)
			used += static_equip + used_equip
		if(STATIC_LIGHT)
			used += static_light + used_light
		if(STATIC_ENVIRON)
			used += static_environ + used_environ
	return used

/area/proc/addStaticPower(value, powerchannel)
	switch(powerchannel)
		if(STATIC_EQUIP)
			static_equip += value
		if(STATIC_LIGHT)
			static_light += value
		if(STATIC_ENVIRON)
			static_environ += value

/area/proc/removeStaticPower(value, powerchannel)
	addStaticPower(-value, powerchannel)

/area/proc/clear_usage()
	used_equip = 0
	used_light = 0
	used_environ = 0

/area/proc/use_power(var/amount, var/chan)
	switch(chan)
		if(STATIC_EQUIP)
			used_equip += amount
		if(STATIC_LIGHT)
			used_light += amount
		if(STATIC_ENVIRON)
			used_environ += amount


var/list/mob/living/forced_ambiance_list = new

/area/Entered(A)
	if(!isliving(A))
		return

	var/mob/living/L = A
	if(!L.ckey)	return

	if(!L.lastarea)
		L.lastarea = get_area(L.loc)
	var/area/newarea = get_area(L.loc)
	var/area/oldarea = L.lastarea
	if(oldarea.has_gravity != newarea.has_gravity)
		if(newarea.has_gravity == 1 && !MOVING_DELIBERATELY(L)) // Being ready when you change areas allows you to avoid falling.
			thunk(L)
		L.update_floating()

	L.lastarea = newarea
	play_ambience(L)

/area/proc/play_ambience(var/mob/living/L)
    // Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(!(L && L.client && L.get_preference_value(/datum/client_preference/play_ambiance) == GLOB.PREF_YES))    return

	var/client/CL = L.client

	if(CL.ambience_playing) // If any ambience already playing
		if(forced_ambience && forced_ambience.len)
			if(CL.ambience_playing in forced_ambience)
				return 1
			else
				var/new_ambience = pick(pick(forced_ambience))
				CL.ambience_playing = new_ambience
				sound_to(L, sound(new_ambience, repeat = 1, wait = 0, volume = 30, channel = GLOB.ambience_sound_channel))
				return 1
		if(CL.ambience_playing in ambience)
			return 1

	if(ambience.len && prob(35))
		if(world.time >= L.client.played + 600)
			var/sound = pick(ambience)
			CL.ambience_playing = sound
			sound_to(L, sound(sound, repeat = 0, wait = 0, volume = 10, channel = GLOB.ambience_sound_channel))
			L.client.played = world.time
			return 1
	else
		var/sound = 'sound/ambience/shipambience.ogg'
		CL.ambience_playing = sound
		sound_to(L, sound(sound, repeat = 1, wait = 0, volume = 30, channel = GLOB.ambience_sound_channel))


//Figures out what gravity should be and sets it appropriately
/area/proc/update_gravity()
	var/grav_before = has_gravity
	if(gravity_blocker)
		if(get_area(gravity_blocker) == src)
			has_gravity = FALSE
			if (grav_before != has_gravity)
				gravity_changed()
			return
		else
			gravity_blocker = null

	/*if (GLOB.active_gravity_generator)
		has_gravity = gravity_is_on*/

	if (grav_before != has_gravity)
		gravity_changed()



//Called when the gravity state changes
/area/proc/gravity_changed()
	for(var/mob/M in src)
		if(has_gravity)
			thunk(M)
		M.update_floating()

//This thunk should probably not be an area proc.
//TODO: Make it a mob proc
/area/proc/thunk(mob)
	if(istype(get_turf(mob), /turf/space)) // Can't fall onto nothing.
		return

	if(istype(mob,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = mob
		if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.item_flags & NOSLIP))
			return
		if(MOVING_QUICKLY(H))
			H.AdjustStunned(2)
			H.AdjustWeakened(2)
		else
			H.AdjustStunned(1)
			H.AdjustWeakened(1)
		to_chat(mob, SPAN_NOTICE("The sudden appearance of gravity makes you fall to the floor!"))

/area/proc/prison_break()
	var/obj/machinery/power/apc/theAPC = get_apc()
	if(theAPC.operating)
		for(var/obj/machinery/power/apc/temp_apc in src)
			temp_apc.overload_lighting(70)
		for(var/obj/machinery/door/airlock/temp_airlock in src)
			temp_airlock.prison_open()
		for(var/obj/machinery/door/window/temp_windoor in src)
			temp_windoor.open()

/area/proc/has_gravity()
	return has_gravity

/area/space/has_gravity()
	return 0

/area/proc/are_living_present()
	for(var/mob/living/L in src)
		if(L.stat != DEAD)
			return TRUE
	return FALSE

/proc/has_gravity(atom/AT, turf/T)
	if(!T)
		T = get_turf(AT)
	var/area/A = get_area(T)
	if(A && A.has_gravity())
		return 1
	return 0


/area/proc/set_ship_area()
	if (!ship_area)
		ship_area = TRUE
		ship_areas[src] = TRUE

/area/AllowDrop()
	CRASH("Bad op: area/AllowDrop() called")

/area/drop_location()
	CRASH("Bad op: area/drop_location() called")

/area/Destroy()
	clear_adjacent_turfs()
	//parent cleanup
	return ..()

// Day night stuff
/**
 * This will calculate all adjacent turfs in this area and add them to a cache for lighting effects.
 *
 * WARNING: This proc is VERY expensive and should be used sparingly.
 */
/area/proc/initialize_day_night_adjacent_turfs()
	LAZYCLEARLIST(adjacent_day_night_turf_cache)
	LAZYINITLIST(adjacent_day_night_turf_cache)

	for(var/turf/iterating_turf as anything in get_area_turfs(src.type))
		var/direction_bitfield = NONE
		var/area/target_area = null

		for(var/bit_step in ALL_JUNCTION_DIRECTIONS)
			var/turf/target_turf
			switch(bit_step)
				if(NORTH_JUNCTION)
					target_turf = locate(iterating_turf.x, iterating_turf.y + 1, iterating_turf.z)
				if(SOUTH_JUNCTION)
					target_turf = locate(iterating_turf.x, iterating_turf.y - 1, iterating_turf.z)
				if(EAST_JUNCTION)
					target_turf = locate(iterating_turf.x + 1, iterating_turf.y, iterating_turf.z)
				if(WEST_JUNCTION)
					target_turf = locate(iterating_turf.x - 1, iterating_turf.y, iterating_turf.z)
				if(NORTHEAST_JUNCTION)
					if(direction_bitfield & NORTH_JUNCTION || direction_bitfield & EAST_JUNCTION)
						continue
					target_turf = locate(iterating_turf.x + 1, iterating_turf.y + 1, iterating_turf.z)
				if(SOUTHEAST_JUNCTION)
					if(direction_bitfield & SOUTH_JUNCTION || direction_bitfield & EAST_JUNCTION)
						continue
					target_turf = locate(iterating_turf.x + 1, iterating_turf.y - 1, iterating_turf.z)
				if(SOUTHWEST_JUNCTION)
					if(direction_bitfield & SOUTH_JUNCTION || direction_bitfield & WEST_JUNCTION)
						continue
					target_turf = locate(iterating_turf.x - 1, iterating_turf.y - 1, iterating_turf.z)
				if(NORTHWEST_JUNCTION)
					if(direction_bitfield & NORTH_JUNCTION || direction_bitfield & WEST_JUNCTION)
						continue
					target_turf = locate(iterating_turf.x - 1, iterating_turf.y + 1, iterating_turf.z)
			if(!target_turf)
				continue
			var/area/temp_area = target_turf.loc
			if(temp_area == src)
				continue
			if(!temp_area.outdoors || temp_area.underground)
				continue
			direction_bitfield ^= bit_step
			target_area = temp_area

		if(!direction_bitfield)
			continue
		adjacent_day_night_turf_cache[iterating_turf] = list(DAY_NIGHT_TURF_INDEX_BITFIELD, DAY_NIGHT_TURF_INDEX_APPEARANCE)
		adjacent_day_night_turf_cache[iterating_turf][DAY_NIGHT_TURF_INDEX_BITFIELD] = direction_bitfield
		RegisterSignal(iterating_turf, COMSIG_PARENT_QDELETING, PROC_REF(clear_adjacent_turf))
		if(iterating_turf.lighting_overlay)
			iterating_turf.lighting_overlay.day_night_area = target_area

	UNSETEMPTY(adjacent_day_night_turf_cache)

/**
 * Completely clears any adjacent turfs from the area while removing the effect.
 */
/area/proc/clear_adjacent_turfs()
	for(var/turf/iterating_turf as anything in adjacent_day_night_turf_cache)
		clear_adjacent_turf(iterating_turf)
	adjacent_day_night_turf_cache = null

/**
 * Clears a signle turf from the adjacency turf cache.
 * Arguments:
 * * turf_to_clear - The turf we will unregister with and clear of any effects.
 */
/area/proc/clear_adjacent_turf(turf/turf_to_clear)
	SIGNAL_HANDLER

	turf_to_clear.underlays -= adjacent_day_night_turf_cache[turf_to_clear][DAY_NIGHT_TURF_INDEX_APPEARANCE]
	adjacent_day_night_turf_cache -= turf_to_clear
	UnregisterSignal(turf_to_clear, COMSIG_PARENT_QDELETING)

/**
 * A handler to set all adjacent turfs to the correct lighting.
 */
/area/proc/apply_day_night_turfs(datum/day_night_controller/incoming_controller)
	SIGNAL_HANDLER

	if(!incoming_controller)
		return

	for(var/turf/iterating_turf as anything in adjacent_day_night_turf_cache)
		iterating_turf.underlays -= adjacent_day_night_turf_cache[iterating_turf][DAY_NIGHT_TURF_INDEX_APPEARANCE]
		var/mutable_appearance/appearance_to_add = mutable_appearance(
			icon = 'icons/effects/daynight_blend.dmi',
			icon_state = "[adjacent_day_night_turf_cache[iterating_turf][DAY_NIGHT_TURF_INDEX_BITFIELD]]",
			layer = DAY_NIGHT_LIGHTING_LAYER,
			plane = LIGHTING_PLANE,
			alpha = incoming_controller.current_light_alpha,
			appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
		)
		appearance_to_add.color = incoming_controller.current_light_color
		if(incoming_controller.current_luminosity)
			iterating_turf.luminosity = incoming_controller.current_luminosity
		iterating_turf.underlays += appearance_to_add
		adjacent_day_night_turf_cache[iterating_turf][DAY_NIGHT_TURF_INDEX_APPEARANCE] = appearance_to_add

/**
 * Used to update the area regarding day and night adjacency turfs.
 *
 * Use this to update the area if changes need to be made.
 * Arguments:
 * * initialize_turfs - This will call the expensive proc initialize_day_night_adjacent_turfs, recalculating all of the turfs after clearing them.
 * * search_for_controller - This will make us look for a controller in our new z-level, and set us up to it if needed.
 * * incoming_controller - The controller that is updating this areas lighting.
 */
/area/proc/update_day_night_turfs(initialize_turfs = FALSE, search_for_controller = FALSE, datum/day_night_controller/incoming_controller)
	if(search_for_controller)
		for(var/datum/day_night_controller/iterating_controller in SSday_night.cached_controllers)
			if(z in iterating_controller.affected_z_levels)
				if(outdoors)
					iterating_controller.register_affected_area(src)
				else
					iterating_controller.register_unaffected_area(src)
	if(initialize_turfs)
		if(adjacent_day_night_turf_cache)
			clear_adjacent_turfs()
		initialize_day_night_adjacent_turfs()
	if(incoming_controller)
		apply_day_night_turfs(incoming_controller)

/*
* Used to add the open turfs above an outdoors area to a cache, so they can be updated with the area's underlay whenever it gets updated.
*
* I know. If you're understandably angry and just disgusted at this code, it's alright. I don't know any better.
* This is a call for help. Please, PLEASE, if you know a better way to do this, let me know, because I was out of ideas. - Lyro
*/

/area/proc/initialize_open_turfs_above()
	LAZYCLEARLIST(open_over_area_day_night)
	LAZYINITLIST(open_over_area_day_night)

	var/turf/above = null

	for(var/turf/iterating_turf as anything in get_area_turfs(src.type))
		above = GetAbove(iterating_turf)
		if(above && istype(above,/turf/simulated/open))
			open_over_area_day_night += above

	UNSETEMPTY(open_over_area_day_night)

/area/proc/update_open_turf_underlays()
	for(var/turf/iterating_turf in open_over_area_day_night)
		iterating_turf.underlays = underlays
