//
//  HeliosAppViewController.m
//  HeliosApp
//
//  Created by Tim Woo on 8/10/11.
//  Copyright 2011 Helios Interactive. All rights reserved.
//

#import "HeliosAppViewController.h"
#import "MapViewAnnotation.h"
#import <MediaPlayer/MediaPlayer.h>

// #define METERS_PER_MILE 1609.344

/* Set total number of categories and number of projects in tab 3 */
static NSUInteger numberOfTabs = 4;
static NSUInteger kNumberOfProjects = 5;

//    Set the amount of Pages for 
//    TabOne (About)          TabTwo (Tech)
//    TabThree (Projects)     TabFour (Contact)*/
static NSUInteger kNumberOfPagesTabOne = 3;
static NSUInteger kNumberOfPagesTabTwo =6;
static NSUInteger kNumberOfPagesTabThree = 6;
static NSUInteger kNumberOfPagesTabFour = 1;

//
//  Sets offset of the parent scrollview. This is the size 
//  of everything below the navigation bar which is 64 pixels.
//  Offset is respect to the entire window.                   
//
static NSUInteger parentScrollViewOffsetTop = 64;
static NSUInteger parentScrollViewOffsetLeft = 0;
static CGFloat parentScrollHeight = 1004-64-64;

//
// Sets the placement of the glass on screen.
// Offset is with respect to the parent scrollview.
//
static NSUInteger childScrollViewOffsetLeft = 15;  
static NSUInteger childScrollViewOffsetTop = 15;
static NSUInteger childScrollViewHeight = 846;
static NSUInteger childScrollViewWidth = 736;

/* Sets position of the pageControl on each tab */
static NSUInteger pageControlOffsetTop = 820;



@interface HeliosAppViewController (PrivateMethods)

- (void)insertProjectNavigation;
- (void)insertContentIntoTabOne:(UIView *)tabOne;
- (void)insertContentIntoTabTwo:(UIView *)tabTwo;
- (void)insertContentIntoTabThree:(UIView *)tabThree;
- (void)insertContentIntoTabFour:(UIView *)tabFour;
- (void)insertButtonsIntoChildScrollView;
- (void)insertButtonsIntoParentScrollView;
- (void)insertLocationManager;
- (void)insertTabs;
- (void)insertParentScrollView;
- (void)loadScrollView:(UIScrollView *)scrollView 
        WithPageNumber:(int)page 
            TotalPages:(int)totalPages 
        ImageViewArray:(NSMutableArray *)imageViewArray;
- (void)scrollToPage:(id)sender;
- (void)playPressed:(UIButton *)button;
- (void)goToMiniApp:(id)sender;
- (void)getDirections:(id)sender;
- (void)playPressed:(UIButton *)button;
/*- (void)cleanScrollView:(UIScrollView *)scrollView 
          AtCurrentPage:(int)currentPage 
         WithTotalPages:(int)totalPages
         ImageViewArray:(NSMutableArray *)imageViewArray;
*/

@end


@implementation HeliosAppViewController

@synthesize segmentedControl, parentScrollView, childScrollViewOne, childScrollViewTwo, childScrollViewThree, childScrollViewFour,
            pageControlOne,pageControlTwo, pageControlThree, imageViewsAbout, imageViewsTech, imageViewsProjects, imageViewsContact,
            home1,home2,home3, locationManager,startingPoint,arrow1,arrow2,arrow3, projectsNavScrollView;

#pragma mark -
#pragma mark Private Methods

- (void)insertContentIntoTabOne:(UIView *)tabOne  {
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *emptyViews = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPagesTabOne; i++)
    {
        [emptyViews addObject:[NSNull null]];
    }
    self.imageViewsAbout = emptyViews;
    [emptyViews release];
    
    // --- create scroll view for tab one
    UIScrollView *scrollViewHorizontal = [[UIScrollView alloc] initWithFrame:CGRectMake(childScrollViewOffsetLeft, childScrollViewOffsetTop,childScrollViewWidth, childScrollViewHeight)];
    scrollViewHorizontal.pagingEnabled = YES;
    scrollViewHorizontal.showsHorizontalScrollIndicator = NO;
    scrollViewHorizontal.showsVerticalScrollIndicator = NO;
    scrollViewHorizontal.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollViewHorizontal.bounces = YES;
    scrollViewHorizontal.contentSize = CGSizeMake(childScrollViewWidth * kNumberOfPagesTabOne, childScrollViewHeight);
    scrollViewHorizontal.clipsToBounds = YES;
    scrollViewHorizontal.delegate = self;
    
    self.childScrollViewOne = scrollViewHorizontal;    
    [scrollViewHorizontal release];
    
    // -- Input content into inner scroll view
    
    [self loadScrollView:childScrollViewOne WithPageNumber:0 TotalPages:kNumberOfPagesTabOne ImageViewArray:imageViewsAbout];
    [self loadScrollView:childScrollViewOne WithPageNumber:1 TotalPages:kNumberOfPagesTabOne ImageViewArray:imageViewsAbout];
    
    // -- add inner scroll view to tab 1
    [tabOne addSubview:childScrollViewOne];
    
    // --- add mask to tab 1
    UIImageView *imageMask = [[UIImageView alloc] initWithFrame:CGRectMake(childScrollViewOffsetLeft, childScrollViewOffsetTop, childScrollViewWidth, childScrollViewHeight)];
    imageMask.image = [UIImage imageNamed:@"glassMask.png"];
    [tabOne addSubview:imageMask];
    [imageMask release];
    
    // --- add page control to tab 1
    UIPageControl *control1 = [[UIPageControl alloc] initWithFrame:CGRectMake(0,pageControlOffsetTop,768,36)];
    control1.numberOfPages = kNumberOfPagesTabOne;
    control1.currentPage = 0;
    [control1 addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    self.pageControlOne = control1;
    [tabOne addSubview:pageControlOne];
    [control1 release];
    
}

