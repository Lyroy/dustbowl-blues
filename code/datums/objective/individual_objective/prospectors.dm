/datum/individual_objective/only_thing_they_fear
	name = "The only thing they fear is you"
	req_department = list(DEPARTMENT_PROSPECTOR)
	units_requested = 40

/datum/individual_objective/only_thing_they_fear/assign()
	..()
	desc = "Slay or observe the slaying of 40 hostiles (Roaches, Spiders, ect)."
	RegisterSignal(mind_holder, COMSIG_MOB_DEATH, .proc/task_completed)

/datum/individual_objective/only_thing_they_fear/task_completed(mob/mob_death)
	..(1)

/datum/individual_objective/only_thing_they_fear/completed()
	if(completed) return
	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	..()

/datum/individual_objective/collection_prospector
	name = "Specialty Collection"
	req_department = list(DEPARTMENT_PROSPECTOR)
	var/obj/item/target

/datum/individual_objective/collection_prospector/proc/pick_candidates()
	var/obj/randomcatcher/CATCH = new /obj/randomcatcher
	return CATCH.get_item(/obj/random/dungeon_gun_ballistic)

/datum/individual_objective/collection_prospector/assign()
	..()
	target = pick_candidates()
	desc = "Get your hands on a [target.name]. You've an eye for quality and want only the best."
	RegisterSignal(mind_holder, COMSING_HUMAN_EQUITP, .proc/task_completed)

/datum/individual_objective/collection_prospector/task_completed(obj/item/W)
	if(W.type == target.type)
		completed()
	else
		for(var/obj/item/I in mind_holder.GetAllContents())
			if(I.type == target.type)
				completed()

/datum/individual_objective/collection_prospector/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSING_HUMAN_EQUITP)
	..()
