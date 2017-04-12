//
//  AlertDialog.m
//  PikasMedia
//
//  Created by Mihai Puscas on 2/14/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "AlertDialog.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation AlertDialog

- (id)initWithFrame:(CGRect)frame Message:(NSString*)message CancelButton:(NSString*)cancelButton OKButton:(NSString*)okButton AlertType:(int)type Sender:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([appDelegate isIPHONE5])
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 568);
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView *view = [[UIView alloc]initWithFrame:frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.7;
        [self addSubview:view];
//        [view release];
        
        CGSize messageLabelSize;
        if([appDelegate isIOS6])
            messageLabelSize = [message sizeWithFont:[UIFont fontWithName:@"marvin" size:19.0] constrainedToSize:CGSizeMake(285-2*20, (162-10-20-37)) lineBreakMode:NSLineBreakByCharWrapping];
        else
            messageLabelSize = [message sizeWithFont:[UIFont fontWithName:@"marvin" size:19.0] constrainedToSize:CGSizeMake(285-2*20, (162-10-20-37)) lineBreakMode:NSLineBreakByWordWrapping];

        UIView *container = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width-285)/2, (frame.size.height-162)/2, 285, 162)];
        container.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alert-popup-bg.png"]];
        bgIV.frame = CGRectMake(0, 0, 285, 162);
        [container addSubview:bgIV];
//        [bgIV release];
        
        UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake((285-messageLabelSize.width)/2, 10, messageLabelSize.width, (162-10-20-37))];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"marvin" size:17.0];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.numberOfLines = 0;
        messageLabel.text = message;
        [container addSubview:messageLabel];
//        [messageLabel release];
        
        if(cancelButton != nil)
        {
            UIButton *cancelBtn = [[UIButton alloc]init];
            cancelBtn.exclusiveTouch = YES;
            cancelBtn.frame = CGRectMake(30, 162-20-37, 88, 37);
            [cancelBtn setBackgroundImage:[UIImage imageNamed:@"alert-button.png"] forState:UIControlStateNormal];
            [cancelBtn setTitle:cancelButton forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = [UIFont fontWithName:@"marvin" size:20];
            [cancelBtn setTitleColor:[UIColor colorWithRed:0.07 green:0.33 blue:0.48 alpha:1.0] forState:UIControlStateNormal];
            [cancelBtn addTarget:sender action:@selector(alertCancelBtnTUI:) forControlEvents:UIControlEventTouchUpInside];
            cancelBtn.tag = type;
            [container addSubview:cancelBtn];
//            [cancelBtn release];
            
            UIButton *okBtn = [[UIButton alloc]init];
            okBtn.exclusiveTouch = YES;
            okBtn.frame = CGRectMake(285-30-88, 162-20-37, 88, 37);
            [okBtn setBackgroundImage:[UIImage imageNamed:@"alert-button.png"] forState:UIControlStateNormal];
            [okBtn setTitle:okButton forState:UIControlStateNormal];
            okBtn.titleLabel.font = [UIFont fontWithName:@"marvin" size:20];
            [okBtn setTitleColor:[UIColor colorWithRed:0.07 green:0.33 blue:0.48 alpha:1.0] forState:UIControlStateNormal];
            [okBtn addTarget:sender action:@selector(alertOkBtnTUI:) forControlEvents:UIControlEventTouchUpInside];
            okBtn.tag = type;
            [container addSubview:okBtn];
//            [okBtn release];
        }else
        {
            UIButton *okBtn = [[UIButton alloc]init];
            okBtn.exclusiveTouch = YES;
            okBtn.frame = CGRectMake((285-88)/2, 162-20-37, 88, 37);
            [okBtn setBackgroundImage:[UIImage imageNamed:@"alert-button.png"] forState:UIControlStateNormal];
            [okBtn setTitle:okButton forState:UIControlStateNormal];
            okBtn.titleLabel.font = [UIFont fontWithName:@"marvin" size:20];
            [okBtn setTitleColor:[UIColor colorWithRed:0.07 green:0.33 blue:0.48 alpha:1.0] forState:UIControlStateNormal];
            [okBtn addTarget:sender action:@selector(alertOkBtnTUI:) forControlEvents:UIControlEventTouchUpInside];
            okBtn.tag = type;
            [container addSubview:okBtn];
//            [okBtn release];
        }
        
        [self addSubview:container];
//        [container release];
    }
    return self;
}


@end
