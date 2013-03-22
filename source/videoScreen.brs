' Play a video
Function showVideoScreen(feedItem As Object) as Boolean

    port = CreateObject("roMessagePort")
    screen = CreateObject("roVideoScreen")
    screen.SetMessagePort(port)

    watched = false

    position = loadPosition(feedItem)
    feedItem.PlayStart = position

    print "Video playback will begin at: " feedItem.PlayStart

    screen.SetPositionNotificationPeriod(1)
    screen.SetContent(feedItem)
    screen.Show()

    while true
        msg = wait(0, port)

        if type(msg) = "roVideoScreenEvent" then
            if msg.isScreenClosed()
                exit while
            else if msg.isRequestFailed()
                ' TODO
                print "Video request failure: "; msg.GetIndex(); " " msg.GetData()
            else if msg.isStatusMessage()
                ' TODO
                print "Video status: "; msg.GetIndex(); " " msg.GetData()
            else if msg.isFullResult()
                watched = True
                exit while
            else if msg.isPlaybackPosition() then
                position = msg.GetIndex()
                savePosition(feedItem, position)
            end if
        end if
    end while

    return watched

End Function

' Save playback position
Function savePosition(feedItem, position)

    RegWrite(feedItem.id + "_position", position.toStr(), "nproku")

End Function

' Load playback position
Function loadPosition(feedItem) as Integer

    position = RegRead(feedItem.Id + "_position", "nproku")
    
    if position = Invalid then
        return 0
    end if

    return position.toInt()

End Function
