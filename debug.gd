extends Control

@onready var discord : DiscordSDK = get_node("/root/Discord")
@onready var text = $HBoxContainer/TextEdit
@onready var user_avatar = $HBoxContainer/Panel/ScrollContainer/VBoxContainer/UserPanel/UserAvatar
@onready var user_name = $HBoxContainer/Panel/ScrollContainer/VBoxContainer/UserPanel/UserName
@onready var user_id = $HBoxContainer/Panel/ScrollContainer/VBoxContainer/UserPanel/UserId

var moment_url = ""

func _ready():
	discord.connect("packet_received", Callable(self, "_packet_received"))
	discord.connect("dispatch_any", Callable(self, "_dispatch"))
	
	discord.connect("dispatch_current_user_update", Callable(self, "_user_updated"))
	
	discord.init("1219337474266894397")
	text.text += "\nWaiting for ready()"
	await discord.dispatch_ready
	text.text += "\nGetting auth code"
	var auth = await discord.command_authorize("code", ["identify", "guilds", "rpc.activities.write"], "")
	text.text += "\nGetting access token from server"
	var hreq = HTTPRequest.new()
	hreq.accept_gzip = false # ?? huh? https://forum.godotengine.org/t/-/37681/19
	add_child(hreq)
	var token_res = hreq.request(
		"https://1219337474266894397.discordsays.com/api/auth",
		["Content-Type: application/x-www-form-urlencoded"],
		HTTPClient.METHOD_POST,
		"code=" + auth["code"]
	)
	var response = await hreq.request_completed
	hreq.queue_free()
	var json = response[3].get_string_from_utf8()
	var token_json = JSON.parse_string(json)
	var token = token_json["access_token"]
	text.text += "\nSending AUTHENTICATE..."
	var authRes = await discord.command_authenticate(token)
	text.text += "\nAuth complete, enjoy the buttons!\n"
	discord.subscribe_to_events()

func _packet_received(opcode, data):
	text.text += "\n========== Packet received! =========="
	text.text += "\nOP:   " + str(opcode)
	text.text += "\nDATA: " + str(data)
	text.text += "\n======================================"

func _dispatch(event, data):
	text.text += "\n[ DISPATCH ] ========================="
	text.text += "\nEVENT:" + event
	text.text += "\nDATA: " + str(data)
	text.text += "\n======================================"

func _user_updated(data):
	user_id.text = data["id"]
	user_name.text = data["global_name"] + " (@" + data["username"] + ")"
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	var http_error = http_request.request("https://cdn.discordapp.com/avatars/"+data["id"]+"/"+data["avatar"]+".png?size=64")
	var response = await http_request.request_completed
	print("loaded image?")
	print(response[1])
	
	var image = Image.new()
	var image_error = image.load_png_from_buffer(response[3])
	print("image load status: " + str(image_error))
	if image_error != OK:
		print("An error occurred while trying to display the image.")
	var texture = ImageTexture.create_from_image(image)
	# Assign to the child TextureRect node
	user_avatar.texture = texture
	


func _on_ButtonCaptureLog_pressed():
	text.text += "\n" + str(await discord.command_capture_log("info", "Hello from Godot!"))

func _on_ButtonEncourageHwAccel_pressed():
	text.text += "\n" + str(await discord.command_encourage_hardware_acceleration())

func _on_ButtonGetChannel_pressed():
	text.text += "\n" + str(await discord.command_get_channel(discord.channel_id))

func _on_ButtonGetChannelPermissions_pressed():
	text.text += "\n" + str(await discord.command_get_channel_permissions())

func _on_ButtonGetEntitlements_pressed():
	text.text += "\n" + str(await discord.command_get_entitlements_embedded())

func _on_ButtonGetInstanceConnectedParticipants_pressed():
	text.text += "\n" + str(await discord.command_get_instance_connected_participants())

func _on_ButtonGetPlatformBehaviors_pressed():
	text.text += "\n" + str(await discord.command_get_platform_behaviors())

func _on_ButtonGetSkus_pressed():
	text.text += "\n" + str(await discord.command_get_skus())

func _on_ButtonInitiateImageUpload_pressed():
	var upload = await discord.command_initiate_image_upload()
	moment_url = upload["image_url"]
	text.text += "\n" + str(upload)

func _on_ButtonOpenExternalLink_pressed():
	text.text += "\n" + str(await discord.command_open_external_link("https://github.com/kuylar/discord-embedded-godot/"))
	text.text += "\nMake sure to leave a star! and maybe a tip..."

func _on_ButtonOpenInviteDialog_pressed():
	text.text += "\n" + str(await discord.command_open_invite_dialog())	

func _on_ButtonOpenShareMomentDialog_pressed():
	if (moment_url == ""):
		text.text += "\nPlease upload an image using the 'Initiate Image Upload' button first."
		return
	text.text += "\n" + str(await discord.command_open_share_moment_dialog(moment_url))

func _on_ButtonSetActivity_pressed():
	text.text += "\n" + str(await discord.command_set_activity("Writing code", "Not in a dungeon"))

func _on_ButtonSetConfig_pressed():
	text.text += "\n" + str(await discord.command_set_config(true))
	text.text += "\nThe PIP window should be interactable now. Give it a try!"

func _on_ButtonSetOrientationLockState_pressed():
	text.text += "\n" + str(await discord.command_set_orientation_lock_state(1, 1, 1))
	text.text += "\nHope you like the landscape layout!"

func _on_ButtonStartPurchase_pressed():
	text.text += "\nNot available in Developer Preview."

func _on_ButtonUserSettingsGetLocale_pressed():
	text.text += "\n" + str(await discord.command_user_settings_get_locale())

func _on_ButtonQuit_pressed():
	text.text += "See you later!"
	discord.close(1000, "See you next time!")
