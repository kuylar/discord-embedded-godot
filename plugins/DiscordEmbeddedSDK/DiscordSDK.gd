class_name DiscordSDK
extends Node

signal packet_received

signal dispatch_ready
signal dispatch_error
signal dispatch_voice_state_update
signal dispatch_speaking_start
signal dispatch_speaking_stop
signal dispatch_activity_layout_mode_update
signal dispatch_orientation_update
signal dispatch_current_user_update
signal dispatch_thermal_state_update
signal dispatch_activity_instance_participants_update
signal dispatch_entitlement_create
signal dispatch_any

var callback_func : JavaScriptObject = JavaScript.create_callback(self, "_handle_message");
var frame_id : String
var instance_id : String
var channel_id : String
var guild_id : String
var client_id : String
var platform : String

var source : JavaScriptObject
var source_origin : String

var packet_response_buffer: Array

var ready = false

var _events = ["VOICE_STATE_UPDATE", "SPEAKING_START", "SPEAKING_STOP",
	"ACTIVITY_LAYOUT_MODE_UPDATE", "ORIENTATION_UPDATE", "CURRENT_USER_UPDATE",
	"THERMAL_STATE_UPDATE", "ACTIVITY_INSTANCE_PARTICIPANTS_UPDATE", "ENTITLEMENT_CREATE"]

func _handle_message(event):
	var data_json = JavaScript.get_interface("JSON").stringify(event[0].data[1])
	var data = JSON.parse(data_json).result
	
	# Add to the packet response buffer so we can access them from functions later on
	if (event[0].data[0] == 1): # Opcode.FRAME
		if (data["cmd"] == "DISPATCH"):
			_handle_dispatch(data)
		elif (data["nonce"] != null):
			packet_response_buffer.append(data)
			print("_handle_message: packet received, buffer size: " + str(packet_response_buffer.size()))
		else:
			emit_signal("packet_received", event[0].data[0], data);
	else:
		emit_signal("packet_received", event[0].data[0], data);

func _handle_dispatch(data):
	var event = data["evt"]
	emit_signal("dispatch_any", event, data["data"])
	match event:
		"READY":
			ready = true
			emit_signal("dispatch_ready", data["data"])
		"ERROR":
			emit_signal("dispatch_error", data["data"])
		"VOICE_STATE_UPDATE":
			emit_signal("dispatch_voice_state_update", data["data"])
		"SPEAKING_START":
			emit_signal("dispatch_speaking_start", data["data"])
		"SPEAKING_STOP":
			emit_signal("dispatch_speaking_stop", data["data"])
		"ACTIVITY_LAYOUT_MODE_UPDATE":
			emit_signal("dispatch_activity_layout_mode_update", data["data"])
		"ORIENTATION_UPDATE":
			emit_signal("dispatch_orientation_update", data["data"])
		"CURRENT_USER_UPDATE":
			emit_signal("dispatch_current_user_update", data["data"])
		"THERMAL_STATE_UPDATE":
			emit_signal("dispatch_thermal_state_update", data["data"])
		"ACTIVITY_INSTANCE_PARTICIPANTS_UPDATE":
			emit_signal("dispatch_activity_instance_participants_update", data["data"])
		"ENTITLEMENT_CREATE":
			emit_signal("dispatch_entitlement_create", data["data"])
		_:
			print("_handle_dispatch: Warning! Unknown event: " + str(event)) # convert to string just to be sure

func _ready():
	JavaScript.get_interface("window").addEventListener("message", callback_func);

func init(client_id: String):
	var query_parts = str(JavaScript.eval("window.location.search")).trim_prefix("?").split("&", false)
	var query_map = {}
	for part in query_parts:
		var parts = part.split("=")
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
	guild_id = query_map["guild_id"]
	self.client_id = client_id
	
	source = JavaScript.get_interface("window").parent.opener
	if (source == null):
		print("source was null")
		source = JavaScript.get_interface("window").parent
	JavaScript.eval("window.source = window.parent.opener ?? window.parent", true)
	
	source_origin = JavaScript.eval("!!document.referrer ? document.referrer : '*'")
	handshake()

func sendMessage(opcode, body):
	var data = [
		opcode,
		body
	]
	print("postMessage: " + JSON.print(data))
	JavaScript.eval("window.source.postMessage(" + JSON.print(data).replace("'", "\\'") + ", '*')", false)
	#source.postMessage(data, source_origin) # i hate this i hate this i hate this

func sendCommand(cmd, args, nonce):
	sendMessage(1, {
		"cmd": cmd,
		"args": args,
		"nonce": nonce
	})
	
func _gen_nonce():
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

func _subscribe_to_events():
	for event in _events:
		sendMessage(1, {
			"cmd": "SUBSCRIBE",
			"evt": event,
			"nonce": _gen_nonce()
		})

func handshake():
	print("Shaking hands")
	sendMessage(0, {
		"v": 1,
		"encoding": "json",
		"client_id": client_id,
		"frame_id": frame_id
	})

func ready():
	if (ready):
		return
	else:
		yield(self, "dispatch_ready")

func _wait_for_nonce(nonce):
	var noMatches = true
	var packet = null
	while noMatches:
		yield(self, "packet_received")
		for i in range(packet_response_buffer.size()):
			var tmppacket = packet_response_buffer[i]
			if (tmppacket == null):
				continue
			if (tmppacket["nonce"] == nonce):
				noMatches = false
				packet = tmppacket
				packet_response_buffer.remove(i)
				break
	return packet

func commandAuthorize():
	var nonce = _gen_nonce()
	sendCommand("AUTHORIZE", {
		"client_id": client_id,
		"prompt": "none",
		"response_type": "code",
		"scope": ["identify", "rpc.activities.write"],
		"state": ""
	}, nonce)
	
	var packet = yield(_wait_for_nonce(nonce), "completed")
	return packet
