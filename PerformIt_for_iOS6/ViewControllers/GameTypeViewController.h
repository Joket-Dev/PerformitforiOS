//
//  GameTypeViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 5/6/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class AppDelegate;
@interface GameTypeViewController : UIViewController
{
    AppDelegate *appDelegate;
    int opponentID;
    NSMutableDictionary *wordsDict;
    int gameTypeSelected;
    BOOL continueGame;
    int selectedGameID;
    NSMutableDictionary *gameDict;

}
@property (nonatomic, strong) IBOutlet UIImageView *backgroundIV;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) IBOutlet UIButton *changeWordsButton;
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) UIButton *coinsButton;
@property (nonatomic, strong) NSMutableDictionary *gameDict;

@property (nonatomic, strong) IBOutlet UIView *popupView;
@property (nonatomic, strong) IBOutlet LabelBorder *popupLabel;
@property (nonatomic, strong) IBOutlet UIView *bubblesPopupView;
@property (nonatomic, strong) IBOutlet UIScrollView *bubblesScrollView;
@property (nonatomic, strong) IBOutlet UIButton *closePopupButton;

@property (nonatomic, strong) NSMutableArray *bubblesArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithUser:(int)opponent_id AndData:(NSMutableDictionary*)dict Game:(int)game_id Continue:(BOOL)continue_game;

- (IBAction)homeButtonTUI:(id)sender;
- (IBAction)changeWordsButtonTUI:(id)sender;

@end
