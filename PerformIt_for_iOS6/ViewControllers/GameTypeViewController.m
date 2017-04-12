//
//  GameTypeViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/6/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "GameTypeViewController.h"
#import "RecordWordViewController.h"
#import "DrawViewController.h"
#import "NewGamePopupViewController.h"
#import "CoinsViewController.h"

#import "LabelBorder.h"

#define imageType 1
#define audioType 2
#define videoType 3

@interface GameTypeViewController ()

@end

@implementation GameTypeViewController
@synthesize backgroundIV;
@synthesize homeButton;
@synthesize changeWordsButton;
@synthesize mainView;
@synthesize coinsButton;
@synthesize gameDict;

@synthesize popupView;
@synthesize popupLabel;
@synthesize bubblesPopupView;
@synthesize bubblesScrollView;
@synthesize closePopupButton;
@synthesize bubblesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithUser:(int)opponent_id AndData:(NSMutableDictionary*)dict Game:(int)game_id Continue:(BOOL)continue_game
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        continueGame = continue_game;
        opponentID = opponent_id;
        selectedGameID = game_id;
        wordsDict = [[NSMutableDictionary alloc]init];
        [wordsDict setDictionary:dict];
    }
    return self;
}

//- (void)dealloc
//{
//    [backgroundIV release];
//    [homeButton release];
//    [changeWordsButton release];
//    [mainView release];
//    [coinsButton release];
//    [gameDict release];
//    [popupView release];
//    [popupLabel release];
//    [bubblesPopupView release];
//    [bubblesScrollView release];
//    [closePopupButton release];
//    [bubblesArray release];
//    [super dealloc];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([appDelegate isIPHONE5])
    {
        backgroundIV.image = [UIImage imageNamed:@"game-type-bg-568h@2x"];
        backgroundIV.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
    }
    //init sections
    while ([mainView.subviews count] > 0)
        [[[mainView subviews] objectAtIndex:0] removeFromSuperview];
        
    [self initWordSection:@"image" Word:[[wordsDict objectForKey:@"image_word"]objectForKey:@"word"] CoinsValue:[[[wordsDict objectForKey:@"image_word"]objectForKey:@"coins"]intValue] Offset:12 Tag:imageType];
    [self initWordSection:@"audio" Word:[[wordsDict objectForKey:@"audio_word"]objectForKey:@"word"] CoinsValue:[[[wordsDict objectForKey:@"audio_word"]objectForKey:@"coins"]intValue] Offset:108 Tag:audioType];
    [self initWordSection:@"video" Word:[[wordsDict objectForKey:@"video_word"]objectForKey:@"word"] CoinsValue:[[[wordsDict objectForKey:@"video_word"]objectForKey:@"coins"]intValue] Offset:204 Tag:videoType];
    
    //init button
    UIView *changeWordsButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, changeWordsButton.frame.size.width, changeWordsButton.frame.size.height)];
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"change-words-button.png"]];
    bgIV.frame = changeWordsButtonView.frame;
    [changeWordsButtonView addSubview:bgIV];
//    [bgIV release];
   
    LabelBorder *buttonLabel = [[LabelBorder alloc]init];
    buttonLabel.frame = changeWordsButtonView.frame;
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.textColor = [UIColor whiteColor];
    buttonLabel.font = [UIFont fontWithName:@"marvin" size:14];
    if([appDelegate isIPHONE5])
        buttonLabel.textAlignment = NSTextAlignmentCenter;
    else
        buttonLabel.textAlignment = NSTextAlignmentCenter;
    if(appDelegate.userData.bubbles > 0)
        buttonLabel.text = [NSString stringWithFormat:@"%d BUBBLES",appDelegate.userData.bubbles];
    else
        buttonLabel.text = @"BUY BUBBLES";
    buttonLabel.numberOfLines = 0;
    if([appDelegate isIOS6])
        buttonLabel.lineBreakMode = NSLineBreakByWordWrapping;
    else
        buttonLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [changeWordsButtonView addSubview:buttonLabel];
//    [buttonLabel release];
    
    [changeWordsButton setImage:[Utilities imageWithView:changeWordsButtonView] forState:UIControlStateNormal];
