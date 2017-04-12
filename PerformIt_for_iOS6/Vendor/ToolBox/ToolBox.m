//
//  ToolBox.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/20/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "ToolBox.h"

@implementation ToolBox
@synthesize selected, itemsArray,selectedItem;

- (id)initWithFrame:(CGRect)frame andItems:(NSMutableArray*)items
{
    self = [super initWithFrame:frame];
    if (self)
    {
        selected = NO;
        itemsArray = [[NSMutableArray alloc]init];
        [itemsArray setArray:items];
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
