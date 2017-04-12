//
//  FacebookFriendCell.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/6/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "FacebookFriendCell.h"
#import "AppDelegate.h"

@implementation FacebookFriendCell

- (id)initWithFrame:(CGRect)frame Photo:(UIImage*)image Name:(NSString*)name 
{
    self = [super initWithFrame:frame];
    if (self)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

//        UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
//        bgIV.frame = CGRectMake(3, 3, 144, 154);
//        [self addSubview:bgIV];
//        [bgIV release];
        
        UIImageView *friendPhotoIV = [[UIImageView alloc]initWithImage:image];
        friendPhotoIV.frame = CGRectMake((frame.size.height-50)/2, (frame.size.height-50)/2, 50, 50);
        [self addSubview:friendPhotoIV];
//        [friendPhotoIV release];
        
        UILabel *friendNameLabel = [[UILabel alloc]init];
        friendNameLabel.frame = CGRectMake((frame.size.height-50)/2+50+10, (frame.size.height-28)/2, frame.size.width-(frame.size.height-50)/2-50-10-10-16-20, 28);
        friendNameLabel.backgroundColor = [UIColor clearColor];
        friendNameLabel.textColor = [UIColor blackColor];
        friendNameLabel.font = [UIFont systemFontOfSize:20];
        friendNameLabel.minimumFontSize = 18;
        friendNameLabel.adjustsFontSizeToFitWidth = YES;
        if([appDelegate isIPHONE5])
            friendNameLabel.textAlignment = NSTextAlignmentLeft;
        else
            friendNameLabel.textAlignment = NSTextAlignmentLeft;
        friendNameLabel.text = name;
        [self addSubview:friendNameLabel];
//        [friendNameLabel release];
        
        UIImageView *arrowIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right-arrow.png"]];
        arrowIV.frame = CGRectMake(frame.size.width-10-16-20, (frame.size.height-14)/2, 14, 16);
        [self addSubview:arrowIV];
//        [arrowIV release];

    }
    return self;
}


@end
