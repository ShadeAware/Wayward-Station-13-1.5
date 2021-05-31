//Needs to return the amount drained from the atom, if no drain on a power object, return FALSE, otherwise, return a define.
/atom/proc/powerarmor_drainact()
	return INVALID_DRAIN




//APC//
/obj/machinery/power/apc/powerarmor_drainact(obj/item/clothing/suit/space/hardsuit/powerarmor/S, mob/living/carbon/human/H, obj/item/clothing/gloves/powerarmor_gloves/G)
	if(!S || !H || !G)
		return INVALID_DRAIN

	var/maxcapacity = 0 //Safety check for batteries
	var/drain = 0 //Drain amount from batteries

	. = 0

	if(cell && cell.charge)
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, loc)

		while(G.candrain && cell.charge> 0 && !maxcapacity)
			drain = rand(G.mindrain, G.maxdrain)

			if(cell.charge < drain)
				drain = cell.charge

			if(S.cell.charge + drain > S.cell.maxcharge)
				drain = S.cell.maxcharge - S.cell.charge
				maxcapacity = 1//Reached maximum battery capacity.

			if (do_after(H,10, target = src))
				spark_system.start()
				playsound(loc, "sparks", 50, 1)
				cell.charge -= drain
				S.cell.charge += drain
				. += drain
			else
				break





//SMES//
/obj/machinery/power/smes/powerarmor_drainact(obj/item/clothing/suit/space/hardsuit/powerarmor/S, mob/living/carbon/human/H, obj/item/clothing/gloves/powerarmor_gloves/G)
	if(!S || !H || !G)
		return INVALID_DRAIN

	var/maxcapacity = 0 //Safety check for batteries
	var/drain = 0 //Drain amount from batteries

	. = 0

	if(charge)
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, loc)

		while(G.candrain && charge > 0 && !maxcapacity)
			drain = rand(G.mindrain, G.maxdrain)

			if(charge < drain)
				drain = charge

			if(S.cell.charge + drain > S.cell.maxcharge)
				drain = S.cell.maxcharge - S.cell.charge
				maxcapacity = 1

			if (do_after(H,10, target = src))
				spark_system.start()
				playsound(loc, "sparks", 50, 1)
				charge -= drain
				S.cell.charge += drain
				. += drain

			else
				break


//CELL//
/obj/item/stock_parts/cell/powerarmor_drainact(obj/item/clothing/suit/space/hardsuit/powerarmor/S, mob/living/carbon/human/H, obj/item/clothing/gloves/powerarmor_gloves/G)
	if(!S || !H || !G)
		return INVALID_DRAIN

	. = 0

	if(charge)
		if(G.candrain && do_after(H,30, target = src))
			. = charge
			if(S.cell.charge + charge > S.cell.maxcharge)
				S.cell.charge = S.cell.maxcharge
			else
				S.cell.charge += charge
			charge = 0
			corrupt()
			update_icon()




//WIRE//
/obj/structure/cable/powerarmor_drainact(obj/item/clothing/suit/space/hardsuit/powerarmor/S, mob/living/carbon/human/H, obj/item/clothing/gloves/powerarmor_gloves/G)
	if(!S || !H || !G)
		return INVALID_DRAIN

	var/maxcapacity = 0 //Safety check
	var/drain = 0 //Drain amount

	. = 0

	var/datum/powernet/PN = powernet
	while(G.candrain && !maxcapacity && src)
		drain = (round((rand(G.mindrain, G.maxdrain))/2))
		var/drained = 0
		if(PN && do_after(H,10, target = src))
			drained = min(drain, delayed_surplus())
			add_delayedload(drained)
			if(drained < drain)//if no power on net, drain apcs
				for(var/obj/machinery/power/terminal/T in PN.nodes)
					if(istype(T.master, /obj/machinery/power/apc))
						var/obj/machinery/power/apc/AP = T.master
						if(AP.operating && AP.cell && AP.cell.charge > 0)
							AP.cell.charge = max(0, AP.cell.charge - 5)
							drained += 5
		else
			break

		S.cell.charge += drained
		if(S.cell.charge > S.cell.maxcharge)
			. += (drained-(S.cell.charge - S.cell.maxcharge))
			S.cell.charge = S.cell.maxcharge
			maxcapacity = 1
		else
			. += drained
		S.spark_system.start()

