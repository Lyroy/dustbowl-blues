/* Unlike Eris we are using our ollld sanity syatem for drinks, food, and sancks. The reason why is - we have too much fucking food and drinks to sort through.
Plus it would require me to get taste_tags working. So, for now until someone can be fucked to put the work in to our shit-codebase, it is staying like this. */
GLOBAL_LIST_EMPTY(sanity_drinks)
GLOBAL_LIST_EMPTY(sanity_non_alcoholic_drinks)
GLOBAL_LIST_EMPTY(sanity_foods)


//for drinks
/proc/init_sanity_drinks()
	var/list/drink_types = subtypesof(/datum/reagent/ethanol)
	for(var/candidate in drink_types)
		var/list/subtypes_candidate = subtypesof(candidate)
		if(!subtypes_candidate.len)
			GLOB.sanity_drinks += candidate
	return GLOB.sanity_drinks.Copy()

/proc/init_sanity_sanity_non_alcoholic_drinks()
	var/list/non_a_drink_types = subtypesof(/datum/reagent/drink)
	for(var/candidate in non_a_drink_types)
		var/list/subtypes_candidate = subtypesof(candidate)
		if(!subtypes_candidate.len)
			GLOB.sanity_non_alcoholic_drinks += candidate
	return GLOB.sanity_non_alcoholic_drinks.Copy()

//for food
/proc/init_sanity_foods()
	var/list/food_types = subtypesof(/obj/item/reagent_containers/food/snacks)
	for(var/candidate in food_types)
		var/obj/item/reagent_containers/food/snacks/food = candidate
		if(initial(food.cooked))
			GLOB.sanity_foods += candidate
	return GLOB.sanity_foods.Copy()
