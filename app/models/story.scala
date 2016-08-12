package models

case class Story(epic: String,
                 storyType: String,
                 storyName: String,
                 anchor: String,
                 floater: String,
                 active: Boolean,
                 resolved: Boolean)
object storyJsonFormats {
 import play.api.libs.json.Json

 // Generates Writes and Reads for Feed and User thanks to Json Macros
 implicit val userFormat = Json.format[User]
 implicit val storyFormat = Json.format[Story]
}
