/obj/structure/flora/wasteplant
	name = "wasteland plant"
	desc = "It's a wasteland plant."
	icon = 'icons/obj/flora/wastelandflora.dmi'
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
		var/max_rand_yield = round((user.getStatStats(SKILL_SUR))/10, 1)
		var/min_yield = round(user.getStatStats(SKILL_SUR)/100,1)
		var/total_yield = min(rand(min_yield,max_rand_yield), max_yield)

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

// trees, you can cut them down

/obj/structure/flora/wasteplant/tree
	name = "wasteland tree"
	desc = "It's a wasteland tree."
	icon = 'icons/obj/flora/wastelandtree.dmi'
	density = 1
	pixel_x = -16
	pixel_y = 0

	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_ICON

	var/stump = TRUE //Do we have a stump when cut down?
	var/shadow = TRUE //Do we have a shadow to drop?
	var/shadow_overlay = "shadow_overlay" //Are shadow underlay, looks nice
	var/stump_type = /obj/structure/flora/stump //What type stump do we have

/obj/structure/flora/wasteplant/tree/New()
	..()
	var/image/shadow_overlay_grabber = image(src.icon, src.shadow_overlay, layer = HIDE_LAYER-0.01) //So we dont hide landmines
	underlays.Cut() //I guess we use this?
	underlays += shadow_overlay_grabber

/obj/structure/flora/wasteplant/tree/attackby(obj/item/I, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!istype(user.loc, /turf))
		return
	var/list/usable_qualities = list(QUALITY_SAWING)
	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	if(tool_type==QUALITY_SAWING)
		to_chat(user, SPAN_NOTICE("You start to cut the tree, felling it."))
		if(I.use_tool(user, src, WORKTIME_SLOW, tool_type, FAILCHANCE_NORMAL, required_stat = SKILL_SUR))
			playsound(loc, 'sound/items/tree_fall.ogg', 80, 1)
			new /obj/plant_spawner/towercaps(get_turf(src))
			new /obj/plant_spawner/towercaps(get_turf(src))
			new /obj/plant_spawner/towercaps(get_turf(src))
			new /obj/plant_spawner/towercaps(get_turf(src))

			for(var/i = 0;i<max_yield/2;i++)
				new /obj/item/reagent_containers/food/snacks/grown(get_turf(src), planttype)

			new stump_type(get_turf(src))
			to_chat(user, SPAN_NOTICE("You cut down a tree."))
			qdel(src)
			return
		return

// the actual plants begin here

// just a note: we should probably set max yield to at or below default yield for the plants, kinda want to make players actually convert wild plant produce into
// seeds and growing them as opposed to just Wandering Around With A Thumb Up They Ass Looking For Pretty Little Flowers To Pick In The Desert Wastes
// in other words: planting should be better than foraging

/obj/structure/flora/wasteplant/bloodvine
	name = "wild Bloodvine"
	desc = "Bababababababababababa some shit about bloodvine being good for healing babababababa."
	icon_state = "bloodvine"
	planttype = "Bloodvine"
	max_yield = 3

/obj/structure/flora/wasteplant/tree/singetree
	name = "Singetree"
	desc = "BABABABABABABA."
	icon_state = "singetree"
	planttype = "Singetree leaves"
	max_yield = 5
	shadow_overlay = "singetree_shadow"
	stump_type = /obj/structure/flora/stump/singetree

/obj/structure/flora/stump/singetree
	icon = 'icons/obj/flora/wastelandtree.dmi'
	icon_state = "singetree_stump"
	pixel_x = -16
	pixel_y = 0

/obj/structure/flora/wasteplant/toxgarlic
	name = "wild Ghoul Garlic"
	desc = "BABABABABABABA."
	icon_state = "toxgarlic"
	planttype = "Ghoul Garlic"
	max_yield = 4

/obj/structure/flora/wasteplant/stareberry
	name = "wild Stareberry bush"
	desc = "BABABABABABABA."
	icon_state = "stareberry"
	planttype = "Stareberries"
	max_yield = 5

/obj/structure/flora/wasteplant/opium
	name = "wild Somniflower"
	desc = "BABABABABABABA."
	icon_state = "opium"
	planttype = "Somniflowers"
	max_yield = 2

/obj/structure/flora/wasteplant/panyote
	name = "wild Panyote cactus"
	desc = "BABABABABABABA."
	icon_state = "panyote"
	planttype = "Panyote"
	max_yield = 5

/obj/structure/flora/wasteplant/tree/animatree
	name = "Animatree"
	desc = "BABABABABABABA."
	icon_state = "animatree"
	planttype = "Animatree bark"
	max_yield = 4
	shadow_overlay = "animatree_shadow"
	stump_type = /obj/structure/flora/stump/animatree

/obj/structure/flora/stump/animatree
	icon = 'icons/obj/flora/wastelandtree.dmi'
	icon_state = "animatree_stump"
	pixel_x = -16
