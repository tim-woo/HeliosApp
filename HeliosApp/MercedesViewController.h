//
//  MercedesViewController.h
//  HeliosApp
//
//  Created by Tim Woo on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GridViewController.h"

@class GridViewController;

@interface MercedesViewController : UIViewController
{
    MPMoviePlayerController *player;
    GridViewController *gridController;
}
@property (retain, nonatomic) MPMoviePlayerController *player;
@property (retain, nonatomic) GridViewController *gridController;

- (IBAction)removeSelfFromWindow:(id)sender;

@end
