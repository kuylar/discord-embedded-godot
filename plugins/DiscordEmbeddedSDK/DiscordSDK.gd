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

## Receives a [DiscordSDK.CurrentGuildMemberUpdate]
signal dispatch_current_guild_member_update(data: CurrentGuildMemberUpdateData)

## Receives a [Dictionary]. This should be replaced by a proper type when its later added.
signal dispatch_entitlement_create(data: Dictionary)

## Receives any event type, or a [Dictionary]
signal dispatch_any(data: Object)
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
	var id: String
	var username: String
	var discriminator: String
	var global_name: String
	var avatar: String
	var avatar_decoration_data: DiscordAvatarDecorationData
	var color_string: String
	var bot: bool
	var flags: int
	var premium_type: int
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

## Event data for [signal dispatch_current_guild_member_update]
class CurrentGuildMemberUpdateData:
	var user_id: String
	var nick: String
	var guild_id: String
	var avatar: String
	var color_string: String
	var avatar_decoration_data: DiscordAvatarDecorationData
	static func decode(dict: Dictionary) -> CurrentGuildMemberUpdateData:
		var data := CurrentGuildMemberUpdateData.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("avatar_decoration_data") != null:
			data.avatar_decoration_data = DiscordAvatarDecorationData.decode(dict["avatar_decoration_data"])
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
## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#uservoicestate
class DiscordUserVoiceState:
	var mute: bool
	var nick: String
	var user: DiscordUser
	var voice_state: DiscordVoiceState
	var volume: int
	var pan: DiscordAudioPan
	static func decode(dict: Dictionary) -> DiscordUserVoiceState:
		var data := DiscordUserVoiceState.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("user") != null:
			data.user = DiscordUser.decode(dict["user"])
		if dict.get("voice_state") != null:
			data.voice_state = DiscordVoiceState.decode(dict["voice_state"])
		if dict.get("pan") != null:
			data.pan = DiscordAudioPan.decode(dict["pan"])
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#voicestate
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

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#channeltypesobject
enum DiscordChannelTypes {
	UNHANDLED = -1,
	DM = 1,
	GROUP_DM = 3,
	GUILD_TEXT = 0,
	GUILD_VOICE = 2,
	GUILD_CATEGORY = 4,
	GUILD_ANNOUNCEMENT = 5,
	GUILD_STORE = 6,
	ANNOUNCEMENT_THREAD = 10,
	PUBLIC_THREAD = 11,
	PRIVATE_THREAD = 12,
	GUILD_STAGE_VOICE = 13,
	GUILD_DIRECTORY = 14,
	GUILD_FORUM = 15,
}

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#orientationlockstatetypeobject
enum DiscordOrientationLockStateType {
	UNHANDLED = -1,
	UNLOCKED = 1,
	PORTRAIT = 2,
	LANDSCAPE = 3
}

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#skutypeobject
enum DiscordSkuType {
	UNHANDLED = -1,
	APPLICATION = 1,
	DLC = 2,
	CONSUMABLE = 3,
	BUNDLE = 4,
	SUBSCRIPTION = 5
}

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#activity
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
	## Party (Nullable)
	var party: DiscordParty
	## Assets (Nullable)
	var assets: DiscordAssets
	## Secrets (Nullable)
	var secrets: DiscordSecrets
	## Instance (Nullable)
	var instance: bool
	## Flags (Nullable)
	var flags: int
	static func decode(dict: Dictionary) -> DiscordActivity:
		var data := DiscordActivity.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("timestamps") != null:
			data.timestamps = DiscordTimestamp.decode(dict["timestamps"])
		if dict.get("emoji") != null:
			data.emoji = DiscordEmoji.decode(dict["emoji"])
		if dict.get("party") != null:
			data.party = DiscordParty.decode(dict["party"])
		if dict.get("assets") != null:
			data.assets = DiscordAssets.decode(dict["assets"])
		if dict.get("secrets") != null:
			data.secrets = DiscordSecrets.decode(dict["secrets"])
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#emoji
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

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#timestamp
class DiscordTimestamp:
	## Start time (Nullable)
	var start: int
	## End time (Nullable)
	var end: int
	static func decode(dict: Dictionary) -> DiscordTimestamp:
		var data := DiscordTimestamp.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#attachment
