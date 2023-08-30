//Cargo
/datum/job/ww_branch_chief
	title = "Wayward Branch Chief"
	flag = MERCHANT
	department = FACTION_WAYWARD
	head_position = TRUE
	aster_guild_member = TRUE
	department_flag = WAYWARD | COMMAND
	faction = MAP_FACTION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Wayward Winds Company"
	difficulty = "Medium."
	selection_color = "#b3a68c"
	alt_titles = list("Wayward Branch Supervisor")
	wage = WAGE_NONE
	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant, access_mining,
		access_heads, access_mining_station, access_RC_announce, access_keycard_auth, access_sec_doors,
		access_eva, access_external_airlocks, access_hydroponics, access_bar, access_kitchen, access_theatre
	)

	ideal_character_age = 40
	minimum_character_age = 25
	playtimerequired = 1200

	stat_modifiers = list(
		SKILL_REP = SKILL_LEVEL_BASIC,
		SKILL_LOC = SKILL_LEVEL_BASIC
	)
	description = "The Branch Chief coordinates the affairs of the local branch of Wayward Winds.<br>\
Your main objective, bluntly, is to make as much money as you can. Purchase and acquire goods, and sell them on for a profit.<br>\
Your Peons will handle most of the grunt work and your Scrappers will acquire resources. They are capable - utilize them well.<br>\
The vendors found throughout Skyline are also operated by your organization. They make you money - ensure they are functional and well-stocked.<br>\
The other factions can provide you with much to export. Trade with them."

	duties = "Keep the population supplied with anything they might need - for a healthy profit.<br>\
Buy up valuable items from scavengers and make a profit reselling them.<br>\
Deploy your salvaging staff to harvest matter and materials.<br>\
Counsel the Foreman on directing Skyline towards profitable opportunities."

	outfit_type = /decl/hierarchy/outfit/job/cargo/merchant

	perks = list(PERK_TIMEISMONEY, PERK_MARKET_PROF, PERK_BARTENDER, PERK_CHEM_CONTRABAND)

/obj/landmark/join/start/ww_branch_chief
	name = "Wayward Branch Chief"
	icon_state = "player-beige-officer"
	join_tag = /datum/job/ww_branch_chief

/datum/job/ww_peon
	title = "Peon"
	flag = CARGOTECH
	department = FACTION_WAYWARD
	department_flag = WAYWARD
	faction = MAP_FACTION
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Wayward Branch Chief"
	difficulty = "Easy."
	alt_titles = list("Cargo Technician", "Cashier")
	selection_color = "#c3b9a6"
	wage = WAGE_NONE
	department_account_access = TRUE
	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech

	access = list(
		access_mailsorting, access_cargo, access_cargo_bot, access_mining,
		access_mining_station
	)

	stat_modifiers = list(
		SKILL_UNA = SKILL_LEVEL_BASIC,
		SKILL_MEL = SKILL_LEVEL_BASIC,
		SKILL_REP = SKILL_LEVEL_BASIC
	)

	perks = list(PERK_MARKET_PROF)

	description = "The Peon forms the backbone of Wayward Winds, equal parts loader and salesman.<br>\
Your main duty is to keep the local company branch operational and profitable. Deliver goods, take payments and orders, and buy from scavengers.<br>\
In quieter times, use your initiative. Visit factions to ask if there's anything they need and try to sell them unusual items.<br>\
Busted lights? Broken vendors? Offer your services for a small fee. You may also find profit in the wastes.<br>\
Avoid the more dangerous areas unless otherwise instructed, however - this domain is hazardous and for training scrappers."

	duties = "Staff the front desk and be ready to process payments and orders.<br>\
	Deliver goods to factions and individuals in good time.<br>\
	Always seek other forms of profit, but do so while keeping the company in a good light."

/obj/landmark/join/start/ww_peon
	name = "Peon"
	icon_state = "player-beige"
	join_tag = /datum/job/ww_peon

/datum/job/ww_scrapper
	title = "Scrapper"
	flag = MINER
	department = FACTION_WAYWARD
	department_flag = LSS
	faction = MAP_FACTION
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Chief Executive Officer"
	difficulty = "Easy."
	alt_titles = list("Lonestar Drill Technician", "Junior Lonestar Miner")
	selection_color = "#c3b9a6"
	wage = WAGE_LABOUR_HAZARD //The miners union is stubborn
	health_modifier = 5

	disallow_species = list(FORM_BSSYNTH, FORM_CHURCHSYNTH)
	outfit_type = /decl/hierarchy/outfit/job/cargo/mining

	description = "The Miner is a professional resource procurer, acquiring valuable minerals for Lonestar Shipping Solutions.<br>\
Your primary responsibility is to descend into the deep tunnels and dig up as much ore as you can.<br>\
Accessed by elevator, the area contains an outpost with all the facilities to process said ore and deliver refined materials ready for use.<br>\
Whatever you dig up will go to the cargo department, and from then on it is the responsibility of others within Lonestar to sell it.<br>\
The deep tunnels are far less dangerous than the wilderness, but pack well - disappearances are not unheard of."

	duties = "Dig up ores and minerals to be processed into usable material.<br>\
	Locate other valuables within the tunnels that may be turned to profit."

	access = list(
		access_maint_tunnels, access_mailsorting, access_mining,
		access_mining_station
	)

	perks = list(PERK_MARKET_PROF)

	stat_modifiers = list(
		STAT_ROB = 15,
		STAT_TGH = 15,
		STAT_VIG = 15,
		STAT_MEC = 15
	)

	software_on_spawn = list(///datum/computer_file/program/supply,
							 ///datum/computer_file/program/deck_management,
							 /datum/computer_file/program/wordprocessor,
							 /datum/computer_file/program/reports)

/obj/landmark/join/start/mining
	name = "Lonestar Miner"
	icon_state = "player-beige"
	join_tag = /datum/job/mining
