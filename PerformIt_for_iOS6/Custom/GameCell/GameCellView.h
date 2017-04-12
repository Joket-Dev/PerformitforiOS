//
//  GameCellView.h
//  PerformIt
//
//  Created by Mihai Puscas on 4/30/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameCellView : UIView
{
    UIImageView *opponentPhotoIV;
    UILabel *opponentNameLabel;
    UILabel *roundLabel;
}
@property (nonatomic, strong) UIImageView *opponentPhotoIV;
@property (nonatomic, strong) UILabel *opponentNameLabel;
@property (nonatomic, strong) UILabel *roundLabel;

- (id)initWithFrame:(CGRect)frame Image:(UIImage*)image Name:(NSString*)name Round:(int)round Action:(BOOL)action_enabled;

@end
