//
//  SwitchViewController.m
//  HeliosApp
//
//  Created by Tim Woo on 8/12/11.
//  Copyright 2011 __Helios Interactive__. All rights reserved.
//

#import "SwitchViewController.h"
#import "HeliosAppViewController.h"
#import "GridViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation SwitchViewController
@synthesize heliosAppViewController;
@synthesize gridViewController;
@synthesize segmentedControl;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    NSLog(@"Im in switchviewcontroller memory warning");
    // Release any cached data, images, etc that aren't in use.
    
    if (self.heliosAppViewController.view.superview == nil)
    {
        NSLog(@"Im in remove heliosviewcontroller");
        NSLog(@"retain count 6 = %i",[heliosAppViewController retainCount]) ;

        self.heliosAppViewController = nil;           // crashes program
    }
    else
    {
        NSLog(@"Im in remove gridviewcontroller");
        NSLog(@"retain count grid 1 = %i",[gridViewController retainCount]) ;

		self.gridViewController = nil;
        NSLog(@"retain count grid 2 = %i",[gridViewController retainCount]) ;

    }
     
     
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    HeliosAppViewController *helioController = [[HeliosAppViewController alloc]
                                                initWithNibName:@"HeliosAppViewController" bundle:nil];
    self.heliosAppViewController = helioController;
    [self.view insertSubview:heliosAppViewController.view atIndex:0];
    [helioController release];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [gridViewController release];
    [heliosAppViewController release];
    
    [segmentedControl release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)switchViews:(id)sender
{
    segmentedControl.enabled = NO;
    
	CATransition *transition = [CATransition animation];
	transition.duration = 0.75;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
	transitioning = YES;
	transition.delegate = self;
    
    if (self.gridViewController.view.superview == nil)
    {
        //transition.subtype = kCATransitionFromBottom;
        [self.view.layer addAnimation:transition forKey:nil];
        
        if (self.gridViewController == nil)
        {
            NSLog(@"Creating gridviewcontroller");

            GridViewController *gridController =
            [[GridViewController alloc] initWithNibName:@"GridViewController"
                                                 bundle:nil];
            self.gridViewController = gridController;
            [gridController release];
        }
        
        [gridViewController viewWillAppear:YES];
        [heliosAppViewController viewWillDisappear:YES];
		
        [heliosAppViewController.view removeFromSuperview];
        [self.view insertSubview:gridViewController.view atIndex:0];
        [heliosAppViewController viewDidDisappear:YES];
        [gridViewController viewDidAppear:YES];
    }
    else
    {
        [self.view.layer addAnimation:transition forKey:nil];
        
		if (self.heliosAppViewController == nil)
		{
            NSLog(@"Creating heliosviewcontroller");

			HeliosAppViewController *helioController =
			[[HeliosAppViewController alloc] initWithNibName:@"HeliosAppViewController"
                                                      bundle:nil];
			self.heliosAppViewController = helioController;
			[helioController release];
		}
        
        [heliosAppViewController viewWillAppear:YES];
        [gridViewController viewWillDisappear:YES];
		
        [gridViewController.view removeFromSuperview];
        [self.view insertSubview:heliosAppViewController.view atIndex:0];
        [gridViewController viewDidDisappear:YES];
        [heliosAppViewController viewDidAppear:YES];
    }
    
    segmentedControl.enabled = YES;
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	transitioning = NO;
}


@end
