//
//  DrawViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 5/15/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DrawingView.h"
#import "TouchDownGestureRecognizer.h"
#import <FacebookSDK/FacebookSDK.h>

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>

@class AppDelegate;
@interface DrawViewController : UIViewController<UIScrollViewDelegate,DrawingViewDelegate, UIGestureRecognizerDelegate>
{
    AppDelegate *appDelegate;
    BOOL drawed;
    NSString *drawingName;
    NSMutableArray *path;
    
    NSMutableArray *colorsArray;
    NSMutableArray *brushArray;
    NSMutableArray *shareArray;

    int lastSelectedTool;
    
    int selectedBrushSize;
    int selectedBrushIndex;

    int selectedEraseBrushSize;
    int selectedEraseBrushIndex;
    
    int selectedColorIndex;
    int selectedBgColorIndex;

    NSMutableDictionary *gameDict;
    BOOL firstTouch;
    BOOL undoAvailable;
    BOOL purchasesAvailable;
    int lastSelectedShareType;
    int buyItemIndex;
}

@property (nonatomic, strong) IBOutlet UIImageView *backgroundIV;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIButton *saveDrawingButton;
@property (nonatomic, strong) IBOutlet UIButton *sendDrawingButton;
@property (nonatomic, strong) IBOutlet UIButton *shareDrawingButton;
@property (nonatomic, strong) IBOutlet UIButton *undoButton;
@property (nonatomic, strong) IBOutlet UIButton *clearButton;
@property (nonatomic, strong) IBOutlet UIButton *addMoreButton;
@property (nonatomic, strong) IBOutlet UIScrollView *toolboxScrollView;
@property (nonatomic, strong) IBOutlet UIView *colorPopupView;
@property (nonatomic, strong) IBOutlet UIView *brushPopupView;
@property (nonatomic, strong) IBOutlet UIScrollView *colorsScrollView;
@property (nonatomic, strong) IBOutlet UIScrollView *brushesScrollView;
@property (nonatomic, strong) IBOutlet UISlider *brushSizeSlider;
@property (nonatomic, strong) IBOutlet UIView *brushPreviewView;
@property (nonatomic, strong) IBOutlet UIButton *dismissPopupButton;
@property (nonatomic, strong) IBOutlet UIView *bgColorPopupView;
@property (nonatomic, strong) IBOutlet UIScrollView *bgColorsScrollView;
@property (nonatomic, strong) IBOutlet UIImageView *leftArrowIV;
@property (nonatomic, strong) IBOutlet UIImageView *rightArrowIV;

@property (nonatomic, strong) IBOutlet UIView *shareView;
@property (nonatomic, strong) IBOutlet UIView *sharePopupView;
@property (nonatomic, strong) IBOutlet UIScrollView *shareScrollView;
@property (nonatomic, strong) IBOutlet UIView *addMorePopupView;
@property (nonatomic, strong) IBOutlet UIScrollView *addMoreScrollView;

@property (nonatomic, strong) IBOutlet UIButton *dismissAddMorePopupButton;

@property (nonatomic, strong) IBOutlet DrawingView *drawingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil GameData:(NSMutableDictionary*)game_dict;

@end
