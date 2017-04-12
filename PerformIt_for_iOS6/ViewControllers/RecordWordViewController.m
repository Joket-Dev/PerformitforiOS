//
//  RecordWordViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 4/25/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "RecordWordViewController.h"
#import "CoinsViewController.h"
#import "AVCamCaptureManager.h"
#import "AVCamRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "Utilities.h"
#import "LabelBorder.h"

#define audioProgressPXLength 212
#define videoProgressPXLength 224

#define ENC_AAC 1
#define ENC_ALAC 2
#define ENC_IMA4 3
#define ENC_ILBC 4
#define ENC_ULAW 5
#define ENC_PCM 6

#define timerStep 0.1

#define kkNoShare 0
#define kkFacebookShare 1
#define kkTwitterShare 2

@interface RecordWordViewController ()
@end

@interface RecordWordViewController (AVCamCaptureManagerDelegate) <AVCamCaptureManagerDelegate>
@end

@implementation RecordWordViewController
@synthesize homeButton;
@synthesize audioBgIV, videoBgIV;
@synthesize recordAudioView, recordVideoView;
@synthesize coinsButton;
@synthesize shareAudioButton, saveAudioButton, sendAudioButton;
@synthesize audioRecordProgressView;
@synthesize playPauseButton;
@synthesize recordAudioButton;
@synthesize soundFxPopupView;
@synthesize soundFxButton;
@synthesize closeSoundFxButton;

@synthesize videoPlayerView;
@synthesize videoPlayerController;
@synthesize captureManager;
@synthesize videoPreviewView;
@synthesize captureVideoPreviewLayer;
@synthesize shareVideoButton, saveVideoButton, sendVideoButton;
@synthesize playPauseVideoButton;
@synthesize recordVideoButton;
@synthesize rotateCameraButton;
@synthesize videoRecordProgressView;

@synthesize shareView, sharePopupView, shareScrollView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil RecordType:(int)record_type GameData:(NSMutableDictionary*)game_dict
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        recordType = record_type;
        gameDict = [[NSMutableDictionary alloc]init];
        [gameDict setDictionary:game_dict];
    }
    return self;
}

