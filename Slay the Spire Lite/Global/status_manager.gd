extends Node

func apply_effect(type:String, target, duration):
	if not target.status_effects.has(type):
		target.status_effects[type] = {"duration" : duration}
	else:
		target.status_effects[type].duration += duration
		

func has_status(type, target):
	for status in target.status_effects:
		if status == type:
			return true
	return false
	
func apply_weak_to_damage(damage):
	damage *= 0.5
	return roundi(damage)
	
func lower_duration(target):
	for status in target.status_effects:
		if target.status_effects[status].duration - 1 > 0: 
			target.status_effects[status].duration -= 1
		else:
			target.status_effects.erase(status)
			
	
