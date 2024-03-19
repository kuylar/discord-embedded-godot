class_name DiscordSDK
extends Node

signal packet_received

var callback_func : JavaScriptObject = JavaScript.create_callback(self, "_handle_message");
var frame_id : String
var instance_id : String
var channel_id : String
var guild_id : String
var client_id : String
var platform : String

var source : JavaScriptObject
var source_origin : String

func _handle_message(event):
	var data_json = JavaScript.get_interface("JSON").stringify(event[0].data)
	emit_signal("packet_received", event[0].data[0], JSON.parse(data_json).result);

func _ready():
	JavaScript.get_interface("window").addEventListener("message", callback_func);
	JavaScript.eval("window.addEventListener('message', console.log)")

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

func handshake():
	print("Shaking hands")
	var data = [
		0, # Opcodes.HANDSHAKE
		{
			"v": 1,
			"encoding": "json",
			"client_id": client_id,
			"frame_id": frame_id
		}
	]
	print("data: ")
	print(JSON.print(data))
	
	JavaScript.eval("window.source.postMessage(" + JSON.print(data).replace("'", "\\'") + ", '*')", false)
	#source.postMessage(data, source_origin) # i hate this i hate this i hate this
