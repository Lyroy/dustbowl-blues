/datum/gear/belt
	display_name = "champion belt"
	path = /obj/item/storage/belt/champion
	slot = slot_belt
	sort_category = "Utility belts"
	cost = 4

/datum/gear/belt/tool
	display_name = "tool belt"
	path = /obj/item/storage/belt/utility
	cost = 2

/datum/gear/belt/toolbelt
	display_name = "handmade tool belt"
	path = /obj/item/storage/belt/utility/handmade
	cost = 2


/datum/gear/belt/medbelt
	display_name = "Medical belt, Selection EMT / Doctor"
	path = /obj/item/storage/belt/medical
	allowed_roles = list("Soteria Doctor","Soteria Biolab Officer","Soteria Lifeline Technician")
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION



