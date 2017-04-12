//
//  LeaderboardViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 5/2/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class AppDelegate;
@interface LeaderboardViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    AppDelegate *appDelegate;
    BOOL endThread;
    BOOL dataAvailable;
}
@property (nonatomic, strong) IBOutlet UIImageView *backgroundIV;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) IBOutlet UITableView *tbl;

@property (nonatomic, strong) NSMutableArray *leaderboardArray;


- (IBAction)homeButtonTUI:(id)sender;

@end