class DiscordAttachment:
	## ID
	var id: String
	## Filename
	var filename: String
	## Size
	var size: int
	## URL
	var url: String
	## Proxy URL
	var proxy_url: String
	## Height (Nullable)
	var height:	int
	## Width (Nullable)
	var width:	int
	static func decode(dict: Dictionary) -> DiscordAttachment:
		var data := DiscordAttachment.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#reaction
class DiscordReaction:
	var count: int
	var me: bool
	var emoji: DiscordEmoji
	static func decode(dict: Dictionary) -> DiscordReaction:
		var data := DiscordReaction.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("emoji") != null:
			data.emoji = DiscordEmoji.decode(dict["emoji"])
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#user
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
	## SKU ID (Nullable)
	var sku_id: String
	static func decode(dict: Dictionary) -> DiscordAvatarDecorationData:
		var data := DiscordAvatarDecorationData.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#guildmember
class DiscordGuildMember:
	## User
	var user: DiscordUser
	## Nick (Nullable)
	var nick: String
	## Roles
	var roles: Array[String] = []
	## Joined at
	var joined_at: String
	## Deaf
	var deaf: bool
	## Mute
	var mute: bool
	static func decode(dict: Dictionary) -> DiscordGuildMember:
		var data := DiscordGuildMember.new()
		DiscordSDK._decode_simple(dict, data)
		data.user = DiscordUser.decode(dict["user"])
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#assets
class DiscordAssets:
	## Large image (Nullable)
	var large_image: String
	## Large text (Nullable)
	var large_text: String
	## Small image (Nullable)
	var small_image: String
	## Small text (Nullable)
	var small_text: String
	static func decode(dict: Dictionary) -> DiscordAssets:
		var data := DiscordAssets.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#application
class DiscordApplication:
	## Description
	var description: String
	## Icon (Nullable)
	var icon: String
	## Id
	var id: String
	## RPC origins
	var rpc_origins: Array[String] = []
	## Name
	var name: String
	static func decode(dict: Dictionary) -> DiscordApplication:
		var data := DiscordApplication.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#party
class DiscordParty:
	## Party ID (Nullable)
	var id: String
	## Party size (Nullable)
	var size: Array[String]
	static func decode(dict: Dictionary) -> DiscordParty:
		var data := DiscordParty.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#relationship
