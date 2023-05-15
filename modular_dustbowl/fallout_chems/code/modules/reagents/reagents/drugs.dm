/datum/reagent/drugs/jet
	name = "Jet"
	id = "jet"
	description = "Jet, the ubiquitous meth-based wasteland chem. Smells like shit, but will fill you with energy."
	taste_description = "undescribable"
	reagent_state = LIQUID
	color = "#553c1c"
	metabolism = REM * 1.2
	scannable = TRUE
	nerve_system_accumulations = 25
	addiction_chance = 20
	sanity_gain = 1.5

/datum/reagent/drugs/jet/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.druggy = max(M.druggy, 15 * effect_multiplier)
	M.add_chemical_effect(CE_PAINKILLER, 25)
	if(prob(7 * effect_multiplier))
		M.emote(pick("twitch", "drool", "moan", "giggle"))
	M.add_chemical_effect(CE_PULSE, -1)
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, "jet")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_BASIC, STIM_TIME, "jet")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_BASIC, STIM_TIME, "jet")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "jet")

/datum/reagent/drugs/jet/on_mob_add(mob/living/L)
	. = ..()
	M.adjustHalLoss(-3 * volume)


/datum/reagent/drugs/rebound
	name = "Rebound"
	id = "rebound"
	description = "Liquid jet mixed with pre-war drugs. Unlike jet, the rush of energy it grants is constant."
	taste_description = "undescribable"
	reagent_state = LIQUID
	color = "#3b2304"
	scannable = TRUE
	nerve_system_accumulations = 50
	addiction_chance = 20

/datum/reagent/drugs/rebound/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustHalLoss(-3)

/datum/reagent/drugs/buffout
	name = "Buffout"
	id = "buffout"
	description = "Highly advanced steroid, made popular by pre-war athletes and post-war brutes. Highly addictive."
	taste_description = "herbs and spices"
	reagent_state = LIQUID
	color = "#70b873"
	scannable = TRUE
	nerve_system_accumulations = 50
	addiction_chance = 25

/datum/reagent/drugs/buffout/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_ROB, STAT_LEVEL_ADEPT, STIM_TIME, "buffout")
	M.stats.addTempStat(STAT_TGH, STAT_LEVEL_EXPERT, STIM_TIME, "buffout")
	M.hallucination(50, 50)

/datum/reagent/drugs/buffout/on_mob_add(mob/living/carbon/M)
	. = ..()
	M.maxHealth += 45
	M.health += 45

/datum/reagent/drugs/buffout/on_mob_delete(mob/living/carbon/M)
	. = ..()
	M.maxHealth -= 45
	M.health -= 45

/datum/reagent/drugs/buffout/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "buffout_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT, STIM_TIME, "buffout_w")

/datum/reagent/drugs/psycho
	name = "Psycho"
	id = "psycho"
	description = "An extreme performance-enhancing drug manufactured for the US Army. Blocks many mental processes, including pain receptors and the frontal lobe.\
	Addiction is unavoidable."
	taste_description = "anger"
	reagent_state = LIQUID
	color = "#db2121"
	overdose = 20
	scannable = TRUE
	nerve_system_accumulations = 75
	addiction_chance = 1000

/datum/reagent/drugs/psycho/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.stats.addTempStat(STAT_TGH, STAT_LEVEL_ADEPT, STIM_TIME, "psycho")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_EXPERT, STIM_TIME, "psycho")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_EXPERT, STIM_TIME, "psycho")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_EXPERT, STIM_TIME, "psycho")
	M.add_chemical_effect(CE_PAINKILLER, 1000) //No pain at all
	M.apply_effect(3, STUTTER)
	M.make_jittery(10)
	M.make_dizzy(10)
	M.add_chemical_effect(CE_PULSE,3)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/C = H.random_organ_by_process(OP_HEART)
		if(C && istype(H))
			C.take_damage(amount = 0.5, edge = TRUE)

/datum/reagent/drugs/psycho/overdose(mob/living/carbon/M, alien)
	//We are so over
	M.add_chemical_effect(CE_PULSE,4)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/C = H.random_organ_by_process(OP_HEART)
		if(C && istype(H))
			C.take_damage(amount = 5, edge = TRUE)

