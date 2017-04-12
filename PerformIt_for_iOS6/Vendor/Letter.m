//
//  Letter.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/15/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "Letter.h"

@implementation Letter
@synthesize draggedToWord;
@synthesize letterText;
@synthesize isExtra;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
