//
//  GridViewController.m
//  HeliosApp
//
//  Created by Tim Woo on 8/12/11.
//  Copyright 2011 Helios Interactive. All rights reserved.
//

// All projects must be named in the format p%i.png and p%iH.png
// kGridRows must be updated to correct number of projects

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

- (void)didReceiveMemoryWarning
{
    NSLog(@"Grid Memory warning");

    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    currentProject = none;
    
    scrollView.contentSize = CGSizeMake(768, kGridRows*312);
    
    // Add the projects to the scrollview.
    
    for (int i=1;i<=kGridRows;i++)
    {
        NSString *image = [[NSString alloc] initWithFormat:@"p%i.png",i];
        NSString *imageHighlighted = [[NSString alloc] initWithFormat:@"p%iH.png",i];

        UIButton *projectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (i-1)*312, 768, 312)];
        [projectButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [projectButton setImage:[UIImage imageNamed:imageHighlighted] forState:UIControlStateHighlighted];
        projectButton.tag = i; 
        [projectButton addTarget:self action:@selector(pushProjectView:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:projectButton];
        [projectButton release];
    }
    
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
    transition.duration = .30;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];

    UIButton *button = (UIButton *)sender;

    switch (button.tag) 
    {
        case 1:
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
            break;
            
        case 2:
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
            break;
            
        default:
            
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
            break;
    }
}

- (void)setCurrentProjectPage:(enum projectPage)project
{
    currentProject = project;
}
@end
