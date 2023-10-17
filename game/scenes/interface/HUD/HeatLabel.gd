extends Label

var player: Player
var label_text: String = "Heat: {0}"

func _ready():
	await owner.ready
	player = owner.player as Player
	assert(player != null, "Player must be available to use this node")

func _process(_delta):
	text = label_text.format([(int(player.heat))])
