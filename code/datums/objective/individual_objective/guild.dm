/datum/individual_objective/order
	name = "Special Order"
	req_department = list(FACTION_WAYWARD)
	var/obj/item/target

/datum/individual_objective/order/proc/pick_candidates()
	return pickweight(list(
	/obj/item/tool_upgrade/reinforcement/guard = 1,
	/obj/item/tool_upgrade/productivity/ergonomic_grip = 1,
	/obj/item/tool_upgrade/productivity/red_paint = 1,
	/obj/item/tool_upgrade/productivity/diamond_blade = 1,
	/obj/item/tool_upgrade/productivity/motor = 1,
	/obj/item/tool_upgrade/refinement/laserguide = 1,
	/obj/item/tool_upgrade/refinement/stabilized_grip = 1,
	/obj/item/tool_upgrade/augment/expansion = 1,
	/obj/item/tool_upgrade/augment/dampener = 0.5,
	/obj/item/tool/screwdriver/combi_driver = 3,
	/obj/item/tool/wirecutters/armature = 3,
	/obj/item/tool/omnitool = 2,
	/obj/item/tool/crowbar/pneumatic = 3,
	/obj/item/tool/wrench/big_wrench = 3,
	/obj/item/tool/weldingtool/advanced = 3,
	/obj/item/tool/saw/circular/advanced = 2,
	/obj/item/tool/saw/chain = 1,
	/obj/item/tool/saw/hyper = 1,
	/obj/item/tool/pickaxe/diamonddrill = 2,
	/obj/item/gun_upgrade/mechanism/glass_widow = 1,
	/obj/item/gun_upgrade/barrel/excruciator = 1,
	/obj/item/device/destTagger = 1,
	/obj/item/device/makeshift_electrolyser = 1,
	/obj/item/device/makeshift_centrifuge = 1
	))

/datum/individual_objective/order/assign()
	..()
	target = pick_candidates()
	target = new target()
	desc = "A buddy of yours is waiting for a [target]. Ensure it will be exported or sold via airship."
	RegisterSignal(SStrade, COMSIG_TRADE_BEACON, .proc/task_completed)

/datum/individual_objective/order/task_completed(atom/movable/AM)
	if(AM.type == target.type)
		completed()

/datum/individual_objective/order/completed()
	if(completed) return
	UnregisterSignal(SStrade, COMSIG_TRADE_BEACON)
	..()
