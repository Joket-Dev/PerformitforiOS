//
//  LoginPopupViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 4/23/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class AppDelegate;
@interface LoginPopupViewController : UIViewController
{
    AppDelegate *appDelegate;
    BOOL dismissView;
    BOOL keyboardShown;
    int requestStatus;
    
}
@property (nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) IBOutlet UIView *loginView;
@property (nonatomic, strong) IBOutlet UILabel *loginPopupTitleLabel;
@property (nonatomic, strong) IBOutlet UITextField *loginUsernameTextField;
@property (nonatomic, strong) IBOutlet UITextField *loginPasswordTextField;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;

@property (nonatomic, strong) IBOutlet UIView *registerView;
@property (nonatomic, strong) IBOutlet UILabel *registerPopupTitleLabel;
@property (nonatomic, strong) IBOutlet UITextField *registernUsernameTextField;
@property (nonatomic, strong) IBOutlet UITextField *registerPasswordTextField;
@property (nonatomic, strong) IBOutlet UITextField *registerEmailTextField;

@property (nonatomic, strong) IBOutlet UIView *forgotPasswordView;
@property (nonatomic, strong) IBOutlet UILabel *forgotPasswordPopupTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *forgotPasswordDetailsLabel;
@property (nonatomic, strong) IBOutlet UITextField *forgotEmailTextField;


- (IBAction)loginCloseButtonTUI:(id)sender;
- (IBAction)registerCloseButtonTUI:(id)sender;
- (IBAction)forgotCloseButtonTUI:(id)sender;

- (IBAction)loginButtonTUI:(id)sender;
- (IBAction)registerUserButtonTUI:(id)sender;
- (IBAction)forgotPasswordButtonTUI:(id)sender;

@end
