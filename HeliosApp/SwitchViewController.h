//
//  SwitchViewController.h
//  HeliosApp
//
//  Created by Tim Woo on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeliosAppViewController;
@class GridViewController;

@interface SwitchViewController : UIViewController
{
    HeliosAppViewController *heliosAppViewController;
    GridViewController      *gridViewController;
    UISegmentedControl *segmentedControl;
    BOOL                      transitioning;
}

@property (retain, nonatomic) HeliosAppViewController *heliosAppViewController;
@property (retain, nonatomic) GridViewController *gridViewController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)switchViews:(id)sender;

@end
