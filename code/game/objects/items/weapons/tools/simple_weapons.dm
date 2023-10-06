//Those are all weapons that don't had tool modding at some point, but should have it for balance purposes.

/obj/item/tool/broken_bottle
	name = "broken bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	matter = list(MATERIAL_GLASS = 2)
	worksound = WORKSOUND_HARD_SLASH
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_WEAK
	item_state = "beer"
	attack_verb = list("stabbed", "slashed", "attacked")
	sharp = TRUE
	edge = FALSE
	max_upgrades = 1 //it's not even a tool
	tool_qualities = list(QUALITY_CUTTING = 10)
	var/icon/broken_outline = icon('icons/obj/drinks.dmi', "broken")

/obj/item/tool/nailstick
	name = "nailed stick"
	desc = "Stick with some nails in it. Looks sharp enough."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hm_spikeclub"
	item_state = "hm_spikeclub"
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_PAINFUL
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("beaten", "slammed", "smacked", "struck", "battered")
	structure_damage_factor = STRUCTURE_DAMAGE_HEAVY
	max_upgrades = 5
	tool_qualities = list(QUALITY_HAMMERING = 10)
	effective_faction = list("spider") // Spiders are weak to crushing.
	damage_mult = 2

/obj/item/tool/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fiber-metal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hatchet"
	matter = list(MATERIAL_STEEL = 4, MATERIAL_PLASTIC = 3)
	worksound = WORKSOUND_HARD_SLASH
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_PAINFUL
	attack_type = CAN_BROAD
	w_class = ITEM_SIZE_SMALL
	sharp = TRUE
	edge = TRUE
	armor_penetration = ARMOR_PEN_SHALLOW
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	attack_verb = list("chopped", "torn", "cut")
	tool_qualities = list(QUALITY_CUTTING = 20, QUALITY_SAWING = 15)
	worksound = WORKSOUND_HARD_SLASH
	price_tag = 30

/obj/item/tool/fireaxe
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "fireaxe0"
	wielded_icon = "fireaxe1"
	sharp = TRUE
	edge = TRUE
	armor_penetration = ARMOR_PEN_DEEP
	tool_qualities = list(QUALITY_CUTTING = 10, QUALITY_PRYING = 20, QUALITY_SAWING = 15)
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	force = WEAPON_FORCE_BRUTAL
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	attack_type = (DOUBLE_TACT | CAN_SWING | CAN_BROAD | FORCED_BROAD)
	hitsound = 'sound/weapons/bladeslice.ogg'
	structure_damage_factor = STRUCTURE_DAMAGE_BREACHING
	embed_mult = 1.2 //Axes cut deep, and their hooked shape catches on things
	worksound = WORKSOUND_HARD_SLASH
	price_tag = 190
	item_icons = list(
		slot_back_str = 'icons/inventory/back/mob.dmi')
	item_state_slots = list(
		slot_back_str = "fireaxe0_back"
		)

/obj/item/tool/fireaxe/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && wielded)
		if(istype(A,/obj/effect/plant))
			var/obj/effect/plant/P = A
			P.die_off()

/obj/item/tool/fireaxe/woodsman
	name = "lumberjack's axe"
	desc = "Chop the wood to fuel the fire."
	icon_state = "woodsmanaxe0"
	wielded_icon = "woodsmanaxe1"
	force = WEAPON_FORCE_ROBUST
	slot_flags = SLOT_BELT|SLOT_BACK
	tool_qualities = list(QUALITY_CUTTING = 40, QUALITY_SAWING = 30)
	w_class = ITEM_SIZE_BULKY
	price_tag = 30

	has_alt_mode = TRUE
	alt_mode_damagetype = HALLOSS
	alt_mode_verbs = list("bashes", "beats", "clobbers")
	alt_mode_sharp = FALSE
	alt_mode_toggle = "flips the axe to its broad side"

