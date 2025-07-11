class_name DiscordSDK
extends Node


#region Signals
signal packet_received
signal _command_response_received

## Receives a [DiscordSDK.ReadyEventData]
signal dispatch_ready(data: ReadyEventData)

## Receives a [DiscordSDK.ErrorEventData]
signal dispatch_error(data: ErrorEventData)

## Receives a [DiscordSDK.VoiceStateUpdateData]
signal dispatch_voice_state_update(data: VoiceStateUpdateData)

## Receives a [DiscordSDK.SpeakingEventData]
signal dispatch_speaking_start(data: SpeakingEventData)

## Receives a [DiscordSDK.SpeakingEventData]
signal dispatch_speaking_stop(data: SpeakingEventData)

## Receives a [DiscordSDK.ActivityLayoutModeUpdateData]
signal dispatch_activity_layout_mode_update(data: ActivityLayoutModeUpdateData)

## Receives a [DiscordSDK.OrientationUpdateData]
signal dispatch_orientation_update(data: OrientationUpdateData)

## Receives a [DiscordSDK.CurrentUserUpdateData]
signal dispatch_current_user_update(data: CurrentUserUpdateData)

## Receives a [DiscordSDK.ThermalStateUpdateData]
signal dispatch_thermal_state_update(data: ThermalStateUpdateData)

## Receives a [DiscordSDK.ParticipantsUpdateData]
signal dispatch_activity_instance_participants_update(data: ParticipantsUpdateData)

## Receives a [DiscordSDK.CurrentUserUpdateData]
signal dispatch_current_guild_member_update(data: CurrentUserUpdateData)

signal dispatch_entitlement_create(data: Dictionary)
signal dispatch_any(data: Dictionary)
#endregion


#region Data types (https://discord.com/developers/docs/developer-tools/embedded-app-sdk)
#       Postfix these with EventData", or "UpdateData" for update events.
#       Call _decode_simple to automatically decode primitive fields
#       Manually call decode on a class to convert a dictionary to it
## Event data for [signal dispatch_ready]
class ReadyEventData:
	var v: int
	var config: ReadyEventDataConfig
	static func decode(dict: Dictionary) -> ReadyEventData:
		var data := ReadyEventData.new()
		DiscordSDK._decode_simple(dict, data)
		data.config = ReadyEventDataConfig.decode(dict["config"])
		return data
class ReadyEventDataConfig:
	var cdn_host: String
	var api_endpoint: String
	var environment: String
	static func decode(dict: Dictionary) -> ReadyEventDataConfig:
		var data := ReadyEventDataConfig.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## Event data for [signal dispatch_error]
class ErrorEventData:
	var code: int
	var message: String
	static func decode(dict: Dictionary) -> ErrorEventData:
		var data := ErrorEventData.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## Event data for [signal dispatch_voice_state_update]
class VoiceStateUpdateData:
	var voice_state: DiscordVoiceState
	var user: DiscordSimpleUser
	var nick: String
	var volume: int
	var mute: bool
	var pan: DiscordAudioPan
	static func decode(dict: Dictionary) -> VoiceStateUpdateData:
		var data := VoiceStateUpdateData.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("voice_state") != null:
			data.voice_state = DiscordVoiceState.decode(dict["voice_state"])
		if dict.get("user") != null:
			data.user = DiscordSimpleUser.decode(dict["user"])
		if dict.get("pan") != null:
			data.pan = DiscordAudioPan.decode(dict["pan"])
		return data

## Event data for [signal dispatch_speaking_start] and [signal dispatch_speaking_stop]
class SpeakingEventData:
	var channel_id: String
	var user_id: String
	static func decode(dict: Dictionary) -> SpeakingEventData:
		var data := SpeakingEventData.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## Event data for [signal dispatch_activity_layout_mode_update]
class ActivityLayoutModeUpdateData:
	var layout_mode: int
	static func decode(dict: Dictionary) -> ActivityLayoutModeUpdateData:
		var data := ActivityLayoutModeUpdateData.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## Event data for [signal dispatch_activity_layout_mode_update]
