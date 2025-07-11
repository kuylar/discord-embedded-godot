extends Panel

@onready var discord: DiscordSDK = get_node("/root/Discord")
@onready var avatar: TextureRect = $Avatar
@onready var username: RichTextLabel = $Name
@onready var flags: RichTextLabel = $Flags


func _ready() -> void:
	discord.dispatch_current_user_update.connect(update)


func update(data: DiscordSDK.CurrentUserUpdateData) -> void:
	username.text = data.global_name + "  [i](@" + data.username + ")[/i]"
	flags.text = data.id
	
	var http_request := HTTPRequest.new()
	add_child(http_request)
	var _http_error := http_request.request("https://cdn.discordapp.com/avatars/%s/%s.png?size=64" % [data.id, data.avatar])
	var response = await http_request.request_completed
	print("loaded image?")
	print(response[1])
	
	var image := Image.new()
	var image_error := image.load_png_from_buffer(response[3])
	print("image load status: " + str(image_error))
	if image_error != OK:
		print("An error occurred while trying to display the image.")
	var texture := ImageTexture.create_from_image(image)
	avatar.texture = texture
