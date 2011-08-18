//
//  HeliosAppViewController.m
//  HeliosApp
//
//  Created by Tim Woo on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HeliosAppViewController.h"
#import <QuartzCore/QuartzCore.h>

static NSUInteger numberOfTabs = 3;

static NSUInteger kNumberOfPagesTabOne = 4;
static NSUInteger kNumberOfPagesTabTwo = 5;
static NSUInteger kNumberOfPagesTabThree = 1;

static NSUInteger parentScrollViewOffsetTop = 64;
//static NSUInteger parentScrollViewOffsetBottom = 64;
static NSUInteger parentScrollViewOffsetLeft = 0;
static CGFloat parentScrollHeight = 1004-64-64;


// Offset is with respect to the parent scrollview
static NSUInteger childScrollViewOffsetLeft = 15;
static NSUInteger childScrollViewOffsetTop = 15;
static NSUInteger childScrollViewHeight = 846;
static NSUInteger childScrollViewWidth = 738;

static NSUInteger pageControlOffsetTop = 820;


@interface HeliosAppViewController (PrivateMethods)

- (void)loadScrollView:(UIScrollView *)scrollView 
        WithPageNumber:(int)page 
            TotalPages:(int)totalPages 
        ImageViewArray:(NSMutableArray *)imageViewArray;
/*- (void)cleanScrollView:(UIScrollView *)scrollView 
          AtCurrentPage:(int)currentPage 
         WithTotalPages:(int)totalPages
         ImageViewArray:(NSMutableArray *)imageViewArray;
*/
- (void)scrollToPage:(id)sender;
@end


@implementation HeliosAppViewController
@synthesize segmentedControl, parentScrollView, childScrollViewOne, childScrollViewTwo, childScrollViewThree,
            pageControlOne,pageControlTwo, pageControlThree, aboutList, imageViewsAbout, imageViewsTech, imageViewsProjects,
            home1,home2,home3;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