/obj/item/tool/fireaxe/handmade
	name = "makeshift axe"
	desc = "A heavy plasteel blade affixed to a welded metal shaft, for close up carnage."
	icon_state = "makeshift_axe"
	item_state = "makeshift_axe"
	wielded_icon = "makeshift_axe_wielded"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 3)
	force = WEAPON_FORCE_DANGEROUS
	throwforce = WEAPON_FORCE_NORMAL
	armor_penetration = ARMOR_PEN_MODERATE
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("chopped", "torn", "cut", "cleaved", "slashed")
	tool_qualities = list(QUALITY_CUTTING = 10)
	structure_damage_factor = STRUCTURE_DAMAGE_BREACHING
	embed_mult = 1.1
	degradation = 1.5
	max_upgrades = 5
	has_alt_mode = TRUE
	alt_mode_damagetype = HALLOSS
	alt_mode_verbs = list("bashes", "beats", "clobbers")
	alt_mode_sharp = FALSE
	alt_mode_toggle = "flips the axe to its broad side"

/obj/item/tool/minihoe
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hoe"
	item_state = "hoe"
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2)
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	max_upgrades = 2
	tool_qualities = list(QUALITY_SHOVELING = 10)
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("slashed", "sliced", "cut", "clawed")

/obj/item/tool/scythe
	name = "scythe"
	desc = "A sharp and curved blade on a long fiber-metal handle, this tool makes it easy to reap what you sow."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "scythe0"
	matter = list(MATERIAL_PLASTEEL = 7, MATERIAL_PLASTIC = 3)
	sharp = TRUE
	edge = TRUE
	worksound = WORKSOUND_HARD_SLASH
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_PAINFUL
	w_class = ITEM_SIZE_BULKY
	slot_flags = SLOT_BACK
	attack_verb = list("chopped", "sliced", "cut", "reaped")
	attack_type = (DOUBLE_TACT | CAN_SWING | CAN_BROAD | FORCED_BROAD)
	tool_qualities = list(QUALITY_CUTTING = 15, QUALITY_SAWING = 10)
	item_icons = list(
		slot_back_str = 'icons/inventory/back/mob.dmi')
	item_state_slots = list(
		slot_back_str = "scythe0_back"
		)

	has_alt_mode = TRUE
	alt_mode_damagetype = HALLOSS
	alt_mode_verbs = list("jabs", "prods", "wacks")
	alt_mode_sharp = FALSE
	alt_mode_toggle = "flips the scythe backwards to use as a blunt spear"
	alt_mode_lossrate = 0.3

//Flails
/obj/item/tool/chain
	name = "chain"
	desc = "A tool used by great men to placate the frothing masses."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "chain"
	item_state = "chain"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_DANGEROUS
	throwforce = WEAPON_FORCE_DANGEROUS
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	attack_type = CAN_SWING
	max_upgrades = 2
	tool_qualities = list(QUALITY_HAMMERING = 5)

	has_alt_mode = TRUE
	alt_mode_damagetype = HALLOSS
	alt_mode_verbs = list("flogged", "whipped", "lashed", "disciplined")
	alt_mode_toggle = "loosens their hand on the grip"
	alt_mode_lossrate = 0.7

//Swords

/obj/item/tool/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "claymore"
	item_state = "claymore"
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 5)
	sharp = TRUE
	edge = TRUE
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	worksound = WORKSOUND_HARD_SLASH
	force = WEAPON_FORCE_ROBUST
	armor_penetration = ARMOR_PEN_DEEP

	throwforce = WEAPON_FORCE_NORMAL
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_type = (CAN_SWING | CAN_BROAD)
	hitsound = 'sound/weapons/bladeslice.ogg'
	tool_qualities = list(QUALITY_CUTTING = 10, QUALITY_SAWING = 10)
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE
	w_class = ITEM_SIZE_BULKY
	price_tag = 100

	has_alt_mode = TRUE
	alt_mode_damagetype = HALLOSS
	alt_mode_sharp = FALSE
	alt_mode_verbs = list("bashes", "stunts", "hilts", "blunts")
	alt_mode_toggle = "uses the broad side of their weapon"
	alt_mode_lossrate = 0.3

/obj/item/tool/sword/katana
	name = "katana"
	desc = "Modern Japanese-style blade that has no curve to it. This one looks pretty sharp."
	icon_state = "katana" // New sprite courtesy of Kavric
	item_state = "katana"
	hitsound = 'sound/weapons/heavyslash.ogg'
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_STEEL = 5, MATERIAL_DIAMOND = 1) //sharpened using diamond dust or whatever
	slot_flags = SLOT_BELT | SLOT_BACK
	force = WEAPON_FORCE_BRUTAL
	armor_penetration = ARMOR_PEN_SHALLOW
	item_icons = list(
		slot_back_str = 'icons/inventory/back/mob.dmi')
	item_state_slots = list(
		slot_back_str = "katana_back"
		)

