//
//  LoginPopupViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 4/23/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "LoginPopupViewController.h"
#import "HomeViewController.h"
#import "Utilities.h"

@interface LoginPopupViewController ()

@end

@implementation LoginPopupViewController
@synthesize mainScrollView;
@synthesize loginView, loginPopupTitleLabel, loginUsernameTextField, loginPasswordTextField, closeButton;
@synthesize registerView, registerPopupTitleLabel, registernUsernameTextField, registerPasswordTextField, registerEmailTextField;
@synthesize forgotPasswordView, forgotPasswordPopupTitleLabel, forgotPasswordDetailsLabel, forgotEmailTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.view.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
    self.view.backgroundColor = [UIColor blackColor];
    [self registerForKeyboardNotifications];
    //scroll view init
    [mainScrollView setCanCancelContentTouches:NO];
	mainScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
	mainScrollView.clipsToBounds = YES;
	mainScrollView.scrollEnabled = NO;
	mainScrollView.pagingEnabled = NO;
	[mainScrollView setContentSize: CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
    
    //login view init
    loginView.hidden = YES;
    [loginPopupTitleLabel setFont:[UIFont fontWithName:@"marvin" size:25]];
    loginPopupTitleLabel.adjustsFontSizeToFitWidth = YES;
    loginPopupTitleLabel.shadowOffset = CGSizeMake(1, 1);
    loginPopupTitleLabel.shadowColor = [UIColor blackColor];
    loginUsernameTextField.placeholder = @"Username";
    loginPasswordTextField.placeholder = @"Password";
    
    //register view init
    registerView.hidden = YES;
    [registerPopupTitleLabel setFont:[UIFont fontWithName:@"marvin" size:25]];
    registerPopupTitleLabel.adjustsFontSizeToFitWidth = YES;
    registerPopupTitleLabel.shadowOffset = CGSizeMake(1, 1);
    registerPopupTitleLabel.shadowColor = [UIColor blackColor];
    registerEmailTextField.placeholder = @"Email address";
    registernUsernameTextField.placeholder = @"Username";
    registerPasswordTextField.placeholder = @"Password";
    
    //forgot password view init
    forgotPasswordView.hidden = YES;
    [forgotPasswordPopupTitleLabel setFont:[UIFont fontWithName:@"marvin" size:25]];
    forgotPasswordPopupTitleLabel.adjustsFontSizeToFitWidth = YES;
    forgotPasswordPopupTitleLabel.shadowOffset = CGSizeMake(1, 1);
    forgotPasswordPopupTitleLabel.shadowColor = [UIColor blackColor];
    forgotPasswordDetailsLabel.font = [Utilities fontWithName:nil minSize:10 maxSize:18 constrainedToSize:forgotPasswordDetailsLabel.frame.size forText:@"To reset your password, enter the username you use to register. This could be a Gmail address or another e-mail address that you assigned to your account"];
    forgotPasswordDetailsLabel.numberOfLines = 0;
    forgotPasswordDetailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    forgotEmailTextField.placeholder = @"Email address";
}

- (void)viewWillAppear:(BOOL)animated
{
    dismissView = NO;
    [self showLoginPopup];
    //loginUsernameTextField.text = @"mihai.puscas";
    //loginPasswordTextField.text = @"123qwe";
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// - (void)dealloc
//{
//    [mainScrollView release];
//    [loginView release];
//    [loginPopupTitleLabel release];
//    [loginUsernameTextField release];
//    [loginPasswordTextField release];
//    [closeButton release];
//    
//    [registerView release];
//    [registerPopupTitleLabel release];
//    [registernUsernameTextField release];
//    [registerPasswordTextField release];
//    [registerEmailTextField release];
//    
//    [forgotPasswordView release];
//    [forgotPasswordPopupTitleLabel release];
//    [forgotPasswordDetailsLabel release];
//    [forgotEmailTextField release];
//    
//    [super dealloc];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [APIManager cancelRequest];
}

- (void)showLoginPopup
{
    loginView.userInteractionEnabled = NO;
    loginView.hidden = NO;
    loginView.frame = CGRectMake(loginView.center.x, loginView.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        if([appDelegate isIPHONE5])
            loginView.frame = CGRectMake(37, 70+88, 274, 241);
        else
            loginView.frame = CGRectMake(37, 70, 274, 241);
    } completion:^(BOOL finished) {
        loginView.userInteractionEnabled = YES;
    }];
}

- (void)dismissLoginPopup
{
    loginView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        loginView.frame = CGRectMake(loginView.center.x, loginView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         loginView.userInteractionEnabled = YES;
         loginView.hidden = YES;
         if(dismissView)
//             [self dismissModalViewControllerAnimated:NO];
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

     }];
}

