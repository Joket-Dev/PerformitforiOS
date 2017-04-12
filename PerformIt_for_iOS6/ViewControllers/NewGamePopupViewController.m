
//
//  NewGamePopupViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 4/30/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "NewGamePopupViewController.h"

#import "GameTypeViewController.h"
#import "FacebookFriendCell.h"
#import "LabelBorder.h"

@interface NewGamePopupViewController ()

@end

@implementation NewGamePopupViewController
@synthesize mainScrollView;
@synthesize closeButton;
@synthesize createGameView, emailButton, facebookButton, usernameButton, randomButton, createGamePopupTitleLabel;

@synthesize emailInvitePopup, sendEmailButton, emailTextField, emailInvitePopupTitleLabel;
@synthesize usernameInvitePopup, sendUsernameButton, usernameTextField, usernameInvitePopupTitleLabel;
@synthesize facebookInvitePopup, tbl, facebookPopupTitleLabel;
@synthesize facebookFriendsArray, groupedFriendsArray;
@synthesize skipToWords;

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
    createGameView.hidden = YES;
    emailInvitePopup.hidden = YES;
    usernameInvitePopup.hidden = YES;
    facebookInvitePopup.hidden = YES;
    
    //scroll view init
    [mainScrollView setCanCancelContentTouches:NO];
	mainScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
	mainScrollView.clipsToBounds = YES;
	mainScrollView.scrollEnabled = NO;
	mainScrollView.pagingEnabled = NO;
	[mainScrollView setContentSize: CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
    
    //init create game popup
    [createGamePopupTitleLabel setFont:[UIFont fontWithName:@"marvin" size:25]];
    createGamePopupTitleLabel.adjustsFontSizeToFitWidth = YES;
    createGamePopupTitleLabel.shadowOffset = CGSizeMake(1, 1);
    createGamePopupTitleLabel.shadowColor = [UIColor blackColor];
    createGamePopupTitleLabel.text = @"CREATE A NEW GAME";

    //init email invite popup
    [emailInvitePopupTitleLabel setFont:[UIFont fontWithName:@"marvin" size:25]];
    emailInvitePopupTitleLabel.adjustsFontSizeToFitWidth = YES;
    emailInvitePopupTitleLabel.shadowOffset = CGSizeMake(1, 1);
    emailInvitePopupTitleLabel.shadowColor = [UIColor blackColor];
    emailInvitePopupTitleLabel.text = @"EMAIL INVITE";
    emailTextField.placeholder = @"Email address";
    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sendEmailButton.frame.size.width, sendEmailButton.frame.size.height)];
    buttonView.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgIV = [[UIImageView alloc]init];
    bgIV.image = [UIImage imageNamed:@"email-invitation-send-button.png"];
    bgIV.frame = buttonView.frame;
    [buttonView addSubview:bgIV];
//    [bgIV release];
    
    LabelBorder *buttonLabel = [[LabelBorder alloc]init];
    buttonLabel.frame = CGRectMake(10, 0, buttonView.frame.size.width-20, buttonView.frame.size.height);
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.textColor = [UIColor whiteColor];
    buttonLabel.font = [UIFont fontWithName:@"marvin" size:25];
    buttonLabel.adjustsFontSizeToFitWidth = YES;

    if([appDelegate isIPHONE5])
        buttonLabel.textAlignment = NSTextAlignmentCenter;
    else
        buttonLabel.textAlignment = NSTextAlignmentCenter;
    buttonLabel.text = @"SEND E-MAIL";
    [buttonView addSubview:buttonLabel];
//    [buttonLabel release];
    [sendEmailButton setImage:[Utilities imageWithView:buttonView] forState:UIControlStateNormal];
//    [buttonView release];
    
    //init username invite popup
    [usernameInvitePopupTitleLabel setFont:[UIFont fontWithName:@"marvin" size:25]];
    usernameInvitePopupTitleLabel.adjustsFontSizeToFitWidth = YES;
    usernameInvitePopupTitleLabel.shadowOffset = CGSizeMake(1, 1);
    usernameInvitePopupTitleLabel.shadowColor = [UIColor blackColor];
    usernameInvitePopupTitleLabel.text = @"USERNAME INVITE";
    usernameTextField.placeholder = @"Username";
    
    buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, sendEmailButton.frame.size.width, sendEmailButton.frame.size.height)];
    buttonView.backgroundColor = [UIColor clearColor];
    
    bgIV = [[UIImageView alloc]init];
    bgIV.image = [UIImage imageNamed:@"email-invitation-send-button.png"];
    bgIV.frame = buttonView.frame;
    [buttonView addSubview:bgIV];
