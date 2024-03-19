extends TextEdit

onready var discord : DiscordSDK = get_node("/root/Discord")

func _ready():
	discord.connect("packet_received", self, "_packet_received")
	discord.init("1219337474266894397")
	text += "\nDiscordSDK.init():"
	text += "\n\tFrame ID: " + discord.frame_id
	text += "\n\tInstance ID: " + discord.instance_id
	text += "\n\tPlatform: " + discord.platform
	text += "\n\tGuild ID: " + discord.guild_id
	text += "\n\tChannel ID: " + discord.channel_id
	text += "\n\tClient ID: " + discord.client_id
	text += "\n\t============================================"
	text += "\n\tSource Origin: " + discord.source_origin

func _packet_received(opcode, data):
	text += "\n= Packet received! ="
	text += "\nOP:   " + str(opcode)
	text += "\nDATA: " + str(data)
	text += "\n===================="
