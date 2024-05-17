extends Node

var module_data = {
	"Propeller": {
		"health": 15,
		"price": 10,
		"repair_time": 3,
		"min_allowable": 1,
		"max_allowable": 2,
		"misc": {
			"speed_boost": 20,
			"energy_consumption": 5
		},
		"assets": {
			"scene": "res://Menus/ShipBuilder/ShipModules/Propeller/propeller.tscn"
		}
	},
	"Gun": {
		"health": 15,
		"price": 2,
		"repair_time": 3,
		"min_allowable": 1,
		"max_allowable": 4,
		"misc": {
			"damage": 1,
			"fire_rate": 0.2,
			"range": 1200,
			"velocity": 1000
		},
		"assets": {
			"scene": "res://Menus/ShipBuilder/ShipModules/Gun/gun_deck.tscn"
		}
	},
	"Storage": {
		"health": 15,
		"price": 3,
		"repair_time": 3,
		"min_allowable": 1,
		"max_allowable": 3,
		"misc": {
			"capacity": 1000,
			"access_speed": 2
		},
		"assets": {
			"scene": "res://Menus/ShipBuilder/ShipModules/Storage/storage.tscn"
		}
	},    
	"Bridge": {
		"health": 15,
		"price": 4,
		"repair_time": 3,
		"min_allowable": 1,
		"max_allowable": 1,
		"misc": {
		},
		"assets": {
			"scene": "res://Menus/ShipBuilder/ShipModules/Bridge/bridge.tscn"
		}
	},
	"Scoop": {
		"health": 15,
		"price": 5,
		"repair_time": 3,
		"min_allowable": 1,
		"max_allowable": 4,
		"misc": {
				"collection_rate": 50
		},
		"assets": {
			"scene": "res://Menus/ShipBuilder/ShipModules/Scoop/scoop.tscn"
		}
	},
	"Shield": {
		"health": 15,
		"price": 6,
		"repair_time": 3,
		"min_allowable": 1,
		"max_allowable": 2,
		"misc": {
		},
		"assets": {
			"scene": "res://Menus/ShipBuilder/ShipModules/Shield/shield.tscn"
		}
	},
	"Hull": {
		"health": 1,
		"price": 7,
		"repair_time": 3,
		"min_allowable": 1,
		"max_allowable": 100,
		"misc": {
		},
		"assets": {
			"scene": "res://Menus/ShipBuilder/ShipModules/BaseTile/base_tile.tscn"
		}
	}
}
