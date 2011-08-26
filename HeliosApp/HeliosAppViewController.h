//
//  HeliosAppViewController.h
//  HeliosApp
//
//  Created by Tim Woo on 8/10/11.
//  Copyright 2011 Helios Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EasyTableView.h"

#define kSwitchesSegmentAbout      0
#define kSwitchesSegmentTech       1
#define kSwitchesSegmentProjects   2
#define kSwitchesSegmentContact    3



@interface HeliosAppViewController : UIViewController <UIScrollViewDelegate, CLLocationManagerDelegate, EasyTableViewDelegate>
{    
    CLLocationManager *locationManager;
    CLLocation        *startingPoint;
    
    BOOL pageControlUsed;
    UISegmentedControl *segmentedControl;
    NSMutableArray *imageViewsAbout;
    NSMutableArray *imageViewsTech;
    NSMutableArray *imageViewsProjects;
    NSMutableArray *imageViewsContact;

    
    UIButton *home1;
    UIButton *home2;
    UIButton *home3;
    
    UIButton *arrow1;
    UIButton *arrow2;
    UIButton *arrow3;

//    UIImageView *image1;
//    UIImageView *image2;
    BOOL transitioning;
}

@property (nonatomic, retain) CLLocation  *startingPoint;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, retain) UIScrollView *parentScrollView;
@property (nonatomic, retain) UIScrollView *childScrollViewOne;
@property (nonatomic, retain) UIScrollView *childScrollViewTwo;
@property (nonatomic, retain) UIScrollView *childScrollViewThree;
@property (nonatomic, retain) UIScrollView *childScrollViewFour;
@property (nonatomic, retain) UIScrollView *projectsNavScrollView;
@property (nonatomic, retain) UIScrollView *projectsNavScrollViewTouch;
@property (nonatomic, retain) UIScrollView *projectsNavScrollViewAR;

@property (nonatomic, retain) UIPageControl *pageControlOne;
@property (nonatomic, retain) UIPageControl *pageControlTwo;
@property (nonatomic, retain) UIPageControl *pageControlThree;

@property (nonatomic, retain) NSMutableArray *imageViewsAbout;
@property (nonatomic, retain) NSMutableArray *imageViewsTech;
@property (nonatomic, retain) NSMutableArray *imageViewsProjects;
@property (nonatomic, retain) NSMutableArray *imageViewsContact;

@property (nonatomic, retain) UIButton *home1;
@property (nonatomic, retain) UIButton *home2;
@property (nonatomic, retain) UIButton *home3;

@property (nonatomic, retain) UIButton *arrow1;
@property (nonatomic, retain) UIButton *arrow2;
@property (nonatomic, retain) UIButton *arrow3;

@property (nonatomic, retain) EasyTableView *horizontalView;


- (IBAction)toggleSwitch:(id) sender;
//- (IBAction)nextTransition:(id)sender;

@end
