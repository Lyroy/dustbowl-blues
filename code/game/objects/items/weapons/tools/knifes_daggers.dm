
//Knifes

/obj/item/tool/knife
	name = "kitchen knife"
	desc = "A general purpose Chef's Knife made by the Lonestar Shipping Solutions, LLC. Guaranteed to stay sharp for years to come."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife"
	flags = CONDUCT
	sharp = TRUE
	edge = TRUE
	worksound = WORKSOUND_HARD_SLASH
	w_class = ITEM_SIZE_SMALL
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_DANGEROUS
	armor_penetration = ARMOR_PEN_SHALLOW
	max_upgrades = 2
	tool_qualities = list(QUALITY_CUTTING = 20,  QUALITY_WIRE_CUTTING = 10, QUALITY_SCREW_DRIVING = 5)
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 1)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/sharphit.ogg'
	slot_flags = SLOT_BELT
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE
	var/backstab_damage = 10

	has_alt_mode = TRUE
	alt_mode_damagetype = HALLOSS
	alt_mode_sharp = FALSE
	alt_mode_verbs = list("bashes", "stunts", "wacks", "blunts")
	alt_mode_toggle = "switches their stance to avoid using the blade of their weapon"
	alt_mode_lossrate = 0.7

/obj/item/tool/knife/resolve_attackby(atom/target, mob/user)
	. = ..()
	if(!(iscarbon(target) || isanimal(target)))
		return
	if(get_turf(target) != get_step(user, user.dir))
		return
	if(target.stat == DEAD)
		return
	if(user.dir != target.dir)
		return
	if(alt_mode_active)
		return
	var/mob/living/carbon/M = target
	M.apply_damages(backstab_damage,0,0,0,0,0,user.targeted_organ)
	visible_message("<span class='danger'>[user] backstabs [target] with [src]!</span>")
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been backstabbed by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Backstabbed [M.name] ([M.ckey])</font>")
	//Uses regular call to deal damage
	//Is affected by mob armor*

/obj/item/tool/knife/boot
	name = "boot knife"
	desc = "A small fixed-blade knife for putting inside a boot."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	matter = list(MATERIAL_PLASTEEL = 2, MATERIAL_PLASTIC = 1)
	force = WEAPON_FORCE_PAINFUL
	backstab_damage = 14
	tool_qualities = list(QUALITY_CUTTING = 20,  QUALITY_WIRE_CUTTING = 10, QUALITY_SCREW_DRIVING = 15)

/*
/obj/item/tool/knife/boot/blackshield
	name = "blackshield tactical knife"
	desc = "A small fixed-blade knife for putting inside a boot, this version is painted in Blackshield colours and has sawed teeth."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife_blackguard"
	item_state = "knife"
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 2)
	tool_qualities = list(QUALITY_CUTTING = 20,  QUALITY_WIRE_CUTTING = 10, QUALITY_SCREW_DRIVING = 5,  QUALITY_SAWING = 1)
	force = WEAPON_FORCE_DANGEROUS // Serrated teeth
	armor_penetration = ARMOR_PEN_MODERATE
	throwforce = WEAPON_FORCE_LETHAL
	price_tag = 35
*/

/obj/item/tool/knife/hook
	name = "meat hook"
	desc = "A sharp plasteel butcher's hook used to hold dressed game in place to butcher. It has quite the sharpened tip to embed more easily in flesh."
	icon_state = "hook_knife"
	item_state = "hook_knife"
	matter = list(MATERIAL_PLASTEEL = 5, MATERIAL_PLASTIC = 2)
	force = WEAPON_FORCE_DANGEROUS
	backstab_damage = 8
	armor_penetration = ARMOR_PEN_EXTREME //Should be countered be embedding
	embed_mult = 1.5 //This is designed for embedding

/obj/item/tool/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	force = WEAPON_FORCE_PAINFUL
	armor_penetration = ARMOR_PEN_MODERATE
	max_upgrades = 3
	backstab_damage = 14
	price_tag = 7

/obj/item/tool/knife/ritual/sickle
	name = "bloodletter"
	desc = "A ritual knife, its latent unearthly energies partly awoken by forces unknown. \
			The curved blade cuts deep into flesh, drawing blood for rituals with ease."
	icon_state = "render_awakened"
	hitsound = 'sound/weapons/renderslash.ogg'
	force = WEAPON_FORCE_DANGEROUS
	armor_penetration = ARMOR_PEN_DEEP
	max_upgrades = 2
	hitsound = 'sound/weapons/renderslash.ogg'
	backstab_damage = 8 // Not so much for stabbing as it is for cutting.
	tool_qualities = list(QUALITY_CUTTING = 20, QUALITY_WIRE_CUTTING = 10)
	attack_verb = list("slashed", "sliced", "ripped", "diced", "cut")
	embed_mult = 1.5 // Careful not to lose it!

