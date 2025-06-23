extends Node

func apply_effect(type:String, target, duration):
	if target:
		if not target.status_effects.has(type):
			target.status_effects[type] = {"duration" : duration}
		else:
			target.status_effects[type].duration += duration
		
	
func apply_weak_to_damage(damage):
	damage *= 0.75
	return roundi(damage)
	
func apply_vulnerable_to_damage(damage):
	damage *= 1.5
	return roundi(damage)
	

func lower_duration(target):
	if target:
		var status_effects_copy = target.status_effects.duplicate()
		for status in status_effects_copy:
			if target.status_effects[status].duration - 1 > 0: 
				target.status_effects[status].duration -= 1
			else:
				target.status_effects.erase(status)
			
func return_duration(type, target):
	if target and target.status_effects.has(type):
		return target.status_effects[type].duration
	return 0