class DiscordRelationship:
	## Relationship type
	var type: int
	## Relationship user
	var user: DiscordUser
	static func decode(dict: Dictionary) -> DiscordApplication:
		var data := DiscordApplication.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("user") != null:
			data.user = DiscordUser.decode(dict["user"])
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#secrets
class DiscordSecrets:
	## Join secret (Nullable)
	var id_secret: String
	## Match secret (Nullable)
	var match_secret: String
	static func decode(dict: Dictionary) -> DiscordSecrets:
		var data := DiscordSecrets.new()
		data.id_secret = dict["secret"]
		data.match_secret = dict["match"]
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#message
class DiscordMessage:
	## ID
	var id: String
	## Channel ID
	var channel_id: String
	## Guild ID (Nullable)
	var guild_id
	## Author (Nullable)
	var author: DiscordUser
	## Member (Nullable)
	var member: DiscordGuildMember
	## Content
	var content: String
	## Timestamp
	var timestamp: String
	## Edited timestamp (Nullable)
	var edited_timestamp: String
	## Text-to-speech
	var tts: bool
	## Mention everyone
	var mention_everyone: bool
	## Mentions
	var mentions: Array[DiscordUser]
	## Mention roles
	var mention_roles: Array[String]
	## Mentioned channels
	var mention_channels: Array[Dictionary]
	## Attachments
	var attachments: Array[DiscordAttachment]
	## Embeds
	var embeds: Array[Dictionary]  # TODO: Make a data type for embeds
	## Reactions (Nullable)
	var reactions: Array[DiscordReaction]
	## Nonce
	var nonce: String
	## Pinned
	var pinned: bool
	## Webhook ID (Nullable)
	var webhook_id: String
	## Type
	var type: int
	## Message activity (Nullable)
	var activity: DiscordMessageActivity
	## Message application (Nullable)
	var application: DiscordMessageApplication
	## Message reference (Nullable)
	var message_reference: DiscordMessageReference
	## Flags
	var flags: int
	## Stickers (Nullable)
	var stickers: Array[Dictionary]  # Stickers don't seem to have a type in the docs?
	## Referenced message (Nullable)
	var referenced_message: DiscordMessage
	static func decode(dict: Dictionary) -> DiscordMessage:
		var data := DiscordMessage.new()
		DiscordSDK._decode_simple(dict, data)
		data.author = DiscordUser.decode(dict["author"])
		data.member = DiscordGuildMember.decode(dict["member"])
		if dict.get("mentions") != null:
			data.mentions = []
			for mention in dict["mentions"]:
				data.mentions.push_back(DiscordUser.decode(mention))
		if dict.get("attachments") != null:
			data.attachments = []
			for attachment in dict["attachments"]:
				data.attachments.push_back(DiscordAttachment.decode(attachment))
		if dict.get("reactions") != null:
			data.reactions = []
			for reaction in dict["reactions"]:
				data.reactions.push_back(DiscordReaction.decode(reaction))
		if dict.get("activity") != null:
			data.activity = DiscordMessageActivity.decode(dict["activity"])
		if dict.get("application") != null:
			data.application = DiscordMessageApplication.decode(dict["application"])
		if dict.get("message_reference") != null:
			data.message_reference = DiscordMessageReference.decode(dict["message_reference"])
		if dict.get("referenced_message") != null:
			data.referenced_message = DiscordMessage.decode(dict["referenced_message"])
		return data
class DiscordMessageActivity:
	## Type
	var type: int
	## Party ID (Nullable)
	var party_id: String
	static func decode(dict: Dictionary) -> DiscordMessageActivity:
		var data := DiscordMessageActivity.new()
		DiscordSDK._decode_simple(dict, data)
		return data
class DiscordMessageApplication:
	## ID
	var id: String
	## Cover image (Nullable)
	var cover_image: String
	## Description
	var description: String
	## Icon (Nullable)
	var icon: String
	## Name
	var name: String
	static func decode(dict: Dictionary) -> DiscordMessageApplication:
		var data := DiscordMessageApplication.new()
		DiscordSDK._decode_simple(dict, data)
		return data
class DiscordMessageReference:
	## Message ID (Nullable)
	var message_id: String
	## Channel ID (Nullable)
	var channel_id: String
	## Guild ID (Nullable)
	var guild_id: String
	static func decode(dict: Dictionary) -> DiscordMessageReference:
		var data := DiscordMessageReference.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#sku
class DiscordSku:
	## ID
	var id: String
	## Name
	var name: String
	## Type
	var type: DiscordSkuType
	## Price
	var price: DiscordSkuPrice
	## Application ID
	var application_id: String
	## Flags
	var flags: int
	## Release date (Nullable)
	var release_date: String
	static func decode(dict: Dictionary) -> DiscordSku:
		var data := DiscordSku.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("type") != null:
			data.type = int(dict["type"]) as DiscordSkuType
		if dict.get("price") != null:
			data.price = DiscordSkuPrice.decode(dict["price"])
		return data
class DiscordSkuPrice:
	var amount: float
	var currency: String
	static func decode(dict: Dictionary) -> DiscordSkuPrice:
		var data := DiscordSkuPrice.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#entitlement
