/datum/stat_holder
	var/tmp/mob/living/holder
	var/list/stat_list = list()
	var/list/datum/perk/perks = list()
	var/list/obj/effect/perk_stats = list() // Holds effects representing perks, to display them in stat()
	var/initialized = FALSE //Whether or not the stats have had time to be properly filled. Not always used. For players, it is set in human/Stat(), used for Stat-dependant organs

/datum/stat_holder/New(mob/living/L)
	holder = L
	for(var/sttype in subtypesof(/datum/stat))
		var/datum/stat/S = new sttype
		stat_list[S.name] = S

/datum/stat_holder/Destroy()
	if(holder)
		holder.stats = null
		holder = null

	QDEL_LIST(perks) //i dont know if this is needed but hey
	QDEL_LIST(perk_stats)

	stat_list.Cut()
	return ..()

/datum/stat_holder/proc/check_for_shared_perk(ability_bitflag)
	for(var/datum/perk/target_perk in perks)
		if(target_perk.check_shared_ability(ability_bitflag))
			return TRUE
	return FALSE

/* Uncomment when we have more than 1 bitflag for shared abilities
/datum/stat_holder/proc/check_for_shared_perks(list/ability_bitflags)
	for(var/datum/perk/target_perk in perks)
		if(target_perk.check_shared_abilities(ability_bitflags))
			return TRUE
	return FALSE
*/

/datum/stat_holder/proc/addTempStat(statName, Value, timeDelay, id = null)
	var/datum/stat/S = stat_list[statName]
	S.addModif(timeDelay, Value, id)
	LEGACY_SEND_SIGNAL(holder, COMSIG_STAT, S.name, S.getValue(), S.getValue(TRUE))

/datum/stat_holder/proc/removeTempStat(statName, id)
	if(!id)
		CRASH("no id passed to removeTempStat(")
	var/datum/stat/S = stat_list[statName]
	S.remove_modifier(id)

/datum/stat_holder/proc/getTempStat(statName, id)
	if(!id)
		CRASH("no id passed to getTempStat(")
	var/datum/stat/S = stat_list[statName]
	return S.get_modifier(id)

/datum/stat_holder/proc/changeStat(statName, Value)
	var/datum/stat/S = stat_list[statName]
	S.changeValue(Value)
	LEGACY_SEND_SIGNAL(holder, COMSIG_STAT, S.name, S.getValue(), S.getValue(TRUE))

/datum/stat_holder/proc/changeStat_withcap(statName, Value)
	var/datum/stat/S = stat_list[statName]
	S.changeValue_withcap(Value)
	LEGACY_SEND_SIGNAL(holder, COMSIG_STAT, S.name, S.getValue(), S.getValue(TRUE))


/datum/stat_holder/proc/setStat(statName, Value)
	var/datum/stat/S = stat_list[statName]
	S.setValue(Value)

/datum/stat_holder/proc/getStat(statName, pure = FALSE, special_override)
	if (!islist(statName))
		var/datum/stat/S = stat_list[statName]
		LEGACY_SEND_SIGNAL(holder, COMSIG_STAT, S.name, S.getValue(), S.getValue(TRUE))

		if(S)
			var/special_modifier = 1
			var/special_to_use = S.linked_special

			if(special_override)
				if(special_override == "NO")
					special_to_use = null
				else
					special_to_use = special_override
			if(special_to_use)
				special_modifier += ((getStat(special_to_use) - 5) * 4 / 100)

			return S.getValue(pure) * special_modifier
		else
			return 0
	else
		log_debug("passed list to getStat(), statName without a list: [statName]")

/datum/stat_holder/proc/getSpecial(statName, pure = FALSE)
	if (!islist(statName))
		var/datum/stat/special/S = stat_list[statName]
		LEGACY_SEND_SIGNAL(holder, COMSIG_STAT, S.name, S.getValue(), S.getValue(TRUE))

		return S ? S.getSpecial(pure) : 0
	else
		log_debug("passed list to getStat(), statName without a list: [statName]")


//	Those are accept list of stats
//	Compound stat checks.
//	Lowest value among the stats passed in
/datum/stat_holder/proc/getMinStat(var/list/namesList, pure = FALSE)
	if(!islist(namesList))
		log_debug("passed non-list to getMinStat()")
		return 0
	var/lowest = INFINITY
	for (var/name in namesList)
		if(getStat(name, pure) < lowest)
			lowest = getStat(name, pure)
	return lowest

