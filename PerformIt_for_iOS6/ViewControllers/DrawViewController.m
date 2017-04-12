//
//  DrawViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/15/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "DrawViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "Utilities.h"
#import "LabelBorder.h"
#include <math.h>
#include "JSON.h"


// Padding for margins
#define kLeftMargin				10.0
#define kTopMargin				10.0
#define kRightMargin			10.0

#define minBrushSize 2//1px
#define maxBrushSize 7//64px

#define timerStep 0.1

#define kkNoShare 0
#define kkFacebookShare 1
#define kkTwitterShare 2

@interface DrawViewController ()

@end

@implementation DrawViewController
@synthesize backgroundIV;
@synthesize backButton;
@synthesize saveDrawingButton;
@synthesize sendDrawingButton;
@synthesize shareDrawingButton;
@synthesize undoButton;
@synthesize clearButton;
@synthesize drawingView;
@synthesize toolboxScrollView;
@synthesize colorPopupView, brushPopupView;
@synthesize colorsScrollView, brushesScrollView;
@synthesize brushSizeSlider;
@synthesize brushPreviewView;
@synthesize dismissPopupButton;
@synthesize bgColorPopupView;
@synthesize bgColorsScrollView;
@synthesize addMoreButton;
@synthesize leftArrowIV, rightArrowIV;
@synthesize addMorePopupView;
@synthesize addMoreScrollView;
@synthesize dismissAddMorePopupButton;

@synthesize shareView, sharePopupView, shareScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil GameData:(NSMutableDictionary*)game_dict
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
        backgroundIV.image = [UIImage imageNamed:@"draw-bg-568h@2x.png"];
        backgroundIV.frame = CGRectMake(0, 0, appDelegate.screenWidth, appDelegate.screenHeight);
        //tbl.frame = CGRectMake(tbl.frame.origin.x, tbl.frame.origin.y, tbl.frame.size.width, tbl.frame.size.height-10);
        toolboxScrollView.frame = CGRectMake(toolboxScrollView.frame.origin.x-50, toolboxScrollView.frame.origin.y+60, toolboxScrollView.frame.size.width+60, toolboxScrollView.frame.size.height);
        addMoreButton.frame = CGRectMake(addMoreButton.frame.origin.x, addMoreButton.frame.origin.y+60, addMoreButton.frame.size.width, addMoreButton.frame.size.height);
        backButton.frame = CGRectMake(268, 10, backButton.frame.size.width, backButton.frame.size.height);
        leftArrowIV.frame = CGRectMake(leftArrowIV.frame.origin.x-50, leftArrowIV.frame.origin.y+60, leftArrowIV.frame.size.width, leftArrowIV.frame.size.height);
        rightArrowIV.frame = CGRectMake(rightArrowIV.frame.origin.x, rightArrowIV.frame.origin.y+60, rightArrowIV.frame.size.width, rightArrowIV.frame.size.height);

        undoButton.frame = CGRectMake(undoButton.frame.origin.x, undoButton.frame.origin.y+60, undoButton.frame.size.width, undoButton.frame.size.height);
        clearButton.frame = CGRectMake(clearButton.frame.origin.x, clearButton.frame.origin.y+60, clearButton.frame.size.width, clearButton.frame.size.height);
        saveDrawingButton.frame = CGRectMake(saveDrawingButton.frame.origin.x, saveDrawingButton.frame.origin.y+60, undoButton.frame.size.width, saveDrawingButton.frame.size.height);
        shareDrawingButton.frame = CGRectMake(shareDrawingButton.frame.origin.x, shareDrawingButton.frame.origin.y+60, shareDrawingButton.frame.size.width, shareDrawingButton.frame.size.height);
        sendDrawingButton.frame = CGRectMake(sendDrawingButton.frame.origin.x, sendDrawingButton.frame.origin.y+60, sendDrawingButton.frame.size.width, sendDrawingButton.frame.size.height);
        
        drawingView.frame = CGRectMake(drawingView.frame.origin.x, drawingView.frame.origin.y+60-1, drawingView.frame.size.width, drawingView.frame.size.height);
        
        colorPopupView.frame = CGRectMake(colorPopupView.frame.origin.x, colorPopupView.frame.origin.y+60, colorPopupView.frame.size.width, colorPopupView.frame.size.height);

        brushPopupView.frame = CGRectMake(brushPopupView.frame.origin.x, brushPopupView.frame.origin.y+60, brushPopupView.frame.size.width, brushPopupView.frame.size.height);

        addMorePopupView.frame = CGRectMake(addMorePopupView.frame.origin.x, addMorePopupView.frame.origin.y, addMorePopupView.frame.size.width, addMorePopupView.frame.size.height);
    }
    dismissAddMorePopupButton.hidden = YES;
    addMorePopupView.hidden = YES;
    
    //init toolbox
    toolboxScrollView.delegate = self;
    toolboxScrollView.showsHorizontalScrollIndicator = NO;
    toolboxScrollView.showsVerticalScrollIndicator = NO;
    toolboxScrollView.scrollEnabled = YES;
    
    colorsScrollView.delegate = self;
    colorsScrollView.showsHorizontalScrollIndicator = NO;
    colorsScrollView.showsVerticalScrollIndicator = NO;
    colorsScrollView.scrollEnabled = YES;
    
    brushesScrollView.delegate = self;
    brushesScrollView.showsHorizontalScrollIndicator = NO;
    brushesScrollView.showsVerticalScrollIndicator = NO;
    brushesScrollView.scrollEnabled = YES;
    
    bgColorsScrollView.delegate = self;
    bgColorsScrollView.showsHorizontalScrollIndicator = NO;
    bgColorsScrollView.showsVerticalScrollIndicator = NO;
    bgColorsScrollView.scrollEnabled = YES;
    
    shareScrollView.delegate = self;
    shareScrollView.showsHorizontalScrollIndicator = NO;
    shareScrollView.showsVerticalScrollIndicator = NO;
    shareScrollView.scrollEnabled = YES;
    
    undoButton.enabled = NO;
    
    lastSelectedTool = noTool;
    selectedColorIndex = 0;
    selectedBrushIndex = 0;
    selectedBrushSize = minBrushSize;
    selectedBgColorIndex = 0;
    selectedEraseBrushIndex = 0;
    selectedEraseBrushSize = minBrushSize;
    
    //add tools to scrollview
    int xOffset = 6.5;
    for (int i = 0; i < 3; i++)
    {
        UIButton *toolButton = [[UIButton alloc]initWithFrame:CGRectMake(xOffset, 0, 46, 42)];
        toolButton.exclusiveTouch = YES;
        toolButton.backgroundColor = [UIColor clearColor];
        if(i == 0)
        {
            toolButton.tag = colorTool;
            [toolButton setImage:[UIImage imageNamed:@"color-button.png"] forState:UIControlStateNormal];
        }
        if(i == 1)
        {
            toolButton.tag = brushTool;
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 46, 42)];
            UIImageView *toolIV = [[UIImageView alloc]initWithFrame:bgView.frame];
            toolIV.image = [UIImage imageNamed:@"brush-button.png"];
            [bgView addSubview:toolIV];
//            [toolIV release];
            UIImageView *highlightIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toolbox-button-higlight.png"]];
            highlightIV.frame = bgView.frame;
            [bgView addSubview:highlightIV];
//            [highlightIV release];
            [toolButton setImage:[Utilities imageWithView:bgView] forState:UIControlStateNormal];
//            [bgView release];
        }
        if(i == 2)
        {
            toolButton.tag = eraseTool;
            [toolButton setImage:[UIImage imageNamed:@"erase-button.png"] forState:UIControlStateNormal];
        }
        [toolButton addTarget:self action:@selector(toolButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
        [toolboxScrollView addSubview:toolButton];
//        [toolButton release];
        xOffset = xOffset + 46 + 6.5;
    }
    toolboxScrollView.contentSize = CGSizeMake(xOffset, 42);
    
    //add colors to scrollview
    colorPopupView.hidden = YES;
    colorsArray = [[NSMutableArray alloc]init];
    //[colorsArray setArray:[Utilities generateAllColors]];
    //[self addColorsToTools:colorsArray];
    
    //add brushes to scrollview
    brushPopupView.hidden = YES;
    brushArray = [[NSMutableArray alloc]init];
    //[self addBrushesToTools:brushArray];
    
    //init brush size slider
    [brushSizeSlider setMinimumValue:minBrushSize];
    [brushSizeSlider setMaximumValue:maxBrushSize];
    [brushSizeSlider setValue:minBrushSize];
    
    //init background color popup
    bgColorPopupView.hidden = YES;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(changeBgColor:)];
    longPressGestureRecognizer.minimumPressDuration = 1.0;
    longPressGestureRecognizer.enabled = YES;
    longPressGestureRecognizer.delegate = self;
    [drawingView addGestureRecognizer:longPressGestureRecognizer];
    
//    TouchDownGestureRecognizer *touchDown = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchDown:)];
//    touchDown.delegate = self;
//    [drawingView addGestureRecognizer:touchDown];
    dismissPopupButton.hidden = YES;
    
    path = [[NSMutableArray alloc]init];
    
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
    xOffset = 5;
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
    
    saveDrawingButton.exclusiveTouch = YES;
    sendDrawingButton.exclusiveTouch = YES;
    shareDrawingButton.exclusiveTouch = YES;
    undoButton.exclusiveTouch = YES;
    clearButton.exclusiveTouch = YES;
    addMoreButton.exclusiveTouch = YES;
    
    //init packets
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
    [self addPackages:appDelegate.inAppPacketsArray];
    [self iniToolbar:appDelegate.inAppPacketsArray];
    [self initDrawingView];
    
    backButton.hidden = NO;
    firstTouch = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [appDelegate setRecording:YES];
    lastSelectedShareType = kkNoShare;
}