- (void)showRegisterPopup
{
    //registernUsernameTextField.text = @"mihai.puscas";
    //registerPasswordTextField.text = @"123qwe";
    //registerEmailTextField.text = @"mihai.puscas@lynxsolutions.eu";
    
    registerView.userInteractionEnabled = NO;
    registerView.hidden = NO;    
    registerView.frame = CGRectMake(registerView.center.x, registerView.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        if([appDelegate isIPHONE5])
            registerView.frame = CGRectMake(37, 70+88, 274, 241);
        else
            registerView.frame = CGRectMake(37, 70, 274, 241);
    } completion:^(BOOL finished) {
        registerView.userInteractionEnabled = YES;
    }];
}

- (void)dismissRegisterPopup
{
    registerView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        registerView.frame = CGRectMake(registerView.center.x, registerView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         registerView.userInteractionEnabled = YES;
         registerView.hidden = YES;
     }];
}

- (void)showForgotPasswordPopup
{
    forgotPasswordView.userInteractionEnabled = NO;
    forgotPasswordView.hidden = NO;
    forgotPasswordView.frame = CGRectMake(forgotPasswordView.center.x, forgotPasswordView.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        if([appDelegate isIPHONE5])
            forgotPasswordView.frame = CGRectMake(37, 70+88, 274, 241);
        else
            forgotPasswordView.frame = CGRectMake(37, 70, 274, 241);
    } completion:^(BOOL finished) {
        forgotPasswordView.userInteractionEnabled = YES;
    }];
}

- (void)dismissForgotPasswordPopup
{
    forgotPasswordView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        forgotPasswordView.frame = CGRectMake(forgotPasswordView.center.x, forgotPasswordView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         forgotPasswordView.userInteractionEnabled = YES;
         forgotPasswordView.hidden = YES;
     }];
}

#pragma mark - Buttons delegate

- (IBAction)loginButtonTUI:(id)sender
{
    if(keyboardShown)
    {
        [loginPasswordTextField becomeFirstResponder];
        [loginPasswordTextField resignFirstResponder];
    }
    //check if data filled
    if([loginUsernameTextField.text length] == 0 || [loginPasswordTextField.text length] == 0)
    {
        [appDelegate showAlert:@"Please complete all fields" CancelButton:nil OkButton:@"OK" Type:loginIncompleteInfoAlert Sender:self];
    }else
    {
        //api call
        [appDelegate showLoadingActivity];
        [APIManager setSender:self];
        [APIManager loginUser:loginUsernameTextField.text andPassword:loginPasswordTextField.text andDeviceID:appDelegate.userData.deviceID Version:appDelegate.version andTag:loginUserRequest];
    }
}

- (IBAction)registerButtonTUI:(id)sender
{
    if(keyboardShown)
    {
        [registerEmailTextField becomeFirstResponder];
        [registerEmailTextField resignFirstResponder];
    }
    //check if data filled
    if([registerEmailTextField.text length] == 0 || [registernUsernameTextField.text length] == 0 || [registerPasswordTextField.text length] == 0)
    {
        [appDelegate showAlert:@"Please complete all required fields" CancelButton:nil OkButton:@"OK" Type:registerIncompleteInfoAlert Sender:self];
    }else
    {
        //api call
        [appDelegate showLoadingActivity];
        [APIManager setSender:self];
        [APIManager registerUser:registernUsernameTextField.text andPassword:registerPasswordTextField.text andEmail:registerEmailTextField.text andDeviceID:appDelegate.userData.deviceID Version:appDelegate.version andTag:registerUserRequest];
    }
}

- (IBAction)submitButtonTUI:(id)sender
{
    if(keyboardShown)
    {
        [forgotEmailTextField resignFirstResponder];
    }
    //check if data filled
    if([forgotEmailTextField.text length] == 0)
    {
        [appDelegate showAlert:@"Please complete all required fields" CancelButton:nil OkButton:@"OK" Type:forgotPassIncompleteInfoAlert Sender:self];
    }else
    {
        //api call
        [appDelegate showLoadingActivity];
        [APIManager setSender:self];
        [APIManager forgotPassword:forgotEmailTextField.text andDeviceID:appDelegate.userData.deviceID Version:appDelegate.version andTag:forgotPassRequest];
    }
}

- (IBAction)registerUserButtonTUI:(id)sender
{
    NSLog(@"register pressed");
    if(keyboardShown)
    {
        [loginPasswordTextField becomeFirstResponder];
        [loginPasswordTextField resignFirstResponder];
    }else
    {
        [self dismissLoginPopup];
        [self showRegisterPopup];
    }
}
- (IBAction)forgotPasswordButtonTUI:(id)sender
{
        NSLog(@"forgot pressed");
    if(keyboardShown)
    {
        [loginPasswordTextField becomeFirstResponder];
        [loginPasswordTextField resignFirstResponder];
    }else
    {
        [self dismissLoginPopup];
        [self showForgotPasswordPopup];
    }
}

