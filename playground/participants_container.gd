extends VBoxContainer

@onready var discord : DiscordSDK = get_node("/root/Discord")
var scene = preload("res://playground/participant.tscn")
var user_nodes : Dictionary = {}

func _ready() -> void:
	discord.connect("dispatch_activity_instance_participants_update", Callable(self, "update"))
	discord.connect("dispatch_voice_state_update", Callable(self, "voice_state_update"))


func update(data: Dictionary) -> void:
	for participant in data["participants"]:
		if (!user_nodes.has(participant["id"])):
			var node = scene.instantiate()
			add_child(node)
			user_nodes[participant["id"]] = node as Participant
		
		user_nodes[participant["id"]].update(participant)


func voice_state_update(data: Dictionary) -> void:
	if (user_nodes.has(data["user"]["id"])):
		user_nodes[data["user"]["id"]].voice_state_update(data)
