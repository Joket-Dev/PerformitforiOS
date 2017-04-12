//
//  Letter.h
//  PerformIt
//
//  Created by Mihai Puscas on 5/15/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Letter : UIButton
{
    BOOL draggedToWord;
    NSString *letterText;
    BOOL isExtra;
    
}
@property (nonatomic, assign) BOOL draggedToWord;
@property (nonatomic, strong) NSString *letterText;
@property (nonatomic, assign) BOOL isExtra;

@end
