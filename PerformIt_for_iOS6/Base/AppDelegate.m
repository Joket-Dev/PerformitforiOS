//
//  AppDelegate.m
//  PerformIt_for_iOS6
//
//  Created by Admin on 6/24/16.
//  Copyright (c) 2016 quantum. All rights reserved.
//

#import "AppDelegate.h"
#import <Tapjoy/Tapjoy.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GamePlayViewController.h"
#import "DrawViewController.h"
#import "RecordWordViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize splashViewController, loginViewController, homeViewController;
@synthesize alertDialog;
@synthesize userData;
@synthesize screenWidth, screenHeight;
@synthesize connected;
@synthesize reLogin;
@synthesize inAppCoins;
@synthesize inAppPacketsArray;
@synthesize inApp;
@synthesize currentlyBuying;
@synthesize playing;
@synthesize recording;
@synthesize pushNotificationDict;
@synthesize gamePaused;
@synthesize version;
@synthesize update;
@synthesize reDrawInPRogress;

NSString *const FBSessionStateChangedNotification = @"com.Performit.Performit:FBSessionStateChangedNotification";

void HandleExceptions(NSException *exception) {
    NSLog(@"This is where we save the application data during a exception");
    // Save application data on crash
}
/*
 My Apps Custom signal catcher, we do special stuff here, and TestFlight takes care of the rest
 */
void SignalHandler(int sig) {
    NSLog(@"This is where we save the application data during a signal");
    // Save application data on crash
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // installs HandleExceptions as the Uncaught Exception Handler
    NSSetUncaughtExceptionHandler(&HandleExceptions);
    // create the signal action structure
    struct sigaction newSignalAction;
    // initialize the signal action structure
    memset(&newSignalAction, 0, sizeof(newSignalAction));
    // set SignalHandler as the handler in the signal action structure
    newSignalAction.sa_handler = &SignalHandler;
    // set SignalHandler as the handlers for SIGABRT, SIGILL and SIGBUS
    sigaction(SIGABRT, &newSignalAction, NULL);
    sigaction(SIGILL, &newSignalAction, NULL);
    sigaction(SIGBUS, &newSignalAction, NULL);
    //
    //#define TESTING 1
    //#ifdef TESTING
    ////    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    //#endif
    //    // Call takeOff after install your own unhandled exception and signal handlers
    //    [TestFlight takeOff:kTestflightToken];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setScreenWidth:[[UIScreen mainScreen] bounds].size.width];
    [self setScreenHeight:[[UIScreen mainScreen] bounds].size.height];
    loadingActivity = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    [self setVersion: (float)[infoDictionary[(NSString*)kCFBundleVersionKey]floatValue]];
    
    userData = [[UserData alloc]init];
    if([Utilities loadUserInfo] == nil)
    {
        [userData setValidLogin:NO];
        [userData setToken:@""];
        [userData setUsername:@""];
        [userData setName:@""];
        [userData setFacebookAccessToken:@""];
        [userData setFacebookID:@""];
        [userData setSoundsEnabled:YES];
        [userData setDeviceID:@""];
    }else
        [self setUserData:[Utilities loadUserInfo]];
    
    pushNotificationDict = nil;
    
    //init in - app packets
    inAppPacketsArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"allcolors" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:kColorsAllPackage] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"limitedcolors" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:kColors1Package] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"allbrushes" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:kBrushesAllPackage] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"limitedbrushes" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:kBrushes1Package] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"backgroundcolor" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:kBackgroundColorPackage] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"15bubbles" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:k15BubblesPackage] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"30bubbles" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:k30BubblesPackage] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"timer2minutes" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:kTimer2minPackage] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"timer5minutes" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:kTimer5minPackage] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"timerinfinite" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:kTimerInfinitePackage] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"timerstop" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:kTimerStopPackage] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    packetDict = [[NSMutableDictionary alloc]init];
    [packetDict setValue:@"hint" forKey:@"packet"];
    [packetDict setValue:[NSNumber numberWithInt:kHintPackage] forKey:@"packet_id"];
    [inAppPacketsArray addObject:packetDict];
    //    [packetDict release];
    
    //add timer an guessing powers
    
    inAppCoins = [[NSMutableArray alloc]init];
    inApp = [[InAppPurchaseManager alloc] init]; //in-app
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    
    // Tapjoy Connect Notifications
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(tjcConnectSuccess:)
    //                                                 name:TJC_CONNECT_SUCCESS
    //                                               object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(tjcConnectFail:)
    //                                                 name:TJC_CONNECT_FAILED
    //                                               object:nil];
    
    // NOTE: This is the only step required if you're an advertiser.
    // NOTE: This must be replaced by your App ID. It is retrieved from the Tapjoy website, in your account.
    //	[Tapjoy requestTapjoyConnect:kTapJoyAppID
    //					   secretKey:kTapJoySecretKey
    //						 options:@{ TJC_OPTION_ENABLE_LOGGING : @(YES) }
    //     // If you are not using Tapjoy Managed currency, you would set your own user ID here.
    //     //TJC_OPTON_USER_ID : @"A_UNIQUE_USER_ID"
    //     ];
    
    self.splashViewController = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
    self.window.rootViewController = self.splashViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    application.applicationIconBadgeNumber = 0;

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    application.applicationIconBadgeNumber = 0;

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
    if(!reDrawInPRogress)
        [self hideLoadingActivity];
    if(update)
        [self showAlert:@"A new version of Perform it is available." CancelButton:nil OkButton:@"Update" Type:newVersionAlert Sender:self.window.rootViewController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
    // Add an observer for when a user has successfully earned currency.
    //	[[NSNotificationCenter defaultCenter] addObserver:self
    //											 selector:@selector(showEarnedCurrencyAlert:)
    //												 name:TJC_TAPPOINTS_EARNED_NOTIFICATION
    //											   object:nil];
    
    //check if active screen is game play
    UIViewController *topController = self.window.rootViewController;
    while (topController.presentedViewController)
    {
        NSLog(@"%@",topController.presentedViewController);
        topController = topController.presentedViewController;
    }
    
    if([topController isKindOfClass:[LoginViewController class]])
    {
        LoginViewController *tempLoginViewController = (LoginViewController*)topController;
        for (id obj in tempLoginViewController.loginview.subviews)
        {
            if ([obj isKindOfClass:[UIButton class]])
            {
                UIButton * button =  obj;
                button.exclusiveTouch = YES;
                [button addTarget:tempLoginViewController action:@selector(facebookButtonTD:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(0, 0, tempLoginViewController.facebookLoginButton.frame.size.width, tempLoginViewController.facebookLoginButton.frame.size.height);
                [button setImage:[UIImage imageNamed:@"facebook-login-button.png"] forState:UIControlStateNormal];
            }
            if ([obj isKindOfClass:[UILabel class]])
            {
                UILabel * loginLabel =  obj;
                loginLabel.text = @"";
                loginLabel.textAlignment = NSTextAlignmentCenter;
                loginLabel.frame = CGRectMake(0, 0, tempLoginViewController.facebookLoginButton.frame.size.width, tempLoginViewController.facebookLoginButton.frame.size.height);
            }
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    application.applicationIconBadgeNumber = 0;
}
- (BOOL)isIPHONE5
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height > 480.0f)
            return YES;
        else
            return NO;
    }
    return NO;
}

- (BOOL)isIOS6
{
    float currentVersion = 6.0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion)
        return YES;
    else
        return NO;
}

