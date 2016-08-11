package models

case class User( id: String,
                 firstName: String,
                 lastName: String,
                 partnerName: String,
                 storyName: String,
                 anchor: Boolean,
                 active: Boolean)

object JsonFormats {
  import play.api.libs.json.Json

  // Generates Writes and Reads for Feed and User thanks to Json Macros
  implicit val userFormat = Json.format[User]
}
