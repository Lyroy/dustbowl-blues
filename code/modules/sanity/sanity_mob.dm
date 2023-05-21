#define SANITY_PASSIVE_GAIN 0.2

#define SANITY_DAMAGE_MOD 0.6

// Damage received from unpleasant stuff in view

#define SANITY_DAMAGE_VIEW(damage, vig, dist) ((damage) * SANITY_DAMAGE_MOD * (1.2 - (vig) / SPECIAL_VALUE_MAXIMUM) * (1 - (dist)/15))


// Damage received from body damage
#define SANITY_DAMAGE_HURT(damage, vig) (min((damage) / 5 * SANITY_DAMAGE_MOD * (1.2 - (vig) / SPECIAL_VALUE_MAXIMUM), 60))

// Damage received from shock
#define SANITY_DAMAGE_SHOCK(shock, vig) ((shock) / 50 * SANITY_DAMAGE_MOD * (1.2 - (vig) / SPECIAL_VALUE_MAXIMUM))

// Damage received from psy effects
#define SANITY_DAMAGE_PSY(damage, vig) (damage * SANITY_DAMAGE_MOD * (2 - (vig) / SPECIAL_VALUE_MAXIMUM))

// Damage received from seeing someone die
#define SANITY_DAMAGE_DEATH(vig) (10 * SANITY_DAMAGE_MOD * (1 - (vig) / SPECIAL_VALUE_MAXIMUM))

#define SANITY_GAIN_SMOKE 0.05 // A full cig restores 300 times that
#define SANITY_GAIN_SAY 1

#define SANITY_COOLDOWN_SAY rand(30 SECONDS, 45 SECONDS)
#define SANITY_COOLDOWN_BREAKDOWN rand(7 MINUTES, 10 MINUTES)

#define SANITY_CHANGE_FADEOFF(level_change) (level_change * 0.75)

#define INSIGHT_PASSIVE_GAIN 0.05
#define INSIGHT_GAIN(level_change) (INSIGHT_PASSIVE_GAIN + level_change / 15)

#define SANITY_MOB_DISTANCE_ACTIVATION 12

#define INSIGHT_DESIRE_COUNT 2

#define INSIGHT_DESIRE_FOOD "food"
#define INSIGHT_DESIRE_ALCOHOL "alcohol"
#define INSIGHT_DESIRE_SMOKING "smoking"
#define INSIGHT_DESIRE_DRUGS "drugs"
#define INSIGHT_DESIRE_DRINK_NONALCOHOL "nonalcoholic"

/datum/sanity
	var/flags
	var/mob/living/carbon/human/owner

	var/sanity_passive_gain_multiplier = 1
	var/sanity_invulnerability = 1
	var/level
	var/max_level = 100
	var/level_change = 0

	var/insight
	var/max_insight = INFINITY
	var/insight_passive_gain_multiplier = 1.5
	var/insight_gain_multiplier = 1.5
	var/insight_rest = 0
	var/max_insight_rest = INFINITY
	var/insight_rest_gain_multiplier = 1
	var/resting = 0
	var/max_resting = INFINITY

	var/list/desires = list()

	var/positive_prob = 20
	var/negative_prob = 30

	var/view_damage_threshold = 20

	var/say_time = 0
	var/breakdown_time = 0
	var/spook_time = 0

	var/death_view_multiplier = 1

	var/list/datum/breakdown/breakdowns = list()

/datum/sanity/New(mob/living/carbon/human/H)
	owner = H
	level = max_level
	insight = rand(0, 30)
	RegisterSignal(owner, COMSIG_MOB_LIFE, .proc/onLife)
	RegisterSignal(owner, COMSIG_HUMAN_SAY, .proc/onSay)

/datum/sanity/proc/onLife()
	if(owner.stat == DEAD || owner.in_stasis)
		return
	if(owner.species.reagent_tag == IS_SYNTHETIC)
		return
	var/affect = SANITY_PASSIVE_GAIN * sanity_passive_gain_multiplier
	if(owner.stat)
		changeLevel(affect)
		return
	if(!(owner.sdisabilities & BLIND) && !owner.blinded)
		affect += handle_area()
		affect -= handle_view()
	changeLevel(max(affect, min(view_damage_threshold - level, 0)))
	handle_breakdowns()
	handle_Insight()
	handle_level()
	LEGACY_SEND_SIGNAL(owner, COMSIG_HUMAN_SANITY, level)