//MECH//
/obj/mecha/powerarmor_drainact(obj/item/clothing/suit/space/hardsuit/powerarmor/S, mob/living/carbon/human/H, obj/item/clothing/gloves/powerarmor_gloves/G)
	if(!S || !H || !G)
		return INVALID_DRAIN

	var/maxcapacity = 0 //Safety check
	var/drain = 0 //Drain amount
	. = 0

	occupant_message("<span class='danger'>Warning: Unauthorized access through sub-route 4, block H, detected.</span>")
	if(get_charge())
		while(G.candrain && cell.charge > 0 && !maxcapacity)
			drain = rand(G.mindrain,G.maxdrain)
			if(cell.charge < drain)
				drain = cell.charge
			if(S.cell.charge + drain > S.cell.maxcharge)
				drain = S.cell.maxcharge - S.cell.charge
				maxcapacity = 1
			if (do_after(H,10, target = src))
				spark_system.start()
				playsound(loc, "sparks", 50, 1)
				cell.use(drain)
				S.cell.charge += drain
				. += drain
			else
				break

//BORG//
/mob/living/silicon/robot/powerarmor_drainact(obj/item/clothing/suit/space/hardsuit/powerarmor/S, mob/living/carbon/human/H, obj/item/clothing/gloves/powerarmor_gloves/G)
	if(!S || !H || !G)
		return INVALID_DRAIN

	var/maxcapacity = 0 //Safety check
	var/drain = 0 //Drain amount
	. = 0

	to_chat(src, "<span class='danger'>Warning: Unauthorized access through sub-route 12, block C, detected.</span>")

	if(cell && cell.charge)
		while(G.candrain && cell.charge > 0 && !maxcapacity)
			drain = rand(G.mindrain,G.maxdrain)
			if(cell.charge < drain)
				drain = cell.charge
			if(S.cell.charge+drain > S.cell.maxcharge)
				drain = S.cell.maxcharge - S.cell.charge
				maxcapacity = 1
			if (do_after(H,10))
				spark_system.start()
				playsound(loc, "sparks", 50, 1)
				cell.charge -= drain
				S.cell.charge += drain
				. += drain
			else
				break


//CARBON MOBS//
/mob/living/carbon/powerarmor_drainact(obj/item/clothing/suit/space/hardsuit/powerarmor/S, mob/living/carbon/human/H, obj/item/clothing/gloves/powerarmor_gloves/G)
	if(!S || !H || !G)
		return INVALID_DRAIN

	. = DRAIN_MOB_SHOCK_FAILED

	//Default cell = 10,000 charge, 10,000/1000 = 10 uses without charging/upgrading
	if(S.cell && S.cell.charge && S.cell.use(500))
		. = DRAIN_MOB_SHOCK
		//Got that electric touch
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, loc)
		playsound(src, "sparks", 50, 1)
		visible_message("<span class='danger'>[H] electrocutes [src] with [H.p_their()] touch!</span>", "<span class='userdanger'>[H] electrocutes you with [H.p_their()] touch!</span>")
		electrocute_act(15, H, flags = SHOCK_NOSTUN)

		DefaultCombatKnockdown(G.stunforce, override_hardstun = 0)
		apply_effect(EFFECT_STUTTER, G.stunforce)
		SEND_SIGNAL(src, COMSIG_LIVING_MINOR_SHOCK)

		lastattacker = H.real_name
		lastattackerckey = H.ckey
		log_combat(H, src, "stunned")

		playsound(loc, 'sound/weapons/egloves.ogg', 50, 1, -1)

		if(ishuman(src))
			var/mob/living/carbon/human/Hsrc = src
			Hsrc.forcesay(GLOB.hit_appends)