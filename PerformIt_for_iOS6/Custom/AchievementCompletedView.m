//
//  AchievementCompletedView.m
//  PerformIt
//
//  Created by Mihai Puscas on 8/19/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "AchievementCompletedView.h"
#import "LabelBorder.h"
#import "Utilities.h"

@implementation AchievementCompletedView

- (id)initWithFrame:(CGRect)frame AchievementName:(NSString*)name AchievementCoins:(NSString*)coins AchievementImage:(NSString*)image Sender:(id)sender Type:(int)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.tag = type;
        UIImageView *bgIV = [[UIImageView alloc]init];
        bgIV.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        bgIV.image = [UIImage imageNamed:@"achievement-popup.png"];
        bgIV.frame = CGRectMake(0, 0, 303, 350);
        [self addSubview:bgIV];
//        [bgIV release];
       
        UIImageView *achievementCompletedIV = [[UIImageView alloc]init];
        achievementCompletedIV.image = [UIImage imageNamed:@"you-have-completed.png"];
        achievementCompletedIV.frame = CGRectMake(24, 20, 223, 105);
        [self addSubview:achievementCompletedIV];
//        [achievementCompletedIV release];
        
               
        CGSize nameSize = [name sizeWithFont:[UIFont fontWithName:@"marvin" size:24]constrainedToSize:CGSizeMake(frame.size.width-2*15-20, 100) lineBreakMode:NSLineBreakByWordWrapping];

        LabelBorder *achievementName = [[LabelBorder alloc]init];
        achievementName.frame = CGRectMake(15, achievementCompletedIV.frame.origin.y+achievementCompletedIV.frame.size.height-10, frame.size.width-2*15-20, nameSize.height);
        achievementName.backgroundColor = [UIColor clearColor];
        achievementName.textColor = [UIColor colorWithRed:141.0/255.0 green:18.0/255.0 blue:168.0/255.0 alpha:1.0];
        achievementName.font = [UIFont fontWithName:@"marvin" size:22];
        achievementName.minimumFontSize = 16;
        achievementName.adjustsFontSizeToFitWidth = YES;
        achievementName.lineBreakMode = NSLineBreakByWordWrapping;
        achievementName.numberOfLines = 0;
        achievementName.textAlignment = NSTextAlignmentCenter;
        achievementName.textAlignment = NSTextAlignmentCenter;
        achievementName.text = name;
        [self addSubview:achievementName];
//        [achievementName release];
        
        LabelBorder *achievementTextLabel = [[LabelBorder alloc]init];
        achievementTextLabel.frame = CGRectMake(achievementName.frame.origin.x-10, achievementName.frame.origin.y+achievementName.frame.size.height, achievementName.frame.size.width+2*10, 25);
        
        achievementTextLabel.backgroundColor = [UIColor clearColor];
        achievementTextLabel.textColor = [UIColor whiteColor];
        achievementTextLabel.font = [UIFont fontWithName:@"marvin" size:22];
        achievementTextLabel.minimumFontSize = 16;
        achievementTextLabel.adjustsFontSizeToFitWidth = YES;
        achievementTextLabel.textAlignment = NSTextAlignmentCenter;
        achievementTextLabel.textAlignment = NSTextAlignmentCenter;
        achievementTextLabel.text = @"ACHIEVEMENT";
        [self addSubview:achievementTextLabel];
//        [achievementTextLabel release];
        
        UIImageView *achievementIV = [[UIImageView alloc]init];
        achievementIV.image = [UIImage imageNamed:image];
        achievementIV.frame = CGRectMake((self.frame.size.width-20-112)/2, achievementTextLabel.frame.origin.y+achievementTextLabel.frame.size.height-10, 112, 120);
        [self addSubview:achievementIV];
//        [achievementIV release];

        UIImageView *coinsIV = [[UIImageView alloc]init];
        coinsIV.image = [UIImage imageNamed:@"win-coin.png"];
        coinsIV.frame = CGRectMake(frame.size.width-20-15-10-42-20, frame.size.height-15-55, 42, 55);
        [self addSubview:coinsIV];
//        [coinsIV release];
        
        LabelBorder *achievementCoins = [[LabelBorder alloc]init];
        achievementCoins.frame = CGRectMake(coinsIV.frame.origin.x-5-100,coinsIV.frame.origin.y+coinsIV.frame.size.height/2-30/2-5, 100, 30);
        achievementCoins.backgroundColor = [UIColor clearColor];
        achievementCoins.textColor = [UIColor whiteColor];
        achievementCoins.font = [UIFont fontWithName:@"marvin" size:25];
        achievementCoins.textAlignment = NSTextAlignmentRight;
        achievementCoins.textAlignment = NSTextAlignmentRight;
        achievementCoins.text = coins;
        [self addSubview:achievementCoins];
//        [achievementCoins release];
        
        UIImageView *earnLabel = [[UIImageView alloc]init];
        earnLabel.image = [UIImage imageNamed:@"achievement-you-have-earned.png"];
        earnLabel.frame = CGRectMake(15+20, frame.size.height-15-50-5, 90, 50);
        [self addSubview:earnLabel];
//        [earnLabel release];
        
        UIButton *closeButton = [[UIButton alloc]init];
        closeButton.frame = CGRectMake(265, -4, 40, 44);
        [closeButton setImage:[UIImage imageNamed:@"close-popup-button.png"] forState:UIControlStateNormal];
        [closeButton addTarget:sender action:@selector(closePopupButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
        closeButton.tag = type;

        [self addSubview:closeButton];
//        [closeButton release];

    }
    return self;
}

@end
