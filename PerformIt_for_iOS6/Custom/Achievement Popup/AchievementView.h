//
//  AchievementView.h
//  PerformIt
//
//  Created by Mihai Puscas on 8/19/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchievementView : UIView
{
}

- (id)initWithFrame:(CGRect)frame AchievementName:(NSString*)name AchievementProgress:(NSString*)progress AchievementDetails:(NSString*)details AchievementCoins:(NSString*)coins AchievementImage:(NSString*)image Sender:(id)sender Type:(int)type;

@end
