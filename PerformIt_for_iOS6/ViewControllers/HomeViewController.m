//
//  HomeViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 4/29/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "HomeViewController.h"
#import "NewGamePopupViewController.h"
#import "SettingsPopupViewController.h"
#import "LeaderboardViewController.h"
#import "AchievementsViewController.h"
#import "GamePlayViewController.h"
#import "CoinsViewController.h"
#import "GameTypeViewController.h"
#import "DrawViewController.h"
#import "RecordWordViewController.h"

#import "GameCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "LabelBorder.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize backgroundIV;
@synthesize mainView;
@synthesize tapjoyButton;
@synthesize createGameButton;
@synthesize tbl;
@synthesize coinsButton;
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;
@synthesize myTurnGamesArray, theirTurnGamesArray, completedGamesAray;

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
    [self setupStrings];
    [self addPullToRefreshHeader];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([appDelegate isIPHONE5])
    {
        backgroundIV.image = [UIImage imageNamed:@"home-bg-568h@2x.png"];
        backgroundIV.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        tbl.frame = CGRectMake(tbl.frame.origin.x, tbl.frame.origin.y, tbl.frame.size.width, tbl.frame.size.height-10);
    }
    
    //init coins button
    coinsButton = [[UIButton alloc]init];
    coinsButton.frame = CGRectMake(27, appDelegate.screenHeight-40, 45+16+5+50, 20);
    [coinsButton addTarget:self action:@selector(coinsButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:coinsButton];
//    [coinsButton release];
    [self addCoinsButton];

    //init create game button
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, createGameButton.frame.size.width, createGameButton.frame.size.height)];
    
    UIImageView *buttonBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, createGameButton.frame.size.width, createGameButton.frame.size.height)];
    buttonBg.image = [UIImage imageNamed:@"create-game-header.png"];
    [buttonView addSubview:buttonBg];
//    [buttonBg release];
    LabelBorder *label = [[LabelBorder alloc]init];
    label.frame = CGRectMake(0, 0, createGameButton.frame.size.width, createGameButton.frame.size.height);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"marvin" size:20];
    if([appDelegate isIPHONE5])
        label.textAlignment = NSTextAlignmentCenter;
    else
        label.textAlignment = NSTextAlignmentCenter;
    label.text = @"+ CREATE NEW GAME";
    [buttonView addSubview:label];
//    [label release];
    
    [createGameButton setImage:[Utilities imageWithView:buttonView] forState:UIControlStateNormal];
//    [buttonView release];

    myTurnGamesArray = [[NSMutableArray alloc]init];
    theirTurnGamesArray = [[NSMutableArray alloc]init];
    completedGamesAray = [[NSMutableArray alloc]init];
    dataAvailable = NO;
    viewWillAppearCalled = NO;
    
    tbl.allowsMultipleSelectionDuringEditing = NO;
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredForeground)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    endThread = NO;
    [appDelegate setPlaying:NO];
    [appDelegate setRecording:NO];
    
    //init tapjoy
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tapjoyClosed:)
												 name:TJC_VIEW_CLOSED_NOTIFICATION
											   object:nil];
//    [Tapjoy setViewDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(appDelegate.pushNotificationDict != nil)
    {
        [appDelegate showLoadingActivity];
        [APIManager setSender:self];
        [APIManager getPurchasablePackets:appDelegate.userData.token Version:appDelegate.version andTag:packetsRequest];
    }else
    {
        //check if sent here from settings-> logout
        if([appDelegate.userData.token length] == 0)
            return;
        [appDelegate showLoadingActivity];
        [APIManager setSender:self];
        [APIManager getGames:appDelegate.userData.token Version:appDelegate.version andTag:gamesRequest];
    }
}
//
//- (void)dealloc
//{
//    [backgroundIV release];
//    [mainView release];
//    [tbl release];
//    [createGameButton release];
//    [tapjoyButton release];
//    [coinsButton release];
//    
//    [refreshHeaderView release];
//    [refreshLabel release];
//    [refreshArrow release];
//    [refreshSpinner release];
//    [textPull release];
//    [textRelease release];
//    [textLoading release];
//    [myTurnGamesArray release];
//    [theirTurnGamesArray release];
//    [completedGamesAray release];
//    [super dealloc];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [APIManager cancelRequest];
    endThread = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:TJC_VIEW_CLOSED_NOTIFICATION];
}