//    [changeWordsButtonView release];
    gameDict = [[NSMutableDictionary alloc]init];
    
    coinsButton = [[UIButton alloc]init];
    coinsButton.exclusiveTouch = YES;
    coinsButton.frame = CGRectMake(27, appDelegate.screenHeight-40-5, 45+16+5+50, 20);
    [coinsButton addTarget:self action:@selector(coinsButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:coinsButton];
//    [coinsButton release];
    [self addCoinsButton];
    
    //init popup
    popupView.hidden = YES;
    //popup label
    
    popupLabel.font = [UIFont fontWithName:@"marvin" size:18];
    if([appDelegate isIPHONE5])
        popupLabel.textAlignment = NSTextAlignmentRight;
    else
        popupLabel.textAlignment = NSTextAlignmentRight;
    popupLabel.text = @"PURCHASE BUBBLES";
    bubblesArray = [[NSMutableArray alloc]init];

}

- (void) viewWillAppear:(BOOL)animated
{
    homeButton.hidden = NO;
    
    //get bubbles count
    [APIManager setSender:self];
    [APIManager getBubbles:appDelegate.userData.token Version:appDelegate.version andTag:getBubblesRequest];
    
    //get bubble list
    [APIManager getAvailableBubbles:appDelegate.userData.token Version:appDelegate.version andTag:getAvailableBubblesRequest];

}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [APIManager cancelRequest];
}

- (void)initWordSection:(NSString*)wordType Word:(NSString*)word CoinsValue:(int)coinsVal Offset:(int)yOffset Tag:(int)tag
{
    UIImageView *headerIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"word-selection-header-bg.png"]];
    headerIV.frame = CGRectMake(6, yOffset, 282, 26);
    [mainView addSubview:headerIV];
//    [headerIV release];
    
    LabelBorder *gameTypeLabel = [[LabelBorder alloc]init];
    gameTypeLabel.frame = CGRectMake(15, headerIV.frame.origin.y+(headerIV.frame.size.height-20)/2, 100, 20);
    gameTypeLabel.backgroundColor = [UIColor clearColor];
    gameTypeLabel.textColor = [UIColor whiteColor];
    gameTypeLabel.font = [UIFont fontWithName:@"marvin" size:18];
    if([appDelegate isIPHONE5])
        gameTypeLabel.textAlignment = NSTextAlignmentLeft;
    else
        gameTypeLabel.textAlignment = NSTextAlignmentLeft;
    gameTypeLabel.text = [wordType uppercaseString];
    [mainView addSubview:gameTypeLabel];
//    [gameTypeLabel release];
    
    UIImageView *coinIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small-coin-icon.png"]];
    coinIV.frame = CGRectMake(headerIV.frame.origin.x+headerIV.frame.size.width-10-16, headerIV.frame.origin.y+(headerIV.frame.size.height-16)/2, 16, 16);
    [mainView addSubview:coinIV];
//    [coinIV release];
    
    LabelBorder *coinsLabel = [[LabelBorder alloc]init];
    coinsLabel.frame = CGRectMake(coinIV.frame.origin.x-10-80, headerIV.frame.origin.y+(headerIV.frame.size.height-20)/2, 80, 20);
    coinsLabel.backgroundColor = [UIColor clearColor];
    coinsLabel.textColor = [UIColor whiteColor];
    coinsLabel.font = [UIFont fontWithName:@"marvin" size:20];
    if([appDelegate isIPHONE5])
        coinsLabel.textAlignment = NSTextAlignmentRight;
    else
        coinsLabel.textAlignment = NSTextAlignmentRight;
    coinsLabel.text = [NSString stringWithFormat:@"%d",coinsVal];
    [mainView addSubview:coinsLabel];
//    [coinsLabel release];
    
    UIButton *wordSelectButton = [[UIButton alloc]init];
    wordSelectButton.exclusiveTouch = YES;
    wordSelectButton.frame = CGRectMake(headerIV.frame.origin.x, headerIV.frame.origin.y+headerIV.frame.size.height, headerIV.frame.size.width, 58);
    wordSelectButton.tag = tag;
    [wordSelectButton addTarget:self action:@selector(wordSelected:) forControlEvents:UIControlEventTouchUpInside];
    UIView *buttonBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wordSelectButton.frame.size.width, wordSelectButton.frame.size.height)];
    
    UIImageView *bgIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"word-selection-bg.png"]];
    bgIV.frame = CGRectMake(0, 0, wordSelectButton.frame.size.width, wordSelectButton.frame.size.height);
    [buttonBgView addSubview:bgIV];
