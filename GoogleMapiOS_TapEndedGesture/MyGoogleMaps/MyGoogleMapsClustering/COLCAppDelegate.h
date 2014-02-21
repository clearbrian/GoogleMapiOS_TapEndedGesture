//
//  COLCAppDelegate.h
//  MyGoogleMapsClustering
//
//  Created by Brian Clear (gbxc) on 13/02/2014.
//  Copyright (c) 2014 Brian Clear (gbxc). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
/*
 Obtaining an API Key
 MUST MAP THE BUNDLE ID!!!!!!!!!!!!!!!!!!! so copying it from another project WONT WORK
 Edit allowed iOS apps...
 add this bundle id
 
 You can obtain a key for your app in the Google APIs Console.
 
 Create an API project in the Google APIs Console.
 Select the Services pane in your API project, and enable the Google Maps SDK for iOS. This displays the Google Maps Terms of Service.
 Select the API Access pane in the console, and click Create new iOS key.
 Enter one or more bundle identifiers as listed in your application's .plist file, such as com.example.myapp.
 Click Create.
 In the API Access page, locate the section Key for iOS apps (with bundle identifiers) and note or copy the 40-character API key.
 */

#warning INSERT GOOGLE API KEY HERE
const static NSString *APIKey = @"INSERT_KEY_HERE";


@interface COLCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
