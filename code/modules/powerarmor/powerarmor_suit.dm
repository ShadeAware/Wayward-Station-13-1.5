//Most of this is shamelessly copied from ninja suit code. You're gonna see a lot of it or things like it here.
/obj/item/clothing/suit/space/hardsuit/powerarmor
	icon_state = "powerarmor"
	name = "power armor"
	desc = "An extremely advanced, energy-powered suit of armor. Essentially a minified exosuit, this armor is capable of augmenting a standard humanoids strength, speed, and combat prowess to insane heights. Can be further upgraded with additional modules."
	armor = list("melee" = 60, "bullet" = 50, "laser" = 30,"energy" = 15, "bomb" = 30, "bio" = 100, "rad" = 30, "fire" = 100, "acid" = 100, "wound" = 30)
	slowdown = -0.5
	resistance_flags = LAVA_PROOF | ACID_PROOF
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/powerarmor
	jetpack = /obj/item/tank/jetpack/suit
	strip_delay = 12
	actions_types = list(/datum/action/item_action/toggle_helmet, /datum/action/item_action/toggle_glove)
	var/obj/item/stock_parts/cell/cell
	var/datum/effect_system/spark_spread/spark_system
	var/s_cost = 5//Base energy cost each ntick.
	var/s_acost = 25//Additional cost for additional powers active.
	var/s_delay = 40//How fast the suit does certain things, lower is faster. Can be overridden in specific procs. Also determines adverse probability.

	//These are all the extra clothing items for the suit for easy reference later on.
	var/obj/item/clothing/head/helmet/space/hardsuit/powerarmor/pa_hood
	var/obj/item/clothing/shoes/powerarmor_shoes/pa_shoes
	var/obj/item/clothing/gloves/powerarmor_gloves/pa_gloves

	//These are extra pieces of clothing in-built to the suit.
	var/obj/item/clothing/gloves/gloves
	var/obj/item/clothing/shoes/shoes

	var/glovestype = /obj/item/clothing/gloves/powerarmor_gloves
	var/shoestype = /obj/item/clothing/shoes/powerarmor_shoes

/obj/item/clothing/suit/space/hardsuit/powerarmor/get_cell()
	return cell

/obj/item/clothing/suit/space/hardsuit/powerarmor/Initialize()
	. = ..()

	//Spark Init
	spark_system = new
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	//Cell Init
	cell = new/obj/item/stock_parts/cell/high
	cell.charge = 9000
	cell.name = "black power cell"
	cell.icon_state = "bscell"
	
	START_PROCESSING(SSprocessing, src)

/obj/item/clothing/suit/space/hardsuit/powerarmor/examine(mob/user)
	. = ..()
	. += "Current energy capacity: <B>[DisplayEnergy(cell.charge)]</B>."

/obj/item/clothing/suit/space/hardsuit/powerarmor/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/toggle_glove))
		pa_gloves.toggledrain()
		return TRUE
	return FALSE