/datum/sanity/Destroy()
	UnregisterSignal(owner, COMSIG_MOB_LIFE)
	UnregisterSignal(owner, COMSIG_HUMAN_SAY)
	owner = null
	QDEL_LIST(breakdowns)
	return ..()

/datum/sanity/proc/give_insight(value)
	var/new_value = value
	if(value > 0)
		new_value = max(0, value * insight_gain_multiplier)
	insight = min(insight + new_value, max_insight)

/datum/sanity/proc/give_resting(value)
	resting = min(resting + value, max_resting)

/datum/sanity/proc/give_insight_rest(value)
	var/new_value = value
	if(value > 0)
		new_value = max(0, value * insight_rest_gain_multiplier)
	insight_rest += new_value

/datum/sanity/proc/handle_view()
	. = 0
	activate_mobs_in_range(owner, SANITY_MOB_DISTANCE_ACTIVATION)
	if(sanity_invulnerability)//Sorry, but that needed to be added here :C
		return
	var/vig = owner.stats.getSpecial(SPECIAL_P)
	for(var/atom/A in view(owner.client ? owner.client : owner))
		if(A.sanity_damage)
			. += SANITY_DAMAGE_VIEW(A.sanity_damage, vig, get_dist(owner, A))

/datum/sanity/proc/handle_area()
	var/area/my_area = get_area(owner)
	if(!my_area)
		return 0
	. = my_area.sanity.affect
	if(. < 0)
		. *= owner.stats.getSpecial(SPECIAL_P) / SPECIAL_VALUE_MAXIMUM

/datum/sanity/proc/handle_breakdowns()
	for(var/datum/breakdown/B in breakdowns)
		if(!B.update())
			breakdowns -= B

/datum/sanity/proc/handle_Insight()
	give_insight((INSIGHT_GAIN(level_change) * insight_passive_gain_multiplier))
	if(resting < max_resting && insight >= 100)
		give_resting(1)
		/*
		if(owner.stats.getPerk(PERK_ARTIST))
			to_chat(owner, SPAN_NOTICE("You have gained insight.[resting ? " Now you need to make art. You cannot gain more insight before you do." : null]"))
		else
		*/
		to_chat(owner, SPAN_NOTICE("You have gained insight.[resting ? " Now you need to rest and rethink your life choices." : " Your previous insight has been discarded, shifting your desires for new ones."]"))
		pick_desires()
		insight -= 100
		owner.playsound_local(get_turf(owner), 'sound/sanity/level_up.ogg', 100)

	var/obj/screen/sanity/hud = owner.HUDneed["sanity"]
	hud?.update_icon()

/datum/sanity/proc/handle_level()
	level_change = SANITY_CHANGE_FADEOFF(level_change)

	if(level < 40 && world.time >= spook_time)
		spook_time = world.time + rand(1 MINUTES, 8 MINUTES) - (40 - level) * 1 SECONDS //Each missing sanity point below 40 decreases cooldown by a second

		var/static/list/effects_40 = list(
			.proc/effect_emote = 25,
			.proc/effect_quote = 50
		)
		var/static/list/effects_30 = effects_40 + list(
			.proc/effect_sound = 1,
			.proc/effect_whisper = 25,
		)
		var/static/list/effects_20 = effects_30 + list(
			.proc/effect_hallucination = 30
		)

		call(src, pickweight(level < 30 ? level < 20 ? effects_20 : effects_30 : effects_40))()


