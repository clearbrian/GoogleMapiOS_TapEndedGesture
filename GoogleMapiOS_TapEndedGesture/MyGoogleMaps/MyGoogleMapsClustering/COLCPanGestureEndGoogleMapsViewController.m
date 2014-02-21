//
//  COLCSecondViewController.m
//  MyGoogleMapsClustering
//
//  Created by Brian Clear (gbxc) on 13/02/2014.
//  Copyright (c) 2014 Brian Clear (gbxc). All rights reserved.
//

#import "COLCPanGestureEndGoogleMapsViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SNGMSMapView.h"
@interface COLCPanGestureEndGoogleMapsViewController ()<SNGMSMapViewDelegate>{
    BOOL _debugOn;
    
    
}
@property (weak, nonatomic) IBOutlet SNGMSMapView *mapView;
@property (nonatomic, retain)  NSTimer *moveMapRedrawClustersTimer;
@end

@implementation COLCPanGestureEndGoogleMapsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _debugOn = TRUE;
    
    self.mapView.snGMSMapViewDelegate = self;
    
}

- (void)snGMSMapView:(SNGMSMapView *)snGMSMapView idleAtCameraPosition:(GMSCameraPosition *)position{
    if(_debugOn)NSLog(@"%s ", __PRETTY_FUNCTION__);
}


//so use gestureHandler and check for UIGestureRecognizerStateEnded - this is when user had lifted their finger/ended the pan
- (void)snGMSMapView:(SNGMSMapView *)snGMSMapView  panGestureHandler:(UIPanGestureRecognizer *)recognizer{
    if([recognizer state] == UIGestureRecognizerStatePossible)
    {
        if(_debugOn)NSLog(@"UIGestureRecognizerStatePossible");
    }
    else if([recognizer state] == UIGestureRecognizerStateBegan)
    {
        if(_debugOn)NSLog(@"UIGestureRecognizerStateBegan");
    }
    else if([recognizer state] == UIGestureRecognizerStateChanged)
    {
        if(_debugOn)NSLog(@"UIGestureRecognizerStateChanged");
    }
    else if([recognizer state] == UIGestureRecognizerStateEnded)
    {
        if(_debugOn)NSLog(@"UIGestureRecognizerStateEnded");
        
        //BEST PLACE TO TEST IF USER HAS LIFTED THEIR FINGER
        
        
        //-----------------------------------------------------------------------------------
        //wait one second before redrawing markers/overlays if case user has briefly lifted their finger
        //repeats:NO so no need to add code to invalidate it
        self.moveMapRedrawClustersTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                           target:self
                                                                         selector:@selector(timerFired:)
                                                                         userInfo:nil
                                                                          repeats:NO];
        
        //-----------------------------------------------------------------------------------
        
    }
    else if([recognizer state] == UIGestureRecognizerStateCancelled)
    {
        if(_debugOn)NSLog(@"UIGestureRecognizerStateCancelled");
    }
    else if([recognizer state] == UIGestureRecognizerStateFailed)
    {
        if(_debugOn)NSLog(@"UIGestureRecognizerStateFailed");
    }
    else{
        NSLog(@"ERROR:<%@ %@:(%d)> %s UNHANDLED STATE", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__);
    }
    
    
    
}

#pragma mark -
#pragma mark MAP STOPPED MOVING - REDRAW VISIBLE CLUSTERS
#pragma mark -

- (void)timerFired:(NSTimer*)theTimer {
    
    //USER HAS LIFTED THEIR FINGER and time period has passed so safe to redraw markers on the map
    
    //Good place to do calculations for
    //- Iterate over all markers find visible ones based on map Projection/zoom etc
    //- clustering of markers based on zoom
    
    //-----------------------------------------------------------------------------------

    //NOTE: this is different from idleAtCameraPosition which as on SDK 1.7 could be triggered even when finger still touching the device.
    //And if you swipe the map and let go. panGestureHandler>>ENDED is triggered when you let go.
    //But idleAtCameraPosition only triggered when swipe slows down and ends
    //-----------------------------------------------------------------------------------

    //Known issue - camera position/map projection is not correct till swipe ends and idleAtCameraPosition called
    //but would have to be a huge swipe for the position to be way off even on an iPad.
    //-----------------------------------------------------------------------------------

    //SPEED IMPROVEMENT: when you start a move, clear the map can make moving easier.
    //if user moves and zooms and you have lots of overlays/markers then I've noticed a delay so definately need to clear map first
    //you can do this
    /*
     self.mapView.delegate = self;
     
    - (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
        [self.mapView clear];
    }
    */
    
    //-----------------------------------------------------------------------------------

    
    if(_debugOn)NSLog(@"%s REDRAW YOUR CLUSTERS/OVERLAYS/MARKERS HERE", __PRETTY_FUNCTION__);

  
}



- (void)viewDidDisappear:(BOOL)animated {

    [self.moveMapRedrawClustersTimer invalidate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.moveMapRedrawClustersTimer invalidate];
}

@end
