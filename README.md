GoogleMapiOS_TapEndedGesture
============================

Better Tap End Recognizer for Google Maps for iOS SDK
-----------------------------------------------------

```sh
As of Google SDK for iOS 1.7:
```

To track when user has ended a tap the only method in the sdk was idleAtCameraPosition.
I was using this to trigger a 1 second timer to recalc clusters.
When timer fired I iterated over a tree of markers and calculated which where visible and clustered them.

But I noticed that idleAtCameraPosition was being triggered even when finger still on the device 
so cluster redraw happening too early and caused stuttering.

Also if you swipe the map with a large swipe and let go.
The idleAtCameraPosition is called till map stops panning even though finger let go.


* So I subclass GSMMapView > SNGSMapView
* Added a PanGesture Recognizer
* If State = ENDED then call delegate
* In View Controller in delegate I fire 0.5 sec timer
* When fired I then redraw the clusters.
* I use a timer so that clustering isnt triggered if user ends tap suddenly.

Code sample doesnt include clustering its just to show a Pan gesture on top of GSMMapView
And a better way to track when tap ended.


Known issue:
------------
* if you do a large swipe and let go the pan gestire >> ENDED is called
* but actual projection of the map isnt correct till idleAtCameraPosition finishes.
* So if youre calculating clusters this may be an issue.
* But would have to be a huge swipe for this to be an issue.

* You can also still use idleAtCameraPosition to store camera. position/zoom
* When 1 sec timer fires on Pan Gesture map may have stopped moving.




TIP: shouldRecognizeSimultaneouslyWithGestureRecognizer should return YES
Default is no and if left at NO the GSMMapView gets the Pan Gesture and our subclass handler is never triggered

```sh
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    //default is no - if we dont set it to on then gesture is captured by GMSMapView and myGestureHandler never called
    return YES;
}
```