/obj/item/tool/sword/katana_makeshift
	name = "makeshift katana"
	desc = "Modern Japanese-style blade that has no curve to it. This one is two knives welded together, proving where there's a will and a weeb there's a way."
	icon_state = "katana_improv"
	item_state = "katana_improv"
	matter = list(MATERIAL_STEEL = 6, MATERIAL_PLASTIC = 2) //twice the value of a kitche knife
	slot_flags = SLOT_BELT|SLOT_BACK
	force = WEAPON_FORCE_DANGEROUS
	armor_penetration = ARMOR_PEN_SHALLOW
	price_tag = 40

/obj/item/tool/sword/saber
	name = "decorative saber"
	desc = "A finely made formal blade as a ornamental show of class or force. Despite being primarily for show it cuts deep and painfully."
	icon = 'icons/obj/weapons-blades.dmi'
	icon_state = "saber"
	item_state = "saber"
	armor_penetration = ARMOR_PEN_SHALLOW
	price_tag = 400
	has_alt_mode = TRUE
	alt_mode_damagetype = HALLOSS
	alt_mode_sharp = FALSE
	alt_mode_verbs = list("bashes", "stunts", "wacks", "blunts")
	alt_mode_toggle = "switches their stance to avoid using the blade of their weapon"
	alt_mode_lossrate = 0.6

/obj/item/tool/sword/saber/cutlass
	name = "cutlass"
	desc = "A finely made sword for pirates or military men who take themselves too seriously."
	icon_state = "cutlass"
	item_state = "cutlass"
	price_tag = 300
	alt_mode_verbs = list("bashes", "stunts", "hilts", "blunts")
	alt_mode_toggle = "uses the broad side of their weapon"

/obj/item/tool/sword/handmade
	name = "junkblade"
	desc = "Hack and slash!"
	icon_state = "msword"
	item_state = "msword"
	slot_flags = SLOT_BELT|SLOT_BACK
	matter = list(MATERIAL_PLASTEEL = 5, MATERIAL_STEEL = 2) // 2 rods, 5 plasteel
	armor_penetration = ARMOR_PEN_MODERATE
	tool_qualities = list(QUALITY_CUTTING = 15,  QUALITY_SAWING = 5)
	degradation = 1.5 // Crappily made
	max_upgrades = 5 // Handmade nature
	price_tag = 100 // Made with plasteel

/obj/item/tool/sword/machete
	name = "machete"
	desc = "An explorer's best friend and trust back up plan. Or primary plan for those who like to get in there personally."
	icon = 'icons/obj/weapons-blades.dmi'
	icon_state = "machete"
	item_state = "machete"
	tool_qualities = list(QUALITY_CUTTING = 10,  QUALITY_SAWING = 20) //So we can cut down trees
	force = WEAPON_FORCE_ROBUST
	w_class = ITEM_SIZE_NORMAL
	price_tag = 120

/obj/item/tool/sword/huntingclaw
	name = "hunting claw"
	desc = "The second best friend a hunter could ask for, this one handed blade is lightweight and razor sharp thanks to its starworks-grade alloy construction.\
	 The hilt is made out of wood with gold looking trimmings. A Black Bear has been beautifully etched on the wood. All craftsmanship is of the highest quality."
	icon = 'icons/obj/weapons-blades.dmi'
	icon_state = "huntingclaw"
	item_state = "huntingclaw"
	matter = list(MATERIAL_STEEL = 5, MATERIAL_WOOD = 2)
	slot_flags = SLOT_BELT | SLOT_BACK
	tool_qualities = list(QUALITY_CUTTING = 20,  QUALITY_SAWING = 20) //Very sharp blade, serrated back
	force = WEAPON_FORCE_ROBUST
	armor_penetration = ARMOR_PEN_SHALLOW
	w_class = ITEM_SIZE_NORMAL
	price_tag = 500

