extends TextEdit

onready var discord : DiscordSDK = get_node("/root/Discord")

func _ready():
	discord.connect("packet_received", self, "_packet_received")
	discord.connect("dispatch_any", self, "_dispatch")
	discord.init("1219337474266894397")
	text += "\nWaiting for ready()"
	yield(discord, "dispatch_ready")
	text += "\nReady called!\n"
	text += "\n\nGetting auth code"
	var auth = yield(discord.commandAuthorize(), "completed")
	text += "\n\n\tData: " + str(auth)
	text += "\n\n\tAuth: " + auth["code"]

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
