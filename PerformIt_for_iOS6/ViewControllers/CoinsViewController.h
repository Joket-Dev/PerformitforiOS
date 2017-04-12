//
//  CoinsViewController.h
//  PerformIt
//
//  Created by Mihai Puscas on 6/24/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CoinsViewController : UIViewController<UIScrollViewDelegate>
{
    AppDelegate *appDelegate;
    int selectedCoinsID;
}
@property (nonatomic, strong) IBOutlet UIImageView  *backgroundIV;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic, strong) NSMutableArray *coinsArray;

- (void)buyCoinsWithTRansaction:(SKPaymentTransaction*)transaction;


@end
