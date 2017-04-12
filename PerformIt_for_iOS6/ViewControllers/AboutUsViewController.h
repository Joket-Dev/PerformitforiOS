//
//  AboutUsViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 20/11/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

@class AppDelegate;
@interface AboutUsViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    AppDelegate *appDelegate;

}
@property (nonatomic, strong) IBOutlet UIImageView *backgroundIV;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) IBOutlet UIScrollView *mainScrollView;

- (IBAction)homeButtonTUI:(id)sender;

@end