- (IBAction)loginCloseButtonTUI:(id)sender
{
    if(keyboardShown)
    {
        [loginPasswordTextField becomeFirstResponder];
        [loginPasswordTextField resignFirstResponder];
    }else
    {
        dismissView = YES;
        [self dismissLoginPopup];
    }
}

- (IBAction)registerCloseButtonTUI:(id)sender
{
    if(keyboardShown)
    {
        [registerEmailTextField becomeFirstResponder];
        [registerEmailTextField resignFirstResponder];
    }else
    {
        [self showLoginPopup];
        [self dismissRegisterPopup];
    }
}

- (IBAction)forgotCloseButtonTUI:(id)sender
{
    if(keyboardShown)
    {
        [forgotEmailTextField resignFirstResponder];
    }else
    {
        [self showLoginPopup];
        [self dismissForgotPasswordPopup];
    }
}

#pragma mark - TextFieldDelegates
- (IBAction)loginUsernameTextFieldDidEndOnExit:(id)sender
{
    [loginPasswordTextField becomeFirstResponder];
}

- (IBAction)loginPasswordTextFieldDidEndOnExit:(id)sender
{
    [loginPasswordTextField resignFirstResponder];
}

- (IBAction)forgotPasswordEmailTextFieldDidEndOnExit:(id)sender
{
    [forgotEmailTextField resignFirstResponder];
}

- (IBAction)registerUsernameTextFieldDidEndOnExit:(id)sender
{
    [registerPasswordTextField becomeFirstResponder];
}

- (IBAction)registerPasswordTextFieldDidEndOnExit:(id)sender
{
    [registerEmailTextField becomeFirstResponder];
}

- (IBAction)registerEmailTextFieldDidEndOnExit:(id)sender
{
    [registerEmailTextField resignFirstResponder];
}

#pragma mark - Keyboad Delegates
-(void)registerForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardWasHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.4 animations:^{
        [mainScrollView setContentSize: CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
    }];
	keyboardShown = NO;
}

-(void)keyboardWasShown:(NSNotification*)aNotification
{
	if (keyboardShown)
		return;
	NSDictionary* info = [aNotification userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
    
	[mainScrollView setContentSize: CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height+keyboardSize.height)];
	keyboardShown = YES;
    CGPoint bottomOffset;
    if(![appDelegate isIPHONE5])
        bottomOffset = CGPointMake(0, 65);
	[mainScrollView setContentOffset: bottomOffset animated: YES];
}

#pragma mark - Alert Delegates
- (void)alertOkBtnTUI:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        appDelegate.alertDialog.alpha = 0.0;
    }completion:^(BOOL finished) {
        [appDelegate.alertDialog removeFromSuperview];
        switch ([sender tag])
        {
            case registerIncompleteInfoAlert:
            {
                
            }
                break;
            case newVersionAlert:
            {
                [appDelegate showLoadingActivity];
                NSString *buyString = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",kAppID];
                NSURL *url = [[NSURL alloc] initWithString:buyString];
                [[UIApplication sharedApplication] openURL:url];
//                [url release];
            }
                break;
            case pushNotificationAlert:
            {
                //check if is not root
                if (appDelegate.window.rootViewController.presentedViewController != nil)
//                    [appDelegate.window.rootViewController dismissModalViewControllerAnimated:YES];
                    [appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

                else
                    [appDelegate.homeViewController viewDidAppear:NO];
            }
                break;
            case accountRegisterAlert:
            {
                if(keyboardShown)
                {
                    [registerEmailTextField becomeFirstResponder];
                    [registerEmailTextField resignFirstResponder];
                }else
                {
                    [self showLoginPopup];
                    [self dismissRegisterPopup];
                }
            }
                break;
            default:
                break;
        }
    }];
}