//    [bgIV release];
    
    UIImageView *wordTypeIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"word-%@-icon.png",wordType]]];
    wordTypeIV.frame = CGRectMake(20, buttonBgView.frame.origin.y+(buttonBgView.frame.size.height-60)/2, 70, 60);
    [buttonBgView addSubview:wordTypeIV];
//    [wordTypeIV release];
    
    UILabel *wordLabel = [[UILabel alloc]init];
    wordLabel.frame = CGRectMake(100, 5, 160, buttonBgView.frame.size.height-10);
    wordLabel.backgroundColor = [UIColor clearColor];
    wordLabel.textColor = [UIColor blackColor];
    wordLabel.font = [Utilities fontWithName:@"marvin" minSize:14 maxSize:22 constrainedToSize:CGSizeMake(160, buttonBgView.frame.size.height-10) forText:word];
    wordLabel.numberOfLines = 0;
    wordLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if([appDelegate isIPHONE5])
        wordLabel.textAlignment = NSTextAlignmentCenter;
    else
        wordLabel.textAlignment = NSTextAlignmentCenter;
    wordLabel.text = word;
    [buttonBgView addSubview:wordLabel];
//    [wordLabel release];
    [wordSelectButton setImage:[Utilities imageWithView:buttonBgView] forState:UIControlStateNormal];
//    [buttonBgView release];
    [mainView addSubview:wordSelectButton];
//    [wordSelectButton release];
}

- (void)initBubblesPopup
{
    while ([bubblesScrollView.subviews count] > 0)
        [[[bubblesScrollView subviews] objectAtIndex:0] removeFromSuperview];
    int xOffset = 10;
    for (int i = 0; i < [bubblesArray count]; i++)
    {
        UIButton *bubble = [[UIButton alloc]init];
        bubble.frame = CGRectMake(xOffset, 0, 100, 115);
        
        UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bubble.frame.size.width, bubble.frame.size.height)];
        buttonView.backgroundColor = [UIColor clearColor];
        
        UIImageView *buttonBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bubble-bg.png"]];
        buttonBg.frame = buttonView.frame;
        [buttonView addSubview:buttonBg];
//        [buttonBg release];
        
        UIImageView *bubbleIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bubble-icon.png"]];
        bubbleIcon.frame = buttonView.frame;
        [buttonView addSubview:bubbleIcon];
//        [bubbleIcon release];
        
        //coin bg
        UIImageView *coinBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"small-coin-icon.png"]];
        coinBg.frame = CGRectMake(buttonView.frame.size.width-10-20, 5, 20, 20);
        [buttonView addSubview:coinBg];
//        [coinBg release];

        //price label
        LabelBorder *priceLabel = [[LabelBorder alloc]init];
        priceLabel.frame = CGRectMake(10, 5, buttonView.frame.size.width-2*10-20-5, 20);
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.font = [UIFont fontWithName:@"marvin" size:16];
        if([appDelegate isIPHONE5])
            priceLabel.textAlignment = NSTextAlignmentRight;
        else
            priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.text = [[bubblesArray objectAtIndex:i]objectForKey:@"coins"];
        [buttonView addSubview:priceLabel];
//        [priceLabel release];
        
        //price label
        LabelBorder *nameLabel = [[LabelBorder alloc]init];
        nameLabel.frame = CGRectMake(10, buttonView.frame.size.height-5-20, buttonView.frame.size.width-2*10, 20);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont fontWithName:@"marvin" size:12];
        if([appDelegate isIPHONE5])
            nameLabel.textAlignment = NSTextAlignmentCenter;
        else
            nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = [NSString stringWithFormat:@"%@ BUBBLES",[[bubblesArray objectAtIndex:i]objectForKey:@"bubbles"]];
        [buttonView addSubview:nameLabel];
//        [nameLabel release];
        
        [bubble setImage:[Utilities imageWithView:buttonView] forState:UIControlStateNormal];
