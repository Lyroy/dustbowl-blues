// copy and pasted scrap code

/obj/structure/scrap_car
	name = "car wreck"
	desc = "A pile of industrial debris."
	anchored = 1
	density = 1
	layer = MOB_LAYER + 1
	bound_height = 64
	bound_width = 64

	icon_state = "car_rubish1"
	icon = 'modular_dustbowl/scavenging/icons/obj/structures/rubbish.dmi'

	var/loot_generated = 0
	var/obj/item/storage/internal/updating/loot	//the visible loot
	var/loot_min = 6
	var/loot_max = 12
	var/list/loot_list = list(
		/obj/random/material,
		/obj/item/stack/rods/random,
		/obj/item/material/shard,
		/obj/random/gun_parts,
		/obj/random/junk/nondense = 2,
		/obj/random/pack/rare = 0.4
	)
	var/dig_amount = 4
	var/big_item_chance = 40
	var/obj/big_item
	var/list/ways = list("searches", "scours", "tears apart", "rips apart", "goes through")
	//sanity_damage = 0.1	// no fuck you that's dumb
	var/rare_item_chance = 33 // literally never used
	var/rare_item = FALSE

/obj/structure/scrap_car/Initialize()
	. = ..()
	icon_state = "car_rubish[rand(1,4)]"
	update_icon()

/obj/structure/scrap_car/examine(var/mob/user)
	.=..()
	if (isliving(user))
		try_make_loot() //Make the loot when examined so the big item check below will work
	to_chat(user, SPAN_NOTICE("You could use a welder to rip off parts of the car to uncover more contents."))
	if ((big_item && big_item.loc == src) && (user.stats.getStat(SKILL_SUR) >= SKILL_LEVEL_EXPERT || user.stats.getStat(SKILL_REP) >= SKILL_LEVEL_EXPERT))
		to_chat(user, SPAN_DANGER("Your gut tells you that there's something hidden within... Keep tearing it apart to find it!"))

/obj/structure/scrap_car/proc/make_big_loot()
	if(prob(big_item_chance))
		var/obj/randomcatcher/CATCH = new /obj/randomcatcher(src)
		big_item = CATCH.get_item(/obj/random/pack/junk_machine)
		if(big_item) //Sanity check in case big_item is a null, as it may sometimes do.
			big_item.forceMove(src)
		if(prob(66))
			big_item.make_old()
		qdel(CATCH)

/obj/structure/scrap_car/proc/try_make_loot()
	if(loot_generated)
		return
	loot_generated = TRUE
	if(!big_item)
		make_big_loot()

	var/amt = rand(loot_min, loot_max)
	for(var/x in 1 to amt)
		var/loot_path = pickweight(loot_list)
		new loot_path(src)

	for(var/obj/item/loot in contents)
		if(prob(66))
			loot.make_old()

	loot = new(src)
	loot.max_w_class = ITEM_SIZE_HUGE
	shuffle_loot()

/obj/structure/scrap_car/Destroy()
	for(var/obj/item in loot)
		qdel(item)
	if(big_item)
		QDEL_NULL(big_item)
	QDEL_NULL(loot)
	return ..()

/obj/structure/scrap_car/proc/shuffle_loot()
	try_make_loot()
	loot.close_all()

	for(var/A in loot)
		loot.remove_from_storage(A,src)

	var/total_storage_space = 0

	if(contents.len)
		contents = shuffle(contents)
		var/num = rand(2, loot_min)
		for(var/obj/item/O in contents)
			if(!num)
				break
			if(O == loot || O == big_item)
				continue
			total_storage_space += O.get_storage_cost()
			O.forceMove(loot)
			num--
	loot.max_storage_space = max(10, total_storage_space)

/obj/structure/scrap_car/proc/hurt_hand(mob/user)
	if(prob(15))
		if(!ishuman(user))
			return FALSE
		var/mob/living/carbon/human/victim = user
		if(victim.species.flags & NO_MINOR_CUT)
			return FALSE
		if(victim.gloves && prob(95))
			return FALSE
		var/obj/item/organ/external/BP = victim.get_organ(victim.hand ? BP_L_ARM : BP_R_ARM)
		if(!BP)
			return FALSE
		if(BP_IS_ROBOTIC(BP))
			return FALSE
		to_chat(user, "<span class='danger'>Ouch! You cut yourself while picking through \the [src].</span>")
		BP.take_damage(5, null, TRUE, TRUE, "Sharp debris")
		if(victim.species.flags & NO_PAIN) // So we still take damage, but actually dig through.
			return FALSE
		return TRUE
	return FALSE

/obj/structure/scrap_car/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(hurt_hand(user))
		return
	try_make_loot()
	loot.open(user)
	playsound(src, "rummage", 50, 1)
	.=..()

/obj/structure/scrap_car/attack_generic(mob/user)
	if (isliving(user) && loot)
		loot.open(user)
	.=..()


/obj/structure/scrap_car/proc/dig_out_lump(newloc = loc)
	if(dig_amount > 0)
		dig_amount--
		//new /obj/item/scrap_lump(src) //Todo: uncomment this once purposes and machinery for scrap are implemented
		return TRUE


/obj/structure/scrap_car/proc/clear_if_empty()
	if (dig_amount <= 0)
		for (var/obj/item/i in contents)
			if ((i != big_item) && (i != loot)) //These two dont stop the pile from being cleared
				return FALSE

		//Anything in the internal storage prevents deletion
		if (loot)
			for (var/obj/item/i in loot.contents)
				return FALSE

		clear()
		return TRUE
	return FALSE

/obj/structure/scrap_car/proc/clear()
	visible_message("<span class='notice'>\The [src] is cleared out!</span>")
	if(big_item)
		visible_message("<span class='notice'>\A hidden [big_item] is uncovered from beneath the [src]!</span>")
		big_item.forceMove(get_turf(src))
		big_item = null
	else if(rare_item)
		new /obj/item/stack/sheet/refined_scrap/random(src.loc)
		visible_message("<span class='notice'><span style='color:orange'>A pile of refined scrap is found beneath the [src]!</span>")
	qdel(src)

/obj/structure/scrap_car/attackby(obj/item/W, mob/living/carbon/human/user)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	var/list/usable_qualities = list(QUALITY_WELDING)
	var/tool_type = W.get_tool_type(user, usable_qualities, src)
	if(tool_type == QUALITY_WELDING)
		if(W.use_tool(user, src, WORKTIME_NORMAL, QUALITY_WELDING, FAILCHANCE_VERY_EASY, required_stat = SKILL_REP))
			user.visible_message(SPAN_NOTICE("[user] [pick(ways)] \the [src]."))
			user.do_attack_animation(src)
			if(prob(user.stats.getStat(SPECIAL_L)*6)) // I PRESENT THE FIRST LUCK SKILL CHECK EVER IMPLEMENTED!!!!!!!!!
				rare_item = TRUE
			else
				rare_item = FALSE
			dig_out_lump(user.loc, 0)
			shuffle_loot()
			clear_if_empty()