class OrientationUpdateData:
	var screen_orientation: int
	static func decode(dict: Dictionary) -> OrientationUpdateData:
		var data := OrientationUpdateData.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## Event data for [signal dispatch_current_user_update]
class CurrentUserUpdateData:
	var user_id: String
	var nick: String
	var guild_id: String
	var avatar: String
	var avatar_decoration_data: DiscordAvatarDecorationData
	var color_string: String
	static func decode(dict: Dictionary) -> CurrentUserUpdateData:
		var data := CurrentUserUpdateData.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("avatar_decoration_data") != null:
			data.avatar_decoration_data = DiscordAvatarDecorationData.decode(dict["avatar_decoration_data"])
		return data

## Event data for [signal dispatch_thermal_state_update]
class ThermalStateUpdateData:
	var thermal_state: int
	static func decode(dict: Dictionary) -> ThermalStateUpdateData:
		var data := ThermalStateUpdateData.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## Event data for [signal dispatch_activity_instance_participants_update]
class ParticipantsUpdateData:
	var participants: Array[DiscordUser] = []
	static func decode(dict: Dictionary) -> ParticipantsUpdateData:
		var data := ParticipantsUpdateData.new()
		if dict.get("participants") != null:
			for participant in dict["participants"]:
				data.participants.push_back(DiscordUser.decode(participant))
		return data
#endregion


#region Custom SDK types, only used for this SDK
class DiscordVoiceState:
	var mute: bool
	var deaf: bool
	var self_mute: bool
	var self_deaf: bool
	var suppress: bool
	static func decode(dict: Dictionary) -> DiscordVoiceState:
		var data := DiscordVoiceState.new()
		DiscordSDK._decode_simple(dict, data)
		return data
class DiscordAudioPan:
	var left: float
	var right: float
	static func decode(dict: Dictionary) -> DiscordAudioPan:
		var data := DiscordAudioPan.new()
		DiscordSDK._decode_simple(dict, data)
		return data
#endregion


#region SDK interface types (https://discord.com/developers/docs/developer-tools/embedded-app-sdk#sdk-interfaces)
#       Prefix them with "Discord" in order to not clash with outside types.
class DiscordActivity:
	## The name of the activity
	var name: String
	## The type of the activity
	var type: int
	## The url of the activity (Nullable)
	var url: String
	## Activity creation time (Nullable)
	var created_at: int
	## Timestamps (Nullable)
	var timestamps: DiscordTimestamp = null
	## Application ID (Nullable)
	var application_id: String
	## Details (Nullable)
	var details: String
	## State (Nullable)
	var state: String
	## Emoji (Nullable)
	var emoji: DiscordEmoji
	
	static func decode(dict: Dictionary) -> DiscordAudioPan:
		var data := DiscordAudioPan.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("timestamps") != null:
			data.timestamps = DiscordTimestamp.decode(dict["timestamps"])
		if dict.get("emoji") != null:
			data.emoji = DiscordEmoji.decode(dict["emoji"])
		return data

class DiscordEmoji:
	## Emoji ID
	var id: String
	## Name (Nullable)
	var name: String
	## Roles (Nullable)
	var roles: Array[String]
	## User (Nullable)
	var user: DiscordUser
	## Require colons (Nullable)
	var require_colons: bool
	## Managed (Nullable)
	var managed: bool
	## Animated (Nullable)
	var animated: bool
	## Available (Nullable)
	var available: bool
	static func decode(dict: Dictionary) -> DiscordEmoji:
		var data := DiscordEmoji.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("user") != null:
			data.user = DiscordUser.decode(dict["user"])
		return data

class DiscordTimestamp:
	## Start time (Nullable)
	var start: int
	## End time (Nullable)
	var end: int
	static func decode(dict: Dictionary) -> DiscordTimestamp:
		var data := DiscordTimestamp.new()
		DiscordSDK._decode_simple(dict, data)
		return data

