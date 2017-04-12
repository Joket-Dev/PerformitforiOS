//
//  HomeViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 4/29/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "LabelBorder.h"
#import <Tapjoy/Tapjoy.h>

@class AppDelegate;
@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, TJCViewDelegate>
{
    AppDelegate *appDelegate;
    BOOL isDragging;
    BOOL isLoading;
    BOOL dataAvailable;
    BOOL endThread;
    int selectedGame;
    BOOL viewWillAppearCalled;
    int selectedGameForDeletion;
}
@property (nonatomic, strong) IBOutlet UIImageView *backgroundIV;
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UITableView *tbl;
@property (nonatomic, strong) IBOutlet UIButton *createGameButton;
@property (nonatomic, strong) IBOutlet UIButton *tapjoyButton;
@property (nonatomic, strong) UIButton *coinsButton;

//pull to refresh
@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
//
@property (nonatomic, strong) NSMutableArray *myTurnGamesArray;
@property (nonatomic, strong) NSMutableArray *theirTurnGamesArray;
@property (nonatomic, strong) NSMutableArray *completedGamesAray;

//pull to refresh
- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
- (void)addItem;
//
- (IBAction)createGameButtonTUI:(id)sender;
- (IBAction)achievementsButtonTUI:(id)sender;
- (IBAction)leaderboardButtonTUI:(id)sender;
- (IBAction)settingsButtonTUI:(id)sender;
- (IBAction)tapjoyButtonTUI:(id)sender;

@end