//        [buttonView release];
        bubble.tag = i;
        [bubble addTarget:self action:@selector(bubblesSelectedTUI:) forControlEvents:UIControlEventTouchUpInside];
        
        [bubblesScrollView addSubview:bubble];
//        [bubble release];
        xOffset = xOffset + bubble.frame.size.width+10;
    }
    bubblesScrollView.contentSize = CGSizeMake(xOffset, bubblesScrollView.frame.size.height);
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
    coinsValueLabel.font = [Utilities fontWithName:@"marvin" minSize:8 maxSize:20 constrainedToSize:CGSizeMake(coinsValueLabel.frame.size.width, coinsValueLabel.frame.size.height) forText:[Utilities formatNumber:appDelegate.userData.coins]];
    if([appDelegate isIPHONE5])
        coinsValueLabel.textAlignment = NSTextAlignmentLeft;
    else
        coinsValueLabel.textAlignment = NSTextAlignmentLeft;
    coinsValueLabel.textAlignment = NSTextAlignmentLeft;
    coinsValueLabel.text = [Utilities formatNumber:appDelegate.userData.coins];
    [coinsButtonView addSubview:coinsValueLabel];
//    [coinsValueLabel release];
    
    [coinsButton setImage:[Utilities imageWithView:coinsButtonView ] forState:UIControlStateNormal];
//    [coinsButtonView release];
}

- (IBAction)homeButtonTUI:(id)sender
{
//    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

}

- (void)coinsButtonTUI:(id)sender
{
    [appDelegate showAlert:@"You want to buy more coins?" CancelButton:@"NO" OkButton:@"YES" Type:moreCoinsAlert Sender:self];
}

- (IBAction)changeWordsButtonTUI:(id)sender
{
    //check if the user has any bubbles, else show popup
    if(appDelegate.userData.bubbles > 0)
    {
        [appDelegate showLoadingActivity];
        [APIManager setSender:self];
        [APIManager getGameWords:[NSString stringWithFormat:@"%d",opponentID] WithBubbles:YES Token:appDelegate.userData.token Version:appDelegate.version andTag:gameWordsRequest];
    }else
    {
        //check if bubbles list loaded
        if([bubblesArray count] > 0)
            [self showbubblesPopup];
        else
            [appDelegate showAlert:@"Bubbles not available. Please try later." CancelButton:nil OkButton:@"OK" Type:-2 Sender:self];
    }
}

- (IBAction)closePopupButtonTUI:(id)sender
{
    [self dismissBubblesPopup];
}

- (void)changeWords
{    
    while ([mainView.subviews count] > 0)
        [[[mainView subviews] objectAtIndex:0] removeFromSuperview];
    [self initWordSection:@"image" Word:[[wordsDict objectForKey:@"image_word"]objectForKey:@"word"] CoinsValue:[[[wordsDict objectForKey:@"image_word"]objectForKey:@"coins"]intValue] Offset:12 Tag:imageType];
    [self initWordSection:@"audio" Word:[[wordsDict objectForKey:@"audio_word"]objectForKey:@"word"] CoinsValue:[[[wordsDict objectForKey:@"audio_word"]objectForKey:@"coins"]intValue] Offset:108 Tag:audioType];
    [self initWordSection:@"video" Word:[[wordsDict objectForKey:@"video_word"]objectForKey:@"word"] CoinsValue:[[[wordsDict objectForKey:@"video_word"]objectForKey:@"coins"]intValue] Offset:204 Tag:videoType];
}

