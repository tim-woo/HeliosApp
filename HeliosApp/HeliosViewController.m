//
//  HeliosAppViewController.m
//  HeliosApp
//
//  Created by Tim Woo on 8/10/11.
//  Copyright 2011 Helios Interactive. All rights reserved.
//

#import "HeliosViewController.h"
#import "MapViewAnnotation.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>

#define PORTRAIT_WIDTH				768
#define LANDSCAPE_HEIGHT			(1024-20)
#define NUM_OF_CELLS				21
#define HORIZONTAL_TABLEVIEW_HEIGHT	195
#define HORIZONTAL_TABLEVIEW_WIDTH  640
#define HORIZONTAL_CELL_WIDTH       195

#define VERTICAL_TABLEVIEW_HEIGHT	720
#define VERTICAL_TABLEVIEW_WIDTH    640
#define VERTICAL_CELL_HEIGHT        200

#define TABLE_BACKGROUND_COLOR		[[UIColor blackColor] colorWithAlphaComponent:0.1]

#define BORDER_VIEW_TAG				10

// #define METERS_PER_MILE 1609.344

/* Set total number of categories  */
static NSUInteger numberOfTabs = 4;

//    Set the amount of Pages for 
//    TabOne (About)          TabTwo (Tech)
//    TabFour (Contact)*/

//    Note: Tab 3 done automatically based on projects.plist

static NSUInteger kNumberOfPagesTabOne = 3;
static NSUInteger kNumberOfPagesTabTwo =6;
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



@interface HeliosViewController (PrivateMethods)
- (void)insertMap;
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
- (void)setupHorizontalView;
- (void)setupVerticalView;
-(void)nextTransition:(id)sender;
- (EasyTableView *)initVerticalViewWithNumberProjects:(int)numberOfProjects;
- (void)switchVerticalView:(id)sender;



/*- (void)cleanScrollView:(UIScrollView *)scrollView 
          AtCurrentPage:(int)currentPage 
         WithTotalPages:(int)totalPages
         ImageViewArray:(NSMutableArray *)imageViewArray;
*/

@end


@implementation HeliosViewController

