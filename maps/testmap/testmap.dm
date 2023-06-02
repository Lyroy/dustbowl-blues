#include "test_map.dmm"

/obj/map_data/testmap
	name = "Testmap"
	is_station_level = TRUE
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = FALSE
	is_sealed = TRUE
	height = 3

/area/testmap_indoors
	ship_area = TRUE
	icon_state = "erisblue"
	outdoors = FALSE
	underground = FALSE

/area/testmap_outdoors
	ship_area = TRUE
	icon_state = "erisyellow"
	outdoors = TRUE
	underground = FALSE

/area/testmap_outdoors_up
	ship_area = TRUE
	icon_state = "erisyellow"
	outdoors = TRUE
	underground = FALSE

/area/testmap_outdoors_very_up
	ship_area = TRUE
	icon_state = "erisyellow"
	outdoors = TRUE
	underground = FALSE