//    [bgIV release];
    
    buttonLabel = [[LabelBorder alloc]init];
    buttonLabel.frame = CGRectMake(10, 0, buttonView.frame.size.width-20, buttonView.frame.size.height);
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.textColor = [UIColor whiteColor];
    buttonLabel.font = [UIFont fontWithName:@"marvin" size:25];
    buttonLabel.adjustsFontSizeToFitWidth = YES;
    if([appDelegate isIPHONE5])
        buttonLabel.textAlignment = NSTextAlignmentCenter;
    else
        buttonLabel.textAlignment = NSTextAlignmentCenter;
    buttonLabel.text = @"SEND USERNAME";
    [buttonView addSubview:buttonLabel];
//    [buttonLabel release];
    [sendUsernameButton setImage:[Utilities imageWithView:buttonView] forState:UIControlStateNormal];
//    [buttonView release];
    
    //init faceboook invite popup
    [facebookPopupTitleLabel setFont:[UIFont fontWithName:@"marvin" size:25]];
    facebookPopupTitleLabel.adjustsFontSizeToFitWidth = YES;
    facebookPopupTitleLabel.shadowOffset = CGSizeMake(1, 1);
    facebookPopupTitleLabel.shadowColor = [UIColor blackColor];
    facebookPopupTitleLabel.text = @"FACEBOOK INVITE";
    
    if([appDelegate.userData.loginType isEqualToString:@"CU"])
        facebookButton.enabled = NO;
    
    facebookFriendsArray = [[NSMutableArray alloc]init];
    groupedFriendsArray = [[NSMutableArray alloc]init];
    alphabet = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    endThread = NO;
    dataAvailable = NO;
    skipToWords = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    dismissView = NO;
    [self showNewGamePopup];
}