- (void)awakeFromNib
{
	// load our data from a plist file inside our app bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aboutViews" ofType:@"plist"];
    self.aboutList = [NSArray arrayWithContentsOfFile:path];
}
 */

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Main App view will appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"Main App view will disappear");
}
- (void)viewDidAppear:(BOOL)animated
{
    [parentScrollView flashScrollIndicators];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    // outer container
    
    // -- create outer scroll view
    
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
    
    // -- create outer uiviews
    UIView *tabOne = [[UIView alloc] initWithFrame:CGRectMake(parentScrollViewOffsetLeft, 0*parentScrollHeight, self.view.frame.size.width, parentScrollHeight)];
    UIView *tabTwo = [[UIView alloc] initWithFrame:CGRectMake(parentScrollViewOffsetLeft, 1*parentScrollHeight, self.view.frame.size.width, parentScrollHeight)];
    UIView *tabThree = [[UIView alloc] initWithFrame:CGRectMake(parentScrollViewOffsetLeft, 2*parentScrollHeight, self.view.frame.size.width, parentScrollHeight)];

    
    // -- inner container start
       
    // -----------
    //  TAB ONE
    // -----------
    
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
        pageControlOne = [[UIPageControl alloc] initWithFrame:CGRectMake(0,pageControlOffsetTop,768,36)];
        pageControlOne.numberOfPages = kNumberOfPagesTabOne;
        pageControlOne.currentPage = 0;
        [pageControlOne addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [tabOne addSubview:pageControlOne];
    
    // ----------
    //  TAB TWO
    // ----------
    
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
        pageControlTwo = [[UIPageControl alloc] initWithFrame:CGRectMake(0,pageControlOffsetTop,768,36)];
        pageControlTwo.numberOfPages = kNumberOfPagesTabTwo;
        pageControlTwo.currentPage = 0;
        [pageControlTwo addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [tabTwo addSubview:pageControlTwo];
    
    
    // ----------
    //  TAB THREE
    // ----------
    
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
    
    // --- add page control to tab 2
    pageControlThree = [[UIPageControl alloc] initWithFrame:CGRectMake(0,pageControlOffsetTop,768,36)];
    pageControlThree.numberOfPages = kNumberOfPagesTabThree;
    pageControlThree.currentPage = 0;
    [pageControlThree addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [tabThree addSubview:pageControlThree];
        
    
    // ------------------------------------------------
    // Buttons to flip view (in all child scroll views)
    // ------------------------------------------------
    
    // button example project flip
    CGFloat pageOfButton = 1;
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(pageOfButton*childScrollViewWidth+32, 98, 290, 320)] autorelease];
    //button.backgroundColor = [UIColor blueColor];
    
    NSLog(@"retain count b1 = %i",[button retainCount]) ;

    [button addTarget:self action:@selector(nextTransition:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"retain count b2 = %i",[button retainCount]) ;

    [childScrollViewOne addSubview:button];
    NSLog(@"retain count b3 = %i",[button retainCount]) ;

    //[button release];
     NSLog(@"retain count b4 = %i",[button retainCount]) ;
    
    // button what we do
    UIButton *button3 = [[[UIButton alloc] initWithFrame:CGRectMake(110, 690, 130, 40)] autorelease];
    [button3 setImage:[UIImage imageNamed:@"button-WhatWeDo.png"] forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"buttonWhatWeDoHighlight"] forState:UIControlStateHighlighted];
     button3.tag = 11;
    [button3 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewOne addSubview:button3];
    
    // button what we bring
    UIButton *button4 = [[[UIButton alloc] initWithFrame:CGRectMake(280, 690, 130, 40)] autorelease];
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
    
    // button Touch
    UIButton *button6 = [[[UIButton alloc] initWithFrame:CGRectMake(110, 620, 130, 60)] autorelease];
    [button6 setImage:[UIImage imageNamed:@"buttonTouch.png"] forState:UIControlStateNormal];
    [button6 setImage:[UIImage imageNamed:@"buttonTouchHighlight.png"] forState:UIControlStateHighlighted];
    button6.tag = 21;
    [button6 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewTwo addSubview:button6];
    
    // button 3D
    UIButton *button7 = [[[UIButton alloc] initWithFrame:CGRectMake(280, 620, 130, 60)] autorelease];
    [button7 setImage:[UIImage imageNamed:@"button3d.png"] forState:UIControlStateNormal];
    [button7 setImage:[UIImage imageNamed:@"button3dHighlight.png"] forState:UIControlStateHighlighted];
    button7.tag = 22;
    [button7 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewTwo addSubview:button7];
    
    // button AR
    UIButton *button8 = [[[UIButton alloc] initWithFrame:CGRectMake(450, 620, 130, 60)] autorelease];
    [button8 setImage:[UIImage imageNamed:@"buttonAR.png"] forState:UIControlStateNormal];
    [button8 setImage:[UIImage imageNamed:@"buttonARHighlight.png"] forState:UIControlStateHighlighted];
    button8.tag = 23;
    [button8 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewTwo addSubview:button8];
    
    // button Mobile
    UIButton *button9 = [[[UIButton alloc] initWithFrame:CGRectMake(280, 700, 130, 60)] autorelease];
    [button9 setImage:[UIImage imageNamed:@"buttonMobile.png"] forState:UIControlStateNormal];
    [button9 setImage:[UIImage imageNamed:@"buttonMobileHighlight.png"] forState:UIControlStateHighlighted];
    button9.tag = 24;
    [button9 addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    [childScrollViewTwo addSubview:button9];
    
    
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
    
    // -- inner container close
    
    [parentScrollView addSubview:tabOne];
    [parentScrollView addSubview:tabTwo];
    [parentScrollView addSubview:tabThree];

    [tabOne release];
    [tabTwo release];
    [tabThree release];
    
    
    // Add home buttons
    UIButton *home1temp = [[UIButton alloc] initWithFrame:CGRectMake(640, 15, 130, 40)];
    [home1temp setImage:[UIImage imageNamed:@"buttonHome.png"] forState:UIControlStateNormal];
    [home1temp setImage:[UIImage imageNamed:@"buttonHomeHighlight"] forState:UIControlStateHighlighted];
    home1temp.tag = 97;
    [home1temp addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    home1 = home1temp;
    [parentScrollView addSubview:home1];
    [home1temp release];

    UIButton *home2t = [[UIButton alloc] initWithFrame:CGRectMake(640, parentScrollHeight+15, 130, 40)];
    [home2t setImage:[UIImage imageNamed:@"buttonHome.png"] forState:UIControlStateNormal];
    [home2t setImage:[UIImage imageNamed:@"buttonHomeHighlight"] forState:UIControlStateHighlighted];
    home2t.tag = 98;
    [home2t addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    home2 = home2t;
    [parentScrollView addSubview:home2];
    [home2t release];

    UIButton *home3t = [[UIButton alloc] initWithFrame:CGRectMake(640, parentScrollHeight*2+15, 130, 40)];
    [home3t setImage:[UIImage imageNamed:@"buttonHome.png"] forState:UIControlStateNormal];
    [home3t setImage:[UIImage imageNamed:@"buttonHomeHighlight"] forState:UIControlStateHighlighted];
    home3t.tag = 99;
    [home3t addTarget:self action:@selector(scrollToPage:) forControlEvents:UIControlEventTouchUpInside];
    home3 = home3t;
    [parentScrollView addSubview:home3];
    [home3t release];

    [self.view addSubview:parentScrollView];
    

    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
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
    [self setAboutList:nil];
    [self setImageViewsAbout:nil];
    [self setImageViewsTech:nil];
    [self setImageViewsProjects:nil];
    [self setHome1:nil];
    [self setHome2:nil];
    [self setHome3:nil];
}

- (void)dealloc {
    [parentScrollView release];
    [childScrollViewOne release];
    [childScrollViewTwo release];
    [childScrollViewThree release];
    [pageControlOne release];
    [pageControlTwo release];
    [pageControlThree release];
    [aboutList release];
    [imageViewsAbout release];
    [imageViewsTech release];
    [imageViewsProjects release];
    [segmentedControl release];
    [home1 release];
    [home2 release];
    [home3 release];

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
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
 

- (void)loadScrollView:(UIScrollView *)scrollView WithPageNumber:(int)page TotalPages:(int)totalPages ImageViewArray:(NSMutableArray *)imageViewArray
{
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
            theImageName = [NSString stringWithFormat:@"childScrollerAbout%i.png",page];
        else if (scrollView == childScrollViewTwo)
            theImageName = [NSString stringWithFormat:@"childScrollerTech%i.png",page];
        else // if (scrollView == childScrollViewThree)
            theImageName = [NSString stringWithFormat:@"childScrollerProjects%i.png",page];

        CGFloat xOrigin = childScrollViewWidth * page;
        UIImageView *anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:theImageName]];
        anImageView.frame = CGRectMake(xOrigin, 0, childScrollViewWidth, childScrollViewHeight);
        anImageView.tag = page;
        
        [imageViewArray replaceObjectAtIndex:page withObject:anImageView];

        [scrollView addSubview:anImageView];
        [anImageView release];
    }
    
    // add the controller's view to the scroll view
    /*
    if (controller.view.superview == nil)
    {
        CGRect frame = childScrollViewOne.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        anImageView.frame = frame;
        [childScrollViewOne addSubview:anImageView];
        
        NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        controller.numberImage.image = [UIImage imageNamed:[numberItem valueForKey:ImageKey]];
        controller.numberTitle.text = [numberItem valueForKey:NameKey];
    }
     */
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
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
        else // if (sender == childScrollViewThree)
        {
            totalPages = kNumberOfPagesTabTwo;
            imageViewArray = imageViewsTech;
        }
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
        [self loadScrollView:sender WithPageNumber:page - 1 TotalPages:totalPages ImageViewArray:imageViewArray];
        [self loadScrollView:sender WithPageNumber:page     TotalPages:totalPages ImageViewArray:imageViewArray];
        [self loadScrollView:sender WithPageNumber:page + 1 TotalPages:totalPages ImageViewArray:imageViewArray];
    }
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
   
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}


// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
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
        }
        else if (parentScrollView.contentOffset.y == parentScrollHeight)
        {         
            segmentedControl.selectedSegmentIndex = kSwitchesSegmentTech;
            [childScrollViewOne scrollRectToVisible:frame animated:NO];
            [childScrollViewThree scrollRectToVisible:frame animated:NO];
        }
        else if (parentScrollView.contentOffset.y == 2*parentScrollHeight)
        {
            segmentedControl.selectedSegmentIndex = kSwitchesSegmentProjects;
            [childScrollViewTwo scrollRectToVisible:frame animated:NO];
            [childScrollViewOne scrollRectToVisible:frame animated:NO];
             
        }
    }
    
    pageControlUsed = NO;
}


