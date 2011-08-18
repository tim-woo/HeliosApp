//
//  HeliosAppViewController.h
//  HeliosApp
//
//  Created by Tim Woo on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSwitchesSegmentAbout      0
#define kSwitchesSegmentTech       1
#define kSwitchesSegmentProjects   2

@interface HeliosAppViewController : UIViewController <UIScrollViewDelegate>
{
    BOOL pageControlUsed;
    UISegmentedControl *segmentedControl;
    NSArray *aboutList;
    NSMutableArray *imageViewsAbout;
    NSMutableArray *imageViewsTech;
    NSMutableArray *imageViewsProjects;
    
    UIButton *home1;
    UIButton *home2;
    UIButton *home3;
    
    UIImageView *image1;
    UIImageView *image2;
    BOOL transitioning;
}

@property (nonatomic, retain) NSArray *aboutList;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UIScrollView *parentScrollView;
@property (nonatomic, retain) UIScrollView *childScrollViewOne;
@property (nonatomic, retain) UIScrollView *childScrollViewTwo;
@property (nonatomic, retain) UIScrollView *childScrollViewThree;
@property (nonatomic, retain) UIPageControl *pageControlOne;
@property (nonatomic, retain) UIPageControl *pageControlTwo;
@property (nonatomic, retain) UIPageControl *pageControlThree;
@property (nonatomic, retain) NSMutableArray *imageViewsAbout;
@property (nonatomic, retain) NSMutableArray *imageViewsTech;
@property (nonatomic, retain) NSMutableArray *imageViewsProjects;
@property (nonatomic, retain) UIButton *home1;
@property (nonatomic, retain) UIButton *home2;
@property (nonatomic, retain) UIButton *home3;



- (IBAction)toggleSwitch:(id) sender;
- (IBAction)nextTransition:(id)sender;
@end
