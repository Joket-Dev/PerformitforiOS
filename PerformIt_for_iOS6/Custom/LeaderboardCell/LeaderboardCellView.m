//
//  LeaderboardCellView.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/3/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "LeaderboardCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation LeaderboardCellView
@synthesize playerPhotoIV, playerNameLabel, scoreLabel;

- (id)initWithFrame:(CGRect)frame Image:(UIImage*)image Name:(NSString*)name Score:(int)score;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

        UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leaderboard-cell-bg.png"]];
        bgIV.frame = CGRectMake(0, 2, frame.size.width, frame.size.height-2*2);
        [self addSubview:bgIV];
//        [bgIV release];
        self.backgroundColor = [UIColor clearColor];
        
        playerPhotoIV = [[UIImageView alloc]initWithImage:image];
        playerPhotoIV.frame = CGRectMake(2+10, 2+10, frame.size.height-2*(2+10), frame.size.height-2*(2+10));
        [self addSubview:playerPhotoIV];
//        [playerPhotoIV release];
        
        playerNameLabel = [[LabelBorder alloc]init];
        playerNameLabel.frame = CGRectMake(10+frame.size.height-20+10, (frame.size.height-30)/2, 120, 30);
        playerNameLabel.backgroundColor = [UIColor clearColor];
        playerNameLabel.textColor = [UIColor whiteColor];
        playerNameLabel.font = [UIFont fontWithName:@"marvin" size:18];
        playerNameLabel.minimumFontSize = 16;
        playerNameLabel.adjustsFontSizeToFitWidth = YES;
        if([appDelegate isIPHONE5])
            playerNameLabel.textAlignment = NSTextAlignmentLeft;
        else
            playerNameLabel.textAlignment = NSTextAlignmentLeft;
                
        playerNameLabel.text = name;
        [self addSubview:playerNameLabel];
//        [playerNameLabel release];
        
        LabelBorder *scoreTextLabel = [[LabelBorder alloc]init];
        scoreTextLabel.frame = CGRectMake(10+40+20+120+10, 15, (frame.size.width-(10+40+20+120+10+10)), 25);
        scoreTextLabel.backgroundColor = [UIColor clearColor];
        scoreTextLabel.textColor = [UIColor whiteColor];
        scoreTextLabel.font = [UIFont fontWithName:@"marvin" size:20];
        if([appDelegate isIPHONE5])
            scoreTextLabel.textAlignment = NSTextAlignmentCenter;
        else
            scoreTextLabel.textAlignment = NSTextAlignmentCenter;

        scoreTextLabel.text = @"Score";
        [self addSubview:scoreTextLabel];
//        [scoreTextLabel release];
        
        scoreLabel = [[LabelBorder alloc]init];
        scoreLabel.frame = CGRectMake(10+40+20+120+10, frame.size.height-15-25, (frame.size.width-(10+40+20+120+10+10)), 25);
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textColor = [UIColor whiteColor];
        scoreLabel.font = [UIFont fontWithName:@"marvin" size:20];
        if([appDelegate isIPHONE5])
            scoreLabel.textAlignment = NSTextAlignmentCenter;
        else
            scoreLabel.textAlignment = NSTextAlignmentCenter;

        scoreLabel.text = [NSString stringWithFormat:@"%d",score];
        [self addSubview:scoreLabel];
//        [scoreLabel release];
        
    }
    return self;
}


@end