- (BOOL)isIOS7
{
    float currentVersion = 7.0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion)
        return YES;
    else
        return NO;
}

#pragma mark - Loading Activity Methods
- (void)showLoadingActivity
{
    [self.window addSubview:loadingActivity];
}

- (void)hideLoadingActivity
{
    [loadingActivity removeFromSuperview];
}

- (void)hideSplashScreen
{
    if(!userData.validLogin)
    {
        reLogin = NO;
        if(splashViewController != nil)
            [splashViewController.view removeFromSuperview];
        splashViewController = nil;
        self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        self.window.rootViewController = self.loginViewController;
        [self.window makeKeyAndVisible];
    }else
    {
        //check for internet
        if([self hasConnectivity])
        {
            if(splashViewController != nil)
                [splashViewController.view removeFromSuperview];
            splashViewController = nil;
            
            homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            self.window.rootViewController = self.homeViewController;
            //            [homeViewController release];
            [self.window makeKeyAndVisible];
        }else
        {
            [self showAlert:@"Internet connection slow or not available." CancelButton:@"Exit" OkButton:@"Retry" Type:noInternetAlert Sender:self.window.rootViewController];
        }
    }
}

- (void)hideLoginScreen
{
    if(loginViewController != nil)
        [loginViewController.view removeFromSuperview];
    loginViewController = nil;
    
    homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.window.rootViewController = self.homeViewController;
    //[homeViewController release];
    [self.window makeKeyAndVisible];
}

- (void)hideHomeScreen
{
    if(homeViewController != nil)
        [homeViewController.view removeFromSuperview];
    homeViewController = nil;
    
    self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.window.rootViewController = self.loginViewController;
    //[loginViewController release];
    [self.window makeKeyAndVisible];
}