class DiscordUser extends DiscordSimpleUser:
	## Global name (Nullable)
	var global_name: String
	## Avatar decoration data (Nullable)
	var avatar_decoration_data: DiscordAvatarDecorationData
	## Flags (Nullable)
	var flags: int
	## Premium type (Nullable)
	var premium_type: int
	static func decode(dict: Dictionary) -> DiscordUser:
		var data := DiscordUser.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("avatar_decoration_data") != null:
			data.avatar_decoration_data = DiscordAvatarDecorationData.decode(dict["avatar_decoration_data"])
		return data
class DiscordSimpleUser:
	## User ID
	var id: String
	## Username
	var username: String
	## Username discriminator
	var discriminator: String
	## Avatar hash (Nullable)
	var avatar: String
	## Whenever the user is a bot
	var bot: bool
	static func decode(dict: Dictionary) -> DiscordSimpleUser:
		var data := DiscordSimpleUser.new()
		DiscordSDK._decode_simple(dict, data)
		return data
class DiscordAvatarDecorationData:
	## Asset
	var asset: String
	## (Nullable)
	var sku_id: String
	static func decode(dict: Dictionary) -> DiscordAvatarDecorationData:
		var data := DiscordAvatarDecorationData.new()
		DiscordSDK._decode_simple(dict, data)
		return data
#endregion

## Automatically decodes anything that isn't a class
static func _decode_simple(dict: Dictionary, target: Object) -> void:
	if dict == null:
		return
	for key in dict.keys():
		var value = dict[key]
		var gotten = target.get(key)
		target.set(key, value)


var callback_func := JavaScriptBridge.create_callback(_handle_message);
var frame_id: String
var instance_id: String
var platform: String
var channel_id: String
var client_id: String
var guild_id: String
var user_id: String
var custom_id: String
var referrer_id: String

var source: JavaScriptObject
var source_origin: String

var is_ready := false
var subscribed := false
var in_js := false

var _events := ["VOICE_STATE_UPDATE", "SPEAKING_START", "SPEAKING_STOP",
	"ACTIVITY_LAYOUT_MODE_UPDATE", "ORIENTATION_UPDATE", "CURRENT_USER_UPDATE",
	"THERMAL_STATE_UPDATE", "ACTIVITY_INSTANCE_PARTICIPANTS_UPDATE", "ENTITLEMENT_CREATE",
	"CURRENT_GUILD_MEMBER_UPDATE"]

func _handle_message(event):
	var data_json = JavaScriptBridge.get_interface("JSON").stringify(event[0].data[1])
	var data = JSON.parse_string(data_json)

	# Add to the packet response buffer so we can access them from functions later on
	if (event[0].data[0] == 1): # Opcode.FRAME
		if (data["cmd"] == "DISPATCH"):
			_handle_dispatch(data)
		elif (data["nonce"] != null):
			_command_response_received.emit(data)
		else:
			packet_received.emit(event[0].data[0], data)
	else:
		packet_received.emit(event[0].data[0], data)

func _handle_dispatch(data):
	var event = data["evt"]
	dispatch_any.emit(event, data["data"])
	match event:
		"READY":
			is_ready = true
			var event_data := ReadyEventData.decode(data["data"])
			dispatch_ready.emit(event_data)
		"ERROR":
			var event_data := ErrorEventData.decode(data["data"])
			dispatch_error.emit(event_data)
		"VOICE_STATE_UPDATE":
			var event_data := VoiceStateUpdateData.decode(data["data"])
			dispatch_voice_state_update.emit(event_data)
		"SPEAKING_START":
			var event_data := SpeakingEventData.decode(data["data"])
			dispatch_speaking_start.emit(event_data)
		"SPEAKING_STOP":
			var event_data := SpeakingEventData.decode(data["data"])
			dispatch_speaking_stop.emit(event_data)
		"ACTIVITY_LAYOUT_MODE_UPDATE":
			var event_data := ActivityLayoutModeUpdateData.decode(data["data"])
			dispatch_activity_layout_mode_update.emit(event_data)
		"ORIENTATION_UPDATE":
			var event_data := OrientationUpdateData.decode(data["data"])
			dispatch_orientation_update.emit(event_data)
		"CURRENT_USER_UPDATE":
			user_id = data["data"]["id"]
			var event_data := CurrentUserUpdateData.decode(data["data"])
			dispatch_current_user_update.emit(event_data)
		"THERMAL_STATE_UPDATE":
			var event_data := ThermalStateUpdateData.decode(data["data"])
			dispatch_thermal_state_update.emit(event_data)
		"ACTIVITY_INSTANCE_PARTICIPANTS_UPDATE":
			var event_data := ParticipantsUpdateData.decode(data["data"])
			dispatch_activity_instance_participants_update.emit(event_data)
		"ENTITLEMENT_CREATE":
			dispatch_entitlement_create.emit(data["data"] as Dictionary)
		"CURRENT_GUILD_MEMBER_UPDATE":
			var event_data := CurrentUserUpdateData.decode(data["data"])
			dispatch_current_guild_member_update.emit(event_data)
		_:
			print("_handle_dispatch: Warning! Unknown event: " + str(event)) # convert to string just to be sure

