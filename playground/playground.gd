extends Control

@onready var discord : DiscordSDK = get_node("/root/Discord")
@onready var log_node : RichTextLabel = $"HBoxContainer/VSplitContainer/Log"
@onready var dispatch_log_node : RichTextLabel = $"%Dispatch"
@onready var raw_dispatch_log_node : RichTextLabel = $"%Raw Dispatch"

var pip_interactivity_press_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	discord.init("1219337474266894397")

	discord.connect("dispatch_any", Callable(self, "_dispatch"))
	discord.connect("dispatch_current_user_update", Callable(self, "_user_updated"))
	
	discord.connect("dispatch_activity_layout_mode_update", Callable(self, "_pip_change"))
	
	log_node.set_scroll_follow(true)


func msg(message: String) -> void:
	log_node.text += "\n" + message


func msg_dispatch(event: String, message: String) -> void:
	dispatch_log_node.text += "\n\n" + event + "\n" + message


func _dispatch(event, data) -> void:
	raw_dispatch_log_node.text += "\n[ " + event + " ]\n"
	raw_dispatch_log_node.text += str(data)
	raw_dispatch_log_node.text += "\n======================================"
	
	match event:
		"READY":
			msg_dispatch(event, "Dispatch is ready!\nVersion: %s\nCDN Host: %s\nAPI Endpoint: %s\nEnvironment: %s" % [data["v"], data["config"]["cdn_host"], data["config"]["api_endpoint"], data["config"]["environment"]])
		"VOICE_STATE_UPDATE":
			msg_dispatch(event, "%s's voice state changed!\nMuted: %s\nVolume: %s\nPan: %s - %s" % [data["nick"], str(data["mute"]), str(data["volume"]), str(data["pan"]["left"]), str(data["pan"]["right"])])
		"SPEAKING_START":
			msg_dispatch(event, "User with ID %s started speaking" % [data["user_id"]])
		"SPEAKING_STOP":
			msg_dispatch(event, "User with ID %s stopped speaking" % [data["user_id"]])
		"ACTIVITY_LAYOUT_MODE_UPDATE":
			if (data["layout_mode"] == 1):
				msg_dispatch(event, "Activity is now in PiP mode")
			else:
				msg_dispatch(event, "Activity is no longer in PiP mode")
		"ORIENTATION_UPDATE":
			msg_dispatch(event, "Orientation is now %s" % ["landscape" if data["screen_orientation"] == 1 else "portrait"])
		"CURRENT_USER_UPDATE":
			msg_dispatch(event, "Current user updated")
		"THERMAL_STATE_UPDATE":
			var states = ["normal", "fair", "serious", "critical"]
			msg_dispatch(event, "Thermal state is now %s" % [states[data["thermal_state"]]])
		"ACTIVITY_INSTANCE_PARTICIPANTS_UPDATE":
			msg_dispatch(event, "Participants updated")
		"ENTITLEMENT_CREATE":
			msg_dispatch(event, "Entitlement created")
		"CURRENT_GUILD_MEMBER_UPDATE":
			msg_dispatch(event, "Current guild member updated")
		_:
			msg_dispatch(event, "Unknown event")


func _pip_change(data) -> void:
	if (data["layout_mode"] == 1):
		$"%PipOverlay".visible = true
	else:
		$"%PipOverlay".visible = false


func _on_set_config_button_pressed() -> void:
	var config = $"%PipInteractivityState".get_selected_id() == 1
	msg("[i]discord.command_set_config(" + str(config) + ")[/i]")
	var result = await discord.command_set_config(config)
	msg("[i][b]no output[/b][/i]")


func _on_capture_log_button_pressed() -> void:
	var level_id = $"%LogLevel".get_selected_id()
	var level = "log"
	match level_id:
		0:
			level = "log"
		1:
			level = "warn"
		2:
			level = "debug"
		3:
			level = "info"
		4:
			level = "error"
	var message = $"%LogMessage".text
	msg("[i]discord.command_capture_log(\"" + level + "\", \"" + message + "\")[/i]")
	var result = await discord.command_capture_log(level, message)
	msg("[i][b]no output[/b][/i]")


