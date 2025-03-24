/datum/job/cheesemaker
	title =  "Cheesemaker"
	tutorial = "Some say Dendor brings bountiful harvests - this much is true, but rot brings forth life. \
	From life brings decay, and from decay brings life. Like your father before you, you let milk rot into cheese. \
	This is your duty, this is your call."
	flag = CHEESEMAKER
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_CHEESEMAKER
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		"Humen",
		"Rakshari",
		"Elf",
		"Half-Elf",
		"Dwarf",
		"Tiefling",
		"Dark Elf",
		"Aasimar",
		"Half-Orc",
		"Kobold",
	)

	outfit = /datum/outfit/job/cheesemaker

/datum/outfit/job/cheesemaker/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/labor/taming, 1, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/craft/cooking, 4, TRUE)
	H.mind?.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/tights/random
	shirt = /obj/item/clothing/shirt/shortshirt/random
	cloak = /obj/item/clothing/cloak/apron
	shoes = /obj/item/clothing/shoes/simpleshoes
	backl = /obj/item/storage/backpack/backpack
	neck = /obj/item/storage/belt/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltr = /obj/item/reagent_containers/glass/bottle/waterskin/milk
	beltl = /obj/item/weapon/knife/villager
	backpack_contents = list(/obj/item/reagent_containers/powder/salt = 3, /obj/item/reagent_containers/food/snacks/cheddar = 1, /obj/item/natural/cloth = 2, /obj/item/book/yeoldecookingmanual = 1)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_CON, 2)