- (void)addCoinsButton
{
    UIView *coinsButtonView = [[UIView alloc]init];
    coinsButtonView.backgroundColor = [UIColor clearColor];
    coinsButtonView.frame = CGRectMake(0, 0, coinsButton.frame.size.width, coinsButton.frame.size.height);
    
    LabelBorder *coinsLabel = [[LabelBorder alloc]init];
    coinsLabel.frame = CGRectMake(0, 0, 45, 20);
    coinsLabel.backgroundColor = [UIColor clearColor];
    coinsLabel.textColor = [UIColor whiteColor];
    coinsLabel.font = [Utilities fontWithName:@"marvin" minSize:8 maxSize:20 constrainedToSize:CGSizeMake(coinsLabel.frame.size.width, coinsLabel.frame.size.height) forText:@"COINS:"];
    if([appDelegate isIPHONE5])
        coinsLabel.textAlignment = NSTextAlignmentLeft;
    else
        coinsLabel.textAlignment = NSTextAlignmentLeft;
    coinsLabel.text = @"COINS:";
    [coinsButtonView addSubview:coinsLabel];
//    [coinsLabel release];
    
    UIImageView *coinIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small-coin-icon.png"]];
    coinIV.frame = CGRectMake(coinsLabel.frame.origin.x+coinsLabel.frame.size.width, coinsLabel.frame.origin.y+(coinsLabel.frame.size.height-16)/2, 16, 16);
    [coinsButtonView addSubview:coinIV];
//    [coinIV release];
    
    LabelBorder *coinsValueLabel = [[LabelBorder alloc]init];
    coinsValueLabel.frame = CGRectMake(coinsLabel.frame.origin.x+coinsLabel.frame.size.width+coinIV.frame.size.width+5, coinsLabel.frame.origin.y+(coinsLabel.frame.size.height-20)/2, 50, 20);
    coinsValueLabel.backgroundColor = [UIColor clearColor];
    coinsValueLabel.textColor = [UIColor whiteColor];
    coinsValueLabel.font = [Utilities fontWithName:@"marvin" minSize:8 maxSize:20 constrainedToSize:CGSizeMake(coinsValueLabel.frame.size.width, coinsValueLabel.frame.size.height) forText:[Utilities formatCoins:appDelegate.userData.coins]];
    if([appDelegate isIPHONE5])
        coinsValueLabel.textAlignment = NSTextAlignmentLeft;
    else
        coinsValueLabel.textAlignment = NSTextAlignmentLeft;
    coinsValueLabel.textAlignment = NSTextAlignmentLeft;
    coinsValueLabel.text = [Utilities formatCoins:appDelegate.userData.coins];
    [coinsButtonView addSubview:coinsValueLabel];
//    [coinsValueLabel release];
    
    [coinsButton setImage:[Utilities imageWithView:coinsButtonView ] forState:UIControlStateNormal];
//    [coinsButtonView release];
}

- (void)coinsButtonTUI:(id)sender
{
    [appDelegate showAlert:@"You want to buy more coins?" CancelButton:@"NO" OkButton:@"YES" Type:moreCoinsAlert Sender:self];
}

- (IBAction)createGameButtonTUI:(id)sender
{
    //delete me
    NewGamePopupViewController *newGamePopupViewController = [[NewGamePopupViewController alloc]initWithNibName:@"NewGamePopupViewController" bundle:nil];
//    appDelegate.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
//    [self presentModalViewController:newGamePopupViewController animated:NO];
    [self presentViewController:newGamePopupViewController animated:NO completion:nil];
//    [newGamePopupViewController release];
}

#pragma mark - Pull Refresh

- (void)setupStrings
{
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)addPullToRefreshHeader
{
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, tbl.frame.size.width, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tbl.frame.size.width, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 24) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 34) / 2),
                                    24, 34);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [tbl addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading)
        return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isLoading)
    {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            tbl.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            tbl.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT)
    {
        // Released above the header
        [self startLoading];
    }

}

- (void)startLoading
{
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        tbl.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading
{
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        tbl.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(stopLoadingComplete)];
    }];
  }

- (void)stopLoadingComplete
{
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh
{
    //[self performSelector:@selector(addItem) withObject:nil afterDelay:2.0];
    self.view.userInteractionEnabled = NO;
    [self addItem];
}

- (void)addItem
{
    //[self stopLoading];
    //[appDelegate showLoadingActivity];
    endThread = YES;
    [APIManager setSender:self];
    [APIManager getGames:appDelegate.userData.token Version:appDelegate.version andTag:gamesRequest];
}

#pragma mark - UITableview Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    switch (indexPath.section)
//    {
//        case 0:
//        {
//            if (indexPath.row == [myTurnGamesArray count])
//                return 10;
//        }
//            break;
//        case 1:
//        {
//            if (indexPath.row == [theirTurnGamesArray count])
//                return 10;
//        }
//            break;
//        case 2:
//        {
//            if (indexPath.row == [completedGamesAray count])
//                return 10;
//        }
//            break;
//        default:
//            break;
//    }
    return 48;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            if([myTurnGamesArray count] == 0)
            {
                if(!dataAvailable)
                    return 0;
                else
                    return 1;
            }else
                return [myTurnGamesArray count];
        }
            break;
        case 1:
        {
            if([theirTurnGamesArray count] == 0)
            {
                if(!dataAvailable)
                    return 0;
                else
                    return 1;
            }else
                return [theirTurnGamesArray count];
        }
            break;
        case 2:
        {
            if([completedGamesAray count] == 0)
            {
                if(!dataAvailable)
                    return 0;
                else
                    return 1;
            }else
                return [completedGamesAray count];
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 24)];
    UIImageView *headerBg = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, headerView.frame.size.width-2*8, headerView.frame.size.height)];

    LabelBorder *headerLabel = [[LabelBorder alloc]init];
    headerLabel.frame = CGRectMake(8, 0, headerView.frame.size.width-2*8, headerView.frame.size.height);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"marvin" size:20];
    if([appDelegate isIPHONE5])
        headerLabel.textAlignment = NSTextAlignmentCenter;
    else
        headerLabel.textAlignment = NSTextAlignmentCenter;

    switch (section)
    {
        case 0:
        {
            headerBg.image = [UIImage imageNamed:@"your-turn-header.png"];
            headerLabel.text = @"YOUR TURN";
        }
            break;
        case 1:
        {
            headerBg.image = [UIImage imageNamed:@"their-turn-header.png"];
            headerLabel.text = @"THEIR TURN";
        }
            break;
        case 2:
        {
            headerBg.image = [UIImage imageNamed:@"completed-games-header.png"];
            headerLabel.text = @"COMPLETED GAMES";
        }
            break;
            
        default:
            break;
    }
    [headerView addSubview:headerBg];
