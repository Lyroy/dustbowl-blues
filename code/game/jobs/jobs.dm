GLOBAL_LIST_INIT(faction_wayward, list(FACTION_WAYWARD))
GLOBAL_LIST_INIT(faction_skymarshal, list(FACTION_SKYMARSHAL))
GLOBAL_LIST_INIT(faction_followers, list(FACTION_FOLLOWERS))
GLOBAL_LIST_INIT(faction_tribe, list(FACTION_TRIBE))
GLOBAL_LIST_INIT(faction_wastelanders, list(FACTION_WASTELANDERS))
GLOBAL_LIST_INIT(faction_raiders, list(FACTION_RAIDERS))
GLOBAL_LIST_INIT(faction_bos, list(FACTION_BOS))

var/const/WAYWARD = (1<<0)
var/const/SKYMARSHAL = (1<<1)
var/const/FOLLOWERS = (1<<2)
var/const/TRIBE = (1<<3)
var/const/WASTELANDERS = (1<<4)
var/const/RAIDERS = (1<<5)
var/const/BOS = (1<<6)
var/const/COMMAND = (1<<7)

var/const/ENGSEC			=(1<<0)

var/const/PREMIER			=(1<<0)
var/const/SMC				=(1<<1)
var/const/SUPSEC			=(1<<2)
var/const/INSPECTOR			=(1<<3)
var/const/TROOPER			=(1<<4)
var/const/MEDSPEC			=(1<<5)
var/const/GUILDMASTER		=(1<<6)
var/const/ADEPT				=(1<<7)
var/const/AI				=(1<<8)
var/const/CYBORG			=(1<<9)
var/const/SWO				=(1<<10)
var/const/OFFICER			=(1<<11)
var/const/SERG				=(1<<12)


var/const/MEDSCI			=(1<<1)

var/const/CRO				=(1<<0)
var/const/SCIENTIST			=(1<<1)
var/const/RECOVERYTEAM		=(1<<2)
var/const/CBO				=(1<<3)
var/const/DOCTOR			=(1<<4)
var/const/PSYCHIATRIST		=(1<<5)
var/const/ROBOTICIST		=(1<<6)


var/const/STEWARD			=(1<<0)
var/const/CLUBMANAGER		=(1<<1)
var/const/CLUBWORKER		=(1<<2)
var/const/MERCHANT			=(1<<3)
var/const/CARGOTECH			=(1<<4)
var/const/MINER				=(1<<5)
var/const/ARTIST			=(1<<6)
var/const/ASSISTANT			=(1<<7)
var/const/JANITOR			=(1<<8)
var/const/BOTANIST			=(1<<9)
var/const/FOREMAN			=(1<<10)
var/const/SALVAGER			=(1<<11)
var/const/PROSPECTOR		=(1<<12)



var/const/CHAPLAIN			=(1<<0)
var/const/ACOLYTE			=(1<<1)

var/const/HUNTMASTER		=(1<<0)
var/const/LODGEHUNTER		=(1<<1)
var/const/OUTSIDER			=(1<<2)
var/const/LODGEHERBALIST	=(1<<3)

var/list/assistant_occupations = list()

var/list/command_positions = list(JOBS_COMMAND)

var/list/wayward_positions = list(JOBS_WAYWARD)

var/list/skymarshal_positions = list(JOBS_SKYMARSHAL)

var/list/followers_positions = list(JOBS_FOLLOWERS)

var/list/tribe_positions = list(JOBS_TRIBE)

var/list/wastelander_positions = list(JOBS_WASTELANDERS)

var/list/raider_positions = list(JOBS_RAIDERS)

var/list/bos_positions = list(JOBS_BOS)

/proc/guest_jobbans(var/job)
	return ((job in raider_positions))