/datum/sanity/proc/pick_desires()
	desires.Cut()
	var/list/candidates = list(
		INSIGHT_DESIRE_FOOD,
		INSIGHT_DESIRE_FOOD,
		INSIGHT_DESIRE_FOOD,
		INSIGHT_DESIRE_ALCOHOL,
		INSIGHT_DESIRE_ALCOHOL,
		INSIGHT_DESIRE_ALCOHOL,
		INSIGHT_DESIRE_SMOKING,
		INSIGHT_DESIRE_DRINK_NONALCOHOL,
		INSIGHT_DESIRE_DRINK_NONALCOHOL,
		INSIGHT_DESIRE_DRUGS,
		INSIGHT_DESIRE_DRUGS,
	)
	for(var/i = 0; i < INSIGHT_DESIRE_COUNT; i++)
		var/desire = pick_n_take(candidates)
		var/list/potential_desires
		switch(desire)
			if(INSIGHT_DESIRE_FOOD)
				potential_desires = GLOB.sanity_foods.Copy()
				if(!potential_desires.len)
					potential_desires = init_sanity_foods()
			if(INSIGHT_DESIRE_ALCOHOL)
				potential_desires = GLOB.sanity_drinks.Copy()
				if(!potential_desires.len)
					potential_desires = init_sanity_drinks()
			if(INSIGHT_DESIRE_DRINK_NONALCOHOL)
				potential_desires = GLOB.sanity_non_alcoholic_drinks.Copy()
				if(!potential_desires.len)
					potential_desires = init_sanity_sanity_non_alcoholic_drinks()
			else
				desires += desire
				continue
		var/desire_count = 0
		while(desire_count < 5)
			var/candidate = pick_n_take(potential_desires)
			desires += candidate
			++desire_count
	print_desires()

/datum/sanity/proc/print_desires()
	if(!resting)
		return
	var/list/desire_names = list()
	for(var/desire in desires)
		if(ispath(desire))
			var/atom/A = desire
			desire_names += initial(A.name)
		else
			desire_names += desire
	to_chat(owner, SPAN_NOTICE("You desire [english_list(desire_names)]."))

/datum/sanity/proc/level_up()
	var/skill_points_gained = 15 + (3 * SKILL_BOOSTS_PER_INT[owner.stats.getStat(SPECIAL_I, pure = TRUE)])
	to_chat(owner, "<font color='purple'>You have gained [skill_points_gained] skill points.")
	owner.skill_points += skill_points_gained

	// owner.pick_individual_objective() //disabling this for now, seems kinda tacky to just do some random task and instantly level up
	resting = 0

/datum/sanity/proc/add_rest(type, amount)
	if(!(type in desires))
		amount /= 4
	give_insight_rest(amount)
	if(insight_rest >= 100)
		insight_rest = 0
		finish_rest()

/datum/sanity/proc/finish_rest()
	desires.Cut()
	to_chat(owner, "<font color='purple'>You have leveled up.")
	/*
	if(owner.stats.getPerk(PERK_ARTIST))
		resting = 0
	*/
	level_up()
	owner.playsound_local(get_turf(owner), 'sound/sanity/rest.ogg', 100)

/datum/sanity/proc/onDamage(amount)
	changeLevel(-SANITY_DAMAGE_HURT(amount, owner.stats.getSpecial(SPECIAL_P)))

/datum/sanity/proc/onPsyDamage(amount)
	changeLevel(-SANITY_DAMAGE_PSY(amount, owner.stats.getSpecial(SPECIAL_P)))

/datum/sanity/proc/onSeeDeath(mob/M)
	if(ishuman(M))
		var/penalty = -SANITY_DAMAGE_DEATH(owner.stats.getSpecial(SPECIAL_P))
		changeLevel(penalty*death_view_multiplier)

/datum/sanity/proc/onShock(amount)
	changeLevel(-SANITY_DAMAGE_SHOCK(amount, owner.stats.getSpecial(SPECIAL_P)))


/datum/sanity/proc/onDrug(datum/reagent/drug/R, multiplier)
	changeLevel(R.sanity_gain * multiplier)
	if(resting)
		add_rest(INSIGHT_DESIRE_DRUGS, 4 * multiplier)

/datum/sanity/proc/onAlcohol(datum/reagent/ethanol/E, multiplier)
	changeLevel(E.sanity_gain_ingest * multiplier)
	if(resting)
		add_rest(E.type, 3 * multiplier)

