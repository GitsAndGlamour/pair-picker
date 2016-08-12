package controllers

import play.modules.reactivemongo.MongoController
import play.modules.reactivemongo.json.collection.JSONCollection
import scala.concurrent.Future
import reactivemongo.api.Cursor
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import org.slf4j.{LoggerFactory, Logger}
import javax.inject.Singleton
import play.api.mvc._
import play.api.libs.json._

/**
 * The Stories controllers encapsulates the Rest endpoints and the interaction with the MongoDB, via ReactiveMongo
 * play plugin. This provides a non-blocking driver for mongoDB as well as some useful additions for handling JSon.
 * @see https://github.com/ReactiveMongo/Play-ReactiveMongo
 */
@Singleton
class Stories extends Controller with MongoController {

  private final val storyLogger: Logger = LoggerFactory.getLogger(classOf[Stories])

  /*
   * Get a JSONCollection (a Collection implementation that is designed to work
   * with JsObject, Reads and Writes.)
   * Note that the `collection` is not a `val`, but a `def`. We do _not_ store
   * the collection reference to avoid potential problems in development with
   * Play hot-reloading.
   */
  def collection: JSONCollection = db.collection[JSONCollection]("stories")

  // ------------------------------------------ //
  // Using case classes + Json Writes and Reads //
  // ------------------------------------------ //

  import models._
  import models.storyJsonFormats._

  def createStory = Action.async(parse.json) {
    request =>
    /*
     * request.body is a JsValue.
     * There is an implicit Writes that turns this JsValue as a JsObject,
     * so you can call insert() with this JsValue.
     * (insert() takes a JsObject as parameter, or anything that can be
     * turned into a JsObject using a Writes.)
     */
      request.body.validate[Story].map {
        story =>
        // `story` is an instance of the case class `models.Story`
          collection.insert(story).map {
            lastError =>
              storyLogger.debug(s"Successfully inserted with LastError: $lastError")
              Created(s"Story Created")
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }

  def updateStory(storyName: String) = Action.async(parse.json) {
    request =>
      request.body.validate[Story].map {
        story =>
          // find our story by first name and last name
          val storyNameSelector = Json.obj("storyName" -> storyName)
          collection.update(storyNameSelector, story).map {
            lastError =>
              storyLogger.debug(s"Successfully updated with LastError: $lastError")
              Created(s"Story Updated")
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }

  def findStories = Action.async {
    // let's do our query
    val cursor: Cursor[Story] = collection.
      // find all
      find(Json.obj()).
      // sort them by creation date
      sort(Json.obj("created" -> -1)).
      // perform the query and get a cursor of JsObject
      cursor[Story]

    // gather all the JsObjects in a list
    val futureStoriesList: Future[List[Story]] = cursor.collect[List]()

    // transform the list into a JsArray
    val futureStoriesJsonArray: Future[JsArray] = futureStoriesList.map { stories =>
      Json.arr(stories)
    }
    // everything's ok! Let's reply with the array
    futureStoriesJsonArray.map {
      stories =>
        Ok(stories(0))
    }
  }

}