- (void)alertCancelBtnTUI:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        appDelegate.alertDialog.alpha = 0.0;
    }completion:^(BOOL finished) {
        [appDelegate.alertDialog removeFromSuperview];
        switch ([sender tag])
        {
            case pushNotificationAlert:
            {
                [appDelegate setPushNotificationDict:nil];
                //check if is not root
                //                if(self.window.rootViewController.presentedViewController == nil)
                //                    [homeViewController viewDidAppear:NO];
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - Asinc request delegate
//*****************ASIHTTP REQUEST DELEGATE************************************
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc]init];
    [responseDict setDictionary:[string JSONValue]];
//    [string release];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dict setValue:[NSNumber numberWithInteger:request.tag] forKey:@"request"];
    [dict setValue:responseDict forKey:@"response"];
    [dict setValue:[NSNumber numberWithBool:NO] forKey:@"timeout"];
//    [responseDict release];
    [APIManager releaseRequest];
    [self performSelectorOnMainThread:@selector(dataReceived:) withObject:dict waitUntilDone:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",[error userInfo]);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dict setValue:[NSNumber numberWithInteger:request.tag] forKey:@"request"];
    [dict setValue:[NSNumber numberWithBool:YES] forKey:@"timeout"];
    [APIManager releaseRequest];
    [self performSelectorOnMainThread:@selector(dataReceived:) withObject:dict waitUntilDone:NO];
}

-(void)saveFriendImage:(NSString*)picture_id
{
    [Utilities cacheImage:[NSString stringWithFormat:@"%@/socialgame/images/profile/%@", shareBaseUrl, picture_id]Filename:picture_id];
}


- (void)dataReceived:(NSDictionary*)dict
{
    [appDelegate hideLoadingActivity];
    switch ([[dict objectForKey:@"request"]integerValue])
    {
        case loginUserRequest:
        {//login user
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"]objectForKey:@"success"]boolValue])
                {
                    //save login info
                    [appDelegate.userData setToken:[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"token"]];
                    [appDelegate.userData setUsername:[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"username"]];
                    [appDelegate.userData setUserID:[[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"id"]intValue]];;
                    [appDelegate.userData setLoginType:[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"type"]];
                    [appDelegate.userData setCoins:[[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"coins"]intValue]];
                    [appDelegate.userData setUserphotourl:[[[dict objectForKey:@"response"] objectForKey:@"response"] objectForKey:@"picture"]];
                    if([[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"firstname"]length] == 0 &&
                       [[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"lastname"]length] == 0)
                        [appDelegate.userData setName:[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"username"]];
                    else                    
                        [appDelegate.userData setName:[NSString stringWithFormat:@"%@ %@",[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"firstname"], [[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"lastname"]]];
                    [appDelegate.userData setValidLogin:YES];
                    [Utilities saveUserInfo:appDelegate.userData];
                    //go to main screen
//                    [self dismissModalViewControllerAnimated:YES];
                    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                    
                    [self saveFriendImage:appDelegate.userData.userphotourl];

                    if(!appDelegate.reLogin)
                        [appDelegate hideLoginScreen];
                    else
                        [appDelegate hideReloginScreen];
                    return;
                }else
                {
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 1)
                    {
                        //Invalid validation_hash
                        [appDelegate showAlert:@"Something went wrong. Please try again." CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 62)
                    {
                        //new version
                        [appDelegate setUpdate:YES];
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"Update" Type:newVersionAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 12)
                    {
                        //invalid username/password
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:invalidUsernamePasswordAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 14)
                    {
                        //accound disabled
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:accountDisabledAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 5)
                    {
                        //Invalid device_id
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                        
                    }
                }
            }
        }
            break;
        case registerUserRequest:
        {//register
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //save info as login
                    [appDelegate.userData setToken:[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"token"]];
                    [appDelegate.userData setUsername:[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"username"]];;
                    [appDelegate.userData setUserID:[[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"id"]intValue]];;
                    [appDelegate.userData setLoginType:[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"type"]];
                    [appDelegate.userData setCoins:[[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"coins"]intValue]];
                    if([[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"firstname"]length] == 0 &&
                       [[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"lastname"]length] == 0)
                        [appDelegate.userData setName:[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"username"]];
                    else
                        [appDelegate.userData setName:[NSString stringWithFormat:@"%@ %@",[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"firstname"], [[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"lastname"]]];
                    [appDelegate.userData setValidLogin:YES];
                    [Utilities saveUserInfo:appDelegate.userData];
                    //go to main screen
//                    [self dismissModalViewControllerAnimated:YES];
                    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

                    if(!appDelegate.reLogin)
                        [appDelegate hideLoginScreen];
                    else
                        [appDelegate hideReloginScreen];
                    return;
                }else
                {
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 1)
                    {
                        //Invalid validation_hash
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 9)
                    {
                        //Username not available
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:usernameNotAvailableAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 32)
                    {
                        //Email not available.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:emailNotAvailableAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 14)
                    {
                        //accound disabled
                        [appDelegate showAlert:@"Successfully registered. Server will enable your account soon." CancelButton:nil OkButton:@"OK" Type:accountRegisterAlert Sender:self];
                    }
                }
            }
        }
            break;
        case forgotPassRequest:
        {//forgot password
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    [appDelegate showAlert:@"A new password was sent to your email address." CancelButton:nil OkButton:@"OK" Type:forgotPassSuccessAlert Sender:self];
                }else
                {
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 1)
                    {
                        //Invalid validation_hash
                        [appDelegate showAlert:@"Something went wrong. Please try again." CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 62)
                    {
                        //new version
                        [appDelegate setUpdate:YES];
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"Update" Type:newVersionAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 11)
                    {
                        //Invalid email
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:invalidEmailAlert Sender:self];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

@end
