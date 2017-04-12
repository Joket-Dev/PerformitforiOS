//
//  SplashViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 4/23/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController
@synthesize backgroundIV, loadingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([appDelegate isIPHONE5])
    {
        backgroundIV.image = [UIImage imageNamed:@"splash-bg-568h@2x.png"];
        backgroundIV.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
    }
    loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.frame = CGRectMake((appDelegate.screenWidth-20)/2, (appDelegate.screenHeight-20)/2, 20, 20);
    [self.view addSubview:loadingView];    
    [loadingView startAnimating];
//    [loadingView release];
    
    //[self performSelector:@selector(dismissSplash:) withObject:nil afterDelay:20.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    if([appDelegate hasConnectivity])
    {
        [loadingView startAnimating];
        //get coins
        [APIManager setSender:self];
        [APIManager getAvailableCoins:appDelegate.userData.token Version:appDelegate.version andTag:availableCoinsRequest];
    }else
    {
        [appDelegate showAlert:@"Internet connection slow or not available." CancelButton:@"Exit" OkButton:@"Retry" Type:noInternetAlert Sender:self];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

//- (void)dealloc
//{
//    [backgroundIV release];    
//    [super dealloc];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dismissSplash:(id)sender
{
    [loadingView stopAnimating];
    [appDelegate hideSplashScreen];
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
    [loadingView stopAnimating];
    switch ([[dict objectForKey:@"request"]integerValue])
    {
        case availableCoinsRequest:
        {//get coins
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:@"Exit" OkButton:@"Retry" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    [appDelegate.inAppCoins setArray:[[dict objectForKey:@"response"]objectForKey:@"response"]];
                    NSMutableArray *products = [[NSMutableArray alloc]init];
                    for ( int i = 0; i < [appDelegate.inAppCoins count]; i++)
                    {
                        [products addObject:[NSString stringWithFormat:@"%@%@",kCoinsInapp,[[appDelegate.inAppCoins objectAtIndex:i]objectForKey:@"coins"]]];
                        [[appDelegate.inAppCoins objectAtIndex:i] setValue:@"NO" forKey:@"available"];
                    }
//                    //add hardcoded packets
//                    
//                    //appDelegate.inAppPacketsArray addObject:<#(id)#>
//                    for ( int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
//                    {
//                        [products addObject:[NSString stringWithFormat:@"%@%@",kPacketsInapp,[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet"]]];
//                        [[appDelegate.inAppPacketsArray objectAtIndex:i] setValue:@"NO" forKey:@"available"];
//                    }
                    
                    [appDelegate.inApp loadStore:products];
//                    [products release];
                    
                    [self dismissSplash:self];
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 2)
                    {
                        //Invalid app_id
                        [appDelegate showAlert:@"Another session with the same user name already exists. Click OK to login and disconnect the other session." CancelButton:nil OkButton:@"OK" Type:invalidAppIDAlert Sender:self];
                    }
                }
            }
        }
            break;            
        default:
            break;
    }
}

#pragma mark - Alert Delegates
- (void)alertOkBtnTUI:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        appDelegate.alertDialog.alpha = 0.0;
    }completion:^(BOOL finished) {
        [appDelegate.alertDialog removeFromSuperview];
        if([sender tag] == noInternetAlert || [sender tag] == timeoutAlert || [sender tag] == apiErrorAlert || [sender tag] == invalidAppIDAlert)
        {
            //get coins
            [self viewWillAppear:NO];
            return ;
        }
        switch ([sender tag])
        {
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
                if(appDelegate.window.rootViewController.presentedViewController != nil)
//                    [appDelegate.window.rootViewController dismissModalViewControllerAnimated:YES];
                [appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

                else
                    [appDelegate.homeViewController viewDidAppear:NO];
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
        if([sender tag] == noInternetAlert || [sender tag] == timeoutAlert || [sender tag] == apiErrorAlert || [sender tag] == invalidAppIDAlert)
        {
            exit(0);
            return ;
        }
        if ([sender tag] == pushNotificationAlert)
        {
            [appDelegate setPushNotificationDict:nil];
            //check if is not root
            //                if(self.window.rootViewController.presentedViewController == nil)
            //                    [homeViewController viewDidAppear:NO];
        }
    }];
}

@end
