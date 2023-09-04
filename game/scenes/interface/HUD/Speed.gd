extends Label

var player: Player
func _ready():
	await owner.ready
	player = owner.player as Player
	assert(player != null, "Player must be available to use this node")

func _process(_delta):
	text = "Speed: " + str(int(player.movement_speed))
