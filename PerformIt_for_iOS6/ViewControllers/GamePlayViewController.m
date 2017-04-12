//
//  GamePlayViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/15/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "GamePlayViewController.h"
#import "GameTypeViewController.h"

#import "AchievementCompletedView.h"
#import "Letter.h"

//#define kkMaxCoins 30//seconds
//#define kkMedCoins 60//seconds
//#define kkSmallCoins 120//seconds
//#define kkNoCoins 300//seconds
//#define kkLetterBaseTag 10000

#define kkNoShare 0
#define kkFacebookShare 1
#define kkTwitterShare 2

@interface GamePlayViewController ()

@end

@implementation GamePlayViewController
@synthesize backgroundIV;
@synthesize homeButton;
@synthesize winPopupView;
@synthesize popupView;
@synthesize popupBgIV;
@synthesize topView;
@synthesize addMoreButton;
@synthesize powersScrollView;
@synthesize nextTurnButton;
@synthesize endTurnButton;
@synthesize shareButton;
@synthesize saveButton;
@synthesize moreCoinsButton;
@synthesize winTextIV;
@synthesize coinsLabel;
@synthesize timerView;
@synthesize gameTimer;
@synthesize stopGameTimer;
@synthesize lettersArray, lettersPlaceholdersArray, wordPlaceholdersArray;

@synthesize recordView;
@synthesize videoPlayerController;
@synthesize audioRecordingView;
@synthesize audioPlayer;
@synthesize drawingView;
@synthesize playButton;
@synthesize addMorePopupView;
@synthesize addMoreScrollView;
@synthesize dismissAddMorePopupButton;

@synthesize shareView;
@synthesize sharePopupView;
@synthesize shareScrollView;

@synthesize achievementPopups;
@synthesize firstRun;
@synthesize gameDict;
@synthesize playbackProgress;
@synthesize reDrawEnded;
@synthesize gameEnded;
@synthesize logoIV;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil GameDict:(NSMutableDictionary*)game_dict
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        gameDict = [[NSMutableDictionary alloc]init];
        [gameDict setDictionary:game_dict];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredBackground)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredForeground)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
    

    
    if ([appDelegate isIPHONE5])
    {
        backgroundIV.image = [UIImage imageNamed:@"gameplay-bg-568h@2x.png"];
        backgroundIV.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        recordView.frame = CGRectMake(recordView.frame.origin.x, recordView.frame.origin.y, recordView.frame.size.width, 360);

        drawingView.frame = CGRectMake(drawingView.frame.origin.x, drawingView.frame.origin.y, drawingView.frame.size.width, 360);
        
        playButton.frame = CGRectMake((drawingView.frame.size.width-playButton.frame.size.width)/2, 190, playButton.frame.size.width, playButton.frame.size.height);
        addMorePopupView.frame = CGRectMake(addMorePopupView.frame.origin.x, addMorePopupView.frame.origin.y, addMorePopupView.frame.size.width, addMorePopupView.frame.size.height);
    }
    dismissAddMorePopupButton.hidden = YES;
    addMorePopupView.hidden = YES;
    
    powersScrollView.userInteractionEnabled = NO;
    
    recordView.hidden = YES;
    timerMax = [[gameDict objectForKey:@"time"]intValue];//seconds
    timerCount = 0;
    extraTimer = -1;
    //init timer label
    timerView.backgroundColor = [UIColor clearColor];
    
    LabelBorder *minutesLabel = [[LabelBorder alloc]initWithFrame:CGRectMake(5, (50-30)/2, 35, 30) BorderColor:[UIColor blackColor]];
    minutesLabel.tag = 88;
    minutesLabel.backgroundColor = [UIColor clearColor];
    minutesLabel.textColor = [UIColor whiteColor];
    minutesLabel.font = [UIFont fontWithName:@"marvin" size:25];
    if([appDelegate isIPHONE5])
        minutesLabel.textAlignment = NSTextAlignmentRight;
    else
        minutesLabel.textAlignment = NSTextAlignmentRight;
    [timerView addSubview:minutesLabel];
//    [minutesLabel release];
    
    LabelBorder *separatorLabel = [[LabelBorder alloc]initWithFrame:CGRectMake(5+35, (50-30)/2, 10, 30) BorderColor:[UIColor blackColor]];
    separatorLabel.tag = 77;
    separatorLabel.backgroundColor = [UIColor clearColor];
    separatorLabel.textColor = [UIColor whiteColor];
    separatorLabel.font = [UIFont fontWithName:@"marvin" size:25];
    if([appDelegate isIPHONE5])
        separatorLabel.textAlignment = NSTextAlignmentCenter;
    else
        separatorLabel.textAlignment = NSTextAlignmentCenter;
    separatorLabel.text = @":";
    [timerView addSubview:separatorLabel];
//    [separatorLabel release];
    
    LabelBorder *secondsLabel = [[LabelBorder alloc]initWithFrame:CGRectMake(5+35+10, (50-30)/2, 40, 30) BorderColor:[UIColor blackColor]];
    secondsLabel.tag = 99;
    secondsLabel.backgroundColor = [UIColor clearColor];
    secondsLabel.textColor = [UIColor whiteColor];
    secondsLabel.font = [UIFont fontWithName:@"marvin" size:25];
    if([appDelegate isIPHONE5])
        secondsLabel.textAlignment = NSTextAlignmentLeft;
    else
        secondsLabel.textAlignment = NSTextAlignmentLeft;
    [timerView addSubview:secondsLabel];
//    [secondsLabel release];
    
    [self updateLabel:[NSNumber numberWithInt:timerMax-timerCount]];
    
    //init popup win text
    if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
        winTextIV.image = [UIImage imageNamed:@"win-text-image.png"];
    if([[gameDict objectForKey:@"type"]isEqualToString:@"audio"])
        winTextIV.image = [UIImage imageNamed:@"win-text-audio"];
    if([[gameDict objectForKey:@"type"]isEqualToString:@"video"])
        winTextIV.image = [UIImage imageNamed:@"win-text-video"];
    popupView.hidden = YES;
    
    //init coins label
    coinsLabel.backgroundColor = [UIColor clearColor];
    coinsLabel.textColor = [UIColor whiteColor];
    coinsLabel.font = [UIFont fontWithName:@"marvin" size:40];
    if([appDelegate isIPHONE5])
        coinsLabel.textAlignment = NSTextAlignmentRight;
    else
        coinsLabel.textAlignment = NSTextAlignmentRight;
    coinsLabel.text = [gameDict objectForKey:@"coins"];
    
    lettersArray = [[NSMutableArray alloc]init];
    lettersPlaceholdersArray = [[NSMutableArray alloc]init];
    wordPlaceholdersArray = [[NSMutableArray alloc]init];
    
    //init record view
    if([[gameDict objectForKey:@"type"]isEqualToString:@"audio"])
    {
        drawingView.hidden = YES;
        recordView.hidden = NO;
        recordView.backgroundColor = [UIColor whiteColor];
        UIImageView *audioBgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"audio-playback-bg.png"]];
        audioBgIV.frame = CGRectMake((recordView.frame.size.width-110)/2, (recordView.frame.size.height-150)/2-40-5, 110, 150);
        
        [recordView addSubview:audioBgIV];
//        [audioBgIV release];
        
        UIView *buttonBgView = [[UIView alloc]init];
        buttonBgView.frame = CGRectMake(0, 0, playButton.frame.size.width, playButton.frame.size.height);
        buttonBgView.backgroundColor = [UIColor lightGrayColor];
        buttonBgView.alpha = 0.5;
        buttonBgView.layer.cornerRadius = playButton.frame.size.width/2;
        
        UIImageView *buttonIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play-video-button"]];
        buttonIV.frame = CGRectMake(0, 0, playButton.frame.size.width, playButton.frame.size.height);
        [buttonBgView addSubview:buttonIV];
//        [buttonIV release];
        
        [playButton setImage:[Utilities imageWithView:buttonBgView] forState:UIControlStateNormal];
//        [buttonBgView release];
        
        playButton.frame = CGRectMake(playButton.frame.origin.x, playButton.frame.origin.y+80+5, playButton.frame.size.width, playButton.frame.size.height);
        
        [recordView bringSubviewToFront:playButton];
    }
    if([[gameDict objectForKey:@"type"]isEqualToString:@"video"])
    {
        drawingView.hidden = YES;
        recordView.hidden = NO;
        
        NSURL *url = [NSURL fileURLWithPath:[gameDict objectForKey:@"video_path"]];
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        videoPlayerController = [[ MPMoviePlayerViewController alloc] initWithContentURL:url];
        UIGraphicsEndImageContext();
        [videoPlayerController.moviePlayer prepareToPlay];
        videoPlayerController.moviePlayer.controlStyle = MPMovieControlStyleNone;
        videoPlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        videoPlayerController.moviePlayer.fullscreen = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlaybackComplete:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerController.moviePlayer];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(videoPlaybackComplete:)
//                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification object:videoPlayerController.moviePlayer];
        
        [[videoPlayerController view] setFrame:CGRectMake(0, 0, recordView.frame.size.width, recordView.frame.size.height)];//setBounds:videoPreviewView.frame];
        videoPlayerController.moviePlayer.scalingMode = MPMovieScalingModeFill;
        [recordView addSubview:videoPlayerController.view];
        
        videoPlayerController.moviePlayer.shouldAutoplay = NO;
        [recordView bringSubviewToFront:playButton];
    }
    if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
    {
        recordView.hidden = NO;
        drawingView.userInteractionEnabled = NO;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:@"1" forKey:@"red"];
        [dict setValue:@"1" forKey:@"green"];
        [dict setValue:@"1" forKey:@"blue"];
        [drawingView setBgColor: dict];
//        [dict release];
        [drawingView eraseAllLines:YES];
        //[drawingView initWithScale:0.9];
        //init play button
        UIView *buttonBgView = [[UIView alloc]init];
        buttonBgView.frame = CGRectMake(0, 0, playButton.frame.size.width, playButton.frame.size.height);
        buttonBgView.backgroundColor = [UIColor lightGrayColor];
        buttonBgView.alpha = 0.5;
        buttonBgView.layer.cornerRadius = playButton.frame.size.width/2;
        
        UIImageView *buttonIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play-video-button"]];
        buttonIV.frame = CGRectMake(0, 0, playButton.frame.size.width, playButton.frame.size.height);
        [buttonBgView addSubview:buttonIV];
//        [buttonIV release];
        
        [playButton setImage:[Utilities imageWithView:buttonBgView] forState:UIControlStateNormal];