- (void)insertContentIntoTabTwo:(UIView *)tabTwo  {
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *emptyViews2 = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPagesTabTwo; i++)
    {
        [emptyViews2 addObject:[NSNull null]];
    }
    self.imageViewsTech = emptyViews2;
    [emptyViews2 release];
    
    UIScrollView *scrollViewHorizontalTwo = [[UIScrollView alloc] initWithFrame:CGRectMake(childScrollViewOffsetLeft, childScrollViewOffsetTop,childScrollViewWidth, childScrollViewHeight)];
    scrollViewHorizontalTwo.pagingEnabled = YES;
    scrollViewHorizontalTwo.showsHorizontalScrollIndicator = NO;
    scrollViewHorizontalTwo.showsVerticalScrollIndicator = NO;
    scrollViewHorizontalTwo.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollViewHorizontalTwo.bounces = YES;
    scrollViewHorizontalTwo.contentSize = CGSizeMake(childScrollViewWidth * kNumberOfPagesTabTwo, childScrollViewHeight);
    scrollViewHorizontalTwo.clipsToBounds = YES;
    scrollViewHorizontalTwo.delegate = self;
    self.childScrollViewTwo = scrollViewHorizontalTwo;    
    [scrollViewHorizontalTwo release];
    
    [self loadScrollView:childScrollViewTwo WithPageNumber:0 TotalPages:kNumberOfPagesTabTwo ImageViewArray:imageViewsTech];
    [self loadScrollView:childScrollViewTwo WithPageNumber:1 TotalPages:kNumberOfPagesTabTwo ImageViewArray:imageViewsTech];
    
    // -- add inner scroll view to tab 2
    [tabTwo addSubview:childScrollViewTwo];       
    
    // -- add mask
    UIImageView *imageMaskTwo = [[UIImageView alloc] initWithFrame:CGRectMake(childScrollViewOffsetLeft, childScrollViewOffsetTop, childScrollViewWidth, childScrollViewHeight)];
    imageMaskTwo.image = [UIImage imageNamed:@"glassMask.png"];
    [tabTwo addSubview:imageMaskTwo];
    [imageMaskTwo release];
    
    // --- add page control to tab 2
    UIPageControl *control2 = [[UIPageControl alloc] initWithFrame:CGRectMake(0,pageControlOffsetTop,768,36)];
    control2.numberOfPages = kNumberOfPagesTabTwo;
    control2.currentPage = 0;
    [control2 addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    self.pageControlTwo = control2;
    [tabTwo addSubview:pageControlTwo];
    [control2 release];
    
}

- (void)insertContentIntoTabThree:(UIView *)tabThree  {
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *emptyViews3 = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPagesTabThree; i++)
    {
        [emptyViews3 addObject:[NSNull null]];
    }
    self.imageViewsProjects = emptyViews3;
    [emptyViews3 release];
    
    UIScrollView *scrollViewHorizontal3 = [[UIScrollView alloc] initWithFrame:CGRectMake(childScrollViewOffsetLeft, childScrollViewOffsetTop,childScrollViewWidth, childScrollViewHeight)];
    scrollViewHorizontal3.pagingEnabled = YES;
    scrollViewHorizontal3.showsHorizontalScrollIndicator = NO;
    scrollViewHorizontal3.showsVerticalScrollIndicator = NO;
    scrollViewHorizontal3.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollViewHorizontal3.bounces = YES;
    scrollViewHorizontal3.contentSize = CGSizeMake(childScrollViewWidth * kNumberOfPagesTabThree, childScrollViewHeight);
    scrollViewHorizontal3.clipsToBounds = YES;
    scrollViewHorizontal3.delegate = self;
    self.childScrollViewThree = scrollViewHorizontal3;    
    [scrollViewHorizontal3 release];
    
    
    [self loadScrollView:childScrollViewThree WithPageNumber:0 TotalPages:kNumberOfPagesTabThree ImageViewArray:imageViewsProjects];
    [self loadScrollView:childScrollViewThree WithPageNumber:1 TotalPages:kNumberOfPagesTabThree ImageViewArray:imageViewsProjects];
    
    // -- add inner scroll view to tab 3
    [tabThree addSubview:childScrollViewThree];       
    
    // -- add mask to tab 3
    UIImageView *imageMask3 = [[UIImageView alloc] initWithFrame:CGRectMake(childScrollViewOffsetLeft, childScrollViewOffsetTop, childScrollViewWidth, childScrollViewHeight)];
    imageMask3.image = [UIImage imageNamed:@"glassMask.png"];
    [tabThree addSubview:imageMask3];
    [imageMask3 release];
    
    // --- add page control to tab 3
    UIPageControl *control3 = [[UIPageControl alloc] initWithFrame:CGRectMake(0,pageControlOffsetTop,768,36)];
    control3.numberOfPages = kNumberOfPagesTabThree;
    control3.currentPage = 0;
    [control3 addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    self.pageControlThree = control3;
    [tabThree addSubview:pageControlThree];
    [control3 release];
    
    // Inserts project nav into tab three
    [self insertProjectNavigation];                 
}

