/datum/perk/superstim_sickness
	name = "Stimpak Sickness"
	desc = "The healing cocktail of the super stimpak has taxed your body. Your muscles and reflexes have been left numb."
	gain_text = "The healing cocktail of the super stimpak has taxed your body. Your muscles and reflexes have been left numb. Better take a breather, sitting down could help..."
	lose_text = "You finally feel your body recover from the sudden rush of stimpak healing juices."
	var/initial_time

/datum/perk/superstim_sickness/assign(mob/living/carbon/human/H)
	..()
	initial_time = world.time
	cooldown_time = world.time + 10 MINUTES
	holder.stats.changeStat(STAT_ROB, -10)
	holder.stats.changeStat(STAT_VIG, -10)

/datum/perk/superstim_sickness/remove()
	holder.stats.changeStat(STAT_ROB, 10)
	holder.stats.changeStat(STAT_VIG, 10)
	..()

/datum/perk/superstim_sickness/on_process()
	if(!..())
		return
	if(cooldown_time <= world.time)
		holder.stats.removePerk(type)
		to_chat(holder, SPAN_NOTICE("[lose_text]"))
		return
	if(holder.buckled)
		cooldown_time -= 2 SECONDS