/datum/reagent/drugs/psycho/withdrawal_act(mob/living/carbon/M)
	M.add_chemical_effect(CE_PULSE,2)
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT, STIM_TIME, "psycho_w")
	M.stats.addTempStat(STAT_BIO, -STAT_LEVEL_ADEPT, STIM_TIME, "psycho_w")
	M.stats.addTempStat(STAT_COG, -STAT_LEVEL_ADEPT, STIM_TIME, "psycho_w")
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_ADEPT, STIM_TIME, "psycho_w")

/datum/reagent/drugs/cateye
	name = "Cateye"
	id = "cateye"
	description = "A pre-war drug used by the US army and then marketed as a toy for children, this drug has proven its use in the \
	post-war world by enhancing vision while in the dark."
	taste_description = "candy"
	reagent_state = LIQUID
	color = "#40db21"
	scannable = TRUE
	nerve_system_accumulations = 30
	addiction_chance = 0

/datum/reagent/drugs/cateye/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_DARKSIGHT, SEE_INVISIBLE_NOLIGHTING)

/datum/reagent/drugs/daytripper
	name = "Day Tripper"
	id = "daytripper"
	description = "A mild pre-War hallucinogenic drug, Day Tripper helps escape from the reality of the Wasteland."
	taste_description = "candy"
	reagent_state = LIQUID
	color = "#7e7e7e"
	scannable = TRUE
	nerve_system_accumulations = 15
	addiction_chance = 20
	sanity_gain = 1.5
	var/list/quotes_good = list(
		"Everything will be fine.",
		"There is nothing to worry about.",
		"Live, laugh, love.",
		"Hang in there!",
		"What doesn't kill you makes you stronger.",
		"We all die someday.",
		"Whatever will be, will be.",
		"What goes around comes around.",
		"And they all lived happily ever after.",
		"It always seems impossible until it's done.",
		"When life gives you lemons, make lemonade.",
		"Life is what happens when you're making other plans.",
		"Forgive and forget.",
		"It is what it is.",
		"There's no “i” in Team.",
		"We're not laughing at you, we're laughing with you.",
		"We're not laughing with you, we're laughing at you.",
		"If at first you don't succeed, try again.",
		"After the storm, the sun will shine.",
		"Don't assume - it makes an ASS out of U and ME.",
		"Nice guys finish last.",
		"This too shall pass.",
		"We'll all be laughing about this one day.",
		"Imagine all the people, living life in peace."
	)
	var/list/quotes_bad = list(
		"Sometimes you just gotta pretend everything will be okay.",
		"It's always worse than it seems.",
		"You're scared to tell people how much it hurts, so keep it all to yourself.",
		"The only thing standing between you and total happiness is reality",
		"Pretend everything will be fine.",
		"Nothing will ever be the same.",
		"You aren't good enough.",
		"You have no idea of how worthless you are.",
		"Maybe you aren't meant to live a happy life.",
		"You did your best, and it still wasn't good enough.",
		"How do you run away from things that are in your head?",
		"If you are having a bad day, remember: it will get worse.",
		"They're dancing in your mind and all you can do is handle.",
		"It doesn't get better.",
		"It's all downhill from here.",
		"Whether you like it or not, alone is something you will be quite a lot.",
		"From the moment you were born, you began to die."
	)

/datum/reagent/drugs/daytripper/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	. = ..()
	M.add_chemical_effect(CE_PULSE, 1)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	if(prob(10))
		to_chat(SPAN_PSION(pick(quotes_good)))

/datum/reagent/drugs/daytripper/overdose(mob/living/carbon/M, alien)
	. = ..()
	if(prob(50))
		M.Weaken(2)
	M.drowsyness = max(M.drowsyness, 20)
	if(prob(10))
		M.say(pick(quotes))
	M.add_chemical_effect(CE_PULSE,-1)
	M.add_chemical_effect(CE_PAINKILLER, 20)

/datum/reagent/drugs/daytripper/withdrawal_act(mob/living/carbon/M)
	M.add_chemical_effect(CE_SLOWDOWN,1)
	if(prob(10))
		to_chat(SPAN_PSION(pick(quotes_bad)))
