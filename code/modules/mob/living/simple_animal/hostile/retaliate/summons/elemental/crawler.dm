
/mob/living/simple_animal/hostile/retaliate/elemental/crawler
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "earthen crawler"
	summon_primer = "You are an crawler, a small elemental. Elementals such as yourself spend immeasurable time wandering about within your plane. Now you've been pulled from your home into a new world, that is decidedly less peaceful then your carefully guarded plane. How you react to these events, only time can tell."
	icon_state = "crawler"
	icon_living = "crawler"
	tier = 1
	icon_dead = "vvd"
	gender = MALE
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 8
	base_intents = list(/datum/intent/simple/elemental_unarmed)
	butcher_results = list()
	faction = list("elemental")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 120
	maxHealth = 120
	melee_damage_lower = 15
	melee_damage_upper = 17
	vision_range = 8
	aggro_vision_range = 11
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 13
	STAEND = 13
	STASTR = 8
	STASPD = 8
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	defdrain = 10
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = 'sound/combat/hits/onstone/wallhit.ogg'
	attack_verb_continuous = "pounds"
	attack_verb_simple = "pounds"
	dodgetime = 0
	aggressive = 1


/mob/living/simple_animal/hostile/retaliate/elemental/crawler/Initialize()
	. = ..()

/mob/living/simple_animal/hostile/retaliate/elemental/crawler/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/natural/elementalmote(deathspot)
	new /obj/item/natural/elementalmote(deathspot)
	new /obj/item/natural/elementalmote(deathspot)
	new /obj/item/natural/elementalmote(deathspot)
	new /obj/item/natural/elementalmote(deathspot)
	new /obj/item/natural/elementalmote(deathspot)
	update_icon()
	sleep(1)
	qdel(src)