- (void)viewDidAppear:(BOOL)animated
{
    //get purchased packages
    
    [appDelegate showLoadingActivity];
    [APIManager setSender:self];
    [APIManager getPurchasablePackets:appDelegate.userData.token Version:appDelegate.version andTag:packetsRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (void)dealloc
//{
//    [backgroundIV release];
//    [backButton release];
//    [saveDrawingButton release];
//    [sendDrawingButton release];
//    [shareDrawingButton release];
//    [undoButton release];
//    [clearButton release];
//    [addMoreButton release];
//    [toolboxScrollView release];
//    [colorPopupView release];
//    [brushPopupView release];
//    [colorsScrollView release];
//    [brushesScrollView release];
//    [brushSizeSlider release];
//    [brushPreviewView release];
//    [dismissPopupButton release];
//    [bgColorPopupView release];
//    [bgColorsScrollView release];
//    [leftArrowIV release];
//    [rightArrowIV release];
//    [shareView release];
//    [sharePopupView release];
//    [shareScrollView release];
//    [addMorePopupView release];
//    [addMoreScrollView release];
//    [dismissAddMorePopupButton release];
//    [drawingView release];
//    [super dealloc];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [APIManager cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Interface Action Buttons
- (IBAction)homeButtonTUI:(id)sender
{
//    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveDrawingButtonTUI:(id)sender
{
    if([drawingView.recordedPath count] > 0)
        drawed = YES;
    if(!drawed)
    {
        [appDelegate showAlert:@"No drawing to save" CancelButton:nil OkButton:@"OK" Type:noRecordToSaveAlert Sender:self];
    }else
    {
        [appDelegate showLoadingActivity];
       	UIImage *image = [drawingView imageRepresentation];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[image CGImage]
                                  orientation:(ALAssetOrientation)[image imageOrientation]
                              completionBlock:^(NSURL *assetURL, NSError *error)
         {
             NSLog(@"%@",error.localizedDescription);
             [appDelegate hideLoadingActivity];
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

- (IBAction)shareDrawingoButtonTUI:(id)sender
{
    if([drawingView.recordedPath count] > 0)
        drawed = YES;
    if(!drawed)
    {
        [appDelegate showAlert:@"No drawing to share" CancelButton:nil OkButton:@"OK" Type:noRecordToShareAlert Sender:self];
    }else
    {
        [self showSharePopup];
    }
}

- (IBAction)sendDrawingButtonTUI:(id)sender
{
    if([drawingView.recordedPath count] > 0)
        drawed = YES;
    if(!drawed)
    {
        [appDelegate showAlert:@"Please draw the hint before sending it to your opponent." CancelButton:nil OkButton:@"OK" Type:noRecordToSendAlert Sender:self];
    }else
    {
        //api call and return to home screen
        
        //bg color as last items
        [drawingView.recordedPath addObject:[colorsArray objectAtIndex:selectedBgColorIndex]];
        
        [appDelegate showLoadingActivity];
//        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(concurrentQueue, ^{

//        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:drawingView.recordedPath];
//        NSError *error = nil;
        
        NSMutableArray * tempPath = [NSMutableArray arrayWithArray:drawingView.recordedPath];
        NSMutableDictionary * dicPath = [[NSMutableDictionary alloc] init];
        NSMutableArray * aryLine = [[NSMutableArray alloc] init];
        BOOL  isPhone5 = [appDelegate isIPHONE5];
        float  height = isPhone5 ? 360 : 305;
        for ( id ary in tempPath ) {
            if ( [ary isKindOfClass:[NSMutableArray class]] ) {
                for ( NSMutableDictionary * dic in ary ) {
                    
                    CGPoint  point = [[dic objectForKey:@"point"] CGPointValue];
                    point.y = 1.0f - point.y / height;
                    point.x = point.x / 312;
//                    NSValue * value = [dic objectForKey:@"point"];
                    NSValue * value = [NSValue valueWithCGPoint:point];
                    [dic setObject:[NSString stringWithFormat:@"%@", value] forKey:@"point"];
                    
                }
                [aryLine addObject:ary];
            } else {
                [dicPath setObject:ary forKey:@"background"];
            }
        }
        [dicPath setObject:aryLine forKey:@"lines"];
        
//        NSData *jsonData = [NSJSONSerialization
//                            dataWithJSONObject:drawingView.recordedPath
//                            options:NSJSONWritingPrettyPrinted
//                            error:&error];
//        NSString * jsonString = nil;
//        if ([jsonData length] > 0 &&
//            error == nil){
//            NSLog(@"Successfully serialized the dictionary into data.");
//            jsonString = [[NSString alloc] initWithData:jsonData
//                                                         encoding:NSUTF8StringEncoding];
//            NSLog(@"JSON String = %@", jsonString);
//        }
//        else if ([jsonData length] == 0 &&
//                 error == nil){
//            NSLog(@"No data was returned after serialization.");
//        }
//        else if (error != nil){
//            NSLog(@"An error happened = %@", error);
//        }
        
        
        
//            NSString *dataString = [Utilities Base64Encode:jsonData];//[arrayData base64EncodedString];//[Utilities base64Encode:arrayData];
        NSString * dataString = [dicPath JSONRepresentation];
            [APIManager setSender:self];
        
            [APIManager sendGameData:[gameDict objectForKey:@"game_round_id"] Data:dataString Token:appDelegate.userData.token Version:appDelegate.version andTag:sendGameDataRequest];
//            dispatch_async(dispatch_get_main_queue(), ^{
//            });
//        });
    }
}

- (void)returnToHome
{
    [appDelegate hideLoadingActivity];
//    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addMoreButtonTUI:(id)sender
{
    NSInteger k = [appDelegate.inAppPacketsArray count];
    for (int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
    {
        if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"purchased"]boolValue])
            k--;
    }
    if(k > 0)
        [self showAddMorePopup];
    else
    {
        [appDelegate showAlert:@"You have all purchasable items." CancelButton:nil OkButton:@"OK" Type:noPurchasesAvailableAlert Sender:self];
    }
}

- (IBAction)closeAddMoreButtonTUI:(id)sender
{
    [self dismissAddMorePopup];
}

- (IBAction)undoButtonTUI:(id)sender
{
    undoAvailable = NO;
    undoButton.enabled = NO;
    if([drawingView.recordedPath count] > 0)
    {
        [drawingView.recordedPath removeObjectAtIndex:[drawingView.recordedPath count]-1];
        [appDelegate showLoadingActivity];
        [drawingView eraseAllLines:YES];
        [appDelegate setReDrawInPRogress:YES];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(concurrentQueue, ^{
            [drawingView playRecordedPath:drawingView.recordedPath Instant:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate hideLoadingActivity];
                [appDelegate setReDrawInPRogress:NO];
            });
        });
    }else
    {
        drawed = NO;
    }
}

- (IBAction)clearButtonTUI:(id)sender
{
    undoAvailable = NO;
    undoButton.enabled = NO;
    
    drawed = NO;
    [drawingView.recordedPath removeAllObjects];
    [drawingView eraseAllLines:NO];
}

- (void)changeBgColor:(id)sender
{
    //check if bg color purchased
    for ( int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
    {
        if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == kBackgroundColorPackage &&
           [[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"purchased"]boolValue])
        {
            if([bgColorPopupView isHidden])
                [self showBgColorsPopup];
            break;
        }
    }
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

-(void)handleTouchDown:(TouchDownGestureRecognizer *)touchDown
{
    if(firstTouch)
    {
        NSLog(@"%@",drawingView.gestureRecognizers);
        for (TouchDownGestureRecognizer *recognizer in drawingView.gestureRecognizers)
        {
            if([recognizer isKindOfClass:[TouchDownGestureRecognizer class]])
                [drawingView removeGestureRecognizer:recognizer];
        }
        firstTouch = NO;
    }
}

#pragma mark - Drawing Delegate
- (void)linedrawed
{
    if([drawingView.recordedPath count] > 0)
    {
        undoAvailable = YES;
        undoButton.enabled = YES;
    }
}

#pragma mark - Alert Delegates
- (void)alertOkBtnTUI:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        appDelegate.alertDialog.alpha = 0.0;
    }completion:^(BOOL finished) {
        [appDelegate.alertDialog removeFromSuperview];
        switch ([sender tag]) {
            case drawTimeAlert:
            {
                [self sendDrawingButtonTUI:self];
            }
                break;
            case apiErrorAlert:
            {
//                [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
//                [self dismissViewControllerAnimated:YES completion:nil];
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
                    [appDelegate showAlert:@"You dont have enough coins to purchase this item. " CancelButton:nil OkButton:@"OK" Type:noCoinsAlert Sender:self];
            }
                break;
            case gameIsDeletedAlert:
            {
//                [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
//                [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];

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
            case buyItemAlert:
            {
                //
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

#pragma mark - Popup show/dismiss

- (void) showAddMorePopup
{
    addMorePopupView.hidden = NO;
    dismissAddMorePopupButton.hidden = NO;
    addMorePopupView.userInteractionEnabled = NO;
    dismissAddMorePopupButton.hidden = NO;
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
    int yOffset = addMorePopupView.frame.origin.y;
    int popupSize = addMorePopupView.frame.size.height;

    dismissAddMorePopupButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        addMorePopupView.frame = CGRectMake(addMorePopupView.center.x, addMorePopupView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         addMorePopupView.userInteractionEnabled = YES;
         addMorePopupView.hidden = YES;
         dismissAddMorePopupButton.hidden = NO;
         //dismissAddMorePopupButton.userInteractionEnabled = YES;
         addMorePopupView.frame = CGRectMake(25, yOffset, 270, popupSize);
     }];
}

- (void)showColorsPopup
{
    brushPopupView.hidden = YES;
    colorPopupView.hidden = NO;
    dismissPopupButton.tag = colorTool;
    dismissPopupButton.hidden = NO;
    int yOffset = 0;
    if([appDelegate isIPHONE5])
        yOffset = 60;
    colorPopupView.frame = CGRectMake(colorPopupView.frame.origin.x, 2+yOffset, colorPopupView.frame.size.width, colorPopupView.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        colorPopupView.frame = CGRectMake(colorPopupView.frame.origin.x, 2+yOffset+colorPopupView.frame.size.height-10, colorPopupView.frame.size.width, colorPopupView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissColorsPopup
{
    [UIView animateWithDuration:0.2 animations:^{
        colorPopupView.frame = CGRectMake(colorPopupView.frame.origin.x, 48, colorPopupView.frame.size.width, colorPopupView.frame.size.height);
    } completion:^(BOOL finished)
     {
         colorPopupView.hidden = YES;
         dismissPopupButton.hidden = YES;
         [self showPopup:lastSelectedTool];
     }];
}

- (void)showBrushPopup:(BOOL)erase
{
    brushPopupView.hidden = NO;
    colorPopupView.hidden = YES;
    dismissPopupButton.hidden = NO;
    if(erase)
    {
        [drawingView setIsErased:YES];
        [drawingView setBrushColor:[colorsArray objectAtIndex:selectedBgColorIndex]];
        
        dismissPopupButton.tag = eraseTool;
    }else
    {
        [drawingView setIsErased:NO];
        [drawingView setBrushColor:[colorsArray objectAtIndex:selectedColorIndex]];
        dismissPopupButton.tag = brushTool;
    }
    int yOffset = 0;
    if([appDelegate isIPHONE5])
        yOffset = 60;
    brushPopupView.frame = CGRectMake(brushPopupView.frame.origin.x, -40+yOffset, brushPopupView.frame.size.width, brushPopupView.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        brushPopupView.frame = CGRectMake(brushPopupView.frame.origin.x, -40+yOffset+brushPopupView.frame.size.height-10, brushPopupView.frame.size.width, brushPopupView.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissBrushPopup:(BOOL)erase
{
    [UIView animateWithDuration:0.2 animations:^{
        brushPopupView.frame = CGRectMake(brushPopupView.frame.origin.x, 8, brushPopupView.frame.size.width, brushPopupView.frame.size.height);
    } completion:^(BOOL finished)
     {
         brushPopupView.hidden = YES;
         dismissPopupButton.hidden = YES;
         [self showPopup:lastSelectedTool];
     }];
}


- (void)showBgColorsPopup
{
    drawingView.userInteractionEnabled = NO;
    dismissPopupButton.tag = bgTool;
    dismissPopupButton.hidden = NO;
    bgColorPopupView.userInteractionEnabled = NO;
    bgColorPopupView.hidden = NO;
    bgColorPopupView.frame = CGRectMake(bgColorPopupView.center.x, bgColorPopupView.center.y, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        bgColorPopupView.frame = CGRectMake(40, 190, 238, 120);
    } completion:^(BOOL finished) {
        bgColorPopupView.userInteractionEnabled = YES;
        drawingView.userInteractionEnabled = YES;
    }];
}

- (void)dismissBgColorsPopup
{
    drawingView.userInteractionEnabled = NO;
    bgColorPopupView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        bgColorPopupView.frame = CGRectMake(bgColorPopupView.center.x, bgColorPopupView.center.y, 0, 0);
    } completion:^(BOOL finished)
     {
         bgColorPopupView.userInteractionEnabled = YES;
         bgColorPopupView.hidden = YES;
         dismissPopupButton.hidden = YES;
         drawingView.userInteractionEnabled = YES;
     }];
    
}

- (void)showPopup:(int)tool_type
{
    switch (tool_type)
    {
        case colorTool:
        {
            [self showColorsPopup];
        }
            break;
        case brushTool:
        {
            [self showBrushPopup:NO];
        }
            break;
        case eraseTool:
        {
            [self showBrushPopup:YES];
        }
            break;
        default:
            break;
    }
}

- (IBAction)dismissPopup:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag)
    {
        case colorTool:
        {
            [self highlightSelectedTool:brushTool];
            [self dismissColorsPopup];
            lastSelectedTool = noTool;
        }
            break;
        case brushTool:
        {
            [self dismissBrushPopup:NO];
            lastSelectedTool = noTool;
        }
            break;
        case eraseTool:
        {
            [self dismissBrushPopup:YES];
            lastSelectedTool = noTool;
        }
            break;
        case bgTool:
        {
            [self dismissBgColorsPopup];
            lastSelectedTool = noTool;
        }
            break;
        default:
            break;
    }
    
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

- (void)highlightSelectedItem:(int)tool_type
{
    switch (tool_type)
    {
        case colorTool:
        {
            for (int i = 0; i < [[colorsScrollView subviews]count]; i++)
            {
                UIButton *itemButton = (UIButton*)[[colorsScrollView subviews]objectAtIndex:i];
                if(itemButton.tag == selectedColorIndex)
                {
                    //enable highlight
                    UIView *itemBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, itemButton.frame.size.width, itemButton.frame.size.height)];
                    itemBgView.layer.cornerRadius = 3;
                    
                    UIImageView *colorShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 37)];
                    colorShadow.image = [UIImage imageNamed:@"color-shadow.png"];
                    [itemBgView addSubview:colorShadow];
//                    [colorShadow release];
                    
                    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(colorShadow.frame.origin.x+7, colorShadow.frame.origin.y+7, colorShadow.frame.size.width-2*7, colorShadow.frame.size.height-2*7)];
                    colorView.backgroundColor = [Utilities colorFromDict:[colorsArray objectAtIndex:i]];
                    colorView.layer.cornerRadius = 5;
                    [itemBgView addSubview:colorView];
//                    [colorView release];
                    
                    UIImageView *highlightIV = [[UIImageView alloc]initWithFrame:itemBgView.frame];
                    highlightIV.image = [UIImage imageNamed:@"toolbox-button-higlight.png"];
                    [itemBgView addSubview:highlightIV];
//                    [highlightIV release];
                    [itemButton setImage:[Utilities imageWithView:itemBgView] forState:UIControlStateNormal];
//                    [itemBgView release];
                }else
                {
                    //disable highligh
                    UIView *itemBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, itemButton.frame.size.width, itemButton.frame.size.height)];
                    UIImageView *colorShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 37)];
                    colorShadow.image = [UIImage imageNamed:@"color-shadow.png"];
                    [itemBgView addSubview:colorShadow];
//                    [colorShadow release];
                    
                    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(colorShadow.frame.origin.x+7, colorShadow.frame.origin.y+7, colorShadow.frame.size.width-2*7, colorShadow.frame.size.height-2*7)];
                    colorView.backgroundColor = [Utilities colorFromDict:[colorsArray objectAtIndex:i]];
                    colorView.layer.cornerRadius = 5;
                    [itemBgView addSubview:colorView];
//                    [colorView release];
                    
                    [itemButton setImage:[Utilities imageWithView:itemBgView] forState:UIControlStateNormal];
//                    [itemBgView release];
                }
            }
        }
            break;
        case brushTool:
        {
            for (int i = 0; i < [[brushesScrollView subviews]count]; i++)
            {
                UIButton *itemButton = (UIButton*)[[brushesScrollView subviews]objectAtIndex:i];
                if(itemButton.tag == selectedBrushIndex)
                {
                    UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, itemButton.frame.size.width, itemButton.frame.size.height)];
                    
                    UIImageView *brushShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 37)];
                    brushShadow.image = [UIImage imageNamed:@"color-shadow.png"];
                    [itemView addSubview:brushShadow];
