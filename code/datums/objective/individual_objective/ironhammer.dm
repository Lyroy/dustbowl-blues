/datum/individual_objective/familiar_face
	name = "A Familiar Face"
	req_department = list(FACTION_SKYMARSHAL)
	var/mob/living/carbon/human/target

/datum/individual_objective/familiar_face/can_assign(mob/living/L)
	if(!..())
		return FALSE
	var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - L
	return candidates.len

/datum/individual_objective/familiar_face/assign()
	..()
	var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - mind_holder
	target = pick(candidates)
	desc = "You swear you saw to [target] somewhere before, and in your line of job it cannot mean good. Search them, \
	remove their backpack or empty their pockets."
	RegisterSignal(mind_holder, COMSIG_EMPTY_POCKETS, .proc/task_completed)

/datum/individual_objective/familiar_face/task_completed(n_target)
	if(n_target == target)
		completed()

/datum/individual_objective/familiar_face/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_EMPTY_POCKETS)
	..()

/datum/individual_objective/time_to_action
	name = "Time for Action"
	req_department = list(FACTION_SKYMARSHAL,FACTION_WASTELANDERS,FACTION_TRIBE)
	units_requested = 20

/datum/individual_objective/time_to_action/assign()
	..()
	desc = "Slay or observe the slaying of 20 hostiles (Ghouls, Radroaches, ect)."
	RegisterSignal(mind_holder, COMSIG_MOB_DEATH, .proc/task_completed)

/datum/individual_objective/time_to_action/task_completed(mob/mob_death)
	..(1)

/datum/individual_objective/time_to_action/completed()
	if(completed) return
	UnregisterSignal(owner, COMSIG_MOB_DEATH)
	..()
/* TODO: make this not be shitcurdy
/datum/individual_objective/paranoia
	name = "Paranoia"
	req_department = list(FACTION_SKYMARSHAL)
	var/list/vitims = list()

/datum/individual_objective/paranoia/assign()
	..()
	units_requested = rand(3,4)
	desc = "The criminals are here, somewhere, you can feel that. Search [units_requested] people, \
			remove their backpack or empty their pockets."
	RegisterSignal(mind_holder, COMSIG_EMPTY_POCKETS, .proc/task_completed)

/datum/individual_objective/paranoia/task_completed(mob/living/carbon/n_target)
	if((n_target in vitims) || !n_target.client)
		return
	vitims += n_target
	..(1)

/datum/individual_objective/paranoia/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_EMPTY_POCKETS)
	..()
*/

/datum/individual_objective/guard
	name = "Guard"
	req_department = list(FACTION_SKYMARSHAL)
	var/area/target_area

/datum/individual_objective/guard/assign()
	..()
	target_area = random_ship_area()
	desc = "[target_area] needs fortification for Skyline's safety. All sorts of mutated creatures tunnel into the skyscraper constantly. Have a turret built there."
	RegisterSignal(target_area, COMSIG_TURRENT, .proc/task_completed)

/datum/individual_objective/guard/task_completed()
		completed()

/datum/individual_objective/guard/completed()
	if(completed) return
	UnregisterSignal(target_area, COMSIG_TURRENT)
	..()
