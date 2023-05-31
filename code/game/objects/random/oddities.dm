/obj/random/oddity_guns
	name = "random gun oddities"
	icon_state = "techloot-grey"

/obj/random/oddity_guns/item_to_spawn()
	return pickweight(list(
				//Bullet
				/obj/item/gun/projectile/deaglebolt = 1,
				/obj/item/gun/projectile/revolver/mistral/elite = 1,
				/obj/item/gun/projectile/shotgun/doublebarrel/bluecross_shotgun = 1,
				/obj/item/gun/projectile/automatic/pulse_rifle = 1,
				/obj/item/gun/projectile/silenced/rat = 1,
				/obj/item/gun/projectile/automatic/maxim/replica = 1,
				/obj/item/gun/projectile/revolver/deacon = 1,
				/obj/item/gun/projectile/clarissa/devil_eye = 1,
				/obj/item/gun/projectile/automatic/slaught_o_matic/lockpickomatic = 1,
				/obj/item/gun/projectile/boltgun/bluecross = 1,
				/obj/item/gun/projectile/that_gun = 1,
				/obj/item/gun/projectile/colt/cult = 1,
				//Energy
				/obj/item/gun/energy/sniperrifle/saint = 1,
				//obj/item/gun/energy/lasersmg/inferno = 1,
				/obj/item/gun/energy/ntpistol/mana = 1,
				/obj/item/gun/energy/captain/zapper = 1,
				/obj/item/gun/energy/xray/psychic_cannon = 1,
				/obj/item/gun/energy/lasersmg/chaos_engine = 1,
				//Hydrogen
				/obj/item/gun/hydrogen/incinerator = 1,
				//Tools / Melee
				/obj/item/tool/nailstick/ogre = 1,
				/obj/item/tool/wrench/big_wrench/freedom = 1,
				/obj/item/tool/saw/hyper/doombringer = 1,
				//obj/item/material/butterfly/frenchman = 1,
				//Gun/Tool Mods
				/obj/item/gun_upgrade/mechanism/brass_kit = 1,
				//Misc - things that are not a "gun" but still good for this
				/obj/item/soap/bluespase = 0.5))

/obj/random/uplink/low_chance
	name = "really really really low chance random uplink"
	icon_state = "techloot-grey-low"
	spawn_nothing_percentage = 95

/obj/random/uplink
	name = "random uplink"
	icon_state = "techloot-grey"

/obj/random/uplink/item_to_spawn()
	return pickweight(list(
				/obj/item/device/radio/uplink = 1,
				/obj/item/tool/multitool/uplink = 1,
				/obj/item/implant/uplink = 1,
				/obj/item/device/radio/headset/uplink = 1))
