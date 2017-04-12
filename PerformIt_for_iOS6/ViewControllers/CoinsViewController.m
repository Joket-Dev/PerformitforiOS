//
//  CoinsViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 6/24/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "CoinsViewController.h"

@interface CoinsViewController ()

@end

@implementation CoinsViewController
@synthesize backgroundIV;
@synthesize homeButton;
@synthesize mainScrollView;

@synthesize coinsArray;

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
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([appDelegate isIPHONE5])
    {
        backgroundIV.image = [UIImage imageNamed:@"achivements-bg-568h@2x.png"];
        backgroundIV.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        mainScrollView.frame = CGRectMake(mainScrollView.frame.origin.x, mainScrollView.frame.origin.y-2, mainScrollView.frame.size.width, mainScrollView.frame.size.height+80);
    }
    mainScrollView.delegate = self;
    mainScrollView.showsVerticalScrollIndicator = NO;
        
    coinsArray = [[NSMutableArray alloc]init];
    
    //$$$Yy$$  set comment inApp purchase code for simple
//    for (int i = 0; i < [appDelegate.inAppCoins count]; i++)
//    {
//        if([[[appDelegate.inAppCoins objectAtIndex:i]objectForKey:@"available"]boolValue])
//            [coinsArray addObject:[appDelegate.inAppCoins objectAtIndex:i]];
//    }
    
    //$0.99 (106 coins), $1.99 (180 coins), $2.99 (222 coins), $4.99 (450 coins), $9.99 (1130 coins), $19.99 (10,223 coins), and $49.99 (1,012,018 coins)
    
    NSArray * ary_Price = @[ @"0.99", @"1.99", @"2.99", @"4.99", @"9.99", @"19.99", @"49.99" ];
    NSArray * ary_Coins = @[ @106, @180, @222, @450, @1130, @10223, @1012018 ];
    
    for ( int i = 0; i < 7; i ++ ) {
        NSDictionary * dicData = @{ @"price": ary_Price[i], @"coins": ary_Coins[i] };
        [coinsArray addObject:dicData];
    }
    
    [self addCoins:coinsArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%f",mainScrollView.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated
{
//    [appDelegate showLoadingActivity];
//    [APIManager setSender:self];
//    [APIManager getAvailableCoins:appDelegate.userData.token Version:appDelegate.version andTag:availableCoinsRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (void)dealloc
//{
//    [backgroundIV release];
//    [homeButton release];
//    [mainScrollView release];
//    [coinsArray release];
//    [super dealloc];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [APIManager cancelRequest];
}

- (void)addCoins:(NSMutableArray*)coins_array
{
    int xOffset = 0;
    int yOffset = 0;
    int line = 0;
    int column = 0;
    for (int i = 0; i < [coins_array count]; i++)
    {
        if(column == 3)
        {
            column = 0;
            line++;
        }
        xOffset = 3 * (column+1) + column * 96;
        yOffset = 10 + line * (127+13);
        column++;
        
        UIView *coinView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 96, 127)];
       
        UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coin-button-bg.png"]];
        bgIV.frame = CGRectMake(0, 0, coinView.frame.size.width, coinView.frame.size.height);
        [coinView addSubview:bgIV];
//        [bgIV release];
        
        LabelBorder *coinPriceLabel = [[LabelBorder alloc]init];
        coinPriceLabel.frame = CGRectMake(5, 5, coinView.frame.size.width-2*5, 20);
        coinPriceLabel.backgroundColor = [UIColor clearColor];
        coinPriceLabel.textColor = [UIColor whiteColor];
        coinPriceLabel.font = [UIFont fontWithName:@"Marvin" size:20];
        coinPriceLabel.minimumFontSize = 12;
        coinPriceLabel.adjustsFontSizeToFitWidth = YES;
        if([appDelegate  isIPHONE5])
            coinPriceLabel.textAlignment = NSTextAlignmentCenter;
        else
            coinPriceLabel.textAlignment = NSTextAlignmentCenter;
        coinPriceLabel.text = [NSString stringWithFormat:@"$ %@",[[coins_array objectAtIndex:i]objectForKey:@"price"]];
        [coinView addSubview:coinPriceLabel];
//        [coinPriceLabel release];
        

        LabelBorder *coinValueLabel = [[LabelBorder alloc]init];
        coinValueLabel.frame = CGRectMake(5, 5+20, coinView.frame.size.width-2*5, 20);
        coinValueLabel.backgroundColor = [UIColor clearColor];
        coinValueLabel.textColor = [UIColor whiteColor];
        coinValueLabel.font = [UIFont fontWithName:@"Marvin" size:14];
        coinValueLabel.minimumFontSize = 10;
        coinValueLabel.adjustsFontSizeToFitWidth = YES;
        if([appDelegate  isIPHONE5])
            coinValueLabel.textAlignment = NSTextAlignmentCenter;
        else
            coinValueLabel.textAlignment = NSTextAlignmentCenter;
        coinValueLabel.text = [NSString stringWithFormat:@"%@ COINS",[Utilities formatCoins:[[[coins_array objectAtIndex:i]objectForKey:@"coins"]intValue]]];
        [coinView addSubview:coinValueLabel];
//        [coinValueLabel release];

        UIImageView *coinsIcon = [[UIImageView alloc]init];
        if([[[coins_array objectAtIndex:i]objectForKey:@"coins"]intValue] < 3.0)
            coinsIcon.image = [UIImage imageNamed:@"coins-categ-min.png"];
        else
            if([[[coins_array objectAtIndex:i]objectForKey:@"coins"]intValue] >= 3.0 && [[[coins_array objectAtIndex:i]objectForKey:@"coins"]intValue] < 10.0)
                coinsIcon.image = [UIImage imageNamed:@"coins-categ-med.png"];
        if([[[coins_array objectAtIndex:i]objectForKey:@"coins"]intValue] >= 10.0)
            coinsIcon.image = [UIImage imageNamed:@"coins-categ-max.png"];

        coinsIcon.frame = CGRectMake((coinView.frame.size.width-77)/2, coinView.frame.size.height-5-60, 77, 60);
        [coinView addSubview:coinsIcon];
//        [coinsIcon release];
        UIButton *itemButton = [[UIButton alloc]init];
        itemButton.frame = CGRectMake(xOffset, yOffset, 96, 127);
        [itemButton setImage:[Utilities imageWithView:coinView] forState:UIControlStateNormal];
//        [coinView release];
        [itemButton addTarget:self action:@selector(coinsSelectedTUI:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = i;
        [mainScrollView addSubview:itemButton];
//        [itemButton release];
    }
    yOffset = yOffset + 127+13;
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, yOffset);
}