//        [buttonBgView release];
    }
    firstRun = YES;
    
    achievementPopups = [[NSMutableArray alloc]init];
    
    //init share view
    LabelBorder *shareLabel = [[LabelBorder alloc]initWithFrame:CGRectMake(20, 10, 198, 30) BorderColor:[UIColor blackColor]];
    shareLabel.tag = 88;
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textColor = [UIColor whiteColor];
    shareLabel.font = [UIFont fontWithName:@"marvin" size:20];
    if([appDelegate isIPHONE5])
        shareLabel.textAlignment = NSTextAlignmentCenter;
    else
        shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.text = @"Share with";
    [sharePopupView addSubview:shareLabel];
//    [shareLabel release];
    
//    UIButton *closeButton = [[UIButton alloc]init];
//    [closeButton setImage:[UIImage imageNamed:@"popup-close-button.png"] forState:UIControlStateNormal];
//    closeButton.frame = CGRectMake(sharePopupView.frame.size.width-37, 0, 37, 37);
//    [closeButton addTarget:self action:@selector(dismissShareView:) forControlEvents:UIControlEventTouchUpInside];
//    [sharePopupView addSubview:closeButton];
//    [closeButton release];

    shareArray = [[NSMutableArray alloc]init];
    [shareArray addObject:[NSNumber numberWithInt:facebookShare]];
    [shareArray addObject:[NSNumber numberWithInt:twitterShare]];
    shareView.hidden = YES;
    int xOffset = 5;
    for (int i = 0; i < [shareArray count]; i++)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(xOffset, 0, 50, 50)];
        button.tag = [[shareArray objectAtIndex:i]intValue];
        button.backgroundColor = [UIColor clearColor];
        
        if([[shareArray objectAtIndex:i]intValue] == facebookShare)
            [button setImage:[UIImage imageNamed:@"facebook-share-button.png"] forState:UIControlStateNormal];
        if([[shareArray objectAtIndex:i]intValue] == twitterShare)
            [button setImage:[UIImage imageNamed:@"twitter-share-button.png"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(shareTypeSelectedTUI:) forControlEvents:UIControlEventTouchUpInside];
        [shareScrollView addSubview:button];
//        [button release];
        xOffset = xOffset + 50 + 5;
    }
    shareScrollView.contentSize = CGSizeMake(xOffset, 50);
    
    for (int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
    {
        [[appDelegate.inAppPacketsArray objectAtIndex:i]setValue:@"NO" forKey:@"used"];
    }
    [self addPackages:appDelegate.inAppPacketsArray];
    
//    shareButton.frame = endTurnButton.frame;
    shareButton.exclusiveTouch = YES;
    moreCoinsButton.exclusiveTouch = YES;
//    moreCoinsButton.hidden = YES;
    saveButton.exclusiveTouch = YES;
    endTurnButton.exclusiveTouch = YES;
//    endTurnButton.hidden = YES;
    nextTurnButton.exclusiveTouch = YES;
    dismissAddMorePopupButton.exclusiveTouch = YES;
    logoIV.hidden = YES;
    if([appDelegate isIPHONE5])
        logoIV.image = [UIImage imageNamed:@"splash-bg-568h@2x.png"];
}

- (void)viewWillAppear:(BOOL)animated
{
    word = [gameDict objectForKey:@"word"];
    [self initWordLettersFrame:word];
    
    lastSelectedShareType = kkNoShare;
    [appDelegate setPlaying:YES];
    
    //init tapjoy
//    [[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(tapjoyClosed:)
//												 name:TJC_VIEW_CLOSED_NOTIFICATION
//											   object:nil];
//    [Tapjoy setViewDelegate:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"%@",wordPlaceholdersArray);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (void)dealloc
//{
//    [backgroundIV release];
//    [homeButton release];
//    [winPopupView release];
//    [popupView release];
//    [popupBgIV release];
//    [topView release];
//    [addMoreButton release];
//    [powersScrollView release];
//    [nextTurnButton release];
//    [endTurnButton release];
//    [shareButton release];
//    [saveButton release];
//    [moreCoinsButton release];
//    [winTextIV release];
//    [coinsLabel release];
//    [timerView release];
//    [gameTimer release];
//    [stopGameTimer release];
//    [lettersArray release];
//    [wordPlaceholdersArray release];
//    [lettersPlaceholdersArray release];
//    [recordView release];
//    [videoPlayerController release];
//    [audioRecordingView release];
//    [audioPlayer release];
//    [drawingView release];
//    [playButton release];
//    [addMorePopupView release];
//    [addMoreScrollView release];
//    [dismissAddMorePopupButton release];
//    [achievementPopups release];
//    [shareView release];
//    [sharePopupView release];
//    [shareScrollView release];
//    [gameDict release];
//    [logoIV release];
//    
//    [super dealloc];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [APIManager cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:TJC_VIEW_CLOSED_NOTIFICATION];
}

