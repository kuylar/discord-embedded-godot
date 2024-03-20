extends TextEdit

onready var discord : DiscordSDK = get_node("/root/Discord")

func _ready():
	discord.connect("packet_received", self, "_packet_received")
	discord.connect("dispatch_any", self, "_dispatch")
	discord.init("1219337474266894397")
	text += "\nWaiting for ready()"
	yield(discord, "dispatch_ready")
	text += "\nReady called!\n"
	text += "\nDiscordSDK.init():"
	text += "\n\tFrame ID: " + discord.frame_id
	text += "\n\tInstance ID: " + discord.instance_id
	text += "\n\tPlatform: " + discord.platform
	text += "\n\tGuild ID: " + discord.guild_id
	text += "\n\tChannel ID: " + discord.channel_id
	text += "\n\tClient ID: " + discord.client_id
	text += "\n\t============================================"
	text += "\n\tSource Origin: " + discord.source_origin
	
	discord.commandAuthorize()

func _packet_received(opcode, data):
	text += "\n========== Packet received! =========="
	text += "\nOP:   " + str(opcode)
	text += "\nDATA: " + str(data)
	text += "\n======================================"

func _dispatch(event, data):
	text += "\n[ DISPATCH ] ========================="
	text += "\nEVENT:" + event
	text += "\nDATA: " + str(data)
	text += "\n======================================"