class DiscordEntitlement:
	## ID
	var id: String
	## SKU ID
	var sku_id: String
	## Application ID
	var application_id: String
	## User ID
	var user_id: String
	## Gift code flags
	var gift_code_flags: int
	## Type (String or int)
	var type: Variant
	## Gifter user ID (Nullable)
	var gifter_user_id: String
	## Branches (Nullable)
	var branches: Array[String]
	## Starts at (Nullable)
	var starts_at: String
	## Ends at (Nullable)
	var ends_at: String	
	## Parent ID (Nullable)
	var parent_id: String
	## Consumed (Nullable)
	var consumed: bool
	## Deleted (Nullable)
	var deleted: bool
	## Gift code batch ID (Nullable)
	var gift_code_batch_id: String
	static func decode(dict: Dictionary) -> DiscordEntitlement:
		var data := DiscordEntitlement.new()
		DiscordSDK._decode_simple(dict, data)
		return data
#endregion


#region Command response types (https://discord.com/developers/docs/developer-tools/embedded-app-sdk#sdk-commands)
## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#authenticateresponse
class CommandAuthenticateResponse:
	## Access token
	var access_token: String
	## User
	var user: DiscordUser
	## Scopes
	var scopes: Array[String] = []
	## Expires
	var expires: String
	## Application
	var application: DiscordApplication
	static func decode(dict: Dictionary) -> CommandAuthenticateResponse:
		var data := CommandAuthenticateResponse.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("user") != null:
			data.user = DiscordUser.decode(dict["user"])
		if dict.get("application") != null:
			data.application = DiscordApplication.decode(dict["application"])
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#authorizeresponse
class CommandAuthorizeResponse:
	## Authorization code
	var code: String
	static func decode(dict: Dictionary) -> CommandAuthorizeResponse:
		var data := CommandAuthorizeResponse.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#encouragehardwareaccelerationresponse
class CommandEncourageHardwareAccelerationResponse:
	var enabled: bool
	static func decode(dict: Dictionary) -> CommandEncourageHardwareAccelerationResponse:
		var data := CommandEncourageHardwareAccelerationResponse.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#getchannelpermissionsresponse
class CommandGetChannelPermissionsResponse:
	## Permissions (BigInt string)
	var permissions: String
	static func decode(dict: Dictionary) -> CommandGetChannelPermissionsResponse:
		var data := CommandGetChannelPermissionsResponse.new()
		data.permissions = str(dict["permissions"])
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#getinstanceconnectedparticipantsresponse
class CommandGetInstanceConnectedParticipantsResponse:
	var participants: Array[DiscordUser]
	static func decode(dict: Dictionary) -> CommandGetInstanceConnectedParticipantsResponse:
		var data := CommandGetInstanceConnectedParticipantsResponse.new()
		if dict.get("participants") != null:
			data.participants = []
			for participant in dict["participants"]:
				data.participants.push_back(DiscordUser.decode(participant))
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#getplatformbehaviorsresponse
class CommandGetPlatformBehaviorsResponse:
	## IOS keyboard resizes view 
	var ios_keyboard_resizes_view: bool
	static func decode(dict: Dictionary) -> CommandGetPlatformBehaviorsResponse:
		var data := CommandGetPlatformBehaviorsResponse.new()
		data.ios_keyboard_resizes_view = dict["iosKeyboardResizesView"]
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#getrelationshipsresponse
class CommandGetRelationshipsResponse:
	var relationships: Array[DiscordRelationship]
	static func decode(dict: Dictionary) -> CommandGetRelationshipsResponse:
		var data := CommandGetRelationshipsResponse.new()
		if dict.get("relationships") != null:
			data.relationships = []
			for relationship in dict["relationships"]:
				data.relationships.push_back(DiscordRelationship.decode(relationship))
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#getskusresponse
class CommandGetSkusResponse:
	var skus: Array[DiscordSku]
	static func decode(dict: Dictionary) -> CommandGetSkusResponse:
		var data := CommandGetSkusResponse.new()
		if dict.get("skus") != null:
			data.skus = []
			for sku in dict["skus"]:
				data.skus.push_back(DiscordSku.decode(sku))
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#initiateimageuploadresponse
class CommandInitiateImageUploadResponse:
	## Image URL
	var image_url: String
	static func decode(dict: Dictionary) -> CommandInitiateImageUploadResponse:
		var data := CommandInitiateImageUploadResponse.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#openexternallinkresponse