@synthesize segmentedControl, parentScrollView, childScrollViewOne, childScrollViewTwo, childScrollViewThree, childScrollViewFour,
            pageControlOne,pageControlTwo, pageControlThree, imageViewsAbout, imageViewsTech, imageViewsProjects, imageViewsContact,
            home1,home2,home3, locationManager,startingPoint,arrow1,arrow2,arrow3, horizontalView, projectNavView, verticalView1,verticalView2,verticalView3,verticalView4,projectsFeatured, projectsAR,projectsAll,projectsTouch,projectsTracking, buttonAR, buttonTracking, buttonAll, buttonTouch;

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
        
    // ------------------------------------------------
    // Project Navigation on back
    // ------------------------------------------------
    
    // View Project Nav Button
    
    UIButton *navButton = [[[UIButton alloc] initWithFrame:CGRectMake(286, 470, 163, 35)] autorelease];
    [navButton setImage:[UIImage imageNamed:@"buttonNavigation.png"] forState:UIControlStateNormal];
    [navButton setImage:[UIImage imageNamed:@"buttonNavH.png"] forState:UIControlStateHighlighted];
    [navButton addTarget:self action:@selector(nextTransition:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewThree addSubview:navButton];
    
    // --- Hidden project pages on the flip view
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(childScrollViewOffsetLeft, childScrollViewOffsetTop, childScrollViewWidth, childScrollViewHeight)];
    self.projectNavView = view;
    [view release];

    /*
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"projectNav.png"]];
    background.frame = CGRectMake(0, 0, childScrollViewWidth, childScrollViewHeight);
    [projectNavView addSubview:background];
    [background release];
        */
    
    transitioning = NO;
    
    UIButton *navBack = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 60, 40)];
    [navBack setImage:[UIImage imageNamed:@"buttonNavBack.png"] forState:UIControlStateNormal];
    [navBack setImage:[UIImage imageNamed:@"buttonNavBackH.png"] forState:UIControlStateHighlighted];
    [navBack addTarget:self action:@selector(nextTransition:) forControlEvents:UIControlEventTouchUpInside];
    [projectNavView addSubview:navBack];
    [navBack release];

    UIButton *buttonAlltemp = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 160, 35)];
    [buttonAlltemp setImage:[UIImage imageNamed:@"buttonAll.png"] forState:UIControlStateNormal];
    [buttonAlltemp setImage:[UIImage imageNamed:@"buttonAllH.png"] forState:UIControlStateHighlighted];
    [buttonAlltemp setImage:[UIImage imageNamed:@"buttonAllH.png"] forState:UIControlStateDisabled];
    [buttonAlltemp addTarget:self action:@selector(switchVerticalView:) forControlEvents:UIControlEventTouchUpInside];
    buttonAlltemp.tag = 11111;
    buttonAlltemp.enabled = NO;
    self.buttonAll = buttonAlltemp;
    [projectNavView addSubview:buttonAll];
    [buttonAlltemp release];
    
    UIButton *buttonTouchTemp = [[UIButton alloc] initWithFrame:CGRectMake(210, 50, 160, 35)];
    [buttonTouchTemp setImage:[UIImage imageNamed:@"buttonTouchInterface.png"] forState:UIControlStateNormal];
    [buttonTouchTemp setImage:[UIImage imageNamed:@"buttonTouchInterfaceH.png"] forState:UIControlStateHighlighted];
    [buttonTouchTemp setImage:[UIImage imageNamed:@"buttonTouchInterfaceH.png"] forState:UIControlStateDisabled];
    [buttonTouchTemp addTarget:self action:@selector(switchVerticalView:) forControlEvents:UIControlEventTouchUpInside];
    buttonTouchTemp.tag = 11112;
    self.buttonTouch = buttonTouchTemp;
    [projectNavView addSubview:buttonTouch];
    [buttonTouchTemp release];
    
    UIButton *buttonARTemp = [[UIButton alloc] initWithFrame:CGRectMake(370, 50, 160, 35)];
    [buttonARTemp setImage:[UIImage imageNamed:@"buttonAugmented.png"] forState:UIControlStateNormal];
    [buttonARTemp setImage:[UIImage imageNamed:@"buttonAugmentedH.png"] forState:UIControlStateHighlighted];
    [buttonARTemp setImage:[UIImage imageNamed:@"buttonAugmentedH.png"] forState:UIControlStateDisabled];

    [buttonARTemp addTarget:self action:@selector(switchVerticalView:) forControlEvents:UIControlEventTouchUpInside];
    buttonARTemp.tag = 11113;
    self.buttonAR = buttonARTemp;
    [projectNavView addSubview:buttonAR];
    [buttonARTemp release];
    
    UIButton *buttonTrack = [[UIButton alloc] initWithFrame:CGRectMake(530, 50, 160, 35)];
    [buttonTrack setImage:[UIImage imageNamed:@"buttonTracking.png"] forState:UIControlStateNormal];
    [buttonTrack setImage:[UIImage imageNamed:@"buttonTrackingH.png"] forState:UIControlStateHighlighted];
    [buttonTrack setImage:[UIImage imageNamed:@"buttonTrackingH.png"] forState:UIControlStateDisabled];

    [buttonTrack addTarget:self action:@selector(switchVerticalView:) forControlEvents:UIControlEventTouchUpInside];
    buttonTrack.tag = 11114;
    self.buttonTracking = buttonTrack;
    [projectNavView addSubview:buttonTracking];
    [buttonTrack release];
    
    [self setupVerticalView];
    
    projectNavView.hidden = YES;
    

    [tabThree addSubview:projectNavView];

    [self setupHorizontalView];

}

- (void)switchVerticalView:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    buttonAll.enabled = YES;
    buttonAR.enabled = YES;
    buttonTouch.enabled = YES;
    buttonTracking.enabled = YES;
    
    verticalView1.hidden = YES;
    verticalView2.hidden = YES;
    verticalView3.hidden = YES;
    verticalView4.hidden = YES;

    if (button.tag == 11111)
    {
        verticalView1.hidden = NO;
        buttonAll.enabled = NO;
    }
    else if (button.tag == 11112)
    {
        verticalView2.hidden = NO;
        buttonTouch.enabled = NO;
    }
    else if (button.tag == 11113)
    {
        verticalView3.hidden = NO;
        buttonAR.enabled = NO;
    }
    else
    {
        verticalView4.hidden = NO;
        buttonTracking.enabled = NO;
    }
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
    
    //[self loadScrollView:childScrollViewFour WithPageNumber:1 TotalPages:kNumberOfPagesTabFour ImageViewArray:imageViewsContact];
    
    [self insertMap];

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

