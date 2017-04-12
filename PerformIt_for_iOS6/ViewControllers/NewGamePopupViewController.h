//
//  NewGamePopupViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 4/30/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class AppDelegate;
@interface NewGamePopupViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    AppDelegate *appDelegate;
    BOOL dismissView;
    BOOL keyboardShown;
    
    NSMutableArray *alphabet;
    BOOL endThread;
    BOOL dataAvailable;
    int opponentID;
    BOOL skipToWords;
}
@property (nonatomic, strong) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic, strong) IBOutlet UIView *createGameView;
@property (nonatomic, strong) IBOutlet UILabel *createGamePopupTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) IBOutlet UIButton *emailButton;
@property (nonatomic, strong) IBOutlet UIButton *facebookButton;
@property (nonatomic, strong) IBOutlet UIButton *usernameButton;
@property (nonatomic, strong) IBOutlet UIButton *randomButton;

@property (nonatomic, strong) IBOutlet UIView *emailInvitePopup;
@property (nonatomic, strong) IBOutlet UILabel *emailInvitePopupTitleLabel;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UIButton *sendEmailButton;

@property (nonatomic, strong) IBOutlet UIView *usernameInvitePopup;
@property (nonatomic, strong) IBOutlet UILabel *usernameInvitePopupTitleLabel;
@property (nonatomic, strong) IBOutlet UITextField *usernameTextField;
@property (nonatomic, strong) IBOutlet UIButton *sendUsernameButton;

@property (nonatomic, strong) IBOutlet UIView *facebookInvitePopup;
@property (nonatomic, strong) IBOutlet UILabel *facebookPopupTitleLabel;
@property (nonatomic, strong) IBOutlet UITableView *tbl;

@property (nonatomic, strong) NSMutableArray *facebookFriendsArray;
@property (nonatomic, strong) NSMutableArray *groupedFriendsArray;
@property (nonatomic, assign) BOOL skipToWords;

- (IBAction)closeButtonTUI:(id)sender;

- (IBAction)emailButtonTUI:(id)sender;
- (IBAction)facebookButtonTUI:(id)sender;
- (IBAction)usernamelButtonTUI:(id)sender;
- (IBAction)randomButtonTUI:(id)sender;

- (IBAction)emailInvitationCloseButtonTUI:(id)sender;
- (IBAction)usernameInvitationCloseButtonTUI:(id)sender;
- (IBAction)facebookInvitationCloseButtonTUI:(id)sender;
- (IBAction)sendEmailInvitationButtonTUI:(id)sender;
- (IBAction)sendUsernameInvitationButtonTUI:(id)sender;



@end