/datum/sanity/proc/onNonAlcohol(datum/reagent/drink/D, multiplier)
	changeLevel(D.sanity_gain_ingest * multiplier)
	if(resting)
		add_rest(D.type, 3 * multiplier)

/datum/sanity/proc/onEat(obj/item/reagent_containers/food/snacks/snack, amount_eaten)
	changeLevel(snack.sanity_gain * amount_eaten / snack.bitesize)
	if(snack.cooked && resting)
		add_rest(snack.type, 20 * amount_eaten / snack.bitesize)

/datum/sanity/proc/onSmoke(obj/item/clothing/mask/smokable/S)
	changeLevel(SANITY_GAIN_SMOKE * S.quality_multiplier)
	if(resting)
		add_rest(INSIGHT_DESIRE_SMOKING, 0.4 * S.quality_multiplier)

/datum/sanity/proc/onSay()
	if(world.time < say_time)
		return
	say_time = world.time + SANITY_COOLDOWN_SAY
	changeLevel(SANITY_GAIN_SAY)


/datum/sanity/proc/changeLevel(amount)
	if(sanity_invulnerability && amount < 0)
		return
	updateLevel(level + amount)

/datum/sanity/proc/setLevel(amount)
	if(sanity_invulnerability)
		restoreLevel(amount)
		return
	updateLevel(amount)

/datum/sanity/proc/restoreLevel(amount)
	if(level <= amount)
		return
	updateLevel(amount)

/datum/sanity/proc/updateLevel(new_level)
	new_level = CLAMP(new_level, 0, max_level)
	level_change += abs(new_level - level)
	level = new_level
	if(level == 0 && world.time >= breakdown_time)
		breakdown()
	var/obj/screen/sanity/hud = owner.HUDneed["sanity"]
	hud?.update_icon()

/datum/sanity/proc/breakdown()
	breakdown_time = world.time + SANITY_COOLDOWN_BREAKDOWN

	for(var/obj/item/device/mind_fryer/M in GLOB.active_mind_fryers)
		if(get_turf(M) in view(get_turf(owner)))
			M.reg_break(owner)

	/*for(var/obj/item/implant/carrion_spider/mindboil/S in GLOB.active_mindboil_spiders)
		if(get_turf(S) in view(get_turf(owner)))
			S.reg_break(owner)*/

	var/list/possible_results
	if(prob(positive_prob))
		possible_results = subtypesof(/datum/breakdown/positive)
	if(prob(negative_prob))
		possible_results = subtypesof(/datum/breakdown/negative)

	possible_results += subtypesof(/datum/breakdown/common)

	for(var/datum/breakdown/B in breakdowns)
		possible_results -= B.type

	while(possible_results.len)
		var/breakdown_type = pick(possible_results)
		var/datum/breakdown/B = new breakdown_type(src)

		if(!B.can_occur())
			possible_results -= breakdown_type
			qdel(B)
			continue

		if(B.occur())
			breakdowns += B
		return

/datum/sanity/proc/breakdown_fabric()
	breakdown_time = world.time + SANITY_COOLDOWN_BREAKDOWN


	var/datum/breakdown/B = new /datum/breakdown/negative/fabric(src)

	if(!B.can_occur())
		message_admins("\blue breakdown_debug has errored or otherwised failed breakdown_fabric.", 1)
		qdel(B)
		return

	if(B.occur())
		breakdowns += B

/datum/sanity/proc/breakdown_debug(breakdown)
	breakdown_time = world.time + SANITY_COOLDOWN_BREAKDOWN
	if(!breakdown)
		message_admins("\blue breakdown_debug has errored or otherwised failed breakdown:[breakdown].", 1)
		return

	var/datum/breakdown/B = new breakdown(src)

	if(!B.can_occur())
		message_admins("\blue breakdown_debug has errored or otherwised failed breakdown:[breakdown].", 1)
		qdel(B)
		return

	if(B.occur())
		breakdowns += B

#undef SANITY_PASSIVE_GAIN