/obj/item/tool/gauntlet
	name = "render gauntlet"
	desc = "A crudely made gauntlet consisting of straps, metal reinforcement and render skin - including it's deadly claws."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "gauntlet"
	tool_qualities = list(QUALITY_CUTTING = 20,  QUALITY_SAWING = 20) //Cuts people down just like trees.
	force = WEAPON_FORCE_BRUTAL
	armor_penetration = ARMOR_PEN_MODERATE
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 5)
	attack_verb = list("clawed", "scratched", "lacerated", "slashed")
	price_tag = 200

//POLEARMS
/obj/item/tool/spear
	icon = 'icons/obj/weapons.dmi'
	icon_state = "spear_glass"
	item_state = "spear_glass"
	wielded_icon = "spear_glass_wielded"
	name = "shard spear"
	desc = "A spiky bit of material tied onto a metal pole with some wire. It's an insult to spears across the globe - but it can still do some nasty damage and has some decent armor-piercing capabilities. Spears like these are often seen in the hands of vagrants, muggers, or desperate militias. Due to this weapon - if you could call it that - being so long, you're able to attack enemies from up to a tile away."
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	throw_speed = 3
	edge = TRUE
	sharp = TRUE
	tool_qualities = list(QUALITY_CUTTING = 10)
	origin_tech = list(TECH_COMBAT = 1)
	hitsound = 'sound/weapons/slice.ogg' // Sounds more like a stab than a cut.
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	embed_mult = 1.5
	price_tag = 50
	//attack_distance = 2


	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_DANGEROUS
	armor_penetration = ARMOR_PEN_MODERATE
	throw_speed = 3
	max_upgrades = 5

	item_icons = list(
		slot_back_str = 'icons/inventory/back/mob.dmi')
	item_state_slots = list(
		slot_back_str = "spearglass0_back"
		)

	has_alt_mode = TRUE
	alt_mode_damagetype = HALLOSS
	alt_mode_sharp = FALSE
	alt_mode_verbs = list("bashes", "stunts", "wacks", "blunts")
	alt_mode_toggle = "switches their stance to strike at targets with the shaft"
	alt_mode_lossrate = 0.4



/obj/item/tool/spear/steel
	name = "steel spear"
	desc = "A steel spearhead welded to a crude metal shaft, made from two welded rods. It'll serve well enough."
	icon_state = "spear_steel"
	item_state = "spear_steel"
	wielded_icon = "spear_steel_wielded"
	force = WEAPON_FORCE_DANGEROUS
	throwforce = WEAPON_FORCE_ROBUST
	armor_penetration = ARMOR_PEN_DEEP
	tool_qualities = list(QUALITY_CUTTING = 10,  QUALITY_WIRE_CUTTING = 5, QUALITY_SCREW_DRIVING = 5)
	matter = list(MATERIAL_STEEL = 3)
	structure_damage_factor = STRUCTURE_DAMAGE_WEAK

/obj/item/tool/spear/plasteel
	name = "plasteel spear"
	desc = "A carefully crafted plasteel spearhead affixed to a metal shaft, it is welded securely on and feels balanced. Show them the past still lives."
	icon_state = "spear_plasteel"
	item_state = "spear_plasteel"
	wielded_icon = "spear_plasteel_wielded"
	force = WEAPON_FORCE_ROBUST
	throwforce = WEAPON_FORCE_BRUTAL
	armor_penetration = ARMOR_PEN_DEEP
	tool_qualities = list(QUALITY_CUTTING = 15,  QUALITY_WIRE_CUTTING = 10, QUALITY_SCREW_DRIVING = 10)
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTEEL = 2)
	structure_damage_factor = STRUCTURE_DAMAGE_NORMAL

/obj/item/tool/spear/uranium
	name = "uranium spear"
	desc = "A steel spear with a uranium lined spearhead. Your foes may survive the stab, but the toxin will linger."
	icon_state = "spear_uranium"
	item_state = "spear_uranium"
	wielded_icon = "spear_uranium_wielded"
	force = WEAPON_FORCE_DANGEROUS
	throwforce = WEAPON_FORCE_DANGEROUS
	armor_penetration = ARMOR_PEN_DEEP
	tool_qualities = list(QUALITY_CUTTING = 10,  QUALITY_WIRE_CUTTING = 5, QUALITY_SCREW_DRIVING = 5)
	matter = list(MATERIAL_STEEL = 3, MATERIAL_URANIUM = 1)

