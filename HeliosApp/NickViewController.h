//
//  NickViewController.h
//  HeliosApp
//
//  Created by Tim Woo on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class GridViewController;

@interface NickViewController : UIViewController
{
    MPMoviePlayerController *player;
    GridViewController *gridController;
}
@property (retain, nonatomic) MPMoviePlayerController *player;
@property (retain, nonatomic)     GridViewController *gridController;

- (IBAction)removeSelfFromWindow:(id)sender;

@end