- (void) addPackages:(NSArray*)packages
{
    while ([powersScrollView.subviews count] > 0)
        [[[powersScrollView subviews] objectAtIndex:0] removeFromSuperview];
    
    [[addMorePopupView viewWithTag:-2] removeFromSuperview];
    while ([addMoreScrollView.subviews count] > 0)
        [[[addMoreScrollView subviews] objectAtIndex:0] removeFromSuperview];
    
    LabelBorder *inAppLabel = [[LabelBorder alloc]init];
    inAppLabel.frame = CGRectMake(10, 20, addMorePopupView.frame.size.width-2*10, 20);
    inAppLabel.backgroundColor = [UIColor clearColor];
    inAppLabel.textColor = [UIColor whiteColor];
    inAppLabel.font = [UIFont fontWithName:@"marvin" size:20];
    inAppLabel.minimumFontSize = 14;
    inAppLabel.adjustsFontSizeToFitWidth = YES;
    inAppLabel.textAlignment = NSTextAlignmentCenter;
    inAppLabel.textAlignment = NSTextAlignmentCenter;
    inAppLabel.text = @"Purchase Items";
    inAppLabel.tag = -2;
    [addMorePopupView addSubview:inAppLabel];
//    [inAppLabel release];
    
    int xOffset = 10;
    int yOffset = 0;
    for (int i = 0; i < [packages count]; i++)
    {
        switch ([[[packages objectAtIndex:i]objectForKey:@"packet_id"]intValue])
        {
            case kTimer2minPackage:
            {
                //NSArray *colors = [Utilities generatePackageColors];
                //yOffset = [self addColorsToPopup:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Package:[packages objectAtIndex:i] Colors:colors]-10;
                yOffset = [self addPacketToPopop:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Image:@"2-minutes-timer.png" Package:[packages objectAtIndex:i]]-10;
                
                if([[[packages objectAtIndex:i] objectForKey:@"purchased"]boolValue])
                {
                    xOffset = [self addPowerup:xOffset Image:@"2-minutes-timer.png" Type:[[[packages objectAtIndex:i]objectForKey:@"packet_id"]intValue]Used:[[[packages objectAtIndex:i]objectForKey:@"used"]boolValue]];
                }
            }
                break;
            case kTimer5minPackage:
            {
                //NSArray *colors = [Utilities generateAllColors];
                //yOffset = [self addColorsToPopup:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Package:[packages objectAtIndex:i] Colors:colors]-10;
                yOffset = [self addPacketToPopop:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Image:@"5-minutes-timer.png" Package:[packages objectAtIndex:i]]-10;
                if([[[packages objectAtIndex:i] objectForKey:@"purchased"]boolValue])
                {
                    xOffset = [self addPowerup:xOffset Image:@"5-minutes-timer.png" Type:[[[packages objectAtIndex:i]objectForKey:@"packet_id"]intValue] Used:[[[packages objectAtIndex:i]objectForKey:@"used"]boolValue]];
                }
            }
                break;
            case kTimerInfinitePackage:
            {
                //NSArray *brushes = [Utilities generatePackageBrushes];
                //yOffset = [self addBrushesToPopup:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Package:[packages objectAtIndex:i] Brushes:brushes]-10;
                yOffset = [self addPacketToPopop:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Image:@"infinite-timer.png" Package:[packages objectAtIndex:i]]-10;
                if([[[packages objectAtIndex:i] objectForKey:@"purchased"]boolValue])
                {
                    xOffset = [self addPowerup:xOffset Image:@"infinite-timer.png" Type:[[[packages objectAtIndex:i]objectForKey:@"packet_id"]intValue]Used:[[[packages objectAtIndex:i]objectForKey:@"used"]boolValue]];
                }

            }
                break;
            case kTimerStopPackage:
            {
                //NSArray *brushes = [Utilities generateAllBrushes];
                //yOffset = [self addBrushesToPopup:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Package:[packages objectAtIndex:i] Brushes:brushes]-10;
                yOffset = [self addPacketToPopop:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Image:@"stop-timer.png" Package:[packages objectAtIndex:i]]-10;
                if([[[packages objectAtIndex:i] objectForKey:@"purchased"]boolValue])
                {
                    xOffset = [self addPowerup:xOffset Image:@"stop-timer.png" Type:[[[packages objectAtIndex:i]objectForKey:@"packet_id"]intValue]Used:[[[packages objectAtIndex:i]objectForKey:@"used"]boolValue]];
                }

            }
                break;
            case kHintPackage:
            {
                //yOffset = [self addBackgroundColorToPopup:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Package:[packages objectAtIndex:i]]-10;
                yOffset = [self addPacketToPopop:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Image:@"give-hint.png" Package:[packages objectAtIndex:i]]-10;
                if([[[packages objectAtIndex:i] objectForKey:@"purchased"]boolValue])
                {
                    xOffset = [self addPowerup:xOffset Image:@"give-hint.png" Type:[[[packages objectAtIndex:i]objectForKey:@"packet_id"]intValue]Used:[[[packages objectAtIndex:i]objectForKey:@"used"]boolValue]];
                }
            }
                break;
            default:
                break;
        }
    }
    addMoreScrollView.contentSize = CGSizeMake(addMoreScrollView.frame.size.width, yOffset);
    yOffset = yOffset + 20;
    
    if(yOffset > (appDelegate.screenHeight-2*70))
        addMorePopupView.frame = CGRectMake(addMorePopupView.frame.origin.x, 70, addMorePopupView.frame.size.width, appDelegate.screenHeight-2*70);
    else
        addMorePopupView.frame = CGRectMake(addMorePopupView.frame.origin.x, (appDelegate.screenHeight-yOffset-(inAppLabel.frame.size.height+20))/2, addMorePopupView.frame.size.width, yOffset+inAppLabel.frame.size.height+20);
    
    addMoreScrollView.frame = CGRectMake(0, inAppLabel.frame.origin.y+inAppLabel.frame.size.height+20, addMorePopupView.frame.size.width, addMorePopupView.frame.size.height-(inAppLabel.frame.origin.y+inAppLabel.frame.size.height)-5);
    [addMorePopupView viewWithTag:-1].layer.cornerRadius = 5;
    [addMorePopupView viewWithTag:-1].layer.masksToBounds = YES;
    
    UIButton *closeButton = [[UIButton alloc]init];
    [closeButton setImage:[UIImage imageNamed:@"popup-close-button.png"] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(addMorePopupView.frame.size.width-37, 0, 37, 37);
    [closeButton addTarget:self action:@selector(closeAddMoreButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
    [addMorePopupView addSubview:closeButton];
//    [closeButton release];
    
    powersScrollView.contentSize = CGSizeMake(xOffset, powersScrollView.frame.size.height);
}

- (int)addPacketToPopop:(CGRect)frame Image:(NSString*)image Package:(NSDictionary*)packagesDict
{
    int yOffset = frame.origin.y;
    
    //package icon
    UIImageView *packageIV = [[UIImageView alloc]initWithFrame:CGRectMake(frame.origin.x, yOffset, 44, 44)];
    packageIV.image = [UIImage imageNamed:image];
    [addMoreScrollView addSubview:packageIV];
//    [packageIV release];
    
    //package name
    LabelBorder *packageNameLabel = [[LabelBorder alloc]init];
    packageNameLabel.frame = CGRectMake(packageIV.frame.origin.x+packageIV.frame.size.width+10, yOffset+(packageIV.frame.size.height-20)/2, addMorePopupView.frame.size.width-2*10-packageIV.frame.size.width-10-40-10, 20);
    packageNameLabel.backgroundColor = [UIColor clearColor];
    packageNameLabel.textColor = [UIColor whiteColor];
    packageNameLabel.font = [UIFont fontWithName:@"marvin" size:16];
    packageNameLabel.minimumFontSize = 12;
    packageNameLabel.adjustsFontSizeToFitWidth = YES;
    packageNameLabel.textAlignment = NSTextAlignmentLeft;
    packageNameLabel.textAlignment = NSTextAlignmentLeft;
    packageNameLabel.text = [packagesDict objectForKey:@"name"];
    [addMoreScrollView addSubview:packageNameLabel];
//    [packageNameLabel release];
    
    //purchase button
    UIButton *purchaseButton = [[UIButton alloc]init];
    purchaseButton.exclusiveTouch = YES;
    purchaseButton.frame = CGRectMake(packageNameLabel.frame.origin.x+packageNameLabel.frame.size.width+10, yOffset+(packageIV.frame.size.height-40)/2, 40, 40);
    [purchaseButton setImage:[UIImage imageNamed:@"purchase-button.png"] forState:UIControlStateNormal];
    [purchaseButton addTarget:self action:@selector(purchaseButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
    purchaseButton.tag = [[packagesDict objectForKey:@"packet_id"]intValue];
    if([[packagesDict objectForKey:@"purchased"]boolValue])
        purchaseButton.enabled = NO;
    [addMoreScrollView addSubview:purchaseButton];
//    [purchaseButton release];
    
    yOffset = yOffset + packageIV.frame.size.height+20;
    
    return yOffset;
}

- (int)addPowerup:(int)xOffset Image:(NSString*)image Type:(int)type Used:(BOOL)used
{
    UIButton *powerupButton = [[UIButton alloc]init];
    powerupButton.frame = CGRectMake(xOffset, (powersScrollView.frame.size.height-44)/2, 44, 44);
    [powerupButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    powerupButton.tag = type;
    [powerupButton addTarget:self action:@selector(powerupSelectedTUI:) forControlEvents:UIControlEventTouchUpInside];
    if(used)
        powerupButton.enabled = NO;
    [powersScrollView addSubview:powerupButton];
//    [powerupButton release];
    xOffset = xOffset + 44 + 10;
    return xOffset;
}

- (void)startGame
{
    if(![gameTimer isValid])
    {
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerInterrupt) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:gameTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)timerInterrupt
{
    [self performSelectorInBackground:@selector(gameTimerCall) withObject:nil];
}

- (void)gameTimerCall
{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    @autoreleasepool {
    timerCount++;
    //update timer label
    [self performSelectorOnMainThread:@selector(updateLabel:) withObject:[NSNumber numberWithInt:timerMax-timerCount] waitUntilDone:NO];
    
    if(timerCount == timerMax)
    {
        //end game
        [gameTimer invalidate];
        gameTimer = nil;
        //stop image, audio and video playback
        if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
        {
            [drawingView setEndThread:YES];
        }
        if([[gameDict objectForKey:@"type"]isEqualToString:@"audio"])
        {
            [self stopPlaying];
        }
        if([[gameDict objectForKey:@"type"]isEqualToString:@"video"])
        {
            [videoPlayerController.moviePlayer pause];
            //[videoPlayerController.moviePlayer stop];
        }
        //show popup with delay
        NSLog(@"call end game with delay - timer ended");
        self.view.userInteractionEnabled = NO;
        [self performSelectorInBackground:@selector(endGameWithDelay:) withObject:@"NO"];
    }
    }
//    [pool release];
}

- (void)updateLabel:(NSNumber*)elapsedSeconds
{
    if([elapsedSeconds intValue] < 0)
        elapsedSeconds = [NSNumber numberWithInt:0];
//    else
//        elapsedSeconds = [NSNumber numberWithInt:[elapsedSeconds intValue]/100];

    LabelBorder *minutesLabel = (LabelBorder*)[timerView viewWithTag:88];
    minutesLabel.text = [NSString stringWithFormat:@"%02ld",([elapsedSeconds integerValue] / 60) % 60];
    
    LabelBorder *secondsLabel = (LabelBorder*)[timerView viewWithTag:99];
    secondsLabel.text = [NSString stringWithFormat:@"%02ld",[elapsedSeconds integerValue] % 60];
}

- (void)showWinPopup
{
    [self.view addSubview:popupView];
    [self.view bringSubviewToFront:popupView];
    popupView.hidden = NO;
    winPopupView.userInteractionEnabled = NO;
    winPopupView.hidden = NO;
    winPopupView.frame = CGRectMake(appDelegate.screenWidth/2, (appDelegate.screenHeight-20)/2, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        winPopupView.frame = CGRectMake(25, (appDelegate.screenHeight-337-20)/2, 270, 337);
    } completion:^(BOOL finished) {
        winPopupView.userInteractionEnabled = YES;
    }];
}

- (void)dismissWinPopup
{
    winPopupView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        winPopupView.frame = CGRectMake(winPopupView.center.x, winPopupView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         winPopupView.userInteractionEnabled = YES;
         winPopupView.hidden = YES;
         popupView.hidden = YES;
     }];
}

- (IBAction)homeButtonTUI:(id)sender
{
    [appDelegate showAlert:@"Do you want to return to home screen? You will lose the game." CancelButton:@"NO" OkButton:@"YES" Type:closeGameAlert Sender:self];
}

- (IBAction)addMoreButtonTUI:(id)sender
{
    [self.view bringSubviewToFront:dismissAddMorePopupButton];
    [self.view bringSubviewToFront:addMorePopupView];
    [self showAddMorePopup];
    
    //pause game
    if(gameTimer != nil)
    {
        [appDelegate setGamePaused:YES];
        //stop timers
        [gameTimer invalidate];
        gameTimer = nil;
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timerInterrupt:) object:nil];
        
        //gameTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerInterrupt) userInfo:nil repeats:YES]retain];

        //check game type
        if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
        {
            
        }
        if([[gameDict objectForKey:@"type"]isEqualToString:@"audio"])
        {
            [audioPlayer pause];
        }
        if([[gameDict objectForKey:@"type"]isEqualToString:@"video"])
        {
            playbackProgress = videoPlayerController.moviePlayer.currentPlaybackTime;
            [videoPlayerController.moviePlayer pause];
        }
    }
}

- (IBAction)closeAddMoreButtonTUI:(id)sender
{
    [self dismissAddMorePopup];
    //un-pause game
    [appDelegate setGamePaused:NO];
    //start timers if the game was started
    if(!firstRun)
    {
        //start timers
        [self startGame];
        
//        //check game type
//        if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
//        {
////            if(!reDrawEnded)
////            {
//                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//                dispatch_async(concurrentQueue, ^{
//                    [drawingView playRecordedPathOnTime:drawingView.recordedPath DisplayCount:-1];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if(!appDelegate.gamePaused)
//                            reDrawEnded = YES;
//                    });
//                });
////            }
//        }
        if([[gameDict objectForKey:@"type"]isEqualToString:@"audio"])
        {
            [audioPlayer play];
        }
        if([[gameDict objectForKey:@"type"]isEqualToString:@"video"])
        {
           if(videoPlayerController.moviePlayer.playbackState == MPMoviePlaybackStatePaused)
           {
                [videoPlayerController.moviePlayer setInitialPlaybackTime:playbackProgress];
                [videoPlayerController.moviePlayer play];
           }
        }
        
        addMoreButton.userInteractionEnabled = NO;
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            sleep(1.0);
            dispatch_async(dispatch_get_main_queue(), ^{
                addMoreButton.userInteractionEnabled = YES;;
            });
        });
    }
}

- (IBAction)saveButtonTUI:(id)sender
{
    [appDelegate showLoadingActivity];
    
    if([[gameDict objectForKey:@"type"]isEqualToString:@"audio"])
    {
        [Utilities mergeVideoURL:@"audio-bg.mp4"
                    withAudioURL:[NSString stringWithFormat:@"audio-record-%@.wav",[gameDict objectForKey:@"game_round_id"]]
                     ToVideoPath:[NSString stringWithFormat:@"%@.mov",[gameDict objectForKey:@"game_round_id"]]];
    }
    if([[gameDict objectForKey:@"type"]isEqualToString:@"video"])
    {
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"video-record-%@.mov",[gameDict objectForKey:@"game_round_id"]]];
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		[library writeVideoAtPathToSavedPhotosAlbum:url
									completionBlock:^(NSURL *assetURL, NSError *error)
         {
             [appDelegate hideLoadingActivity];
             if (error)
             {
                 if([error.localizedDescription isEqualToString:@"User denied access"])
                     [appDelegate showAlert:@"User denied access. See Settings->Privacy section" CancelButton:nil OkButton:@"OK" Type:recordingSavingErrorAlert Sender:self];
                 else
                     [appDelegate showAlert:@"The recording could not be saved." CancelButton:nil OkButton:@"OK" Type:recordingSavingErrorAlert Sender:self];
             }else
             {
                 [appDelegate showAlert:@"Recording succesfully saved." CancelButton:nil OkButton:@"OK" Type:recordingSavingSuccesfullAlert Sender:self];
             }
         }];