//                    [brushShadow release];
                    
                    UIImageView *brush = [[UIImageView alloc]initWithFrame:CGRectMake(brushShadow.frame.origin.x+7, brushShadow.frame.origin.y+7, brushShadow.frame.size.width-2*7, brushShadow.frame.size.height-2*7)];
                    brush.image = [Utilities negativeImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-preview.png",[[brushArray objectAtIndex:i] stringByDeletingPathExtension]]]];
                    [itemView addSubview:brush];
//                    [brush release];
                    
                    UIImageView *highlightIV = [[UIImageView alloc]initWithFrame:itemView.frame];
                    highlightIV.image = [UIImage imageNamed:@"toolbox-button-higlight.png"];
                    [itemView addSubview:highlightIV];
//                    [highlightIV release];
                    
                    [itemButton setImage:[Utilities imageWithView:itemView] forState:UIControlStateNormal];
//                    [itemView release];
                }else
                {
                    //disable highligh
                    UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, itemButton.frame.size.width, itemButton.frame.size.height)];

                    UIImageView *brushShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 37)];
                    brushShadow.image = [UIImage imageNamed:@"color-shadow.png"];
                    [itemView addSubview:brushShadow];
//                    [brushShadow release];
                    
                    UIImageView *brush = [[UIImageView alloc]initWithFrame:CGRectMake(brushShadow.frame.origin.x+7, brushShadow.frame.origin.y+7, brushShadow.frame.size.width-2*7, brushShadow.frame.size.height-2*7)];
                    brush.image = [Utilities negativeImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-preview.png",[[brushArray objectAtIndex:i] stringByDeletingPathExtension]]]];
                    [itemView addSubview:brush];
//                    [brush release];

                    
                    [itemButton setImage:[Utilities imageWithView:itemView] forState:UIControlStateNormal];
//                    [itemView release];
                }
            }
        }
            break;
        case eraseTool:
        {
            for (int i = 0; i < [[brushesScrollView subviews]count]; i++)
            {
                UIButton *itemButton = (UIButton*)[[brushesScrollView subviews]objectAtIndex:i];
                if(itemButton.tag == selectedEraseBrushIndex)
                {
                    UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, itemButton.frame.size.width, itemButton.frame.size.height)];
                    
                    UIImageView *brushShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 37)];
                    brushShadow.image = [UIImage imageNamed:@"color-shadow.png"];
                    [itemView addSubview:brushShadow];
