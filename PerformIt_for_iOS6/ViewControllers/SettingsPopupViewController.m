//
//  SettingsPopupViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/2/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "SettingsPopupViewController.h"
#import "LoginPopupViewController.h"
#import "AboutUsViewController.h"
#import "Utilities.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface SettingsPopupViewController () {
    UIImageView * ivPhoto;
    NSString * file_path;
}
@end

@implementation SettingsPopupViewController
@synthesize settingsView;
@synthesize coinsTextLabel;
//@synthesize enableSoundsButton, disableSoundsButton;
@synthesize nameTextField;
@synthesize cancelEditButton;
@synthesize changeSettingsButton;
@synthesize coinsLabel, coinsIV;
@synthesize aboutUsButton, logoutButton;
@synthesize closeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)saveFriendImage:(NSString*)picture_id
{
    [Utilities cacheImage:[NSString stringWithFormat:@"%@/socialgame/images/profile/%@", shareBaseUrl, picture_id]Filename:picture_id];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.view.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
    self.view.backgroundColor = [UIColor blackColor];
    
//    //init sound buttons
//    if(appDelegate.userData.soundsEnabled)
//    {
//        [enableSoundsButton setImage:[UIImage imageNamed:@"enable-sounds-button-selected.png"] forState:UIControlStateNormal];
//        [disableSoundsButton setImage:[UIImage imageNamed:@"disable-sounds-button.png"] forState:UIControlStateNormal];
//    }else
//    {
//        [enableSoundsButton setImage:[UIImage imageNamed:@"enable-sounds-button.png"] forState:UIControlStateNormal];
//        [disableSoundsButton setImage:[UIImage imageNamed:@"disable-sounds-button-selected.png"] forState:UIControlStateNormal];
//    }
    
    //init coins label and image
    
//    ivPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 80, 80)];
//    //    ivPhoto.image = [UIImage imageNamed:@"45985"];
//    ivPhoto.contentMode = UIViewContentModeScaleToFill;
//    ivPhoto.userInteractionEnabled = YES;
//    ivPhoto.alpha = 1.0f;
//    ivPhoto.layer.cornerRadius = 3.0f;
//    ivPhoto.layer.masksToBounds = YES;
//    ivPhoto.layer.borderWidth = 3.0f;
//    ivPhoto.layer.borderColor = [UIColor colorWithRed:16/255.0f green:91/255.0f blue:148/255.0f alpha:1.0f].CGColor;
//    ivPhoto.image = [Utilities getCachedImage:appDelegate.userData.userphotourl];
//    
//    [settingsView addSubview:ivPhoto];
//
//    UITapGestureRecognizer * tap_ges_photo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_photo_clicked:)];
//    tap_ges_photo.numberOfTouchesRequired = 1;
//    tap_ges_photo.numberOfTapsRequired = 1;
//    [ivPhoto addGestureRecognizer:tap_ges_photo];

    
    [coinsLabel setFont:[UIFont fontWithName:@"marvin" size:25]];
    coinsLabel.adjustsFontSizeToFitWidth = YES;
    coinsLabel.shadowOffset = CGSizeMake(1, 1);
    coinsLabel.shadowColor = [UIColor blackColor];
    coinsLabel.text = [NSString stringWithFormat:@"%d",appDelegate.userData.coins];
    if([appDelegate isIPHONE5])
        coinsLabel.textAlignment = NSTextAlignmentRight;
    else
        coinsLabel.textAlignment = NSTextAlignmentRight;
    
    [coinsTextLabel setFont:[UIFont fontWithName:@"marvin" size:25]];
    coinsTextLabel.adjustsFontSizeToFitWidth = YES;
    coinsTextLabel.shadowOffset = CGSizeMake(1, 1);
    coinsTextLabel.shadowColor = [UIColor blackColor];
    coinsTextLabel.text = @"CURRENT COIN COUNT:";
    if([appDelegate isIPHONE5])
        coinsTextLabel.textAlignment = NSTextAlignmentLeft;
    else
        coinsTextLabel.textAlignment = NSTextAlignmentLeft;
    
    if(appDelegate.userData.coins < 100)
    {
        coinsIV.image = [UIImage imageNamed:@"coins-categ-min.png"];
    }else
    if(appDelegate.userData.coins < 500)
    {
        coinsIV.image = [UIImage imageNamed:@"coins-categ-med.png"];
    }else
    {
        coinsIV.image = [UIImage imageNamed:@"coins-categ-max.png"];
    }
    //init textfield
    cancelEditButton.hidden = YES;
    nameTextField.text = appDelegate.userData.name;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self showSettingsPopup];
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
//    [settingsView release];
//    [nameTextField release];
//    [changeSettingsButton release];
//    [coinsLabel release];
//    [coinsIV release];
//    [cancelEditButton release];
//    [aboutUsButton release];
//    [logoutButton release];
//    [closeButton release];
//    [coinsTextLabel release];
//    [super dealloc];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [APIManager cancelRequest];
}

