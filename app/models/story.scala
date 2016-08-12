package models

case class Story(epic: String,
                 storyType: String,
                 points: Int,
                 storyName: String,
                 anchor: String,
                 floater: String,
                 active: Boolean,
                 resolved: Boolean)
object storyJsonFormats {
 import play.api.libs.json.Json

 // Generates Writes and Reads for Feed and Story thanks to Json Macros
 implicit val storyFormat = Json.format[Story]
}