/obj/item/clothing/suit/space/hardsuit/powerarmor/attackby(obj/item/I, mob/U, params)
	if(istype(I, /obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/CELL = I
		if(CELL.maxcharge > cell.maxcharge && pa_gloves && pa_gloves.candrain)
			to_chat(U, "<span class='notice'>Higher maximum capacity detected.\nUpgrading...</span>")
			if (pa_gloves && pa_gloves.candrain && do_after(U,s_delay, target = src))
				U.transferItemToLoc(CELL, src)
				CELL.charge = min(CELL.charge+cell.charge, CELL.maxcharge)
				var/obj/item/stock_parts/cell/old_cell = cell
				old_cell.charge = 0
				U.put_in_hands(old_cell)
				old_cell.add_fingerprint(U)
				old_cell.corrupt()
				old_cell.update_icon()
				cell = CELL
				to_chat(U, "<span class='notice'>Upgrade complete. Maximum capacity: <b>[round(cell.maxcharge/100)]</b>%</span>")
			else
				to_chat(U, "<span class='danger'>Procedure interrupted. Protocol terminated.</span>")
		return
	return ..()

/obj/item/clothing/suit/space/hardsuit/powerarmor/equipped(mob/user, slot)
	. = ..()
	playsound(src, 'sound/effect/powerarmor_online.ogg', 60, 1)
	if(ishuman(user) && slot == SLOT_WEAR_SUIT)
		var/mob/living/carbon/human/H = user
		if(!istype(H.shoes, /obj/item/clothing/shoes/powerarmor_shoes))
			if(!H.dropItemToGround(H.shoes))
				qdel(H.shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/powerarmor_shoes(H), SLOT_SHOES)
		if(!istype(H.gloves, /obj/item/clothing/gloves/powerarmor_gloves))
			if(!H.dropItemToGround(H.gloves))
				qdel(H.gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/powerarmor_gloves(H), SLOT_GLOVES)

/obj/item/clothing/suit/space/hardsuit/powerarmor/process()
	if(cell.charge > 0)
		slowdown = -0.5
	else
		cell.charge = 0
		slowdown = 5

/obj/item/clothing/head/helmet/space/hardsuit/powerarmor
	desc = "A highly advanced combat helmet, pressurized and armored to offer the pinnacle of protection for its user."
	name = "power armor helmet"
	icon_state = "s-ninja"
	item_state = "s-ninja_mask"
	armor = list("melee" = 60, "bullet" = 50, "laser" = 30,"energy" = 15, "bomb" = 30, "bio" = 30, "rad" = 25, "fire" = 100, "acid" = 100)
	strip_delay = 12
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

/obj/item/clothing/head/helmet/space/hardsuit/powerarmor/equipped(mob/living/carbon/human/user, slot)
	..()
	if (slot == SLOT_HEAD)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		DHUD.add_hud_to(user)

/obj/item/clothing/head/helmet/space/hardsuit/powerarmor/dropped(mob/living/carbon/human/user)
	..()
	if (user.head == src)
		var/datum/atom_hud/DHUD = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		DHUD.remove_hud_from(user)

/obj/item/clothing/shoes/powerarmor_shoes/
	name = "power armor boots"
	desc = "A pair of high-tech combat boots. Excellent for running and even better for smashing skulls."
	icon_state = "s-pa"
	permeability_coefficient = 0.01
	clothing_flags = NOSLIP
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor = list("melee" = 60, "bullet" = 50, "laser" = 30,"energy" = 15, "bomb" = 30, "bio" = 30, "rad" = 30, "fire" = 100, "acid" = 100)
	strip_delay = 120
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/powerarmor_shoes/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, NINJA_SUIT_TRAIT)

/obj/item/clothing/gloves/powerarmor_gloves/
	desc = "These nano-enhanced gloves insulate from electricity and provide fire resistance."
	name = "powerarmor gloves"
	icon_state = "s-pa"
	item_state = "s-pa"
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	strip_delay = 120
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/draining = 0
	var/candrain = 0
	var/mindrain = 200
	var/maxdrain = 400

	var/stunforce = 100

/obj/item/clothing/gloves/powerarmor_gloves/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, NINJA_SUIT_TRAIT)

/obj/item/clothing/gloves/powerarmor_gloves/Touch(atom/A,proximity)
	if(!candrain || draining)
		return FALSE
	if(!ishuman(loc))
		return FALSE	//Only works while worn

	var/mob/living/carbon/human/H = loc

	var/obj/item/clothing/suit/space/hardsuit/powerarmor/suit = H.wear_suit
	if(!istype(suit))
		return FALSE
	if(isturf(A))
		return FALSE

	if(!proximity)
		return FALSE

	A.add_fingerprint(H)

	draining = TRUE
	. = A.powerarmor_drainact(suit,H,src)
	draining = FALSE

	if(isnum(.)) //Numerical values of drained handle their feedback here, Alpha values handle it themselves (Research hacking)
		if(.)
			to_chat(H, "<span class='notice'>Gained <B>[DisplayEnergy(.)]</B> of energy from [A].</span>")
		else
			to_chat(H, "<span class='danger'>\The [A] has run dry of energy, you must find another source!</span>")
		. = INTERRUPT_UNARMED_ATTACK
	else
		. = FALSE	//as to not cancel attack_hand()

/obj/item/clothing/gloves/powerarmor_gloves/proc/toggledrain()
	var/mob/living/carbon/human/U = loc
	to_chat(U, "You <b>[candrain?"disable":"enable"]</b> special interaction.")
	candrain=!candrain

/obj/item/clothing/gloves/powerarmor_gloves/examine(mob/user)
	. = ..()
	. += "The energy drain mechanism is <B>[candrain?"active":"inactive"]</B>."