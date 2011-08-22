//
//  GridViewController.h
//  HeliosApp
//
//  Created by Tim Woo on 8/12/11.
//  Copyright 2011 Helios Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NickViewController;
@class MercedesViewController;

enum projectPage {
    nick, mercedes, none
};

@interface GridViewController : UIViewController
{
    UIScrollView *scrollView;
    enum projectPage currentProject;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NickViewController *nickViewController;
@property (nonatomic, retain) MercedesViewController *mercedesViewController;

- (void)setCurrentProjectPage:(enum projectPage)project;

@end