//        [library release];
    }
    if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
    {
        UIImage *image = [drawingView imageRepresentation];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[image CGImage]
                                  orientation:(ALAssetOrientation)[image imageOrientation]
                              completionBlock:^(NSURL *assetURL, NSError *error)
         {
             [appDelegate hideLoadingActivity];
             NSLog(@"%@",error.localizedDescription);
             if (error)
             {
                 if([error.localizedDescription isEqualToString:@"User denied access"])
                     [appDelegate showAlert:@"User denied access. See Settings->Privacy section" CancelButton:nil OkButton:@"OK" Type:recordingSavingErrorAlert Sender:self];
                 else
                     [appDelegate showAlert:@"Drawing could not be saved" CancelButton:nil OkButton:@"OK" Type:recordingSavingErrorAlert Sender:self];
             }else
             {
                 [appDelegate showAlert:@"Drawing saved successfully." CancelButton:nil OkButton:@"OK" Type:recordingSavingSuccesfullAlert Sender:self];
             }
         }];
    }
}

- (void)saveAudioRecordingToGallery:(NSString*)path
{
    NSURL *url = [[NSURL alloc]initWithString:path];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error)
     {
         [appDelegate hideLoadingActivity];
         if (error)
         {
             if (error)
             {
                 if([error.localizedDescription isEqualToString:@"User denied access"])
                     [appDelegate showAlert:@"User denied access. See Settings->Privacy section" CancelButton:nil OkButton:@"OK" Type:recordingSavingErrorAlert Sender:self];
                 else
                     [appDelegate showAlert:@"The recording could not be saved." CancelButton:nil OkButton:@"OK" Type:recordingSavingErrorAlert Sender:self];
             }
         }else
         {
             [appDelegate showAlert:@"Recording succesfully saved." CancelButton:nil OkButton:@"OK" Type:recordingSavingSuccesfullAlert Sender:self];
         }
         
     }];
//    [library release];
    
}
- (IBAction)nextTurnButtonTUI:(id)sender
{
    //record new word for opponent
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    [APIManager getGameWords:[gameDict objectForKey:@"player"] WithBubbles:NO Token:appDelegate.userData.token Version:appDelegate.version andTag:gameWordsRequest];
}

- (IBAction)moreCoinsButtonTUI:(id)sender
{
    //tapjoy
//    [Tapjoy showOffersWithViewController:self];
}

- (IBAction)endTurnButtonTUI:(id)sender
{
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    [APIManager deleteGame:appDelegate.userData.token GameRoundID:[[gameDict objectForKey:@"game_round_id"]intValue] Version:appDelegate.version andTag:endGameRequest];
}

- (IBAction)shareButtonTUI:(id)sender
{
    [self.view bringSubviewToFront:shareView];
    [self showSharePopup];
}

- (IBAction)dismissShareView:(id)sender
{
    [self dismissSharePopup];
}

- (IBAction)shareTypeSelectedTUI:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
    {
        //check if image redraw ended, if not do instant redraw
        if(reDrawEnded)
        {
            UIImage *image = [drawingView imageRepresentation];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            NSString *shareData = [Utilities Base64Encode:imageData];
            
            NSString *shareType = @"";
            switch (btn.tag)
            {
                case facebookShare:
                {
                    shareType = @"facebook";
                    lastSelectedShareType = kkFacebookShare;
                }
                    break;
                case twitterShare:
                {
                    shareType = @"twitter";
                    lastSelectedShareType = kkTwitterShare;
                }
                    break;
                default:
                    break;
            }
            [appDelegate showLoadingActivity];
            [APIManager setSender:self];
            [APIManager share:appDelegate.userData.token GameRoundID:[[gameDict objectForKey:@"game_round_id"]intValue] To:shareType Data:shareData Version:appDelegate.version andTag:shareRequest];
        }else
        {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(concurrentQueue, ^{
                [drawingView eraseAllLines:YES];
                [drawingView playRecordedPath:drawingView.recordedPath Instant:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    reDrawEnded = YES;
                    //take screenshot
                    UIImage *image = [drawingView imageRepresentation];
                    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                    NSString *shareData = [Utilities Base64Encode:imageData];

                    NSString *shareType = @"";
                    switch (btn.tag)
                    {
                        case facebookShare:
                        {
                            shareType = @"facebook";
                            lastSelectedShareType = kkFacebookShare;
                        }
                            break;
                        case twitterShare:
                        {
                             shareType = @"twitter";
                            lastSelectedShareType = kkTwitterShare;
                        }
                            break;
                        default:
                            break;
                    }
                    [appDelegate showLoadingActivity];
                    [APIManager setSender:self];
                    [APIManager share:appDelegate.userData.token GameRoundID:[[gameDict objectForKey:@"game_round_id"]intValue] To:shareType Data:shareData Version:appDelegate.version andTag:shareRequest];
                });
            });
        }
    }else
    {
        NSString *shareType = @"";
        switch (btn.tag)
        {
            case facebookShare:
            {
                shareType = @"facebook";
                lastSelectedShareType = kkFacebookShare;
            }
                break;
            case twitterShare:
            {
                shareType = @"twitter";
                lastSelectedShareType = kkTwitterShare;
            }
                break;
            default:
                break;
              break;
        }
        [appDelegate showLoadingActivity];
        [APIManager setSender:self];
        [APIManager share:appDelegate.userData.token GameRoundID:[[gameDict objectForKey:@"game_round_id"]intValue] To:shareType Data:@"" Version:appDelegate.version andTag:shareRequest];
    }
}

- (void)proceedWithShare:(NSString*)shareString
{
    NSString *shareUrl = [NSString stringWithFormat:@"%@",[Utilities createShareLink:[[gameDict objectForKey:@"game_round_id"]intValue] Owner:NO]];

    if(lastSelectedShareType == kkFacebookShare)
    {
        [appDelegate showLoadingActivity];
        [self postWithUrl:shareUrl
              andImageURL:[NSString stringWithFormat:@"%@/images/Icon.png",shareBaseUrl]
                 andTitle:@"Perform it"
           andDescprition:@"description"];
        return;
    }
    if(lastSelectedShareType == kkTwitterShare)
    {
        if(![appDelegate isIOS6])
        {
            TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
            [twitter setInitialText:shareString];
            [twitter setTitle:shareString];
            [twitter addImage:[UIImage imageNamed:@"Icon.png"]];
            
            [twitter addURL:[NSURL URLWithString:shareUrl]];
            
            //[twitter addImage:[UIImage imageNamed:@"Icon@2x.png"]];
            [self presentViewController:twitter animated:YES completion:nil];
            
            twitter.completionHandler = ^(TWTweetComposeViewControllerResult res)
            {
                if(res == TWTweetComposeViewControllerResultDone)
                {
                    [appDelegate showAlert:@"Share success" CancelButton:nil OkButton:@"OK" Type:-1 Sender:self];
                }
                if(res == TWTweetComposeViewControllerResultCancelled)
                {
                    [appDelegate showAlert:@"Share canceled" CancelButton:nil OkButton:@"OK" Type:-1 Sender:self];
                }
                [appDelegate hideLoadingActivity];
//                [self dismissModalViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            };
        }else
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:shareString];
                [tweetSheet setTitle:shareString];
                [tweetSheet addImage:[UIImage imageNamed:@"Icon.png"]];
                [tweetSheet addURL:[NSURL URLWithString:shareUrl]];
                
                [self presentViewController:tweetSheet animated:YES completion:nil];
                tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult res)
                {
                    if(res == TWTweetComposeViewControllerResultDone)
                    {
                        [appDelegate showAlert:@"Share success" CancelButton:nil OkButton:@"OK" Type:-1 Sender:self];
                    }
                    if(res == TWTweetComposeViewControllerResultCancelled)
                    {
                        [appDelegate showAlert:@"Share canceled" CancelButton:nil OkButton:@"OK" Type:-1 Sender:self];
                    }
                    [appDelegate hideLoadingActivity];
//                    [self dismissModalViewControllerAnimated:YES];
                    [self dismissViewControllerAnimated:YES completion:nil];
                };
            }else
            {
                [appDelegate showAlert:@"You have no twitter account. Plese login with your account and try again." CancelButton:nil OkButton:@"OK" Type:-1 Sender:self];
                
                [appDelegate hideLoadingActivity];
            }
        }
    }
}

- (void)initWordLettersFrame:(NSString*)wordString
{
    //calc offset
    imageWidth = 30;
    int distanceBetween = 5;
    if([wordString length] > 8)
        distanceBetween = 3;
    
    if ( appDelegate.screenWidth - imageWidth*(int)[wordString length] - distanceBetween*((int)[wordString length]+1) < 0 ) {
        imageWidth = ( appDelegate.screenWidth - distanceBetween*((int)[wordString length]+1) ) / [wordString length];
    }
    
    int xOffset = (int)((appDelegate.screenWidth - imageWidth*[wordString length] - distanceBetween*((int)[wordString length]-1)))/2;
    int yOffset = 0;
    if([appDelegate isIPHONE5])
        yOffset = 420+4;
    else
        yOffset = 365;
    NSLog(@"%d",xOffset);
    for (int i = 0; i < [wordString length]; i++)
    {
        UIImageView *wordFrameIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"letter-bg.png"]];
        wordFrameIV.frame = CGRectMake(xOffset, yOffset, imageWidth, imageWidth);
        [self.view addSubview:wordFrameIV];
        //[self.view bringSubviewToFront:wordFrameIV];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:[NSNumber numberWithFloat:wordFrameIV.center.x] forKey:@"centerX"];
        [dict setValue:[NSNumber numberWithFloat:wordFrameIV.center.y] forKey:@"centerY"];
        [dict setValue:[NSNumber numberWithInt:-1] forKey:@"letterID"];
        [wordPlaceholdersArray addObject:dict];
//        [dict release];
        
//        [wordFrameIV release];
        xOffset += imageWidth + distanceBetween;
    }
}

