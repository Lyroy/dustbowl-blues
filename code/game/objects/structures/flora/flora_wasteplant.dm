/obj/structure/flora/wasteplant
	name = "wasteland plant"
	desc = "It's a wasteland plant."
	icon = 'icons/obj/flora/wastelandflora.dmi' // well get custom sprites later this is just here for now
	anchored = 1
	density = 0
	var/has_plod = TRUE
	var/produce
	var/timer = 1 MINUTE

/obj/structure/flora/wasteplant/attack_hand(mob/user)
	if(!ispath(produce))
		return ..()

	if(has_plod)
		// some math to get the total yield
		var/max_yield = min(round(user.getStatStats(SKILL_SUR)/10,1),10)
		var/min_yield = round(user.getStatStats(SKILL_SUR)/100,1)
		var/total_yield = rand(min_yield,max_yield)

		// create the produce
		for(var/i = 0;i<total_yield;i++)
			new produce(get_turf(user))

		// tell the user what they got
		if(!total_yield)
			to_chat(user, SPAN_DANGER("You fail to harvest anything useful."))
		else
			to_chat(user, SPAN_NOTICE("You harvest [produce] from [src]."))

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
