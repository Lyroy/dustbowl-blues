/obj/item/tool/saw //tier 2
	name = "metal saw"
	desc = "For cutting wood and other objects to pieces. Or sawing bones, in case of emergency."
	icon_state = "metal_saw"
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	worksound = WORKSOUND_SIMPLE_SAW
	flags = CONDUCT
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 1)
	attack_type = (DOUBLE_TACT | CAN_SWING | CAN_BROAD | FORCED_BROAD)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = TRUE
	edge = TRUE
	tool_qualities = list(QUALITY_SAWING = 45, QUALITY_CUTTING = 30, QUALITY_WIRE_CUTTING = 30)
	price_tag = 20
	embed_mult = 1 //Serrated blades catch on bone more easily

/obj/item/tool/saw/bs
	name = "bluespace metal saw"
	icon_state = "bs_metal_saw"
	tool_qualities = list(QUALITY_SAWING = 100, QUALITY_CUTTING = 100, QUALITY_WIRE_CUTTING = 100)

/obj/item/tool/saw/improvised
	name = "choppa"
	desc = "An improvised saw made of twisted, wicked metal. The serrated blade, with ample space for tool mods, is great for cutting."
	icon_state = "impro_saw"
	force = WEAPON_FORCE_PAINFUL //doubles as makeshift melee weapon, thus must have more damage than tier 2 saw
	tool_qualities = list(QUALITY_SAWING = 15, QUALITY_CUTTING = 10, QUALITY_WIRE_CUTTING = 10)
	degradation = 1
	max_upgrades = 5 //all makeshift tools get more mods to make them actually viable for mid-late game
	price_tag = 7

/obj/item/tool/saw/medical
	name = "medical saw"
	icon_state = "bs_metal_saw"
	force = WEAPON_FORCE_PAINFUL
	tool_qualities = list(QUALITY_SAWING = 60, QUALITY_CUTTING = 40, QUALITY_WIRE_CUTTING = 40)
	degradation = 2.65

/obj/item/tool/saw/chain //for shits and giggles were keeping this
	name = "chainsaw"
	desc = "You can cut trees, people, walls, and zombies with it, just watch out for fuel."
	icon_state = "chainsaw"
	hitsound = WORKSOUND_CHAINSAW
	worksound = WORKSOUND_CHAINSAW
	force = WEAPON_FORCE_WEAK
	switched_on_forcemult = 4 //28 total
	w_class = ITEM_SIZE_NORMAL
	armor_penetration = ARMOR_PEN_SHALLOW
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 2)
	tool_qualities = list(QUALITY_SAWING = 5, QUALITY_CUTTING = 5, QUALITY_WIRE_CUTTING = 5) //barely usable when off, but allows mods to be applied
	switched_off_qualities = list(QUALITY_CUTTING = 5)
	max_upgrades = 3
	use_fuel_cost = 0.1
	toggleable = TRUE
	switched_on_qualities = list(QUALITY_SAWING = 60, QUALITY_CUTTING = 50, QUALITY_WIRE_CUTTING = 20)
	max_fuel = 80
	price_tag = 550

/obj/item/tool/saw/chain/turn_on(mob/user)
	.=..()
	if(.)
		to_chat(user, SPAN_NOTICE("You rev up the [src]."))
		playsound(loc, 'sound/items/chainsaw_on.ogg', 40)
		START_PROCESSING(SSobj, src)

/obj/item/tool/saw/chain/turn_off()
	playsound(loc, 'sound/items/chainsaw_off.ogg', 80)
	..()
