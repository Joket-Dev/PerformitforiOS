//
//  AppDelegate.h
//  PerformIt_for_iOS6
//
//  Created by Admin on 6/24/16.
//  Copyright (c) 2016 quantum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "SplashViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

#import "LoadingView.h"
#import "AlertDialog.h"
#import "UserData.h"

#import "Utilities.h"
#import "Constants.h"
#import "APIManager.h"

#import "JSON.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBWebDialogs.h>


#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "InAppPurchaseManager.h"

#import "TestFlight.h"
#import <Tapjoy/Tapjoy.h>

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@class SplashViewController;
@class LoginViewController;
@class HomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    LoadingView *loadingActivity;
    BOOL connected;
    BOOL reLogin;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) SplashViewController *splashViewController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) HomeViewController *homeViewController;

@property (nonatomic, strong) AlertDialog *alertDialog;
@property (nonatomic, strong) UserData *userData;

@property (nonatomic, assign) int screenWidth;
@property (nonatomic, assign) int screenHeight;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, assign) BOOL reLogin;

@property (nonatomic, strong) NSMutableArray *inAppCoins;
@property (nonatomic, strong) NSMutableArray *inAppPacketsArray;
@property (nonatomic, strong) InAppPurchaseManager *inApp;
@property (nonatomic, assign) BOOL currentlyBuying;

@property (nonatomic, assign) BOOL playing;
@property (nonatomic, assign) BOOL recording;
@property (nonatomic, assign) BOOL gamePaused;
@property (nonatomic, assign) float version;
@property (nonatomic, assign) BOOL update;
@property (nonatomic, assign) BOOL reDrawInPRogress;

@property (nonatomic, strong) NSMutableDictionary *pushNotificationDict;
- (BOOL)isIPHONE5;
- (BOOL)isIOS6;
- (BOOL)isIOS7;

- (void)hideSplashScreen;
- (void)hideLoginScreen;
- (void)hideHomeScreen;
- (void)showReloginScreen;
- (void)hideReloginScreen;

- (void)showLoadingActivity;
- (void)hideLoadingActivity;

- (BOOL)hasConnectivity;

- (void) showAlert:(NSString*)message CancelButton:(NSString*)cancelButton OkButton:(NSString*)okButton Type:(int)type Sender:(id)sender;

- (void)cancelBuyPackets;
- (void)cancelBuyCoins;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

