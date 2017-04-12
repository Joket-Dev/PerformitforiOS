//
//  RecordWordViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 4/25/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <FacebookSDK/FacebookSDK.h>

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>

@class AppDelegate;
@class AVCamCaptureManager, AVCamPreviewView, AVCaptureVideoPreviewLayer;

@interface RecordWordViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    AppDelegate *appDelegate;
    int recordType;
    NSMutableDictionary *gameDict;
    NSTimer *recordTimer;
    BOOL recorded;
    float timerCount;
    int timerStatusCount;
    
    //Audio record/playback
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    int recordEncoding;
    NSString *wordToRecord;
    BOOL audioIsPlaying;
    BOOL videoIsPlaying;
    float videoLength;
    
    NSString *audioRecordName;
    NSString *videoRecordName;

    //
    
    //Video record/playback

    //
    
    NSMutableArray *shareArray;
    NSTimer *autosaveTimer;
    int lastSelectedShareType;
    
    BOOL isRecording;
    BOOL recordingPause;
    BOOL playbackPause;
    BOOL recordingResume;
    BOOL playbackResume;
    
}
@property (nonatomic, strong) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) IBOutlet UIView *recordAudioView;
@property (nonatomic, strong) IBOutlet UIView *recordVideoView;
@property (nonatomic, strong) UIButton *coinsButton;

//audio
@property (nonatomic, strong) IBOutlet UIImageView *audioBgIV;

@property (nonatomic, strong) IBOutlet UIButton *saveAudioButton;
@property (nonatomic, strong) IBOutlet UIButton *sendAudioButton;
@property (nonatomic, strong) IBOutlet UIButton *shareAudioButton;
@property (nonatomic, strong) IBOutlet UIView *audioRecordProgressView;
@property (nonatomic, strong) IBOutlet UIButton *playPauseButton;
@property (nonatomic, strong) IBOutlet UIButton *recordAudioButton;
@property (nonatomic, strong) IBOutlet UIView *soundFxPopupView;
@property (nonatomic, strong) IBOutlet UIButton *soundFxButton;
@property (nonatomic, strong) IBOutlet UIButton *closeSoundFxButton;

//

//video
@property (nonatomic, strong) IBOutlet UIImageView *videoBgIV;

@property (nonatomic, strong) AVCamCaptureManager *captureManager;
@property (nonatomic, strong) IBOutlet UIView *videoPreviewView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) IBOutlet UIView *videoPlayerView;
@property (nonatomic, strong) MPMoviePlayerViewController *videoPlayerController;

@property (nonatomic, strong) IBOutlet UIButton *saveVideoButton;
@property (nonatomic, strong) IBOutlet UIButton *sendVideoButton;
@property (nonatomic, strong) IBOutlet UIButton *shareVideoButton;
@property (nonatomic, strong) IBOutlet UIButton *recordVideoButton;
@property (nonatomic, strong) IBOutlet UIButton *playPauseVideoButton;
@property (nonatomic, strong) IBOutlet UIButton *rotateCameraButton;
@property (nonatomic, strong) IBOutlet UIView *videoRecordProgressView;


//share
@property (nonatomic, strong) IBOutlet UIView *shareView;
@property (nonatomic, strong) IBOutlet UIView *sharePopupView;
@property (nonatomic, strong) IBOutlet UIScrollView *shareScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil RecordType:(int)record_type GameData:(NSMutableDictionary*)game_dict;

//
- (IBAction)homeButtonTUI:(id)sender;
- (IBAction)recordButtonTUI:(id)sender;

- (IBAction)audioPlayPauseButtonTUI:(id)sender;
- (IBAction)videoPlayPauseButtonTUI:(id)sender;

//audio record/play methods
- (BOOL) startRecording:(NSString*)recordName;
- (void) stopRecording;
- (void) playRecording:(NSString*)recordName;
- (void) stopPlaying;
- (void)saveAudioRecordingToGallery:(NSString*)path;


- (IBAction)saveAudioButtonTUI:(id)sender;
- (IBAction)shareAudioButtonTUI:(id)sender;
- (IBAction)sendAudioButtonTUI:(id)sender;

//


@end
