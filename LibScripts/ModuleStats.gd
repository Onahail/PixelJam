extends Node

var module_data = {
	"Propeller": {
		"health": 15,
		"price": 250,
		"repair_time": 3,
		"min_allowable": 1,
		"max_allowable": 6,
		"misc": {
			"speed_boost": 100,
			"energy_consumption": 5
		},
		"assets": {
			"scene": "res://Menus/ShipBuilder/ShipModules/Propeller/propeller.tscn"
		}
	},
	"Gun": {
		"health": 16,
		"price": 25,
		"repair_time": 3,
		"min_allowable": 0,
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
		"price": 40,
		"repair_time": 3,
		"min_allowable": 0,
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
		"health": 10,
		"price": 0,
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
		"health": 10,
		"price": 150,
		"repair_time": 3,
		"min_allowable": 1,
		"max_allowable": 4,
		"misc": {
				"collection_rate": 100
		},
		"assets": {
			"scene": "res://Menus/ShipBuilder/ShipModules/Scoop/scoop.tscn"
		}
	},
	"Shield": {
		"health": 15,
		"price": 300,
		"repair_time": 3,
		"min_allowable": 0,
		"max_allowable": 2,
		"misc": {
			"shield_hp": 20,
			"recharge_rate": 2,
			"recharge_delay": 5
		},
		"assets": {
			"scene": "res://Menus/ShipBuilder/ShipModules/Shield/shield.tscn"
		}
	},
	"Hull": {
		"health": 20,
		"price": 50,
		"base_price": 50,
		"repair_time": 3,
		"min_allowable": 1,
		"max_allowable": 100,
		"misc": {
		},
		"assets": {
			"scene": "res://Menus/ShipBuilder/ShipModules/BaseTile/base_tile.tscn",
			"expansion_marker": "res://Menus/ShipBuilder/ShipModules/BaseTile/expansion_marker.tscn"
		}
	}
}