//	Get the highest value among the stats passed in
/datum/stat_holder/proc/getMaxStat(var/list/namesList, pure = FALSE, special_override)
	if(!islist(namesList))
		log_debug("passed non-list to getMaxStat()")
		return 0
	var/highest = -INFINITY
	for (var/name in namesList)
		if(getStat(name, pure, special_override) > highest)
			highest = getStat(name, pure, special_override)
	return highest

//	Sum total of the stats
/datum/stat_holder/proc/getSumOfStat(var/list/namesList, pure = FALSE, special_override)
	if(!islist(namesList))
		log_debug("passed non-list to getSumStat()")
		return 0
	var/sum = 0
	for (var/name in namesList)
		sum += getStat(name, pure, special_override)
	return sum

//	Get the average (mean) value of the stats
/datum/stat_holder/proc/getAvgStat(var/list/namesList, pure = FALSE, special_override)
	if(!islist(namesList))
		log_debug("passed non-list to getAvgStat()")
		return 0
	var/avg = getSumOfStat(namesList, pure, special_override)
	return avg / namesList.len

// return value from 0 to 1 based on value of stat, more stat value less return value
// use this proc to get multiplier for decreasing delay time (exaple: "50 * getMult(STAT_ROB, SKILL_LEVEL_ADEPT)"  this will result in 5 seconds if stat STAT_ROB = 0 and result will be 0 if STAT_ROB = SKILL_LEVEL_ADEPT)
/datum/stat_holder/proc/getMult(statName, statCap = SKILL_LEVEL_MAX, pure = FALSE, special_override)
    if(!statName)
        return
    return 1 - max(0,min(1,getStat(statName, pure, special_override)/statCap))

/datum/stat_holder/proc/getPerk(perkType)
	RETURN_TYPE(/datum/perk)
	var/datum/perk/path = ispath(perkType) ? perkType : text2path(perkType) // Adds support for textual argument so that it can be called through VV easily
	if(path)
		return locate(path) in perks

/// The main, public proc to add a perk to a mob. Accepts a path or a stringified path.
/datum/stat_holder/proc/addPerk(perkType)
	. = FALSE
	if(!getPerk(perkType))
		var/datum/perk/P = new perkType
		perks += P
		P.assign(holder)
		perk_stats += P.statclick
		. = TRUE


/// The main, public proc to remove a perk from a mob. Accepts a path or a stringified path.
/datum/stat_holder/proc/removePerk(perkType)
	var/datum/perk/P = getPerk(perkType)
	if(P)
		perks -= P
		P.remove()
		perk_stats -= P.statclick

/datum/stat_holder/proc/removeAllPerks()
	for(var/datum/perk/P in (perk_stats || perks))
		removePerk(P)


/datum/stat_mod
	var/time = 0
	var/value = 0
	var/id

/datum/stat_mod/New(_delay, _affect, _id)
	if(_delay == INFINITY)
		time = -1
	else
		time = world.time + _delay
	value = _affect
	id = _id



/datum/stat
	var/name = "Character skill"
	var/desc = "Basic characteristic, you are not supposed to see this. Report to admins."
	var/value = SKILL_VALUE_DEFAULT
	var/list/mods = list()
	var/linked_special //We use this SPECIAL stat as a multiplier
	var/img = 'html/images/stats/unknown.png' // little image that shows up when selecting stats

/datum/stat/proc/addModif(delay, affect, id)
	for(var/elem in mods)
		var/datum/stat_mod/SM = elem
		if(SM.id == id)
			if(delay == INFINITY)
				SM.time = -1
			else
				SM.time = world.time + delay
			SM.value = affect
			return
	mods += new /datum/stat_mod(delay, affect, id)

/datum/stat/proc/remove_modifier(id)
	for(var/elem in mods)
		var/datum/stat_mod/SM = elem
		if(SM.id == id)
			mods.Remove(SM)
			return

/datum/stat/proc/get_modifier(id)
	for(var/elem in mods)
		var/datum/stat_mod/SM = elem
		if(SM.id == id)
			return SM

/datum/stat/proc/changeValue(affect)
	value = value + affect

/datum/stat/proc/changeValue_withcap(affect)
	if(value > SKILL_VALUE_MAXIMUM)
		return

	if(value + affect > SKILL_VALUE_MAXIMUM)
		value = SKILL_VALUE_MAXIMUM
	else
		value = value + affect


/datum/stat/proc/getValue(pure = FALSE)
	if(pure)
		return value
	else
		. = value
		for(var/elem in mods)
			var/datum/stat_mod/SM = elem
			if(SM.time != -1 && SM.time < world.time)
				mods -= SM
				qdel(SM)
				continue
			. += SM.value