/obj/item/tool/spear/uranium/apply_hit_effect(mob/living/carbon/human/target, mob/living/user, hit_zone)
	..()
	if(istype(target))
		target.apply_effect(rand(5, 10), IRRADIATE)

/obj/item/tool/spear/makeshift_halberd
	name = "makeshift halberd"
	desc = "Slap a heavy blade on some rods duct-taped together and call it a day."
	icon_state = "makeshift_halberd"
	item_state = "makeshift_halberd"
	wielded_icon = "makeshift_halberd_wielded"
	force = WEAPON_FORCE_ROBUST
	throwforce = WEAPON_FORCE_NORMAL
	armor_penetration = ARMOR_PEN_SHALLOW
	tool_qualities = list(QUALITY_CUTTING = 10)
	matter = list(MATERIAL_STEEL = 5)

/obj/item/tool/spear/hunter_halberd
	name = "halberd"
	desc = "A hand-crafted halberd with a red cloth wrapped around the base of the blade itself. A Hunter's signature melee weapon of choice."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hunter_halberd"
	item_state = "hunter_halberd"
	wielded_icon = "hunter_halberd_wielded"
	force = WEAPON_FORCE_BRUTAL
	armor_penetration = ARMOR_PEN_DEEP
	price_tag = 500
	matter = list(MATERIAL_STEEL = 22, MATERIAL_WOOD = 10, MATERIAL_PLASTEEL = 4)

//Shitty loadout weapons
/obj/item/tool/cheap
	name = "cheap sword"
	desc = "A sword of acceptable quality. It's no work of art, but it's sharp enough to get the job done."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cheap_sword"
	item_state = "cheap_sword"
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 5)
	sharp = TRUE
	edge = TRUE
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	worksound = WORKSOUND_HARD_SLASH
	force = WEAPON_FORCE_ROBUST
	armor_penetration = ARMOR_PEN_DEEP

	throwforce = WEAPON_FORCE_NORMAL
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	tool_qualities = list(QUALITY_CUTTING = 10, QUALITY_SAWING = 10)
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE
	w_class = ITEM_SIZE_NORMAL
	price_tag = 100

	has_alt_mode = TRUE
	alt_mode_damagetype = HALLOSS
	alt_mode_sharp = FALSE
	alt_mode_verbs = list("bashes", "stunts", "wacks", "blunts")
	alt_mode_toggle = "switches their stance to avoid using the blade of their weapon"
	alt_mode_lossrate = 0.9 //Little loss so people can use these in real gimmics

/obj/item/tool/cheap/axe
	name = "cheap tomahawk"
	desc = "A tomahawk of acceptable quality."
	icon_state = "cheap_axe"
	item_state = "cheap_axe"
	structure_damage_factor = STRUCTURE_DAMAGE_WEAK
	attack_verb = list("attacked", "slashed", "chopped", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/tool/cheap/katana
	name = "cheap katana"
	desc = "A katana of acceptable quality."
	icon_state = "katana_old"
	item_state = "katana"
	force = WEAPON_FORCE_DANGEROUS
	armor_penetration = ARMOR_PEN_EXTREME

/obj/item/tool/cheap/spear
	name = "cheap spear"
	desc = "A spear of acceptable quality. Place sharp end towards enemy."
	icon_state = "cheap_spear"
	item_state = "cheap_spear"
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK|SLOT_BELT
	throwforce = WEAPON_FORCE_BRUTAL
	throw_speed = 3
	embed_mult = 1.5
	structure_damage_factor = STRUCTURE_DAMAGE_WEAK
	tool_qualities = list(QUALITY_CUTTING = 15,  QUALITY_WIRE_CUTTING = 10, QUALITY_SCREW_DRIVING = 10)
	hitsound = 'sound/weapons/slice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	item_icons = list(
		slot_back_str = 'icons/inventory/back/mob.dmi')
	item_state_slots = list(
		slot_back_str = "cheap_spear"
		)
	alt_mode_toggle = "switches their stance to strike at targets with the shaft"
	alt_mode_lossrate = 0.4

/obj/item/tool/cheap/saber
	name = "cheap saber"
	desc = "A saber of acceptable quality. Probably not fit for parrying, but why not give it a try?"
	icon_state = "cheap_saber"
	item_state = "cutlass"
