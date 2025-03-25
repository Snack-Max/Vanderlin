/mob/living/simple_animal/hostile/retaliate/spider
	icon = 'icons/roguetown/mob/monster/spider.dmi'
	name = "beespider"
	desc = "Swamp-lurking creachers with a wicked bite. They make honey from flowers and spin silk from their abdomen. Some dark elves see them as a sacred animal."
	icon_state = "honeys"
	icon_living = "honeys"
	icon_dead = "honeys-dead"

	faction = list("bugs")
	turns_per_move = 4
	move_to_delay = 2
	vision_range = 5
	aggro_vision_range = 5

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1,
							/obj/item/natural/silk = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1,
							/obj/item/reagent_containers/food/snacks/spiderhoney = 1,
							/obj/item/natural/silk = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 2,
							/obj/item/reagent_containers/food/snacks/spiderhoney = 2,
							/obj/item/natural/silk = 3)

	health = SPIDER_HEALTH
	maxHealth = SPIDER_HEALTH
	food_type = list(/obj/item/bodypart,
					/obj/item/organ,
					/obj/item/reagent_containers/food/snacks/meat)

	base_intents = list(/datum/intent/simple/bite)
	attack_sound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')
	melee_damage_lower = 17
	melee_damage_upper = 22

	tame_chance = 25

	TOTALCON = 6
	TOTALSTR = 10
	TOTALSPD = 10

	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 35
	defdrain = 5
	attack_same = FALSE
	retreat_health = 0.2

	aggressive = TRUE
	stat_attack = UNCONSCIOUS
	body_eater = TRUE

	ai_controller = /datum/ai_controller/spider
	AIStatus = AI_OFF
	can_have_ai = FALSE

	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/good_boy,
		/datum/pet_command/follow,
		/datum/pet_command/point_targeting/home,
		/datum/pet_command/go_home,
		/datum/pet_command/point_targeting/attack,
		/datum/pet_command/point_targeting/fetch,
		/datum/pet_command/play_dead,
		/datum/pet_command/protect_owner,
		/datum/pet_command/aggressive,
		/datum/pet_command/calm,
	)

/mob/living/simple_animal/hostile/retaliate/spider/mutated
	icon = 'icons/roguetown/mob/monster/spider.dmi'
	name = "skallax spider"
	icon_state = "skallax"
	icon_living = "skallax"
	icon_dead = "skallax-dead"

	health = SPIDER_HEALTH+10
	maxHealth = SPIDER_HEALTH+10

	base_intents = list(/datum/intent/simple/bite)

/mob/living/simple_animal/hostile/retaliate/spider/Initialize()
	. = ..()
	gender = MALE
	if(prob(33))
		gender = FEMALE
	update_icon()

	AddComponent(/datum/component/obeys_commands, pet_commands)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)
	ADD_TRAIT(src, TRAIT_WEBWALK, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/spider/UnarmedAttack(atom/A)
	if(!..())
		return
	production += rand(30, 50)

/mob/living/simple_animal/hostile/retaliate/spider/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.reagents)
			L.reagents.add_reagent(/datum/reagent/toxin/venom, 1)

/mob/living/simple_animal/hostile/retaliate/spider/find_food()
	. = ..()
	if(!.)
		return eat_bodies()

/mob/living/simple_animal/hostile/retaliate/spider/try_tame(obj/item/O, mob/user)
	if(!stat)
		user.visible_message("<span class='info'>[user] hand-feeds [O] to [src].</span>", "<span class='notice'>I hand-feed [O] to [src].</span>")
		playsound(loc,'sound/misc/eat.ogg', rand(30,60), TRUE)
		qdel(O)
		food = min(food + 30, 100)
		if(tame && owner == user)
			return TRUE
		var/realchance = tame_chance
		if(is_species(user, /datum/species/elf/dark))
			realchance += 15
		if(realchance)
			if(user.mind)
				realchance += (user.mind.get_skill_level(/datum/skill/labor/taming) * 20)
			if(prob(realchance))
				tamed(user)
			else
				tame_chance += bonus_tame_chance
		return TRUE

/mob/living/simple_animal/hostile/retaliate/spider/death(gibbed)
	..()
	update_icon()


