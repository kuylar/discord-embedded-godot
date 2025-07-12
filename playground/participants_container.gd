extends VBoxContainer

@onready var discord: DiscordSDK = get_node("/root/Discord")
var scene := preload("res://playground/participant.tscn")
var user_nodes: Dictionary[String, Participant] = {}


func _ready() -> void:
	discord.dispatch_activity_instance_participants_update.connect(update)
	discord.dispatch_voice_state_update.connect(voice_state_update)


func update(data: DiscordSDK.ParticipantsUpdateData) -> void:
	for participant in data.participants:
		if (!user_nodes.has(participant.id)):
			var node := scene.instantiate()
			add_child(node)
			user_nodes[participant.id] = node as Participant
		user_nodes[participant.id].update(participant)


func voice_state_update(data: DiscordSDK.VoiceStateUpdateData) -> void:
	if (user_nodes.has(data.user.id)):
		user_nodes[data.user.id].voice_state_update(data)