- (void)showReloginScreen
{
    reLogin = YES;
    //    [homeViewController dismissModalViewControllerAnimated:NO];
    [homeViewController dismissViewControllerAnimated:NO completion:nil];
    self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.window.rootViewController = self.loginViewController;
    [self.window makeKeyAndVisible];
}

- (void)hideReloginScreen
{
    reLogin = NO;
    if(loginViewController != nil)
        [loginViewController.view removeFromSuperview];
    loginViewController = nil;
    homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.window.rootViewController = self.homeViewController;
    //[homeViewController release];
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}

#pragma mark - PushNotifications
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSString *device_id;
    device_id = [[devToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [userData setDeviceID:[device_id stringByReplacingOccurrencesOfString:@" " withString:@"" ]];
    NSLog(@"%@",userData.deviceID);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSString *errText = [[NSString alloc] initWithFormat:@"APN Error:%@",err];
    NSLog(@"Fail register APN:%@",errText);
    //    [errText release];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    if(!playing && !recording && [userData.token length] > 0 && pushNotificationDict == nil)
    {
        pushNotificationDict = [[NSMutableDictionary alloc]initWithDictionary:userInfo];
        
        UIViewController *topController = self.window.rootViewController;
        while (topController.presentedViewController)
        {
            NSLog(@"%@",topController.presentedViewController);
            topController = topController.presentedViewController;
        }
        //hide all alerts
        
        [self showAlert:[userInfo objectForKey:@"message"] CancelButton:@"Later" OkButton:@"Play" Type:pushNotificationAlert Sender:topController];
    }
}

- (BOOL)hasConnectivity
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                [self setConnected:NO];
                return NO;
            }
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                [self setConnected:YES];
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    [self setConnected:YES];
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                [self setConnected:YES];
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - Alert Delegates
- (void)alertOkBtnTUI:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alertDialog.alpha = 0.0;
    }completion:^(BOOL finished) {
        [self.alertDialog removeFromSuperview];
        switch ([sender tag])
        {
            case noInternetAlert:
            {
                //retry connection
                [self hideSplashScreen];
            }
                break;
            case pushNotificationAlert:
            {
                //check if is not root
                if(self.window.rootViewController.presentedViewController != nil)
                    //                    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
                    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                else
                    [homeViewController viewDidAppear:NO];
            }
                break;
            case newVersionAlert:
            {
                [self showLoadingActivity];
                NSString *buyString = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",kAppID];
                NSURL *url = [[NSURL alloc] initWithString:buyString];
                [[UIApplication sharedApplication] openURL:url];
                //                [url release];
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
        self.alertDialog.alpha = 0.0;
    }completion:^(BOOL finished) {
        [self.alertDialog removeFromSuperview];
        switch ([sender tag])
        {
            case noInternetAlert:
            {
                //close app
                exit(0);
            }
                break;
            case facebookRetryAlert:
            {
                //retry facebook
            }
                break;
            case pushNotificationAlert:
            {
                pushNotificationDict = nil;
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

- (void) showAlert:(NSString*)message CancelButton:(NSString*)cancelButton OkButton:(NSString*)okButton Type:(int)type Sender:(id)sender
{
    alertDialog = [[AlertDialog alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) Message:message CancelButton:cancelButton OKButton:okButton AlertType:type Sender:sender];
    alertDialog.alpha = 0.0;
    [[sender view] addSubview:alertDialog];
    [[sender view] bringSubviewToFront:alertDialog];
    [UIView animateWithDuration:0.5 animations:^{
        alertDialog.alpha = 1.0;
    }];
}

- (void)cancelBuyPackets
{
    [self setCurrentlyBuying:NO];
    [self hideLoadingActivity];
}

- (void)cancelBuyCoins
{
    [self setCurrentlyBuying:NO];
    [self hideLoadingActivity];
}

#pragma mark - Tapjoy Delegates

-(void)tjcConnectSuccess:(NSNotification*)notifyObj
{
    NSLog(@"Tapjoy connect Succeeded");
}


- (void)tjcConnectFail:(NSNotification*)notifyObj
{
    NSLog(@"Tapjoy connect Failed");
}

- (void)showEarnedCurrencyAlert:(NSNotification*)notifyObj
{
    NSNumber *tapPointsEarned = notifyObj.object;
    int earnedNum = [tapPointsEarned intValue];
    
    NSLog(@"Currency earned: %d", earnedNum);
    
    // Pops up a UIAlert notifying the user that they have successfully earned some currency.
    // This is the default alert, so you may place a custom alert here if you choose to do so.
    //[Tapjoy showDefaultEarnedCurrencyAlert];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "yphone.quantum.com.PerformIt_for_iOS6" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PerformIt_for_iOS6" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PerformIt_for_iOS6.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
