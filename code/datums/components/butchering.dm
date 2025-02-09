/datum/component/butchering
	var/speed = 80 //time in deciseconds taken to butcher something
	var/effectiveness = 100 //percentage effectiveness; numbers above 100 yield extra drops
	var/bonus_modifier = 0 //percentage increase to bonus item chance
	var/butcher_sound = 'sound/blank.ogg' //sound played when butchering
	var/butchering_enabled = TRUE
	var/can_be_blunt = FALSE

/datum/component/butchering/Initialize(_speed, _effectiveness, _bonus_modifier, _butcher_sound, disabled, _can_be_blunt)
	if(_speed)
		speed = _speed
	if(_effectiveness)
		effectiveness = _effectiveness
	if(_bonus_modifier)
		bonus_modifier = _bonus_modifier
	if(_butcher_sound)
		butcher_sound = _butcher_sound
	if(disabled)
		butchering_enabled = FALSE
	if(_can_be_blunt)
		can_be_blunt = _can_be_blunt
	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(onItemAttack))

/datum/component/butchering/proc/onItemAttack(obj/item/source, mob/living/M, mob/living/user)
	return
/*
	if(user.used_intent.type != INTENT_HARM)
		return
	if(M.stat == DEAD && (M.butcher_results || M.guaranteed_butcher_results)) //can we butcher it?
		if(butchering_enabled && (can_be_blunt || source.get_sharpness()))
			INVOKE_ASYNC(src, PROC_REF(startButcher), source, M, user)
			return COMPONENT_ITEM_NO_ATTACK

	if(ishuman(M) && source.force && source.get_sharpness())
		var/mob/living/carbon/human/H = M
		if((H.health <= H.crit_threshold || (user.pulling == H && user.grab_state >= GRAB_NECK) || H.IsSleeping()) && user.zone_selected == BODY_ZONE_HEAD) // Only sleeping, neck grabbed, or crit, can be sliced.
			if(H.has_status_effect(/datum/status_effect/neck_slice))
				user.show_message("<span class='warning'>[H]'s neck has already been already cut, you can't make the bleeding any worse!</span>", MSG_VISUAL, \
								"<span class='warning'>Their neck has already been already cut, you can't make the bleeding any worse!</span>")
				return COMPONENT_ITEM_NO_ATTACK
			INVOKE_ASYNC(src, PROC_REF(startNeckSlice), source, H, user)
			return COMPONENT_ITEM_NO_ATTACK
*/

/datum/component/butchering/proc/startButcher(obj/item/source, mob/living/M, mob/living/user)
	to_chat(user, "<span class='notice'>I begin to butcher [M]...</span>")
	playsound(M.loc, butcher_sound, 50, TRUE, -1)
	if(do_after(user, speed, M) && M.Adjacent(source))
		Butcher(user, M)

/datum/component/butchering/proc/startNeckSlice(obj/item/source, mob/living/carbon/human/H, mob/living/user)
	user.visible_message("<span class='danger'>[user] is slitting [H]'s throat!</span>", \
					"<span class='danger'>I start slicing [H]'s throat!</span>", \
					"<span class='hear'>I hear a cutting noise!</span>", ignored_mobs = H)
	H.show_message("<span class='danger'>My throat is being slit by [user]!</span>", MSG_VISUAL, \
					"<span class = 'danger'>Something is cutting into my neck!</span>", NONE)
	log_combat(user, H, "starts slicing the throat of")

	playsound(H.loc, butcher_sound, 50, TRUE, -1)
	if(do_after(user, clamp(50 SECONDS / source.force, 3 SECONDS, 10 SECONDS), H) && H.Adjacent(source))
		if(H.has_status_effect(/datum/status_effect/neck_slice))
			user.show_message("<span class='warning'>[H]'s neck has already been already cut, you can't make the bleeding any worse!</span>", MSG_VISUAL, \
							"<span class='warning'>Their neck has already been already cut, you can't make the bleeding any worse!</span>")
			return

		H.visible_message("<span class='danger'>[user] slits [H]'s throat!</span>", \
					"<span class='danger'>[user] slits my throat...</span>")
		log_combat(user, H, "finishes slicing the throat of")
		H.apply_damage(source.force, BRUTE, BODY_ZONE_HEAD)
		H.bleed_rate = CLAMP(H.bleed_rate + 20, 0, 30)
		H.apply_status_effect(/datum/status_effect/neck_slice)

/datum/component/butchering/proc/Butcher(mob/living/butcher, mob/living/meat)
	var/turf/T = meat.drop_location()
	var/final_effectiveness = effectiveness - meat.butcher_difficulty
	var/bonus_chance = max(0, (final_effectiveness - 100) + bonus_modifier) //so 125 total effectiveness = 25% extra chance
	for(var/V in meat.butcher_results)
		var/obj/bones = V
		var/amount = meat.butcher_results[bones]
		for(var/_i in 1 to amount)
			if(!prob(final_effectiveness))
				if(butcher)
					to_chat(butcher, "<span class='warning'>I fail to harvest some of the [initial(bones.name)] from [meat].</span>")
			else if(prob(bonus_chance))
				if(butcher)
					to_chat(butcher, "<span class='info'>I harvest some extra [initial(bones.name)] from [meat]!</span>")
				for(var/i in 1 to 2)
					new bones (T)
			else
				new bones (T)
		meat.butcher_results.Remove(bones) //in case you want to, say, have it drop its results on gib
	for(var/V in meat.guaranteed_butcher_results)
		var/obj/sinew = V
		var/amount = meat.guaranteed_butcher_results[sinew]
		for(var/i in 1 to amount)
			new sinew (T)
		meat.guaranteed_butcher_results.Remove(sinew)
	if(butcher)
		butcher.visible_message("<span class='notice'>[butcher] butchers [meat].</span>", \
								"<span class='notice'>I butcher [meat].</span>")
	ButcherEffects(meat)
	meat.harvest(butcher)
	meat.gib(FALSE, FALSE, TRUE)

/datum/component/butchering/proc/ButcherEffects(mob/living/meat) //extra effects called on butchering, override this via subtypes
	return
