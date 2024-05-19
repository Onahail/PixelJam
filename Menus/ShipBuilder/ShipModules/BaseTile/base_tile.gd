extends Module

var x = null
var y = null
var in_explosion_radius = null

func _ready():
	module_name = "Hull"
	super._ready()
	$TextureHealthBar.z_index = 1
	EventBus.apply_explosive_damage.connect(_on_apply_explosion_damage)
	

func _physics_process(delta):
	super._physics_process(delta)
	
	var overlapping_areas = $ExplosionCheck.get_overlapping_areas()
	
	for area in overlapping_areas:
		if in_explosion_radius == null:
			if area.name == "Explosion":
				in_explosion_radius = area
				#print(self.module_name)
	
func _on_apply_explosion_damage():
	if in_explosion_radius and shielded == false:
		repairable.applyDamage(Globals.EXPLOSION_DAMAGE, self)
		in_explosion_radius = null


func _on_hp_depleted():
	#TODO Hull Destroyed
	super._on_hp_depleted()
