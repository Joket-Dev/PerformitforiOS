//
//  LoginViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 4/23/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "LoginViewController.h"

#import "RecordWordViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize backgroundIV;
@synthesize loginButton, facebookLoginButton;
@synthesize loginview;
@synthesize fbGraphUser;
@synthesize FbLoginBegin;

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
    if ([appDelegate isIPHONE5])
    {
        backgroundIV.image = [UIImage imageNamed:@"login-bg-568h@2x.png"];
        backgroundIV.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        loginButton.frame = CGRectMake(loginButton.frame.origin.x, loginButton.frame.origin.y-20, loginButton.frame.size.width, loginButton.frame.size.height);
        facebookLoginButton.frame = CGRectMake(facebookLoginButton.frame.origin.x, facebookLoginButton.frame.origin.y-20, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
    }
    facebookLoginButton.hidden = YES;
    loginview = [[FBLoginView alloc] init];
    loginButton.exclusiveTouch = YES;
    [self.view addSubview:loginview];
    
    clearFbTokens = YES;
    [self setFbLoginBegin: NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    loginview.frame = facebookLoginButton.frame;
    loginview.layer.cornerRadius = facebookLoginButton.frame.size.width/2;
    for (id obj in loginview.subviews)
    {
        NSLog(@"%@",obj);
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * button =  obj;
            button.exclusiveTouch = YES;
            [button addTarget:self action:@selector(facebookButtonTD:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
            [button setImage:[UIImage imageNamed:@"facebook-login-button.png"] forState:UIControlStateNormal];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
        }
    }


    loginview.delegate = self;
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (void)dealloc
//{
//    [backgroundIV release];
//    [loginButton release];
//    [facebookLoginButton release];
//    [loginview release];
//    [fbGraphUser release];
//    
//    [super dealloc];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [APIManager cancelRequest];
    loginview.delegate = nil;
}


- (IBAction)loginButtonTUI:(id)sender
{
    LoginPopupViewController *loginPopupViewController = [[LoginPopupViewController alloc]initWithNibName:@"LoginPopupViewController" bundle:nil];
//    appDelegate.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
//    [self presentModalViewController:loginPopupViewController animated:NO];
    [self presentViewController:loginPopupViewController animated:NO completion:nil];
//    [loginPopupViewController release];

    
//    [appDelegate showLoadingActivity];
//    [APIManager setSender:self];
//    [APIManager loginFB:@"aaa" andDeviceID:@"abcd" Version:appDelegate.version andTag:loginFBRequest];
}

- (IBAction)facebookLoginButtonTUI:(id)sender
{

    //[appDelegate showLoadingActivity];
    //[appDelegate openSessionWithAllowLoginUI:YES];
}

- (void)facebookLogin
{
    //api call
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    [APIManager loginFB:appDelegate.userData.facebookID andDeviceID:appDelegate.userData.deviceID Version:appDelegate.version andTag:loginFBRequest];
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

- (void)dataReceived:(NSDictionary*)dict
{
    [appDelegate hideLoadingActivity];
    switch ([[dict objectForKey:@"request"]integerValue])
    {
        case loginFBRequest:
        {//login FB
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 5)
                    {
                        //Invalid device_id
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 7)
                    {
                        //Could not connect with facebook
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:facebookConnectErrorAlert Sender:self];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - FBLoginViewDelegate
- (void)facebookButtonTD:(id)sender
{
    for (id obj in loginview.subviews)
    {
        NSLog(@"%@",obj);
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * button =  obj;
            button.exclusiveTouch = YES;
            [button addTarget:self action:@selector(facebookButtonTD:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
            [button setImage:[UIImage imageNamed:@"facebook-login-button.png"] forState:UIControlStateNormal];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
        }
    }
    [appDelegate showLoadingActivity];
    NSLog(@"touch down");
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * button =  obj;
            button.exclusiveTouch = YES;
            [button addTarget:self action:@selector(facebookButtonTD:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
            [button setImage:[UIImage imageNamed:@"facebook-login-button.png"] forState:UIControlStateNormal];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
        }
    }
    if(self.fbGraphUser != nil && !FbLoginBegin)
    {
        [self setFbLoginBegin: YES];
        [appDelegate.userData setFacebookID:fbGraphUser.id];
        [appDelegate.userData setFacebookAccessToken:@""];
        [appDelegate.userData setName: [NSString stringWithFormat:@"%@ %@",fbGraphUser.first_name,fbGraphUser.last_name]];
        [appDelegate.userData setUsername:fbGraphUser.username];
        //[appDelegate showLoadingActivity];
        NSLog(@"login from showing user");
        
        [self facebookLogin];
    }else
        if(!FbLoginBegin)
            [appDelegate hideLoadingActivity];

    clearFbTokens = NO;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * button =  obj;
            button.exclusiveTouch = YES;
            [button addTarget:self action:@selector(facebookButtonTD:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
            [button setImage:[UIImage imageNamed:@"facebook-login-button.png"] forState:UIControlStateNormal];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
        }
    }
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * button =  obj;
            button.exclusiveTouch = YES;
            [button addTarget:self action:@selector(facebookButtonTD:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
            [button setImage:[UIImage imageNamed:@"facebook-login-button.png"] forState:UIControlStateNormal];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
        }
    }
    self.fbGraphUser = user;
    if(!clearFbTokens && !FbLoginBegin)
    {
        [self setFbLoginBegin: YES];
        [appDelegate.userData setFacebookID:fbGraphUser.id];
        [appDelegate.userData setFacebookAccessToken:@""];
        [appDelegate.userData setName: [NSString stringWithFormat:@"%@ %@",fbGraphUser.first_name,fbGraphUser.last_name]];
        [appDelegate.userData setUsername:fbGraphUser.username];
        //[appDelegate showLoadingActivity];
        NSLog(@"login from fetch user");
        [self facebookLogin];
    }else
        if(!FbLoginBegin)
            [appDelegate hideLoadingActivity];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * button =  obj;
            button.exclusiveTouch = YES;
            [button addTarget:self action:@selector(facebookButtonTD:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
            [button setImage:[UIImage imageNamed:@"facebook-login-button.png"] forState:UIControlStateNormal];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height);
        }
    }
    [appDelegate hideLoadingActivity];
    NSLog(@"FBLoginView encountered an error=%@", error);
}
@end
