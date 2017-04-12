//
//  LeaderboardCellView.h
//  PerformIt
//
//  Created by Mihai Puscas on 5/3/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelBorder.h"

@interface LeaderboardCellView : UIView
{
    UIImageView *playerPhotoIV;
    LabelBorder *playerNameLabel;
    LabelBorder *scoreLabel;
}
@property (nonatomic, strong) UIImageView *playerPhotoIV;
@property (nonatomic, strong) LabelBorder *playerNameLabel;
@property (nonatomic, strong) LabelBorder *scoreLabel;

- (id)initWithFrame:(CGRect)frame Image:(UIImage*)image Name:(NSString*)name Score:(int)score;

@end
