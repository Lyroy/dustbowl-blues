/datum/individual_objective/adiction
	name = "Addiction study"
	req_department = list(FACTION_FOLLOWERS)
	limited_antag = TRUE
	rarity = 4

/datum/individual_objective/adiction/assign()
	..()
	units_requested = rand(1,2)
	desc = "Observe a sum of [units_requested] occasions where someone becomes addicted to chemicals. Record and remember the physical and mental effects."
	RegisterSignal(mind_holder, COMSIG_CARBON_ADICTION, .proc/task_completed)

/datum/individual_objective/adiction/task_completed(mob/living/carbon/C, datum/reagent/reagent)
	if(C != mind_holder)
		..(1)

/datum/individual_objective/adiction/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_CARBON_ADICTION)
	..()

/datum/individual_objective/autopsy
	name = "Death is the Answer"
	req_department = list(FACTION_FOLLOWERS)
	var/list/cadavers = list()

/datum/individual_objective/autopsy/assign()
	..()
	units_requested = rand(1,2)
	desc = "Perform [units_requested] autopsies."
	RegisterSignal(mind_holder, COMSING_AUTOPSY, .proc/task_completed)

/datum/individual_objective/autopsy/task_completed(mob/living/carbon/human/H)
	if(H in cadavers)
		return
	cadavers += H
	..(1)

/datum/individual_objective/autopsy/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSING_AUTOPSY)
	..()

/datum/individual_objective/damage
	name = "A Different Perspective"
	req_department = list(FACTION_FOLLOWERS)
	var/last_health

/datum/individual_objective/damage/assign()
	..()
	units_requested = rand(40,80)
	desc = "Receive cumulative [units_requested] damage of any kind, record the damage and a medical scanner print out for later data logging and treatment."
	last_health = mind_holder.health
	RegisterSignal(mind_holder, COMSIG_HUMAN_HEALTH, .proc/task_completed)

/datum/individual_objective/damage/task_completed(health)
	if(last_health > health)
		units_completed += last_health - health
	last_health = health
	if(check_for_completion())
		completed()

/datum/individual_objective/damage/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_HEALTH)
	..()