- (void)wordSelected:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    gameTypeSelected = (int)btn.tag;
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    
    switch (btn.tag)
    {
        case imageType:
        {
            if(continueGame)
                [APIManager continueGame:[NSString stringWithFormat:@"%d",selectedGameID] Word:[[wordsDict objectForKey:@"image_word"]objectForKey:@"id"] Token:appDelegate.userData.token Version:appDelegate.version andTag:continueGameRequest];
            else
                [APIManager createGame:[[wordsDict objectForKey:@"image_word"]objectForKey:@"id"] Opponent:[NSString stringWithFormat:@"%d",opponentID] Token:appDelegate.userData.token Version:appDelegate.version andTag:createGameRequest];
        }
            break;
        case audioType:
        {
            //[appDelegate hideLoadingActivity];
            //return;
            if(continueGame)
                [APIManager continueGame:[NSString stringWithFormat:@"%d",selectedGameID] Word:[[wordsDict objectForKey:@"audio_word"]objectForKey:@"id"] Token:appDelegate.userData.token Version:appDelegate.version andTag:continueGameRequest];
            else
                [APIManager createGame:[[wordsDict objectForKey:@"audio_word"]objectForKey:@"id"] Opponent:[NSString stringWithFormat:@"%d",opponentID] Token:appDelegate.userData.token Version:appDelegate.version andTag:createGameRequest];
        }
            break;
        case videoType:
        {
            //[appDelegate hideLoadingActivity];
            //return;
            //check if camera exists
            NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            
            // $$$Yy$ tempcode
//            if ( TRUE )
            if ( [videoDevices count] > 0 )
            {
                if(continueGame)
                    [APIManager continueGame:[NSString stringWithFormat:@"%d",selectedGameID] Word:[[wordsDict objectForKey:@"video_word"]objectForKey:@"id"] Token:appDelegate.userData.token Version:appDelegate.version andTag:continueGameRequest];
                else
                    [APIManager createGame:[[wordsDict objectForKey:@"video_word"]objectForKey:@"id"] Opponent:[NSString stringWithFormat:@"%d",opponentID] Token:appDelegate.userData.token Version:appDelegate.version andTag:createGameRequest];
            }else
            {
                [appDelegate hideLoadingActivity];
                [appDelegate showAlert:@"This device doesn't have camera." CancelButton:nil OkButton:@"OK" Type:noCameraAlert Sender:self];
            }
        }
            break;
        default:
            break;
    }
}

- (void)bubblesSelectedTUI:(id)sender
{
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    [APIManager purchaseBubbles:appDelegate.userData.token BubbleID:[[[bubblesArray objectAtIndex:[sender tag]]objectForKey:@"id"]intValue] Version:appDelegate.version andTag:purchaseBubblesRequest];
}

#pragma mark - Popup Methods
- (void)showbubblesPopup
{
    [self.view bringSubviewToFront:popupView];
    popupView.userInteractionEnabled = NO;
    popupView.hidden = NO;
    
    bubblesPopupView.frame = CGRectMake(bubblesPopupView.center.x, bubblesPopupView.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        bubblesPopupView.frame = CGRectMake((appDelegate.screenWidth-270)/2, (appDelegate.screenHeight-200)/2, 270, 200);
    } completion:^(BOOL finished) {
        popupView.userInteractionEnabled = YES;
    }];
}

- (void)dismissBubblesPopup
{
    popupView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        bubblesPopupView.frame = CGRectMake(bubblesPopupView.center.x, bubblesPopupView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         popupView.userInteractionEnabled = YES;
         popupView.hidden = YES;
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
                    [appDelegate.userData setBubbles:appDelegate.userData.bubbles-1];
                    [Utilities saveUserInfo:appDelegate.userData];
                    //replace button
                    UIView *changeWordsButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, changeWordsButton.frame.size.width, changeWordsButton.frame.size.height)];
                    UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"change-words-button.png"]];
                    bgIV.frame = changeWordsButtonView.frame;
                    [changeWordsButtonView addSubview:bgIV];
//                    [bgIV release];
                    
                    LabelBorder *buttonLabel = [[LabelBorder alloc]init];
                    buttonLabel.frame = changeWordsButtonView.frame;
                    buttonLabel.backgroundColor = [UIColor clearColor];
                    buttonLabel.textColor = [UIColor whiteColor];
                    buttonLabel.font = [UIFont fontWithName:@"marvin" size:14];
                    if([appDelegate isIPHONE5])
                        buttonLabel.textAlignment = NSTextAlignmentCenter;
                    else
                        buttonLabel.textAlignment = NSTextAlignmentCenter;
                    if(appDelegate.userData.bubbles > 0)
                        buttonLabel.text = [NSString stringWithFormat:@"%d BUBBLES",appDelegate.userData.bubbles];
                    else
                        buttonLabel.text = @"BUY BUBBLES";
                    buttonLabel.numberOfLines = 0;
                    if([appDelegate isIOS6])
                        buttonLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    else
                        buttonLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    [changeWordsButtonView addSubview:buttonLabel];
