//
//  NickViewController.m
//  HeliosApp
//
//  Created by Tim Woo on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MercedesViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation MercedesViewController
@synthesize player, gridController;

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
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"Mercedes ViewdidLoad");
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterFullscreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    NSLog(@"in viewdiedunload");
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.player = nil;
    self.gridController = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"Mercedes viewwilldisappear");
    [player pause];
    self.player = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Mercedes viewwillAppear");
    
    //------ MOVIE PLAYER
    //---get movie, set up notifications ----
    NSString *url = [[NSBundle mainBundle] 
                     pathForResource:@"mercedes" 
                     ofType:@"mov"];
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] 
                                            initWithContentURL:[NSURL fileURLWithPath:url]];
    self.player = moviePlayer;
    [moviePlayer release];

    //---play partial screen---
    player.view.frame = CGRectMake(0, 64, 768, 433);
    [self.view addSubview:player.view];
    
    //---play movie---
    [player play];
    
}
- (void)dealloc
{
    [player release];
    [gridController release];
    [super dealloc];
}


#pragma mark -
#pragma mark MPMoviePlayerNotifications

- (void)willEnterFullscreen:(NSNotification*)notification {
    NSLog(@"willEnterFullscreen");
}

- (void)enteredFullscreen:(NSNotification*)notification {
    NSLog(@"enteredFullscreen");
}

- (void)willExitFullscreen:(NSNotification*)notification {
    NSLog(@"willExitFullscreen");
}

- (void)exitedFullscreen:(NSNotification*)notification {
    NSLog(@"exitedFullscreen");
    //[player.view removeFromSuperview];
    //player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playbackFinished:(NSNotification*)notification {
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackFinished. Reason: Playback Ended");         
            break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"playbackFinished. Reason: Playback Error");
            break;
        case MPMovieFinishReasonUserExited:
            NSLog(@"playbackFinished. Reason: User Exited");
            break;
        default:
            break;
    }
    [player setFullscreen:NO animated:YES];
}



- (IBAction)removeSelfFromWindow:(id)sender
{
    [gridController setCurrentProjectPage:none];

    CATransition *transition = [CATransition animation];
    transition.duration = .30;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.view.superview.layer addAnimation:transition forKey:nil];
    
    [self viewWillDisappear:YES];
    [gridController viewWillAppear:YES];
    
    [self.view removeFromSuperview];
    
    [self viewDidDisappear:YES];
    [gridController viewDidAppear:YES];
    
    
}

@end
