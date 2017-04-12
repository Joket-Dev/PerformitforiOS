//
//  ToolBox.h
//  PerformIt
//
//  Created by Mihai Puscas on 5/20/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolBox : UIButton
{
    BOOL selected;
    NSMutableArray *itemsArray;
    int selectedItem;
}
@property (nonatomic) BOOL selected;
@property (nonatomic, retain) NSMutableArray *itemsArray;
@property (nonatomic) int selectedItem;

- (id)initWithFrame:(CGRect)frame andItems:(NSMutableArray*)items;

@end
