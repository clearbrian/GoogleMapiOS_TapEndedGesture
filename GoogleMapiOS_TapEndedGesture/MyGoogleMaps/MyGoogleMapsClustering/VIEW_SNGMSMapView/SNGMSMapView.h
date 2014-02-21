//
//  SNGMSMapView.h
//  MyGoogleMapsClustering
//
//  Created by Brian Clear (gbxc) on 21/02/2014.
//  Copyright (c) 2014 Brian Clear (gbxc). All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#pragma mark -
#pragma mark SNGMSMapViewDelegate
#pragma mark -
@class SNGMSMapView;
@protocol SNGMSMapViewDelegate <NSObject>

@optional

//triggered when map comes to a halt
//Though I noticed that this can happen when finger still on the map
//and any redrawing on the map may stutter
//so use gestureHandler and check for UIGestureRecognizerStateEnded - this is when user had lifted their finger/ended the pan

//GMSMapView >> GMSMapViewDelegate >> idleAtCameraPosition:
- (void)snGMSMapView:(SNGMSMapView *)snGMSMapView idleAtCameraPosition:(GMSCameraPosition *)position;


//so use gestureHandler and check for UIGestureRecognizerStateEnded - this is when user had lifted their finger/ended the pan
//SNGMSMapView >> UIPanGestureRecognizer >> panGestureHandler
- (void)snGMSMapView:(SNGMSMapView *)snGMSMapView  panGestureHandler:(UIPanGestureRecognizer *)recognizer;
@end




#pragma mark -
#pragma mark SNGMSMapView
#pragma mark -

@interface SNGMSMapView : GMSMapView

//cant call it delegate as GMSMapView.delegate exists
@property (nonatomic, weak) id<SNGMSMapViewDelegate> snGMSMapViewDelegate;
@end