//                    [buttonLabel release];
                    
                    [changeWordsButton setImage:[Utilities imageWithView:changeWordsButtonView] forState:UIControlStateNormal];
//                    [changeWordsButtonView release];
                    
                    [wordsDict setDictionary:[[dict objectForKey:@"response"]objectForKey:@"response"]];
                    [self changeWords];
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
        case createGameRequest:
        {//create game
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    [appDelegate setPlaying:YES];

                    switch (gameTypeSelected)
                    {
                        case imageType:
                        {
                            [[[dict objectForKey:@"response"]objectForKey:@"response"] setValue:[wordsDict objectForKey:@"image_word"] forKey:@"word"];
                            [gameDict setDictionary:dict];
                            
                            //get packets
                            [appDelegate showLoadingActivity];
                            [APIManager setSender:self];
                            [APIManager getPurchasablePackets:appDelegate.userData.token Version:appDelegate.version andTag:packetsRequest];
    
                            
//                            DrawViewController *drawViewController = [[DrawViewController alloc]initWithNibName:@"DrawViewController" bundle:nil GameData:[[dict objectForKey:@"response"]objectForKey:@"response"]];
//                            [self presentModalViewController:drawViewController animated:YES];
//                            [drawViewController release];
                        }
                            break;
                        case audioType:
                        {
                            [[[dict objectForKey:@"response"]objectForKey:@"response"] setValue:[wordsDict objectForKey:@"audio_word"] forKey:@"word"];
                            RecordWordViewController *recordWordViewController = [[RecordWordViewController alloc]initWithNibName:@"RecordWordViewController" bundle:nil RecordType:recordSound GameData:[[dict objectForKey:@"response"]objectForKey:@"response"]];
//                            [self presentModalViewController:recordWordViewController animated:YES];
                            [self presentViewController:recordWordViewController animated:YES completion:nil];
//                            [recordWordViewController release];
                        }
                            break;
                        case videoType:
                        {
                            [[[dict objectForKey:@"response"]objectForKey:@"response"] setValue:[wordsDict objectForKey:@"video_word"] forKey:@"word"];

                            RecordWordViewController *recordWordViewController = [[RecordWordViewController alloc]initWithNibName:@"RecordWordViewController" bundle:nil RecordType:recordVideo GameData:[[dict objectForKey:@"response"]objectForKey:@"response"]];
//                            [self presentModalViewController:recordWordViewController animated:YES];
                            [self presentViewController:recordWordViewController animated:YES completion:nil];
//                            [recordWordViewController release];
                            /*
                             "game_id" = 6;
                             "game_round_id" = 9;
                             word =     {
                             coins = 5;
                             id = 2;
                             time = 30;
                             type = video;
                             word = shark;
                             };
                             */
                        }
                            break;
                        default:
                            break;
                    }
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 24)
                    {
                        //Invalid game type.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 31)
                    {
                        //User doesn't exists
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:opponentDoesntExistsAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 35)
                    {
                        //Word doesn't exists
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:wordDoesntExistsAlert Sender:self];
                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 39)
                    {
                        //There are no active players, try later
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:noActivePlayersAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 49)
                    {
                        //Could not create game, try later.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                    }
                }
            }
        }
            break;
        case continueGameRequest:
        {//continue game
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //returned only the game_round_id and round_id
                    switch (gameTypeSelected)
                    {
                        case imageType:
                        {
                            [[[dict objectForKey:@"response"]objectForKey:@"response"] setValue:[wordsDict objectForKey:@"image_word"] forKey:@"word"];
                            
                            [gameDict setDictionary:dict];
                            
                            //get packets
                            [appDelegate showLoadingActivity];
                            [APIManager setSender:self];
                            [APIManager getPurchasablePackets:appDelegate.userData.token Version:appDelegate.version andTag:packetsRequest];
                            
//                            DrawViewController *drawViewController = [[DrawViewController alloc]initWithNibName:@"DrawViewController" bundle:nil GameData:[[dict objectForKey:@"response"]objectForKey:@"response"]];
//                            [self presentModalViewController:drawViewController animated:YES];
//                            [drawViewController release];
                        }
                            break;
                        case audioType:
                        {
                            [[[dict objectForKey:@"response"]objectForKey:@"response"] setValue:[wordsDict objectForKey:@"audio_word"] forKey:@"word"];
                            RecordWordViewController *recordWordViewController = [[RecordWordViewController alloc]initWithNibName:@"RecordWordViewController" bundle:nil RecordType:recordSound GameData:[[dict objectForKey:@"response"]objectForKey:@"response"]];
//                            [self presentModalViewController:recordWordViewController animated:YES];
                            [self presentViewController:recordWordViewController animated:YES completion:nil];
//                            [recordWordViewController release];
                        }
                            break;
                        case videoType:
                        {
                            [[[dict objectForKey:@"response"]objectForKey:@"response"] setValue:[wordsDict objectForKey:@"video_word"] forKey:@"word"];
                            
                            RecordWordViewController *recordWordViewController = [[RecordWordViewController alloc]initWithNibName:@"RecordWordViewController" bundle:nil RecordType:recordVideo GameData:[[dict objectForKey:@"response"]objectForKey:@"response"]];
//                            [self presentModalViewController:recordWordViewController animated:YES];
                            [self presentViewController:recordWordViewController animated:YES completion:nil];
//                            [recordWordViewController release];
                        }
                            break;
                        default:
                            break;
                    }
                    
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 24)
                    {
                        //Invalid game type.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 31)
                    {
                        //User doesn't exists
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:opponentDoesntExistsAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 35)
                    {
                        //Word doesn't exists
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:wordDoesntExistsAlert Sender:self];
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
                    
                    DrawViewController *drawViewController = [[DrawViewController alloc]initWithNibName:@"DrawViewController" bundle:nil GameData:[[gameDict objectForKey:@"response"]objectForKey:@"response"]];
//                    [self presentModalViewController:drawViewController animated:YES];
                    [self presentViewController:drawViewController animated:YES completion:nil];
//                    [drawViewController release];
                    gameDict = nil;
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
        case getBubblesRequest:
        {
            if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
            {
                //refresh bubbles
                [appDelegate.userData setBubbles:[[[dict objectForKey:@"response"]objectForKey:@"response"]intValue]];
               
                //refresh bubbles button
                UIView *changeWordsButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, changeWordsButton.frame.size.width, changeWordsButton.frame.size.height)];
                UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"change-words-button.png"]];
                bgIV.frame = changeWordsButtonView.frame;
                [changeWordsButtonView addSubview:bgIV];