/mob/living/simple_animal/hostile/retaliate/spider/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		var/mutable_appearance/eye_lights = mutable_appearance(icon, "honeys-eyes")
		eye_lights.plane = 19
		eye_lights.layer = 19
		add_overlay(eye_lights)

/mob/living/simple_animal/hostile/retaliate/spider/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/spider/aggro (1).ogg','sound/vo/mobs/spider/aggro (2).ogg','sound/vo/mobs/spider/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/spider/pain.ogg')
		if("death")
			return pick('sound/vo/mobs/spider/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/spider/idle (1).ogg','sound/vo/mobs/spider/idle (2).ogg','sound/vo/mobs/spider/idle (3).ogg','sound/vo/mobs/spider/idle (4).ogg')

/mob/living/simple_animal/hostile/retaliate/spider/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/spider/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "stomach"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/mob/living/simple_animal/hostile/retaliate/spider/handle_habitation(obj/structure/spider/nest/home)
	. = ..()
	home.to_process += production
	production = 0

/obj/structure/spider/nest/constructed
	name = "spider nesting house"
	desc = "A hand built nest for beespiders."
	icon_state = "constructed_nest"

/obj/structure/spider/nest
	name = "spider nest"
	desc = "A woven nest for spiders to live in."

	icon = 'icons/obj/structures/spiders/nest.dmi'
	icon_state = "nest"

	var/to_process = 0
	var/total_processed = 0
	var/process_cap = 500

	var/datum/proximity_monitor/advanced/spider_nest/field

	var/last_disturbed = 0

/obj/structure/spider/nest/Initialize()
	. = ..()
	AddComponent(/datum/component/mob_home, 6)
	START_PROCESSING(SSobj, src)
	return INITIALIZE_HINT_LATELOAD

/obj/structure/spider/nest/LateInitialize()
	. = ..()
	field = make_field(/datum/proximity_monitor/advanced/spider_nest, list("parent" = src, "host" = src))

/obj/structure/spider/nest/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/structure/spider/nest/examine(mob/user)
	. = ..()
	var/honey = FLOOR(total_processed * 0.01, 1)
	var/string = "empty"
	switch(honey)
		if(1)
			string = "slightly filled"
		if(2)
			string = "partially filled"
		if(3)
			string = "half filled"
		if(4)
			string = "almost full"
		if(5)
			string = "completely full"
	. += span_notice("The nest looks [string].")

/obj/structure/spider/nest/attackby(obj/item/I, mob/user, params)
	. = ..()
	check_crossed(user)

/obj/structure/spider/nest/process()
	if(total_processed >= process_cap)
		return
	if(!to_process)
		return
	var/process_amount = min(5, to_process)
	to_process -= process_amount
	total_processed += process_amount

/obj/structure/spider/nest/proc/check_crossed(atom/movable/movable)
	if(last_disturbed > world.time)
		return
	if(!isliving(movable))
		return
	if(istype(movable, /mob/living/simple_animal/hostile/retaliate/spider))
		return
	for(var/mob/living/simple_animal/hostile/retaliate/spider/spider in contents)
		spider.handle_habitation(src)

		var/datum/targetting_datum/targeter = spider.ai_controller.blackboard[BB_PET_TARGETING_DATUM]
		if (!targeter)
			continue
		if (!targeter.can_attack(spider, movable))
			new /obj/effect/temp_visual/heart(spider.loc)
			continue
		spider.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, movable)
		spider.ai_controller.queue_behavior(/datum/ai_behavior/basic_melee_attack, BB_BASIC_MOB_CURRENT_TARGET, BB_PET_TARGETING_DATUM)

	last_disturbed = world.time + 12 SECONDS

/datum/proximity_monitor/advanced/spider_nest
	field_shape = FIELD_SHAPE_RADIUS_SQUARE
	current_range = 2

	setup_field_turfs = TRUE
	setup_edge_turfs = TRUE

	var/obj/structure/spider/nest/parent


/datum/proximity_monitor/advanced/spider_nest/field_turf_crossed(atom/movable/AM, obj/effect/abstract/proximity_checker/advanced/field_turf/F)
	. = ..()
	parent.check_crossed(AM)
