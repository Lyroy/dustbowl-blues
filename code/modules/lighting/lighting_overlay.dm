/datum/lighting_overlay
	///the underlay we are currently applying to our turf to apply light
	var/mutable_appearance/current_underlay

	///whether we are already in the SSlighting.objects_queue list
	var/needs_update = FALSE

	///the turf that our light is applied to
	var/turf/affected_turf

	/// Area which gets linked to a lighting overlay to make it consider the luminosity from the day/night blending from the area. Yes this isn't ideal, but applying luminosity up to 2 (from both sources) on the turf is not ideal either
	var/area/day_night_area


/datum/lighting_overlay/New(turf/source)
	if(!isturf(source))
		qdel(src, force=TRUE)
		stack_trace("a lighting object was assigned to [source], a non turf! ")
		return

	. = ..()

	day_night_area = null

	affected_turf = source
	if (affected_turf.lighting_overlay)
		qdel(affected_turf.lighting_overlay, force = TRUE)
		stack_trace("a lighting object was assigned to a turf that already had a lighting object!")

	affected_turf.lighting_overlay = src
	// Default to fullbright, so things can "see" if they use view() before we update
	affected_turf.luminosity = 1

	current_underlay = mutable_appearance(LIGHTING_ICON, "transparent", affected_turf.z * 0.01, LIGHTING_PLANE, 255, RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM)

	needs_update = TRUE
	global.lighting_update_overlays += src;
	update_overlay()


/datum/lighting_overlay/Destroy()
	global.lighting_update_overlays -= src;
	if (isturf(affected_turf))
		affected_turf.lighting_overlay = null
		affected_turf.luminosity = 1
		affected_turf.underlays -= current_underlay
	affected_turf = null
	return ..()

/datum/lighting_overlay/proc/update_overlay()
	if (!isturf(affected_turf)) // Erm...
		if (affected_turf)
			warning("A lighting overlay realised its loc was NOT a turf (actual loc: [affected_turf], [affected_turf.type]) in update_overlay() and got deleted!")

		else
			warning("A lighting overlay realised it was in nullspace in update_overlay() and got deleted!")

		qdel(src)
		return

	// To the future coder who sees this and thinks
	// "Why didn't he just use a loop?"
	// Well my man, it's because the loop performed like shit.
	// And there's no way to improve it because
	// without a loop you can make the list all at once which is the fastest you're gonna get.
	// Oh it's also shorter line wise.
	// Including with these comments.

	// See LIGHTING_CORNER_DIAGONAL in lighting_corner.dm for why these values are what they are.
	// No I seriously cannot think of a more efficient method, fuck off Comic.
	var/static/datum/lighting_corner/dummy/dummy_lighting_corner = new

	var/list/corners = affected_turf.corners
	var/datum/lighting_corner/cr = dummy_lighting_corner
	var/datum/lighting_corner/cg = dummy_lighting_corner
	var/datum/lighting_corner/cb = dummy_lighting_corner
	var/datum/lighting_corner/ca = dummy_lighting_corner
	if (corners) //done this way for speed
		cr = corners[3] || dummy_lighting_corner
		cg = corners[2] || dummy_lighting_corner
		cb = corners[4] || dummy_lighting_corner
		ca = corners[1] || dummy_lighting_corner

	var/max = max(cr.cache_mx, cg.cache_mx, cb.cache_mx, ca.cache_mx)

	#if LIGHTING_SOFT_THRESHOLD != 0
	var/set_luminosity = max > LIGHTING_SOFT_THRESHOLD
	#else
	// Because of floating points™?, it won't even be a flat 0.
	// This number is mostly arbitrary.
	var/set_luminosity = max > 1e-6
	#endif

	// Respect daynight blending from an area for luminosity here, this is required as the luminosity can sometimes be overriden to 0 when it's day outside, and day trumps whatever is trying to set it to 0.
	if(day_night_area?.luminosity)
		set_luminosity = 1

	var/mutable_appearance/current_underlay = src.current_underlay
	affected_turf.underlays -= current_underlay
	if(cr.cache_r & cg.cache_r & cb.cache_r & ca.cache_r && \
		(cr.cache_g + cg.cache_g + cb.cache_g + ca.cache_g + \
		cr.cache_b + cg.cache_b + cb.cache_b + ca.cache_b == 8))
		//anything that passes the first case is very likely to pass the second, and addition is a little faster in this case
		current_underlay.icon_state = "lighting_transparent"
		current_underlay.color = null
	else if(!set_luminosity)
		current_underlay.icon_state = "lighting_dark"
		current_underlay.color = null
	else
		current_underlay.icon_state = null
		current_underlay.color = list(
		cr.cache_r, cr.cache_g, cr.cache_b, 0,
		cg.cache_r, cg.cache_g, cg.cache_b, 0,
		cb.cache_r, cb.cache_g, cb.cache_b, 0,
		ca.cache_r, ca.cache_g, ca.cache_b, 0,
		0, 0, 0, 1
	)
	current_underlay.plane = calculate_plane(affected_turf.z, LIGHTING_PLANE)

	// Of note. Most of the cost in this proc is here, I think because color matrix'd underlays DO NOT cache well, which is what adding to underlays does
	// We use underlays because objects on each tile would fuck with maptick. if that ever changes, use an object for this instead
	affected_turf.underlays += current_underlay
	affected_turf.luminosity = set_luminosity
