//
//  LabelBorder.h
//  PerformIt
//
//  Created by Mihai Puscas on 5/3/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelBorder : UILabel
{
    UIColor *borderColor;
}
@property (nonatomic, strong) UIColor *borderColor;

- (id)initWithFrame:(CGRect)frame BorderColor:(UIColor*)color;

@end
