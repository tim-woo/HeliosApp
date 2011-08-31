//
//  SwitchViewController.h
//  HeliosApp
//
//  Created by Tim Woo on 8/12/11.
//  Copyright 2011 Helios Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeliosViewController;
@class GridViewController;

@interface SwitchViewController : UIViewController
{
    HeliosViewController *heliosAppViewController;
    GridViewController      *gridViewController;
    UISegmentedControl *segmentedControl;
    BOOL                      transitioning;
}

@property (retain, nonatomic) HeliosViewController *heliosAppViewController;
@property (retain, nonatomic) GridViewController *gridViewController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)switchViews:(id)sender;

@end