- (void)initLettersFrame:(NSString*)lettersString
{
    int xOffset = (int)((appDelegate.screenWidth - 30*[lettersString length]/2 - 5*([lettersString length]/2-1)))/2;
    int yOffset = 0;
    if([appDelegate isIPHONE5])
        yOffset = 480;
    else
        yOffset = 408;
    for (int i = 0; i < [lettersString length]; i++)
    {
        if(i == [lettersString length]/2)
        {
            xOffset = (int)((appDelegate.screenWidth - 30*[lettersString length]/2 - 5*([lettersString length]/2-1)))/2;
            if([appDelegate isIPHONE5])
                yOffset += 30 + 10;
            else
                yOffset += 30 + 3;
        }
        
        Letter *letter = [[Letter alloc]initWithFrame:CGRectMake(xOffset, yOffset, imageWidth, imageWidth)];
        [letter setBackgroundImage:[UIImage imageNamed:@"letter-bg.png"] forState:UIControlStateNormal];
        letter.tag = i;
        [letter setLetterText:[[allLetters substringWithRange:NSMakeRange(i, 1)]uppercaseString]];
        [letter setTitle:letter.letterText forState:UIControlStateNormal];
        [letter setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [letter.titleLabel setFont:[UIFont fontWithName:@"marvin" size:20]];
        [letter addTarget:self action:@selector(letterTUI:) forControlEvents:UIControlEventTouchUpInside];
        
//        //seach if letters is extra or not
//        BOOL isInWord = NO;
//        int count = 0;
//        for (int j = 0; j < [word length]; j++)
//        {
//            if([letter.letterText isEqualToString:[[word substringWithRange:NSMakeRange(j, 1)]uppercaseString]])
//            {
//                isInWord = YES;
//                count++;
//                break;
//            }
//        }
//        if(isInWord )
//        {
//            NSLog(@"%@",letter.letterText);
//          [letter setIsExtra:NO];
//        }else
//            [letter setIsExtra:YES];
        
        [self.view addSubview:letter];
        [lettersArray addObject:letter];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:[NSNumber numberWithFloat:letter.center.x] forKey:@"centerX"];
        [dict setValue:[NSNumber numberWithFloat:letter.center.y] forKey:@"centerY"];
        [dict setValue:[NSNumber numberWithInt:i] forKey:@"letterID"];
        [lettersPlaceholdersArray addObject:dict];
//        [dict release];
        
//        [letter release];
        
        xOffset += 30 + 5;
    }
}

