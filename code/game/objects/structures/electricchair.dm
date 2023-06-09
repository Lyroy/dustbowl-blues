/obj/structure/bed/chair/e_chair
	name = "electric chair"
	desc = "Looks absolutely SHOCKING!"
	icon_state = "echair0"
	var/on = 0
	var/obj/item/assembly/shock_kit/part = new()
	var/last_time = 1.0

/obj/structure/bed/chair/e_chair/New()
	..()
	add_overlay(image('icons/obj/objects.dmi', src, "echair_over", MOB_LAYER + 1, dir))
	return

/obj/structure/bed/chair/e_chair/attackby(var/obj/item/tool/tool, var/mob/user)
	if(!tool.use_tool(user, src, WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, required_stat = SKILL_REP))
		return
	var/obj/structure/bed/chair/C = new /obj/structure/bed/chair(loc)
	C.set_dir(dir)
	part.loc = loc
	part.master = null
	part = null
	qdel(src)

/obj/structure/bed/chair/e_chair/verb/toggle()
	set name = "Toggle Electric Chair"
	set category = "Object"
	set src in oview(1)

	if(on)
		on = 0
		icon_state = "echair0"
	else
		on = 1
		icon_state = "echair1"
	to_chat(usr, SPAN_NOTICE("You switch [on ? "on" : "off"] [src]."))
	return

/obj/structure/bed/chair/e_chair/rotate()
	..()
	cut_overlays()
	add_overlay(image('icons/obj/objects.dmi', src, "echair_over", MOB_LAYER + 1, dir))	//there's probably a better way of handling this, but eh. -Pete
	return

/obj/structure/bed/chair/e_chair/proc/shock()
	if(!on)
		return
	if(last_time + 50 > world.time)
		return
	last_time = world.time

	// special power handling
	var/area/A = get_area(src)
	if(!isarea(A))
		return
	if(!A.powered(STATIC_EQUIP))
		return
	A.use_power(STATIC_EQUIP, 5000)
	var/light = A.power_light
	A.updateicon()

	flick("echair1", src)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(12, 1, src)
	s.start()
	if(buckled_mob)
		buckled_mob.burn_skin(85)
		to_chat(buckled_mob, SPAN_DANGER("You feel a deep shock course through your body!"))
		sleep(1)
		buckled_mob.burn_skin(85)
		buckled_mob.Stun(600)
	visible_message(SPAN_DANGER("The electric chair went off!"), SPAN_DANGER("You hear a deep sharp shock!"))

	A.power_light = light
	A.updateicon()
	return
