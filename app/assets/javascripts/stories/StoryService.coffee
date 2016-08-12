
class StoryService

    @headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
    @defaultConfig = { headers: @headers }

    constructor: (@$log, @$http, @$q) ->
        @$log.debug "constructing StoryService"

    listStories: () ->
        @$log.debug "listStories()"
        deferred = @$q.defer()

        @$http.get("/stories")
        .success((data, status, headers) =>
                @$log.info("Successfully listed Stories - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to list Stories - status #{status}")
                deferred.reject(data)
            )
        deferred.promise

    createStory: (story) ->
        @$log.debug "createStory #{angular.toJson(story, true)}"
        deferred = @$q.defer()

        @$http.post('/story', story)
        .success((data, status, headers) =>
                @$log.info("Successfully created Story - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to create story - status #{status}")
                deferred.reject(data)
            )
        deferred.promise

    updateStory: (firstName, lastName, story) ->
      @$log.debug "updateStory #{angular.toJson(story, true)}"
      deferred = @$q.defer()

      @$http.put("/story/#{firstName}/#{lastName}", story)
      .success((data, status, headers) =>
              @$log.info("Successfully updated Story - status #{status}")
              deferred.resolve(data)
            )
      .error((data, status, header) =>
              @$log.error("Failed to update story - status #{status}")
              deferred.reject(data)
            )
      deferred.promise

servicesModule.service('StoryService', ['$log', '$http', '$q', StoryService])
