class UpdateStoryCtrl

  constructor: (@$log, @$location, @$routeParams, @StoryService) ->
      @$log.debug "constructing UpdateStoryController"
      @Story = {}
      @findStories()

  updateStory: () ->
      @$log.debug "updateStory()"
      # @Story.active = true
      @StoryService.updateStory(@$routeParams.storyName,  @Story)
      .then(
          (data) =>
            @$log.debug "Promise returned #{data} Story"
            @Story = data
            @$location.path("/")
        ,
        (error) =>
            @$log.error "Unable to update Story: #{error}"
      )

  findStories: () ->
      # route params must be same name as provided in routing url in app.coffee
      storyName = @$routeParams.storyName
      @$log.debug "findStories route params: #{storyName}"

      @StoryService.listStories()
      .then(
        (data) =>
          @$log.debug "Promise returned #{data.length} Stories"

          # find a Story with the name of firstName and lastName
          # as filter returns an array, get the first object in it, and return it
          @Story = (data.filter (Story) -> Story.storyName is storyName)[0]
      ,
        (error) =>
          @$log.error "Unable to get Stories: #{error}"
      )

controllersModule.controller('UpdateStoryCtrl', ['$log', '$location', '$routeParams', 'StoryService', UpdateStoryCtrl])