//    [headerBg release];
    
    [headerView addSubview:headerLabel];
//    [headerLabel release];
    
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
//    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
//    }
    [cell setBackgroundColor:[UIColor clearColor]];
    if(!dataAvailable)
        return cell;
    switch (indexPath.section)
    {
        case 0:
        {
            if([myTurnGamesArray count] == 0)
            {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                GameCellView *gameCellView = [[GameCellView alloc]initWithFrame:CGRectMake(8, 0, tableView.frame.size.width-2*8, tableView.rowHeight) Image:nil Name:nil Round:0 Action:NO];
                [cell addSubview:gameCellView];
//                [gameCellView release];
            }else
            {
                UIImage *image = [self getFriendImage:[[myTurnGamesArray objectAtIndex:indexPath.row] objectForKey:@"picture"]];
                if(image == nil)
                    image = [UIImage imageNamed:@"opponent-no-image.png"];
                GameCellView *gameCellView = [[GameCellView alloc]initWithFrame:CGRectMake(8, 0, tableView.frame.size.width-2*8, tableView.rowHeight) Image:image Name:[[myTurnGamesArray objectAtIndex:indexPath.row] objectForKey:@"name"] Round:[[[myTurnGamesArray objectAtIndex:indexPath.row] objectForKey:@"win_count"]intValue] Action:YES];
                
                UIButton *gameButton = [[UIButton alloc]init];
                gameButton.exclusiveTouch = YES;
                gameButton.frame = CGRectMake(8, 0, tableView.frame.size.width-2*8, tableView.rowHeight);
                gameButton.tag = [[NSString stringWithFormat:@"%d%d",indexPath.section+1,indexPath.row] intValue];
                [gameButton addTarget:self action:@selector(gameSeletectedTUI:) forControlEvents:UIControlEventTouchUpInside];
                [gameButton setImage:[Utilities imageWithView:gameCellView] forState:UIControlStateNormal];
                //[cell addSubview:gameCellView];
//                [gameCellView release];
                
                
                UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
                swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
                [gameButton addGestureRecognizer:swipeRightGestureRecognizer];
//                [swipeRightGestureRecognizer release];
                
                UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
                swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
                [gameButton addGestureRecognizer:swipeLeftGestureRecognizer];
//                [swipeLeftGestureRecognizer release];
                
                [cell addSubview:gameButton];
//                [gameButton release];
            }
        }
            break;
        case 1:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if([theirTurnGamesArray count] == 0)
            {
                GameCellView *gameCellView = [[GameCellView alloc]initWithFrame:CGRectMake(8, 0, tableView.frame.size.width-2*8, tableView.rowHeight) Image:nil Name:nil Round:0 Action:NO];
                [cell addSubview:gameCellView];
//                [gameCellView release];
            }else
            {
                UIImage *image = [self getFriendImage:[[theirTurnGamesArray objectAtIndex:indexPath.row] objectForKey:@"picture"]];
                if(image == nil)
                    image = [UIImage imageNamed:@"opponent-no-image.png"];
                GameCellView *gameCellView = [[GameCellView alloc]initWithFrame:CGRectMake(8, 0, tableView.frame.size.width-2*8, tableView.rowHeight) Image:image Name:[[theirTurnGamesArray objectAtIndex:indexPath.row] objectForKey:@"name"] Round:[[[theirTurnGamesArray objectAtIndex:indexPath.row] objectForKey:@"win_count"]intValue] Action:NO];
                [cell addSubview:gameCellView];
//                [gameCellView release];

//                UIButton *gameButton = [[UIButton alloc]init];
//                gameButton.frame = CGRectMake(8, 0, tableView.frame.size.width-2*8, tableView.rowHeight);
//                gameButton.tag = [[NSString stringWithFormat:@"%d,%d",indexPath.section+1,indexPath.row]intValue];
//                [gameButton addTarget:self action:@selector(gameSeletectedTUI:) forControlEvents:UIControlEventTouchUpInside];
//                [gameButton setImage:[Utilities imageWithView:gameCellView] forState:UIControlStateNormal];
//                gameButton.userInteractionEnabled = NO;
//                [gameCellView release];
//                [cell addSubview:gameButton];
//                [gameButton release];
            }
        }
            break;
        case 2:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if([completedGamesAray count] == 0)
            {
                GameCellView *gameCellView = [[GameCellView alloc]initWithFrame:CGRectMake(8, 0, tableView.frame.size.width-2*8, tableView.rowHeight) Image:nil Name:nil Round:0 Action:NO];
                [cell addSubview:gameCellView];
//                [gameCellView release];
            }else
            {
                UIImage *image = [self getFriendImage:[[completedGamesAray objectAtIndex:indexPath.row] objectForKey:@"picture"]];
                if(image == nil)
                    image = [UIImage imageNamed:@"opponent-no-image.png"];
                GameCellView *gameCellView = [[GameCellView alloc]initWithFrame:CGRectMake(8, 0, tableView.frame.size.width-2*8, tableView.rowHeight) Image:image Name:[[completedGamesAray objectAtIndex:indexPath.row] objectForKey:@"name"] Round:[[[completedGamesAray objectAtIndex:indexPath.row] objectForKey:@"win_count"]intValue] Action:NO];
                
//                UIButton *gameButton = [[UIButton alloc]init];
//                gameButton.exclusiveTouch = YES;
//                gameButton.frame = CGRectMake(8, 0, tableView.frame.size.width-2*8, tableView.rowHeight);
//                gameButton.tag = [[NSString stringWithFormat:@"%d,%d",indexPath.section+1,indexPath.row]intValue];
////                [gameButton addTarget:self action:@selector(gameSeletectedTUI:) forControlEvents:UIControlEventTouchUpInside];
//                [gameButton setImage:[Utilities imageWithView:gameCellView] forState:UIControlStateNormal];
////                gameButton.userInteractionEnabled = NO;
//                [gameCellView release];
////                [cell addSubview:gameButton];
////                [gameButton release];
//                
//                
//                UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//                swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//                [gameButton addGestureRecognizer:swipeRightGestureRecognizer];
//                [swipeRightGestureRecognizer release];
//                
//                UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
//                swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//                [gameButton addGestureRecognizer:swipeLeftGestureRecognizer];
//                [swipeLeftGestureRecognizer release];
//                
//
//                
//                [cell addSubview:gameButton];
                [cell addSubview:gameCellView];
//                [gameCellView release];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:NO animated:YES];
    return;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section == 0 && [myTurnGamesArray count] > 0)
