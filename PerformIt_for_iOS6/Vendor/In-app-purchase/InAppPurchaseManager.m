//
// InAppPurchaseManager.m
#import "InAppPurchaseManager.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "CoinsViewController.h"
#import "DrawViewController.h"
#import "RecordWordViewController.h"
#import "GamePlayViewController.h"

@implementation InAppPurchaseManager

- (void)requestProductData:(NSArray*)products
{
    NSSet *productIdentifiers = [NSSet setWithArray:products];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    
    for (int i=0; i<[products count]; i++)
    {
        product = [products objectAtIndex:i];              
        AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        for (int j = 0; j < [appDelegate.inAppCoins count]; j++)
        {
            if([[NSString stringWithFormat:@"%@%@",kCoinsInapp,[[appDelegate.inAppCoins objectAtIndex:j]objectForKey:@"coins"]]isEqualToString:product.productIdentifier])
            {
                [[appDelegate.inAppCoins objectAtIndex:j] setValue:@"YES" forKey:@"available"];
                [[appDelegate.inAppCoins objectAtIndex:j] setValue:product forKey:@"product"];
            }
        }
//        for (int j = 0; j < [appDelegate.inAppPacketsArray count]; j++)
//        {
//            if([[NSString stringWithFormat:@"%@%@",kPacketsInapp,[[appDelegate.inAppPacketsArray objectAtIndex:j]objectForKey:@"packet"]]isEqualToString:product.productIdentifier])
//            {
//                [[appDelegate.inAppPacketsArray objectAtIndex:j] setValue:@"YES" forKey:@"available"];
//                [[appDelegate.inAppPacketsArray objectAtIndex:j] setValue:product forKey:@"product"];
//            }
//        }
//        NSLog(@"%@",appDelegate.inAppPacketsArray);
    }
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
//    [productsRequest release];
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
} 

#pragma - 
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore:(NSArray*)products
{
    if([self canMakePurchases])
        NSLog(@"Purchases available");
    else
        NSLog(@"Purchases not available");
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // get the product description (defined in early sections)
    [self requestProductData:products];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//

-(void)purchaseProduct:(SKProduct*)myProduct
{
    NSLog(@"buy product:%@",myProduct.productIdentifier);
    
    SKPayment *payment = [SKPayment paymentWithProduct:myProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];    
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{   
    NSLog(@"record");
    [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:transaction.payment.productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//
// enable pro features
//
//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

- (void)provideContent:(NSString *)productId transaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"%@",productId);
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.currentlyBuying)
    {
        currentTransaction = transaction;
        
        UIViewController *topController = appDelegate.window.rootViewController;
        while (topController.presentedViewController)
        {
            NSLog(@"%@",topController.presentedViewController);
            topController = topController.presentedViewController;
        }
        if([topController isKindOfClass:[CoinsViewController class]])
        {
            CoinsViewController *coinsViewController = (CoinsViewController*)topController;
            [coinsViewController buyCoinsWithTRansaction:transaction];
            return;
        }
    }else
    {
        [self finishTransaction:transaction wasSuccessful:NO];
    }
}

- (void)finishCurrentTransaction:(BOOL)wasSuccesfull
{
    [self finishTransaction:currentTransaction wasSuccessful:wasSuccesfull];
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"complete");
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier transaction:transaction];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier transaction:transaction];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIViewController *topController = appDelegate.window.rootViewController;
    while (topController.presentedViewController)
    {
        NSLog(@"%@",topController.presentedViewController);
        topController = topController.presentedViewController;
    }
    
    NSLog(@"%@",[appDelegate.window.rootViewController.navigationController topViewController]);
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"%@",transaction.error.userInfo);
        [self finishTransaction:transaction wasSuccessful:NO];
        //check if user can connect to itunes store
        if(transaction.error.code == 0 && appDelegate.currentlyBuying)
            [appDelegate showAlert:@"Store not available" CancelButton:nil OkButton:@"OK" Type:storeNotAvailableAlert Sender:topController];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    [appDelegate setCurrentlyBuying:NO];

    [appDelegate hideLoadingActivity];
    //re enable timers and iamge/ video/a audio
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"update");
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSLog(@"%d",transaction.transactionState);

        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
} 

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"xxx");
}

@end


