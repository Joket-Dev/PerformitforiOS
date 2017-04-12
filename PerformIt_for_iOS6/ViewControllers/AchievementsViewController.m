//
//  AchievementsViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/2/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "AchievementsViewController.h"

#import "AchievementCellView.h"
#import "AchievementView.h"
#import "AchievementCompletedView.h"

#define kkAchievementCompleted 1000
#define kkAchievementInProgress 1001

@interface AchievementsViewController ()

@end

@implementation AchievementsViewController
@synthesize backgroundIV;
@synthesize homeButton;
@synthesize tbl;

@synthesize popupView;

@synthesize achievementsArray;
@synthesize achievementPopups;

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
        backgroundIV.image = [UIImage imageNamed:@"achivements-bg-568h@2x.png"];
        backgroundIV.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        tbl.frame = CGRectMake(tbl.frame.origin.x, tbl.frame.origin.y+3, tbl.frame.size.width, tbl.frame.size.height-3);
    }
    tbl.backgroundColor = [UIColor clearColor];
    tbl.showsVerticalScrollIndicator = NO;
    achievementsArray = [[NSMutableArray alloc]init];
    achievementPopups = [[NSMutableArray alloc]init];
    
    popupView.hidden = YES;
    dataAvailable = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidAppear:(BOOL)animated
{
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    [APIManager getAchievements:appDelegate.userData.token Version:appDelegate.version andTag:achievementsRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (void)dealloc
//{
//    [backgroundIV release];
//    [homeButton release];
//    [tbl release];
//    [popupView release];
//    [achievementsArray release];
//    [achievementPopups release];
//    
//    [super dealloc];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [APIManager cancelRequest];
}

- (IBAction)homeButtonTUI:(id)sender
{
//    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closePopupButtonTUI:(id)sender
{
    if([sender tag] == kkAchievementInProgress)
    {
        [self dismissAchievementPopup];
        return;
    }
    if([sender tag] == kkAchievementCompleted)
    {
        [self dismissAchievementCompletedPopup];

        return;
    }
}

#pragma mark - Delegates Methods
- (void)showAchievementPopup:(NSInteger)index
{
    //init popup
    AchievementView *achievementView = [[AchievementView alloc]initWithFrame:CGRectMake(10, 99, 303, 350) AchievementName:[[achievementsArray objectAtIndex:index]objectForKey:@"name"] AchievementProgress:[NSString stringWithFormat:@"%@/%@",[[achievementsArray objectAtIndex:index]objectForKey:@"achieved"],[[achievementsArray objectAtIndex:index]objectForKey:@"target"]] AchievementDetails:[[achievementsArray objectAtIndex:index]objectForKey:@"description"] AchievementCoins:[[achievementsArray objectAtIndex:index]objectForKey:@"coins"] AchievementImage:[NSString stringWithFormat:@"achievement-%@.png",[[achievementsArray objectAtIndex:index]objectForKey:@"achievement_type_id"]] Sender:self Type:kkAchievementInProgress];
    [popupView addSubview:achievementView];
    [achievementPopups addObject:achievementView];
//    [achievementView release];
    
    popupView.hidden = NO;
    achievementView.frame = CGRectMake(appDelegate.screenWidth/2, (appDelegate.screenHeight-20)/2, 0, 0);
    [UIView animateWithDuration:.2 animations:^{
        achievementView.frame = CGRectMake(10, (appDelegate.screenHeight-350-20)/2, 303, 350);
        NSLog(@"%f",achievementView.frame.origin.x);
    } completion:^(BOOL finished) {
        popupView.userInteractionEnabled = YES;
    }];
}

- (void)dismissAchievementPopup
{
    popupView.userInteractionEnabled = NO;
    AchievementView *achievementView = (AchievementView*)[achievementPopups lastObject];
    [UIView animateWithDuration:0.2 animations:^{
        achievementView.frame = CGRectMake(achievementView.center.x, achievementView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         popupView.userInteractionEnabled = YES;
         popupView.hidden = YES;
         [achievementView removeFromSuperview];
         [achievementPopups removeLastObject];
     }];
}

- (void)showAchievementCompletedPopup:(NSInteger)index
{
    //init popup
     AchievementCompletedView *achievementView = [[AchievementCompletedView alloc]initWithFrame:CGRectMake(10, 99, 303, 350) AchievementName:[[achievementsArray objectAtIndex:index]objectForKey:@"name"] AchievementCoins:[[achievementsArray objectAtIndex:index]objectForKey:@"coins"] AchievementImage:[NSString stringWithFormat:@"achievement-%@.png",[[achievementsArray objectAtIndex:index]objectForKey:@"achievement_type_id"]] Sender:self Type:kkAchievementCompleted];
    [popupView addSubview:achievementView];
    [achievementPopups addObject:achievementView];
//    [achievementView release];
    
    popupView.hidden = NO;
    achievementView.frame = CGRectMake(appDelegate.screenWidth/2, (appDelegate.screenHeight-20)/2, 0, 0);
    [UIView animateWithDuration:.2 animations:^{
        achievementView.frame = CGRectMake(10, (appDelegate.screenHeight-350-20)/2, 303, 350);
        NSLog(@"%f",achievementView.frame.origin.x);
    } completion:^(BOOL finished) {
        popupView.userInteractionEnabled = YES;
    }];
}

- (void)dismissAchievementCompletedPopup
{
    popupView.userInteractionEnabled = NO;
    AchievementCompletedView *achievementView = (AchievementCompletedView*)[achievementPopups lastObject];
    [UIView animateWithDuration:0.2 animations:^{
        achievementView.frame = CGRectMake(achievementView.center.x, achievementView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         popupView.userInteractionEnabled = YES;
         popupView.hidden = YES;
         [achievementView removeFromSuperview];
         [achievementPopups removeLastObject];
     }];
}

#pragma mark - UITableview Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return achevementLines;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(dataAvailable)
    {
        int index = (int)(indexPath.row * 2);

//
//    BOOL achieved = NO;
//    if([[[achievementsArray objectAtIndex:index]objectForKey:@"achieved"]intValue] == [[[achievementsArray objectAtIndex:index]objectForKey:@"target"]intValue])
//        achieved = YES;
//    
//    AchievementCellView *achievementCellView = [[AchievementCellView alloc]initWithFrame:CGRectMake(0, 0, 150,160) AchievementType:[NSString stringWithFormat:@"achievement-%d",[[[achievementsArray objectAtIndex:index]objectForKey:@"achievement_type_id"]intValue]] Achieved:achieved Completed:[[[achievementsArray objectAtIndex:index]objectForKey:@"achieved"]intValue] From:[[[achievementsArray objectAtIndex:index]objectForKey:@"target"]intValue] AchievementName:[[achievementsArray objectAtIndex:index]objectForKey:@"name"]];
//    
//    UIImage *leftImage = [Utilities imageWithView:achievementCellView];
//    [achievementCellView release];
    
    UIButton *leftColumnButton = [[UIButton alloc]init];
    leftColumnButton.exclusiveTouch = YES;
    leftColumnButton.tag = index;
    leftColumnButton.frame = CGRectMake(0, 0, 150, 160);
    leftColumnButton.backgroundColor = [UIColor clearColor];
    [leftColumnButton setImage:[[achievementsArray objectAtIndex:index]objectForKey:@"icon"] forState:UIControlStateNormal];
    [leftColumnButton addTarget:self action:@selector(achievementSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:leftColumnButton];
//    [leftColumnButton release];
    
    if(index+1 < [achievementsArray count])
    {
        index++;
//        BOOL achieved = NO;
//        if([[[achievementsArray objectAtIndex:index]objectForKey:@"achieved"]intValue] == [[[achievementsArray objectAtIndex:index]objectForKey:@"target"]intValue])
//            achieved = YES;
//        
//        AchievementCellView *achievementCellView = [[AchievementCellView alloc]initWithFrame:CGRectMake(0, 0, 150,160) AchievementType:[NSString stringWithFormat:@"achievement-%d",[[[achievementsArray objectAtIndex:index]objectForKey:@"achievement_type_id"]intValue]] Achieved:achieved Completed:[[[achievementsArray objectAtIndex:index]objectForKey:@"achieved"]intValue] From:[[[achievementsArray objectAtIndex:index]objectForKey:@"target"]intValue] AchievementName:[[achievementsArray objectAtIndex:index]objectForKey:@"name"]];
//        
//        UIImage *rightImage = [Utilities imageWithView:achievementCellView];
//        [achievementCellView release];
        
        UIButton *rightColumnButton = [[UIButton alloc]init];
        rightColumnButton.exclusiveTouch = YES;
        rightColumnButton.tag = index;
        rightColumnButton.frame = CGRectMake(150-2, 0, 150, 160);
        rightColumnButton.backgroundColor = [UIColor clearColor];
        [rightColumnButton setImage:[[achievementsArray objectAtIndex:index]objectForKey:@"icon"] forState:UIControlStateNormal];
        [rightColumnButton addTarget:self action:@selector(achievementSelected:) forControlEvents:UIControlEventTouchUpInside];

        [cell addSubview:rightColumnButton];
//        [rightColumnButton release];
    }
    
    //    AchievementCellView *rightAchievementCellView = [[AchievementCellView alloc]initWithFrame:CGRectMake(0, 0, 150,160) AchievementType:@"audio-achievement-completed.png" Achieved:YES Completed:99 From:100];
    //
    //    UIImage *rightImage = [Utilities imageWithView:rightAchievementCellView];
    //    [rightAchievementCellView release];
    //
    //    UIButton *rightColumnButton = [[UIButton alloc]init];
    //    rightColumnButton.frame = CGRectMake(150-2, 0, 150, 160);
    //    rightColumnButton.backgroundColor = [UIColor clearColor];
    //    [rightColumnButton setImage:rightImage forState:UIControlStateNormal];
    //    [cell addSubview:rightColumnButton];
    //    [rightColumnButton release];
    }
    return cell;
}

- (void)achievementSelected:(id)sender
{
    if([[[achievementsArray objectAtIndex:[sender tag]]objectForKey:@"achieved"]intValue] == [[[achievementsArray objectAtIndex:[sender tag]]objectForKey:@"target"]intValue])
    {
        [self showAchievementCompletedPopup:[sender tag]];
    }else
    {
        [self showAchievementPopup:[sender tag]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:NO animated:YES];
    
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
        case achievementsRequest:
        {//get achievements list
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout                
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    dataAvailable = YES;
                    [achievementsArray setArray:[[dict objectForKey:@"response"]objectForKey:@"response"]];
                    achevementLines = roundf((float)[achievementsArray count]/2.0);
                    [appDelegate showLoadingActivity];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        for (int i = 0; i < [achievementsArray count]; i++)
                        {
                            BOOL achieved = NO;
                            if([[[achievementsArray objectAtIndex:i]objectForKey:@"achieved"]intValue] == [[[achievementsArray objectAtIndex:i]objectForKey:@"target"]intValue])
                                achieved = YES;
                            
                            AchievementCellView *achievementCellView = [[AchievementCellView alloc]initWithFrame:CGRectMake(0, 0, 150,160) AchievementType:[NSString stringWithFormat:@"achievement-%d",[[[achievementsArray objectAtIndex:i]objectForKey:@"achievement_type_id"]intValue]] Achieved:achieved Completed:[[[achievementsArray objectAtIndex:i]objectForKey:@"achieved"]intValue] From:[[[achievementsArray objectAtIndex:i]objectForKey:@"target"]intValue] AchievementName:[[achievementsArray objectAtIndex:i]objectForKey:@"name"]];
                            [[achievementsArray objectAtIndex:i] setValue:[Utilities imageWithView:achievementCellView] forKey:@"icon"];
//                            [achievementCellView release];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [appDelegate hideLoadingActivity];
                            [tbl reloadData];
                        });
                    });
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
        switch ([sender tag])
        {
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

@end