- (void)showSettingsPopup
{    
    settingsView.hidden = NO;
    settingsView.frame = CGRectMake(settingsView.center.x, settingsView.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        if([appDelegate isIPHONE5])
            settingsView.frame = CGRectMake(8, 50+38+20, 310, 380);
        else
            settingsView.frame = CGRectMake(8, 50+20, 310, 380);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissSettingsPopup
{
    [UIView animateWithDuration:0.2 animations:^{
        settingsView.frame = CGRectMake(settingsView.center.x, settingsView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         settingsView.hidden = YES;
//         [self dismissModalViewControllerAnimated:NO];
         [self dismissViewControllerAnimated:NO completion:nil];
     }];
}

- (IBAction)closePopupButtonTUI:(id)sender
{
    if(![nameTextField.text isEqualToString:appDelegate.userData.name])
    {
        //save before close
        [appDelegate showAlert:@"Save data changes before close?" CancelButton:@"NO" OkButton:@"YES" Type:saveSettingsBeforeCloseAlert Sender:self];
    }else
        [self dismissSettingsPopup];
}

- (IBAction)changeSettingsButtonTUI:(id)sender
{
    if([nameTextField.text length] == 0)
    {
        [appDelegate showAlert:@"Please enter your complete name" CancelButton:nil OkButton:@"OK" Type:noNameAlert Sender:self];
        return;
    }
    if(![nameTextField.text isEqualToString:appDelegate.userData.name])
    {
        //save if changed
        saveOnClose = NO;
        [appDelegate showLoadingActivity];
        [APIManager setSender:self];
        NSString *firstname = [[nameTextField.text componentsSeparatedByString:@" "]objectAtIndex:0];
        NSString *lastname = @"";
        if([[nameTextField.text componentsSeparatedByString:@" "]count] > 1)
            lastname = [[nameTextField.text componentsSeparatedByString:@" "]objectAtIndex:1];
        
        [APIManager saveSettings:appDelegate.userData.token Firtsname:firstname Lastname:lastname Version:appDelegate.version andTag:saveSettingsRequest];    }
    
}

//- (IBAction)enableSoundsButtonTUI:(id)sender
//{
//    [appDelegate.userData setSoundsEnabled:YES];
//    [enableSoundsButton setImage:[UIImage imageNamed:@"enable-sounds-button-selected.png"] forState:UIControlStateNormal];
//    [disableSoundsButton setImage:[UIImage imageNamed:@"disable-sounds-button.png"] forState:UIControlStateNormal];
//
//}
//- (IBAction)disableSoundsButtonTUI:(id)sender
//{
//    [appDelegate.userData setSoundsEnabled:NO];
//    [enableSoundsButton setImage:[UIImage imageNamed:@"enable-sounds-button.png"] forState:UIControlStateNormal];
//    [disableSoundsButton setImage:[UIImage imageNamed:@"disable-sounds-button-selected.png"] forState:UIControlStateNormal];
//}

- (IBAction)cancelEditTD:(id)sender
{
    cancelEditButton.hidden = YES;
    [nameTextField resignFirstResponder];
}

#pragma mark - TextFieldDelegates
- (IBAction)nameTextFieldDidEndOnExit:(id)sender
{
    [nameTextField resignFirstResponder];
}

#pragma mark - Keyboad Delegates
-(void)registerForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardWasHidden:(NSNotification*)aNotification
{
    cancelEditButton.hidden = YES;
	keyboardShown = NO;
}

-(void)keyboardWasShown:(NSNotification*)aNotification
{
	if (keyboardShown)
		return;
    
    cancelEditButton.hidden = NO;
	keyboardShown = YES;
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
            case saveSettingsBeforeCloseAlert:
            {
                //api call
                saveOnClose = YES;
                [appDelegate showLoadingActivity];
                [APIManager setSender:self];
                NSString *firstname = [[nameTextField.text componentsSeparatedByString:@" "]objectAtIndex:0];
                NSString *lastname = @"";
                if([[nameTextField.text componentsSeparatedByString:@" "]count] > 1)
                    lastname = [[nameTextField.text componentsSeparatedByString:@" "]objectAtIndex:1];
                [APIManager saveSettings:appDelegate.userData.token Firtsname:firstname Lastname:lastname Version:appDelegate.version andTag:saveSettingsRequest];
            }
                break;
            case logoutAlert:
            {
                //api call
                [appDelegate showLoadingActivity];
                [APIManager setSender:self];
                [APIManager logoutUser:appDelegate.userData.token Version:appDelegate.version andTag:logoutRequest];
            }
                break;
            case invalidAppIDAlert:
            {
                [appDelegate.userData setValidLogin:NO];
                [Utilities saveUserInfo:appDelegate.userData];
                [appDelegate showReloginScreen];
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
                if(appDelegate.window.rootViewController.presentedViewController != nil)
                //                    [appDelegate.window.rootViewController dismissModalViewControllerAnimated:YES];
                    [appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                else
                    [appDelegate.homeViewController viewDidAppear:NO];
            }
                break;
                
            case timeoutAlert:
            {
                
            }
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
            case saveSettingsBeforeCloseAlert:
            {
                [self performSelector:@selector(dismissSettingsPopup) withObject:nil afterDelay:0.5];
            }
                break;
            case logoutAlert:
            {
                
            }
                break;
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

- (IBAction)aboutUsButtonTUI:(id)sender
{
    AboutUsViewController *aboutUsViewController = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
    [self presentViewController:aboutUsViewController animated:YES completion:nil];
//    [aboutUsViewController release];
}

- (IBAction)logoutButtonTUI:(id)sender
{
    [appDelegate showAlert:@"Are you sure you want to logout?" CancelButton:@"NO" OkButton:@"YES" Type:logoutAlert Sender:self];
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
        case logoutRequest:
        {//logout
//            if([[dict objectForKey:@"timeout"]boolValue])
//            {
//                //timeout
//                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
//            }else
//            {
//                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
//                {
            [appDelegate.userData setValidLogin:NO];
            [appDelegate.userData setToken:@""];
            [appDelegate.userData setUsername:@""];
            [appDelegate.userData setName:@""];
            [appDelegate.userData setFacebookAccessToken:@""];
            [appDelegate.userData setFacebookID:@""];
            [appDelegate.userData setSoundsEnabled:YES];
        
            [Utilities saveUserInfo:appDelegate.userData];
            if(![appDelegate.userData.loginType isEqualToString:@"CU"])
                [self facebookLogout];
//            [self dismissModalViewControllerAnimated:NO];
            [self dismissViewControllerAnimated:NO completion:nil];
            [appDelegate hideHomeScreen];
//                    return;
//                }else
//                {
//                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 1)
//                    {
//                        //Invalid validation_hash
//                        [appDelegate showAlert:@"Something went wrong. Please try again." CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
//                    }
//                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 62)
//                    {
//                        //new version
//                        [appDelegate setUpdate:YES];
//                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"Update" Type:newVersionAlert Sender:self];
//                    }
//                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 2)
//                    {
//                        //Invalid app_id
//                        appDelegate.userData.validLogin = NO;
//                        [Utilities saveUserInfo:appDelegate.userData];
//                        [self dismissModalViewControllerAnimated:NO];
//                        [appDelegate hideHomeScreen];
//                    }
//                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 30)
//                    {
//                        //User id is missing
//                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:userIsMissingAlert Sender:self];
//                    }
//                }
//            }
        }
            break;
        case saveSettingsRequest:
        {//save settings
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //save name to user info
                    [appDelegate.userData setName:nameTextField.text];
                    //if saved on exit dissmis popup
                    if(saveOnClose)
                        [self dismissSettingsPopup];
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
- (void)facebookLogout
{
    if (FBSession.activeSession.isOpen)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebook_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebook_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
}

- (void) tap_photo_clicked:(UITapGestureRecognizer *)paramSender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Library", nil];
    [actionSheet showInView:self.view];
}

- (BOOL)shouldStartCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}



#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if ( cameraDeviceAvailable == NO ) {
            [appDelegate showAlert:@"Camera Device is not available at this moment." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
//            [Global showMessage:@"Camera Device is not available at this moment."];
            return;
        }
        [self shouldStartCameraController];
    } else if (buttonIndex == 1) {
        [self shouldStartPhotoLibraryPickerController];
    }
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    file_path = [Utilities saveImageToDevice:image withName:appDelegate.userData.username extension:@"png"];
    
    ivPhoto.image = image;
    ivPhoto.alpha = 1.0f;
    
}
@end