//        return YES;
//    else
//        return NO;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        selectedGameForDeletion = indexPath.row;
//        [appDelegate showAlert:@"Are you sure you want to delete this game" CancelButton:@"NO" OkButton:@"YES" Type:deleteGameAlert Sender:self];
//    }
//}


- (IBAction)achievementsButtonTUI:(id)sender
{
    //delete me
    AchievementsViewController *achievementsViewController = [[AchievementsViewController alloc]initWithNibName:@"AchievementsViewController" bundle:nil];
    [self presentViewController:achievementsViewController animated:YES completion:nil];
//    [achievementsViewController release];
}

- (IBAction)leaderboardButtonTUI:(id)sender
{
    //delete me
    LeaderboardViewController *leaderboardViewController = [[LeaderboardViewController alloc]initWithNibName:@"LeaderboardViewController" bundle:nil];
    [self presentViewController:leaderboardViewController animated:YES completion:nil];
//    [leaderboardViewController release];
}

- (IBAction)settingsButtonTUI:(id)sender
{
    //delete me
    SettingsPopupViewController *settingsPopupViewController = [[SettingsPopupViewController alloc]initWithNibName:@"SettingsPopupViewController" bundle:nil];
    appDelegate.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:settingsPopupViewController animated:NO completion:nil];
//    [settingsPopupViewController release];
}