//                    [brushShadow release];
                    
                    UIImageView *brush = [[UIImageView alloc]initWithFrame:CGRectMake(brushShadow.frame.origin.x+7, brushShadow.frame.origin.y+7, brushShadow.frame.size.width-2*7, brushShadow.frame.size.height-2*7)];
                    brush.image = [Utilities negativeImage:[UIImage imageNamed:[brushArray objectAtIndex:i]]];
                    [itemView addSubview:brush];
//                    [brush release];
                    
                    UIImageView *highlightIV = [[UIImageView alloc]initWithFrame:itemView.frame];
                    highlightIV.image = [UIImage imageNamed:@"toolbox-button-higlight.png"];
                    [itemView addSubview:highlightIV];
//                    [highlightIV release];
                    
                    [itemButton setImage:[Utilities imageWithView:itemView] forState:UIControlStateNormal];
//                    [itemView release];
                }else
                {
                    //disable highligh
                    UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, itemButton.frame.size.width, itemButton.frame.size.height)];
                  
                    UIImageView *brushShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 37)];
                    brushShadow.image = [UIImage imageNamed:@"color-shadow.png"];
                    [itemView addSubview:brushShadow];
//                    [brushShadow release];
                    
                    UIImageView *brush = [[UIImageView alloc]initWithFrame:CGRectMake(brushShadow.frame.origin.x+7, brushShadow.frame.origin.y+7, brushShadow.frame.size.width-2*7, brushShadow.frame.size.height-2*7)];
                    brush.image = [Utilities negativeImage:[UIImage imageNamed:[brushArray objectAtIndex:i]]];
                    [itemView addSubview:brush];
//                    [brush release];
                    
                    UIImageView *highlightIV = [[UIImageView alloc]initWithFrame:itemView.frame];
                    highlightIV.image = [UIImage imageNamed:@"toolbox-button-higlight.png"];
                    [itemView addSubview:highlightIV];
//                    [highlightIV release];
                    
                    [itemButton setImage:[Utilities imageWithView:itemView] forState:UIControlStateNormal];
//                    [itemView release];
                }
            }
        }
            break;
        case bgTool:
        {
            for (int i = 0; i < [[bgColorsScrollView subviews]count]; i++)
            {
                UIButton *itemButton = (UIButton*)[[bgColorsScrollView subviews]objectAtIndex:i];
                if(itemButton.tag == selectedBgColorIndex)
                {
                    //enable highlight
                    UIView *itemBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, itemButton.frame.size.width, itemButton.frame.size.height)];

                    UIImageView *colorShadow = [[UIImageView alloc]initWithFrame:CGRectMake((itemButton.frame.size.width-36)/2, (itemButton.frame.size.height-37)/2, 36, 37)];
                    colorShadow.image = [UIImage imageNamed:@"color-shadow.png"];
                    [itemBgView addSubview:colorShadow];
//                    [colorShadow release];
                    
                    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(colorShadow.frame.origin.x+7, colorShadow.frame.origin.y+7, colorShadow.frame.size.width-2*7, colorShadow.frame.size.height-2*7)];
                    colorView.backgroundColor = [Utilities colorFromDict:[colorsArray objectAtIndex:i]];
                    colorView.layer.cornerRadius = 5;
                    [itemBgView addSubview:colorView];
//                    [colorView release];
                    
                    UIImageView *highlightIV = [[UIImageView alloc]initWithFrame:itemBgView.frame];
                    highlightIV.image = [UIImage imageNamed:@"toolbox-button-higlight.png"];
                    [itemBgView addSubview:highlightIV];
//                    [highlightIV release];
                    [itemButton setImage:[Utilities imageWithView:itemBgView] forState:UIControlStateNormal];
//                    [itemBgView release];
                }else
                {
                    //disable highligh
                    UIView *itemBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, itemButton.frame.size.width, itemButton.frame.size.height)];

                    UIImageView *colorShadow = [[UIImageView alloc]initWithFrame:CGRectMake((itemButton.frame.size.width-36)/2, (itemButton.frame.size.height-37)/2, 36, 37)];
                    colorShadow.image = [UIImage imageNamed:@"color-shadow.png"];
                    [itemBgView addSubview:colorShadow];
//                    [colorShadow release];
                    
                    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(colorShadow.frame.origin.x+7, colorShadow.frame.origin.y+7, colorShadow.frame.size.width-2*7, colorShadow.frame.size.height-2*7)];
                    colorView.backgroundColor = [Utilities colorFromDict:[colorsArray objectAtIndex:i]];
                    colorView.layer.cornerRadius = 5;
                    [itemBgView addSubview:colorView];
//                    [colorView release];
                    
                    [itemButton setImage:[Utilities imageWithView:itemBgView] forState:UIControlStateNormal];
//                    [itemBgView release];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)highlightSelectedTool:(int)tool_type
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 46, 42)];
    UIImageView *highlightIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"toolbox-button-higlight.png"]];
    highlightIV.frame = bgView.frame;
    [bgView addSubview:highlightIV];
//    [highlightIV release];
    UIImageView *toolIV = [[UIImageView alloc]initWithFrame:bgView.frame];
    [bgView addSubview:toolIV];