- (void)insertContentIntoTabFour:(UIView *)tabFour  {
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *emptyViews4 = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPagesTabFour; i++)
    {
        [emptyViews4 addObject:[NSNull null]];
    }
    self.imageViewsContact = emptyViews4;
    [emptyViews4 release];
    
    UIScrollView *scrollViewHorizontal4 = [[UIScrollView alloc] initWithFrame:CGRectMake(childScrollViewOffsetLeft, childScrollViewOffsetTop,childScrollViewWidth, childScrollViewHeight)];
    scrollViewHorizontal4.pagingEnabled = YES;
    scrollViewHorizontal4.showsHorizontalScrollIndicator = NO;
    scrollViewHorizontal4.showsVerticalScrollIndicator = NO;
    scrollViewHorizontal4.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollViewHorizontal4.bounces = YES;
    scrollViewHorizontal4.contentSize = CGSizeMake(childScrollViewWidth * kNumberOfPagesTabFour, childScrollViewHeight);
    scrollViewHorizontal4.clipsToBounds = YES;
    scrollViewHorizontal4.delegate = self;
    self.childScrollViewFour = scrollViewHorizontal4;    
    [scrollViewHorizontal4 release];
    
    
    [self loadScrollView:childScrollViewFour WithPageNumber:0 TotalPages:kNumberOfPagesTabFour ImageViewArray:imageViewsContact];
    [self loadScrollView:childScrollViewFour WithPageNumber:1 TotalPages:kNumberOfPagesTabFour ImageViewArray:imageViewsContact];
    
    // add map to tab 4
    MKMapView* mapView = [[MKMapView alloc] initWithFrame:CGRectMake(255, 294, 242, 227)];
    mapView.mapType = MKMapTypeStandard;
    
    CLLocationCoordinate2D HeliosLocation;
    HeliosLocation.latitude = 37.774887;
    HeliosLocation.longitude = -122.409432;
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 37.786996;
    newRegion.center.longitude = -122.440100;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    // MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(HeliosLocation, 8*METERS_PER_MILE, 8*METERS_PER_MILE);
    // MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    
    MapViewAnnotation *heliosAnnotation = [[MapViewAnnotation alloc] initWithTitle:@"Helios Interactive" andCoordinate:HeliosLocation]; 
    [mapView addAnnotation:heliosAnnotation];
    [heliosAnnotation release];
    
    [mapView setRegion:newRegion animated:NO];
    
    [childScrollViewFour addSubview:mapView];
    [mapView release];
    
    // -- add inner scroll view to tab 4
    
    [tabFour addSubview:childScrollViewFour];       
    
    // -- add mask to tab 4
    
    UIImageView *imageMask4 = [[UIImageView alloc] initWithFrame:CGRectMake(childScrollViewOffsetLeft, childScrollViewOffsetTop, childScrollViewWidth, childScrollViewHeight)];
    imageMask4.image = [UIImage imageNamed:@"glassMask.png"];
    [tabFour addSubview:imageMask4];
    [imageMask4 release];
    
    // --- add page control to tab 4
    /*
     UIPageControl *control4 = [[UIPageControl alloc] initWithFrame:CGRectMake(0,pageControlOffsetTop,768,36)];
     control4.numberOfPages = kNumberOfPagesTabTwo;
     control4.currentPage = 0;
     [control4 addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
     
     self.pageControlFour = control4;
     [tabFour addSubview:pageControlFour];
     [control4 release];
     */
    
}

- (void)insertProjectNavigation {
    //-----------------------------//
    //   Projects Nav ScrollView   //
    //-----------------------------//
    
    int buttonProjectWidth = 199;
    
    UIScrollView *scrollViewProjects = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 510,641, 191)];
    scrollViewProjects.pagingEnabled = NO;
    scrollViewProjects.showsHorizontalScrollIndicator = YES;
    scrollViewProjects.showsVerticalScrollIndicator = NO;
    scrollViewProjects.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollViewProjects.bounces = NO;
    scrollViewProjects.contentSize = CGSizeMake(kNumberOfProjects*(buttonProjectWidth+15), 191);
    scrollViewProjects.contentInset = UIEdgeInsetsMake(0, 0, 0, 7);
    scrollViewProjects.clipsToBounds = YES;
    scrollViewProjects.delegate = self;
    self.projectsNavScrollView = scrollViewProjects;
    [scrollViewProjects release];
    
    [childScrollViewThree addSubview:projectsNavScrollView];
    
    UIImageView *backgroundScrollViewProjects = [[UIImageView alloc] initWithFrame:CGRectMake(50,510, 641, 191)];
    backgroundScrollViewProjects.image = [UIImage imageNamed:@"scrollbarProjectNav.png"];
    [childScrollViewThree addSubview:backgroundScrollViewProjects];
    [backgroundScrollViewProjects release];
    
    for (int i=1;i<=kNumberOfProjects;i++)
    {
        NSString *projectImage = [NSString stringWithFormat:@"buttonP%i.png",i];
        NSString *projectImageHighlighted = [NSString stringWithFormat:@"buttonP%iH.png",i];
        
        UIButton *projectButton = [[UIButton alloc] initWithFrame:CGRectMake((i-1)*(buttonProjectWidth+15)+7, 0, buttonProjectWidth, 191)];
        [projectButton setImage:[UIImage imageNamed:projectImage] forState:UIControlStateNormal];
        [projectButton setImage:[UIImage imageNamed:projectImageHighlighted] forState:UIControlStateHighlighted];
        projectButton.tag = i+2000; 
        [projectButton addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
        [projectsNavScrollView addSubview:projectButton];
        [projectButton release];
        
    }
    
}