- (IBAction)tapjoyButtonTUI:(id)sender
{
//    [Tapjoy showOffersWithViewController:self];
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
    self.view.userInteractionEnabled = YES;
    [self stopLoading];
    [appDelegate hideLoadingActivity];
    switch ([[dict objectForKey:@"request"]integerValue])
    {
        case gamesRequest:
        {//get games list
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //update games and coins
                    [appDelegate.userData setCoins:[[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"coins"] intValue]];
                    [self addCoinsButton];
                    
                    [myTurnGamesArray setArray:[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"my_turn"]];
                    [theirTurnGamesArray setArray:[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"their_turn"]];
                    [completedGamesAray setArray:[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"completed"]];
                    dataAvailable = YES;
                    [tbl reloadData];
                    
                    //get friends iamges - /images/profile/<picture>
                    endThread = NO;
                    [self getLazyImages:myTurnGamesArray];
                    [self getLazyImages:theirTurnGamesArray];
                    [self getLazyImages:completedGamesAray];
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 47)
                    {
                        //Error getting game list.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                    }
                }
            }
        }
            break;
        case gameDetailsRequest:
        {//get games details for guess
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //go to play screen
                    //check if data's are valid
                    if ([[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"type"]isEqualToString:@"image"])
                    {
//                        NSData *arrayData = [Utilities base64DataFromString:[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"data"]];
                        //[NSData dataFromBase64String:[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"data"]];
//                        id data = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
//                        NSMutableArray *array;
                        
                        NSString * response = [[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"data"];
                        
//                        NSData * data = [Utilities base64DataFromString:response];
//                        NSError * error;
//                        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                        id  result = [response JSONValue];
                                               
                        if(![result isKindOfClass:[NSMutableDictionary class]])
                        {
                            //error data is corrupted
                            
                            [appDelegate showAlert:@"Something went wrong. Please try again." CancelButton:nil OkButton:@"OK" Type:errorRequestImageAlert Sender:self];
                            return;
                        }
                        
                        NSMutableArray * array = [[NSMutableArray alloc] init];
                        BOOL  isPhone5 = [appDelegate isIPHONE5];
                        for ( id ary in [result objectForKey:@"lines"] ) {
                            if ( [ary isKindOfClass:[NSMutableArray class]] ) {
                                NSMutableArray * temp = [[NSMutableArray alloc] init];
                                for ( NSMutableDictionary * dic in ary ) {
                                    NSMutableString * string = [dic objectForKey:@"point"];
                                    CGPoint point = CGPointFromString(string);
                                    point.x = point.x * 312;
                                    point.y = (1.0f - point.y) * (isPhone5 ? 360 : 305);
                                    NSMutableDictionary * dicTemp = [[NSMutableDictionary alloc] initWithDictionary:dic];
                                    NSValue * value = [NSValue valueWithCGPoint:point];
                                    [dicTemp setObject:value forKey:@"point"];
                                    [temp addObject:dicTemp];
//                                    [dic setObject:[NSValue valueWithCGPoint:point] forKey:@"point"];
                                }
                                [array addObject:temp];
                            }
                        }
                        [array addObject:[result objectForKey:@"background"]];
                        
//                        array = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
                        [[[dict objectForKey:@"response"]objectForKey:@"response"]setValue:array forKey:@"image_array"];
                        [[[dict objectForKey:@"response"]objectForKey:@"response"] removeObjectForKey:@"data"];
                    }
                    if ([[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"type"]isEqualToString:@"audio"])
                    {
                        //save data to audio file
                        NSData *audioData = [Utilities base64DataFromString:[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"data"]];
                        NSString *path = [NSString stringWithFormat:@"%@/audio-record-%@.wav",[Utilities documentsDirectoryPath],[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"game_round_id"]];
                        BOOL ok = [audioData writeToFile:path atomically:YES];// writeToURL:[NSURL URLWithString:path] atomically:YES];
                        if(!ok)
                        {
                            [appDelegate showAlert:@"Something went wrong. Please try again." CancelButton:nil OkButton:@"OK" Type:errorRequestAudioAlert Sender:self];
                            return;
                        }
                    }
                    if ([[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"type"]isEqualToString:@"video"])
                    {
                        //save data to video file
                        NSData *videoData = [Utilities base64DataFromString:[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"data"]];
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@-%@.mov",@"video-record",[[[dict objectForKey:@"response"]objectForKey:@"response"] objectForKey:@"game_round_id"]]];
                        [[[dict objectForKey:@"response"]objectForKey:@"response"] removeObjectForKey:@"data"];
                        [[[dict objectForKey:@"response"]objectForKey:@"response"] setValue:path forKey:@"video_path"];

                        if(![videoData writeToFile:path atomically:YES])
                        {
                            //error
                            [appDelegate showAlert:@"Something went wrong. Please try again." CancelButton:nil OkButton:@"OK" Type:errorRequestVideoAlert Sender:self];

                            return;
                        }
                    }
                                       
                    GamePlayViewController *gamePlayViewController = [[GamePlayViewController alloc] initWithNibName:@"GamePlayViewController" bundle:nil GameDict:[[dict objectForKey:@"response"]objectForKey:@"response"]];
                    [self presentViewController:gamePlayViewController animated:YES completion:nil];
//                    [gamePlayViewController release];
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 47)
                    {
                        //Error getting game
                        [appDelegate showAlert:[[dict objectForKey:@"Response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 21)
                    {
                        //game deleted
                        [appDelegate showAlert:[[dict objectForKey:@"Response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:gameIsDeletedAlert Sender:self];
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
                    //go to words screen witj pre-loaded words
                    GameTypeViewController *gameTypeViewController = [[GameTypeViewController alloc]initWithNibName:@"GameTypeViewController" bundle:nil WithUser:[[[myTurnGamesArray objectAtIndex:selectedGame ] objectForKey:@"player"]intValue] AndData:[[dict objectForKey:@"response"] objectForKey:@"response"] Game:[[[myTurnGamesArray objectAtIndex:selectedGame ] objectForKey:@"game_id"]intValue] Continue:YES];
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
        case purchasedCoinsRequest:
        {//purchase coins
//        if([[dict objectForKey:@"timeout"]boolValue])
//        {
//            //timeout
//            [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
//        }else
//        {
            if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
            {
                //success
                [appDelegate showLoadingActivity];
                [appDelegate.userData setCoins:[[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"coins"]intValue]];
                [self addCoinsButton];

                [Tapjoy getTapPointsWithCompletion:^(NSDictionary *parameters, NSError *error)
                 {
                     if (!error)
                     {
                         [Tapjoy spendTapPoints:[parameters[@"amount"] intValue] completion:^(NSDictionary *parameters, NSError *error)
                         {
                              if (!error)
                              {
                                  
                              }
                              [appDelegate hideLoadingActivity];
                          }];
                         return;
                     }
                     [appDelegate hideLoadingActivity];
                 }];
//            }else
//            {                
//                if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 1)
//                {
//                    //Invalid validation_hash
//                    [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
//                }
//                if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 2)
//                {
//                    //Invalid app_id
//                    [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:invalidAppIDAlert Sender:self];
//
//                    [appDelegate showAlert:@"Another session with the same user name already exists. Click OK to login and disconnect the other session." CancelButton:nil OkButton:@"OK" Type:invalidAppIDAlert Sender:self];
//                }
//                if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 16)
//                {
//                    //Invalid coin value.
//                    [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
//                }
//            }
        }
    }
    break;
        case packetsRequest:
        {//packets request
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //this contain purchased packages
                    //merge with already requested data from itunes
                    NSMutableArray *tempPackets = [[NSMutableArray alloc]init];
                    for (int i = 0; i < [[[dict objectForKey:@"response"]objectForKey:@"response"] count]; i++)
                    {
                        for (int j = 0; j < [appDelegate.inAppPacketsArray count]; j++)
                        {
                            if([[[[[dict objectForKey:@"response"]objectForKey:@"response"] objectAtIndex:i]objectForKey:@"packet_id"]intValue] ==
                               [[[appDelegate.inAppPacketsArray objectAtIndex:j]objectForKey:@"packet_id"]intValue])
                            {
                                [tempPackets addObject:[appDelegate.inAppPacketsArray objectAtIndex:j]];
                                [[tempPackets lastObject] addEntriesFromDictionary:[[[dict objectForKey:@"response"]objectForKey:@"response"] objectAtIndex:i]];
                            }
                        }
                    }
                    [appDelegate.inAppPacketsArray setArray:tempPackets];
//                    [tempPackets release];
                    
                    //check if all packages are purchased set all packages as purchased
                    for (int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
                    {
                        if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == kColorsAllPackage &&
                           [[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"purchased"]boolValue])
                        {
                            for (int j = 0; j < [appDelegate.inAppPacketsArray count]; j++)
                            {
                                if([[[appDelegate.inAppPacketsArray objectAtIndex:j]objectForKey:@"packet_id"]intValue] == kColors1Package )
                                {
                                    [[appDelegate.inAppPacketsArray objectAtIndex:j] setValue:@"YES" forKey:@"purchased"];
                                    break;
                                }
                            }
                        }
                        if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == kBrushesAllPackage &&
                           [[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"purchased"]boolValue])
                        {
                            for (int j = 0; j < [appDelegate.inAppPacketsArray count]; j++)
                            {
                                if([[[appDelegate.inAppPacketsArray objectAtIndex:j]objectForKey:@"packet_id"]intValue] == kBrushes1Package )
                                {
                                    [[appDelegate.inAppPacketsArray objectAtIndex:j] setValue:@"YES" forKey:@"purchased"];
                                    break;
                                }
                            }
                        }
                    }
                    
                    //proceed with game
                    //check if is push notifications
                    if(appDelegate.pushNotificationDict != nil)
                    {
                        [appDelegate showLoadingActivity];
                        [APIManager setSender:self];
                        [APIManager getGameDetails:[appDelegate.pushNotificationDict objectForKey:@"game_round_id"] Token:appDelegate.userData.token Version:appDelegate.version andTag:gameDetailsRequest];
                        appDelegate.pushNotificationDict = nil;
                    }else
                        [self proceedToGame];
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
        case deleteGameRequest:
        {
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    [myTurnGamesArray removeObjectAtIndex:selectedGameForDeletion];
                    [tbl reloadData];
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 20)
                    {
                        //invalid packet.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                        
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 23)
                    {
                        //Error purchasing packet
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 17)
                    {
                        //Error purchasing packet
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 21)
                    {
                        //game deleted
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:gameIsDeletedAlert Sender:self];
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
        case moreCoinsAlert:
        {
            CoinsViewController *coinsViewController = [[CoinsViewController alloc]initWithNibName:@"CoinsViewController" bundle:nil];
//            [self presentModalViewController:coinsViewController animated:YES];
            [self.view.window.rootViewController presentViewController:coinsViewController animated:YES completion:nil];

//            [coinsViewController release];

        }
            break;
        case deleteGameAlert:
        {
            [appDelegate showLoadingActivity];
            [APIManager setSender:self];
            [APIManager deleteGame:appDelegate.userData.token GameRoundID:[[[myTurnGamesArray objectAtIndex:selectedGameForDeletion ] objectForKey:@"game_round_id"]intValue] Version:appDelegate.version andTag:deleteGameRequest];
        }
            break;
        case gameIsDeletedAlert:
        {
//            [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

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
        case pushNotificationAlert:
        {
            //check if is not root
            if(appDelegate.window.rootViewController.presentedViewController != nil)
//                [appDelegate.window.rootViewController dismissModalViewControllerAnimated:YES];
                [appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

            else
                [appDelegate.homeViewController viewDidAppear:NO];
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
        switch ([sender tag])
        {
            case pushNotificationAlert:
            {
                [appDelegate setPushNotificationDict:nil];
                [self viewDidAppear:NO];
            }
                break;
            default:
                break;
        }
    }];
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
                [self saveFriendImage:[[array objectAtIndex:i]objectForKey:@"picture"]];
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

-(void)saveFriendImage:(NSString*)picture_id
{
    [Utilities cacheImage:[NSString stringWithFormat:@"%@/socialgame/images/profile/%@", shareBaseUrl, picture_id]Filename:picture_id];
}

-(UIImage*)getFriendImage:(NSString*)picture_id
{
    return [Utilities  getCachedImage:picture_id];
}

- (void)gameSeletectedTUI:(id)sender
{
//    int section = [[[NSString stringWithFormat:@"%d",[sender tag]] substringToIndex:1]intValue]-1;
    int row = [[[NSString stringWithFormat:@"%ld",[sender tag]] substringFromIndex:1]intValue];
    selectedGame = row;
    //get packets
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    [APIManager getPurchasablePackets:appDelegate.userData.token Version:appDelegate.version andTag:packetsRequest];
    
    return;
//    switch (section)
//    {
//        case 0:
//        {
//            //check game type
//            if([[[myTurnGamesArray objectAtIndex:row] objectForKey:@"my_action"] isEqualToString:@"send_data"])
//            {
//                //check game type an go to record screen or draw
//                if([[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"type"] isEqualToString:@"image"])
//                {
//                    DrawViewController *drawViewController = [[DrawViewController alloc]initWithNibName:@"DrawViewController" bundle:nil GameData:[myTurnGamesArray objectAtIndex:selectedGame]];
//                    [self presentModalViewController:drawViewController animated:YES];
//                    [drawViewController release];
//                }
//                if([[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"type"] isEqualToString:@"audio"])
//                {
//                    NSMutableDictionary *wordDict = [[NSMutableDictionary alloc]init];
//                    [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"coins"] forKey:@"coins"];
//                    [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"word_id"] forKey:@"id"];
//                    [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"time"] forKey:@"time"];
//                    [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"type"] forKey:@"type"];
//                    [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"word"] forKey:@"word"];
//                    
//                    [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"coins"];
//                    [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"word_id"];
//                    [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"time"];
//                    [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"type"];
//                    [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"word"];
//                    [[myTurnGamesArray objectAtIndex:selectedGame] setValue:wordDict forKey:@"word"];
//                    [wordDict release];
//                    
//                    RecordWordViewController *recordWordViewController = [[RecordWordViewController alloc]initWithNibName:@"RecordWordViewController" bundle:nil RecordType:recordSound GameData:[myTurnGamesArray objectAtIndex:selectedGame]];
//                    [self presentModalViewController:recordWordViewController animated:YES];
//                    [recordWordViewController release];
//                }
//                if([[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"type"] isEqualToString:@"video"])
//                {
//                    NSMutableDictionary *wordDict = [[NSMutableDictionary alloc]init];
//                    [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"coins"] forKey:@"coins"];
//                    [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"word_id"] forKey:@"id"];
//                    [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"time"] forKey:@"time"];
//                    [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"type"] forKey:@"type"];
//                    [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"word"] forKey:@"word"];
//
//                    [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"coins"];
//                    [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"word_id"];
//                    [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"time"];
//                    [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"type"];
//                    [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"word"];
//                    [[myTurnGamesArray objectAtIndex:selectedGame] setValue:wordDict forKey:@"word"];
//                    [wordDict release];
//                    
//                    RecordWordViewController *recordWordViewController = [[RecordWordViewController alloc]initWithNibName:@"RecordWordViewController" bundle:nil RecordType:recordVideo GameData:[myTurnGamesArray objectAtIndex:selectedGame]];
//                    [self presentModalViewController:recordWordViewController animated:YES];
//                    [recordWordViewController release];
//                }
//            }
//            if([[[myTurnGamesArray objectAtIndex:row] objectForKey:@"my_action"] isEqualToString:@"finish_game"])
//            {
//                //have to guess
//                //get game details
//                [appDelegate showLoadingActivity];
//                [APIManager setSender:self];
//                [APIManager getGameDetails:[[myTurnGamesArray objectAtIndex:row]objectForKey:@"game_round_id"] Token:appDelegate.userData.token Version:appDelegate.version andTag:gameDetailsRequest];
//            }
//            if([[[myTurnGamesArray objectAtIndex:row] objectForKey:@"my_action"] isEqualToString:@"continue_game"])
//            {
//                //turn ended, create a new round
//                [appDelegate showLoadingActivity];
//                [APIManager setSender:self];
//                [APIManager getGameWords:[[myTurnGamesArray objectAtIndex:row] objectForKey:@"player"] Token:appDelegate.userData.token Version:appDelegate.version andTag:gameWordsRequest];
//            }
//        }
//            break;
//        case 1:
//        {
//            
//        }
//            break;
//        case 2:
//        {
//            
//        }
//            break;
//        default:
//            break;
//    }
}

- (void)proceedToGame
{
    //check game type
    if([[[myTurnGamesArray objectAtIndex:selectedGame] objectForKey:@"my_action"] isEqualToString:@"send_data"])
    {
        //check game type an go to record screen or draw
        if([[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"type"] isEqualToString:@"image"])
        {
            DrawViewController *drawViewController = [[DrawViewController alloc]initWithNibName:@"DrawViewController" bundle:nil GameData:[myTurnGamesArray objectAtIndex:selectedGame]];
            [self presentViewController:drawViewController animated:YES completion:nil];
//            [drawViewController release];
        }
        if([[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"type"] isEqualToString:@"audio"])
        {
            NSMutableDictionary *wordDict = [[NSMutableDictionary alloc]init];
            [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"coins"] forKey:@"coins"];
            [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"word_id"] forKey:@"id"];
            [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"time"] forKey:@"time"];
            [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"type"] forKey:@"type"];
            [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"word"] forKey:@"word"];
            
            [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"coins"];
            [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"word_id"];
            [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"time"];
            [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"type"];
            [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"word"];
            [[myTurnGamesArray objectAtIndex:selectedGame] setValue:wordDict forKey:@"word"];
//            [wordDict release];
            
            RecordWordViewController *recordWordViewController = [[RecordWordViewController alloc]initWithNibName:@"RecordWordViewController" bundle:nil RecordType:recordSound GameData:[myTurnGamesArray objectAtIndex:selectedGame]];
            [self presentViewController:recordWordViewController animated:YES completion:nil];
//            [recordWordViewController release];
        }
        if([[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"type"] isEqualToString:@"video"])
        {
            NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            if ([videoDevices count] == 0 )
            {
                [appDelegate hideLoadingActivity];
                [appDelegate showAlert:@"This device doesn't have camera, and you can't continue this game from this device." CancelButton:nil OkButton:@"OK" Type:noCameraAlert Sender:self];
                return;
            }

            NSMutableDictionary *wordDict = [[NSMutableDictionary alloc]init];
            [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"coins"] forKey:@"coins"];
            [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"word_id"] forKey:@"id"];
            [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"time"] forKey:@"time"];
            [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"type"] forKey:@"type"];
            [wordDict setValue:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"word"] forKey:@"word"];
            
            [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"coins"];
            [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"word_id"];
            [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"time"];
            [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"type"];
            [[myTurnGamesArray objectAtIndex:selectedGame] removeObjectForKey:@"word"];
            [[myTurnGamesArray objectAtIndex:selectedGame] setValue:wordDict forKey:@"word"];
//            [wordDict release];
            
            RecordWordViewController *recordWordViewController = [[RecordWordViewController alloc]initWithNibName:@"RecordWordViewController" bundle:nil RecordType:recordVideo GameData:[myTurnGamesArray objectAtIndex:selectedGame]];
            [self presentViewController:recordWordViewController animated:YES completion:nil];
//            [recordWordViewController release];
        }
    }
    if([[[myTurnGamesArray objectAtIndex:selectedGame] objectForKey:@"my_action"] isEqualToString:@"finish_game"])
    {
        //have to guess
        //get game details
        [appDelegate showLoadingActivity];
        [APIManager setSender:self];
        [APIManager getGameDetails:[[myTurnGamesArray objectAtIndex:selectedGame]objectForKey:@"game_round_id"] Token:appDelegate.userData.token Version:appDelegate.version andTag:gameDetailsRequest];
    }
    if([[[myTurnGamesArray objectAtIndex:selectedGame] objectForKey:@"my_action"] isEqualToString:@"continue_game"])
    {
        //turn ended, create a new round
        [appDelegate showLoadingActivity];
        [APIManager setSender:self];
        [APIManager getGameWords:[[myTurnGamesArray objectAtIndex:selectedGame] objectForKey:@"player"] WithBubbles:NO Token:appDelegate.userData.token Version:appDelegate.version andTag:gameWordsRequest];
    }
}

