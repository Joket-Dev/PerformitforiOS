//
//  LeaderboardViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/2/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "LeaderboardViewController.h"

#import "LeaderboardCellView.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController
@synthesize backgroundIV;
@synthesize homeButton;
@synthesize tbl;
@synthesize leaderboardArray;

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
        tbl.frame = CGRectMake(tbl.frame.origin.x, tbl.frame.origin.y, tbl.frame.size.width, tbl.frame.size.height-3);
    }
    leaderboardArray = [[NSMutableArray alloc]init];
    tbl.backgroundColor = [UIColor clearColor];
    tbl.showsVerticalScrollIndicator = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidAppear:(BOOL)animated
{
    endThread = NO;
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    [APIManager getLeaderboard:appDelegate.userData.token Version:appDelegate.version andTag:leaderboardRequest];
}

//- (void)dealloc
//{
//    [backgroundIV release];
//    [homeButton release];
//    [tbl release];
//    [leaderboardArray release];
//    
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
}

- (IBAction)homeButtonTUI:(id)sender
{
//    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableview Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [leaderboardArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(!dataAvailable)
        return cell;
    
    UIImage *image = [self getFriendImage:[[leaderboardArray objectAtIndex:indexPath.row] objectForKey:@"picture"]];
    if(image == nil)
        image = [UIImage imageNamed:@"opponent-no-image.png"];

    LeaderboardCellView *leaderboardCellView = [[LeaderboardCellView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.rowHeight) Image:image Name:[[leaderboardArray objectAtIndex:indexPath.row] objectForKey:@"name"] Score:[[[leaderboardArray objectAtIndex:indexPath.row] objectForKey:@"coins"]intValue]];
    
//    UIButton *btn = [[UIButton alloc]init];
//    btn.frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.rowHeight);
//    btn.tag = indexPath.row;
//    [btn setImage:[Utilities imageWithView:leaderboardCellView] forState:UIControlStateNormal];
//    [cell addSubview:btn];
//    [btn release];
    [cell addSubview:leaderboardCellView];
//    [leaderboardCellView release];
    
    return cell;
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
        case leaderboardRequest:
        {//get leaderboard
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //update list
                    [leaderboardArray setArray:[[dict objectForKey:@"response"]objectForKey:@"response"]];
                    dataAvailable = YES;
                    [tbl reloadData];
                    endThread = NO;
                    [self getLazyImages:leaderboardArray];
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



@end
