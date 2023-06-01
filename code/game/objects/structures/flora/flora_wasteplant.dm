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
		var/obj/item/product = new produce
		if(!istype(product))
			return //Something fucked up here or it's a weird product
		user.put_in_hands(product)
		to_chat(user, "<span class='notice'>You pluck [product] from [src].</span>")
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