/datum/stat/proc/setValue(value)
	src.value = value

//Unused but might be good for later additions
/datum/stat/proc/setValue_withcap(value)
	if(value > SKILL_VALUE_MAXIMUM)
		src.value = SKILL_VALUE_MAXIMUM
	else
		src.value = value

/datum/stat/athletics
	name = SKILL_ATH
	desc = "Life is a constant race against time, with obstacles at every turn. Mastery of athletic skills grants the character unparalleled agility, speed, and endurance, allowing them to push their physical limits and navigate treacherous terrains with ease."
	linked_special = SPECIAL_A
	img = 'html/images/stats/skills/athletics.png'

/datum/stat/lockpick
	name = SKILL_LOC
	desc = "Locks are like secrets, waiting to be unraveled. With nimble fingers and a keen eye for detail, you excel at manipulating mechanisms and opening doors to the unknown."
	linked_special = SPECIAL_P
	img = 'html/images/stats/skills/lockpicking.png'

/datum/stat/medicine
	name = SKILL_MED
	desc = "Life hangs by a thread, and you possess the knowledge to weave it back together. Skilled in the art of healing, you mend wounds, alleviate suffering, and understand the intricacies of the human body."
	linked_special = SPECIAL_I
	img = 'html/images/stats/skills/medicine.png'

/datum/stat/repair
	name = SKILL_REP
	desc = "Every piece has its place, and every broken thing yearns to be whole again. Aptitude in repairing and restoring a wide range of mechanical and technological devices, allowing you to mend, improve and create equipment and machinery."
	linked_special = SPECIAL_I
	img = 'html/images/stats/skills/repair.png'

/datum/stat/science
	name = SKILL_SCI
	desc = "(Science)"
	linked_special = SPECIAL_I
	img = 'html/images/stats/skills/science.png'

/datum/stat/survival
	name = SKILL_SUR
	desc = "In the wilderness, instincts guide your every move. You can read the signs of nature, find sustenance in the harshest environments, and adapt to any circumstance. Your expertise in survival skills keeps you alive against all odds."
	linked_special = SPECIAL_E
	img = 'html/images/stats/skills/survival.png'

/datum/stat/big_guns
	name = SKILL_BIG
	desc = "Amidst the chaos, you emerge as the wielder of immense power. Your mastery of big guns grants you the ability to harness the fury of heavy weaponry. From heavy machineguns to flamethrowers and miniguns, you rain devastation upon your foes with unmatched precision and overwhelming firepower."
	linked_special = SPECIAL_E
	img = 'html/images/stats/skills/bigguns.png'

/datum/stat/energy_guns
	name = SKILL_ENE
	desc = "Harness the power of the stars and wield beams of pure energy. With proficiency in energy guns, you become a force to be reckoned with, disintegrating targets and searing through armor with futuristic weapons."
	linked_special = SPECIAL_P
	img = 'html/images/stats/skills/energyguns.png'

/datum/stat/explosives
	name = SKILL_EXP
	desc = "Embrace the controlled chaos of destruction. Skilled in explosives, you strategically deploy bombs, mines, and grenades, turning the tide of battle with devastating blasts and calculated explosions."
	linked_special = SPECIAL_P
	img = 'html/images/stats/skills/explosives.png'

/datum/stat/melee_weapons
	name = SKILL_MEL
	desc = "When steel clashes and sweat fills the air, you stand firm as a master of close-quarters combat. Your proficiency in melee weapons grants deadly precision, strength, and agility, allowing you to carve through enemies with lethal strikes."
	linked_special = SPECIAL_S
	img = 'html/images/stats/skills/melee.png'

/datum/stat/small_guns
	name = SKILL_SMA
	desc = "In the realm of quick-draw and sharp aim, you embody deadly accuracy. Proficient with pistols, rifles, and compact firearms, you unleash a storm of bullets, taking down enemies with calculated shots."
	linked_special = SPECIAL_A
	img = 'html/images/stats/skills/smallguns.png'

/datum/stat/unarmed
	name = SKILL_UNA
	desc = "When all weapons are stripped away, you remain an unyielding force. Skilled in unarmed combat, you deliver bone-crushing punches, lightning-fast strikes, and devastating kicks. Utilize your body as the ultimate weapon and overpower opponents with sheer skill."
	linked_special = SPECIAL_S
	img = 'html/images/stats/skills/unarmed.png'

// Use to perform stat checks
/mob/proc/stat_check(stat_path, needed)
	var/points = src.stats.getStat(stat_path)
	return points >= needed

