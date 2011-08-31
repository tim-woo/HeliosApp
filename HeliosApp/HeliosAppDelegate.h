//
//  HeliosAppAppDelegate.h
//  HeliosApp
//
//  Created by Tim Woo on 8/10/11.
//  Copyright 2011 Helios Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeliosViewController;
@class SwitchViewController;

@interface HeliosAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet HeliosViewController *heliosViewController;
//@property (nonatomic, retain) IBOutlet SwitchViewController *switchViewController;
@end