//- (void)dealloc
//{
//    [homeButton release];
//    [recordAudioView release];
//    [recordVideoView release];
//    [coinsButton release];
//    [audioBgIV release];
//    [saveAudioButton release];
//    [sendAudioButton release];
//    [shareAudioButton release];
//    [audioRecordProgressView release];
//    [playPauseButton release];
//    [recordAudioButton release];
//    [soundFxPopupView release];
//    [soundFxButton release];
//    [closeSoundFxButton release];
//    [videoBgIV release];
//    [captureManager release];
//    [videoPreviewView release];
//    [captureVideoPreviewLayer release];
//    [videoPlayerView release];
//    [videoPlayerController release];
//    [saveVideoButton release];
//    [sendVideoButton release];
//    [shareVideoButton release];
//    [recordVideoButton release];
//    [playPauseVideoButton release];
//    [rotateCameraButton release];
//    [videoRecordProgressView release];
//    [shareView release];
//    [sharePopupView release];
//    [shareScrollView release];
//    [audioPlayer release];
//    [audioRecorder release];
//    [super dealloc];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    int yOffset = 0;
    if([appDelegate isIPHONE5])
    {
        yOffset = 25;
        audioBgIV.image = [UIImage imageNamed:@"record-audio-bg-568h@2x.png"];
        audioBgIV.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);

        videoBgIV.image = [UIImage imageNamed:@"record-video-bg-568h@2x.png"];
        videoBgIV.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        
        playPauseButton.frame = CGRectMake(playPauseButton.frame.origin.x, playPauseButton.frame.origin.y+20+5, playPauseButton.frame.size.width, playPauseButton.frame.size.height);
        recordAudioButton.frame = CGRectMake(recordAudioButton.frame.origin.x, recordAudioButton.frame.origin.y+20+5, recordAudioButton.frame.size.width, recordAudioButton.frame.size.height);
    
        saveAudioButton.frame = CGRectMake(saveAudioButton.frame.origin.x, saveAudioButton.frame.origin.y+25-5, saveAudioButton.frame.size.width, saveAudioButton.frame.size.height);
        shareAudioButton.frame = CGRectMake(shareAudioButton.frame.origin.x, shareAudioButton.frame.origin.y+25-5, shareAudioButton.frame.size.width, shareAudioButton.frame.size.height);
        sendAudioButton.frame = CGRectMake(sendAudioButton.frame.origin.x, sendAudioButton.frame.origin.y+25-5, sendAudioButton.frame.size.width, sendAudioButton.frame.size.height);
        soundFxButton.frame = CGRectMake(soundFxButton.frame.origin.x, soundFxButton.frame.origin.y+25, soundFxButton.frame.size.width, soundFxButton.frame.size.height);
        homeButton.frame = CGRectMake(268, 10, homeButton.frame.size.width, homeButton.frame.size.height);
        
        soundFxPopupView.frame = CGRectMake(soundFxPopupView.frame.origin.x, soundFxPopupView.frame.origin.y, soundFxPopupView.frame.size.width, soundFxPopupView.frame.size.height);
        
        playPauseVideoButton.frame = CGRectMake(playPauseVideoButton.frame.origin.x, playPauseVideoButton.frame.origin.y+60-2, playPauseVideoButton.frame.size.width, playPauseVideoButton.frame.size.height);

        recordVideoButton.frame = CGRectMake(recordVideoButton.frame.origin.x, recordVideoButton.frame.origin.y+60, recordVideoButton.frame.size.width, recordVideoButton.frame.size.height);
    
        
        saveVideoButton.frame = CGRectMake(saveVideoButton.frame.origin.x, saveVideoButton.frame.origin.y+60, saveVideoButton.frame.size.width, saveVideoButton.frame.size.height);
        shareVideoButton.frame = CGRectMake(shareVideoButton.frame.origin.x, shareVideoButton.frame.origin.y+60, shareVideoButton.frame.size.width, shareVideoButton.frame.size.height);
        sendVideoButton.frame = CGRectMake(sendVideoButton.frame.origin.x, sendVideoButton.frame.origin.y+60, sendVideoButton.frame.size.width, sendVideoButton.frame.size.height);
        videoPlayerView.frame = CGRectMake(videoPlayerView.frame.origin.x, videoPlayerView.frame.origin.y+60-2, videoPlayerView.frame.size.width, videoPlayerView.frame.size.height);
        videoPreviewView.frame = CGRectMake(videoPreviewView.frame.origin.x, videoPreviewView.frame.origin.y+60-2, videoPreviewView.frame.size.width, videoPreviewView.frame.size.height);

        rotateCameraButton.frame = CGRectMake(rotateCameraButton.frame.origin.x, rotateCameraButton.frame.origin.y+60, rotateCameraButton.frame.size.width, rotateCameraButton.frame.size.height);
    }
    
    audioRecordName = @"audio-record";
    videoRecordName = @"video-record";
    coinsButton = [[UIButton alloc]init];
    [coinsButton addTarget:self action:@selector(coinsButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
      
    if(recordType == recordSound)
    {
        if([appDelegate isIPHONE5])
            coinsButton.frame = CGRectMake(20, 495-50+5, 45+16+5+50, 20);
        else
            coinsButton.frame = CGRectMake(20, 440-10, 45+16+5+50, 20);
        
        [recordAudioButton setImage:[Utilities imageWithView:[self recordButtonView:@"RECORD" Icon:@"record-icon-on.png"]] forState:UIControlStateNormal];
        
        UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake((recordAudioView.frame.size.width-recordAudioButton.frame.size.width)/2, recordAudioButton.frame.origin.y+recordAudioButton.frame.size.height+5, recordAudioButton.frame.size.width, 40)];
        wordLabel.backgroundColor = [UIColor clearColor];
        wordLabel.textColor = [UIColor grayColor];
        wordLabel.font = [Utilities fontWithName:@"marvin" minSize:10 maxSize:22 constrainedToSize:CGSizeMake(recordAudioButton.frame.size.width, 40) forText:[[gameDict objectForKey:@"word"]objectForKey:@"word"]];
        wordLabel.numberOfLines = 0;
        wordLabel.lineBreakMode = NSLineBreakByWordWrapping;
        if([appDelegate isIPHONE5])
            wordLabel.textAlignment = NSTextAlignmentCenter;
        else
            wordLabel.textAlignment = NSTextAlignmentCenter;
        wordLabel.text = [[gameDict objectForKey:@"word"]objectForKey:@"word"];
        [recordAudioView addSubview:wordLabel];
//        [wordLabel release];
        
        [playPauseButton setImage:[UIImage imageNamed:@"record-button.png"] forState:UIControlStateNormal];
        playPauseButton.userInteractionEnabled = NO;
        if([appDelegate isIPHONE5])
            audioRecordProgressView.frame = CGRectMake(audioRecordProgressView.frame.origin.x, audioRecordProgressView.frame.origin.y+20-2, 0, audioRecordProgressView.frame.size.height+2*2);
        else
            audioRecordProgressView.frame = CGRectMake(audioRecordProgressView.frame.origin.x, audioRecordProgressView.frame.origin.y, 0, audioRecordProgressView.frame.size.height);
        recordEncoding = ENC_PCM;
        audioIsPlaying = NO;
        
//        closeSoundFxButton.hidden = YES;
        soundFxPopupView.hidden = YES;
        [recordAudioView bringSubviewToFront:soundFxPopupView];
        
        LabelBorder *fxNameLabel = [[LabelBorder alloc]init];
        fxNameLabel.frame = CGRectMake(10, 35, 200, 20 );
        fxNameLabel.backgroundColor = [UIColor clearColor];
        fxNameLabel.textColor = [UIColor whiteColor];
        fxNameLabel.font = [UIFont fontWithName:@"marvin" size:20];
        if([appDelegate isIPHONE5])
            fxNameLabel.textAlignment = NSTextAlignmentLeft;
        fxNameLabel.textAlignment = NSTextAlignmentLeft;
        fxNameLabel.text = @"SFX NAME 1";
        [soundFxPopupView addSubview:fxNameLabel];
//        [fxNameLabel release];
        
        UISlider * customSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 35+20+5, 246, 21)];
        customSlider.backgroundColor = [UIColor clearColor];
        UIImage *stetchLeftTrack = [[UIImage imageNamed:@"sound-effects-sliderbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        UIImage *stetchRightTrack = [[UIImage imageNamed:@"sound-effects-sliderbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [customSlider setThumbImage: [UIImage imageNamed:@"slider-button.png"] forState:UIControlStateNormal];
        [customSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [customSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
        customSlider.minimumValue = 0.0;
        customSlider.maximumValue = 100.0;
        customSlider.continuous = YES;
        customSlider.value = 50.0;
        customSlider.tag = 1;
        [customSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [soundFxPopupView addSubview:customSlider];
//        [customSlider release];
        
        fxNameLabel = [[LabelBorder alloc]init];
        fxNameLabel.frame = CGRectMake(10, 35+20+5+21+20, 200, 20 );
        fxNameLabel.backgroundColor = [UIColor clearColor];
        fxNameLabel.textColor = [UIColor whiteColor];
        fxNameLabel.font = [UIFont fontWithName:@"marvin" size:20];
        if([appDelegate isIPHONE5])
            fxNameLabel.textAlignment = NSTextAlignmentLeft;
        fxNameLabel.textAlignment = NSTextAlignmentLeft;
        fxNameLabel.text = @"SFX NAME 2";
        [soundFxPopupView addSubview:fxNameLabel];
//        [fxNameLabel release];
        
        customSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 35+20+5+21+20+20+5, 246, 21)];
        customSlider.backgroundColor = [UIColor clearColor];
        
        [customSlider setThumbImage: [UIImage imageNamed:@"slider-button.png"] forState:UIControlStateNormal];
        [customSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [customSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
        customSlider.minimumValue = 0.0;
        customSlider.maximumValue = 100.0;
        customSlider.continuous = YES;
        customSlider.value = 50.0;
        customSlider.tag = 1;
        [customSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [soundFxPopupView addSubview:customSlider];
//        [customSlider release];
        
        recordVideoView.hidden = YES;
        recordAudioView.hidden = NO;
    }else
    {
        if([appDelegate isIPHONE5])
            coinsButton.frame = CGRectMake(20, 495, 45+16+5+50, 20);
        else
            coinsButton.frame = CGRectMake(20, 440-10+5, 45+16+5+50, 20);
        
        //init video record view
        [recordVideoButton setImage:[Utilities imageWithView:[self recordButtonView:@"RECORD" Icon:@"record-icon-on.png"]] forState:UIControlStateNormal];
        
        UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake((recordVideoView.frame.size.width-recordVideoButton.frame.size.width)/2, recordVideoButton.frame.origin.y+recordVideoButton.frame.size.height+5, recordVideoButton.frame.size.width, 40)];
        wordLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
        wordLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.22 alpha:1.0];
        wordLabel.font = [Utilities fontWithName:@"marvin" minSize:10 maxSize:22 constrainedToSize:CGSizeMake(recordVideoButton.frame.size.width, 40) forText:[[gameDict objectForKey:@"word"]objectForKey:@"word"]];
        wordLabel.numberOfLines = 0;
        wordLabel.lineBreakMode = NSLineBreakByWordWrapping;
        if([appDelegate isIPHONE5])
            wordLabel.textAlignment = NSTextAlignmentCenter;
        else
            wordLabel.textAlignment = NSTextAlignmentCenter;
        wordLabel.layer.cornerRadius = 3;
        
        wordLabel.text = [[gameDict objectForKey:@"word"]objectForKey:@"word"];
        [recordVideoView addSubview:wordLabel];
//        [wordLabel release];
      
        if ([self captureManager] == nil)
        {
            AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
            [self setCaptureManager:manager];
//            [manager release];
            
            [[self captureManager] setDelegate:self];
            
            if ([[self captureManager] setupSession])
            {
                // Create video preview layer and add it to the UI
                AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
                UIView *view = [self videoPreviewView];
                CALayer *viewLayer = [view layer];
                [viewLayer setMasksToBounds:YES];
                
                CGRect bounds = [view bounds];
                [newCaptureVideoPreviewLayer setFrame:bounds];
                
                if([appDelegate isIOS6])
                {
                    if ([newCaptureVideoPreviewLayer.connection isVideoOrientationSupported])
                        [newCaptureVideoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                }else
                {
                    if ([newCaptureVideoPreviewLayer isOrientationSupported])
                        [newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
                }

                [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResize];// AVLayerVideoGravityResizeAspectFill];
                [viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
                
                [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
//                [newCaptureVideoPreviewLayer release];
                
                // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[[self captureManager] session] startRunning];
                });
            }
        }
        timerStatusCount = 0;
//        videoPlayerView.hidden = YES;
        playPauseVideoButton.hidden = YES;
        recordVideoView.hidden = NO;
        recordAudioView.hidden = YES;
        
        [playPauseVideoButton setImage:[UIImage imageNamed:@"record_video_button.png"] forState:UIControlStateNormal];
        playPauseVideoButton.userInteractionEnabled = NO;
        if([appDelegate isIPHONE5])
            videoRecordProgressView.frame = CGRectMake(70, 82, 0, videoRecordProgressView.frame.size.height);
        else
            videoRecordProgressView.frame = CGRectMake(70, 23, 0, videoRecordProgressView.frame.size.height);
    }
    
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
    
    shareArray = [[NSMutableArray alloc]init];
    [shareArray addObject:[NSNumber numberWithInt:facebookShare]];
    [shareArray addObject:[NSNumber numberWithInt:twitterShare]];
    shareView.hidden = YES;
    int xOffset = 5;
    for (int i = 0; i < [shareArray count]; i++)
    {
        UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(xOffset, 0, 50, 50)];
        shareButton.tag = [[shareArray objectAtIndex:i]intValue];
        shareButton.backgroundColor = [UIColor clearColor];
        
        if([[shareArray objectAtIndex:i]intValue] == facebookShare)
            [shareButton setImage:[UIImage imageNamed:@"facebook-share-button.png"] forState:UIControlStateNormal];
        if([[shareArray objectAtIndex:i]intValue] == twitterShare)
            [shareButton setImage:[UIImage imageNamed:@"twitter-share-button.png"] forState:UIControlStateNormal];
        
        [shareButton addTarget:self action:@selector(shareTypeSelectedTUI:) forControlEvents:UIControlEventTouchUpInside];
        [shareScrollView addSubview:shareButton];
//        [shareButton release];
        xOffset = xOffset + 50 + 5;
    }
    shareScrollView.contentSize = CGSizeMake(xOffset, 50);
    homeButton.hidden = NO;
//    soundFxButton.hidden = YES;
    
    if(recordType == recordSound)
    {
        [recordAudioView addSubview:coinsButton];
//        [coinsButton release];
    }else
    {
        [recordVideoView addSubview:coinsButton];
//        [coinsButton release];
    }
    [self addCoinsButton];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredBackground)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredForeground)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
    coinsButton.exclusiveTouch = YES;
    saveAudioButton.exclusiveTouch = YES;
    saveVideoButton.exclusiveTouch = YES;
    shareAudioButton.exclusiveTouch = YES;
    shareVideoButton.exclusiveTouch = YES;
    sendAudioButton.exclusiveTouch = YES;
    sendVideoButton.exclusiveTouch = YES;
    rotateCameraButton.exclusiveTouch = YES;
    
    playPauseButton.exclusiveTouch = YES;
    playPauseVideoButton.exclusiveTouch = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [appDelegate setRecording:YES];
    lastSelectedShareType = kkNoShare;
}

- (void)viewDidAppear:(BOOL)animated
{
    //init autosave timer
    autosaveTimer = [NSTimer scheduledTimerWithTimeInterval:timerStep target:self selector:@selector(autosaveTimerCall) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:autosaveTimer forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [APIManager cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void) addVideoPlayer:(NSString*)filename From:(NSString*)from
{
    NSString *moviePath = [NSString stringWithFormat:@"%@/%@.mov",from,filename];
    NSURL *url = [NSURL fileURLWithPath:moviePath];

    videoPlayerController = [[ MPMoviePlayerViewController alloc] initWithContentURL:url];
    [videoPlayerController.moviePlayer prepareToPlay];
    videoPlayerController.moviePlayer.controlStyle = MPMovieControlStyleNone;
    videoPlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    videoPlayerController.moviePlayer.fullscreen = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlaybackComplete:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerController.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlaybackStateChanged:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:videoPlayerController.moviePlayer];
    
    
    [[videoPlayerController view] setFrame:CGRectMake(0, 0, videoPlayerView.frame.size.width, videoPlayerView.frame.size.height)];
    videoPlayerController.moviePlayer.scalingMode = MPMovieScalingModeFill;
    [videoPlayerView addSubview:videoPlayerController.view];
    
    videoPlayerController.moviePlayer.shouldAutoplay = NO;
    
    //rotateCameraButton.hidden = NO;
}

- (void)coinsButtonTUI:(id)sender
{
    //[appDelegate showAlert:@"You want to buy more coins?" CancelButton:@"NO" OkButton:@"YES" Type:moreCoinsAlert Sender:self];
}

- (IBAction)homeButtonTUI:(id)sender
{
    //delete record files
    [Utilities deleteRecordedFile:[NSString stringWithFormat:@"%@.mov",videoRecordName] fron:[Utilities documentsDirectoryPath]];
    [Utilities deleteRecordedFile:[NSString stringWithFormat:@"%@.wav",audioRecordName] fron:[Utilities documentsDirectoryPath]];
//    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)recordButtonTUI:(id)sender
{
    isRecording = YES;
    if (recordType == recordSound)
    {
        if(recorded)
        {
            recorded = NO;
            
            playPauseButton.hidden = NO;
            [playPauseButton setImage:[UIImage imageNamed:@"record-button.png"] forState:UIControlStateNormal];
            playPauseButton.userInteractionEnabled = NO;
            [recordAudioButton setImage:[Utilities imageWithView:[self recordButtonView:@"RECORD" Icon:@"record-icon-on.png"]] forState:UIControlStateNormal];
            recordAudioButton.userInteractionEnabled = YES;
            return;
        }else
        {
            playPauseButton.hidden = NO;
            [playPauseButton setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
            playPauseButton.userInteractionEnabled = YES;
        }
        recordAudioButton.userInteractionEnabled = NO;
        saveAudioButton.userInteractionEnabled = NO;
        shareAudioButton.userInteractionEnabled = NO;
        sendAudioButton.userInteractionEnabled = NO;
        coinsButton.userInteractionEnabled = NO;
        
        [Utilities deleteRecordedFile:[NSString stringWithFormat:@"%@.wav",audioRecordName] fron:[Utilities documentsDirectoryPath]];
        
        timerStatusCount = 0;
        videoLength = 10.0;
        
        timerCount = videoLength/timerStep;
        NSLog(@"count:%f",timerCount);
        recordTimer = [NSTimer timerWithTimeInterval:timerStep target:self selector:@selector(gameTimerCall) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:recordTimer forMode:NSRunLoopCommonModes];
        //[[self captureManager] startRecording];
        [self startRecording:audioRecordName];

        
        if([appDelegate isIPHONE5])
            audioRecordProgressView.frame = CGRectMake(79, 104, 0, audioRecordProgressView.frame.size.height);
        else
            audioRecordProgressView.frame = CGRectMake(79, 85, 0, audioRecordProgressView.frame.size.height);

        //playPauseButton.userInteractionEnabled = NO;
//        recorded = NO;
//        //audio
//        recordAudioButton.userInteractionEnabled = NO;
//        [Utilities deleteRecordedFile:[NSString stringWithFormat:@"%@.wav",audioRecordName] fron:[Utilities documentsDirectoryPath]];
//        if([self startRecording:audioRecordName])
//        {
//            [playPauseButton setImage:[UIImage imageNamed:@"record-button.png"] forState:UIControlStateNormal];
//            playPauseButton.userInteractionEnabled = NO;
//            [recordAudioButton setImage:[Utilities imageWithView:[self recordButtonView:@"RECORDING" Icon:@"record-icon-on.png"]] forState:UIControlStateNormal];
//            
//            playPauseButton.userInteractionEnabled = NO;
//            saveAudioButton.userInteractionEnabled = NO;
//            shareAudioButton.userInteractionEnabled = NO;
//            sendAudioButton.userInteractionEnabled = NO;
//            coinsButton.userInteractionEnabled = NO;
//            
//            timerStatusCount = 0;
//            timerCount = 10.0/timerStep;
//            
//            recordTimer = [NSTimer scheduledTimerWithTimeInterval:timerStep target:self selector:@selector(gameTimerCall) userInfo:nil repeats:YES];
//            [[NSRunLoop mainRunLoop] addTimer:recordTimer forMode:NSRunLoopCommonModes];
//            
//            audioRecordProgressView.frame = CGRectMake(audioRecordProgressView.frame.origin.x, audioRecordProgressView.frame.origin.y, 0, audioRecordProgressView.frame.size.height);
//            playPauseButton.userInteractionEnabled = NO;
//
//            
//        }else
//        {
//            //error recording audio
//            recordAudioButton.userInteractionEnabled = YES;
//            [appDelegate showAlert:@"Audio recording failed. Please try later" CancelButton:nil OkButton:@"OK" Type:audioRecordFailAlert Sender:self];
//        }
    }else
    {
        //video
        if(recorded)
        {
            recorded = NO;
            rotateCameraButton.hidden = NO;
            videoPlayerView.hidden = YES;
            videoPreviewView.hidden = NO;

            playPauseVideoButton.hidden = NO;
            [playPauseVideoButton setImage:[UIImage imageNamed:@"record_video_button.png"] forState:UIControlStateNormal];
            playPauseVideoButton.userInteractionEnabled = NO;
            [recordVideoButton setImage:[Utilities imageWithView:[self recordButtonView:@"RECORD" Icon:@"record-icon-on.png"]] forState:UIControlStateNormal];
            recordVideoButton.userInteractionEnabled = YES;
            rotateCameraButton.hidden = NO;
            return;
        }else
        {
            rotateCameraButton.hidden = YES;
            videoPreviewView.hidden = NO;
            videoPlayerView.hidden = YES;
            playPauseVideoButton.hidden = NO;
            [playPauseVideoButton setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
            playPauseVideoButton.userInteractionEnabled = YES;
        }
        recordVideoButton.userInteractionEnabled = NO;
        saveVideoButton.userInteractionEnabled = NO;
        shareVideoButton.userInteractionEnabled = NO;
        sendVideoButton.userInteractionEnabled = NO;
        coinsButton.userInteractionEnabled = NO;
        
        [Utilities deleteRecordedFile:[NSString stringWithFormat:@"%@.mov",videoRecordName] fron:[Utilities documentsDirectoryPath]];
        
        timerStatusCount = 0;
        videoLength = 10.0;

        timerCount = videoLength/timerStep;
        NSLog(@"count:%f",timerCount);
        recordTimer = [NSTimer timerWithTimeInterval:timerStep target:self selector:@selector(gameTimerCall) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:recordTimer forMode:NSRunLoopCommonModes];
        [[self captureManager] startRecording];
        
        if([appDelegate isIPHONE5])
            videoRecordProgressView.frame = CGRectMake(70, 82, 0, videoRecordProgressView.frame.size.height);
        else
            videoRecordProgressView.frame = CGRectMake(70, 23, 0, videoRecordProgressView.frame.size.height);
        playPauseVideoButton.userInteractionEnabled = NO;
    }
}

- (void)gameTimerCall
{
    [self performSelectorInBackground:@selector(recordTimerInterrupt) withObject:nil];
}

- (void) recordTimerInterrupt
{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    @autoreleasepool {

    timerCount--;
    timerStatusCount++;
    if(timerStatusCount == 4)
        timerStatusCount = 0;
    
    if(timerCount*timerStep > 1)
        playPauseVideoButton.userInteractionEnabled = YES;

    NSLog(@"record timer count:%f",timerCount);
    if(timerCount <= 0)
    {
        //record/play completed
        [recordTimer invalidate];
        recordTimer = nil;
        recorded = YES;
        
        if(recordType == recordSound)
        {
            //audio
//            [recordAudioButton setImage:[Utilities imageWithView:[self recordButtonView:@"RE-RECORD" Icon:@"re-record-icon.png"]] forState:UIControlStateNormal];
//            
//            recordAudioButton.userInteractionEnabled = YES;
//            
//            saveAudioButton.userInteractionEnabled = YES;
//            shareAudioButton.userInteractionEnabled = YES;
//            sendAudioButton.userInteractionEnabled = YES;
//            coinsButton.userInteractionEnabled = YES;
//            
//            playPauseButton.userInteractionEnabled = YES;
//            [playPauseButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
//            audioRecordProgressView.frame = CGRectMake(audioRecordProgressView.frame.origin.x, audioRecordProgressView.frame.origin.y, 0, audioRecordProgressView.frame.size.height);
//            [self stopRecording];
            
            [recordAudioButton setImage:[Utilities imageWithView:[self recordButtonView:@"RE-RECORD" Icon:@"re-record-icon.png"]] forState:UIControlStateNormal];
            recordAudioButton.userInteractionEnabled = YES;
            
            saveAudioButton.userInteractionEnabled = YES;
            shareAudioButton.userInteractionEnabled = YES;
            sendAudioButton.userInteractionEnabled = YES;
            coinsButton.userInteractionEnabled = YES;
            
            recordAudioButton.hidden = NO;
            //playPauseVideoButton.hidden = YES;
            //[playPauseVideoButton setImage:[UIImage imageNamed:@"play-video-button.png"] forState:UIControlStateNormal];
            [playPauseButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
            
            if([appDelegate isIPHONE5])
                audioRecordProgressView.frame = CGRectMake(79, 104, 0, audioRecordProgressView.frame.size.height);
            else
                audioRecordProgressView.frame = CGRectMake(79, 85, 0, audioRecordProgressView.frame.size.height);
            
            [self stopRecording];
            videoLength = 10.0;
            NSLog(@"record timer stop");
        }else
        {
            //video
            [recordVideoButton setImage:[Utilities imageWithView:[self recordButtonView:@"RE-RECORD" Icon:@"re-record-icon.png"]] forState:UIControlStateNormal];
            recordVideoButton.userInteractionEnabled = YES;
            
            saveVideoButton.userInteractionEnabled = YES;
            shareVideoButton.userInteractionEnabled = YES;
            sendVideoButton.userInteractionEnabled = YES;
            coinsButton.userInteractionEnabled = YES;
            
            videoPreviewView.hidden = YES;
            videoPlayerView.hidden = NO;
            recordVideoButton.hidden = NO;
            //playPauseVideoButton.hidden = YES;
            //[playPauseVideoButton setImage:[UIImage imageNamed:@"play-video-button.png"] forState:UIControlStateNormal];
            [playPauseVideoButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];

            rotateCameraButton.hidden = YES;
            if([appDelegate isIPHONE5])
                videoRecordProgressView.frame = CGRectMake(70, 82, 0, videoRecordProgressView.frame.size.height);
            else
                videoRecordProgressView.frame = CGRectMake(70, 23, 0, videoRecordProgressView.frame.size.height);

            [[self captureManager] stopRecording];
            videoLength = 10.0;
            NSLog(@"record timer stop");
            [appDelegate showLoadingActivity];
        }
    }else
    {
        [self performSelectorOnMainThread:@selector(animateRecordStatus) withObject:nil waitUntilDone:NO];
        if(recordType == recordSound)
        {
            [self performSelectorOnMainThread:@selector(animateAudioRecording:) withObject:[NSNumber numberWithInt:10/timerStep-timerCount] waitUntilDone:NO];
        }else
        {
            [self performSelectorOnMainThread:@selector(animateTimerCountdown:) withObject:[NSNumber numberWithInt:videoLength/timerStep-timerCount] waitUntilDone:NO];
        }
    }
    }
//    [pool release];
}

- (void) playTimerInterupt
{
    timerCount--;
    NSLog(@"counter:%f",timerCount);
    if(recordType == recordSound)
    {
        [self performSelectorOnMainThread:@selector(animateAudioRecording:) withObject:[NSNumber numberWithInt:videoLength/timerStep-timerCount] waitUntilDone:NO];
    }else
    {
        [self performSelectorOnMainThread:@selector(animateTimerCountdown:) withObject:[NSNumber numberWithInt:videoLength/timerStep-timerCount] waitUntilDone:NO];
    }
    if(timerCount <= 0)
    {
        if(recordType == recordSound)
        {
            //record/play completed
            [recordTimer invalidate];
            recordTimer = nil;
            audioIsPlaying = NO;
            [playPauseButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
            recordAudioButton.hidden = NO;
            if([appDelegate isIPHONE5])
                audioRecordProgressView.frame = CGRectMake(79, 104, 0, audioRecordProgressView.frame.size.height);
            else
                audioRecordProgressView.frame = CGRectMake(79, 85, 0, audioRecordProgressView.frame.size.height);
            [self stopPlaying];
        }else
        {
            return;
            //video play completed
            NSLog(@"video playback ended");
            if([appDelegate isIPHONE5])
                videoRecordProgressView.frame = CGRectMake(70, 82, 0, videoRecordProgressView.frame.size.height);
            else
                videoRecordProgressView.frame = CGRectMake(70, 23, 0, videoRecordProgressView.frame.size.height);
//            //stop video recorded
            videoIsPlaying = NO;
            [videoPlayerController.moviePlayer pause];
            [videoPlayerController.moviePlayer stop];
        }
    }
}

- (IBAction)audioPlayPauseButtonTUI:(id)sender
{
//    if(audioIsPlaying)
//    {
//        [playPauseButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
//        recordAudioButton.hidden = NO;
//
//        [self pausePlaying];
//        [recordTimer invalidate];
//        recordTimer = nil;
//        audioIsPlaying = NO;
//        audioRecordProgressView.frame = CGRectMake(audioRecordProgressView.frame.origin.x, audioRecordProgressView.frame.origin.y, 0, audioRecordProgressView.frame.size.height);
//    }else
//    {
//        audioIsPlaying = YES;
//        [playPauseButton setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
//        recordAudioButton.hidden = YES;
//        
//        timerCount = 10.0/timerStep;
//        audioRecordProgressView.frame = CGRectMake(audioRecordProgressView.frame.origin.x, audioRecordProgressView.frame.origin.y, 0, audioRecordProgressView.frame.size.height);
//        recordTimer = [NSTimer scheduledTimerWithTimeInterval:timerStep target:self selector:@selector(playTimerInterupt) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:recordTimer forMode:NSRunLoopCommonModes];
//        [self playRecording:audioRecordName];
//    }
    if(!audioIsPlaying)
    {
        //check is audio is recording
        if([recordTimer isValid])
        {
            [recordTimer invalidate];
            recordTimer = nil;
            recorded = YES;
            videoLength = timerCount*timerStep;
            
            [recordAudioButton setImage:[Utilities imageWithView:[self recordButtonView:@"RE-RECORD" Icon:@"re-record-icon.png"]] forState:UIControlStateNormal];
            recordAudioButton.userInteractionEnabled = YES;
            
            saveAudioButton.userInteractionEnabled = YES;
            shareAudioButton.userInteractionEnabled = YES;
            sendAudioButton.userInteractionEnabled = YES;
            coinsButton.userInteractionEnabled = YES;
            
            recordAudioButton.hidden = NO;
            [playPauseButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
            playPauseButton.userInteractionEnabled = YES;
            
            [self stopRecording];
            if([appDelegate isIPHONE5])
                audioRecordProgressView.frame = CGRectMake(79, 104, 0, audioRecordProgressView.frame.size.height);
            else
                audioRecordProgressView.frame = CGRectMake(79, 85, 0, audioRecordProgressView.frame.size.height);            return;
        }
        
        //play audio recorded
        audioIsPlaying = YES;
        recordAudioButton.hidden = YES;
        playPauseButton.hidden = NO;
        
        [playPauseButton setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
        playPauseButton.userInteractionEnabled = YES;
        
        if([appDelegate isIPHONE5])
            audioRecordProgressView.frame = CGRectMake(79, 104, 0, audioRecordProgressView.frame.size.height);
        else
            audioRecordProgressView.frame = CGRectMake(79, 85, 0, audioRecordProgressView.frame.size.height);
//        videoLength = videoPlayerController.moviePlayer.playableDuration;
//        timerCount = videoLength/timerStep;
        
        [self playRecording:audioRecordName];
        videoLength = audioPlayer.duration;
        timerCount = videoLength/timerStep;
        
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:timerStep target:self selector:@selector(playTimerInterupt) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:recordTimer forMode:NSRunLoopCommonModes];
        
    }else
    {
        //stop video recorded
        [recordTimer invalidate];
        recordTimer = nil;
        
        audioIsPlaying = NO;
        recordAudioButton.hidden = NO;
        [playPauseButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];

        [self stopPlaying];
        if([appDelegate isIPHONE5])
            audioRecordProgressView.frame = CGRectMake(79, 104, 0, audioRecordProgressView.frame.size.height);
        else
            audioRecordProgressView.frame = CGRectMake(79, 85, 0, audioRecordProgressView.frame.size.height);
    }
}

- (IBAction)soundFxButtonTUI:(id)sender
{
    [self showSoundFxPopup];
}

- (IBAction)closeSoundFxButtonTUI:(id)sender
{
    [self dismissSoundFxPopup];
}

- (void) showSoundFxPopup
{
    soundFxPopupView.hidden = NO;
    closeSoundFxButton.hidden = NO;
    soundFxPopupView.userInteractionEnabled = NO;
    closeSoundFxButton.userInteractionEnabled = NO;
    int yOffset = 0;
    if([appDelegate isIPHONE5])
        yOffset = 25;
    soundFxPopupView.frame = CGRectMake(soundFxPopupView.center.x, soundFxPopupView.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        soundFxPopupView.frame = CGRectMake(30, 160+yOffset, 268, 228);
    } completion:^(BOOL finished) {
        soundFxPopupView.userInteractionEnabled = YES;
        closeSoundFxButton.userInteractionEnabled = YES;
    }];
}

- (void) dismissSoundFxPopup
{
    soundFxPopupView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        soundFxPopupView.frame = CGRectMake(soundFxPopupView.center.x, soundFxPopupView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         soundFxPopupView.userInteractionEnabled = YES;
         soundFxPopupView.hidden = YES;
         closeSoundFxButton.hidden = YES;
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

- (IBAction)videoPlayPauseButtonTUI:(id)sender
{
    if(!videoIsPlaying)
    {
        //check is video is recording
        if([recordTimer isValid])
        {
            [recordTimer invalidate];
            recordTimer = nil;
            recorded = YES;
            videoLength = timerCount*timerStep;
            
            [recordVideoButton setImage:[Utilities imageWithView:[self recordButtonView:@"RE-RECORD" Icon:@"re-record-icon.png"]] forState:UIControlStateNormal];
            recordVideoButton.userInteractionEnabled = YES;
            
            saveVideoButton.userInteractionEnabled = YES;
            shareVideoButton.userInteractionEnabled = YES;
            sendVideoButton.userInteractionEnabled = YES;
            coinsButton.userInteractionEnabled = YES;
            
            videoPreviewView.hidden = YES;
            videoPlayerView.hidden = NO;
            recordVideoButton.hidden = NO;
            //[playPauseVideoButton setImage:[UIImage imageNamed:@"play-video-button.png"] forState:UIControlStateNormal];
            [playPauseVideoButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
            playPauseVideoButton.userInteractionEnabled = YES;
            //playPauseVideoButton.hidden = YES;
            rotateCameraButton.hidden = YES;

            [[self captureManager] stopRecording];
            
            if([appDelegate isIPHONE5])
                videoRecordProgressView.frame = CGRectMake(70, 82, 0, videoRecordProgressView.frame.size.height);
            else
                videoRecordProgressView.frame = CGRectMake(70, 23, 0, videoRecordProgressView.frame.size.height);
            
            [appDelegate showLoadingActivity];
            return;
        }
        
        //play video recorded
        videoIsPlaying = YES;
        recordVideoButton.hidden = YES;
        playPauseVideoButton.hidden = NO;
        videoPreviewView.hidden = YES;
        videoPlayerView.hidden = NO;
        
        //[playPauseVideoButton setImage:[UIImage imageNamed:@"stop-video-button.png"] forState:UIControlStateNormal];
        [playPauseVideoButton setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
        playPauseVideoButton.userInteractionEnabled = YES;
        
        //timerCount = videoLength/timerStep;
        if([appDelegate isIPHONE5])
            videoRecordProgressView.frame = CGRectMake(70, 82, 0, videoRecordProgressView.frame.size.height);
        else
            videoRecordProgressView.frame = CGRectMake(70, 23, 0, videoRecordProgressView.frame.size.height);
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:timerStep target:self selector:@selector(playTimerInterupt) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:recordTimer forMode:NSRunLoopCommonModes];
        videoLength = videoPlayerController.moviePlayer.playableDuration;
        timerCount = videoLength/timerStep;

        NSLog(@"%f",videoPlayerController.moviePlayer.playableDuration);
        [videoPlayerController.moviePlayer play];
        //[appDelegate showLoadingActivity];

    }else
    {
        //stop video recorded
        videoIsPlaying = NO;
        [videoPlayerController.moviePlayer pause];
        [videoPlayerController.moviePlayer stop];
        
    }
}

#pragma mark - AUDIO RECORDING BUTTONS
- (IBAction)saveAudioButtonTUI:(id)sender
{
    if(!recorded)
    {
        [appDelegate showAlert:@"No record to save." CancelButton:nil OkButton:@"OK" Type:noRecordToSaveAlert Sender:self];
    }else
    {
        [appDelegate showLoadingActivity];
        [Utilities mergeVideoURL:@"audio-bg.mp4"
                    withAudioURL:[NSString stringWithFormat:@"%@.wav",audioRecordName]
                     ToVideoPath:[NSString stringWithFormat:@"%@.mov",audioRecordName]];
    }
}

- (void)saveAudioRecordingToGallery:(NSString*)path
{
    NSURL *url = [[NSURL alloc]initWithString:path];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:url
                                completionBlock:^(NSURL *assetURL, NSError *error)
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

- (IBAction)shareAudioButtonTUI:(id)sender
{
    if(!recorded)
    {
        [appDelegate showAlert:@"No record to share." CancelButton:nil OkButton:@"OK" Type:noRecordToShareAlert Sender:self];
    }else
    {
        [self showSharePopup];
    }
}

- (IBAction)sendAudioButtonTUI:(id)sender
{
    if(!recorded)
    {
        [appDelegate showAlert:@"Please record a audio file before sending it to your opponent." CancelButton:nil OkButton:@"OK" Type:noRecordToShareAlert Sender:self];
    }else
    {
        [recordTimer invalidate];
        recordTimer = nil;
        if([appDelegate isIPHONE5])
            audioRecordProgressView.frame = CGRectMake(79, 104, 0, audioRecordProgressView.frame.size.height);
        else
            audioRecordProgressView.frame = CGRectMake(79, 85, 0, audioRecordProgressView.frame.size.height);
        
        [self stopPlaying];
        //api call and return to home screen
        [appDelegate showLoadingActivity];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            NSString *audioString = [self avFileToData:[NSString stringWithFormat:@"%@/%@.wav",[Utilities documentsDirectoryPath],audioRecordName]];
            [APIManager setSender:self];
            [APIManager sendGameData:[gameDict objectForKey:@"game_round_id"] Data:audioString Token:appDelegate.userData.token Version:appDelegate.version andTag:sendGameDataRequest];
//            [APIManager sendAudioGameData:[gameDict objectForKey:@"game_round_id"] audio_url:[NSString stringWithFormat:@"%@/%@.wav",[Utilities documentsDirectoryPath],audioRecordName] Token:appDelegate.userData.token Version:appDelegate.version andTag:sendGameDataRequest];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        });
    }
}

#pragma mark - AUDIO RECORDING ACTIONS
- (BOOL) startRecording:(NSString*)recordName
{
    NSLog(@"startRecording");
    
//    [audioRecorder release];
    audioRecorder = nil;
    
    // Init audio with record capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    if(recordEncoding == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    else
    {
        NSNumber *formatObject;
        
        switch (recordEncoding)
        {
            case (ENC_AAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.wav", [Utilities documentsDirectoryPath],audioRecordName]];
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
//    [recordSettings release];
    if ([audioRecorder prepareToRecord] == YES)
    {
        [audioRecorder record];
        return YES;
    }else
    {
        //$$$Yy$$ temp no useable
//        int errorCode = CFSwapInt32HostToBig ([error code]);
//        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        return NO;
    }
}

- (void) stopRecording
{
    NSLog(@"stopRecording");
    [audioRecorder stop];
    isRecording = NO;
    if(timerCount == 0)
        videoLength = 10.0;
    else
        videoLength = timerCount*timerStep;
}

- (void) playRecording:(NSString*)recordName
{
    NSLog(@"playRecording");
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.wav", [Utilities documentsDirectoryPath],audioRecordName]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
}

- (void) stopPlaying
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
}

- (void) pausePlaying
{
    NSLog(@"pausePlaying");
    [audioPlayer pause];
}

#pragma mark - VIDEO RECORDING BUTTONS
- (IBAction)saveVideoButtonTUI:(id)sender
{
    if(!recorded)
    {
        [appDelegate showAlert:@"No record to save." CancelButton:nil OkButton:@"OK" Type:noRecordToSaveAlert Sender:self];

    }else
    {
        [appDelegate showLoadingActivity];
        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/%@.mov",[Utilities documentsDirectoryPath],videoRecordName]];
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
}

- (IBAction)shareVideoButtonTUI:(id)sender
{
    if(!recorded)
    {
        [appDelegate showAlert:@"No record to share." CancelButton:nil OkButton:@"OK" Type:noRecordToShareAlert Sender:self];

    }else
    {
        [self showSharePopup];
    }
}

- (IBAction)sendVideoButtonTUI:(id)sender
{
    if(!recorded)
    {
        [appDelegate showAlert:@"Please record a video file before sending it to your opponent." CancelButton:nil OkButton:@"OK" Type:noRecordToSendAlert Sender:self];
    }else
    {
        if([appDelegate isIPHONE5])
            videoRecordProgressView.frame = CGRectMake(70, 82, 0, videoRecordProgressView.frame.size.height);
        else
            videoRecordProgressView.frame = CGRectMake(70, 23, 0, videoRecordProgressView.frame.size.height);

        [recordTimer invalidate];
        recordTimer = nil;

        [videoPlayerController.moviePlayer pause];
        [videoPlayerController.moviePlayer stop];

        //convert video to nsdata and convert to base64
        [appDelegate showLoadingActivity];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            NSString *videoString = [self avFileToData:[NSString stringWithFormat:@"%@/%@.mov",[Utilities documentsDirectoryPath],videoRecordName]];
            [APIManager setSender:self];
            [APIManager sendGameData:[gameDict objectForKey:@"game_round_id"] Data:videoString Token:appDelegate.userData.token Version:appDelegate.version andTag:sendGameDataRequest];
            dispatch_async(dispatch_get_main_queue(), ^{

            });
        });
    }
}

#pragma mark - VIDEO RECORDING ACTIONS
- (void)captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
//        [alertView release];
    });
}

- (void)captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager
{
}

- (void) captureManagerRecordingFinished:(AVCamCaptureManager *)captureManager VideoURL:(NSURL *)assetURL
{
    //isRecording = NO;
    if(timerCount == 0)
        videoLength = 10.0;
    else
        videoLength = timerCount*timerStep;
    if([Utilities saveVideo:assetURL To:videoRecordName])
    {
        NSLog(@"video saved");
        if(!recordingPause)
            [self addVideoPlayer:videoRecordName From:[Utilities documentsDirectoryPath]];
    }else
    {
        
    }
}

- (void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager
{
}

- (void)captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager
{
}

- (void)videoPlaybackComplete:(NSNotification*)aNotification
{
//    NSLog(@"%d",videoPlayerController.moviePlayer.playbackState);
    
    if(videoPlayerController.moviePlayer.playbackState == MPMoviePlaybackStatePaused || videoPlayerController.moviePlayer.playbackState == MPMoviePlaybackStateStopped)
    {
        [recordTimer invalidate];
        recordTimer = nil;
        videoIsPlaying = NO;
        
        //video
        if(videoPlayerController != nil)
            [videoPlayerController.view removeFromSuperview];
        if(videoPlayerController != nil)
        {
//            [videoPlayerController release];
            videoPlayerController = nil;
        }
        [self addVideoPlayer:videoRecordName From:[Utilities documentsDirectoryPath]];
        
        //[playPauseVideoButton setImage:[UIImage imageNamed:@"play-video-button.png"] forState:UIControlStateNormal];
        [playPauseVideoButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];

        recordVideoButton.hidden = NO;
        
        [recordVideoButton setImage:[Utilities imageWithView:[self recordButtonView:@"RE-RECORD" Icon:@"re-record-icon.png"]] forState:UIControlStateNormal];
        recordVideoButton.hidden = NO;
        recordVideoButton.userInteractionEnabled = YES;
    
        if([appDelegate isIPHONE5])
            videoRecordProgressView.frame = CGRectMake(70, 82, 0, videoRecordProgressView.frame.size.height);
        else
            videoRecordProgressView.frame = CGRectMake(70, 23, 0, videoRecordProgressView.frame.size.height);
    }
}

-(void) videoPlaybackStateChanged:(NSNotification*)aNotification
{
    [appDelegate hideLoadingActivity];
}
- (IBAction)changeCamerasButtonTUI:(id)sender
{
    [[self captureManager] toggleCamera];
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
            case moreCoinsAlert:
            {
                CoinsViewController *coinsViewController = [[CoinsViewController alloc]initWithNibName:@"CoinsViewController" bundle:nil];
                [self presentViewController:coinsViewController animated:YES completion:nil];
//                [coinsViewController release];
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

- (void)animateRecordStatus
{
    
    if(recordType == recordSound)
    {
        if(timerStatusCount < 2)
        {
            [recordAudioButton setImage:[Utilities imageWithView:[self recordButtonView:@"RECORDING" Icon:@"record-icon-on.png"]] forState:UIControlStateNormal];
        }else
        {
            [recordAudioButton setImage:[Utilities imageWithView:[self recordButtonView:@"RECORDING" Icon:@"record-icon-off.png"]] forState:UIControlStateNormal];
        }
    }else
    {
        if(timerStatusCount < 2)
        {
            [recordVideoButton setImage:[Utilities imageWithView:[self recordButtonView:@"RECORDING" Icon:@"record-icon-on.png"]] forState:UIControlStateNormal];
        }else
        {
            [recordVideoButton setImage:[Utilities imageWithView:[self recordButtonView:@"RECORDING" Icon:@"record-icon-off.png"]] forState:UIControlStateNormal];
        }
    }
}

- (void)animateTimerCountdown:(NSNumber*)value
{
    if([appDelegate isIPHONE5])
        videoRecordProgressView.frame = CGRectMake(70, 82,  (videoProgressPXLength/videoLength)*[value intValue]*timerStep, videoRecordProgressView.frame.size.height);
    else
        videoRecordProgressView.frame = CGRectMake(70, 23, (videoProgressPXLength/videoLength)*[value intValue]*timerStep, videoRecordProgressView.frame.size.height);
    NSLog(@"%d frame: %f",[value intValue], (videoProgressPXLength/videoLength)*[value intValue]*timerStep);
}

- (void)animateAudioRecording:(NSNumber*)time
{
    if([time intValue] >= videoLength/timerStep || (!audioRecorder.isRecording && !audioIsPlaying))
    {
        if([appDelegate isIPHONE5])
            audioRecordProgressView.frame = CGRectMake(79, 104, 0, audioRecordProgressView.frame.size.height);
        else
            audioRecordProgressView.frame = CGRectMake(79, 85, 0, audioRecordProgressView.frame.size.height);
    }else
    {
        if([appDelegate isIPHONE5])
            audioRecordProgressView.frame = CGRectMake(79, 104, (audioProgressPXLength/videoLength)*[time intValue]*timerStep, audioRecordProgressView.frame.size.height);
        else
            audioRecordProgressView.frame = CGRectMake(79, 85, (audioProgressPXLength/videoLength)*[time intValue]*timerStep, audioRecordProgressView.frame.size.height);
    }
//        audioRecordProgressView.frame = CGRectMake(audioRecordProgressView.frame.origin.x, audioRecordProgressView.frame.origin.y, (audioProgressPXLength/10)*[time intValue]*timerStep, audioRecordProgressView.frame.size.height);
}

- (UIView*)recordButtonView:(NSString*)text Icon:(NSString*)imageName
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, recordAudioButton.frame.size.width, recordAudioButton.frame.size.height)];
    UIImageView *buttonBgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"record-button-bg.png"]];
    buttonBgIV.frame = buttonView.frame;
    [buttonView addSubview:buttonBgIV];
//    [buttonBgIV release];
    
    UIImageView *buttonIconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    buttonIconIV.frame = CGRectMake(10, (buttonView.frame.size.height-30)/2, 30, 30);
    [buttonView addSubview:buttonIconIV];
//    [buttonIconIV release];
    
    LabelBorder *buttonLabel = [[LabelBorder alloc]initWithFrame:CGRectMake(10+30+10, 0, buttonBgIV.frame.size.width-10-30-10-10, buttonBgIV.frame.size.height) BorderColor:[UIColor whiteColor]];
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.22 alpha:1.0];
    buttonLabel.font = [UIFont fontWithName:@"marvin" size:28];
    buttonLabel.adjustsFontSizeToFitWidth = YES;
    if([appDelegate isIPHONE5])
        buttonLabel.textAlignment = NSTextAlignmentLeft;
    else
        buttonLabel.textAlignment = NSTextAlignmentLeft;
    buttonLabel.text = text;
    [buttonView addSubview:buttonLabel];
//    [buttonLabel release];
    
    return buttonView;
}

- (IBAction)sliderAction:(id)sender
{
    
}


- (IBAction)dismissShareView:(id)sender
{
    [self dismissSharePopup];
}

- (IBAction)shareTypeSelectedTUI:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    NSString *shareData;
    if(recordType == recordSound)
    {
        shareData = [self avFileToData:[NSString stringWithFormat:@"%@/%@.wav",[Utilities documentsDirectoryPath],audioRecordName]];
    }else
    {
        shareData = [self avFileToData:[NSString stringWithFormat:@"%@/%@.mov",[Utilities documentsDirectoryPath],videoRecordName]];
    }
    
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
}

- (NSString*)avFileToData:(NSString*)filename
{
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filename];
    return [Utilities Base64Encode:data];
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
        case sendGameDataRequest:
        {//send game data image/video
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //return to home
                    [Utilities deleteRecordedFile:[NSString stringWithFormat:@"%@.mov",videoRecordName] fron:[Utilities documentsDirectoryPath]];
//                    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
                    
                    // $$$Yy$$ temphide
//                    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                       
                        appDelegate.window.rootViewController = [[HomeViewController alloc] init] ;
                        
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 20)
                    {
                        //invalid game
                        [appDelegate showAlert:[[dict objectForKey:@"response"]objectForKey:@"response"] CancelButton:nil OkButton:@"OK" Type:apiErrorAlert Sender:self];

                    }
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 37)
                    {
                        //data is mising
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

- (void)proceedWithShare:(NSString*)shareString
{
    NSString *shareUrl = [NSString stringWithFormat:@"%@",[Utilities createShareLink:[[gameDict objectForKey:@"game_round_id"]intValue] Owner:YES]];
    
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
            
            [twitter addURL:[NSURL URLWithString:[Utilities shortenURL:shareUrl]]];
            
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
                [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

            };
        }else
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:shareString];
                [tweetSheet setTitle:shareString];
                [tweetSheet addImage:[UIImage imageNamed:@"Icon.png"]];
                [tweetSheet addURL:[NSURL URLWithString:[Utilities shortenURL:shareUrl]]];
                
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
                    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

                };
            }else
            {
                [appDelegate showAlert:@"You have no twitter account. Plese login with your account and try again." CancelButton:nil OkButton:@"OK" Type:-1 Sender:self];
                
                [appDelegate hideLoadingActivity];
            }
        }
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


#pragma mark - Autosave Timer methods
- (void)autosaveTimerCall
{
    [self performSelectorInBackground:@selector(autosaveTimerInterrupt) withObject:nil];
}

- (void) autosaveTimerInterrupt
{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    //check if have to save any recording
//    [pool release];
}

#pragma mark - app notifications
- (void)handleEnteredBackground
{
    if(recordType == recordSound)
    {
        if(isRecording)
        {
            recordingPause = YES;
            [recordTimer invalidate];
            recordTimer = nil;
            recorded = YES;
            
            [recordAudioButton setImage:[Utilities imageWithView:[self recordButtonView:@"RE-RECORD" Icon:@"re-record-icon.png"]] forState:UIControlStateNormal];
            
            recordAudioButton.userInteractionEnabled = YES;
            
            saveAudioButton.userInteractionEnabled = YES;
            shareAudioButton.userInteractionEnabled = YES;
            sendAudioButton.userInteractionEnabled = YES;
            coinsButton.userInteractionEnabled = YES;
            
            playPauseButton.userInteractionEnabled = YES;
            [playPauseButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
            if([appDelegate isIPHONE5])
                audioRecordProgressView.frame = CGRectMake(79, 104, 0, audioRecordProgressView.frame.size.height);
            else
                audioRecordProgressView.frame = CGRectMake(79, 85, 0, audioRecordProgressView.frame.size.height);            [self stopRecording];
            isRecording = NO;
        }
    }else
    {
        if(isRecording)
        {
            recordingPause = YES;
            [recordTimer invalidate];
            recordTimer = nil;
            recorded = YES;
            if([appDelegate isIPHONE5])
                videoRecordProgressView.frame = CGRectMake(70, 82,  0, videoRecordProgressView.frame.size.height);
            else
                videoRecordProgressView.frame = CGRectMake(70, 23, 0, videoRecordProgressView.frame.size.height);
            //isRecording = NO;
        }
    }
}

- (void)handleEnteredForeground
{
    if(recordType == recordSound)
    {
        if(isRecording)
        {
            recordingPause = NO;
            videoLength = timerCount*timerStep;
            
            [recordAudioButton setImage:[Utilities imageWithView:[self recordButtonView:@"RE-RECORD" Icon:@"re-record-icon.png"]] forState:UIControlStateNormal];
            recordAudioButton.userInteractionEnabled = YES;
            
            saveAudioButton.userInteractionEnabled = YES;
            shareAudioButton.userInteractionEnabled = YES;
            sendAudioButton.userInteractionEnabled = YES;
            coinsButton.userInteractionEnabled = YES;
            
            recordAudioButton.hidden = NO;
            [playPauseButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
            playPauseButton.userInteractionEnabled = YES;
        }
    }else
    {
        if(isRecording)
        {
            recordingPause = NO;
            videoLength = timerCount*timerStep;
            
            [recordVideoButton setImage:[Utilities imageWithView:[self recordButtonView:@"RE-RECORD" Icon:@"re-record-icon.png"]] forState:UIControlStateNormal];
            recordVideoButton.userInteractionEnabled = YES;
            
            saveVideoButton.userInteractionEnabled = YES;
            shareVideoButton.userInteractionEnabled = YES;
            sendVideoButton.userInteractionEnabled = YES;
            coinsButton.userInteractionEnabled = YES;
            
            videoPreviewView.hidden = YES;
            videoPlayerView.hidden = NO;
            recordVideoButton.hidden = NO;
            [playPauseVideoButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
            playPauseVideoButton.userInteractionEnabled = YES;
            rotateCameraButton.hidden = YES;
            
            [self addVideoPlayer:videoRecordName From:[Utilities documentsDirectoryPath]];
        }
    }
}

@end
