//
//  GridViewController.h
//  HeliosApp
//
//  Created by Tim Woo on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
   // BOOL inProjectPage;
    enum projectPage currentProject;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet NickViewController *nickViewController;
@property (nonatomic, retain) IBOutlet MercedesViewController *mercedesViewController;
- (IBAction)pushProjectView:(id)sender;
- (void)setCurrentProjectPage:(enum projectPage)project;

@end