- (IBAction)homeButtonTUI:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        case availableCoinsRequest:
        {//send game data image/video
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    [coinsArray setArray:[[dict objectForKey:@"response"]objectForKey:@"response"]];
                    [self addCoins:coinsArray];
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
        case purchasedCoinsRequest:
        {//send game data image/video
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                [appDelegate.inApp finishCurrentTransaction:NO];
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //success
                    [appDelegate.inApp finishCurrentTransaction:YES];
                    
                    [appDelegate showAlert:@"Coins successfully purchased." CancelButton:nil OkButton:@"OK" Type:buyOkAlert Sender:self];
                }else
                {
                    [appDelegate.inApp finishCurrentTransaction:NO];

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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 16)
                    {
                        //Invalid coin value.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                    }
                }
            }
        }
            break;
        case buyCoinsRequest:
        {//send game data image/video
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                [appDelegate.inApp finishCurrentTransaction:NO];
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //success
                    
                    [appDelegate showAlert:@"Coins successfully purchased." CancelButton:nil OkButton:@"OK" Type:buyOkAlert Sender:self];
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
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"Update" Type:newVersionAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 2)
                    {
                        //Invalid app_id
                        [appDelegate showAlert:@"Another session with the same user name already exists. Click OK to login and disconnect the other session." CancelButton:nil OkButton:@"OK" Type:invalidAppIDAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 16)
                    {
                        //Invalid coin value.
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

- (void)coinsSelectedTUI:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    selectedCoinsID = (int)btn.tag;//[[[coinsArray objectAtIndex:btn.tag]objectForKey:@"id"]intValue];
  
    
    // $$$Yy@@  set comment inApp purchase code for simple
    //in-app purchase
//    [appDelegate showLoadingActivity];
//    [appDelegate setCurrentlyBuying:YES];
//    [appDelegate.inApp purchaseProduct:[[coinsArray objectAtIndex:selectedCoinsID]objectForKey:@"product"]];
    
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    [APIManager buyCoins:[coinsArray objectAtIndex:btn.tag] Token:appDelegate.userData.token Version:appDelegate.version andTag:buyCoinsRequest];
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
//        case buyCoinsAlert:
//        {
//            //in-app purchase
//            [appDelegate showLoadingActivity];
//            [appDelegate setCurrentlyBuying:YES];
//            //[appDelegate setProductCoins:[[coinValues objectAtIndex:btn.tag-1]intValue]];
//            //[[coinsArray objectAtIndex:selectedCoinsID]objectForKey:@"coins"]
//            [appDelegate.inApp purchaseProduct:[NSString stringWithFormat:@"%@%@",kCoinsInapp,[[coinsArray objectAtIndex:selectedCoinsID]objectForKey:@"coins"]]];
//            return;
//            [APIManager setSender:self];
//            [APIManager purchasedCoins:[NSString stringWithFormat:@"%d",selectedCoinsID] Extra:@"" Token:appDelegate.userData.token Version:appDelegate.version andTag:purchasedCoinsRequest];
//        }
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

- (void)buyCoinsWithTRansaction:(SKPaymentTransaction*)transaction
{
    NSString *string = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    [APIManager setSender:self];
    [APIManager purchasedCoins:[NSString stringWithFormat:@"%d",selectedCoinsID+1]
                         Extra: string
                         Token:appDelegate.userData.token
                        Version:appDelegate.version andTag:purchasedCoinsRequest];
//    [string release];
}

@end