class CommandOpenExternalLinkResponse:
	## Opened (Nullable)
	var opened: bool
	static func decode(dict: Dictionary) -> CommandOpenExternalLinkResponse:
		var data := CommandOpenExternalLinkResponse.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#sharelinkresponse
class CommandShareLinkResponse:
	## Success
	var success: bool
	static func decode(dict: Dictionary) -> CommandShareLinkResponse:
		var data := CommandShareLinkResponse.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#usersettingsgetlocaleresponse
class CommandUserSettingsGetLocaleResponse:
	## Locale
	var locale: String
	static func decode(dict: Dictionary) -> CommandUserSettingsGetLocaleResponse:
		var data := CommandUserSettingsGetLocaleResponse.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#setconfigresponse
class CommandSetConfigResponse:
	## Use interactive PIP
	var use_interactive_pip: bool
	static func decode(dict: Dictionary) -> CommandSetConfigResponse:
		var data := CommandSetConfigResponse.new()
		DiscordSDK._decode_simple(dict, data)
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#getchannelresponse
class CommandGetChannelResponse:
	## ID
	var id: String
	## Channel type
	var type: DiscordChannelTypes
	## Guild ID (Nullable)
	var guild_id: String
	## Name (Nullable)
	var name: String
	## Topic (Nullable)
	var topic: String
	## Bitrate (Nullable)
	var bitrate: int
	## User limit (Nullable)
	var user_limit: int
	## Position (Nullable)
	var position: int
	## Voice states
	var voice_states: Array[DiscordUserVoiceState]
	## Messages
	var messages: Array[DiscordMessage]
	static func decode(dict: Dictionary) -> CommandGetChannelResponse:
		var data := CommandGetChannelResponse.new()
		DiscordSDK._decode_simple(dict, data)
		if dict.get("voice_states") != null:
			data.voice_states = []
			for state in dict["voice_states"]:
				data.voice_states.push_back(DiscordUserVoiceState.decode(state))
		if dict.get("messages") != null:
			data.messages = []
			for message in dict["messages"]:
				data.messages.push_back(DiscordMessage.decode(message))
		return data

## https://discord.com/developers/docs/developer-tools/embedded-app-sdk#getentitlementsresponse
class CommandGetEntitlements:
	var entitlements: Array[DiscordEntitlement]
	static func decode(dict: Dictionary) -> CommandGetEntitlements:
		var data := CommandGetEntitlements.new()
		if dict.get("entitlements") != null:
			data.entitlements = []
			for entitlement in dict["entitlements"]:
				data.entitlements.push_back(DiscordEntitlement.decode(entitlement))
		return data
#endregion