- (void)insertMap {
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
    
}

- (void)setupHorizontalView {
    
    int kNumberOfProjectsFeatured = [self.projectsFeatured count];

	CGRect frameRect	= CGRectMake(50, 510, HORIZONTAL_TABLEVIEW_WIDTH, HORIZONTAL_TABLEVIEW_HEIGHT);
	EasyTableView *view	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:kNumberOfProjectsFeatured ofWidth:HORIZONTAL_CELL_WIDTH];
	self.horizontalView = view;
    [view release];
    
	horizontalView.delegate						= self;
	horizontalView.tableView.backgroundColor	= TABLE_BACKGROUND_COLOR;
	horizontalView.tableView.allowsSelection	= YES;
	horizontalView.tableView.separatorColor		= [[UIColor blackColor] colorWithAlphaComponent:0.2];
	horizontalView.cellBackgroundColor			= [UIColor clearColor];
	horizontalView.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	
	[childScrollViewThree addSubview:horizontalView];
}


- (EasyTableView *)initVerticalViewWithNumberProjects:(int)numberOfProjects
{
    CGRect frameRect	= CGRectMake(50, 90, VERTICAL_TABLEVIEW_WIDTH, VERTICAL_TABLEVIEW_HEIGHT);
	EasyTableView *table = [[EasyTableView alloc] initWithFrame:frameRect numberOfRows:numberOfProjects ofHeight:VERTICAL_CELL_HEIGHT];
	
	table.delegate					= self;
	table.tableView.backgroundColor	= [UIColor clearColor];
	table.tableView.allowsSelection	= YES;
	table.tableView.separatorColor	= [[UIColor whiteColor] colorWithAlphaComponent:0.3];
	table.cellBackgroundColor		= [UIColor clearColor];
	table.autoresizingMask			= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Allow verticalView to scroll up and completely clear the horizontalView
	table.tableView.contentInset		= UIEdgeInsetsMake(5, 0, 0, 0);
    
    return table;
}

- (void)setupVerticalView {
    int kNumberOfProjects = [self.projectsAll count];
    int kNumberOfProjectsTouch = [self.projectsTouch count];
    int kNumberOfProjectsAR = [self.projectsAR count];
    int kNumberOfProjectsTracking = [self.projectsTracking count];
    
    EasyTableView *table = [self initVerticalViewWithNumberProjects:kNumberOfProjects];
    self.verticalView1 = table;
	[projectNavView addSubview:verticalView1];
	//[verticalView1 release];
    [table release];
    
    EasyTableView *table2 = [self initVerticalViewWithNumberProjects:kNumberOfProjectsTouch];
    self.verticalView2 = table2;
    verticalView2.hidden = YES;
	[projectNavView addSubview:verticalView2];
    [table2 release];
    
    EasyTableView *table3 = [self initVerticalViewWithNumberProjects:kNumberOfProjectsAR];
    self.verticalView3 = table3;
    verticalView3.hidden = YES;
	[projectNavView addSubview:verticalView3];
    [table3 release];
    
    EasyTableView *table4 = [self initVerticalViewWithNumberProjects:kNumberOfProjectsTracking];
    self.verticalView4 = table4;
    verticalView4.hidden = YES;
	[projectNavView addSubview:verticalView4];
    [table4 release];
}

