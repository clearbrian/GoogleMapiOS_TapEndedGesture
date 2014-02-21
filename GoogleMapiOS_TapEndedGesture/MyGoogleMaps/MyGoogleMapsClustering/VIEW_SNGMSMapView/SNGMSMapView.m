//
//  SNGMSMapView.m
//  MyGoogleMapsClustering
//
//  Created by Brian Clear (gbxc) on 21/02/2014.
//  Copyright (c) 2014 Brian Clear (gbxc). All rights reserved.
//

#import "SNGMSMapView.h"


@interface SNGMSMapView()<UIGestureRecognizerDelegate,GMSMapViewDelegate>{
    BOOL _debugOn;
}
@property (nonatomic, retain) UIPanGestureRecognizer *panGestureRecognizer;
@end

/*
 I used this Google Maps delegte method idleAtCameraPosition: to calculate when to redraw clusters
 I noticed idleAtCameraPosition was being called even when finger was still on the map
 And this caused stuttering
 
 So I created this subclass that added a PanGestureRecognizer over the map
 When UIGestureRecognizerStateEnded then draw clusters
 
 */
@implementation SNGMSMapView


//if view called in code
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}
//if view used in XIB or Storyboard
- (void)awakeFromNib
{
    
    if(_debugOn)NSLog(@"%s ", __PRETTY_FUNCTION__);
    
    [self setupView];
    
}
//called from initWithFrame or awakeFromNib so class can be used in IB or in code
-(void)setupView{
    //turn on for full debugging
    _debugOn = TRUE;
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    //GMSMapViewDelegate
    //super class GMSMapView.delegate
    self.delegate = self;
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate
#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    //default is no - if we dont set it to on then gesture is captured by GMSMapView and myGestureHandler never called
    return YES;
}

#pragma mark -
#pragma mark UIPanGestureRecognizer handler
#pragma mark -
-(void)panGestureHandler:(UIPanGestureRecognizer *)recognizer {
    
    //    UIGestureRecognizerStatePossible,
    //          the recognizer has not yet recognized its gesture, but may be evaluating touch events. this is the default state
    //
    //    UIGestureRecognizerStateBegan,
    //          the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop
    //    UIGestureRecognizerStateChanged,
    //          the recognizer has received touches recognized as a change to the gesture. the action method will be called at the next turn of the run loop
    //    UIGestureRecognizerStateEnded,
    //          the recognizer has received touches recognized as the end of the gesture.
    //            the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible
    //    UIGestureRecognizerStateCancelled,
    //          the recognizer has received touches resulting in the cancellation of the gesture.
    //            the action method will be called at the next turn of the run loop. the recognizer will be reset to UIGestureRecognizerStatePossible
    //
    //    UIGestureRecognizerStateFailed
    
    
    
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
    
    //-----------------------------------------------------------------------------------
    //just pass state back in the delegate let ViewController decide what to do with it
    if(self.snGMSMapViewDelegate){
        if([self.snGMSMapViewDelegate respondsToSelector:@selector(snGMSMapView:panGestureHandler:)])
        {
            
            [self.snGMSMapViewDelegate snGMSMapView:self panGestureHandler:recognizer];
            
        }else {
            NSLog(@"ERROR:<%@ %@:(%d)> %s delegate[%@] doesnt implement snGMSMapView:panGestureHandler:", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__ ,self.delegate);
        }
    }else{
        NSLog(@"ERROR:<%@ %@:(%d)> %s self.delegate is nil - ADD:  self.mapView.snGMSMapViewDelegate = self;", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__);
    }
    //-----------------------------------------------------------------------------------

}



#pragma mark -
#pragma mark GMSMapViewDelegate
#pragma mark -
//called by GMSMapView when map stops moving.
//I noticed that this isnt always the same time as when you lift your finger
//finger can also be still on the map when this is triggered thus any drawing code can be called too early and cause stuttering
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    if(_debugOn)NSLog(@"%s ", __PRETTY_FUNCTION__);
    
    //-----------------------------------------------------------------------------------
    //just pass back in a delegate - let vc use it
    //though for this problem -(IBAction)gestureHandler:(UIPanGestureRecognizer *)recognizer
    // is more accurate
    
    if(self.snGMSMapViewDelegate){
        if([self.snGMSMapViewDelegate respondsToSelector:@selector(snGMSMapView:idleAtCameraPosition:)]){
            
            [self.snGMSMapViewDelegate snGMSMapView:self idleAtCameraPosition:position];
            
        }else {
            NSLog(@"ERROR:<%@ %@:(%d)> %s delegate[%@] doesnt implement snGMSMapView:idleAtCameraPosition:", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__ ,self.delegate);
        }
    }else{
        NSLog(@"ERROR:<%@ %@:(%d)> %s self.delegate is nil - ADD:  self.mapView.snGMSMapViewDelegate = self;", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__);
    }
    //-----------------------------------------------------------------------------------
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
