#define TURF_REMOVE_CROWBAR				1
#define TURF_REMOVE_SCREWDRIVER			2
#define TURF_REMOVE_SHOVEL				4
#define TURF_REMOVE_WRENCH				8
#define TURF_REMOVE_WELDER				16
#define TURF_CAN_BREAK					32
#define TURF_CAN_BURN					64
#define TURF_EDGES_EXTERNAL				128
#define TURF_HAS_CORNERS				256
#define TURF_HAS_INNER_CORNERS			512
#define TURF_IS_FRAGILE					1024
#define TURF_ACID_IMMUNE       			2048
#define TURF_HIDES_THINGS				4096
#define TURF_CAN_HAVE_RANDOM_BORDER		4096



//Used for floor/wall smoothing
#define SMOOTH_NONE 0	//Smooth only with itself
#define SMOOTH_ALL 1	//Smooth with all of type
#define SMOOTH_WHITELIST 2	//Smooth with a whitelist of subtypes
#define SMOOTH_BLACKLIST 3 //Smooth with all but a blacklist of subtypes
#define SMOOTH_GREYLIST 4 // Use a whitelist and a blacklist at the same time. atom smoothing only

#define NORTH_JUNCTION NORTH //(1<<0)
#define SOUTH_JUNCTION SOUTH //(1<<1)
#define EAST_JUNCTION EAST  //(1<<2)
#define WEST_JUNCTION WEST  //(1<<3)
#define NORTHEAST_JUNCTION (1<<4)
#define SOUTHEAST_JUNCTION (1<<5)
#define SOUTHWEST_JUNCTION (1<<6)
#define NORTHWEST_JUNCTION (1<<7)

/*DEFINE_BITFIELD(smoothing_junction, list(
	"NORTH_JUNCTION" = NORTH_JUNCTION,
	"SOUTH_JUNCTION" = SOUTH_JUNCTION,
	"EAST_JUNCTION" = EAST_JUNCTION,
	"WEST_JUNCTION" = WEST_JUNCTION,
	"NORTHEAST_JUNCTION" = NORTHEAST_JUNCTION,
	"SOUTHEAST_JUNCTION" = SOUTHEAST_JUNCTION,
	"SOUTHWEST_JUNCTION" = SOUTHWEST_JUNCTION,
	"NORTHWEST_JUNCTION" = NORTHWEST_JUNCTION
))*/

#define ALL_JUNCTION_DIRECTIONS list(\
	NORTH_JUNCTION,\
	SOUTH_JUNCTION,\
	EAST_JUNCTION,\
	WEST_JUNCTION,\
	NORTHEAST_JUNCTION,\
	SOUTHEAST_JUNCTION,\
	SOUTHWEST_JUNCTION,\
	NORTHWEST_JUNCTION\
	)


#define DECK_HEIGHT 3	//3 metres in vertical height between decks
//Note that the height of a turf's airspace is defined elsewhere as 2.5 metres, this adds extra to account for floor thickness

//supposedly the fastest way to do this according to https://gist.github.com/Giacom/be635398926bb463b42a
///Returns a list of turf in a square
#define RANGE_TURFS(RADIUS, CENTER) \
	RECT_TURFS(RADIUS, RADIUS, CENTER)

#define RECT_TURFS(H_RADIUS, V_RADIUS, CENTER) \
	block( \
	locate(max(CENTER.x-(H_RADIUS),1),          max(CENTER.y-(V_RADIUS),1),          CENTER.z), \
	locate(min(CENTER.x+(H_RADIUS),world.maxx), min(CENTER.y+(V_RADIUS),world.maxy), CENTER.z) \
	)

#define trange(RADIUS, CENTER) \
  block( \
    locate(max(CENTER.x-(RADIUS),1),          max(CENTER.y-(RADIUS),1),          CENTER.z), \
    locate(min(CENTER.x+(RADIUS),world.maxx), min(CENTER.y+(RADIUS),world.maxy), CENTER.z) \
)

#define get_turf(atom) get_step(atom, 0)

/proc/dist3D(atom/A, atom/B)
	var/turf/a = get_turf(A)
	var/turf/b = get_turf(B)

	if (!a || !b)
		return 0

	var/vecX = A.x - B.x
	var/vecY = A.y - B.y
	var/vecZ = (A.y - B.y)*DECK_HEIGHT

	return abs(sqrt((vecX*vecX) + (vecY*vecY) +(vecZ*vecZ)))

/// Turf will be passable if density is 0
#define TURF_PATHING_PASS_DENSITY 0
/// Turf will be passable depending on [CanPass] return value
#define TURF_PATHING_PASS_PROC 1
/// Turf is never passable
#define TURF_PATHING_PASS_NO 2