/proc/skillPointsToLevel(var/points)
	switch(points)
		if (SKILL_LEVEL_NONE to SKILL_LEVEL_BASIC)
			return "Untrained"
		if (SKILL_LEVEL_BASIC to SKILL_LEVEL_ADEPT)
			return "Basic"
		if (SKILL_LEVEL_ADEPT to SKILL_LEVEL_EXPERT)
			return "Adept"
		if (SKILL_LEVEL_EXPERT to SKILL_LEVEL_PROF)
			return "Expert"
		if (SKILL_LEVEL_PROF to INFINITY)
			return "Master"

/datum/stat/special
	value = SPECIAL_VALUE_DEFAULT
	var/list/special_desc

/datum/stat/special/changeValue_withcap(affect)
	if(value > SPECIAL_VALUE_MAXIMUM)
		return

	if(value + affect > SPECIAL_VALUE_MAXIMUM)
		value = SPECIAL_VALUE_MAXIMUM
	else if(value + affect < SPECIAL_VALUE_MINIMUM)
		value = SPECIAL_VALUE_MINIMUM
	else
		value = value + affect

/datum/stat/special/strength
	name = SPECIAL_S
	desc = "Raw physical strength. A high Strength is good for physical characters."
	special_desc = list("Wet Noodle","Beached Jellyfish","Doughy Baby","Lightweight","Average Joe","Barrel Chested","Beach Bully","Circus Strongman","Doomsday Pecs","Hercules' Bigger Cousin")
	img = 'html/images/stats/special/strength.png'

/datum/stat/special/perception
	name = SPECIAL_P
	desc = "The ability to see, hear, taste and notice unusual things. A high Perception is important for a sharpshooter."
	special_desc = list("Deaf Bat","Senile Mole","Squinting Newt","Unsuspecting Trout","Wary Trout","Alert Coyote","Big-Eyed Tiger","Monocled Falcon","Sniper Hawk","Eagle with Telescope")
	img = 'html/images/stats/special/perception.png'

/datum/stat/special/endurance
	name = SPECIAL_E
	desc = "Stamina and physical toughness. A character with a high Endurance will survive where others may not."
	special_desc = list("Basically Dead","Crumbly","Do Not Bend","Handle With Care","Stain-Resistant","Hardy","Tough-as-nails","Flame Retardant","Bullet Proof","Unstoppable")
	img = 'html/images/stats/special/endurance.png'

/datum/stat/special/charisma
	name = SPECIAL_C
	desc = "A combination of appearance and charm. A high Charisma is important for characters that want to influence people with words."
	special_desc = list("Misanthrope","Old Hermit","Creepy Undertaker","Peevish Librarian","Substitute Teacher","Cheery Salesman","Diplomat","Movie Star","Casanova","Cult Leader")
	img = 'html/images/stats/special/charisma.png'

/datum/stat/special/intelligence
	name = SPECIAL_I
	desc = "Knowledge, wisdom and the ability to think quickly. A high Intelligence is important for any character."
	special_desc = list("Sub-Brick","Vegetable","Cretin","Knuckle Head","Knowledgeable","Gifted","Smartypants","Know-It-All","Genius","Omniscient")
	img = 'html/images/stats/special/intelligence.png'

/datum/stat/special/agility
	name = SPECIAL_A
	desc = "Coordination and the ability to move well. A high Agility is important for any active character."
	special_desc = list("Walking Disaster","Accident Prone","Oaf","Butterfingers","Under Control","Catlike","Knife Thrower","Knife Catcher","Acrobatic Marvel","Walks on Water")
	img = 'html/images/stats/special/agility.png'

/datum/stat/special/luck
	name = SPECIAL_L
	desc = "Fate. Karma. An extremely high or low Luck will affect the character - somehow."
	special_desc = list("13 Pitch-Black Cats","Broken Gypsy Mirror","Sickly Albatross","Spilled Salt","Coin Flip","Stacked Deck","Lucky 7","Leprechaun's Foot","21 Leaf Clover","Two-Headed Coin Flip")
	img = 'html/images/stats/special/luck.png'

/datum/stat/special/proc/specialToLevel(var/points)
	return special_desc[points]

/datum/stat/special/proc/getSpecial(pure = FALSE)
	. += value - 5
	if(!pure)
		for(var/elem in mods)
			var/datum/stat_mod/SM = elem
			if(SM.time != -1 && SM.time < world.time)
				mods -= SM
				qdel(SM)
				continue
			. += SM.value
	if(. < 0)
		. *= 7.5
	else
		. *= 20