- (void)insertButtonsIntoChildScrollView {
    // Add arrow buttons to the vertical scroll view
    
    UIButton *arrowTemp = [[UIButton alloc] initWithFrame:CGRectMake(360, 570, 30, 20)];
    [arrowTemp setImage:[UIImage imageNamed:@"buttonArrow.png"] forState:UIControlStateNormal];
    [arrowTemp setImage:[UIImage imageNamed:@"buttonArrowH.png"] forState:UIControlStateHighlighted];
    arrowTemp.tag = 150;
    [arrowTemp addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    self.arrow1 = arrowTemp;
    [childScrollViewOne addSubview:arrow1];
    [arrowTemp release];
    
    UIButton *arrowTemp2 = [[UIButton alloc] initWithFrame:CGRectMake(360, 520, 30, 20)];
    [arrowTemp2 setImage:[UIImage imageNamed:@"buttonArrow.png"] forState:UIControlStateNormal];
    [arrowTemp2 setImage:[UIImage imageNamed:@"buttonArrowH.png"] forState:UIControlStateHighlighted];
    arrowTemp2.tag = 151;
    [arrowTemp2 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    self.arrow2 = arrowTemp2;
    [childScrollViewTwo addSubview:arrow2];
    [arrowTemp2 release];
    
    UIButton *arrowTemp3 = [[UIButton alloc] initWithFrame:CGRectMake(360, 420, 30, 20)];
    [arrowTemp3 setImage:[UIImage imageNamed:@"buttonArrow.png"] forState:UIControlStateNormal];
    [arrowTemp3 setImage:[UIImage imageNamed:@"buttonArrowH.png"] forState:UIControlStateHighlighted];
    arrowTemp3.tag = 152;
    [arrowTemp3 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    self.arrow3 = arrowTemp3;
    [childScrollViewThree addSubview:arrow3];
    [arrowTemp3 release];
    /*
     // button what we do
     UIButton *button3 = [[[UIButton alloc] initWithFrame:CGRectMake(220, 690, 130, 40)] autorelease];
     [button3 setImage:[UIImage imageNamed:@"button-WhatWeDo.png"] forState:UIControlStateNormal];
     [button3 setImage:[UIImage imageNamed:@"buttonWhatWeDoHighlight"] forState:UIControlStateHighlighted];
     button3.tag = 11;
     [button3 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
     [childScrollViewOne addSubview:button3];
     
     // button what we bring
     UIButton *button4 = [[[UIButton alloc] initWithFrame:CGRectMake(410, 690, 130, 40)] autorelease];
     [button4 setImage:[UIImage imageNamed:@"buttonWhatWeBring.png"] forState:UIControlStateNormal];
     [button4 setImage:[UIImage imageNamed:@"buttonWhatWeBringHighlight.png"] forState:UIControlStateHighlighted];
     button4.tag = 12;
     [button4 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
     [childScrollViewOne addSubview:button4];
     
     // button how it works
     UIButton *button5 = [[[UIButton alloc] initWithFrame:CGRectMake(450, 690, 130, 40)] autorelease];
     [button5 setImage:[UIImage imageNamed:@"buttonHowItWorks.png"] forState:UIControlStateNormal];
     [button5 setImage:[UIImage imageNamed:@"buttonHowItWorksHighlight.png"] forState:UIControlStateHighlighted];
     button5.tag = 13;
     [button5 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
     [childScrollViewOne addSubview:button5];
     */
    
    // button Touch
    UIButton *button6 = [[UIButton alloc] initWithFrame:CGRectMake(140, 580, 130, 60)];
    [button6 setImage:[UIImage imageNamed:@"buttonTouch.png"] forState:UIControlStateNormal];
    [button6 setImage:[UIImage imageNamed:@"buttonTouchHighlight.png"] forState:UIControlStateHighlighted];
    button6.tag = 21;
    [button6 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewTwo addSubview:button6];
    [button6 release];
    
    // button 3D
    UIButton *button7 = [[UIButton alloc] initWithFrame:CGRectMake(310, 580, 130, 60)];
    [button7 setImage:[UIImage imageNamed:@"button3d.png"] forState:UIControlStateNormal];
    [button7 setImage:[UIImage imageNamed:@"button3dHighlight.png"] forState:UIControlStateHighlighted];
    button7.tag = 22;
    [button7 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewTwo addSubview:button7];
    [button7 release];
    
    // button AR
    UIButton *button8 = [[UIButton alloc] initWithFrame:CGRectMake(480, 580, 130, 60)];
    [button8 setImage:[UIImage imageNamed:@"buttonAR.png"] forState:UIControlStateNormal];
    [button8 setImage:[UIImage imageNamed:@"buttonARHighlight.png"] forState:UIControlStateHighlighted];
    button8.tag = 23;
    [button8 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewTwo addSubview:button8];
    [button8 release];
    
    // button Mobile
    UIButton *button9 = [[UIButton alloc] initWithFrame:CGRectMake(310, 660, 130, 60)];
    [button9 setImage:[UIImage imageNamed:@"buttonMobile.png"] forState:UIControlStateNormal];
    [button9 setImage:[UIImage imageNamed:@"buttonMobileHighlight.png"] forState:UIControlStateHighlighted];
    button9.tag = 24;
    [button9 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewTwo addSubview:button9];
    [button9 release];
    
    // Go To Mini App Button
    UIButton *mini = [[UIButton alloc] initWithFrame:CGRectMake(childScrollViewWidth*2+540, 85, 163, 35)];
    [mini setImage:[UIImage imageNamed:@"buttonMini.png"] forState:UIControlStateNormal];
    [mini setImage:[UIImage imageNamed:@"buttonMiniHighlight.png"] forState:UIControlStateHighlighted];
    [mini addTarget:self action:@selector(goToMiniApp:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewThree addSubview:mini];
    [mini release];
    
    // Get Directions Button
    UIButton *getDirectionsButton = [[UIButton alloc] initWithFrame:CGRectMake(310, 252, 126, 30)];
    [getDirectionsButton setImage:[UIImage imageNamed:@"buttonDirections.png"] forState:UIControlStateNormal];
    [getDirectionsButton setImage:[UIImage imageNamed:@"buttonDirectionsH.png"] forState:UIControlStateHighlighted];
    [getDirectionsButton addTarget:self action:@selector(getDirections:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewFour addSubview:getDirectionsButton];
    [getDirectionsButton release];
    
    // Add play button to project 1
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(childScrollViewWidth+220, 370, 81, 81)];    
    [playButton setBackgroundImage:[UIImage imageNamed:@"buttonPlay.png"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"buttonPlayH.png"] forState:UIControlStateHighlighted];
    [playButton addTarget:self action:@selector(playPressed:) forControlEvents: UIControlEventTouchUpInside]; 
    playButton.tag = 50001;
    [childScrollViewThree addSubview:playButton];
    [playButton release];
    
    // Add play button to project 2
    UIButton *playButton2 = [[UIButton alloc] initWithFrame:CGRectMake(childScrollViewWidth*2 +620, 370, 81, 81)];    
    [playButton2 setBackgroundImage:[UIImage imageNamed:@"buttonPlay.png"] forState:UIControlStateNormal];
    [playButton2 setImage:[UIImage imageNamed:@"buttonPlayH.png"] forState:UIControlStateHighlighted];
    [playButton2 addTarget:self action:@selector(playPressed:) forControlEvents: UIControlEventTouchUpInside]; 
    playButton2.tag = 50002;
    [childScrollViewThree addSubview:playButton2];
    [playButton2 release];
    
}

- (void)insertButtonsIntoParentScrollView {
    // Add home buttons to the vertical scroll view
    
    UIButton *home1temp = [[UIButton alloc] initWithFrame:CGRectMake(640, 15, 130, 40)];
    [home1temp setImage:[UIImage imageNamed:@"buttonHome.png"] forState:UIControlStateNormal];
    [home1temp setImage:[UIImage imageNamed:@"buttonHomeHighlight"] forState:UIControlStateHighlighted];
    home1temp.tag = 997;
    [home1temp addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    self.home1 = home1temp;
    [parentScrollView addSubview:home1];
    [home1temp release];
    
    UIButton *home2t = [[UIButton alloc] initWithFrame:CGRectMake(640, parentScrollHeight+15, 130, 40)];
    [home2t setImage:[UIImage imageNamed:@"buttonHome.png"] forState:UIControlStateNormal];
    [home2t setImage:[UIImage imageNamed:@"buttonHomeHighlight"] forState:UIControlStateHighlighted];
    home2t.tag = 998;
    [home2t addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    self.home2 = home2t;
    [parentScrollView addSubview:home2];
    [home2t release];
    
    UIButton *home3t = [[UIButton alloc] initWithFrame:CGRectMake(640, parentScrollHeight*2+15, 130, 40)];
    [home3t setImage:[UIImage imageNamed:@"buttonHome.png"] forState:UIControlStateNormal];
    [home3t setImage:[UIImage imageNamed:@"buttonHomeHighlight"] forState:UIControlStateHighlighted];
    home3t.tag = 999;
    [home3t addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    self.home3 = home3t;
    [parentScrollView addSubview:home3];
    [home3t release];
    
}

- (void)insertLocationManager {
    /* Add location manager */
    
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    self.locationManager = manager;
    [manager release];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
    
}

- (void)insertTabs {
    /* create tabs for each section (about, tech, projects, contact)  */
    
    UIView *tabOne = [[UIView alloc] initWithFrame:CGRectMake(parentScrollViewOffsetLeft, 0*parentScrollHeight, self.view.frame.size.width, parentScrollHeight)];
    UIView *tabTwo = [[UIView alloc] initWithFrame:CGRectMake(parentScrollViewOffsetLeft, 1*parentScrollHeight, self.view.frame.size.width, parentScrollHeight)];
    UIView *tabThree = [[UIView alloc] initWithFrame:CGRectMake(parentScrollViewOffsetLeft, 2*parentScrollHeight, self.view.frame.size.width, parentScrollHeight)];
    UIView *tabFour = [[UIView alloc] initWithFrame:CGRectMake(parentScrollViewOffsetLeft, 3*parentScrollHeight, self.view.frame.size.width, parentScrollHeight)];
    
    /*          Inner container start
     Insert Content into all tabs          */
    
    [self insertContentIntoTabOne: tabOne];         // includes adding child scrollviews, glass masks, pagecontrols, all pages from loadscrollview:, and maps
    [self insertContentIntoTabTwo: tabTwo];
    [self insertContentIntoTabThree: tabThree];
    [self insertContentIntoTabFour: tabFour];
    
    [self insertButtonsIntoChildScrollView];        // jump buttons, direction button, mini app button, etc
    
    //Flip side functionality 
    /*
     // ------------------------------------------------
     // Scroll view Flip side functionality
     // ------------------------------------------------
     
     // button example project flip
     CGFloat pageOfButton = 1;
     UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(pageOfButton*childScrollViewWidth+32, 98, 290, 320)] autorelease];
     [button addTarget:self action:@selector(nextTransition:) forControlEvents:UIControlEventTouchUpInside];
     [childScrollViewOne addSubview:button];
     
     
     // --- Hidden project pages on the flip view
     
     image1 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"childScrollerAbout3.png"]] autorelease];
     image1.frame = CGRectMake(childScrollViewOffsetLeft, childScrollViewOffsetTop,childScrollViewWidth, childScrollViewHeight);
     image2 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"childScrollerAbout2.png"]] autorelease];
     image2.frame = CGRectMake(childScrollViewOffsetLeft, childScrollViewOffsetTop,childScrollViewWidth, childScrollViewHeight);
     image1.hidden = YES;
     image2.hidden = YES;
     [image1 setUserInteractionEnabled:YES];
     [image2 setUserInteractionEnabled:YES];
     transitioning = NO;
     
     // Back button to normal view
     UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 100, 50)];
     //button2.backgroundColor = [UIColor redColor];
     [button2 addTarget:self action:@selector(nextTransition:) forControlEvents:UIControlEventTouchUpInside];
     [image1 addSubview:button2];
     [button2 release];
     
     [tabOne addSubview:image1];
     [tabOne addSubview:image2];
     
     */
    
    /*          inner container close            */
    
    
    // Put the tabs into the main vertical scrollview
    [parentScrollView addSubview:tabOne];
    [parentScrollView addSubview:tabTwo];
    [parentScrollView addSubview:tabThree];
    [parentScrollView addSubview:tabFour];
    
    [tabOne release];
    [tabTwo release];
    [tabThree release];
    [tabFour release];
    
}

- (void)insertParentScrollView {
    /* create outer scroll view  */
    
    UIScrollView *scrollViewVerticalContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(parentScrollViewOffsetLeft, parentScrollViewOffsetTop,self.view.frame.size.width, parentScrollHeight)];
    scrollViewVerticalContainer.pagingEnabled = YES;
    scrollViewVerticalContainer.showsHorizontalScrollIndicator = YES;
    scrollViewVerticalContainer.showsVerticalScrollIndicator = YES;
    scrollViewVerticalContainer.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollViewVerticalContainer.bounces = NO;
    scrollViewVerticalContainer.contentSize = CGSizeMake(self.view.frame.size.width, parentScrollHeight * numberOfTabs);
    scrollViewVerticalContainer.delegate = self;
    
    self.parentScrollView = scrollViewVerticalContainer;
    [scrollViewVerticalContainer release];
    
    [self insertTabs];
    
    [self insertButtonsIntoParentScrollView];
    
    [self.view addSubview:parentScrollView];
    
}

- (void)goToMiniApp:(id)sender  {
    NSString *str = @"itms-apps://ax.itunes.apple.com/us/app/virtual-mini/id417870781?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [str release];
}

- (void)getDirections:(id)sender  {
    NSString *url;
    if (startingPoint == nil )
    {
        url = [NSString stringWithFormat: @"http://maps.google.com/maps?q=Helios+Interactive+San+Francisco+CA+94103&sll=37.774887,-122.409432"];
    }
    else
    {
        NSString* address = @"305 8th Street, San Francisco, CA 94103";
        url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",
               startingPoint.coordinate.latitude, startingPoint.coordinate.longitude,
               [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

- (void)playPressed:(UIButton *)button  {
    
	// Play movie from URL
    //NSURL *movieURL = [NSURL URLWithString:@"http://someurlsomewhere.com/movie.mp4"];
    
    NSURL *videoURL;
    if (button.tag == 50001)
    { 
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"mercedes" ofType:@"mov"];
        videoURL = [[NSURL fileURLWithPath:moviePath] retain];
    }
    else
    {
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Agilent_final" ofType:@"mov"];
        videoURL = [[NSURL fileURLWithPath:moviePath] retain];
    }
    
    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
    [playerViewController release];
    [videoURL release];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidAppear:(BOOL)animated {
    [parentScrollView flashScrollIndicators];
}

- (void)viewDidLoad {   
    [self insertLocationManager];
    
    // Parent scrollview is vertical and is the outer container for all inner content
    
    [self insertParentScrollView];      

    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setParentScrollView:nil];
    [self setChildScrollViewOne:nil];
    [self setChildScrollViewTwo:nil];
    [self setChildScrollViewThree:nil];
    [self setPageControlOne:nil];
    [self setPageControlTwo:nil];
    [self setPageControlThree:nil];
    [self setSegmentedControl:nil];
    [self setImageViewsAbout:nil];
    [self setImageViewsTech:nil];
    [self setImageViewsProjects:nil];
    
    self.locationManager = nil;
    self.startingPoint = nil;
    self.arrow1 = nil;
    self.arrow2 = nil;
    self.arrow3 = nil;
    
    [self setHome1:nil];
    [self setHome2:nil];
    [self setHome3:nil];
    
    self.projectsNavScrollView = nil;
}

- (void)dealloc {
    [parentScrollView release];
    [childScrollViewOne release];
    [childScrollViewTwo release];
    [childScrollViewThree release];
    [childScrollViewFour release];
    [pageControlOne release];
    [pageControlTwo release];
    [pageControlThree release];
    [imageViewsAbout release];
    [imageViewsTech release];
    [imageViewsProjects release];
    [segmentedControl release];
    [home1 release];
    [home2 release];
    [home3 release];
    [arrow1 release];
    [arrow2 release];
    [arrow3 release];
    [locationManager release];
    [startingPoint release];
    [projectsNavScrollView release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/*
- (void)cleanScrollView:(UIScrollView *)scrollView AtCurrentPage:(int)currentPage WithTotalPages:(int)totalPages  ImageViewArray:(NSMutableArray *)imageViewArray
{
    NSLog(@"In cleanscollview");
    
    if (currentPage < 0)
        return;
    if (currentPage >= totalPages)
        return;
    
    UIView *subview;
    for (int i=0; i<totalPages; i++)
    {
        NSLog(@"i = %i ", i);
        NSLog(@"currentpage = %i", currentPage);
        
        if ([imageViewArray objectAtIndex:i] != [NSNull null])
        {
            if (i != currentPage && i != currentPage-1 && i != currentPage+1)
            {
                [imageViewArray replaceObjectAtIndex:i withObject:[NSNull null]];
                [[scrollView viewWithTag:i] removeFromSuperview];
            }
            
        }
    }
}
*/
 
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
    // change pageControl indicator
    int page = 0;
    CGFloat pageWidth = childScrollViewOne.frame.size.width;
    page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (sender == childScrollViewOne)
        pageControlOne.currentPage = page;
    else if (sender == childScrollViewTwo)
        pageControlTwo.currentPage = page;
    else if (sender == childScrollViewThree)
        pageControlThree.currentPage = page;
    else {}
   // else if (sender == childScrollViewFour)
   //     pageControlFour.currentPage = page;
    
    
    if (sender != parentScrollView && sender != projectsNavScrollView)
    {
        int totalPages;
        NSMutableArray *imageViewArray;
        
        if (sender == childScrollViewOne) 
        {
            totalPages = kNumberOfPagesTabOne;
            imageViewArray = imageViewsAbout;
        }
        else if (sender == childScrollViewTwo)
        {
            totalPages = kNumberOfPagesTabTwo;
            imageViewArray = imageViewsTech;
        }
        else if (sender == childScrollViewThree)
        {
            totalPages = kNumberOfPagesTabThree;
            imageViewArray = imageViewsProjects;
        }
        else //if (sender == childScrollViewFour)
        {
            totalPages = kNumberOfPagesTabFour;
            imageViewArray = imageViewsContact;
        }
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
        [self loadScrollView:sender WithPageNumber:page - 1 TotalPages:totalPages ImageViewArray:imageViewArray];
        [self loadScrollView:sender WithPageNumber:page     TotalPages:totalPages ImageViewArray:imageViewArray];
        [self loadScrollView:sender WithPageNumber:page + 1 TotalPages:totalPages ImageViewArray:imageViewArray];
    }
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
   
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // -- reset frame if parent frame scrolls to a different tab
    
    if (scrollView == parentScrollView)
    {   
        CGRect frame = childScrollViewOne.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        
        if (parentScrollView.contentOffset.y == 0)
        {
            segmentedControl.selectedSegmentIndex = kSwitchesSegmentAbout;
            [childScrollViewTwo scrollRectToVisible:frame animated:NO];
            [childScrollViewThree scrollRectToVisible:frame animated:NO];
            [childScrollViewFour scrollRectToVisible:frame animated:NO];
        }
        else if (parentScrollView.contentOffset.y == parentScrollHeight)
        {         
            segmentedControl.selectedSegmentIndex = kSwitchesSegmentTech;
            [childScrollViewOne scrollRectToVisible:frame animated:NO];
            [childScrollViewThree scrollRectToVisible:frame animated:NO];
            [childScrollViewFour scrollRectToVisible:frame animated:NO];
        }
        else if (parentScrollView.contentOffset.y == 2*parentScrollHeight)
        {
            segmentedControl.selectedSegmentIndex = kSwitchesSegmentProjects;
            [childScrollViewTwo scrollRectToVisible:frame animated:NO];
            [childScrollViewOne scrollRectToVisible:frame animated:NO];
            [childScrollViewFour scrollRectToVisible:frame animated:NO];
        }
        else if (parentScrollView.contentOffset.y == 3*parentScrollHeight)
        {
            segmentedControl.selectedSegmentIndex = kSwitchesSegmentContact;
            [childScrollViewOne scrollRectToVisible:frame animated:NO];
            [childScrollViewTwo scrollRectToVisible:frame animated:NO];
            [childScrollViewThree scrollRectToVisible:frame animated:NO];
        }
    }
    
    pageControlUsed = NO;
}

#pragma mark -
#pragma mark Page Navigation and Page Control

- (IBAction)toggleSwitch:(id) sender {
    int index = [sender selectedSegmentIndex];
    
    CGRect frameParent = parentScrollView.frame;
    frameParent.origin.x = 0;
    frameParent.origin.y = frameParent.size.height * index;
    
    [parentScrollView scrollRectToVisible:frameParent animated:YES];
    
    CGRect frameChild = childScrollViewOne.frame;
    frameChild.origin.x = 0;
    frameChild.origin.y = 0;
    
    if (index == kSwitchesSegmentAbout)
        [childScrollViewOne scrollRectToVisible:frameChild animated:NO];
    else if (index == kSwitchesSegmentTech)
        [childScrollViewTwo scrollRectToVisible:frameChild animated:NO];
    else if (index == kSwitchesSegmentProjects)
        [childScrollViewThree scrollRectToVisible:frameChild animated:NO];
    else if (index == kSwitchesSegmentContact)
        [childScrollViewFour scrollRectToVisible:frameChild animated:NO];

}

- (IBAction)changePage:(id)sender {
    int page;
    int totalPages;
    NSMutableArray *imageViewArray;
    UIScrollView *theChildScrollView;
    
    if (sender == pageControlOne)
    {
        page = pageControlOne.currentPage;
        totalPages = kNumberOfPagesTabOne;
        imageViewArray = imageViewsAbout;
        theChildScrollView = childScrollViewOne;
        
        // update the scroll view to the appropriate page
        CGRect frame = childScrollViewOne.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [childScrollViewOne scrollRectToVisible:frame animated:YES];
    }
    else if (sender == pageControlTwo)
    {
        page = pageControlTwo.currentPage;
        totalPages = kNumberOfPagesTabTwo;
        imageViewArray = imageViewsTech;
        theChildScrollView = childScrollViewTwo;
        
        // update the scroll view to the appropriate page
        CGRect frame = childScrollViewTwo.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [childScrollViewTwo scrollRectToVisible:frame animated:YES];
    }
    else // if (sender == pageControlThree)
    {
        page = pageControlThree.currentPage;
        totalPages = kNumberOfPagesTabThree;
        imageViewArray = imageViewsProjects;
        theChildScrollView = childScrollViewThree;
        
        // update the scroll view to the appropriate page
        CGRect frame = childScrollViewThree.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [childScrollViewThree scrollRectToVisible:frame animated:YES];
    }
   /* else //if (sender == pageControlFour)
    {
        page = pageControlFour.currentPage;
        totalPages = kNumberOfPagesTabFour;
        imageViewArray = imageViewsContact;
        theChildScrollView = childScrollViewFour;
        
        // update the scroll view to the appropriate page
        CGRect frame = childScrollViewFour.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [childScrollViewFour scrollRectToVisible:frame animated:YES];
        
    }*/

    
    [self loadScrollView:theChildScrollView WithPageNumber:(page - 1) TotalPages:totalPages ImageViewArray:imageViewArray];
    [self loadScrollView:theChildScrollView WithPageNumber:page     TotalPages:totalPages ImageViewArray:imageViewArray];
    [self loadScrollView:theChildScrollView WithPageNumber:page + 1 TotalPages:totalPages ImageViewArray:imageViewArray];
    
    pageControlUsed = YES;
}

/*
-(void)performTransition
{
	CATransition *transition = [CATransition animation];
	transition.duration = 0.75;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	transitioning = YES;
	transition.delegate = self;
	
	// add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[childScrollViewOne.layer addAnimation:transition forKey:nil];
    [childScrollViewTwo.layer addAnimation:transition forKey:nil];
	
	if (image1.hidden == YES)
    {
        childScrollViewOne.hidden = YES;
        pageControlOne.hidden = YES;
        segmentedControl.hidden = YES;
        parentScrollView.scrollEnabled = NO;
        home1.hidden = YES;
        home2.hidden = YES;
        home3.hidden = YES;
        
        image1.hidden = NO;
        
    }
    else
    {        
        image1.hidden = YES;
        childScrollViewOne.hidden = NO;
        pageControlOne.hidden = NO;
        segmentedControl.hidden = NO;
        parentScrollView.scrollEnabled = YES;
        home1.hidden = NO;
        home2.hidden = NO;
        home3.hidden = NO;
    }
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	transitioning = NO;
}

-(IBAction)nextTransition:(id)sender
{
	if(!transitioning)
	{
		[self performTransition];
	}
}
 */

- (void)scrollToPage:(id)sender {
    // Button tags are used to determine which button is pressed and what scrollview needs to be moved
    
    UIButton *button = (UIButton *)sender;
    CGRect frame = childScrollViewOne.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    if (button.tag == 997)                                              // Home Buttons
        [childScrollViewOne scrollRectToVisible:frame animated:NO];
    else if (button.tag == 998)
        [childScrollViewTwo scrollRectToVisible:frame animated:NO];
    else if (button.tag == 999)
        [childScrollViewThree scrollRectToVisible:frame animated:NO];
    
    else if (button.tag == 150)                                         // Arrow Buttons
    {
        frame.origin.x = frame.size.width;
        [childScrollViewOne scrollRectToVisible:frame animated:YES];
    }
    else if  (button.tag == 151)
    {
        frame.origin.x = frame.size.width;
        [childScrollViewTwo scrollRectToVisible:frame animated:YES];
    }
    else if (button.tag == 152)
    {
        frame.origin.x = frame.size.width;
        [childScrollViewThree scrollRectToVisible:frame animated:YES];
    }
    
    else if (button.tag >2000 && button.tag <3000)                      // Project Jump Nav
    {
        frame.origin.x = frame.size.width * (button.tag-2000);
        [childScrollViewThree scrollRectToVisible:frame animated:NO];
    }
        
    else if (button.tag > 10 && button.tag < 20)                        // About Jump Buttons
    {
        frame.origin.x = frame.size.width * (button.tag-10);
        [childScrollViewOne scrollRectToVisible:frame animated:NO];
    }
    else if (button.tag > 20 && button.tag < 30)                        // Tech Jump Buttons
    {
        frame.origin.x = frame.size.width * (button.tag-20);
        [childScrollViewTwo scrollRectToVisible:frame animated:NO];
    }
    else                                                                // Project Jump Buttons
    {
        frame.origin.x = frame.size.width * (button.tag-30);
        [childScrollViewThree scrollRectToVisible:frame animated:NO];
    }
    
    pageControlUsed = NO;
}

- (void)loadScrollView:(UIScrollView *)scrollView WithPageNumber:(int)page TotalPages:(int)totalPages ImageViewArray:(NSMutableArray *)imageViewArray   {
    if (page < 0)
        return;
    if (page >= totalPages)
        return;
    
    // replace the placeholder if necessary
    UIImageView *anImageView = [imageViewArray objectAtIndex:page];
    if ((NSNull *)anImageView == [NSNull null])
    {
        NSString *theImageName;
        if (scrollView == childScrollViewOne)
            theImageName = [NSString stringWithFormat:@"about%i.png",page];
        else if (scrollView == childScrollViewTwo)
            theImageName = [NSString stringWithFormat:@"tech%i.png",page];
        else if (scrollView == childScrollViewThree)
            theImageName = [NSString stringWithFormat:@"project%i.png",page];
        else // if (scrollView == childScrollViewFour)
            theImageName = [NSString stringWithFormat:@"contact%i.png",page];
        
        CGFloat xOrigin = childScrollViewWidth * page;
        UIImageView *anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:theImageName]];
        anImageView.frame = CGRectMake(xOrigin, 0, childScrollViewWidth, childScrollViewHeight);
        anImageView.tag = page;
        
        [imageViewArray replaceObjectAtIndex:page withObject:anImageView];
        
        [scrollView addSubview:anImageView];
        [scrollView sendSubviewToBack:anImageView];
        [anImageView release];
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation   {
    if (startingPoint == nil)
    {
        self.startingPoint = newLocation;
        [locationManager stopUpdatingLocation];
        [locationManager startMonitoringSignificantLocationChanges];
    }
}

@end
