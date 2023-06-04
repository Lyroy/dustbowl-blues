/obj/structure/flora/wasteplant
	name = "wasteland plant"
	desc = "It's a wasteland plant."
	icon = 'icons/obj/flora/wastelandflora.dmi' // well get custom sprites later this is just here for now
	anchored = 1
	density = 0
	var/has_plod = TRUE
	var/planttype
	var/timer = 1 MINUTE
	var/max_yield = 10

/obj/structure/flora/wasteplant/attack_hand(mob/user)
	if(!planttype)
		return ..()

	if(has_plod)
		// some math to get the total yield
		var/max_rand_yield = min(round((user.getStatStats(SKILL_SUR))/10, 1),max_yield)
		var/min_yield = round(user.getStatStats(SKILL_SUR)/100,1)
		var/total_yield = rand(min_yield,max_rand_yield)

		// create the produce
		for(var/i = 0;i<total_yield;i++)
			new /obj/item/reagent_containers/food/snacks/grown(get_turf(user), planttype)

		// tell the user what they got
		if(!total_yield)
			to_chat(user, SPAN_DANGER("You fail to harvest anything useful."))
		else
			to_chat(user, SPAN_NOTICE("You harvest [planttype] from [src]."))

		has_plod = FALSE
		update_icon() //Won't update due to proc otherwise
		timer = initial(timer) + rand(-100,100) //add some variability
		addtimer(CALLBACK(src, .proc/regrow),timer) //Set up the timer properly
	update_icon()

/obj/structure/flora/wasteplant/proc/regrow()
	if(!QDELETED(src))
		has_plod = TRUE
		update_icon()

/obj/structure/flora/wasteplant/update_icon()
	if(has_plod)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]_no"

// the actual plants begin here

// just a note: we should probably set max yield to at or below default yield for the plants, kinda want to make players actually convert wild plant produce into
// seeds and growing them as opposed to just Wandering Around With A Thumb Up They Ass Looking For Pretty Little Flowers To Pick In The Desert Wastes

/obj/structure/flora/wasteplant/bloodvine
	name = "wild bloodvine"
	desc = "Bababababababababababa some shit about bloodvine being good for healing babababababa."
	icon_state = "bloodvine"
	planttype = "bloodvine"
	max_yield = 3
