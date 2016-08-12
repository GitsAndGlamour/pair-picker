
class CreateStoryCtrl

    constructor: (@$log, @$location,  @StoryService) ->
        @$log.debug "constructing CreateStoryController"
        @story = {}

    createStory: () ->
        @$log.debug "createStory()"
        @story.active = true
        @story.anchor = "No anchor"
        @story.floater = "No floater"
        @StoryService.createStory(@story)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data} Story"
                @story = data
                @$location.path("/")
            ,
            (error) =>
                @$log.error "Unable to create Story: #{error}"
            )

controllersModule.controller('CreateStoryCtrl', ['$log', '$location', 'StoryService', CreateStoryCtrl])
