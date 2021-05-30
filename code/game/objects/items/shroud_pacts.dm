/obj/item/shroud_pact
	name = "Pact of the Shroud"
	icon = 'icons/obj/shroud_objects.dmi'
	icon_state = "shroud_covenant"
	desc = "A perfectly smooth rock, with strange runes lining the sides. It has been broken apart by something otherworldly, and leaks fantastical amounts of strange energy which writhes in an unnatural form. Whispers pitter out from the rock, promising great power."

/obj/item/shroud_pact/attack_self(mob/user)
	to_chat(user, "<span class='cult'>Dark energies swirl and twist around your body, encircling you in an aura of profound psionic power. Multiple lifetimes flash before your eyes, both human and inhuman - the beings of the shroud look to you, and smile an insidious grin.")
	user.log_message("has entered a Greater Pact with the Gods of the Shroud. They have been granted great power.", LOG_ATTACK, color="orange")
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shadowwalk) //Is this shit code? Absolutely. Do I care? Not in the slightest. I cannot be assed to figure out how to make spell_add and lists work together. Fuck whoever did the spell adding function.
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/pointed/void_blink)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/repulse/eldritch)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/void_pull)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/revenant/defile)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/aimed/rust_wave)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/cone/staggered/entropic_plume)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/linkWorlds)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/emplosion/eldritch)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/forcewall/cult)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/pointed/cleave/long)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/pointed/trigger/blind/eldritch)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/grasp_of_decay)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/mad_touch)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/pointed/blood_siphon)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/basic_heal)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shed_human_form)
	playsound(src,'sound/magic/shroud_pact.ogg',40,1)
	qdel(src)

/obj/item/shroud_blessing
	name = "Shrouds Blessings"
	icon = 'icons/obj/shroud_objects.dmi'
	icon_state = "shroud_blessing"
	desc = "A perfectly smooth rock, with strange, ethereal runes lining the sides. It glows with a sickly purple hue, with faint whispers surrounding the air this object resides in."

/obj/item/shroud_blessing/attack_self(mob/user)
	to_chat(user, "<span class='cult'>Dark energies swirl and twist around your arm. A searing pain overwhelms you as two purple vines of pure light jab into your flesh, vanishing as soon as they had arrived.")
	user.log_message("has entered a Lesser Pact with the Gods of the Shroud, granting them power.", LOG_ATTACK, color="orange")
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shadowwalk) //Is this shit code? Absolutely. Do I care? Not in the slightest. I cannot be assed to figure out how to make spell_add and lists work together. Fuck whoever did the spell adding function.
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/pointed/void_blink)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/revenant/defile)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/forcewall/cult)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/grasp_of_decay)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/pointed/blood_siphon)
	playsound(src,'sound/hallucinations/i_see_you1.ogg',40,1)
	qdel(src)
