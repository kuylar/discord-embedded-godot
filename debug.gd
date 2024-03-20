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
	var auth = yield(discord.commandAuthorize("code", ["identify", "guilds"], ""), "completed")
	text += "\n\tAuth: " + auth["code"]
	text += "\n\nGetting access token from server"
	var hreq = HTTPRequest.new()
	add_child(hreq)
	var token_res = hreq.request(
		"https://1219337474266894397.discordsays.com/api/auth",
		["Content-Type: application/x-www-form-urlencoded"],
		true,
		HTTPClient.METHOD_POST,
		"code=" + auth["code"]
	)
	var response = yield(hreq, "request_completed")
	hreq.queue_free()
	var token = parse_json(response[3].get_string_from_utf8())["access_token"]
	text += "\n\nSending AUTHENTICATE..."
	var authRes = yield(discord.commandAuthenticate(token), "completed")
	text += "\n\tData: " + str(authRes).replace(token, "<redacted>")
	text += "\n\nWelcome, " + authRes["user"]["username"]
	discord.subscribe_to_events()

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
