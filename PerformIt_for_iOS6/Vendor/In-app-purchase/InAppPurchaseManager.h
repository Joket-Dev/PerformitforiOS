// InAppPurchaseManager.h

#import <StoreKit/StoreKit.h>

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProduct *product;
    SKProductsRequest *productsRequest;
    SKPaymentTransaction *currentTransaction;
}

- (void)requestProductData:(NSArray*)products;
- (void)loadStore:(NSArray*)products;
- (BOOL)canMakePurchases;
-(void)purchaseProduct:(SKProduct*)myProduct;
- (void)finishCurrentTransaction:(BOOL)wasSuccesfull;

@end
