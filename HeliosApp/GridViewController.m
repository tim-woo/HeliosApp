//
//  GridViewController.m
//  HeliosApp
//
//  Created by Tim Woo on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GridViewController.h"
#import "NickViewController.h"
#import "MercedesViewController.h"

#import <QuartzCore/QuartzCore.h>
static NSUInteger kGridRows = 5;



@interface GridViewController (PrivateMethods)

- (void)pushProjectView:(id)sender;
@end

@implementation GridViewController
@synthesize nickViewController, scrollView, mercedesViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    /*
    if (self.nickViewController != nil && self.nickViewController.view.hidden == YES)
    {
        NSLog(@"In did recieve memory warning");
        //[self.nickViewController.view removeFromSuperview];
        //self.nickViewController = nil;
    }*/
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    currentProject = none;
    
    scrollView.contentSize = CGSizeMake(768, kGridRows*312);

    // row 1
    UIButton *tileNick = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 768, 312)];
    [tileNick setImage:[UIImage imageNamed:@"projectNick.png"] forState:UIControlStateNormal];
    [tileNick setImage:[UIImage imageNamed:@"projectNick.png"] forState:UIControlStateHighlighted];
    tileNick.tag = 1; 
    [tileNick addTarget:self action:@selector(pushProjectView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:tileNick];
    [tileNick release];
    
    // row 2
    UIButton *tileEmpty = [[UIButton alloc] initWithFrame:CGRectMake(0, 312, 768, 312)];
    [tileEmpty setImage:[UIImage imageNamed:@"project2.png"] forState:UIControlStateNormal];
    [tileEmpty setImage:[UIImage imageNamed:@"project2.png"] forState:UIControlStateHighlighted];
    tileEmpty.tag = 2; 
    [tileEmpty addTarget:self action:@selector(pushProjectView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:tileEmpty];
    [tileEmpty release];
    
    // row 3
    UIButton *tileEmpty3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 2*312, 768, 312)];
    [tileEmpty3 setImage:[UIImage imageNamed:@"project3.png"] forState:UIControlStateNormal];
    [tileEmpty3 setImage:[UIImage imageNamed:@"project3.png"] forState:UIControlStateHighlighted];
    tileEmpty3.tag = 1; 
    [tileEmpty3 addTarget:self action:@selector(pushProjectView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:tileEmpty3];
    [tileEmpty3 release];
    
    // row 4
    UIButton *tileEmpty5 = [[UIButton alloc] initWithFrame:CGRectMake(0, 3*312, 768, 312)];
    [tileEmpty5 setImage:[UIImage imageNamed:@"project4.png"] forState:UIControlStateNormal];
    [tileEmpty5 setImage:[UIImage imageNamed:@"project4.png"] forState:UIControlStateHighlighted];
    tileEmpty5.tag = 1; 
    [tileEmpty5 addTarget:self action:@selector(pushProjectView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:tileEmpty5];
    [tileEmpty5 release];
    
    // row 5
    UIButton *tileEmpty6 = [[UIButton alloc] initWithFrame:CGRectMake(0, 4*312, 768, 312)];
    [tileEmpty6 setImage:[UIImage imageNamed:@"projectIntel.png"] forState:UIControlStateNormal];
    [tileEmpty6 setImage:[UIImage imageNamed:@"projectIntel.png"] forState:UIControlStateHighlighted];
    tileEmpty6.tag = 1; 
    [tileEmpty6 addTarget:self action:@selector(pushProjectView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:tileEmpty6];
    [tileEmpty6 release];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMercedesViewController:nil];
    [self setNickViewController:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"Grid viewwillDisappear");

    if (currentProject == nick)
    {
        NSLog(@"    -- in nick project page");
        [nickViewController viewWillDisappear:YES];
    }
    else if (currentProject == mercedes)
    {
        NSLog(@"    -- in mercedes project page");
        [mercedesViewController viewWillDisappear:YES];
    }
    else
    {
        NSLog(@"    -- in NO project page");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Grid viewWillAppear");
    
    if (currentProject == nick)
    {
        NSLog(@"       -- in project page");
        [nickViewController viewWillAppear:YES];
    }
    else if (currentProject == mercedes)
    {
        [mercedesViewController viewWillAppear:YES];
    }
    else
    {
     NSLog(@"       -- NOT in project page");
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [mercedesViewController release];
    [nickViewController release];
    [scrollView release];
    [super dealloc];
}

- (void)pushProjectView:(id)sender
{    
    CATransition *transition = [CATransition animation];
    transition.duration = .50;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];

    UIButton *button = (UIButton *)sender;

    if (button.tag == 1)
    {
       self.mercedesViewController = nil;

        if (self.nickViewController == nil)
        {
            NickViewController *nickController = [[NickViewController alloc] initWithNibName:@"NickViewController" bundle:nil];
            nickController.gridController = self;
            self.nickViewController = nickController;
            [nickController release];
        }
        [self viewWillDisappear:YES];
        [nickViewController viewWillAppear:YES];

        [self.view addSubview:nickViewController.view];
    
        [self viewDidDisappear:YES];
        [nickViewController viewDidAppear:YES];
        
        currentProject = nick;
    }
    else if (button.tag == 2)
    {
       self.nickViewController = nil;

        if (self.mercedesViewController == nil)
        {
            MercedesViewController *mercedes = [[MercedesViewController alloc] initWithNibName:@"MercedesViewController" bundle:nil];
            mercedes.gridController = self;
            self.mercedesViewController = mercedes;
            [mercedes release];
        }
        [self viewWillDisappear:YES];
        [mercedesViewController viewWillAppear:YES];
        
        [self.view addSubview:mercedesViewController.view];
        
        [self viewDidDisappear:YES];
        [mercedesViewController viewDidAppear:YES];
        
        currentProject = mercedes;
    }
}

- (void)setCurrentProjectPage:(enum projectPage)project
{
    currentProject = project;
}
@end