func _ready():
	# For some reason, OS.has_feature("web") sometimes returns false in web
	# Added a OS.get_name() check to be sure
	in_js = OS.has_feature("web") || OS.get_name() == "Web"
	if (in_js):
		JavaScriptBridge.get_interface("window").addEventListener("message", callback_func);
	else:
		print("Not in a JavaScript environment. Discord SDK will not work.")

func init(client_id_: String):
	if (not in_js):
		print("Not in a JavaScript environment. Ignoring call to init()")
		return
	var query_parts := str(JavaScriptBridge.eval("window.location.search")).trim_prefix("?").split("&", false)
	var query_map := {}
	for part in query_parts:
		var parts := part.split("=")
		query_map[parts[0]] = parts[1]

	if (!query_map.has("frame_id")):
		push_error("frameId query variable is not set!")
	if (!query_map.has("instance_id")):
		push_error("instanceId query variable is not set!")
	if (!query_map.has("platform")):
		push_error("platform query variable is not set!")

	frame_id = query_map["frame_id"]
	instance_id = query_map["instance_id"]
	platform = query_map["platform"]
	channel_id = query_map["channel_id"]
	if (query_map.has("guild_id")):
		guild_id = query_map["guild_id"]
	else:
		guild_id = ""
		print("Not in a guild")
	if (query_map.has("custom_id")):
		custom_id = query_map["custom_id"]
	if (query_map.has("referrer_id")):
		referrer_id = query_map["referrer_id"]
	client_id = client_id_
	source = JavaScriptBridge.get_interface("window").parent.opener
	if (source == null):
		source = JavaScriptBridge.get_interface("window").parent
	JavaScriptBridge.eval("window.source = window.parent.opener ?? window.parent", true)

	source_origin = JavaScriptBridge.eval("!!document.referrer ? document.referrer : '*'")
	handshake()

func sendMessage(opcode: Variant, body: Dictionary):
	if (not in_js):
		print("Not in a JavaScript environment. Ignoring call to sendMessage()")
		return
	var data = [
		opcode,
		body
	]
	# note about this, source.postMessage doesn't work, because `data` somehow
	# turns into `undefined` somewhere. not sure how to fix, but this works
	# for now.
	JavaScriptBridge.eval("window.source.postMessage(" + JSON.stringify(data).replace("'", "\\'") + ", '*')", false)
	#source.postMessage(data, "*")

func sendCommand(cmd: Variant, args: Dictionary, nonce: String):
	if (not in_js):
		print("Not in a JavaScript environment. Ignoring call to sendCommand()")
		return
	sendMessage(1, {
		"cmd": cmd,
		"args": args,
		"nonce": nonce
	})

func _gen_nonce() -> String:
	var chars = "0123456789abcdef"
	var output_string := ""

	for i in range(8):
		output_string += chars[randi() % chars.length()]
	output_string += "-"
	for i in range(4):
		output_string += chars[randi() % chars.length()]
	output_string += "-"
	for i in range(4):
		output_string += chars[randi() % chars.length()]
	output_string += "-"
	for i in range(4):
		output_string += chars[randi() % chars.length()]
	output_string += "-"
	for i in range(12):
		output_string += chars[randi() % chars.length()]

	return output_string

