extends Control

@onready var jug_water = $JugWater
var scene_grain_package = preload("res://src/scenes/items/grain_package.tscn")
var scene_milk = preload("res://src/scenes/items/milk.tscn")

@onready var milk_frother = $MilkFrother

var WIDTH
var HEIGHT

var opened_ingredients: Dictionary
var instances_ingredients: Dictionary
var value_properties: Dictionary 

var current_ingredient: Ingredient = null

signal level_hud_visible()

func _ready() -> void:
	emit_signal("level_hud_visible")
	
	WIDTH = get_viewport().size.x
	HEIGHT = get_viewport().size.y
	milk_frother.position = Vector2(1150, 475)
	value_properties = {
		Ingredient.Category.GRAINS: {
			"position": Vector2(80, 190), "scale": Vector2(0.45, 0.45), "idx_position": 1
		}, 
		Ingredient.Category.MILK: {
			"position": Vector2(1200, 190), "scale": Vector2(0.5, 0.5), "idx_position": -1
		}
	}
	
	opened_ingredients[Ingredient.Category.GRAINS] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.GRAINS
	)
	opened_ingredients[Ingredient.Category.MILK] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.MILK
	)
	opened_ingredients[Ingredient.Category.WATER] = Global.progress.select_ingredients_by_category(
		Ingredient.Category.WATER
	)
	
	instances_ingredients[Ingredient.Category.GRAINS] = load_ingredients(
		opened_ingredients[Ingredient.Category.GRAINS], scene_grain_package
	)
	instances_ingredients[Ingredient.Category.MILK] = load_ingredients(
		opened_ingredients[Ingredient.Category.MILK], scene_milk
	)

	instances_ingredients[Ingredient.Category.WATER] = {
		opened_ingredients[Ingredient.Category.WATER].keys()[0]: jug_water
	}
	jug_water.ingredient = instances_ingredients[Ingredient.Category.WATER].keys()[0]
	jug_water.connect("ingredient_pressed", change_current_ingredient)
	
func load_ingredients(ingredients: Dictionary, scene) -> Dictionary:
	var result = {}
	var count = 0
	
	for ingredient in ingredients.keys():
		var instance = scene.instantiate()
		instance.connect("ingredient_pressed", change_current_ingredient)
		instance.ingredient = ingredient
		var size_x = (100 * count) + 10
		
		var sprite = instance.get_node("Sprite2D")
		if sprite:
			sprite.texture = load("res://assets/items/{0}.png".format([ingredient.id]))
		
		instance.scale = value_properties[ingredient.category]["scale"]
		instance.position = value_properties[ingredient.category]["position"]
		instance.position.x += size_x * value_properties[ingredient.category]["idx_position"]
			
		result[ingredient] = instance
		
		add_child(instance)
		instance.update_number()
		count += 1
	return result
		
func change_current_ingredient(ingredient: Ingredient) -> void:
	if current_ingredient == ingredient:
		current_ingredient = null
	elif current_ingredient == null:
		current_ingredient = ingredient
	else:
		var instance = find_instance_by_ingredients(current_ingredient)
		var glow_effect = instance.get_node("GlowEffect")
		glow_effect.visible = not glow_effect.visible
		
		current_ingredient = ingredient
	print(current_ingredient)

func find_instance_by_ingredients(ingredient: Ingredient):
	var instance
	for ingr in instances_ingredients[ingredient.category].keys():
		if ingr == ingredient:
			instance = instances_ingredients[ingredient.category][ingr]
			break
			
	assert(instance != null, "The value of instance cannot be null")
	return instance
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bottom_hud_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level.tscn")


func _on_bottom_hud_left_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_right.tscn")


func _on_bottom_hud_right_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/level_left.tscn")
