
class StoryCtrl

    constructor: (@$log, @StoryService) ->
        @$log.debug "constructing StoryController"
        @stories = []
        @getAllStories()

    getAllStories: () ->
        @$log.debug "getAllStories()"

        @StoryService.listStories()
        .then(
            (data) =>
                @$log.debug "Promise returned #{data.length} Stories"
                @stories = data
            ,
            (error) =>
                @$log.error "Unable to get Stories: #{error}"
            )

controllersModule.controller('StoryCtrl', ['$log', 'StoryService', StoryCtrl])
