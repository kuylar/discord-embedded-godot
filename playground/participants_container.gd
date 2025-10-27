extends VBoxContainer

@onready var discord: DiscordSDK = get_node("/root/Discord")
var scene := preload("res://playground/participant.tscn")
var user_nodes: Dictionary[String, Participant] = {}


func _ready() -> void:
	discord.dispatch_activity_instance_participants_update.connect(update)
	discord.dispatch_voice_state_update.connect(voice_state_update)


func update(data: DiscordSDK.ParticipantsUpdateData) -> void:
	var prev_ids : Array = user_nodes.keys()
	for participant in data.participants:
		if (!user_nodes.has(participant.id)):
			var node := scene.instantiate()
			add_child(node)
			user_nodes[participant.id] = node as Participant
		user_nodes[participant.id].update(participant)
		
		var pos = prev_ids.find(participant.id)
		if pos >= 0:
			prev_ids.remove_at(pos)
	for prev_id in prev_ids:
		user_nodes[prev_id].queue_free()
		user_nodes.erase(prev_id)


func voice_state_update(data: DiscordSDK.VoiceStateUpdateData) -> void:
	if (user_nodes.has(data.user.id)):
		user_nodes[data.user.id].voice_state_update(data)
