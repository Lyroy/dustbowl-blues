/obj/item/modification/organ/internal/special
	name = "membrane"
	desc = "A graftable outer membrane for organ tissues."
	icon_state = "membrane"

/obj/item/modification/organ/internal/special/update_icon()
	icon_state = initial(icon_state) + "-[rand(1,5)]"

/obj/item/modification/organ/internal/special/on_item_examine

/obj/item/modification/organ/internal/special/on_item_examine/brainloss
	name = "eldritch membrane"
	desc = "A graftable outer membrane for organ tissues. The alien textures are painful to look at."

/obj/item/modification/organ/internal/special/on_item_examine/brainloss/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	AddComponent(/datum/component/modification/organ/on_item_examine/brainloss)
	..()


/obj/item/modification/organ/internal/special/on_pickup

/obj/item/modification/organ/internal/special/on_pickup/shock
	name = "shocking membrane"
	desc = "A graftable outer membrane for organ tissues. There is bioelectric phenomena present and it hurts to touch."
	icon_state = "membrane-hive"

/obj/item/modification/organ/internal/special/on_pickup/shock/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	AddComponent(/datum/component/modification/organ/on_pickup/shock)
	..()

/obj/item/modification/organ/internal/special/on_pickup/shock/update_icon()
	return

/obj/item/modification/organ/internal/special/on_pickup/shock/powerful
	name = "powerful shocking membrane"
	desc = "A graftable outer membrane for organ tissues. There is significant bioelectric phenomena present and it hurts to touch."

/obj/item/modification/organ/internal/special/on_pickup/shock/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	AddComponent(/datum/component/modification/organ/on_pickup/shock/powerful)
	..()


/obj/item/modification/organ/internal/special/on_cooldown

/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect
	name = "endocrinal membrane"
	desc = "A graftable membrane for organ tissues. Secretes hormones when the primary organ function triggers."

/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/New(loc, generate_organ_stats = FALSE, predefined_modifier = null, list/chosen_special_info)
	var/datum/component/modification/organ/on_cooldown/chemical_effect/S = AddComponent(/datum/component/modification/organ/on_cooldown/chemical_effect)

	if(chosen_special_info?.len >= 2)
		S.effect = chosen_special_info[1]
	..()

/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/bloodrestore
/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/bloodrestore/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/chemical_effect/S = AddComponent(/datum/component/modification/organ/on_cooldown/chemical_effect)

	S.effect = pick(/datum/reagent/hormone/bloodrestore, /datum/reagent/hormone/bloodrestore/alt)
	..()

/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/bloodclot
/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/bloodclot/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/chemical_effect/S = AddComponent(/datum/component/modification/organ/on_cooldown/chemical_effect)

	S.effect = pick(/datum/reagent/hormone/bloodclot, /datum/reagent/hormone/bloodclot/alt)
	..()

/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/painkiller
/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/painkiller/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/chemical_effect/S = AddComponent(/datum/component/modification/organ/on_cooldown/chemical_effect)

	S.effect = pick(/datum/reagent/hormone/painkiller, /datum/reagent/hormone/painkiller/alt)
	..()

/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/antitox
/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/antitox/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/chemical_effect/S = AddComponent(/datum/component/modification/organ/on_cooldown/chemical_effect)

	S.effect = pick(/datum/reagent/hormone/antitox, /datum/reagent/hormone/antitox/alt)
	..()

/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/oxygenation
/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/oxygenation/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/chemical_effect/S = AddComponent(/datum/component/modification/organ/on_cooldown/chemical_effect)

	S.effect = pick(/datum/reagent/hormone/oxygenation, /datum/reagent/hormone/oxygenation/alt)
	..()

/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/speedboost
/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect/speedboost/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/chemical_effect/S = AddComponent(/datum/component/modification/organ/on_cooldown/chemical_effect)

	S.effect = pick(/datum/reagent/hormone/speedboost, /datum/reagent/hormone/speedboost/alt)
	..()


/obj/item/modification/organ/internal/special/on_cooldown/stat_boost
	name = "intracrinal membrane"
	desc = "A graftable membrane for organ tissues. Secretes stimulating hormones when the primary organ function triggers."

/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/New(loc, generate_organ_stats = FALSE, predefined_modifier = null, list/chosen_special_info)
	var/datum/component/modification/organ/on_cooldown/stat_boost/S = AddComponent(/datum/component/modification/organ/on_cooldown/stat_boost)

	if(chosen_special_info?.len >= 2)
		S.stat = chosen_special_info[1]
		S.boost = chosen_special_info[2]
	..()

/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/strength
/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/strength/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/stat_boost/S = AddComponent(/datum/component/modification/organ/on_cooldown/stat_boost)

	S.stat = SPECIAL_S
	S.boost = 1
	..()

/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/perception
/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/perception/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/stat_boost/S = AddComponent(/datum/component/modification/organ/on_cooldown/stat_boost)

	S.stat = SPECIAL_P
	S.boost = 1
	..()

/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/endurance
/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/endurance/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/stat_boost/S = AddComponent(/datum/component/modification/organ/on_cooldown/stat_boost)

	S.stat = SPECIAL_E
	S.boost = 1
	..()

/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/charisma
/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/charisma/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/stat_boost/S = AddComponent(/datum/component/modification/organ/on_cooldown/stat_boost)

	S.stat = SPECIAL_C
	S.boost = 1
	..()

/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/intelligence
/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/intelligence/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/stat_boost/S = AddComponent(/datum/component/modification/organ/on_cooldown/stat_boost)

	S.stat = SPECIAL_I
	S.boost = 1
	..()

/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/agility
/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/agility/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/stat_boost/S = AddComponent(/datum/component/modification/organ/on_cooldown/stat_boost)

	S.stat = SPECIAL_A
	S.boost = 1
	..()

/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/luck
/obj/item/modification/organ/internal/special/on_cooldown/stat_boost/luck/New(loc, generate_organ_stats = FALSE, predefined_modifier = null)
	var/datum/component/modification/organ/on_cooldown/stat_boost/S = AddComponent(/datum/component/modification/organ/on_cooldown/stat_boost)

	S.stat = SPECIAL_L
	S.boost = 1
	..()