//                [bgIV release];
                
                LabelBorder *buttonLabel = [[LabelBorder alloc]init];
                buttonLabel.frame = changeWordsButtonView.frame;
                buttonLabel.backgroundColor = [UIColor clearColor];
                buttonLabel.textColor = [UIColor whiteColor];
                buttonLabel.font = [UIFont fontWithName:@"marvin" size:14];
                if([appDelegate isIPHONE5])
                    buttonLabel.textAlignment = NSTextAlignmentCenter;
                else
                    buttonLabel.textAlignment = NSTextAlignmentCenter;
                if(appDelegate.userData.bubbles > 0)
                    buttonLabel.text = [NSString stringWithFormat:@"%d BUBBLES",appDelegate.userData.bubbles];
                else
                    buttonLabel.text = @"BUY BUBBLES";
                buttonLabel.numberOfLines = 0;
                if([appDelegate isIOS6])
                    buttonLabel.lineBreakMode = NSLineBreakByWordWrapping;
                else
                    buttonLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [changeWordsButtonView addSubview:buttonLabel];
//                [buttonLabel release];
                
                [changeWordsButton setImage:[Utilities imageWithView:changeWordsButtonView] forState:UIControlStateNormal];
//                [changeWordsButtonView release];
            }
        }
            break;
        case purchaseBubblesRequest:
        {//bubbles purchased
            if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
            {
                //change bubbles count
                [appDelegate.userData setBubbles:[[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"bubbles"]intValue]];
                [appDelegate.userData setCoins:[[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"coins"]intValue]];
                //update coins button
                [self addCoinsButton];
                //update bubbles button
                //init button
                UIView *changeWordsButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, changeWordsButton.frame.size.width, changeWordsButton.frame.size.height)];
                UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"change-words-button.png"]];
                bgIV.frame = changeWordsButtonView.frame;
                [changeWordsButtonView addSubview:bgIV];