## Automatically decodes anything that isn't a class
static func _decode_simple(dict: Dictionary, target: Object) -> void:
	if dict == null:
		return
	for key in dict.keys():
		var value = dict[key]
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
	match event:
		"READY":
			is_ready = true
			var event_data := ReadyEventData.decode(data["data"])
			dispatch_any.emit(event, event_data)
			dispatch_ready.emit(event_data)
		"ERROR":
			var event_data := ErrorEventData.decode(data["data"])
			dispatch_any.emit(event, event_data)
			dispatch_error.emit(event_data)
		"VOICE_STATE_UPDATE":
			var event_data := VoiceStateUpdateData.decode(data["data"])
			dispatch_any.emit(event, event_data)
			dispatch_voice_state_update.emit(event_data)
		"SPEAKING_START":
			var event_data := SpeakingEventData.decode(data["data"])
			dispatch_any.emit(event, event_data)
			dispatch_speaking_start.emit(event_data)
		"SPEAKING_STOP":
			var event_data := SpeakingEventData.decode(data["data"])
			dispatch_any.emit(event, event_data)
			dispatch_speaking_stop.emit(event_data)
		"ACTIVITY_LAYOUT_MODE_UPDATE":
			var event_data := ActivityLayoutModeUpdateData.decode(data["data"])
			dispatch_any.emit(event, event_data)
			dispatch_activity_layout_mode_update.emit(event_data)
		"ORIENTATION_UPDATE":
			var event_data := OrientationUpdateData.decode(data["data"])
			dispatch_any.emit(event, event_data)
			dispatch_orientation_update.emit(event_data)
		"CURRENT_USER_UPDATE":
			user_id = data["data"]["id"]
			var event_data := CurrentUserUpdateData.decode(data["data"])
			dispatch_any.emit(event, event_data)
			dispatch_current_user_update.emit(event_data)
		"THERMAL_STATE_UPDATE":
			var event_data := ThermalStateUpdateData.decode(data["data"])
			dispatch_any.emit(event, event_data)
			dispatch_thermal_state_update.emit(event_data)
		"ACTIVITY_INSTANCE_PARTICIPANTS_UPDATE":
			var event_data := ParticipantsUpdateData.decode(data["data"])
			dispatch_any.emit(event, event_data)
			dispatch_activity_instance_participants_update.emit(event_data)
		"ENTITLEMENT_CREATE":
			dispatch_any.emit(event, data["data"] as Dictionary)
			dispatch_entitlement_create.emit(data["data"] as Dictionary)
		"CURRENT_GUILD_MEMBER_UPDATE":
			var event_data := CurrentGuildMemberUpdateData.decode(data["data"])
			dispatch_any.emit(event, event_data)
			dispatch_current_guild_member_update.emit(event_data)
		_:
			dispatch_any.emit(event, data["data"])
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

func sendMessage(opcode: int, body: Dictionary):
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

func sendCommand(cmd: String, args: Dictionary, nonce: String):
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