#pragma mark - Tapjoy callback
- (void)tapjoyClosed:(NSNotification*)notification
{
    [appDelegate showLoadingActivity];
    [Tapjoy getTapPointsWithCompletion:^(NSDictionary *parameters, NSError *error)
     {
         if (!error)
         {
             if([parameters[@"amount"] intValue] > 0)
             {
                 [APIManager setSender:self];
                 [APIManager purchasedCoins:[NSString stringWithFormat:@"%d",-[parameters[@"amount"] intValue]]
                                      Extra:@""
                                      Token:appDelegate.userData.token
                                     Version:appDelegate.version andTag:purchasedCoinsRequest];
                 return ;
            }
         }
         [appDelegate hideLoadingActivity];
     }];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void)handleSwipeFrom:(UIGestureRecognizer*)recognizer
{
    int row = [[[NSString stringWithFormat:@"%ld",recognizer.view.tag] substringFromIndex:1]intValue];
    int col = [[[NSString stringWithFormat:@"%ld", recognizer.view.tag] substringToIndex:1]intValue]-1;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:col];
    CGRect rectInTableView = [tbl rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperview = [tbl convertRect:rectInTableView toView:self.view];
    
    UIButton *cancelDeleteButton = [[UIButton alloc]init];
    cancelDeleteButton.frame = self.view.frame;
    cancelDeleteButton.tag = 100000000+row;
    cancelDeleteButton.backgroundColor = [UIColor clearColor];
    [cancelDeleteButton addTarget:self action:@selector(cancelDeleteButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelDeleteButton];
    
    UIButton *deleteButton = [[UIButton alloc]init];
    deleteButton.tag = -(100000000+row);
    deleteButton.frame = CGRectMake(rectInSuperview.size.width, rectInSuperview.origin.y+(48-33)/2, 64, 33);
    [deleteButton setImage:[UIImage imageNamed:@"delete-button.png"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.contentMode = UIViewContentModeLeft;
    deleteButton.imageView.contentMode = UIViewContentModeLeft;

    [self.view addSubview:deleteButton];
    
    deleteButton.frame = CGRectMake(rectInSuperview.size.width+10, rectInSuperview.origin.y+(48-33)/2, 0, 33);
    [UIView animateWithDuration:0.25 animations:^{
        deleteButton.frame = CGRectMake(rectInSuperview.size.width-64+10, rectInSuperview.origin.y+(48-33)/2, 64, 33);
    } completion:^(BOOL finished)
    {
        
    }];
}

- (void)deleteButtonTUI:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.view viewWithTag:[sender tag]].frame = CGRectMake([self.view viewWithTag:[sender tag]].frame.origin.x+64, [self.view viewWithTag:[sender tag]].frame.origin.y, 0, [self.view viewWithTag:[sender tag]].frame.size.height);
    } completion:^(BOOL finished)
     {
         [[self.view viewWithTag:[sender tag]]removeFromSuperview];
         [[self.view viewWithTag:-[sender tag]] removeFromSuperview];
     }];
    selectedGameForDeletion = -[sender tag]-100000000;
    [appDelegate showAlert:@"Are you sure you want to delete this game" CancelButton:@"NO" OkButton:@"YES" Type:deleteGameAlert Sender:self];
}

- (void)cancelDeleteButtonTUI:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.view viewWithTag:-[sender tag]].frame = CGRectMake([self.view viewWithTag:-[sender tag]].frame.origin.x+64, [self.view viewWithTag:-[sender tag]].frame.origin.y, 0, [self.view viewWithTag:-[sender tag]].frame.size.height);
    } completion:^(BOOL finished)
     {
         [[self.view viewWithTag:[sender tag]] removeFromSuperview];
         [[self.view viewWithTag:-[sender tag]] removeFromSuperview];
     }];
}

- (void)handleEnteredForeground
{
    UIViewController *topController = appDelegate.window.rootViewController;
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    
    if([topController isKindOfClass:[HomeViewController class]])
    {
        [self refresh];
    }
}

@end
