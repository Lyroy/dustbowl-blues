/*
	Department Datums
	Currently only used for a non-shitcode way of having variable initial balances in department accounts
	in future, should be a holder for job datums
*/

/datum/department
	var/name = "unspecified department"	//Name may be shown in UIs, proper capitalisation
	var/id	= "department" //This should be one of the DEPARTMENT_XXX defines in __defines/jobs.dm
	var/account_number = 0
	var/account_pin
	var/account_initial_balance = 3500	//How much money this account starts off with
	var/list/jobs_in_department = list()

	// With external, this is the name of an organisation
	// Adding a funding source makes the game pay them out of thin air.
	// Adding in a department flag (see sojourn-station/code/__DEFINES/jobs.dm) will make it draw form said account to wire funds for payment of wages.
	// This is takes form the source budget_bage + wages per person
	var/funding_source

	// Budget for misc department expenses, paid regardless of it being manned or not
	var/budget_base = 0

	// Budget for crew salaries. Summed up initial wages of department's personnel
	var/budget_personnel = 0


	// How much account failed to pay to employees. Used for emails
	var/total_debt = 0

/datum/department/proc/get_total_budget()
	if(funding_source)
		return budget_base + budget_personnel
	else
		return FALSE


/datum/department/wayward_winds
	name = "Wayward Winds"
	id = FACTION_WAYWARD
	account_initial_balance = 57800 //50k for emergencies, 7800 for the wages if both have nepotism to last 5 hour shift if it comes to it, shouldn't ever need any more.
	jobs_in_department = list("/datum/job/premier","/datum/job/pg")

/datum/department/skymarshal
	name = "Sky Marshals"
	id = FACTION_SKYMARSHAL
	account_initial_balance = 46000 //Estimated 4k extra credits than what is required for wages on a full roster.
	jobs_in_department = list("/datum/job/smc","/datum/job/swo","/datum/job/supsec","/datum/job/serg","/datum/job/inspector","/datum/job/medspec","/datum/job/trooper","/datum/job/officer")

/datum/department/followers
	name = "Followers of the Apocalypse"
	id = FACTION_FOLLOWERS
	account_initial_balance = 17000 //17000 to cover some expenses but not that much
	jobs_in_department = list("/datum/job/chief_engineer","/datum/job/technomancer")

/datum/department/tribe
	name = "Placeholder Tribe"
	id = FACTION_TRIBE
	account_initial_balance = 0
	jobs_in_department = list("/datum/job/clubmanager","/datum/job/clubworker","/datum/job/hydro","/datum/job/artist","/datum/job/janitor")

/datum/department/wastelanders
	name = "Wastelanders"
	id = FACTION_WASTELANDERS
	account_initial_balance = 30250 //Covers crew-cost. Rest should be made up for by medical fees and chem sales.
	jobs_in_department = list("datum/job/cmo","/datum/job/doctor","/datum/job/recovery_team","/datum/job/psychiatrist")

/datum/department/raiders
	name = "Raiders"
	id = FACTION_RAIDERS
	account_initial_balance = 24500 //Covers wages of employees. Sell posis and whatever else to make up for material cost.
	jobs_in_department = list("/datum/job/rd","/datum/job/scientist","/datum/job/roboticist")

/datum/department/bos
	name = "Brotherhood Outcasts"
	id = FACTION_BOS
	account_initial_balance = 17000 //17000 to cover some expenses but not that much
	jobs_in_department = list ("/datum/job/chaplain","/datum/job/acolyte")

/datum/department/enclave
	name = "Civil Defense"
	id = FACTION_ENCLAVE
	account_initial_balance = 18200 //Has a lot of workers to pay - but their /entire/ job is literally to make money. Should cover the base nessessities of hourly payment.
	jobs_in_department = list("/datum/job/merchant","/datum/job/cargo_tech","/datum/job/mining")


///////////////////////DEPARTMENT EXPERIENCE PERKS//////////////////////////////////////////

/datum/perk/experienced
	name = "Experienced: HOLDER"
	desc = "This is only a test."
	active = FALSE
	passivePerk = FALSE
	var/subPerk = FALSE
	var/datum/department/dept




/datum/perk/experienced/activate()
	..()
	var/list/perkChoice
	var/paths = subtypesof(type)
	for (var/T in paths)
		var/datum/perk/experienced/checker = new T
		if (checker)
			if ((checker.dept == dept)&&(checker.subPerk))
				perkChoice += list(checker)

	var/datum/perk/experienced/choice = input("Hey, this is the first text.", "SECOND!", FALSE) as anything in perkChoice
	if (istype(choice,/datum/perk/experienced))
		holder.stats.addPerk(choice.type)
	holder.stats.removePerk(type)
