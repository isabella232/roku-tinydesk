'
' The video search screen.
'

function SearchScreen() as Object

    ' Member vars
    this = {}

    this._port = createObject("roMessagePort")
    
    ' Member functions
    this.search = SearchScreen_search
    this._getSuggestions = _SearchScreen_getSuggestions
    this._getMatches = _SearchScreen_getMatches

    return this

end function

function SearchScreen_search(feed)

    this = m

    this._feed = feed

    this._screen = createObject("roSearchScreen")

    this._screen.setMessagePort(this._port) 
    this._screen.setBreadcrumbText("", "Search")
    this._screen.setSearchTermHeaderText("Suggestions:")
    this._screen.setSearchButtonText("search")
    this._screen.setClearButtonEnabled(false)
    
    this._screen.Show() 

    searchString = invalid

    while true 
        msg = wait(0, this._screen.GetMessagePort()) 

        if type(msg) = "roSearchScreenEvent"
            if msg.isScreenClosed()
                exit while
            else if msg.isCleared()
                history.Clear()
            else if msg.isPartialResult()
                searchString = msg.GetMessage()
                this._screen.SetSearchTerms(this._getSuggestions(searchString))
            else if msg.isFullResult()
                searchString = msg.GetMessage()

                exit while
            endif
        endif
    endwhile 

    this._screen.Close()

    return this._getMatches(searchString)

end function

' Get a list of suggestions for a given search string
function _SearchScreen_getSuggestions(searchString)

    this = m

    lSearchString = LCase(searchString)
    suggestions = []

    for each feedItem in this._feed
        if instr(LCase(feedItem.title), lSearchString) > 0 then
            suggestions.Push(feedItem.title)
        end if
    end for

    return suggestions

end function

' Get a list of matches for a given search string
Function _SearchScreen_getMatches(searchString)

    this = m

    if searchString = invalid or searchString = "" then
        return []
    end if

    lSearchString = LCase(searchString)
    matches = []

    for each feedItem in this._feed
        if instr(LCase(feedItem.title), lSearchString) > 0 then
            matches.Push(feedItem)
        end if
    end for

    return matches 


End Function
