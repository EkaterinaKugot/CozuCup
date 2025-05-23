# progress.gd
extends Resource
class_name Progress

@export var number_start: int = 0:
	get:
		return number_start
	set(value):
		assert(value >= 0, "The value of number_start cannot be less than 0")
		number_start = value		
@export var day: int = 1:
	get:
		return day
	set(value):
		assert(value >= 1, "The value of day cannot be less than 1")
		day = value		

@export var option_duration_day: Dictionary = {5: [10, 20]}:
	get:
		return option_duration_day
@export var size_intervals: int = 15:
	get:
		return size_intervals
@export var duration_day: int = option_duration_day.keys()[0]:
	get:
		return duration_day
	set(value):
		assert(value in option_duration_day.keys(), "The value of duration_day cannot have such a value")
		duration_day = value

@export var rating: float = 5.0:
	get:
		return rating
	set(value):
		assert(value >= 1, "The value of rating cannot be less than 1")
		rating = value		
@export var number_grades: int = 1:
	get:
		return number_grades
	set(value):
		number_grades = value
const max_rating: int = 5

@export var money: int = 100:
	get:
		return money
	set(value):
		if value < 0:
			var error_message = "The value of money cannot be less than 0"
			push_error(error_message)  # Выводим ошибку в консоль
			return
		money = value	
@export var diamonds: int = 0:
	get:
		return diamonds
	set(value):
		if value < 0:
			if value < 0:
				var error_message = "The value of diamonds cannot be less than 0"
				push_error(error_message)  # Выводим ошибку в консоль
				return
		diamonds = value

@export var opened_ingredients: Dictionary = {}:
	get:
		return opened_ingredients
	set(value):
		assert(value.size() >= 0, "The size of opened_ingredients cannot be less than 0")
		opened_ingredients = value
@export var opened_recipes: Array[Recipe] = []:
	get:
		return opened_recipes
	set(value):
		assert(value.size() >= 0, "The size of opened_recipes cannot be less than 0")
		opened_recipes = value
@export var opened_improvements: Array[Improvement] = []:
	get:
		return opened_improvements
	set(value):
		assert(value.size() >= 0, "The size of opened_recipes cannot be less than 0")
		opened_improvements = value

@export var daily_tasks: DailyTasks

const number_basic_ingredient: int = 30

func add_number_start() -> void:
	number_start += 1
	
func add_day() -> void:
	day += 1
	
func change_rating(sum_grades: float, number_grades_per_day: int) -> void:
	assert(sum_grades >= 0, "The value of sum_grades should be larger or equal to zero")
	assert(number_grades_per_day >= 0, "The value of number_grades_per_day should be larger or equal to zero")
	rating = snappedf(( (rating * number_grades) + sum_grades) / (number_grades_per_day + number_grades), 0.1) 
	_add_number_grades(number_grades_per_day)

func _add_number_grades(number_grades_per_day: int) -> void:
	assert(number_grades_per_day >= 0, "The value of number_grades_per_day should be larger or equal to zero")
	number_grades += number_grades_per_day
	
func add_money(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	money += value
	
func sub_money(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	money -= value
	if daily_tasks.get_task(3) != null and daily_tasks.get_task(3).id == "consumption":
		daily_tasks.update_progress(3, value)

func check_money(number: int) -> bool:
	return money - number >= 0
	
func add_diamonds(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	diamonds += value
	
func sub_diamonds(value: int) -> void:
	assert(value >= 0, "The value of value cannot be less than 0")
	diamonds -= value

func check_diamonds(number: int) -> bool:
	return diamonds - number >= 0
	
func add_new_opened_ingredients(ingredient: Ingredient, number: int = 5) -> void:
	assert(number >= 0, "The value of value cannot be less than 0")
	opened_ingredients[ingredient] = number

func add_number_ingredient(ingredient: Ingredient, number: int) -> void:
	assert(number >= 1, "The value of value cannot be less than 1")
	assert(ingredient in opened_ingredients.keys(), "There is no such value in opened_ingredients")
	opened_ingredients[ingredient] += number
	
func sub_number_ingredient(ingredient: Ingredient, number: int) -> void:
	assert(number >= 1, "The value of value cannot be less than 1")
	assert(ingredient in opened_ingredients.keys(), "There is no such value in opened_ingredients")
	opened_ingredients[ingredient] -= number

func check_number_ingredient(ingredient: Ingredient, number: int) -> bool:
	return opened_ingredients[ingredient] - number >= 0
	
func add_new_opened_recipes(recipe: Recipe) -> void:
	opened_recipes.append(recipe)

func add_new_improvement(improvement: Improvement) -> void:
	if not opened_improvements.has(improvement):
		opened_improvements.append(improvement)

func has_improvement(improvement: Improvement) -> bool:
	return opened_improvements.has(improvement)
	
func select_ingredients_by_category(category: Ingredient.Category) -> Dictionary:
	var result = {}
	for ingredient in opened_ingredients.keys():
		if ingredient.category == category:
			result[ingredient] = opened_ingredients[ingredient]
	return result

func select_ingredients_by_id(id: String) -> Ingredient:
	for ingredient in opened_ingredients.keys():
		if ingredient.id == id:
			return ingredient
	return null
	
func select_improvement_by_id(id: String) -> Improvement:
	var result: Improvement
	for improvement in opened_improvements:
		if improvement.id == id:
			result = improvement
			break
	return result
