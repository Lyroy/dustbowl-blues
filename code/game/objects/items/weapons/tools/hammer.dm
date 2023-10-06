/obj/item/tool/hammer
	name = "hammer"
	desc = "Used for applying blunt force to a surface."
	icon_state = "hammer"
	item_state = "hammer"
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFUL
	worksound = WORKSOUND_HAMMER
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 4, MATERIAL_WOOD = 2)
	price_tag = 30
	attack_type = (DOUBLE_TACT | CAN_SWING)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked","flattened","pulped")
	tool_qualities = list(QUALITY_HAMMERING = 35, QUALITY_PRYING = 10)
	effective_faction = list("spider") // Spiders are weak to crushing.
	damage_mult = 2
	hitsound = 'sound/weapons/smash.ogg'

	has_alt_mode = TRUE
	alt_mode_damagetype = HALLOSS
	alt_mode_sharp = FALSE
	alt_mode_verbs = list("bashes", "stunts", "wacks", "blunts")
	alt_mode_toggle = "loosens their grip on the handle of their weapon"
	alt_mode_lossrate = 0.4


/obj/item/tool/hammer/deadblow
	name = "deadblow hammer"
	desc = "Used for applying blunt force to a surface. This one has sand inside its plasteel head to help do strikes much more constantly in the same place with the same force well reducing trama onto soft surfaces."
	icon_state = "deadblow"
	item_state = "hammer"
	tool_qualities = list(QUALITY_HAMMERING = 45)
	matter = list(MATERIAL_STEEL = 4, MATERIAL_WOOD = 2, MATERIAL_GLASS = 1, MATERIAL_PLASTEEL = 2)
	attack_verb = list("attacked", "blunted", "brused", "smacked", "whacked", "striked", "bonked")
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 3)

/obj/item/tool/hammer/foremansledge
	name = "foreman's sledgehammer"
	desc = "Once a tool used to nail rivets, now a tool used to crush skulls."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sledgehammer"
	item_state = "sledgehammer0"
	wielded_icon = "sledgehammer1"
	force = WEAPON_FORCE_LETHAL
	slot_flags = SLOT_BELT|SLOT_BACK
	armor_penetration = ARMOR_PEN_EXTREME
	throwforce = WEAPON_FORCE_LETHAL
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_PLASTIC = 5)
	throw_speed = 1
	throw_range = 7
	w_class = ITEM_SIZE_BULKY
	origin_tech = list(TECH_COMBAT = 3)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked","flattened","pulped")
	structure_damage_factor = STRUCTURE_DAMAGE_BREACHING
	tool_qualities = list(QUALITY_HAMMERING = 45)
	price_tag = 2000

/obj/item/tool/hammer/homewrecker
	name = "homewrecker"
	desc = "A large steel chunk welded to a long handle. Extremely heavy."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "homewrecker"
	item_state = "homewrecker0"
	wielded_icon = "homewrecker1"
	armor_penetration = ARMOR_PEN_EXTREME
	w_class = ITEM_SIZE_BULKY
	slot_flags = SLOT_BELT|SLOT_BACK
	force = WEAPON_FORCE_ROBUST
	tool_qualities = list(QUALITY_HAMMERING = 15)
	attack_verb = list("attacked", "smashed", "bludgeoned", "beaten")
	structure_damage_factor = STRUCTURE_DAMAGE_HEAVY
	max_upgrades = 5
	price_tag = 15

/obj/item/tool/hammer/mace
	name = "mace"
	desc = "Used for applying blunt force trauma to a person's rib cage."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "mace"
	item_state = "mace"
	matter = list(MATERIAL_STEEL = 10)
	price_tag = 30

	armor_penetration = ARMOR_PEN_DEEP
	force = WEAPON_FORCE_DANGEROUS

	tool_qualities = list(QUALITY_HAMMERING = 20)

/obj/item/tool/hammer/mace/makeshift
	name = "makeshift mace"
	desc = "Some metal attached to the end of a stick, for applying blunt force trauma to a roach."
	icon_state = "ghetto_mace"
	item_state = "ghetto_mace"

	force = WEAPON_FORCE_PAINFUL

	tool_qualities = list(QUALITY_HAMMERING = 15)
	price_tag = 20
	degradation = 5 //This one breaks REALLY fast
	max_upgrades = 5 //all makeshift tools get more mods to make them actually viable for mid-late game

/obj/item/tool/hammer/makeshift_staff
	name = "makeshift staff"
	desc = "Three rods, some duct tape and a lot of bloodlust give you this."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "makeshift_staff"
	item_state = "makeshift_staff"
	wielded_icon = "makeshift_staff_wielded"
	tool_qualities = list(QUALITY_HAMMERING = 5)
	matter = list(MATERIAL_STEEL = 3)
	max_upgrades = 3
	armor_penetration = ARMOR_PEN_GRAZING
	force = WEAPON_FORCE_PAINFUL
	w_class = ITEM_SIZE_HUGE

/obj/item/tool/hammer/dumbbell
	name = "dumbbell"
	desc = "To get stronger with this thing, you need to regularly train for many a month. But to hammer a nail, or crack a skull..."
	icon_state = "dumbbell"
	item_state = "dumbbell"
	tool_qualities = list(QUALITY_HAMMERING = 15)
	matter = list(MATERIAL_STEEL = 5)
