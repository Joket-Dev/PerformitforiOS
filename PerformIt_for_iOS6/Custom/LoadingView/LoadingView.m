//
//  LoadingView.m
//  PikasMedia
//
//  Created by Mihai Puscas on 2/13/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        loadingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingActivity.frame = CGRectMake((frame.size.width-21)/2,(frame.size.height-21)/2, 21, 21);
        [self addSubview:loadingActivity];
        [loadingActivity startAnimating];
        //[loadingActivity release];
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
    }
    return self;
}


@end
