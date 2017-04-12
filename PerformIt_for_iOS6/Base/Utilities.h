//
//  Utilities.h
//  PerformIt
//
//  Created by Mihai Puscas on 4/29/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "NSData+Base64.h"
#import "UserData.h"

@interface Utilities : NSObject
{
    
}

+ (UIFont*)fontWithName:(NSString *)fontName minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize constrainedToSize:(CGSize)labelSize forText:(NSString*)text;
+ (UIImage *) imageWithView:(UIView *)view;
+ (NSString *)documentsDirectoryPath;
+ (NSString*)formatNumber:(int)number;
+ (BOOL)deleteRecordedFile:(NSString*)filename fron:(NSString*)from;
+ (BOOL) saveVideo:(NSURL *)fileURL To:(NSString*)filename;
+ (NSString*) formatCounterToString:(int)value;

+ (NSMutableArray*)generateFreeBrushes;
+ (NSMutableArray*)generatePackageBrushes;
+ (NSMutableArray*)generateAllBrushes;

+ (NSMutableArray*)generateFreeColors;
+ (NSMutableArray*)generatePackageColors;
+ (NSMutableArray*)generateAllColors;

+ (UIColor*)colorFromDict:(NSDictionary*)dict;
+ (UIImage *)negativeImage:(UIImage*)image;

+ (void)saveUserInfo:(UserData*)userData;
+ (UserData*)loadUserInfo;
+ (NSMutableArray*)groupAlphabeticallyArray:(NSMutableArray *)list;
+ (BOOL) cacheImage:(NSString *) ImageURLString Filename:(NSString*)filename;
+ (UIImage *) getCachedImage:(NSString *)filename;
+ (NSString*)formatCoins:(int)coins;
+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length;
+ (NSString*)randomizeString:(NSString*)string;

+ (NSData *)base64DataFromString: (NSString *)string;
+ (NSString *)Base64Encode:(NSData *)data;

+ (void) mergeVideoURL:(NSString*)videoPath withAudioURL:(NSString*)audiopath ToVideoPath:(NSString*)finalVideoPath;
+ (CVPixelBufferRef) pixelBufferFromCGImage:(CGImageRef)image Size:(CGSize)size;
+ (NSString*)createShareLink:(int)game_round_id Owner:(BOOL)owner;
+ (NSString*)shortenURL:(NSString*)url;
+ (BOOL) validEmail:(NSString*) emailString;
+ (NSString *)saveImageToDevice:(UIImage *)image withName:(NSString *)imageName extension:(NSString *)ext;


@end
