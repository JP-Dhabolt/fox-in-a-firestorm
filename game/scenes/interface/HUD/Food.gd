extends Label

func _process(_delta):
	var food_amount: int = -99
	if GameManager.current_player != null:
		food_amount = GameManager.current_player.food

	text = "Food: " + str(food_amount)