//                [bgIV release];
                
                LabelBorder *buttonLabel = [[LabelBorder alloc]init];
                buttonLabel.frame = changeWordsButtonView.frame;
                buttonLabel.backgroundColor = [UIColor clearColor];
                buttonLabel.textColor = [UIColor whiteColor];
                buttonLabel.font = [UIFont fontWithName:@"marvin" size:14];
                if([appDelegate isIPHONE5])
                    buttonLabel.textAlignment = NSTextAlignmentCenter;
                else
                    buttonLabel.textAlignment = NSTextAlignmentCenter;
                if(appDelegate.userData.bubbles > 0)
                    buttonLabel.text = [NSString stringWithFormat:@"%d BUBBLES",appDelegate.userData.bubbles];
                else
                    buttonLabel.text = @"BUY BUBBLES";
                buttonLabel.numberOfLines = 0;
                if([appDelegate isIOS6])
                    buttonLabel.lineBreakMode = NSLineBreakByWordWrapping;
                else
                    buttonLabel.lineBreakMode = NSLineBreakByWordWrapping;
                [changeWordsButtonView addSubview:buttonLabel];
//                [buttonLabel release];
                
                [changeWordsButton setImage:[Utilities imageWithView:changeWordsButtonView] forState:UIControlStateNormal];
//                [changeWordsButtonView release];
                
//                //request new words
//                [appDelegate showLoadingActivity];
//                [APIManager setSender:self];
//                [APIManager getGameWords:[NSString stringWithFormat:@"%d",opponentID] Token:appDelegate.userData.token Version:appDelegate.version andTag:gameWordsRequest];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 1)
                {
                    //Invalid validation_hash
                    [appDelegate showAlert:@"Something went wrong. Please try again." CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                }
                if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 2)
                {
                    //Invalid app_id
                    [appDelegate showAlert:@"Another session with the same user name already exists. Click OK to login and disconnect the other session." CancelButton:nil OkButton:@"OK" Type:invalidAppIDAlert Sender:self];
                }
                if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 57)
                {
                    //Invalid bubble value.
                    [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                }
                if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 59)
                {
                    //You do not have enough coins.
                    [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:noCoinsAlert Sender:self];
                }
                if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 60)
                {
                    //Error purchasing bubbles.
                    [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                }
            }
        }
            break;
        case getAvailableBubblesRequest:
        {
            //get available bubbles
            if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
            {
                [bubblesArray setArray:[[dict objectForKey:@"response"]objectForKey:@"response"]];
                //init popup
                [self initBubblesPopup];
            }else
            {
//                if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 1)
//                {
//                    //Invalid validation_hash
//                    [appDelegate showAlert:@"Something went wrong. Please try again." CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
//                }
//                if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 2)
//                {
//                    //Invalid app_id
//                    [appDelegate showAlert:@"Another session with the same user name already exists. Click OK to login and disconnect the other session." CancelButton:nil OkButton:@"OK" Type:invalidAppIDAlert Sender:self];
//                }
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
        case opponentDoesntExistsAlert:
        {
//            [self dismissModalViewControllerAnimated:YES];
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

        }
            break;
        case wordDoesntExistsAlert:
        {
//            [self dismissModalViewControllerAnimated:YES];
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

            NewGamePopupViewController *newGamePopupViewController = (NewGamePopupViewController*)appDelegate.window.rootViewController.presentedViewController;
            [newGamePopupViewController setSkipToWords:YES];
        }
            break;
        case invalidAppIDAlert:
        {
            [appDelegate.userData setValidLogin:NO];
            [Utilities saveUserInfo:appDelegate.userData];
            [appDelegate showReloginScreen];
        }
            break;
        case noActivePlayersAlert:
        {
            //return to opponent choose
//            [self dismissModalViewControllerAnimated:YES];
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

        }
            break;
        case moreCoinsAlert:
        {
            CoinsViewController *coinsViewController = [[CoinsViewController alloc]initWithNibName:@"CoinsViewController" bundle:nil];
//            [self presentModalViewController:coinsViewController animated:YES];
            [self presentViewController:coinsViewController animated:YES completion:nil];
//            [coinsViewController release];
            
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