func _on_encourage_hw_accel_pressed() -> void:
	msg("[i]discord.command_encourage_hardware_acceleration()[/i]")
	var result = await discord.command_encourage_hardware_acceleration()
	msg("Hardware acceleration is: " + ("Enabled" if result["enabled"] else "Disabled"))


func _on_external_url_button_pressed() -> void:
	var url = $"%ExternalUrlInput".text
	msg("[i]discord.command_open_external_link(" + str(url) + ")[/i]")
	var result = await discord.command_open_external_link(url)
	msg("[i][b]no output[/b][/i]")


func _on_set_orientation_lock_button_pressed() -> void:
	var lock_state = -1 if $"%LockState".get_selected_id() == 0 else $"%LockState".get_selected_id()
	var pip_lock_state = -1 if $"%PipLockState".get_selected_id() == 0 else $"%PipLockState".get_selected_id()
	var grid_lock_state = -1 if $"%GridLockState".get_selected_id() == 0 else $"%GridLockState".get_selected_id()

	msg("[i]discord.command_set_orientation_lock_state(" + str(lock_state) + ", " + str(pip_lock_state) + ", " + str(grid_lock_state) + ")[/i]")
	var result = await discord.command_set_orientation_lock_state(lock_state, pip_lock_state, grid_lock_state)
	msg("[i][b]no output[/b][/i]")


func _on_log_channel_info_button_pressed() -> void:
	msg("[i]discord.command_get_channel(" + str(discord.channel_id) + ")[/i]")
	var result = await discord.command_get_channel(discord.channel_id)
	msg("[Channel Info] =====================================================")
	msg("Id: " + str(result["id"]))
	msg("Name: " + str(result["name"]))
	msg("Type: " + str(result["type"]))
	msg("Topic: " + str(result["topic"]))
	msg("Bitrate: " + str(result["bitrate"]))
	msg("User Limit: " + str(result["user_limit"]))
	msg("Guild Id: " + str(result["guild_id"]))
	msg("Position: " + str(result["position"]))
	msg("[Voice States]")
	for state in result["voice_states"]:
		msg("- Nick: " + str(state["nick"]))
		msg("  Muted: " + str(state["mute"]))
		msg("  Volume: " + str(state["volume"]))
		msg("  Pan:")
		msg("    Left: " + str(state["pan"]["left"]))
		msg("    Right: " + str(state["pan"]["right"]))
	msg("[/Voice States]")
	msg("[/Channel Info] ====================================================")


func _on_log_channel_permissions_button_pressed() -> void:
	msg("[i]discord.command_get_channel_permissions()[/i]")
	var result = await discord.command_get_channel_permissions()
	msg("[Channel Permissions] ==============================================")
	msg("Permissions: " + str(result["permissions"]))
	msg("[/Channel Permissions] =============================================")


func _on_log_platform_behaviors_button_pressed() -> void:
	msg("[i]discord.command_get_platform_behaviors()[/i]")
	var result = await discord.command_get_platform_behaviors()
	msg("[Platform Behaviors] ===============================================")
	for key in result:
		msg(str(key) + ": " + str(result[key]))
	msg("[/Platform Behaviors] ==============================================")


func _on_log_user_locale_button_pressed() -> void:
	msg("[i]discord.command_user_settings_get_locale()[/i]")
	var result = await discord.command_user_settings_get_locale()
	msg("[b]User Locale: [/b] " + result["locale"])


func _on_initiate_image_upload_button_pressed() -> void:
	var line_edit : LineEdit = $"%ShareMomentUrl"
	msg("[i]discord.command_initiate_image_upload()[/i]")
	var result = await discord.command_initiate_image_upload()
	msg("Image URL: " + str(result["image_url"]))
	line_edit.text = str(result["image_url"])


