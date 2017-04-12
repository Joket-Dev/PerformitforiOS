//
//  AlertDialog.h
//  PikasMedia
//
//  Created by Mihai Puscas on 2/14/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YAlertDialogDelegate <NSObject>

- (void)alertOkBtnTUI:(id)sender;
- (void)alertCancelBtnTUI:(id)sender;

@end

@interface AlertDialog : UIView
{
}

- (id)initWithFrame:(CGRect)frame Message:(NSString*)message CancelButton:(NSString*)cancelButton OKButton:(NSString*)okButton AlertType:(int)type Sender:(id)sender;

@end
