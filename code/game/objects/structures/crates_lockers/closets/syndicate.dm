/obj/structure/closet/syndicate
	name = "armory closet"
	desc = "Why is this here?"
	icon_state = "syndicate"
	req_access = list(access_syndicate) //Stop people getting good stuff without access
	locked = TRUE
	secure = TRUE

/obj/structure/closet/syndicate/personal
	desc = "It's a storage unit for operative gear."

/obj/structure/closet/syndicate/personal/populate_contents()
	new /obj/item/tank/jetpack/oxygen(src)
	new /obj/item/clothing/mask/gas/tactical(src)
	new /obj/item/clothing/under/syndicate(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/cell/large/high(src)
	new /obj/item/card/id/syndicate(src)
	new /obj/item/tool/multitool(src)
	new /obj/item/shield/buckler/energy(src)
	new /obj/item/clothing/shoes/magboots(src)
	new /obj/item/storage/pouch/pistol_holster(src) // Perhaps this may encourage actually buying pistols.
	new /obj/item/storage/pouch/ammo(src)


/obj/structure/closet/syndicate/suit
	desc = "It's a storage unit for voidsuits."

/obj/structure/closet/syndicate/suit/populate_contents()
	new /obj/item/tank/jetpack/oxygen(src)
	new /obj/item/clothing/shoes/magboots(src)
	new /obj/item/clothing/mask/gas/tactical(src)


/obj/structure/closet/syndicate/nuclear
	desc = "It's a storage unit for nuclear-operative gear."

/obj/structure/closet/syndicate/nuclear/populate_contents()
	new /obj/item/ammo_magazine/smg_35(src)
	new /obj/item/ammo_magazine/smg_35(src)
	new /obj/item/ammo_magazine/smg_35(src)
	new /obj/item/ammo_magazine/smg_35(src)
	new /obj/item/ammo_magazine/smg_35(src)
	new /obj/item/storage/box/handcuffs(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/gun/energy/gun(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	new /obj/item/pinpointer/nukeop(src)
	return