func command_authorize(response_type: String, scopes: Array, state: String) -> CommandAuthorizeResponse:
	var nonce := _gen_nonce()
	sendCommand("AUTHORIZE", {
		"client_id": client_id,
		"prompt": "none",
		"response_type": response_type,
		"scope": scopes,
		"state": state
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandAuthorizeResponse.decode(packet)

func command_authenticate(access_token: String) -> CommandAuthenticateResponse:
	var nonce := _gen_nonce()
	sendCommand("AUTHENTICATE", {
		"access_token": access_token
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandAuthenticateResponse.decode(packet)

func command_capture_log(level: String, message: String) -> void:
	var nonce := _gen_nonce()
	sendCommand("CAPTURE_LOG", {
		"level": level,
		"message": message
	}, nonce)
	await _wait_for_nonce(nonce)

func command_encourage_hardware_acceleration() -> CommandEncourageHardwareAccelerationResponse:
	var nonce := _gen_nonce()
	sendCommand("ENCOURAGE_HW_ACCELERATION", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandEncourageHardwareAccelerationResponse.decode(packet)

func command_get_channel(id: String) -> CommandGetChannelResponse:
	var nonce := _gen_nonce()
	sendCommand("GET_CHANNEL", {
		"channel_id": id
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandGetChannelResponse.decode(packet)


func command_get_channel_permissions() -> CommandGetChannelPermissionsResponse:
	var nonce := _gen_nonce()
	sendCommand("GET_CHANNEL_PERMISSIONS", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandGetChannelPermissionsResponse.decode(packet)


func command_get_entitlements_embedded() -> CommandGetEntitlements:
	var nonce := _gen_nonce()
	sendCommand("GET_ENTITLEMENTS_EMBEDDED", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandGetEntitlements.decode(packet)


func command_get_instance_connected_participants() -> CommandGetInstanceConnectedParticipantsResponse:
	var nonce := _gen_nonce()
	sendCommand("GET_ACTIVITY_INSTANCE_CONNECTED_PARTICIPANTS", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandGetInstanceConnectedParticipantsResponse.decode(packet)


func command_get_platform_behaviors() -> CommandGetPlatformBehaviorsResponse:
	var nonce := _gen_nonce()
	sendCommand("GET_PLATFORM_BEHAVIORS", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandGetPlatformBehaviorsResponse.decode(packet)


func command_get_skus() -> CommandGetSkusResponse:
	var nonce := _gen_nonce()
	sendCommand("GET_SKUS_EMBEDDED", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandGetSkusResponse.decode(packet)


func command_initiate_image_upload() -> CommandInitiateImageUploadResponse:
	var nonce := _gen_nonce()
	sendCommand("INITIATE_IMAGE_UPLOAD", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandInitiateImageUploadResponse.decode(packet)


func command_open_external_link(url: String) -> CommandOpenExternalLinkResponse:
	var nonce := _gen_nonce()
	sendCommand("OPEN_EXTERNAL_LINK", {
		"url": url
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandOpenExternalLinkResponse.decode(packet)


func command_open_invite_dialog() -> void:
	var nonce := _gen_nonce()
	sendCommand("OPEN_INVITE_DIALOG", {}, nonce)
	await _wait_for_nonce(nonce)


func command_open_share_moment_dialog(media_url: String) -> void:
	var nonce := _gen_nonce()
	sendCommand("OPEN_SHARE_MOMENT_DIALOG", {
		"mediaUrl": media_url
	}, nonce)
	await _wait_for_nonce(nonce)

func command_set_activity(state: String, details: String, timestamps: Dictionary = {}, assets: Dictionary = {}, party: Dictionary = {}, secrets: Dictionary = {}, instance: bool = false) -> DiscordActivity:
	var nonce := _gen_nonce()
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
	return DiscordActivity.decode(packet)


func command_set_config(use_interactive_pip: bool) -> CommandSetConfigResponse:
	var nonce := _gen_nonce()
	sendCommand("SET_CONFIG", {
		"use_interactive_pip": use_interactive_pip
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandSetConfigResponse.decode(packet)


func command_set_orientation_lock_state(lock_state: DiscordOrientationLockStateType, pip_lock_state: DiscordOrientationLockStateType, grid_lock_state: DiscordOrientationLockStateType) -> void:
	var nonce := _gen_nonce()
	sendCommand("SET_ORIENTATION_LOCK_STATE", {
		"lock_state": lock_state,
		"pip_lock_state": pip_lock_state,
		"grid_lock_state": grid_lock_state
	}, nonce)
	await _wait_for_nonce(nonce)

## Returns either null or [DiscordEntitlement]
func command_start_purchase(sku_id: String, pid: int) -> DiscordEntitlement:
	var nonce := _gen_nonce()
	sendCommand("START_PURCHASE", {
		"sku_id": sku_id,
		"pid": pid
	}, nonce)

	var packet = await _wait_for_nonce(nonce)
	if packet == null:
		return null
	return DiscordEntitlement.decode(packet)


func command_user_settings_get_locale() -> CommandUserSettingsGetLocaleResponse:
	var nonce := _gen_nonce()
	sendCommand("USER_SETTINGS_GET_LOCALE", {}, nonce)

	var packet = await _wait_for_nonce(nonce)
	return CommandUserSettingsGetLocaleResponse.decode(packet)


func command_share_link(message: String, referrer_id: String, custom_id: String) -> CommandShareLinkResponse:
	var nonce := _gen_nonce()
	sendCommand("SHARE_LINK", {
		"referrer_id": referrer_id,
		"custom_id": custom_id,
		"message": message
	}, nonce)
	
	var packet = await _wait_for_nonce(nonce)
	return CommandShareLinkResponse.decode(packet)