/obj/item/tool/knife/butch
	name = "butcher's cleaver"
	icon_state = "butch"
	desc = "A huge thing used for chopping up vegetables and meat. This includes roaches and roach-byproducts."
	force = WEAPON_FORCE_DANGEROUS
	throwforce = WEAPON_FORCE_DANGEROUS+2
	backstab_damage = 8
	armor_penetration = ARMOR_PEN_MODERATE
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	matter = list(MATERIAL_STEEL = 5, MATERIAL_PLASTIC = 1)
	tool_qualities = list(QUALITY_CUTTING = 20,  QUALITY_WIRE_CUTTING = 15)
	price_tag = 14

/*
/obj/item/tool/knife/tacknife
	name = "tactical knife"
	desc = "You'd be killing loads of people if this was Medal of Valor: Heroes of Space."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife_guard"
	item_state = "knife"
	backstab_damage = 14
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 2)
	force = WEAPON_FORCE_DANGEROUS // Serrated combat knife
	tool_qualities = list(QUALITY_CUTTING = 20,  QUALITY_WIRE_CUTTING = 10, QUALITY_SCREW_DRIVING = 5,  QUALITY_SAWING = 5)
	armor_penetration = ARMOR_PEN_MODERATE
	throwforce = WEAPON_FORCE_LETHAL
	max_upgrades = 3
	embed_mult = 0.6
	price_tag = 38
*/

/obj/item/tool/knife/dagger
	name = "dagger"
	desc = "A sharp implement; difference between this and a knife: it's sharp on both sides. Good for finding holes in armor and exploiting them."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dagger"
	item_state = "dagger"
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 2)
	force = 13
	backstab_damage = 15
	armor_penetration = ARMOR_PEN_HALF
	throwforce = WEAPON_FORCE_ROBUST
	price_tag = 21

/obj/item/tool/knife/dagger/skinning
	name = "skinning knife"
	desc = "A sharp tool that is the pride and joy of the local Hunting Lodge. While not well suited as a weapon, its blade is as finely edged as any laser scalpel. Considered sacred by \
	the hunters that normally carry them."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "skinning"
	item_state = "skinning"
	armor_penetration = ARMOR_PEN_DEEP
	tool_qualities = list(QUALITY_CUTTING = 50)
	matter = list(MATERIAL_PLASTEEL = 8, MATERIAL_WOOD = 2, MATERIAL_DIAMOND = 3) // 5 plasteel + 2 wood, then +3 plasteel +3 diamond from whetstone.
	price_tag = 500 // Takes diamond to make and very rare.

/*
/obj/item/tool/knife/dagger/ceremonial
	name = "ceremonial dagger"
	desc = "Given to high ranking officers as a signature of office, while it isn't meant to be a weapon it certainly does the job."
	icon_state = "fancydagger"
	item_state = "fancydagger"
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 2, MATERIAL_GOLD = 1, MATERIAL_SILVER = 1)
	embed_mult = 0.6
	max_upgrades = 4
	price_tag = 300 // Fancy expensive paper weight.
*/

/obj/item/tool/knife/dagger/heirloom_knife
	name = "heirloom dagger"
	desc = "This dagger was given to generations of family members that once hunted as a faint memory of trust and hope, while it isn't meant to be a weapon it certainly does the job of cutting things. Extremely handy not exactly valuable yet precious."
	icon_state = "general_skinningknife"
	item_state = "fancydagger"
	matter = list(MATERIAL_PLASTEEL = 3, MATERIAL_PLASTIC = 2, MATERIAL_SILVER = 1)
	embed_mult = 0.7
	max_upgrades = 0
	price_tag = 50 // Fancy expensive heirloom.... it is not exactly meant to be upgradable nor sold but the value that it holds is somehow more symbolic than material.
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_ROBUST
	armor_penetration = ARMOR_PEN_GRAZING
	tool_qualities = list(QUALITY_CUTTING = 35) //Can't be upgraded. Round start knife. Damage is bad not really good to selling either. Only fair give a good status to cutting things.
	backstab_damage = 9

