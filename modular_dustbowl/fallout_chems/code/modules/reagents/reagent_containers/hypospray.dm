/obj/item/reagent_containers/hypospray/autoinjector/stimpak
	name = "Stimpak"
	desc = "A syringe for containing and delivering the medication and a gauge for measuring the status of the stimpak's contents."
	icon = 'modular_dustbowl/fallout_chems/icons/obj/drugs.dmi'
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	icon_state = "hypo_stimpak"
	item_state = "hypo_stimpak"
	amount_per_transfer_from_this = 15
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1)
	reagent_flags = INJECTABLE | DRAINABLE | AMOUNT_VISIBLE | REFILLABLE
	volume = 15
	preloaded_reagents = list("stimpak" = 15)
	baseline_sprite = "hypo_stimpak"
	injtime = 2

/obj/item/reagent_containers/hypospray/autoinjector/stimpak/super
	name = "Super Stimpak"
	desc = "A syringe for containing and delivering the medication, a gauge for measuring the status of the stimpak's contents, an additional vial for further storage of drugs and a leather strap to keep it secured in place."
	icon_state = "hypo_superstimpak"
	item_state = "hypo_superstimpak"
	amount_per_transfer_from_this = 30
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 1, MATERIAL_LEATHER = 1)
	volume = 30
	preloaded_reagents = list("super_stimpak" = 30)
	baseline_sprite = "hypo_superstimpak"
	injtime = 4
