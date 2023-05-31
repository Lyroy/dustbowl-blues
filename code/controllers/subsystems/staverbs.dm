// File contains:
// - statverbs subsystem
// - statverb datum defenation
// - statverb related atom code

SUBSYSTEM_DEF(statverbs)
	name = "statverbs"
	flags = SS_NO_INIT|SS_NO_FIRE

	var/list/all_verbs = list()

/datum/controller/subsystem/statverbs/proc/call_verb(user, target, path, tmp_name)
	var/datum/statverb/SV
	if(isnull(all_verbs[path]))
		all_verbs[path]= new path
	SV = all_verbs[path]
	SV.try_action(user, target, tmp_name)


// Statverb datum //
/datum/statverb
	var/name
	var/required_stat = SKILL_ATH
	var/base_range = RANGE_ADJACENT	//maximum distance or RANGE_ADJACENT
	var/minimal_stat = 0


/datum/statverb/proc/try_action(mob/living/user, atom/target, saved_name = "target")
	if(!istype(user))
		return
	if(!(target in view(user)))
		to_chat(user, SPAN_WARNING("You're too far from [saved_name]"))
		return FALSE

	if(base_range == RANGE_ADJACENT)
		if(!target.Adjacent(user))
			to_chat(user, SPAN_WARNING("You should be adjacent to [target]"))
			return FALSE
	else
		if(get_dist(user, target) > base_range)
			to_chat(user, SPAN_WARNING("You're too far from [target]"))
			return FALSE

	if(user.stats.getStat(required_stat) < minimal_stat)
		switch(required_stat)
			if(SPECIAL_S)
				to_chat(user, SPAN_WARNING("You aren't strong enough to do that!"))
			if(SPECIAL_P)
				to_chat(user, SPAN_WARNING("You aren't perceptive enough to do that!"))
			if(SPECIAL_E)
				to_chat(user, SPAN_WARNING("You're not tough enough to do that!"))
			if(SPECIAL_C)
				to_chat(user, SPAN_WARNING("You're not charismatic enough to do that!"))
			if(SPECIAL_I)
				to_chat(user, SPAN_WARNING("You're not smart enough to do that!"))
			if(SPECIAL_A)
				to_chat(user, SPAN_WARNING("You're not agile enough to do that!"))
			if(SPECIAL_L)
				to_chat(user, SPAN_WARNING("Your luck isn't good enough!"))

			if(SKILL_ATH)
				to_chat(user, SPAN_WARNING("You're not athletic enough to do this!"))
			if(SKILL_LOC)
				to_chat(user, SPAN_WARNING("You're not skilled enough in lockpicking to do this!"))
			if(SKILL_MED)
				to_chat(user, SPAN_WARNING("You're not skilled enough in medicine to do this!"))
			if(SKILL_REP)
				to_chat(user, SPAN_WARNING("You're not skilled enough in repairing to do this!"))
			if(SKILL_SCI)
				to_chat(user, SPAN_WARNING("You're not skilled enough in science to do this!"))
			if(SKILL_SUR)
				to_chat(user, SPAN_WARNING("You're not skilled enough in survival to do this!"))

			if(SKILL_BIG)
				to_chat(user, SPAN_WARNING("You're not proficient enough with big weapons to do this!"))
			if(SKILL_ENE)
				to_chat(user, SPAN_WARNING("You're not proficient enough with energy weapons to do this!"))
			if(SKILL_EXP)
				to_chat(user, SPAN_WARNING("You're not proficient enough with explosives to do this!"))
			if(SKILL_MEL)
				to_chat(user, SPAN_WARNING("You're not proficient enough with melee weapons to do this!"))
			if(SKILL_SMA)
				to_chat(user, SPAN_WARNING("You're not proficient enough with small weapons to do this!"))
			if(SKILL_UNA)
				to_chat(user, SPAN_WARNING("You're not proficient enough in unarmed combat to do this!"))
		return FALSE

	action(user, target)

/datum/statverb/proc/action(mob/user, atom/target)



// Atom part //
/atom
	var/list/statverbs

/atom/Initialize()
	. = ..()
	initalize_statverbs()

/atom/Destroy()
	. = ..()
	if(statverbs)
		statverbs.Cut()

/atom/proc/initalize_statverbs()
	var/list/paths = statverbs
	statverbs = new
	for(var/path in paths)
		add_statverb(path)

/atom/proc/add_statverb(path)
	if(!statverbs)
		statverbs = new
	var/datum/statverb/SV = path
	statverbs[initial(SV.required_stat)] = path

/atom/proc/remove_statverb(path)
	statverbs -= path



/atom/proc/show_stat_verbs()
	if(statverbs && statverbs.len)
		. = "Apply: "
		for(var/stat in statverbs)
			. += " <a href='?src=\ref[src];statverb=[stat];obj_name=[src]'>[stat]</a>"

/atom/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["statverb"])
		SSstatverbs.call_verb(usr, src, src.statverbs[href_list["statverb"]], href_list["obj_name"])


// Example

/turf/simulated/floor/initalize_statverbs()
	if(flooring && (flooring.flags & TURF_REMOVE_CROWBAR))
		add_statverb(/datum/statverb/remove_plating)