- (void)letterTUI:(id)sender
{
    Letter *letter = (Letter*)sender;
    //check ifthe letter is in the word or in the letters frame
    BOOL founded = NO;
    int firstFreePosition = -1;
    if(letter.draggedToWord)
    {
        //move the letter to the first available space in letters frame
        for (int i = 0; i < [lettersPlaceholdersArray count]; i++)
        {
            if([[[lettersPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]intValue] == -1)
            {
                founded = YES;
                firstFreePosition = i;
                break;
            }
        }
        if(founded)
        {
            //now move the selected letter to this position
            letter.draggedToWord = NO;
            [[lettersPlaceholdersArray objectAtIndex:firstFreePosition] setValue:[NSNumber numberWithInteger:letter.tag] forKey:@"letterID"];
            
            //search the letter in the lettersplaceholder array and set to -1 letterID
            for (int i = 0; i < [wordPlaceholdersArray count]; i++)
            {
                if([[[wordPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]intValue] == letter.tag)
                {
                    [[wordPlaceholdersArray objectAtIndex:i] setValue:[NSNumber numberWithInt:-1] forKey:@"letterID"];
                    break;
                }
            }
            [UIView animateWithDuration:0.5 animations:^{
                letter.center = CGPointMake([[[lettersPlaceholdersArray objectAtIndex:firstFreePosition]objectForKey:@"centerX"]integerValue],
                                            [[[lettersPlaceholdersArray objectAtIndex:firstFreePosition]objectForKey:@"centerY"]integerValue]);
            } completion:^(BOOL finished) {
                NSLog(@"dragged to word");
                //if(!self.letterIsMoving)
                    [self checkWord];
                //[self setLetterIsMoving: NO];
            }];
        }else
        {
            //no letter free position - implausible
        }
    }else
    {
        //move the letter to the first available space in word
        for (int i = 0; i < [wordPlaceholdersArray count]; i++)
        {
            if([[[wordPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]intValue] == -1)
            {
                founded = YES;
                firstFreePosition = i;
                break;
            }
        }
        if(founded)
        {
            NSLog(@"move letter: %@",letter.letterText);
            //now move the selected letter to this position
            letter.draggedToWord = YES;
            [[wordPlaceholdersArray objectAtIndex:firstFreePosition] setValue:[NSNumber numberWithInteger:letter.tag] forKey:@"letterID"];
            //search the letter in the lettersplaceholder array and set to -1 letterID
            for (int i = 0; i < [lettersPlaceholdersArray count]; i++)
            {
                if([[[lettersPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]intValue] == letter.tag)
                {
                    [[lettersPlaceholdersArray objectAtIndex:i] setValue:[NSNumber numberWithInt:-1] forKey:@"letterID"];
                    break;
                }
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                letter.center = CGPointMake([[[wordPlaceholdersArray objectAtIndex:firstFreePosition]objectForKey:@"centerX"]integerValue],
                                            [[[wordPlaceholdersArray objectAtIndex:firstFreePosition]objectForKey:@"centerY"]integerValue]);
            } completion:^(BOOL finished) {
                NSLog(@"not dragged to word");
               // if(!self.letterIsMoving)
                    [self checkWord];
                //[self setLetterIsMoving: NO];

                //self.view.userInteractionEnabled = YES;
            }];
        }else
        {
            //no word free position
        }
    }
    //check if word letter holders are all
    int lettersInWord = 0;
    for (int i = 0; i < [wordPlaceholdersArray count]; i++)
    {
        if([[[wordPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]integerValue] != -1)
            lettersInWord++;
    }
    if(lettersInWord == [wordPlaceholdersArray count]-1)
    {
        [letter setBackgroundImage:[UIImage imageNamed:@"letter-bg.png"] forState:UIControlStateNormal];
        for (int i = 0; i < [wordPlaceholdersArray count]; i++)
        {
            for (int j = 0; j < [lettersArray count]; j++)
            {
                Letter *tempLetter = (Letter*)[lettersArray objectAtIndex:j];
                if([[[wordPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]integerValue] == tempLetter.tag)
                {
                    [tempLetter setBackgroundImage:[UIImage imageNamed:@"letter-bg.png"] forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (void)checkWord
{
    //check if word letter holders are all
    int lettersInWord = 0;
    for (int i = 0; i < [wordPlaceholdersArray count]; i++)
    {
        if([[[wordPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]integerValue] != -1)
            lettersInWord++;
    }
    NSLog(@"letters in word: %d",lettersInWord);
    if(lettersInWord == [wordPlaceholdersArray count])
    {
        if([self wordIsCorrect])
        {
            //the word is correct
            //stop timer
            [gameTimer invalidate];
            gameTimer = nil;
            //stop image, audio and video playback
            if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
            {
                [drawingView setEndThread:YES];
            }
            if([[gameDict objectForKey:@"type"]isEqualToString:@"audio"])
            {
                [self stopPlaying];
            }
            if([[gameDict objectForKey:@"type"]isEqualToString:@"video"])
            {
                [videoPlayerController.moviePlayer pause];
                [videoPlayerController.moviePlayer stop];
            }
            //the animation is in progres so wait < 0.5 before show popup
            //api call to send data
            NSLog(@"call end game with delay");
            //if(!letterIsMoving)
            if(gameEnded)
                return;
            gameEnded = YES;
            self.view.userInteractionEnabled = NO;
            [self performSelectorInBackground:@selector(endGameWithDelay:) withObject:@"YES"];
        }else
        {
            //wrong word - play error sound maybe
        }
    }
}

- (void)endGameWithDelay:(NSString*)status
{
    sleep(1);
    [self performSelectorOnMainThread:@selector(endGame:) withObject:status waitUntilDone:YES];
}

- (void)endGame:(NSString*)status
{
    //api call to send data
    self.view.userInteractionEnabled = YES;
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    
    if([status boolValue])
    {
        [APIManager finishGame:[gameDict objectForKey:@"game_round_id"] Word:word Time:timerCount Token:appDelegate.userData.token ExtraTimer:extraTimer Version:appDelegate.version andTag:finishGameRequest];
    }else
    {
        [winPopupView bringSubviewToFront:popupBgIV];
        [winPopupView bringSubviewToFront:saveButton];
        [winPopupView bringSubviewToFront:nextTurnButton];
        [winPopupView bringSubviewToFront:endTurnButton];
        [winPopupView bringSubviewToFront:shareButton];
        [winPopupView bringSubviewToFront:moreCoinsButton];
        [winPopupView bringSubviewToFront:winTextIV];
        winTextIV.image = [UIImage imageNamed:@"lose-text.png"];
        [APIManager finishGame:[gameDict objectForKey:@"game_round_id"] Word:@"" Time:timerCount Token:appDelegate.userData.token ExtraTimer:extraTimer Version:appDelegate.version andTag:finishGameRequest];
    }
}

- (BOOL)wordIsCorrect
{
    NSString *tempWord = [[NSMutableString alloc]initWithString:@""];
    for (int i = 0; i < [wordPlaceholdersArray count]; i++)
    {
        for (int j = 0; j < [lettersArray count]; j++)
        {
            Letter *letter = (Letter*)[lettersArray objectAtIndex:j];
            if([[[wordPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]integerValue] == letter.tag)
            {
                tempWord = [NSString stringWithFormat:@"%@%@",tempWord,letter.letterText];
                break;
            }
        }
        //[[[wordPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]integerValue]];
        //tempWord = [NSString stringWithFormat:@"%@%@",tempWord,letter.letterText];
    }

    for (int i = 0; i < [wordPlaceholdersArray count]; i++)
    {
        for (int j = 0; j < [lettersArray count]; j++)
        {
            Letter *letter = (Letter*)[lettersArray objectAtIndex:j];
            if([[[wordPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]integerValue] == letter.tag)
            {
                if([[tempWord uppercaseString] isEqualToString:[word uppercaseString]])
                    [letter setBackgroundImage:[UIImage imageNamed:@"letter-bg-correct.png"] forState:UIControlStateNormal];
                else
                    [letter setBackgroundImage:[UIImage imageNamed:@"letter-bg-wrong.png"] forState:UIControlStateNormal];
            }
        }
    }
    if([[tempWord uppercaseString] isEqualToString:[word uppercaseString]])
    {
        //[tempWord release];
        return YES;
    }else
    {
        //[tempWord release];
        return NO;
    }
}

- (IBAction)playButtonTUI:(id)sender
{
    if(firstRun)
    {
        allLetters = [Utilities randomizeString:[NSString stringWithFormat:@"%@%@",[Utilities randomAlphanumericStringWithLength:14-[word length]],word]];
        [self initLettersFrame:allLetters];
        [self startGame];
        firstRun = NO;
        //enable powerups
        powersScrollView.userInteractionEnabled = YES;
    }
    //enable interface
    playButton.hidden = YES;
    if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
    {
        //transform paths to a sinle path with one line
        
        [drawingView.recordedPath setArray:[gameDict objectForKey:@"image_array"]];
        
        //the last item is bg color
        [drawingView setBgColor:[drawingView.recordedPath lastObject]];
        [drawingView.recordedPath removeLastObject];
        reDrawEnded = NO;
        if(![appDelegate isIPHONE5])
            [drawingView.recordedPath setArray:[self rescalese:drawingView.recordedPath]];
        
        [drawingView.recordedPath setArray:[self breakPath:drawingView.recordedPath]];
        int displayCount = [drawingView.recordedPath count]/(timerMax-5);//max time - 10 seconds -> miliseconds 500
        displayCount = displayCount/15.0;
        if(displayCount < 1)
            displayCount = 1;
        
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(concurrentQueue, ^{
            [drawingView eraseAllLines:YES];
            //[drawingView playRecordedPath:drawingView.recordedPath Instant:NO];
            [drawingView playRecordedPathOnTime:drawingView.recordedPath DisplayCount:displayCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                reDrawEnded = YES;
            });
        });
    }
    if([[gameDict objectForKey:@"type"]isEqualToString:@"audio"])
    {
        [self playRecording];
    }
    if([[gameDict objectForKey:@"type"]isEqualToString:@"video"])
    {
        [videoPlayerController.moviePlayer play];
    }
}

- (void)videoPlaybackComplete:(NSNotification*)aNotification
{
    //NSLog(@"%@",aNotification.userInfo);
   // NSLog(@"%@",aNotification.object);

//    NSLog(@"%d",videoPlayerController.moviePlayer.playbackState);
    if((videoPlayerController.moviePlayer.playbackState == MPMoviePlaybackStateStopped || videoPlayerController.moviePlayer.playbackState == MPMoviePlaybackStatePaused) && !appDelegate.gamePaused)
    {
        NSLog(@"movie palyer stopped");
        //video
        playButton.hidden = NO;
       // [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:videoPlayerController.moviePlayer];

        if(videoPlayerController != nil)
            [videoPlayerController.view removeFromSuperview];
        if(videoPlayerController != nil)
        {
//            [videoPlayerController release];
            videoPlayerController = nil;
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@-%@.mov",@"video-record",[gameDict objectForKey:@"game_round_id"]]];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        videoPlayerController = [[ MPMoviePlayerViewController alloc] initWithContentURL:url];
        UIGraphicsEndImageContext();
        [videoPlayerController.moviePlayer prepareToPlay];
        videoPlayerController.moviePlayer.controlStyle = MPMovieControlStyleNone;
        videoPlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        videoPlayerController.moviePlayer.fullscreen = YES;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlaybackComplete:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerController.moviePlayer];

//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(videoPlaybackComplete:)
//                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification object:videoPlayerController.moviePlayer];
        
        [[videoPlayerController view] setFrame:CGRectMake(0, 0, recordView.frame.size.width, recordView.frame.size.height)];//setBounds:videoPreviewView.frame];
        videoPlayerController.moviePlayer.scalingMode = MPMovieScalingModeFill;
        [recordView addSubview:videoPlayerController.view];
        
        videoPlayerController.moviePlayer.shouldAutoplay = NO;
        [recordView bringSubviewToFront:playButton];
    }
}

#pragma mark - Popup show/dismiss

- (void) showAddMorePopup
{
    addMorePopupView.hidden = NO;
    dismissAddMorePopupButton.hidden = NO;
    dismissAddMorePopupButton.userInteractionEnabled = NO;
    addMorePopupView.userInteractionEnabled = NO;
    dismissAddMorePopupButton.userInteractionEnabled = NO;
    int yOffset = addMorePopupView.frame.origin.y;
    int popupSize = addMorePopupView.frame.size.height;
    addMorePopupView.frame = CGRectMake(addMorePopupView.center.x, addMorePopupView.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        addMorePopupView.frame = CGRectMake(25, yOffset, 270, popupSize);
    } completion:^(BOOL finished) {
        addMorePopupView.userInteractionEnabled = YES;
        dismissAddMorePopupButton.userInteractionEnabled = YES;
    }];
}

- (void) dismissAddMorePopup
{
    addMorePopupView.userInteractionEnabled = NO;
    dismissAddMorePopupButton.userInteractionEnabled = NO;
    int yOffset = addMorePopupView.frame.origin.y;
    int popupSize = addMorePopupView.frame.size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        addMorePopupView.frame = CGRectMake(addMorePopupView.center.x, addMorePopupView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         addMorePopupView.userInteractionEnabled = YES;
         addMorePopupView.hidden = YES;
         dismissAddMorePopupButton.hidden = YES;
         addMorePopupView.frame = CGRectMake(25, yOffset, 270, popupSize);
         dismissAddMorePopupButton.userInteractionEnabled = YES;
     }];
}

- (void)showSharePopup
{
    sharePopupView.userInteractionEnabled = NO;
    shareView.userInteractionEnabled = NO;
    sharePopupView.hidden = NO;
    shareView.hidden = NO;
    sharePopupView.frame = CGRectMake(sharePopupView.center.x, sharePopupView.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        sharePopupView.frame = CGRectMake(40, 190, 238, 120);
    } completion:^(BOOL finished) {
        sharePopupView.userInteractionEnabled = YES;
        shareView.userInteractionEnabled = YES;
    }];
}

- (void)dismissSharePopup
{
    sharePopupView.userInteractionEnabled = NO;
    shareView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        sharePopupView.frame = CGRectMake(sharePopupView.center.x, sharePopupView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         sharePopupView.userInteractionEnabled = YES;
         shareView.userInteractionEnabled = YES;
         sharePopupView.hidden = YES;
         shareView.hidden = YES;
     }];
}

#pragma mark - Achievement Methods
- (void)dismissAchievementCompletedPopup
{
    popupView.userInteractionEnabled = NO;
    AchievementCompletedView *achievementView = (AchievementCompletedView*)[achievementPopups lastObject];
    [UIView animateWithDuration:0.2 animations:^{
        achievementView.frame = CGRectMake(achievementView.center.x, achievementView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         popupView.userInteractionEnabled = YES;
         [achievementView removeFromSuperview];
         [achievementPopups removeLastObject];
     }];
}

- (IBAction)closePopupButtonTUI:(id)sender
{
    [self dismissAchievementCompletedPopup];
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
        case finishGameRequest:
        {//finish game
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    if(cancelGame)
                    {
//                        [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
                        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                        return;
                    }
                    [self performSelectorOnMainThread:@selector(showWinPopup) withObject:nil waitUntilDone:NO];
                    //get achievements list and show them
                    
                    for (int i = 0; i < [[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"achievements"] count]; i++)
                    {
                        //init popup
                        AchievementCompletedView *achievementView = [[AchievementCompletedView alloc]initWithFrame:CGRectMake(10, 99, 303, 350) AchievementName:[[[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"achievements"] objectAtIndex:i]objectForKey:@"name"] AchievementCoins:[[[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"achievements"] objectAtIndex:i]objectForKey:@"coins"] AchievementImage:[NSString stringWithFormat:@"achievement-%@.png",[[[[[dict objectForKey:@"response"]objectForKey:@"response"]objectForKey:@"achievements"] objectAtIndex:i]objectForKey:@"achievement_type_id"]] Sender:self Type:i];
                        [popupView addSubview:achievementView];
                        [achievementPopups addObject:achievementView];
//                        [achievementView release];
                        
                        popupView.hidden = NO;
                        achievementView.frame = CGRectMake(appDelegate.screenWidth/2, (appDelegate.screenHeight-20)/2, 0, 0);
                        [UIView animateWithDuration:.2 animations:^{
                            achievementView.frame = CGRectMake(10, (appDelegate.screenHeight-350-20)/2, 303, 350);
                            NSLog(@"%f",achievementView.frame.origin.x);
                        } completion:^(BOOL finished) {
                            popupView.userInteractionEnabled = YES;
                        }];
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 20)
                    {
                        //Invalid game
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 43)
                    {
                        //Game already finished
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 21)
                    {
                        //Game deleted
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:gameIsDeletedAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 45)
                    {
                        //Error finishing game.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 46)
                    {
                        //You cannot finish this game
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];

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
                    //go words screen
                    
                    GameTypeViewController *gameTypeViewController = [[GameTypeViewController alloc]initWithNibName:@"GameTypeViewController" bundle:nil WithUser:[[gameDict objectForKey:@"player"]intValue] AndData:[[dict objectForKey:@"response"] objectForKey:@"response"] Game:[[gameDict objectForKey:@"game_id"]intValue] Continue:YES];
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
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //success
                    [appDelegate showLoadingActivity];
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 16)
                    {
                        //Invalid coin value.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];

                    }
                }
            }
        }
            break;
        case registerPacketPurchaseRequest:
        {
            //register purchase
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //success
                    appDelegate.userData.coins = [[[[dict objectForKey:@"response"] objectForKey:@"response"]objectForKey:@"coins"] intValue];

                    [appDelegate showAlert:@"Packet successfully purchased." CancelButton:nil OkButton:@"OK" Type:buyOkAlert Sender:self];
                    
                    //reload powerups
                    for ( int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
                    {
                        if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == [[[[dict objectForKey:@"response"] objectForKey:@"response"]objectForKey:@"packet_id"] intValue])
                        {
                            [[appDelegate.inAppPacketsArray objectAtIndex:i]setValue:@"YES" forKey:@"purchased"];
                            break;
                        }
                    }
                    [self addPackages:appDelegate.inAppPacketsArray];
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 52)
                    {
                        //invalid  packet.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 53)
                    {
                        //Packet already purchased.
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 54)
                    {
                        //Error purchasing packet
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
                    }
                }
            }
        }
            break;
        case endGameRequest:
        {
            //end game
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //success
//                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 21)
//                    {
//                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
//                        
//                    }
//                    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
                    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
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
        case shareRequest:
        {
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //proceed with share
                    [self proceedWithShare:@""];
//                    //success
//                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 53)
//                    {
//                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];
//                    }
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
                        //invalid  packet.
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

#pragma mark - Alert Delegates
- (void)alertOkBtnTUI:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        appDelegate.alertDialog.alpha = 0.0;
    }completion:^(BOOL finished) {
        [appDelegate.alertDialog removeFromSuperview];
        switch ([sender tag])
        {
            case noInternetAlert:
            {
                //return to home screen
//                [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
                [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
            }
                break;
            case timeoutAlert:
            {
                //return to home screen
//                [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
                [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

            }
                break;
            case apiErrorAlert:
            {
                //return to home screen
//                [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
                [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

            }
                break;
            case closeGameAlert:
            {
                //stop timer
                [gameTimer invalidate];
                gameTimer = nil;
                //stop image, audio and video playback
                if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
                {
                    [drawingView setEndThread:YES];
                }
                if([[gameDict objectForKey:@"type"]isEqualToString:@"audio"])
                {
                    [self stopPlaying];
                }
                if([[gameDict objectForKey:@"type"]isEqualToString:@"video"])
                {
                    [videoPlayerController.moviePlayer pause];
                    [videoPlayerController.moviePlayer stop];
                }

                //send game data
                cancelGame = YES;
                [appDelegate showLoadingActivity];
                [APIManager setSender:self];
                [APIManager finishGame:[gameDict objectForKey:@"game_round_id"] Word:@"" Time:timerCount Token:appDelegate.userData.token ExtraTimer:extraTimer Version:appDelegate.version andTag:finishGameRequest];
            }
                break;
            case buyItemAlert:
            {
                if(appDelegate.userData.coins >= [[[appDelegate.inAppPacketsArray objectAtIndex:buyItemIndex]objectForKey:@"coins"]intValue])
                {
                    [appDelegate showLoadingActivity];
                    [APIManager setSender:self];
                    [APIManager registerPurchase:appDelegate.userData.token PacketID:[[[appDelegate.inAppPacketsArray objectAtIndex:buyItemIndex]objectForKey:@"packet_id"]intValue] Version:appDelegate.version andTag:registerPacketPurchaseRequest];
                }else
                    [appDelegate showAlert:@"You don't have sufficient coins to purchase this item" CancelButton:nil OkButton:@"OK" Type:noCoinsAlert Sender:self];

            }
                break;
            case invalidAppIDAlert:
            {
                [appDelegate.userData setValidLogin:NO];
                [Utilities saveUserInfo:appDelegate.userData];
                [appDelegate showReloginScreen];
            }
                break;
            case gameIsDeletedAlert:
            {
//                [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
                [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

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
                    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

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
            case noInternetAlert:
            {
            }
                break;
            case closeGameAlert:
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

#pragma mark - Audio Play/Pause/Stop Methods
- (void) playRecording
{
    NSLog(@"playRecording");
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithData:[Utilities base64DataFromString:[gameDict objectForKey:@"data"]] error:&error];
    audioPlayer.numberOfLoops = 0;
    audioPlayer.delegate = self;
    [audioPlayer play];
    NSLog(@"playing");
}

- (void) stopPlaying
{
    NSLog(@"stopPlaying");
    if(audioPlayer != nil && audioPlayer.isPlaying)
        [audioPlayer stop];
    //audioPlayer.delegate = nil;
}

- (void) pausePlaying
{
    NSLog(@"pausePlaying");
    if(audioPlayer != nil && audioPlayer.isPlaying)
        [audioPlayer pause];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //[player release];
    //player = nil;
    if(!appDelegate.gamePaused)
        playButton.hidden = NO;
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

- (NSMutableArray*)rescalese:(NSMutableArray*)drawing_path
{
    float ratio = 360.0/312.0;
    float newHeight = 305.0;
    float newWidth = newHeight/ratio;
    float scaleRatio = newWidth/312.0;

    int l = 0;
    int p = 0;

    for(l = 0; l < [drawing_path  count]; l++)
    {
        for(p = 0; p < [[drawing_path objectAtIndex:l]count]; p ++)
        {
            CGPoint point = [[[[drawing_path objectAtIndex:l]objectAtIndex:p]objectForKey:@"point"]CGPointValue];
            point.x = point.x*scaleRatio+(312-newWidth)/2;
            point.y = point.y*scaleRatio+(305-newHeight)/2;

//            if(point.x < 0)
//                point.x = 0;
//            if(point.x > newWidth)
//                point.x = newWidth;
//            
//            if(point.y < 0)
//                point.y = 0;
//            if(point.y > newHeight)
//                point.y = newHeight;
            [[[drawing_path objectAtIndex:l]objectAtIndex:p] setValue:[NSValue valueWithCGPoint:point] forKey:@"point"];
            float brushSize = [[[[drawing_path objectAtIndex:l]objectAtIndex:p] objectForKey:@"brush-size" ] floatValue]*scaleRatio;
            [[[drawing_path objectAtIndex:l]objectAtIndex:p] setValue:[NSNumber numberWithFloat:brushSize] forKey:@"brush-size"];
        }
    }
    return drawing_path;
}

- (void)powerupSelectedTUI:(id)sender
{
    UIButton *powerupButton = (UIButton*)sender;
    powerupButton.enabled = NO;
    switch ([sender tag])
    {
        case kTimer2minPackage:
        {
            for (int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
            {
                if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == [sender tag])
                {
                    [[appDelegate.inAppPacketsArray objectAtIndex:i]setValue:@"YES" forKey:@"used"];
                    break;
                }
            }
            //start timer
            extraTimer = kTimer2minPackage;
            timerMax = timerMax-timerCount + 2*60;//seconds
            [self updateLabel:[NSNumber numberWithInt:timerMax-timerCount]];

        }
            break;
        case kTimer5minPackage:
        {
            for (int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
            {
                if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == [sender tag])
                {
                    [[appDelegate.inAppPacketsArray objectAtIndex:i]setValue:@"YES" forKey:@"used"];
                    break;
                }
            }
            //start timer
            extraTimer = kTimer5minPackage;
            timerMax = timerMax-timerCount + 5*60;//seconds
            [self updateLabel:[NSNumber numberWithInt:timerMax-timerCount]];
        }
            break;
        case kTimerInfinitePackage:
        {
            //disable all times and stop timer
            for (int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
            {
                if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == [sender tag])
                {
                    [[appDelegate.inAppPacketsArray objectAtIndex:i]setValue:@"YES" forKey:@"used"];
                }
                if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == kTimer2minPackage)
                {
                    [[appDelegate.inAppPacketsArray objectAtIndex:i]setValue:@"YES" forKey:@"used"];
                    UIButton *tempButton = (UIButton*)[powersScrollView viewWithTag:kTimer2minPackage];
                    tempButton.enabled = NO;
                }
                if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == kTimer5minPackage)
                {
                    [[appDelegate.inAppPacketsArray objectAtIndex:i]setValue:@"YES" forKey:@"used"];
                    UIButton *tempButton = (UIButton*)[powersScrollView viewWithTag:kTimer2minPackage];
                    tempButton.enabled = NO;
                }
                if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == kTimerStopPackage)
                {
                    [[appDelegate.inAppPacketsArray objectAtIndex:i]setValue:@"YES" forKey:@"used"];
                    UIButton *tempButton = (UIButton*)[powersScrollView viewWithTag:kTimer2minPackage];
                    tempButton.enabled = NO;
                }
            }
            //start timer
            //stop timer
            [gameTimer invalidate];
            gameTimer = nil;
            extraTimer = kTimerInfinitePackage;

            [timerView viewWithTag:88].hidden = YES;
            [timerView viewWithTag:99].hidden = YES;
            [timerView viewWithTag:77].hidden = YES;

            LabelBorder *timeLabel;
            if([appDelegate isIOS7])
                timeLabel = [[LabelBorder alloc]initWithFrame:CGRectMake(0, 0, timerView.frame.size.width, timerView.frame.size.height) BorderColor:[UIColor blackColor]];
            else
                timeLabel = [[LabelBorder alloc]initWithFrame:CGRectMake(0, -7, timerView.frame.size.width, timerView.frame.size.height) BorderColor:[UIColor blackColor]];

            timeLabel.tag = 66;
            timeLabel.backgroundColor = [UIColor clearColor];
            timeLabel.textColor = [UIColor whiteColor];
            timeLabel.font = [UIFont fontWithName:@"marvin" size:80];
            if([appDelegate isIPHONE5])
                timeLabel.textAlignment = NSTextAlignmentCenter;
            else
                timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.text = @"∞";
            [timerView addSubview:timeLabel];
//            [timeLabel release];
        }
            break;
        case kTimerStopPackage:
        {
            for (int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
            {
                if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == [sender tag])
                {
                    [[appDelegate.inAppPacketsArray objectAtIndex:i]setValue:@"YES" forKey:@"used"];
                    break;
                }
            }
            //stop timer
            [gameTimer invalidate];
            gameTimer = nil;
            
            int stopTime = 20;//seconds
            stopGameTimer = [NSTimer scheduledTimerWithTimeInterval:stopTime target:self selector:@selector(stopGameEnded) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:stopGameTimer forMode:NSRunLoopCommonModes];
        }
            break;
        case kHintPackage:
        {
            for (int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
            {
                if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == [sender tag])
                {
                    [[appDelegate.inAppPacketsArray objectAtIndex:i]setValue:@"YES" forKey:@"used"];
                    break;
                }
            }
            //remove letters
            [self removeLetters];
        }
            break;
        default:
            break;
    }
}

- (void)stopGameEnded
{
    //the game was pauses and stop timer ended
    //start the timers
    [stopGameTimer invalidate];
    stopGameTimer = nil;
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerInterrupt) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:gameTimer forMode:NSRunLoopCommonModes];
}

- (void)removeLetters
{
    NSMutableArray *tempLetters = [[NSMutableArray alloc]init];
    for (int i = 0; i <[lettersArray count]; i++)
         [tempLetters addObject:@"0"];

    for (int i = 0; i < [word length]; i++)
    {
        for (int j = 0; j < [lettersArray count]; j++)
        {
            if([[tempLetters objectAtIndex:j]intValue] == 0)
            {
                Letter *letter = (Letter*)[lettersArray objectAtIndex:j];
                if([[letter.letterText uppercaseString] isEqualToString:[[word substringWithRange:NSMakeRange(i, 1)]uppercaseString]])
                {
                    [tempLetters replaceObjectAtIndex:j withObject:@"1"];
                    break;
                }
            }
        }
    }
    __block int k = 0;
    for (int i = 0; i < [tempLetters count]; i++)
    {
        if([[tempLetters objectAtIndex:i]intValue] == 0)
        {
            Letter *letter = (Letter*)[lettersArray objectAtIndex:i];
            [letter setIsExtra:YES];
            k++;
        }
    }
//    [tempLetters release];
    for (int i = 0; i < [lettersArray count]; i++)
    {
        Letter *letter = (Letter*)[lettersArray objectAtIndex:i];
        if(letter.isExtra)
        {
            for (int j = 0; j < [wordPlaceholdersArray count]; j++)
            {
                if([[[wordPlaceholdersArray objectAtIndex:j]objectForKey:@"letterID"]intValue] == letter.tag)
                {
                    [[wordPlaceholdersArray objectAtIndex:j]setValue:@"-1" forKey:@"letterID"];
                }
            }
            for (int j = 0; j < [lettersPlaceholdersArray count]; j++)
            {
                if([[[lettersPlaceholdersArray objectAtIndex:j]objectForKey:@"letterID"]intValue] == letter.tag)
                {
                    [[lettersPlaceholdersArray objectAtIndex:j]setValue:@"-1" forKey:@"letterID"];
                }
            }
            [UIView animateWithDuration:0.2 animations:^{
                letter.frame = CGRectMake(letter.frame.origin.x+letter.frame.size.width/2, letter.frame.origin.y+letter.frame.size.height/2, 0, 0);
            } completion:^(BOOL finished) {
                letter.hidden = YES;
                [lettersArray removeObjectAtIndex:i];
                k--;
                NSLog(@"%d",k);
                if(k == 0)
                {
                    int lettersInWord = 0;
                    for (int i = 0; i < [wordPlaceholdersArray count]; i++)
                    {
                        if([[[wordPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]integerValue] != -1)
                            lettersInWord++;
                    }
                    if(lettersInWord < [wordPlaceholdersArray count])
                    {
                        [letter setBackgroundImage:[UIImage imageNamed:@"letter-bg.png"] forState:UIControlStateNormal];
                        for (int i = 0; i < [wordPlaceholdersArray count]; i++)
                        {
                            for (int j = 0; j < [lettersArray count]; j++)
                            {
                                Letter *tempLetter = (Letter*)[lettersArray objectAtIndex:j];
                                if([[[wordPlaceholdersArray objectAtIndex:i]objectForKey:@"letterID"]integerValue] == tempLetter.tag)
                                {
                                    [tempLetter setBackgroundImage:[UIImage imageNamed:@"letter-bg.png"] forState:UIControlStateNormal];
                                }
                            }
                        }
                    }
                }
//                if([lettersArray count] == 0)
//                {
//                    [lettersArray setArray:remainingLetters];
//                    [remainingLetters release];
//                }
            }];
        }
    }
//    return;
//    NSMutableArray *tempLetters = [[NSMutableArray alloc]init];
//    for (int i = 0; i < [allLetters length]; i++)
//    {
//        for (int j = 0; j < [word length]; j++)
//        {
//            if([[[allLetters substringWithRange:NSMakeRange(i, 1)]uppercaseString] isEqualToString:[[word substringWithRange:NSMakeRange(j, 1)]uppercaseString]])
//            {
//                BOOL alreadyExists = NO;
//                for (int z = 0; z < [tempLetters count]; z++)
//                {
//                    if([[word substringWithRange:NSMakeRange(j, 1)] isEqualToString:[tempLetters objectAtIndex:z]])
//                    {
//                        alreadyExists = YES;
//                        break;
//                    }
//                }
//                if(!alreadyExists)
//                    [tempLetters addObject:[word substringWithRange:NSMakeRange(j, 1)]];
//                //break;
//            }
//        }
//    }
//    
//    NSMutableArray *remainingLetters = [[NSMutableArray alloc]init];
//    for (int i = 0; i < [tempLetters count]; i++)
//    {
//        int j = 0;
//        while (j < [lettersArray count])
//        //for (int j = 0; j < [lettersArray count]; j++)
//        {
//            Letter *letter = (Letter*)[lettersArray objectAtIndex:j];
//            if([[[tempLetters objectAtIndex:i]uppercaseString] isEqualToString:[letter letterText]])
//            {
//                //[tempLetters replaceObjectAtIndex:i withObject:letter];
//                [remainingLetters addObject:[lettersArray objectAtIndex:j]];
//                
//                [lettersArray removeObjectAtIndex:j];
//                break;
//            }
//            j++;
//        }
//    }
//    [tempLetters release];
//    
//    for (int i = 0; i < [lettersArray count]; i++)
//    {
//        int j = 0;
//        while (j < [lettersPlaceholdersArray count])
//        {
//            NSLog(@"%d,%d",[[lettersArray objectAtIndex:i] tag], [[[lettersPlaceholdersArray objectAtIndex:j]objectForKey:@"letterID"]intValue]);
//            if([[lettersArray objectAtIndex:i] tag] == [[[lettersPlaceholdersArray objectAtIndex:j]objectForKey:@"letterID"]intValue])
//            {
//                [lettersPlaceholdersArray removeObjectAtIndex:j];
//                //break;
//            }
//            j++;
//        }
//    }
//    for (int i = 0; i < [lettersArray count]; i++)
//    {
//        Letter *letter = (Letter*)[lettersArray objectAtIndex:i];
//        [UIView animateWithDuration:0.2 animations:^{
//            letter.frame = CGRectMake(letter.frame.origin.x+letter.frame.size.width/2, letter.frame.origin.y+letter.frame.size.height/2, 0, 0);
//        } completion:^(BOOL finished) {
//            [lettersArray removeObjectAtIndex:i];
//            if([lettersArray count] == 0)
//            {
//                [lettersArray setArray:remainingLetters];
//                [remainingLetters release];
//            }
//        }];
//    }
}

- (void)purchaseButtonTUI:(id)sender
{
    buyItemIndex = -1;
    for (int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
    {
        if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == [sender tag])
        {
            buyItemIndex = i;
            break;
        }
    }
    if(buyItemIndex != -1)
    {
            [appDelegate showAlert:[NSString stringWithFormat:@"Do you want to buy %@ for %@ coins?",[[appDelegate.inAppPacketsArray objectAtIndex:buyItemIndex]objectForKey:@"name"],[[appDelegate.inAppPacketsArray objectAtIndex:buyItemIndex]objectForKey:@"coins"]] CancelButton:@"NO" OkButton:@"YES" Type:buyItemAlert Sender:self];
    }
}

#pragma mark - Facebook Share Delegates
- (void)postWithUrl:(NSString*)URL andImageURL:(NSString*)imageURL andTitle:(NSString*)title andDescprition:(NSString*)description
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:title, imageURL, URL, description, nil] forKeys:[NSArray arrayWithObjects:@"name", @"picture", @"link", @"description", nil ]];
    
    [FBWebDialogs presentFeedDialogModallyWithSession:[FBSession activeSession]
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error){
                                                  [appDelegate hideLoadingActivity];
                                                  if(error != nil)
                                                      
                                                  {
                                                      [appDelegate showAlert:@"Share error" CancelButton:nil OkButton:@"OK" Type:-1 Sender:self];
                                                  }else
                                                  {
                                                      if(result == FBWebDialogResultDialogCompleted)
                                                      {
                                                          [appDelegate showAlert:@"Share success" CancelButton:nil OkButton:@"OK" Type:-1 Sender:self];
                                                      }else
                                                      {
                                                          [appDelegate showAlert:@"Share canceled" CancelButton:nil OkButton:@"OK" Type:-1 Sender:self];
                                                      }
                                                  }
                                              }
     ];
}

- (NSMutableArray*)breakPath:(NSMutableArray*)path
{
    NSMutableArray *tempPath = [[NSMutableArray alloc]init];
    int l = 0;
    int p = 0;
    for(l = 0; l < [path count]; l++)
    {
        for(p = 0; p < [[path objectAtIndex:l]count]; p ++)
        {
            [tempPath addObject:[[path objectAtIndex:l]objectAtIndex:p]];
            [[tempPath lastObject] setValue:[NSNumber numberWithInt:l] forKey:@"line"];

            if(p == 0 || p == [[path objectAtIndex:l]count])
                [[tempPath lastObject] setValue:@"YES" forKey:@"line_end"];
            else
                [[tempPath lastObject] setValue:@"NO" forKey:@"line_end"];
        }
    }
    return tempPath;
}

#pragma mark - app notifications
- (void)handleEnteredBackground
{
    logoIV.hidden = NO;
    [self.view bringSubviewToFront:logoIV];
    if(gameTimer != nil && !appDelegate.gamePaused && addMorePopupView.hidden == YES)
    {
        [appDelegate setGamePaused:YES];
        //stop timers
        [gameTimer invalidate];
        gameTimer = nil;
        //check game type
        if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
        {
            
        }
        if([[gameDict objectForKey:@"type"]isEqualToString:@"audio"])
        {
            [audioPlayer pause];
        }
        if([[gameDict objectForKey:@"type"]isEqualToString:@"video"])
        {
            playbackProgress = videoPlayerController.moviePlayer.currentPlaybackTime;
            [videoPlayerController.moviePlayer pause];
        }
    }
}

- (void)handleEnteredForeground
{
    logoIV.hidden = YES;
    
   if(appDelegate.gamePaused && addMorePopupView.hidden == YES)
    {
        [appDelegate setGamePaused:NO];
        //start timers if the game was started
        if(!firstRun)
        {
            //start timers
            [self startGame];
            
            //check game type
//            if([[gameDict objectForKey:@"type"]isEqualToString:@"image"])
//            {
//                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//                dispatch_async(concurrentQueue, ^{
//                    [drawingView playRecordedPathOnTime:drawingView.recordedPath DisplayCount:-1];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        reDrawEnded = YES;
//                    });
//                });
//            }
            if([[gameDict objectForKey:@"type"]isEqualToString:@"audio"])
            {
                [audioPlayer play];
            }
            if([[gameDict objectForKey:@"type"]isEqualToString:@"video"])
            {
                [videoPlayerController.moviePlayer setInitialPlaybackTime:playbackProgress];
                [videoPlayerController.moviePlayer play];
            }
        }
    }
}


@end
