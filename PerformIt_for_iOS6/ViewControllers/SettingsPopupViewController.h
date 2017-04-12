//
//  SettingsPopupViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 5/2/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKit+AFNetworking.h"
#import "AppDelegate.h"

@class AppDelegate;
@interface SettingsPopupViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
{
    AppDelegate *appDelegate;
    BOOL keyboardShown;
    BOOL saveOnClose;
}
@property (nonatomic, strong) IBOutlet UIView *settingsView;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UIButton *changeSettingsButton;
//@property (nonatomic, strong) IBOutlet UIButton *enableSoundsButton;
//@property (nonatomic, strong) IBOutlet UIButton *disableSoundsButton;
@property (nonatomic, strong) IBOutlet LabelBorder *coinsLabel;
@property (nonatomic, strong) IBOutlet UIImageView *coinsIV;
@property (nonatomic, strong) IBOutlet UIButton *cancelEditButton;
@property (nonatomic, strong) IBOutlet UIButton *aboutUsButton;
@property (nonatomic, strong) IBOutlet UIButton *logoutButton;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) IBOutlet LabelBorder *coinsTextLabel;

- (IBAction)closePopupButtonTUI:(id)sender;
- (IBAction)changeSettingsButtonTUI:(id)sender;
//- (IBAction)enableSoundsButtonTUI:(id)sender;
//- (IBAction)disableSoundsButtonTUI:(id)sender;
- (IBAction)aboutUsButtonTUI:(id)sender;
- (IBAction)logoutButtonTUI:(id)sender;

@end
