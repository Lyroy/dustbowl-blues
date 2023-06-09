// Well Isnt This Convenient
var/global/list/desert_plant_turfs = list(/turf/simulated/floor/asteroid/dirt/ground, /turf/simulated/floor/asteroid/dirt/dark)

/datum/turf_initializer/desert/Initialize(var/turf/simulated/T)
	if(T.density)
		return

	// check to make sure were looking at the fucking ground
	if(!is_type_in_list(T, desert_plant_turfs))
		return

	// Quick and dirty check to avoid placing things inside windows
	if(locate(/obj/structure/low_wall || /obj/structure/grille, T))
		return

	if(prob(2)) // value ripped from sunset's GRASS_SPONTANEOUS_GROUND value
		new /obj/structure/flora/ausbushes/sparsegrass(T) // lets just put grass down for now, well do a list of plants when we Actually Have Plants :]
