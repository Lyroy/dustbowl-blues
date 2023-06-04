/datum/seed/bloodvine
	name = "bloodvine"
	seed_name = "bloodvine"
	display_name = "bloodvine"
	chems = list("bloodsap_powder" = list(1,2),"nutriment" = list(1,5))

/datum/seed/bloodvine/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"bloodvine")
	set_trait(TRAIT_PRODUCT_ICON, "vine2")
	set_trait(TRAIT_PRODUCT_COLOUR, "#8a284e")
	set_trait(TRAIT_PLANT_COLOUR, "#bd3535")
	set_trait(TRAIT_ENDURANCE,18)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,3)
	set_trait(TRAIT_PLANT_ICON_OVERRIDE,1)