func _on_share_moment_button_pressed() -> void:
	var line_edit : LineEdit = $"%ShareMomentUrl"
	msg("[i]discord.command_open_share_moment_dialog()[/i]")
	var result = await discord.command_open_share_moment_dialog(line_edit.text)
	msg("[i][b]no output[/b][/i]")


func _on_invite_button_pressed() -> void:
	msg("[i]discord.command_open_invite_dialog()[/i]")
	var result = await discord.command_open_invite_dialog()
	msg("[i][b]no output[/b][/i]")


func _on_set_activity_button_pressed() -> void:
	var state              = $"%ActivityState".text
	var details            = $"%ActivityDetails".text
	var start_date         = $"%ActivityStartTimestamp".text
	var end_date           = $"%ActivityEndTimestamp".text
	var large_image        = $"%ActivityLargeImage".text
	var large_image_text   = $"%ActivityLargeImageText".text
	var small_image        = $"%ActivitySmallImage".text
	var small_image_text   = $"%ActivitySmallImageText".text
	var party_id           = $"%ActivityPartyId".text
	var party_member_count = $"%ActivityPartyMemberCount".text
	var party_member_max   = $"%ActivityMaxMemberCount".text
	var secret_match       = $"%ActivityMatchSecret".text
	var secret_join        = $"%ActivityJoinSecret".text
	var secret_spectate    = $"%ActivitySpectateSecret".text
	var instance           = $"%ActivityInstance".button_pressed

	var timestamps = {}
	var assets = {}
	var party = {}
	var secrets = {}

	if (len(start_date) > 0):
		timestamps["start"] = int(start_date)
	if (len(end_date) > 0):
		timestamps["end"] = int(end_date)
	if (len(small_image) > 0):
		assets["small_image"] = str(small_image)
	if (len(small_image_text) > 0):
		assets["small_text"] = str(small_image_text)
	if (len(large_image) > 0):
		assets["large_image"] = str(large_image)
	if (len(large_image_text) > 0):
		assets["large_text"] = str(large_image_text)
	if (len(party_id) > 0):
		party["id"] = party_id
	if (len(party_member_count) > 0 or len(party_member_max) > 0):
		party["size"] = [
			int(party_member_count),
			int(party_member_max)
		]
	if (len(secret_match) > 0):
		secrets["match"] = secret_match
	if (len(secret_join) > 0):
		secrets["join"] = secret_join
	if (len(secret_spectate) > 0):
		secrets["spectate"] = secret_spectate
	discord.command_set_activity(state, details, timestamps, assets, party, secrets, instance)


func _on_oauth_authorize_button_pressed() -> void:
	var scopes = []
	var progress : ProgressBar = $"%OauthProgressBar"
	
	if ($"%OauthScopeIdentify".button_pressed):
		scopes.append("identify")
	if ($"%OauthScopeGuilds".button_pressed):
		scopes.append("guilds")
	if ($"%OauthScopeActivitiesWrite".button_pressed):
		scopes.append("rpc.activities.write")
	if ($"%OauthScopeVoiceRead".button_pressed):
		scopes.append("rpc.voice.read")
	if ($"%OauthScopeMembersRead".button_pressed):
		scopes.append("guilds.members.read")
	
	progress.value = 1
	msg("Authorizing with scopes: " + str(scopes))
	var auth = await discord.command_authorize("code", scopes, "")
	progress.value = 2
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
	progress.value = 3
	msg("Got access token")
	var authRes = await discord.command_authenticate(token)
	msg("OAuth complete")
	discord.subscribe_to_events()
	$"%OauthWindow".visible = false
	$"%OauthWindowBg".visible = false


func _on_pip_interactivity_test_button_pressed() -> void:
	pip_interactivity_press_count += 1
	$"%PipInteractivityTestButton".text = "I was pressed %s times!" % str(pip_interactivity_press_count)
