class_name Participant

extends Panel

@onready var avatar: TextureRect = $Avatar
@onready var username: RichTextLabel = $Name
@onready var flags: RichTextLabel = $Flags

func update(data: Dictionary) -> void:
	username.text = data["global_name"] + "  [i](@" + data["username"] + ")[/i]"
	flags.text = ""

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
	avatar.texture = texture


func voice_state_update(data: Dictionary) -> void:
	var text = ""
	var voice_state = data["voice_state"]
	if (voice_state["mute"] == true):
		text += "M "
	if (voice_state["deaf"] == true):
		text += "D "
	if (voice_state["self_mute"] == true):
		text += "SM "
	if (voice_state["self_deaf"] == true):
		text += "SD "
	if (voice_state["suppress"] == true):
		text += "Suppressed"
	flags.text = "[i]%s[/i]" % text.trim_suffix(" ")
