//
//  AboutUsViewController.m
//  PerformIt
//
//  Created by Mihai Puscas on 20/11/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end


@implementation AboutUsViewController
@synthesize backgroundIV;
@synthesize homeButton;
@synthesize mainScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([appDelegate isIPHONE5])
    {
        backgroundIV.image = [UIImage imageNamed:@"about-us-bg-568h@2x.png"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 20, mainScrollView.frame.size.width-2*10, mainScrollView.frame.size.height)];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.gestureRecognizers = nil;
    textView.font = [UIFont systemFontOfSize:16];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor darkGrayColor];
    textView.text = @"The makers of Perform It are a legendary few. They come from places only known to gods and mythical legends. They’ve wrestled with the Loch Ness Monster and played cricket with Sasquatch. One time they were spotted by a homo sapien…and never again. Pictures have surfaced of them and have ‘magically’ lost their opacity right in front of our very own eyes. Some say they live in the benthos, some say they live inside the top of Mount Everest and other believe they don’t live at all. Whatever you believe, Perform It is living proof.";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        [textView sizeToFit];
    
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)].height);
    [mainScrollView addSubview:textView];
//    [textView release];
    
    UIImageView *firstSeparator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about-separator.png"]];
    firstSeparator.frame = CGRectMake(10, textView.frame.origin.y+textView.frame.size.height+5, mainScrollView.frame.size.width-2*10, 1);
    [mainScrollView addSubview:firstSeparator];
//    [firstSeparator release];
    
    
    UITextView *emailTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, firstSeparator.frame.origin.y+firstSeparator.frame.size.height, mainScrollView.frame.size.width-2*10, 80)];
    emailTextView.editable = NO;
    emailTextView.scrollEnabled = NO;
    emailTextView.gestureRecognizers = nil;
    emailTextView.font = [UIFont systemFontOfSize:16];
    emailTextView.backgroundColor = [UIColor clearColor];
    emailTextView.textColor = [UIColor darkGrayColor];
    emailTextView.text = @"If you are still inquisitive, contact the one they call Numby Lewis at numbylewis@gmail.com.";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        [emailTextView sizeToFit];
    
    emailTextView.frame = CGRectMake(emailTextView.frame.origin.x, emailTextView.frame.origin.y, emailTextView.frame.size.width, [emailTextView sizeThatFits:CGSizeMake(emailTextView.frame.size.width, MAXFLOAT)].height);
    [mainScrollView addSubview:emailTextView];
//    [emailTextView release];
    
    UIButton *emailButton = [[UIButton alloc]initWithFrame:CGRectMake((mainScrollView.frame.size.width-84)/2, emailTextView.frame.origin.y+emailTextView.frame.size.height+5, 84, 55)];
    [emailButton setImage:[UIImage imageNamed:@"mail-button.png"] forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(sendEmailButtonTUI:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:emailButton];
//    [emailButton release];
    
    UIImageView *leftSeparator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about-separator.png"]];
    leftSeparator.frame = CGRectMake(10, emailButton.frame.origin.y+emailButton.frame.size.height/2, emailButton.frame.origin.x-10-20, 1);
    [mainScrollView addSubview:leftSeparator];
//    [leftSeparator release];

    UIImageView *rightSeparator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about-separator.png"]];
    rightSeparator.frame = CGRectMake(mainScrollView.frame.size.width-10-leftSeparator.frame.size.width, emailButton.frame.origin.y+emailButton.frame.size.height/2, leftSeparator.frame.size.width, 1);
    [mainScrollView addSubview:rightSeparator];
//    [rightSeparator release];
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, emailButton.frame.origin.y+emailButton.frame.size.height+20);
    //textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.contentSize.height);
    //@"If you are still inquisitive, contact the one they call Numby Lewis at numbylewis@gmail.com.";

}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)homeButtonTUI:(id)sender
{
//    [self.view.window.rootViewController dismissModalViewControllerAnimated:YES];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendEmailButtonTUI:(id)sender
{
    [self sendMailTo:@"numbylewis@gmail.com"];
}


- (void)sendMailTo:(NSString*)recipients
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSArray *toRecipients = [recipients componentsSeparatedByString:@","];
        [mailer setToRecipients:toRecipients];
        [mailer setSubject:@""];
        NSString *emailBody = @"";
        [mailer setMessageBody:emailBody isHTML:NO];
//        [self presentModalViewController:mailer animated:YES];
        [self presentViewController:mailer animated:YES completion:nil];
//        [mailer release];
    }else
    {
        
        [appDelegate showAlert:@"You have no email address set." CancelButton:nil OkButton:@"OK" Type:0 Sender:self];
    }
}

#pragma mark - Email Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
