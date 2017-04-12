//
//  SplashViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 4/23/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class AppDelegate;
@interface SplashViewController : UIViewController
{
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) IBOutlet UIImageView *backgroundIV;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;


- (void)dismissSplash:(id)sender;

@end