//    [toolIV release];
    
    switch (tool_type)
    {
        case colorTool:
        {
            toolIV.image = [UIImage imageNamed:@"color-button.png"];
            UIButton *colorButton = (UIButton*)[toolboxScrollView viewWithTag:colorTool];
            [colorButton setImage:[Utilities imageWithView:bgView] forState:UIControlStateNormal];
            
            UIButton *brushButton = (UIButton*)[toolboxScrollView viewWithTag:brushTool];
            [brushButton setImage:[UIImage imageNamed:@"brush-button.png"] forState:UIControlStateNormal];
            
            UIButton *eraseButton = (UIButton*)[toolboxScrollView viewWithTag:eraseTool];
            [eraseButton setImage:[UIImage imageNamed:@"erase-button.png"] forState:UIControlStateNormal];
        }
            break;
        case brushTool:
        {
            toolIV.image = [UIImage imageNamed:@"brush-button.png"];
            UIButton *brushButton = (UIButton*)[toolboxScrollView viewWithTag:brushTool];
            [brushButton setImage:[Utilities imageWithView:bgView] forState:UIControlStateNormal];
            
            UIButton *colorButton = (UIButton*)[toolboxScrollView viewWithTag:colorTool];
            [colorButton setImage:[UIImage imageNamed:@"color-button.png"] forState:UIControlStateNormal];
            
            UIButton *eraseButton = (UIButton*)[toolboxScrollView viewWithTag:eraseTool];
            [eraseButton setImage:[UIImage imageNamed:@"erase-button.png"] forState:UIControlStateNormal];
        }
            break;
        case eraseTool:
        {
            toolIV.image = [UIImage imageNamed:@"erase-button.png"];
            UIButton *eraseButton = (UIButton*)[toolboxScrollView viewWithTag:eraseTool];
            [eraseButton setImage:[Utilities imageWithView:bgView] forState:UIControlStateNormal];
            
            UIButton *colorButton = (UIButton*)[toolboxScrollView viewWithTag:colorTool];
            [colorButton setImage:[UIImage imageNamed:@"color-button.png"] forState:UIControlStateNormal];
            
            UIButton *brushButton = (UIButton*)[toolboxScrollView viewWithTag:brushTool];
            [brushButton setImage:[UIImage imageNamed:@"brush-button.png"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
//    [bgView release];
}

#pragma mark - Popup Actions
- (IBAction)toolButtonTUI:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag)
    {
        case colorTool:
        {
            //check for other popups
            if(lastSelectedTool == noTool)
            {
                [self highlightSelectedTool:colorTool];
                [self showColorsPopup];
                lastSelectedTool = colorTool;
                return;
            }
            if (lastSelectedTool == colorTool)
            {
                [self highlightSelectedTool:brushTool];
                [self dismissColorsPopup];
                lastSelectedTool = noTool;
                return;
            }
            if(lastSelectedTool == brushTool)
            {
                //close this popop and then show
                [self highlightSelectedTool:colorTool];
                [self dismissBrushPopup:NO];
                lastSelectedTool = colorTool;
                return;
            }
            if(lastSelectedTool == eraseTool)
            {
                //close this popop and then show
                [self highlightSelectedTool:colorTool];
                [self dismissBrushPopup:YES];
                lastSelectedTool = colorTool;
                return;
            }
        }
            break;
        case brushTool:
        {
            //check for other popups
            if(lastSelectedTool == noTool)
            {
                [self highlightSelectedTool:brushTool];
                [self showBrushPopup:NO];
                lastSelectedTool = brushTool;
                return;
            }
            if (lastSelectedTool == brushTool)
            {
                [self dismissBrushPopup:NO];
                lastSelectedTool = noTool;
                return;
            }
            if(lastSelectedTool == colorTool)
            {
                //close this popop and then show
                [self highlightSelectedTool:brushTool];
                [self dismissColorsPopup];
                lastSelectedTool = brushTool;
                return;
            }
            if(lastSelectedTool == eraseTool)
            {
                //close this popop and then show
                [self highlightSelectedTool:brushTool];
                [self dismissBrushPopup:YES];
                lastSelectedTool = brushTool;
                return;
            }
        }
            break;
            
        case eraseTool:
        {
            //check for other popups
            if(lastSelectedTool == noTool)
            {
                [self highlightSelectedTool:eraseTool];
                [self showBrushPopup:YES];
                lastSelectedTool = eraseTool;
                return;
            }
            if (lastSelectedTool == eraseTool)
            {
                [self dismissBrushPopup:YES];
                lastSelectedTool = noTool;
                return;
            }
            if(lastSelectedTool == colorTool)
            {
                //close this popop and then show
                [self highlightSelectedTool:eraseTool];
                [self dismissColorsPopup];
                lastSelectedTool = eraseTool;
                return;
            }
            if(lastSelectedTool == brushTool)
            {
                //close this popop and then show
                [self highlightSelectedTool:eraseTool];
                [self dismissBrushPopup:NO];
                lastSelectedTool = eraseTool;
                return;
            }
        }
            break;
            
        default:
            break;
    }
}
//    UIButton *btn = (UIButton*)sender;
//    switch (btn.tag)
//    {
//        case colorTool:
//        {
//            if(colorToolSelected)
//            {
//                //hide popup
//                colorToolSelected = NO;
//                [UIView animateWithDuration:0.3 animations:^{
//                    toolboxPopupView.frame = CGRectMake(toolboxPopupView.frame.origin.x, toolboxPopupView.frame.origin.y-toolboxPopupView.frame.size.height+10, toolboxPopupView.frame.size.width, toolboxPopupView.frame.size.height);
//                } completion:^(BOOL finished) {
//
//                }];
//
//            }else
//            {
//                //show popup
//                if(brushToolSelected)//or others
//                {
//                    //reinit scoll and butto
//                    toolItemsScrollView.frame = CGRectMake(42, 0, 225, 62);
//                    rightScrollItemsButton.frame = CGRectMake(264, 15, 40, 40);
//
//                    [self addItemsForToolbox:colorTool];
//                    brushToolSelected = NO;
//                    //hide old popup
//                    [UIView animateWithDuration:0.3 animations:^{
//                        toolboxPopupView.frame = CGRectMake(toolboxPopupView.frame.origin.x, toolboxPopupView.frame.origin.y-toolboxPopupView.frame.size.height+10, toolboxPopupView.frame.size.width, toolboxPopupView.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        //show the new popup
//                        colorToolSelected = YES;
//                        [UIView animateWithDuration:0.3 animations:^{
//                            toolboxPopupView.frame = CGRectMake(toolboxPopupView.frame.origin.x, toolboxPopupView.frame.origin.y+toolboxPopupView.frame.size.height-10, toolboxPopupView.frame.size.width, toolboxPopupView.frame.size.height);
//                        } completion:^(BOOL finished) {
//                        }];
//                    }];
//                }else
//                {
//                    //show the new popup
//                    [self addItemsForToolbox:colorTool];
//
//                    colorToolSelected = YES;
//                    [UIView animateWithDuration:0.3 animations:^{
//                        toolboxPopupView.frame = CGRectMake(toolboxPopupView.frame.origin.x, toolboxPopupView.frame.origin.y+toolboxPopupView.frame.size.height-10, toolboxPopupView.frame.size.width, toolboxPopupView.frame.size.height);
//                    } completion:^(BOOL finished) {
//                    }];
//                }
//            }
//        }
//            break;
//        case brushTool:
//        {
//            if(brushToolSelected)
//            {
//                //hide popup
//                brushToolSelected = NO;
//                [UIView animateWithDuration:0.3 animations:^{
//                    toolboxPopupView.frame = CGRectMake(toolboxPopupView.frame.origin.x, toolboxPopupView.frame.origin.y-toolboxPopupView.frame.size.height+10, toolboxPopupView.frame.size.width, toolboxPopupView.frame.size.height);
//                } completion:^(BOOL finished) {
//
//                }];
//
//            }else
//            {
//                //show popup
//                if(colorToolSelected)//or others
//                {
//                    toolItemsScrollView.frame = CGRectMake(42, 0, 225, 62);
//                    rightScrollItemsButton.frame = CGRectMake(110, 15, 40, 40);
//
//                    [self addItemsForToolbox:brushTool];
//                    colorToolSelected = NO;
//                    //hide old popup
//                    [UIView animateWithDuration:0.3 animations:^{
//                        toolboxPopupView.frame = CGRectMake(toolboxPopupView.frame.origin.x, toolboxPopupView.frame.origin.y-toolboxPopupView.frame.size.height+10, toolboxPopupView.frame.size.width, toolboxPopupView.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        //show the new popup
//                        brushToolSelected = YES;
//                        [UIView animateWithDuration:0.3 animations:^{
//                            toolboxPopupView.frame = CGRectMake(toolboxPopupView.frame.origin.x, toolboxPopupView.frame.origin.y+toolboxPopupView.frame.size.height-10, toolboxPopupView.frame.size.width, toolboxPopupView.frame.size.height);
//                        } completion:^(BOOL finished) {
//                        }];
//                    }];
//                }else
//                {
//                    //show the new popup
//                    toolItemsScrollView.frame = CGRectMake(42, 0, 225, 62);
//                    rightScrollItemsButton.frame = CGRectMake(leftScrollItemsButton.frame.origin.x+leftScrollItemsButton.frame.size.width+110, 15, 40, 40);
//
//                    [self addItemsForToolbox:brushTool];
//                    brushToolSelected = YES;
//                    [UIView animateWithDuration:0.3 animations:^{
//                        toolboxPopupView.frame = CGRectMake(toolboxPopupView.frame.origin.x, toolboxPopupView.frame.origin.y+toolboxPopupView.frame.size.height-10, toolboxPopupView.frame.size.width, toolboxPopupView.frame.size.height);
//                    } completion:^(BOOL finished) {
//                    }];
//                }
//            }
//        }
//            break;
//
//        default:
//            break;
//    }
//}

//- (IBAction)leftScrollButtonTUI:(id)sender
//{
//    if(toolboxScrollView.contentOffset.x > 0)
//    {
//        [UIView animateWithDuration:0.3 animations:^{
//            toolboxScrollView.contentOffset = CGPointMake(toolboxScrollView.contentOffset.x - (46+6.5), toolboxScrollView.contentOffset.y);
//
//        } completion:^(BOOL finished) {
//
//        }];
//    }
//}
//
//- (IBAction)rightScrollButtonTUI:(id)sender
//{
//    if(toolboxScrollView.contentOffset.x < toolboxScrollView.contentSize.width - toolboxScrollView.frame.size.width)
//    {
//        [UIView animateWithDuration:0.3 animations:^{
//            toolboxScrollView.contentOffset = CGPointMake(toolboxScrollView.contentOffset.x + (46+6.5), toolboxScrollView.contentOffset.y);
//        } completion:^(BOOL finished) {
//
//        }];
//    }
//}

- (void)brushSelectedTUI:(id)sender
{
    UIButton *item = (UIButton*)sender;
    selectedBrushIndex = (int)item.tag;
    [self highlightSelectedItem:brushTool];
    
    //remove preview subview
    while ([brushPreviewView.subviews count] > 0)
        [[[brushPreviewView subviews] objectAtIndex:0] removeFromSuperview];
//    UIImageView *previewIV = [[UIImageView alloc]initWithImage:[Utilities negativeImage:[UIImage imageNamed:[brushArray objectAtIndex:selectedBrushIndex]]]];
//    previewIV.frame = CGRectMake((64-pow(2, selectedBrushSize))/2, (64-pow(2, selectedBrushSize))/2, pow(2, selectedBrushSize), pow(2, selectedBrushSize));
    UIImageView *previewIV = [[UIImageView alloc]initWithImage:[Utilities negativeImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-preview.png",[[brushArray objectAtIndex:selectedBrushIndex] stringByDeletingPathExtension]]]]];
    previewIV.frame = CGRectMake((64-pow(2, selectedBrushSize-1))/2, (64-pow(2, selectedBrushSize-1))/2, pow(2, selectedBrushSize-1), pow(2, selectedBrushSize-1));
    previewIV.contentMode = UIViewContentModeScaleAspectFit;
    [brushPreviewView addSubview:previewIV];
//    [previewIV release];
    
    [drawingView setBrushName:[brushArray objectAtIndex:selectedBrushIndex]];
}

- (void)colorSelectedTUI:(id)sender
{
    UIButton *item = (UIButton*)sender;
    selectedColorIndex = (int)item.tag;
    [self highlightSelectedItem:colorTool];
    [drawingView setBrushColor:[colorsArray objectAtIndex:selectedColorIndex]];
}

- (void)bgColorSelectedTUI:(id)sender
{
    UIButton *item = (UIButton*)sender;
    if(item.tag == selectedBgColorIndex)
        return;
    
    selectedBgColorIndex = (int)item.tag;
    [self highlightSelectedItem:bgTool];
    [drawingView setBgColor:[colorsArray objectAtIndex:selectedBgColorIndex]];
    [drawingView setBrushColor:[colorsArray objectAtIndex:selectedBgColorIndex]];
    [drawingView eraseAllLines:YES];
    [appDelegate showLoadingActivity];
    [appDelegate setReDrawInPRogress:YES];

    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(concurrentQueue, ^{
        [drawingView playRecordedPath:drawingView.recordedPath Instant:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate hideLoadingActivity];
            [appDelegate setReDrawInPRogress:NO];
            [drawingView setBrushColor:[colorsArray objectAtIndex:selectedColorIndex]];
        });
    });
}

- (IBAction)brushSizeChange:(id)sender
{
    selectedBrushSize = brushSizeSlider.value;
    //remove preview subview
    while ([brushPreviewView.subviews count] > 0)
        [[[brushPreviewView subviews] objectAtIndex:0] removeFromSuperview];
    UIImageView *previewIV = [[UIImageView alloc]initWithImage:[Utilities negativeImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-preview.png",[[brushArray objectAtIndex:selectedBrushIndex] stringByDeletingPathExtension]]]]];
    previewIV.frame = CGRectMake((64-pow(2, selectedBrushSize-1))/2, (64-pow(2, selectedBrushSize-1))/2, pow(2, selectedBrushSize-1), pow(2, selectedBrushSize-1));
    previewIV.contentMode = UIViewContentModeScaleAspectFit;
    [brushPreviewView addSubview:previewIV];
//    [previewIV release];
    
    [drawingView setBrushSize:pow(2, selectedBrushSize)];
}

- (IBAction)dismissShareView:(id)sender
{
    [self dismissSharePopup];
}

- (IBAction)shareTypeSelectedTUI:(id)sender
{
    UIButton *btn = (UIButton*)sender;
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
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
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
//                    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];

                    // $$$Yy$ temphide
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
//
//                        });
//                    });

//                    [self dismissViewControllerAnimated:YES completion:^{
//                        
                        appDelegate.window.rootViewController = [[HomeViewController alloc] init] ;
//
//                    }];
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
                    if([[[dict objectForKey:@"response"] objectForKey:@"code"]intValue] == 40)
                    {
                        //Data already sent, or it is the other users turn to play.
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
        case registerPacketPurchaseRequest:
        {
            //register purchase
            if([[dict objectForKey:@"timeout"]boolValue])
            {
                //[appDelegate.inApp finishCurrentTransaction:NO];
                //timeout
                [appDelegate showAlert:@"A connection timeout occured. Plase try later." CancelButton:nil OkButton:@"OK" Type:timeoutAlert Sender:self];
            }else
            {
                if([[[dict objectForKey:@"response"] objectForKey:@"success"]boolValue])
                {
                    //success
                    //[appDelegate.inApp finishCurrentTransaction:YES];
                    appDelegate.userData.coins = [[[[dict objectForKey:@"response"] objectForKey:@"response"]objectForKey:@"coins"] intValue];
                    
                    [appDelegate showAlert:@"Packet successfully purchased." CancelButton:nil OkButton:@"OK" Type:buyOkAlert Sender:self];

                    //reload colors or brushes
                    for ( int i = 0; i < [appDelegate.inAppPacketsArray count]; i++)
                    {
                        if([[[appDelegate.inAppPacketsArray objectAtIndex:i]objectForKey:@"packet_id"]intValue] == [[[[dict objectForKey:@"response"] objectForKey:@"response"]objectForKey:@"packet_id"] intValue])
                        {
                            [[appDelegate.inAppPacketsArray objectAtIndex:i]setValue:@"YES" forKey:@"purchased"];
                            break;
                        }
                    }
                    
                    NSLog(@"%d",selectedColorIndex);
                    NSLog(@"%d",selectedBgColorIndex);
                    [self addPackages:appDelegate.inAppPacketsArray];
                    [self iniToolbar:appDelegate.inAppPacketsArray];
                }else
                {
                    //[appDelegate.inApp finishCurrentTransaction:NO];
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
            //[twitter addImage:[UIImage imageNamed:@"Icon.png"]];
            
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
                [self dismissViewControllerAnimated:YES completion:nil];
            };
        }else
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:shareString];
                [tweetSheet setTitle:shareString];
                //[tweetSheet addImage:[UIImage imageNamed:@"Icon.png"]];
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

- (NSMutableArray*)rescalese:(NSMutableArray*)drawing_path
{
//    float ratio = 291.0/320.0;
//    float newHeight = 234.0;
//    float newWidth = newHeight/ratio;
//    float xScaleRatio = newWidth/320.0;
//    float yScaleRatio = newHeight/291;
//    
//    int l = 0;
//    int p = 0;
//
//    for(l = 0; l < [drawing_path  count]; l++)
//    {
//        for(p = 0; p < [[drawing_path objectAtIndex:l]count] -1; p ++)
//        {
//            CGPoint point = [[[[drawing_path objectAtIndex:l]objectAtIndex:p]objectForKey:@"point"]CGPointValue];
//            point.x = point.x*xScaleRatio+(320-newWidth)/2;
//            point.y = point.y*yScaleRatio;//+(291-newHeight)/2;
//            [[[drawing_path objectAtIndex:l]objectAtIndex:p] setValue:[NSValue valueWithCGPoint:point] forKey:@"point"];
//
//            int oldBrushSize = [[[[drawing_path objectAtIndex:l]objectAtIndex:p]objectForKey:@"brush-size"]intValue];
//            [[[drawing_path objectAtIndex:l]objectAtIndex:p] setValue:[NSNumber numberWithInt:oldBrushSize*ratio] forKey:@"brush-size"];
//        }
//    }
    return drawing_path;
}

- (void)iniToolbar:(NSArray*)packages
{
    NSLog(@"%d",selectedColorIndex);
    NSLog(@"%d",selectedBgColorIndex);

    //colors
    for (int i = 0; i < [packages count]; i++)
    {
        if([[[packages objectAtIndex:i]objectForKey:@"packet_id"]intValue] == kColorsAllPackage &&
           [[[packages objectAtIndex:i]objectForKey:@"purchased"]boolValue])
        {
            NSMutableArray *tempColors = [[NSMutableArray alloc]init];
            [tempColors setArray:[Utilities generateAllColors]];
            
            if([colorsArray count] > 0)
            {
                for (int i = 0; i < [tempColors count]; i++)
                {
                    if([[[colorsArray objectAtIndex:selectedColorIndex] objectForKey:@"red"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"red"]floatValue] &&
                       [[[colorsArray objectAtIndex:selectedColorIndex] objectForKey:@"green"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"green"]floatValue] &&
                       [[[colorsArray objectAtIndex:selectedColorIndex] objectForKey:@"blue"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"blue"]floatValue])
                    {
                        selectedColorIndex = i;
                        break;
                    }
                }
                for (int i = 0; i < [tempColors count]; i++)
                {
                    if([[[colorsArray objectAtIndex:selectedBgColorIndex] objectForKey:@"red"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"red"]floatValue] &&
                       [[[colorsArray objectAtIndex:selectedBgColorIndex] objectForKey:@"green"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"green"]floatValue] &&
                       [[[colorsArray objectAtIndex:selectedBgColorIndex] objectForKey:@"blue"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"blue"]floatValue])
                    {
                        selectedBgColorIndex = i;
                        break;
                    }
                }
            }
            
            [colorsArray removeAllObjects];
            [colorsArray setArray:tempColors];
//            [tempColors release];
            break;
        }
        if([[[packages objectAtIndex:i]objectForKey:@"packet_id"]intValue] == kColors1Package &&
           [[[packages objectAtIndex:i]objectForKey:@"purchased"]boolValue])
        {
            NSMutableArray *tempColors = [[NSMutableArray alloc]init];
            [tempColors setArray:[Utilities generateFreeColors]];
            [tempColors addObjectsFromArray:[Utilities generatePackageColors]];
            
            if([colorsArray count] > 0)
            {
                for (int i = 0; i < [tempColors count]; i++)
                {
                    if([[[colorsArray objectAtIndex:selectedColorIndex] objectForKey:@"red"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"red"]floatValue] &&
                       [[[colorsArray objectAtIndex:selectedColorIndex] objectForKey:@"green"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"green"]floatValue] &&
                       [[[colorsArray objectAtIndex:selectedColorIndex] objectForKey:@"blue"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"blue"]floatValue])
                    {
                        selectedColorIndex = i;
                        break;
                    }
                }
                for (int i = 0; i < [tempColors count]; i++)
                {
                    if([[[colorsArray objectAtIndex:selectedBgColorIndex] objectForKey:@"red"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"red"]floatValue] &&
                       [[[colorsArray objectAtIndex:selectedBgColorIndex] objectForKey:@"green"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"green"]floatValue] &&
                       [[[colorsArray objectAtIndex:selectedBgColorIndex] objectForKey:@"blue"]floatValue] == [[[tempColors objectAtIndex:i]objectForKey:@"blue"]floatValue])
                    {
                        selectedBgColorIndex = i;
                        break;
                    }
                }
            }
            [colorsArray removeAllObjects];
            [colorsArray setArray:tempColors];
//            [tempColors release];
        }
    }
    if([colorsArray count] == 0)
        [colorsArray setArray:[Utilities generateFreeColors]];
    
    //brushes
    for (int i = 0; i < [packages count]; i++)
    {
        if([[[packages objectAtIndex:i]objectForKey:@"packet_id"]intValue] == kBrushesAllPackage &&
           [[[packages objectAtIndex:i]objectForKey:@"purchased"]boolValue])
        {
            NSMutableArray *tempBrushes = [[NSMutableArray alloc]init];
            [tempBrushes setArray:[Utilities generateAllBrushes]];
            
            if([brushArray count] > 0)
            {
                for (int i = 0; i < [tempBrushes count]; i++)
                {
                    if([[brushArray objectAtIndex:selectedBrushIndex] isEqualToString:[tempBrushes objectAtIndex:i]])
                    {
                        selectedBrushIndex = i;
                        break;
                    }
                }
                for (int i = 0; i < [tempBrushes count]; i++)
                {
                    if([[brushArray objectAtIndex:selectedBrushIndex] isEqualToString:[tempBrushes objectAtIndex:i]])
                    {
                        selectedEraseBrushIndex = i;
                        break;
                    }
                }
            }
            [brushArray removeAllObjects];
            [brushArray setArray:tempBrushes];
//            [tempBrushes release];
            break;
        }
        if([[[packages objectAtIndex:i]objectForKey:@"packet_id"]intValue] == kBrushes1Package &&
           [[[packages objectAtIndex:i]objectForKey:@"purchased"]boolValue])
        {
            NSMutableArray *tempBrushes = [[NSMutableArray alloc]init];
            [tempBrushes setArray:[Utilities generateFreeBrushes]];
            [tempBrushes addObjectsFromArray:[Utilities generatePackageBrushes]];
            
            if([brushArray count] > 0)
            {
                for (int i = 0; i < [tempBrushes count]; i++)
                {
                    if([[brushArray objectAtIndex:selectedBrushIndex] isEqualToString:[tempBrushes objectAtIndex:i]])

                    {
                        selectedBrushIndex = i;
                        break;
                    }
                }
                for (int i = 0; i < [tempBrushes count]; i++)
                {
                    if([[brushArray objectAtIndex:selectedBrushIndex] isEqualToString:[tempBrushes objectAtIndex:i]])
                    {
                        selectedEraseBrushIndex = i;
                        break;
                    }
                }
            }
            [brushArray removeAllObjects];
            [brushArray setArray:tempBrushes];
//            [tempBrushes release];
        }
    }
    if([brushArray count] == 0)
        [brushArray setArray:[Utilities generateFreeBrushes]];
   
    //populate toolbar
    [self addColorsToTools:colorsArray];
    [self addBrushesToTools:brushArray];
    
    //init brush preview
    brushPreviewView.layer.cornerRadius = 5;
    UIImageView *previewIV = [[UIImageView alloc]initWithImage:[Utilities negativeImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-preview.png",[[brushArray objectAtIndex:selectedBrushIndex] stringByDeletingPathExtension]]]]];
    previewIV.frame = CGRectMake((64-pow(2, selectedBrushSize-1))/2, (64-pow(2, selectedBrushSize-1))/2, pow(2, selectedBrushSize-1), pow(2, selectedBrushSize-1));
    previewIV.contentMode = UIViewContentModeScaleAspectFit;
    [brushPreviewView addSubview:previewIV];
//    [previewIV release];
    
    //init bg colors
    [self addColorsToBackground:colorsArray];
}

- (void) addPackages:(NSArray*)packages
{
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
    inAppLabel.text = @"In-App Purchases";
    inAppLabel.tag = -2;
    [addMorePopupView addSubview:inAppLabel];
//    [inAppLabel release];
    
    int yOffset = 0;
    for (int i = 0; i < [packages count]; i++)
    {
        switch ([[[packages objectAtIndex:i]objectForKey:@"packet_id"]intValue])
        {
            case kColors1Package:
            {
                    NSArray *colors = [Utilities generatePackageColors];
                    yOffset = [self addColorsToPopup:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Package:[packages objectAtIndex:i] Colors:colors]-10;
            }
                break;
            case kColorsAllPackage:
            {
                NSArray *colors = [Utilities generateAllColors];
                yOffset = [self addColorsToPopup:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Package:[packages objectAtIndex:i] Colors:colors]-10;
            }
                break;
            case kBrushes1Package:
            {
                NSArray *brushes = [Utilities generatePackageBrushes];
                yOffset = [self addBrushesToPopup:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Package:[packages objectAtIndex:i] Brushes:brushes]-10;
            }
                break;
            case kBrushesAllPackage:
            {
                NSArray *brushes = [Utilities generateAllBrushes];
                yOffset = [self addBrushesToPopup:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Package:[packages objectAtIndex:i] Brushes:brushes]-10;
            }
                break;
            case kBackgroundColorPackage:
            {
                yOffset = [self addBackgroundColorToPopup:CGRectMake(10, yOffset,addMorePopupView.frame.size.width, addMorePopupView.frame.size.height) Package:[packages objectAtIndex:i]]-10;
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
}

- (void)initDrawingView
{
    selectedColorIndex = 0;
    selectedBgColorIndex = [colorsArray count]-1;

    //search for drawing color - deafult black
    //search for bg color - default white
    for (int i = 0; i < [colorsArray count]; i++)
    {
        if([[[colorsArray objectAtIndex:i]objectForKey:@"red"]floatValue] == 0 &&
           [[[colorsArray objectAtIndex:i]objectForKey:@"green"]floatValue] == 0 &&
           [[[colorsArray objectAtIndex:i]objectForKey:@"blue"]floatValue] == 0
           )
        {
            selectedColorIndex = i;
        }
        if([[[colorsArray objectAtIndex:i]objectForKey:@"red"]floatValue] == 1 &&
           [[[colorsArray objectAtIndex:i]objectForKey:@"green"]floatValue] == 1 &&
           [[[colorsArray objectAtIndex:i]objectForKey:@"blue"]floatValue] == 1
           )
        {
            selectedBgColorIndex = i;
        }
    }
    
    selectedBrushIndex = 0;
    selectedEraseBrushIndex = 0;
    
    //init drawing view
    drawingView.delegate = self;
    [drawingView setBrushName:[brushArray objectAtIndex:selectedBrushIndex]];
    [drawingView setBrushSize:pow(2, selectedBrushSize)];
    [drawingView setBrushColor:[colorsArray objectAtIndex:selectedColorIndex]];
    [drawingView setBgColor:[colorsArray objectAtIndex:selectedBgColorIndex]];
    [drawingView setIsErased:NO];
}

- (int)addColorsToPopup:(CGRect)frame Package:(NSDictionary*)packagesDict Colors:(NSArray*)colors
{
    int yOffset = frame.origin.y;

    //package name
    LabelBorder *packageNameLabel = [[LabelBorder alloc]init];
    packageNameLabel.frame = CGRectMake(frame.origin.x, yOffset, addMorePopupView.frame.size.width-2*10, 20);
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
    
    UIImageView *colorsBg = [[UIImageView alloc]init];
    colorsBg.image = [UIImage imageNamed:@"colors-bg.png"];
    colorsBg.frame = CGRectMake(10, packageNameLabel.frame.origin.y+packageNameLabel.frame.size.height+5, addMorePopupView.frame.size.width-2*10-(10+40), 44);
    [addMoreScrollView addSubview:colorsBg];
//    [colorsBg release];
    
    UIScrollView *packageScroll = [[UIScrollView alloc]init];
    packageScroll.frame = CGRectMake(colorsBg.frame.origin.x+5, colorsBg.frame.origin.y, colorsBg.frame.size.width-2*5, colorsBg.frame.size.height);
    packageScroll.backgroundColor = [UIColor clearColor];
    packageScroll.showsHorizontalScrollIndicator = NO;
    int xOffset = 10;
    for (int i = 0; i < [colors count]; i++)
    {
        UIImageView *colorShadow = [[UIImageView alloc]initWithFrame:CGRectMake(xOffset, 4, 36, 37)];
        colorShadow.image = [UIImage imageNamed:@"color-shadow.png"];
        [packageScroll addSubview:colorShadow];
//        [colorShadow release];
        
        UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(colorShadow.frame.origin.x+7, colorShadow.frame.origin.y+7, colorShadow.frame.size.width-2*7, colorShadow.frame.size.height-2*7)];
        colorView.backgroundColor = [Utilities colorFromDict:[colors objectAtIndex:i]];
        colorView.layer.cornerRadius = 5;
        [packageScroll addSubview:colorView];
//        [colorView release];
        xOffset = xOffset + colorShadow.frame.size.width+10;
    }
    packageScroll.contentSize = CGSizeMake(xOffset, packageScroll.frame.size.height);
    [addMoreScrollView addSubview:packageScroll];
//    [packageScroll release];
    

    //purchase button
    UIButton *purchaseButton = [[UIButton alloc]init];
    purchaseButton.exclusiveTouch = YES;
    purchaseButton.frame = CGRectMake(packageScroll.frame.origin.x+packageScroll.frame.size.width+10, packageScroll.frame.origin.y+(packageScroll.frame.size.height-40)/2, 40, 40);
    [purchaseButton setImage:[UIImage imageNamed:@"purchase-button.png"] forState:UIControlStateNormal];
    [purchaseButton addTarget:self action:@selector(purchaseButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
    purchaseButton.tag = [[packagesDict objectForKey:@"packet_id"]intValue];
    if([[packagesDict objectForKey:@"purchased"]boolValue])
        purchaseButton.enabled = NO;
    [addMoreScrollView addSubview:purchaseButton];
//    [purchaseButton release];
    
    yOffset = yOffset + packageScroll.frame.size.height+20+40;
    
    return yOffset;
}

- (int)addBrushesToPopup:(CGRect)frame Package:(NSDictionary*)packagesDict Brushes:(NSArray*)brushes
{
    int yOffset = frame.origin.y;
    
    //package name
    LabelBorder *packageNameLabel = [[LabelBorder alloc]init];
    packageNameLabel.frame = CGRectMake(frame.origin.x, yOffset, addMorePopupView.frame.size.width-2*10, 20);
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
    
    UIImageView *brushesBg = [[UIImageView alloc]init];
    brushesBg.image = [UIImage imageNamed:@"colors-bg.png"];
    brushesBg.frame = CGRectMake(10, packageNameLabel.frame.origin.y+packageNameLabel.frame.size.height+5, addMorePopupView.frame.size.width-2*10-(10+40), 44);
    [addMoreScrollView addSubview:brushesBg];
//    [brushesBg release];
    
    UIScrollView *packageScroll = [[UIScrollView alloc]init];
    packageScroll.frame = CGRectMake(brushesBg.frame.origin.x+5, brushesBg.frame.origin.y, brushesBg.frame.size.width-2*5, brushesBg.frame.size.height);
    packageScroll.backgroundColor = [UIColor clearColor];
    packageScroll.showsHorizontalScrollIndicator = NO;
    int xOffset = 10;
    for (int i = 0; i < [brushes count]; i++)
    {
        UIImageView *brushShadow = [[UIImageView alloc]initWithFrame:CGRectMake(xOffset, 4, 36, 37)];
        brushShadow.image = [UIImage imageNamed:@"color-shadow.png"];
        [packageScroll addSubview:brushShadow];
//        [brushShadow release];
        
        UIImageView *brush = [[UIImageView alloc]initWithFrame:CGRectMake(brushShadow.frame.origin.x+7, brushShadow.frame.origin.y+7, brushShadow.frame.size.width-2*7, brushShadow.frame.size.height-2*7)];
        brush.image = [Utilities negativeImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-preview.png",[[brushes objectAtIndex:i] stringByDeletingPathExtension]]]];
        [packageScroll addSubview:brush];
//        [brush release];
        
        xOffset = xOffset + brushShadow.frame.size.width+10;
    }
    packageScroll.contentSize = CGSizeMake(xOffset, packageScroll.frame.size.height);
    [addMoreScrollView addSubview:packageScroll];
//    [packageScroll release];
    
    //purchase button
    UIButton *purchaseButton = [[UIButton alloc]init];
    purchaseButton.exclusiveTouch = YES;

    purchaseButton.frame = CGRectMake(packageScroll.frame.origin.x+packageScroll.frame.size.width+10, packageScroll.frame.origin.y+(packageScroll.frame.size.height-40)/2, 40, 40);
    [purchaseButton setImage:[UIImage imageNamed:@"purchase-button.png"] forState:UIControlStateNormal];
    [purchaseButton addTarget:self action:@selector(purchaseButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
    purchaseButton.tag = [[packagesDict objectForKey:@"packet_id"]intValue];
    if([[packagesDict objectForKey:@"purchased"]boolValue])
        purchaseButton.enabled = NO;
    [addMoreScrollView addSubview:purchaseButton];
//    [purchaseButton release];
    
    yOffset = yOffset + packageScroll.frame.size.height+20+40;
    
    return yOffset;
}

- (int)addBackgroundColorToPopup:(CGRect)frame Package:(NSDictionary*)packagesDict
{
    int yOffset = frame.origin.y;
    
    //package name
    LabelBorder *packageNameLabel = [[LabelBorder alloc]init];
    packageNameLabel.frame = CGRectMake(frame.origin.x, yOffset, addMorePopupView.frame.size.width-2*10, 20);
    packageNameLabel.backgroundColor = [UIColor clearColor];
    packageNameLabel.textColor = [UIColor whiteColor];
    packageNameLabel.font = [UIFont fontWithName:@"marvin" size:20];
    packageNameLabel.minimumFontSize = 14;
    packageNameLabel.adjustsFontSizeToFitWidth = YES;
    packageNameLabel.textAlignment = NSTextAlignmentLeft;
    packageNameLabel.textAlignment = NSTextAlignmentLeft;
    packageNameLabel.text = [packagesDict objectForKey:@"name"];
    [addMoreScrollView addSubview:packageNameLabel];
//    [packageNameLabel release];
    
    UIImageView *backgroundColorIV = [[UIImageView alloc]initWithFrame:CGRectMake((addMorePopupView.frame.size.width-2*10-(10+40)-116)/2, packageNameLabel.frame.origin.y+packageNameLabel.frame.size.height+5, 116, 44)];
    backgroundColorIV.image = [UIImage imageNamed:@"background-color.png"];
    [addMoreScrollView addSubview:backgroundColorIV];
//    [backgroundColorIV release];
    
    //purchase button
    UIButton *purchaseButton = [[UIButton alloc]init];
    purchaseButton.exclusiveTouch = YES;

    purchaseButton.frame = CGRectMake(addMorePopupView.frame.size.width-10-40, backgroundColorIV.frame.origin.y+(backgroundColorIV.frame.size.height-40)/2, 40, 40);
    [purchaseButton setImage:[UIImage imageNamed:@"purchase-button.png"] forState:UIControlStateNormal];
    [purchaseButton addTarget:self action:@selector(purchaseButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
    purchaseButton.tag = [[packagesDict objectForKey:@"packet_id"]intValue];
    if([[packagesDict objectForKey:@"purchased"]boolValue])
        purchaseButton.enabled = NO;
    [addMoreScrollView addSubview:purchaseButton];
//    [purchaseButton release];
    
    yOffset = yOffset + backgroundColorIV.frame.size.height+20+40;
    
    return yOffset;
}

- (void)addColorsToTools:(NSArray*)colors
{
    while ([colorsScrollView.subviews count] > 0)
        [[[colorsScrollView subviews] objectAtIndex:0] removeFromSuperview];
    
    int xOffset = 5;
    for (int i = 0; i < [colors count]; i++)
    {
        UIButton *itemButton = [[UIButton alloc]initWithFrame:CGRectMake(xOffset, (colorsScrollView.frame.size.height-37)/2, 36, 37)];
        itemButton.tag = i;
        itemButton.backgroundColor = [UIColor clearColor];
        
        UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 36, 37)];
        //itemView.layer.cornerRadius = 3;
        itemView.backgroundColor = [UIColor clearColor];
        
        UIImageView *colorShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 37)];
        colorShadow.image = [UIImage imageNamed:@"color-shadow.png"];
        [itemView addSubview:colorShadow];
//        [colorShadow release];
        
        UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(colorShadow.frame.origin.x+7, colorShadow.frame.origin.y+7, colorShadow.frame.size.width-2*7, colorShadow.frame.size.height-2*7)];
        colorView.backgroundColor = [Utilities colorFromDict:[colors objectAtIndex:i]];
        colorView.layer.cornerRadius = 5;
        [itemView addSubview:colorView];
//        [colorView release];
        
        [itemButton setImage:[Utilities imageWithView:itemView] forState:UIControlStateNormal];
        [itemButton addTarget:self action:@selector(colorSelectedTUI:) forControlEvents:UIControlEventTouchUpInside];
        [colorsScrollView addSubview:itemButton];
//        [itemButton release];
        xOffset = xOffset + itemButton.frame.size.width + 5;
    }
    colorsScrollView.contentSize = CGSizeMake(xOffset, 30);
    [self highlightSelectedItem:colorTool];
}

- (void)addBrushesToTools:(NSArray*)brushes
{
    while ([brushesScrollView.subviews count] > 0)
        [[[brushesScrollView subviews] objectAtIndex:0] removeFromSuperview];
    
    int xOffset = 5;
    for (int i = 0; i < [brushes count]; i++)
    {
        UIButton *itemButton = [[UIButton alloc]initWithFrame:CGRectMake(xOffset, (colorsScrollView.frame.size.height-37)/2, 36, 37)];
        itemButton.tag = i;
        itemButton.backgroundColor = [UIColor clearColor];
        
        UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, itemButton.frame.size.width, itemButton.frame.size.height)];
        itemView.layer.cornerRadius = 3;
        
        UIImageView *brushShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 37)];
        brushShadow.image = [UIImage imageNamed:@"color-shadow.png"];
        [itemView addSubview:brushShadow];
//        [brushShadow release];
        
        UIImageView *brush = [[UIImageView alloc]initWithFrame:CGRectMake(brushShadow.frame.origin.x+7, brushShadow.frame.origin.y+7, brushShadow.frame.size.width-2*7, brushShadow.frame.size.height-2*7)];
        brush.image = [Utilities negativeImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-preview.png",[[brushes objectAtIndex:i] stringByDeletingPathExtension]]]];
        [itemView addSubview:brush];
//        [brush release];
        
        [itemButton setImage:[Utilities imageWithView:itemView] forState:UIControlStateNormal];
//        [itemView release];
        [itemButton addTarget:self action:@selector(brushSelectedTUI:) forControlEvents:UIControlEventTouchUpInside];
        [brushesScrollView addSubview:itemButton];
//        [itemButton release];
        xOffset = xOffset + itemButton.frame.size.width + 5;
    }
    brushesScrollView.contentSize = CGSizeMake(xOffset, brushesScrollView.frame.size.height);
    [self highlightSelectedItem:brushTool];
}

- (void)addColorsToBackground:(NSArray*)colors
{
        while ([bgColorsScrollView.subviews count] > 0)
        [[[bgColorsScrollView subviews] objectAtIndex:0] removeFromSuperview];
    
    int xOffset = 5;
    for (int i = 0; i < [colorsArray count]; i++)
    {
        UIButton *itemButton = [[UIButton alloc]initWithFrame:CGRectMake(xOffset, 5, 40, 40)];
        itemButton.tag = i;
        itemButton.backgroundColor = [UIColor clearColor];
        
        UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        
        itemView.backgroundColor = [UIColor clearColor];
        
        UIImageView *colorShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 37)];
        colorShadow.image = [UIImage imageNamed:@"color-shadow.png"];
        [itemView addSubview:colorShadow];
//        [colorShadow release];
        
        UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(colorShadow.frame.origin.x+7, colorShadow.frame.origin.y+7, colorShadow.frame.size.width-2*7, colorShadow.frame.size.height-2*7)];
        colorView.backgroundColor = [Utilities colorFromDict:[colors objectAtIndex:i]];
        colorView.layer.cornerRadius = 5;
        [itemView addSubview:colorView];
//        [colorView release];
        
        [itemButton setImage:[Utilities imageWithView:itemView] forState:UIControlStateNormal];
        //[colorView release];
        [itemButton addTarget:self action:@selector(bgColorSelectedTUI:) forControlEvents:UIControlEventTouchUpInside];
        [bgColorsScrollView addSubview:itemButton];
//        [itemButton release];
        xOffset = xOffset + 40 + 5;
    }
    bgColorsScrollView.contentSize = CGSizeMake(xOffset, 40);
    
    [self highlightSelectedItem:bgTool];
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


#pragma mark - app notifications
- (void)handleEnteredBackground
{
    [appDelegate setGamePaused:YES];
}

- (void)handleEnteredForeground
{
    [appDelegate setGamePaused:NO];

}

@end
