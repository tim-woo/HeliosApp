//
//  HeliosAppAppDelegate.h
//  HeliosApp
//
//  Created by Tim Woo on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class HeliosAppViewController;
@class SwitchViewController;

@interface HeliosAppAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

//@property (nonatomic, retain) IBOutlet HeliosAppViewController *viewController;
@property (nonatomic, retain) IBOutlet SwitchViewController *switchViewController;
@end