- (void)viewDidAppear:(BOOL)animated
{
    //check if returned from game type screen
    if(skipToWords)
    {
        skipToWords = NO;
        [appDelegate showLoadingActivity];
        [APIManager setSender:self];
        [APIManager getGameWords:[NSString stringWithFormat:@"%d",opponentID] WithBubbles:NO Token:appDelegate.userData.token Version:appDelegate.version andTag:gameWordsRequest];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (void)dealloc
//{
//    [mainScrollView release];
//    [createGameView release];
//    [createGamePopupTitleLabel release];
//    [closeButton release];
//    [emailButton release];
//    [facebookButton release];
//    [usernameButton release];
//    [randomButton release];
//    [emailInvitePopup release];
//    [emailInvitePopupTitleLabel release];
//    [emailTextField release];
//    [sendEmailButton release];
//    [usernameInvitePopup release];
//    [usernameInvitePopupTitleLabel release];
//    [usernameTextField release];
//    [sendUsernameButton release];
//    [facebookInvitePopup release];
//    [facebookPopupTitleLabel release];
//    [tbl release];
//    [facebookFriendsArray release];
//    [groupedFriendsArray release];
//    
//    [super dealloc];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [APIManager cancelRequest];
    endThread = YES;
}

- (void)showNewGamePopup
{
    createGameView.hidden = NO;
    createGameView.frame = CGRectMake(createGameView.center.x, createGameView.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        if([appDelegate isIPHONE5])
            createGameView.frame = CGRectMake(10, 70+88, 305, 191);
        else
            createGameView.frame = CGRectMake(10, 70, 305, 191);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissNewGamePopup
{
    [UIView animateWithDuration:0.2 animations:^{
        createGameView.frame = CGRectMake(createGameView.center.x, createGameView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         createGameView.hidden = YES;
         if(dismissView)
         {
             endThread = YES;
//             [self dismissModalViewControllerAnimated:NO];
             [self dismissViewControllerAnimated:NO completion:nil];
         }
     }];
}

- (void)showEmailInvitePopup
{
    emailInvitePopup.hidden = NO;
    emailInvitePopup.frame = CGRectMake(emailInvitePopup.center.x, emailInvitePopup.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        if([appDelegate isIPHONE5])
            emailInvitePopup.frame = CGRectMake(10, 70+88, 305, 191);
        else
            emailInvitePopup.frame = CGRectMake(10, 70, 305, 191);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissEmailInvitePopup
{
    [UIView animateWithDuration:0.2 animations:^{
        emailInvitePopup.frame = CGRectMake(emailInvitePopup.center.x, emailInvitePopup.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         emailInvitePopup.hidden = YES;
     }];
}

- (void)showUsernameInvitePopup
{
    usernameInvitePopup.hidden = NO;
    usernameInvitePopup.frame = CGRectMake(usernameInvitePopup.center.x, usernameInvitePopup.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        if([appDelegate isIPHONE5])
            usernameInvitePopup.frame = CGRectMake(10, 70+88, 305, 191);
        else
            usernameInvitePopup.frame = CGRectMake(10, 70, 305, 191);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissUsernameInvitePopup
{
    [UIView animateWithDuration:0.2 animations:^{
        usernameInvitePopup.frame = CGRectMake(usernameInvitePopup.center.x, usernameInvitePopup.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         usernameInvitePopup.hidden = YES;
     }];
}

- (void)showFacebookInvitePopup
{
    facebookInvitePopup.hidden = NO;
    facebookInvitePopup.frame = CGRectMake(facebookInvitePopup.center.x, facebookInvitePopup.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        if([appDelegate isIPHONE5])
            facebookInvitePopup.frame = CGRectMake(15, 0, 300, 460);
        else
            facebookInvitePopup.frame = CGRectMake(15, 0, 300, 460);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissFacebookInvitePopup
{
    [UIView animateWithDuration:0.2 animations:^{
        facebookInvitePopup.frame = CGRectMake(facebookInvitePopup.center.x, facebookInvitePopup.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         facebookInvitePopup.hidden = YES;
     }];
}

#pragma mark - Popup Buttons Delegate
- (IBAction)closeButtonTUI:(id)sender
{
    dismissView = YES;
    [self dismissNewGamePopup];
}

- (IBAction)emailButtonTUI:(id)sender
{
    [self dismissNewGamePopup];
    [self showEmailInvitePopup];
}

- (IBAction)facebookButtonTUI:(id)sender
{
    if([facebookFriendsArray count] == 0)
    {
        [appDelegate showLoadingActivity];
        [APIManager setSender: self];
        [APIManager getFacebookFriends:appDelegate.userData.token Version:appDelegate.version andTag:facebookFriendsRequest];
    }else
    {
        [self dismissNewGamePopup];
        [self showFacebookInvitePopup];
    }
}

- (IBAction)usernamelButtonTUI:(id)sender
{
    [self dismissNewGamePopup];
    [self showUsernameInvitePopup];
}

- (IBAction)randomButtonTUI:(id)sender
{
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    [APIManager getGameWords:@"-1" WithBubbles:NO Token:appDelegate.userData.token Version:appDelegate.version andTag:gameWordsRequest];
    opponentID = -1;
}

- (IBAction)emailInvitationCloseButtonTUI:(id)sender
{
    if(keyboardShown)
    {
        [emailTextField resignFirstResponder];
    }else
    {
        [self showNewGamePopup];
        [self dismissEmailInvitePopup];
    }
}

- (IBAction)usernameInvitationCloseButtonTUI:(id)sender
{
    if(keyboardShown)
    {
        [usernameTextField resignFirstResponder];
    }else
    {
        [self showNewGamePopup];
        [self dismissUsernameInvitePopup];
    }
}

- (IBAction)facebookInvitationCloseButtonTUI:(id)sender
{
    [self showNewGamePopup];
    [self dismissFacebookInvitePopup];
}

#pragma mark - TextFieldDelegates
- (IBAction)emailTextFieldDidEndOnExit:(id)sender
{
    [emailTextField resignFirstResponder];
}

- (IBAction)usernameTextFieldDidEndOnExit:(id)sender
{
    [usernameTextField resignFirstResponder];
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
    bottomOffset = CGPointMake(0, 30);
	[mainScrollView setContentOffset: bottomOffset animated: YES];
}

#pragma mark - UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [groupedFriendsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[groupedFriendsArray objectAtIndex:section] objectForKey:@"rowValue"] count];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
	return [[groupedFriendsArray objectAtIndex:section] objectForKey:@"headerName"];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return alphabet;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UIImageView *headerBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    
    LabelBorder *headerLabel = [[LabelBorder alloc]init];
    headerLabel.frame = CGRectMake(20, 0, headerView.frame.size.width-20, headerView.frame.size.height);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"marvin" size:20];
    if([appDelegate isIPHONE5])
        headerLabel.textAlignment = NSTextAlignmentLeft;
    else
        headerLabel.textAlignment = NSTextAlignmentLeft;

    headerBg.image = [UIImage imageNamed:@"facebook-header-bg.png"];
    headerLabel.text = [[groupedFriendsArray objectAtIndex:section] objectForKey:@"headerName"];

    [headerView addSubview:headerBg];
//    [headerBg release];
    
    [headerView addSubview:headerLabel];
//    [headerLabel release];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    if(dataAvailable)
    {
        UIImage *image = [self getFriendImage:[self getFriendDetailsWithValue:[[[groupedFriendsArray objectAtIndex:indexPath.section] objectForKey:@"rowValue"]objectAtIndex:indexPath.row] andKey:@"facebook_id"]];
        if(image == nil)
            image = [UIImage imageNamed:@"opponent-no-image.png"];
        FacebookFriendCell *facebookFriendCellView = [[FacebookFriendCell alloc]initWithFrame:CGRectMake(0, 0, tbl.frame.size.width, tbl.rowHeight) Photo:image Name:[NSString stringWithFormat:@"%@ %@",[self getFriendDetailsWithValue:[[[groupedFriendsArray objectAtIndex:indexPath.section] objectForKey:@"rowValue"]objectAtIndex:indexPath.row] andKey:@"firstname"],[self getFriendDetailsWithValue:[[[groupedFriendsArray objectAtIndex:indexPath.section] objectForKey:@"rowValue"]objectAtIndex:indexPath.row] andKey:@"lastname"]]];
        
        [cell addSubview:facebookFriendCellView];
//        [facebookFriendCellView release];
    }
    return cell;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:NO animated:YES];
    NSLog(@"%@",[self getFriendDetailsWithValue:[[[groupedFriendsArray objectAtIndex:indexPath.section] objectForKey:@"rowValue"]objectAtIndex:indexPath.row] andKey:@"user_id"]);
    opponentID = [[self getFriendDetailsWithValue:[[[groupedFriendsArray objectAtIndex:indexPath.section] objectForKey:@"rowValue"]objectAtIndex:indexPath.row] andKey:@"user_id"]intValue];
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    [APIManager getGameWords:[self getFriendDetailsWithValue:[[[groupedFriendsArray objectAtIndex:indexPath.section] objectForKey:@"rowValue"]objectAtIndex:indexPath.row] andKey:@"user_id"] WithBubbles:NO Token:appDelegate.userData.token Version:appDelegate.version andTag:gameWordsRequest];
}

- (IBAction)sendEmailInvitationButtonTUI:(id)sender
{
    if(keyboardShown)
    {
        [emailTextField resignFirstResponder];
    }
    //check if data filled
    if([emailTextField.text length] == 0)
    {
        [appDelegate showAlert:@"Please complete all required fields" CancelButton:nil OkButton:@"OK" Type:emailInviteIncompleteAlert Sender:self];

    }else
    {
        if([emailTextField.text isEqualToString:appDelegate.userData.email])
        {
            [appDelegate showAlert:@"This is your email. Please use another one." CancelButton:nil OkButton:@"OK" Type:usedEmailAlert Sender:self];
        }else
        {
            //api call
            [appDelegate showLoadingActivity];
            [APIManager setSender:self];
            [APIManager checkUser:emailTextField.text andType:@"email" Token:appDelegate.userData.token Version:appDelegate.version andTag:checkForUserRequest];
        }
    }
}

- (IBAction)sendUsernameInvitationButtonTUI:(id)sender
{
    if(keyboardShown)
    {
        [usernameTextField resignFirstResponder];
    }
    //check if data filled
    if([usernameTextField.text length] == 0)
    {
        [appDelegate showAlert:@"Please complete all required fields" CancelButton:nil OkButton:@"OK" Type:usernameInviteIncompleteAlert Sender:self];

    }else
    {
        if([appDelegate.userData.loginType isEqualToString:@"CU"] && [usernameTextField.text isEqualToString:appDelegate.userData.username])
        {
            [appDelegate showAlert:@"This is your username. Please use another one." CancelButton:nil OkButton:@"OK" Type:usedUsernameAlert Sender:self];
            
        }else
        {
            //api call
            [appDelegate showLoadingActivity];
            [APIManager setSender:self];
            [APIManager checkUser:usernameTextField.text andType:@"username" Token:appDelegate.userData.token Version:appDelegate.version andTag:checkForUserRequest];
        }
    }
}

#pragma mark - Alert Delegates
- (void)alertOkBtnTUI:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        appDelegate.alertDialog.alpha = 0.0;
    }completion:^(BOOL finished) {
        [appDelegate.alertDialog removeFromSuperview];
    }];
    switch ([sender tag])
    {
        case invalidAppIDAlert:
        {
            [appDelegate.userData setValidLogin:NO];
            [Utilities saveUserInfo:appDelegate.userData];
            [appDelegate showReloginScreen];
        }
            break;
        case usedUsernameAlert:
        {
            [usernameTextField becomeFirstResponder];
            
        }
            break;
        case usedEmailAlert:
        {
            [emailTextField becomeFirstResponder];
        }
            break;
        case newVersionAlert:
        {
            [appDelegate showLoadingActivity];
            NSString *buyString = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",kAppID];
            NSURL *url = [[NSURL alloc] initWithString:buyString];
            [[UIApplication sharedApplication] openURL:url];
//            [url release];
        }
            break;
        default:
            break;
    }
}

- (void)alertCancelBtnTUI:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        appDelegate.alertDialog.alpha = 0.0;
    }completion:^(BOOL finished) {
        [appDelegate.alertDialog removeFromSuperview];
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

- (void)dataReceived:(NSDictionary*)dict
{
    [appDelegate hideLoadingActivity];
    switch ([[dict objectForKey:@"request"]integerValue])
    {
        case checkForUserRequest:
        {//check for username
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    [appDelegate showLoadingActivity];
                    [APIManager setSender:self];
                    [APIManager getGameWords:[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"user_id"] WithBubbles:NO Token:appDelegate.userData.token Version:appDelegate.version andTag:gameWordsRequest];
                    opponentID = [[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"user_id"]intValue];
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 31)
                    {
                        //User doesn't exits
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:userIsMissingAlert Sender:self];
                    }
                }
            }
        }
            break;
        case facebookFriendsRequest:
        {//get facebook friends
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //show popup
                    dataAvailable = YES;
                    [facebookFriendsArray setArray:[[dict objectForKey:@"response"]objectForKey:@"response"]];
                    [self setGroupedFriendsArray:[Utilities groupAlphabeticallyArray:facebookFriendsArray]];
                    [tbl reloadData];
                    [self dismissNewGamePopup];
                    [self showFacebookInvitePopup];
                    [self performSelectorInBackground:@selector(getLazyImages:) withObject:facebookFriendsArray];
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 36)
                    {
                        //None of your friends are playing.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:noFriendPlayingAlert Sender:self];
                    }
                }
            }
        }
            break;
        case gameWordsRequest:
        {//get game words
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //go to next screen
                    endThread = YES;
                    GameTypeViewController *gameTypeViewController = [[GameTypeViewController alloc]initWithNibName:@"GameTypeViewController" bundle:nil WithUser:opponentID AndData:[[dict objectForKey:@"response"] objectForKey:@"response"] Game:-1 Continue:NO];
//                    [self presentModalViewController:gameTypeViewController animated:YES];
                    [self presentViewController:gameTypeViewController animated:YES completion:nil];
//                    [gameTypeViewController release];
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 2)
                    {
                        //Invalid app_id
                        [appDelegate showAlert:@"Another session with the same user name already exists. Click OK to login and disconnect the other session." CancelButton:nil OkButton:@"OK" Type:invalidAppIDAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 34)
                    {
                        //Value must be numeric.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

- (NSString*) getFriendDetailsWithValue:(NSString*)value andKey:(NSString*)key
{
    for (int i = 0; i < [facebookFriendsArray count]; i++)
    {
        NSString *string = [NSString stringWithFormat:@"%@ %@",[[facebookFriendsArray objectAtIndex:i] objectForKey:@"firstname"],[[facebookFriendsArray objectAtIndex:i] objectForKey:@"lastname"]];
        
            if([value isEqualToString:string])
            {
                return [[facebookFriendsArray objectAtIndex:i]objectForKey:key];
            }
    }
    return nil;
}

#pragma mark - Friends Images
- (void)getLazyImages:(NSMutableArray*)array
{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    @autoreleasepool {
    for (int i=0; i<[array count]; i++)
    {
        if(!endThread)
        {
            [self saveFriendImage:[[array objectAtIndex:i]objectForKey:@"facebook_id"]];
            [self performSelectorOnMainThread:@selector(getLazyImagesDone) withObject:nil waitUntilDone:NO];
        }else
            break;
    }
    }
//    [pool release];
}

-(void)getLazyImagesDone
{
    //  [tbl reloadData];
}

-(void)saveFriendImage:(NSString*)facebook_id
{
    [Utilities cacheImage:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture/",facebook_id]Filename:facebook_id];
}

-(UIImage*)getFriendImage:(NSString*)facebook_id
{
    return [Utilities  getCachedImage:facebook_id];
}
@end


