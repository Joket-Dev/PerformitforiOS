//
//  AchievementCellView.h
//  PerformIt
//
//  Created by Mihai Puscas on 5/3/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelBorder.h"

@interface AchievementCellView : UIView
{
}

- (id)initWithFrame:(CGRect)frame AchievementType:(NSString*)type Achieved:(BOOL)achieved Completed:(int)completed From:(int)from AchievementName:(NSString*)name;

@end
