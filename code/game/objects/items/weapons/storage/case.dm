/obj/item/storage/case //created for future tweaks
	name = "Case"
	max_w_class = ITEM_SIZE_BULKY
	w_class = ITEM_SIZE_HUGE
	var/opened = FALSE //Checking opened case or not

/obj/item/storage/case/attack_hand(mob/user as mob)

	if ((loc != user) && opened)
		open(user)

	else
		close_all()
		..()

	update_icon()
	src.add_fingerprint(user)
	return

/obj/item/storage/case/open(var/mob/user)
	if(!opened)
		return
	..()

/obj/item/storage/case/attackby(obj/item/W as obj, mob/user as mob)
	update_icon()
	..()

/obj/item/storage/case/AltClick()
	if(!istype(loc, /turf/))
		to_chat(usr, "\The [src] has to be on a stable surface first!")
		return

	else
		opened = !opened
		anchored = !anchored
		close_all()
		update_icon()

/obj/item/storage/case/update_icon()
	..()

	icon_state = initial(icon_state)
	if(!anchored)
		overlays.Cut()
		icon_state += "-closed"
