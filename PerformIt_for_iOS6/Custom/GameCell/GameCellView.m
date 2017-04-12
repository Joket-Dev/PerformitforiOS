//
//  GameCellView.m
//  PerformIt
//
//  Created by Mihai Puscas on 4/30/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "GameCellView.h"
#import "AppDelegate.h"

@implementation GameCellView
@synthesize opponentPhotoIV, opponentNameLabel, roundLabel;
- (id)initWithFrame:(CGRect)frame Image:(UIImage*)image Name:(NSString*)name Round:(int)round Action:(BOOL)action_enabled
{
    self = [super initWithFrame:frame];
    if (self)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

        UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"game-cell-bg.png"]];
        bgIV.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:bgIV];
//        [bgIV release];
        self.backgroundColor = [UIColor clearColor];
        
        if(image == nil && round == 0 && name == nil )
        {
            opponentNameLabel = [[UILabel alloc]init];
            opponentNameLabel.frame = frame;
            opponentNameLabel.backgroundColor = [UIColor clearColor];
            opponentNameLabel.textColor = [UIColor blackColor];
            opponentNameLabel.font = [UIFont systemFontOfSize:18];
            opponentNameLabel.textAlignment = NSTextAlignmentCenter;
            opponentNameLabel.textAlignment = NSTextAlignmentCenter;
            opponentNameLabel.text = @"No games in this category";
            [self addSubview:opponentNameLabel];
//            [opponentNameLabel release];
        }else
        {
            opponentPhotoIV = [[UIImageView alloc]initWithImage:image];
            opponentPhotoIV.frame = CGRectMake(4, 4, 40, 40);
            [self addSubview:opponentPhotoIV];
//            [opponentPhotoIV release];
            
            opponentNameLabel = [[UILabel alloc]init];
            opponentNameLabel.frame = CGRectMake(4+40+10, (frame.size.height-28)/2, 160-20, 28);
            opponentNameLabel.backgroundColor = [UIColor clearColor];
            opponentNameLabel.textColor = [UIColor blackColor];
            opponentNameLabel.font = [UIFont systemFontOfSize:20];
            opponentNameLabel.minimumFontSize = 14;
            opponentNameLabel.adjustsFontSizeToFitWidth = YES;
            if([appDelegate isIPHONE5])
                opponentNameLabel.textAlignment = NSTextAlignmentLeft;
            else
                opponentNameLabel.textAlignment = NSTextAlignmentLeft;
            opponentNameLabel.text = name;
            [self addSubview:opponentNameLabel];
//            [opponentNameLabel release];
            
            roundLabel = [[UILabel alloc]init];
            roundLabel.frame = CGRectMake(opponentNameLabel.frame.origin.x+opponentNameLabel.frame.size.width+10, (frame.size.height-28)/2, (frame.size.width-10-16)-(opponentNameLabel.frame.origin.x+opponentNameLabel.frame.size.width+10), 28);
            roundLabel.backgroundColor = [UIColor clearColor];
            roundLabel.textColor = [UIColor darkGrayColor];
            roundLabel.font = [UIFont fontWithName:@"marvin" size:25];
            if([appDelegate isIPHONE5])
                roundLabel.textAlignment = NSTextAlignmentCenter;
            else
                roundLabel.textAlignment = NSTextAlignmentCenter;
            roundLabel.text = [NSString stringWithFormat:@"%d",round];
            [self addSubview:roundLabel];
//            [roundLabel release];
            
            if(action_enabled)
            {
                UIImageView *arrowIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right-arrow.png"]];
                arrowIV.frame = CGRectMake(frame.size.width-10-16, (frame.size.height-14)/2, 14, 16);
                [self addSubview:arrowIV];
//                [arrowIV release];
            }
        }
        
    }
    return self;
}

@end
