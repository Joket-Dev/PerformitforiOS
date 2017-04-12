//
//  GamePlayViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 5/15/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DrawingView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Tapjoy/Tapjoy.h>
#import <FacebookSDK/FacebookSDK.h>

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class AppDelegate;
@interface GamePlayViewController : UIViewController<AVAudioPlayerDelegate, TJCViewDelegate>
{
    AppDelegate *appDelegate;
    
    NSMutableDictionary *gameDict;
    
    int timerMax;
    int timerCount;
    int extraTimerMax;
    int extraTimer;
    int imageWidth;
    BOOL firstRun;
    
    NSString *word;
    NSString *allLetters;
    
    NSTimer *gameTimer;
    //NSTimer *playbackTimer;
    NSTimer *stopGameTimer;

    BOOL cancelGame;
    BOOL reDrawEnded;
    int lastSelectedShareType;
    
    NSMutableArray *shareArray;
    float playbackProgress;
    int buyItemIndex;
}
@property (nonatomic, strong) IBOutlet UIImageView *backgroundIV;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) IBOutlet UIView *winPopupView;
@property (nonatomic, strong) IBOutlet UIView *popupView;
@property (nonatomic, strong) IBOutlet UIImageView *popupBgIV;
@property (nonatomic, strong) IBOutlet UIView *topView;;
@property (nonatomic, strong) IBOutlet UIButton *addMoreButton;
@property (nonatomic, strong) IBOutlet UIScrollView *powersScrollView;

@property (nonatomic, strong) IBOutlet UIButton *nextTurnButton;
@property (nonatomic, strong) IBOutlet UIButton *endTurnButton;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;

@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutlet UIButton *moreCoinsButton;
@property (nonatomic, strong) IBOutlet UIImageView *winTextIV;
@property (nonatomic, strong) IBOutlet UILabel *coinsLabel;
@property (nonatomic, strong) IBOutlet UIView *timerView;


@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, strong) NSTimer *stopGameTimer;


@property (nonatomic, strong) NSMutableArray *lettersArray;//contains all the letters
@property (nonatomic, strong) NSMutableArray *wordPlaceholdersArray;//contains the positions of word letters
@property (nonatomic, strong) NSMutableArray *lettersPlaceholdersArray;//contains the positions of picker letters


@property (nonatomic, strong) IBOutlet UIView *recordView;
@property (nonatomic, strong) MPMoviePlayerViewController *videoPlayerController;
@property (nonatomic, strong) IBOutlet UIView *audioRecordingView;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) IBOutlet DrawingView *drawingView;
@property (nonatomic, strong) IBOutlet UIButton *playButton;

@property (nonatomic, strong) IBOutlet UIView *addMorePopupView;
@property (nonatomic, strong) IBOutlet UIScrollView *addMoreScrollView;
@property (nonatomic, strong) IBOutlet UIButton *dismissAddMorePopupButton;

@property (nonatomic, strong) NSMutableArray *achievementPopups;

@property (nonatomic, strong) IBOutlet UIView *shareView;
@property (nonatomic, strong) IBOutlet UIView *sharePopupView;
@property (nonatomic, strong) IBOutlet UIScrollView *shareScrollView;
@property (nonatomic, assign) BOOL firstRun;
@property (nonatomic, assign) BOOL reDrawEnded;
@property (nonatomic, assign) float playbackProgress;

@property (nonatomic, strong) NSMutableDictionary *gameDict;
@property (nonatomic, assign) BOOL gameEnded;

@property (nonatomic, strong) IBOutlet UIImageView *logoIV;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil GameDict:(NSMutableDictionary*)game_dict;

- (void)saveAudioRecordingToGallery:(NSString*)path;
- (void)startGame;

@end