/datum/statverb/remove_plating
	name = "Remove plating"
	required_stat = SPECIAL_S
	minimal_stat  = SPECIAL_LEVEL_GOOD

/datum/statverb/remove_plating/action(mob/user, turf/simulated/floor/target)
	if(target.flooring && target.flooring.flags & TURF_REMOVE_CROWBAR)
		user.visible_message(
			SPAN_DANGER("[user] grabbed the edges of [target] with their hands!"),
			"You grab the edges of [target] with your hands"
		)
		if(do_mob(user, target, target.flooring.removal_time * 3))
			user.visible_message(
				SPAN_DANGER("[user] roughly tore plating off from [target]!"),
				"You tore plating off from [target]"
			)
			target.make_plating(FALSE)
		else
			var/target_name = target ? "[target]" : "the floor"
			user.visible_message(
				SPAN_DANGER("[user] stopped tearing the plating off from [target_name]!"),
				"You stop tearing plating off from [target_name]"
			)

/obj/item/modular_computer/initalize_statverbs()
	if(enabled == 0)
		add_statverb(/datum/statverb/fix_computer)

/datum/statverb/fix_computer
	name = "Fix computer"
	required_stat = SKILL_SCI
	minimal_stat  = SKILL_LEVEL_PROF //We use what we at lest need to use this

/datum/statverb/fix_computer/action(mob/user, obj/item/modular_computer/target)
	if(target.hard_drive.damage < 100)
		user.visible_message(
			SPAN_WARNING("[target] doesn't need repairs!")
		)
		return
	var/timer = 160 - (user.stats.getStat(SKILL_SCI) * 2)
	if(target.hard_drive.damage == 100)
		var/datum/repeating_sound/keyboardsound = new(30, timer, 0.15, target, "keyboard", 80, 1)
		user.visible_message(
			SPAN_NOTICE("You begin repairing [target]."),
		)
		if(do_mob(user, target, timer))
			keyboardsound.stop()
			keyboardsound = null
			target.hard_drive.damage = 0
			target.hard_drive.install_default_files()
			target.update_icon()
			user.visible_message(
				SPAN_NOTICE("You manage to repair [target], but the harddrive was corrupted! Only default programs were restored."),
			)
		else
			keyboardsound.stop()
			keyboardsound = null
			var/target_name = target ? "[target]" : "the computer"
			user.visible_message(
				SPAN_NOTICE("You stop repairing [target_name]."),
			)

/obj/machinery/computer/rdconsole/initalize_statverbs()
	if(access_research_equipment in req_access)
		add_statverb(/datum/statverb/hack_console)


/datum/statverb/hack_console
	name = "Hack console"
	required_stat = SKILL_SCI
	minimal_stat  = SKILL_LEVEL_ADEPT


/datum/statverb/hack_console/action(mob/user, obj/machinery/computer/rdconsole/target)
	if(target.hacked == 1)
		user.visible_message(
			SPAN_WARNING("[target] is already hacked!")
		)
		return
	if(target.hacked == 0)
		var/timer = 220 - (user.stats.getStat(SKILL_SCI) * 2)
		var/datum/repeating_sound/keyboardsound = new(30, timer, 0.15, target, "keyboard", 80, 1)
		user.visible_message(
			SPAN_DANGER("[user] begins hacking into [target]!"),
			"You start hacking the access requirement on [target]"
		)
		if(do_mob(user, target, timer))
			keyboardsound.stop()
			keyboardsound = null
			target.req_access.Cut()
			target.hacked = 1
			user.visible_message(
				SPAN_DANGER("[user] breaks the access encryption on [target]!"),
				"You break the access encryption on [target]"
			)
		else
			keyboardsound.stop()
			keyboardsound = null
			var/target_name = target ? "[target]" : "the research console"
			user.visible_message(
				SPAN_DANGER("[user] stopped hacking into [target_name]!"),
				"You stop hacking into [target_name]."
			)

/datum/statverb/pick_lock
	name = "Pick lock"
	required_stat = SKILL_LOC
	minimal_stat  = SKILL_LEVEL_NONE


/datum/statverb/pick_lock/action(mob/user, obj/machinery/computer/rdconsole/target)
	if(target.hacked == 1)
		user.visible_message(
			SPAN_WARNING("[target] is already hacked!")
		)
		return
	if(target.hacked == 0)
		var/timer = 220 - (user.stats.getStat(SKILL_SCI) * 2)
		var/datum/repeating_sound/keyboardsound = new(30, timer, 0.15, target, "keyboard", 80, 1)
		user.visible_message(
			SPAN_DANGER("[user] begins hacking into [target]!"),
			"You start hacking the access requirement on [target]"
		)
		if(do_mob(user, target, timer))
			keyboardsound.stop()
			keyboardsound = null
			target.req_access.Cut()
			target.hacked = 1
			user.visible_message(
				SPAN_DANGER("[user] breaks the access encryption on [target]!"),
				"You break the access encryption on [target]"
			)
		else
			keyboardsound.stop()
			keyboardsound = null
			var/target_name = target ? "[target]" : "the research console"
			user.visible_message(
				SPAN_DANGER("[user] stopped hacking into [target_name]!"),
				"You stop hacking into [target_name]."
			)
