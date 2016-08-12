class UpdateStoryCtrl

  constructor: (@$log, @$location, @$routeParams, @StoryService) ->
      @$log.debug "constructing UpdateStoryController"
      @story = {}
      @findStory()

  updateStory: () ->
      @$log.debug "updateStory()"
      # @story.active = true
      @StoryService.updateStory(@$routeParams.storyName, @story)
      .then(
          (data) =>
            @$log.debug "Promise returned #{data} Story"
            @story = data
            @$location.path("/")
        ,
        (error) =>
            @$log.error "Unable to update Story: #{error}"
      )

  findStory: () ->
      # route params must be same name as provided in routing url in app.coffee
      storyName = @$routeParams.storyName
      @$log.debug "findStory route params: #{storyName}"

      @StoryService.listStories()
      .then(
        (data) =>
          @$log.debug "Promise returned #{data.length} Stories"

          # find a story with the name of storyName
          # as filter returns an array, get the first object in it, and return it
          @story = (data.filter (story) -> story.storyName is storyName)[0]
      ,
        (error) =>
          @$log.error "Unable to get Stories: #{error}"
      )

controllersModule.controller('UpdateStoryCtrl', ['$log', '$location', '$routeParams', 'StoryService', UpdateStoryCtrl])
