//
//  LoginViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 4/23/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LoginPopupViewController.h"

#import <FacebookSDK/FacebookSDK.h>

@class AppDelegate;

@interface LoginViewController : UIViewController<FBLoginViewDelegate>
{
    AppDelegate *appDelegate;
    
    FBLoginView *loginview;
    BOOL clearFbTokens;
    BOOL FbLoginBegin;
   
}
@property (nonatomic, strong) IBOutlet UIImageView *backgroundIV;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *facebookLoginButton;

@property (nonatomic, strong) FBLoginView *loginview;
@property (strong, nonatomic) id<FBGraphUser> fbGraphUser;
@property (nonatomic, assign) BOOL FbLoginBegin;

- (IBAction)loginButtonTUI:(id)sender;
- (IBAction)facebookLoginButtonTUI:(id)sender;
- (void)facebookLogin;

@end