- (void)insertButtonsIntoChildScrollView {
    // Add arrow buttons to the vertical scroll view

    UIButton *arrowTemp = [[UIButton alloc] initWithFrame:CGRectMake(354, 570, 30, 20)];
    [arrowTemp setImage:[UIImage imageNamed:@"buttonArrow.png"] forState:UIControlStateNormal];
    [arrowTemp setImage:[UIImage imageNamed:@"buttonArrowH.png"] forState:UIControlStateHighlighted];
    arrowTemp.tag = 150;
    [arrowTemp addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    self.arrow1 = arrowTemp;
    [childScrollViewOne addSubview:arrow1];
    [arrowTemp release];
    
    UIButton *arrowTemp2 = [[UIButton alloc] initWithFrame:CGRectMake(354, 520, 30, 20)];
    [arrowTemp2 setImage:[UIImage imageNamed:@"buttonArrow.png"] forState:UIControlStateNormal];
    [arrowTemp2 setImage:[UIImage imageNamed:@"buttonArrowH.png"] forState:UIControlStateHighlighted];
    arrowTemp2.tag = 151;
    [arrowTemp2 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    self.arrow2 = arrowTemp2;
    [childScrollViewTwo addSubview:arrow2];
    [arrowTemp2 release];
    
    UIButton *arrowTemp3 = [[UIButton alloc] initWithFrame:CGRectMake(354, 380, 30, 20)];
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
    
    /*          inner container close       */
    
    
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

- (void)viewDidAppear:(BOOL)animated {
    [parentScrollView flashScrollIndicators];
}

- (void)viewDidLoad { 
    
    // create the dictionary of projects
    NSString *path = [[NSBundle mainBundle] pathForResource:@"projects" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    //self.projects = [dict objectForKey:@"projects"];
    self.projectsAll = [dict objectForKey:@"all"];
    self.projectsAR = [dict objectForKey:@"ar"];
    self.projectsTouch = [dict objectForKey:@"touch"];
    self.projectsTracking = [dict objectForKey:@"tracking"];
    self.projectsFeatured = [dict objectForKey:@"featured"];

    kNumberOfPagesTabThree = [self.projectsAll count] + 1;     // total pages = #projects + intro page
    
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
    
    self.horizontalView = nil;
    self.projectNavView = nil;
    
    self.verticalView1 = nil;
    self.verticalView2 = nil;
    self.verticalView3 = nil;
    self.verticalView4 = nil;
    
    self.projectsAll = nil;
    self.projectsAR = nil;
    self.projectsTouch = nil;
    self.projectsTracking = nil;
    self.projectsFeatured = nil;
    
    self.buttonTracking = nil;
    self.buttonTouch = nil;
    self.buttonAR = nil;
    self.buttonAll = nil;
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
    [horizontalView release];
    [projectNavView release];
    [verticalView1 release];
    [verticalView2 release];
    [verticalView3 release];
    [verticalView4 release];
    [projectsFeatured release];
    [projectsTouch release];
    [projectsTracking release];
    [projectsAR release];
    [projectsAll release];
    [buttonAll release];
    [buttonAR release];
    [buttonTouch release];
    [buttonTracking release];
    
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
    
    
    if (sender != parentScrollView)
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    pageControlUsed = NO;   // At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
    // -- reset frame if parent frame scrolls to a different tab
    
    if (scrollView == parentScrollView)
    {   
        CGRect frame = childScrollViewOne.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        
        // resets project intro page from nav page 
        if (childScrollViewThree.hidden == YES && parentScrollView.contentOffset.y != 2*parentScrollHeight  )        
            [self nextTransition:nil];
        
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
    
    if (childScrollViewThree.hidden == YES)
        [self nextTransition:nil];
    
    pageControlOne.currentPage = 0;
    pageControlTwo.currentPage = 0;
    pageControlThree.currentPage = 0;
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

-(void)performTransition
{
	CATransition *transition = [CATransition animation];
	transition.duration = 0.50;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	transitioning = YES;
	transition.delegate = self;
	
	// add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[childScrollViewThree.layer addAnimation:transition forKey:nil];
    [projectNavView.layer addAnimation:transition forKey:nil];
	
	if (projectNavView.hidden == YES)
    {
        childScrollViewThree.hidden = YES;
        pageControlThree.hidden = YES;
        //segmentedControl.hidden = YES;
        parentScrollView.scrollEnabled = NO;
        //home1.hidden = YES;
        //home2.hidden = YES;
        home3.hidden = YES;
        
        projectNavView.hidden = NO;
        
    }
    else
    {        
        projectNavView.hidden = YES;
        
        childScrollViewThree.hidden = NO;
        pageControlThree.hidden = NO;
        //segmentedControl.hidden = NO;
        parentScrollView.scrollEnabled = YES;
        //home1.hidden = NO;
        //home2.hidden = NO;
        home3.hidden = NO;
    }
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	transitioning = NO;
}

-(void)nextTransition:(id)sender
{
	if(!transitioning)
	{
		[self performTransition];
	}
}

- (void)scrollToPage:(id)sender {
    // Button tags are used to determine which button is pressed and what scrollview needs to be moved
   
    UIButton *button = (UIButton *)sender;
    
    CGRect frame = childScrollViewOne.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    
    if (button.tag == 802)                                              // EasyTableViewButton
    {
        int index = [button.currentTitle intValue];
        frame.origin.x = frame.size.width*index;
        
        [childScrollViewThree scrollRectToVisible:frame animated:NO];
        
        if (childScrollViewThree.hidden == YES)
        {
            [self nextTransition:self];
        }
    }
    else if (button.tag == 997)   {                                           // Home Buttons
        [childScrollViewOne scrollRectToVisible:frame animated:NO];
        pageControlOne.currentPage = 0;
    }
    else if (button.tag == 998) {
        [childScrollViewTwo scrollRectToVisible:frame animated:NO];
        pageControlTwo.currentPage = 0;
    }
    else if (button.tag == 999) {
        [childScrollViewThree scrollRectToVisible:frame animated:NO];
        pageControlThree.currentPage = 0;
    }
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
    else
    {
        NSLog(@"Reached unknown path in scrolltopage:");
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

#pragma mark -
#pragma mark EasyTableViewDelegate

// These delegate methods support both example views - first delegate method creates the necessary views

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect {
	
    if (easyTableView == horizontalView) {
        CGRect buttonRect = CGRectMake(5,5, 185, 185);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonRect;
        return button;
    }
    else
    {
        CGRect buttonRect = CGRectMake(0,0, 640, 200);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonRect;
        return button;
    }
}

// Second delegate populates the views with data from a data source

- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndex:(NSUInteger)index {

    if (easyTableView == horizontalView)
    {
        NSDictionary *navFeatured = [self.projectsFeatured objectAtIndex:index];
        
        UIButton *button = (UIButton *)view;
        [button setTitle:[navFeatured objectForKey:@"page"] forState:UIControlStateNormal] ;
        [button setImage:[UIImage imageNamed:[navFeatured objectForKey:@"featuredImage"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[navFeatured objectForKey:@"featuredImageHighlight"]] forState:UIControlStateHighlighted];
                
        [button addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (easyTableView == verticalView1)
    {
        NSDictionary *navAll = [self.projectsAll objectAtIndex:index];
        UIButton *button = (UIButton *)view;
        
        [button setTitle:[navAll objectForKey:@"page"] forState:UIControlStateNormal] ;
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

        [button setImage:[UIImage imageNamed:[navAll objectForKey:@"navImage"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[navAll objectForKey:@"navHighlight"]] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (easyTableView == verticalView2)
    {
        NSDictionary *navTouch = [self.projectsTouch objectAtIndex:index];
        UIButton *button = (UIButton *)view;
        
        [button setTitle:[navTouch objectForKey:@"page"] forState:UIControlStateNormal] ;
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:[navTouch objectForKey:@"navImage"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[navTouch objectForKey:@"navHighlight"]] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];

    }
    else if (easyTableView == verticalView3)
    {
        NSDictionary *navAR = [self.projectsAR objectAtIndex:index];
        UIButton *button = (UIButton *)view;
        
        [button setTitle:[navAR objectForKey:@"page"] forState:UIControlStateNormal] ;
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

        [button setImage:[UIImage imageNamed:[navAR objectForKey:@"navImage"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[navAR objectForKey:@"navHighlight"]] forState:UIControlStateHighlighted];

        [button addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];

    }
    else // easytableview == verticalview4
    {
        NSDictionary *navTracking = [self.projectsTracking objectAtIndex:index];
        UIButton *button = (UIButton *)view;
        
        [button setTitle:[navTracking objectForKey:@"page"] forState:UIControlStateNormal] ;
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

        [button setImage:[UIImage imageNamed:[navTracking objectForKey:@"navImage"]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[navTracking objectForKey:@"navHighlight"]] forState:UIControlStateHighlighted];

        [button addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];

    }
}


@end