- (IBAction)toggleSwitch:(id) sender
{
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
    else
        [childScrollViewThree scrollRectToVisible:frameChild animated:NO];
}


- (IBAction)changePage:(id)sender
{
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
    
    [self loadScrollView:theChildScrollView WithPageNumber:page - 1 TotalPages:totalPages ImageViewArray:imageViewArray];
    [self loadScrollView:theChildScrollView WithPageNumber:page     TotalPages:totalPages ImageViewArray:imageViewArray];
    [self loadScrollView:theChildScrollView WithPageNumber:page + 1 TotalPages:totalPages ImageViewArray:imageViewArray];
    
    pageControlUsed = YES;
}

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

- (void)scrollToPage:(id)sender
{
    NSLog(@"In scrolltopage");
    UIButton *button = (UIButton *)sender;
    CGRect frame = childScrollViewOne.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    if (button.tag == 97)
        [childScrollViewOne scrollRectToVisible:frame animated:YES];
    else if (button.tag == 98)
        [childScrollViewTwo scrollRectToVisible:frame animated:YES];
    else if (button.tag == 99)
        [childScrollViewThree scrollRectToVisible:frame animated:YES];
    else if (button.tag > 10 && button.tag < 20)
    {
        frame.origin.x = frame.size.width * (button.tag-10);
        [childScrollViewOne scrollRectToVisible:frame animated:YES];
    }
    else if (button.tag > 20 && button.tag < 30)
    {
        frame.origin.x = frame.size.width * (button.tag-20);
        [childScrollViewTwo scrollRectToVisible:frame animated:YES];
    }
    else
    {
        frame.origin.x = frame.size.width * (button.tag-30);
        [childScrollViewThree scrollRectToVisible:frame animated:YES];
    }
    
    pageControlUsed = NO;
}

@end
