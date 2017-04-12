//
//  AchievementCellView.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/3/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "AchievementCellView.h"
#import "Utilities.h"

@implementation AchievementCellView

- (id)initWithFrame:(CGRect)frame AchievementType:(NSString*)type Achieved:(BOOL)achieved Completed:(int)completed From:(int)from AchievementName:(NSString*)name
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"achievement-bg.png"]];
        bgIV.frame = CGRectMake(3, 3, 144, 154);
        [self addSubview:bgIV];
//        [bgIV release];
        
        if(achieved)
        {
            UIImageView *achievedIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"achieved.png"]];
            achievedIV.frame = CGRectMake(bgIV.frame.origin.x+bgIV.frame.size.width-28, bgIV.frame.origin.y, 28, 28);
            [self addSubview:achievedIV];
//            [achievedIV release];
        }
        
        UIImageView *achievementIV;
        if(achieved)
            achievementIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",type]]];
        else
            achievementIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-uncompleted.png",type]]];

        achievementIV.frame = CGRectMake(15, 10, frame.size.width-30, frame.size.height-30);
        [self addSubview:achievementIV];
//        [achievementIV release];
        
        if(from > 0)
        {
            LabelBorder *completedLabel = [[LabelBorder alloc]init];
            completedLabel.frame = CGRectMake(10, 10, 100, 20);
            completedLabel.backgroundColor = [UIColor clearColor];
            completedLabel.textColor = [UIColor whiteColor];
            completedLabel.font = [UIFont fontWithName:@"marvin" size:20];
            completedLabel.textAlignment = NSTextAlignmentLeft;
            completedLabel.textAlignment = NSTextAlignmentLeft;
            completedLabel.text = [NSString stringWithFormat:@"%d/%d",completed,from];
            [self addSubview:completedLabel];
//            [completedLabel release];
        }
        
        LabelBorder *nameLabel = [[LabelBorder alloc]init];
        nameLabel.frame = CGRectMake(10, frame.size.height-10-40+2, frame.size.width-20, 40);
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [Utilities fontWithName:@"marvin" minSize:10 maxSize:17 constrainedToSize:CGSizeMake(frame.size.width-20, 40) forText:name];//[UIFont fontWithName:@"marvin" size:20];
//        nameLabel.minimumFontSize = 10;
//        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.numberOfLines = 0;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = [NSString stringWithFormat:@"%@",name];
        [self addSubview:nameLabel];
//        [nameLabel release];
    }
    return self;
}

@end