func subscribe_to_events():
	if subscribed: return
	for event in _events:
		sendMessage(1, {
			"cmd": "SUBSCRIBE",
			"evt": event,
			"args": {
				"channel_id": channel_id,
				"guild_id": guild_id
			},
			"nonce": _gen_nonce()
		})
	subscribed = true

func handshake():
	print("Shaking hands")
	sendMessage(0, {
		"v": 1,
		"encoding": "json",
		"client_id": client_id,
		"frame_id": frame_id
	})

func ready():
	if (is_ready):
		return
	else:
		await self.dispatch_ready

func close(code: int, message: String):
	# we dont wait for nonce here
	sendMessage(2, {
		"code": code,
		"message": message,
		"nonce": _gen_nonce()
	})

func _wait_for_nonce(nonce: String):
	var noMatches = true
	var packet = null
	while noMatches:
		# TODO: just get packet from this event instead of using a buffer
		var tmppacket = await self._command_response_received
		if (tmppacket["nonce"] == nonce):
			noMatches = false
			packet = tmppacket
			break
	return packet["data"]

func command_authorize(response_type: String, scopes: Array, state: String) -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("AUTHORIZE", {
		"client_id": client_id,
		"prompt": "none",
		"response_type": response_type,
		"scope": scopes,
		"state": state
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet

func command_authenticate(access_token: String) -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("AUTHENTICATE", {
		"access_token": access_token
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet

func command_capture_log(level: String, message: String) -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("CAPTURE_LOG", {
		"level": level,
		"message": message
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet

func command_encourage_hardware_acceleration() -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("ENCOURAGE_HW_ACCELERATION", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet

func command_get_channel(id: String) -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("GET_CHANNEL", {
		"channel_id": id
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_get_channel_permissions() -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("GET_CHANNEL_PERMISSIONS", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_get_entitlements_embedded() -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("GET_ENTITLEMENTS_EMBEDDED", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_get_instance_connected_participants() -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("GET_ACTIVITY_INSTANCE_CONNECTED_PARTICIPANTS", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_get_platform_behaviors() -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("GET_PLATFORM_BEHAVIORS", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_get_skus() -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("GET_SKUS_EMBEDDED", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_initiate_image_upload() -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("INITIATE_IMAGE_UPLOAD", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_open_external_link(url: String) -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("OPEN_EXTERNAL_LINK", {
		"url": url
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_open_invite_dialog() -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("OPEN_INVITE_DIALOG", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_open_share_moment_dialog(media_url: String) -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("OPEN_SHARE_MOMENT_DIALOG", {
		"mediaUrl": media_url
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_set_activity(state: String, details: String, timestamps: Dictionary = {}, assets: Dictionary = {}, party: Dictionary = {}, secrets: Dictionary = {}, instance: bool = false) -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("SET_ACTIVITY", {
		"activity": {
			"state": state,
			"details": details,
			"timestamps": timestamps,
			"assets": assets,
			"party": party,
			"secrets": secrets,
			"instance": instance
		}
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_set_config(use_interactive_pip: bool) -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("SET_CONFIG", {
		"use_interactive_pip": use_interactive_pip
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet



# UNHANDLED: -1
# PORTRAIT: 0
# LANDSCAPE: 1
func command_set_orientation_lock_state(lock_state: int, pip_lock_state: int, grid_lock_state: int) -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("SET_ORIENTATION_LOCK_STATE", {
		"lock_state": lock_state,
		"pip_lock_state": pip_lock_state,
		"grid_lock_state": grid_lock_state
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_start_purchase(sku_id: String, pid: int) -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("START_PURCHASE", {
		"sku_id": sku_id,
		"pid": pid
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_user_settings_get_locale() -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("USER_SETTINGS_GET_LOCALE", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return packet


func command_share_link(message: String, referrer_id: String, custom_id: String) -> Dictionary:
	var nonce = _gen_nonce()
	sendCommand("SHARE_LINK", {
		"referrer_id": referrer_id,
		"custom_id": custom_id,
		"message": message
	}, nonce)
	
	var packet = await _wait_for_nonce(nonce)
	return packet
