//
//  Utilities.m
//  PerformIt
//
//  Created by Mihai Puscas on 4/29/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "Utilities.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "RecordWordViewController.h"
#import "GamePlayViewController.h"
// helpers
//#include "CAXException.h"
//#include "CAStreamBasicDescription.h"
#define ROUND_UP(N, S) ((((N) + (S) - 1) / (S)) * (S))


@implementation Utilities

+ (NSString *)saveImageToDevice:(UIImage *)image withName:(NSString *)imageName extension:(NSString *)ext
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * fileName = [NSString stringWithFormat:@"%@.%@",imageName, [ext lowercaseString]];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSError * error;
    if ([[ext lowercaseString] isEqualToString:@"png"])
    {
        [UIImagePNGRepresentation(image) writeToFile:localFilePath options:NSDataWritingAtomic error:&error];
    }
    else if ([[ext lowercaseString] isEqualToString:@"jpg"] || [[ext lowercaseString] isEqualToString:@"jpeg"])
    {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:localFilePath options:NSDataWritingAtomic error:&error];
    }
    else
    {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", ext);
        return [NSString stringWithFormat:@""];
    }
//    if(error != NULL)
//    {
//        NSLog(@"error saving image: %@", error);
//    }
    
    return localFilePath;
}

+ (UIFont*)fontWithName:(NSString *)fontName minSize:(CGFloat)minSize maxSize:(CGFloat)maxSize constrainedToSize:(CGSize)labelSize forText:(NSString*)text
{
    UIFont* font;
    if(fontName != nil)
        font = [UIFont fontWithName:fontName size:maxSize];
    else
        font = [UIFont systemFontOfSize:maxSize];
    
    CGSize constraintSize = CGSizeMake(labelSize.width, MAXFLOAT);
    NSRange range = NSMakeRange(minSize, maxSize);
    
    int fontSize = 0;
    for (NSInteger i = maxSize; i > minSize; i--)
    {
        fontSize = ceil(((float)range.length + (float)range.location) / 2.0);
        
        font = [font fontWithSize:fontSize];
        CGSize size = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
        if (size.height <= labelSize.height)
            range.location = fontSize;
        else
            range.length = fontSize - 1;
        
        if (range.length == range.location)
        {
            font = [font fontWithSize:range.location];
            break;
        }
    }
    
    return font;
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (NSString *)documentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    return documentsDirectoryPath;
}

+ (NSString*)formatNumber:(int)number
{
    NSString *string = [NSString stringWithFormat:@"%d",number];
    if([string length] > 3)
    {
        NSMutableString *tempString = [[NSMutableString alloc] init];
        [tempString setString:string];
        [tempString insertString:@"." atIndex:[tempString length]-3];
        return tempString ;
    }
    return string;
}

+ (BOOL)deleteRecordedFile:(NSString*)filename fron:(NSString*)from
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *cacheFiles = [fileManager contentsOfDirectoryAtPath:from error:&error];
    for (NSString *file in cacheFiles)
    {
        error = nil;
        if([file isEqualToString:filename])
        {
            [fileManager removeItemAtPath:[from stringByAppendingPathComponent:file] error:&error];
            return YES;
        }
    }
    return NO;
}

+ (BOOL) saveVideo:(NSURL *)fileURL To:(NSString*)filename
{
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/%@.mov", filename];
	NSError	*error;
    
//    AVAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
//    AVMutableComposition *videoComposition = [AVMutableComposition composition];
//    AVMutableCompositionTrack *compositionVideoTrack = [videoComposition  addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//    
//    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    
//    AVMutableVideoComposition* videoComposition = [[AVMutableVideoComposition videoComposition]retain];
//    videoComposition.renderSize = CGSizeMake(320, 240);
//    videoComposition.frameDuration = CMTimeMake(1, 30);
//    
//    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );
//    
//    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
//    CGAffineTransform finalTransform = // setup a transform that grows the video, effectively causing a crop
//    [transformer setTransform:finalTransform atTime:kCMTimeZero];
//    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
//    videoComposition.instructions = [NSArray arrayWithObject: instruction];
//    
//    exporter = [[AVAssetExportSession alloc] initWithAsset:saveComposition presetName:AVAssetExportPresetHighestQuality] ;
//    exporter.videoComposition = videoComposition;
//    exporter.outputURL=url3;
//    exporter.outputFileType=AVFileTypeQuickTimeMovie;
//    
//    [exporter exportAsynchronouslyWithCompletionHandler:^(void){}];
    
	if ([[NSFileManager defaultManager] copyItemAtURL:fileURL toURL:[NSURL fileURLWithPath:destinationPath] error:&error])
    {
        return YES;
    }
    return NO;
}

+ (NSData *)base64DataFromString: (NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    return theData;
}

+ (NSString *)Base64Encode:(NSData *)data
{
    //Point to start of the data and set buffer sizes
    int inLength = (int)[data length];
    int outLength = ((((inLength * 4)/3)/4)*4) + (((inLength * 4)/3)%4 ? 4 : 0);
    const char *inputBuffer = [data bytes];
    char *outputBuffer = malloc(outLength);
    outputBuffer[outLength] = 0;
    
    //64 digit code
    static char Encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    //start the count
    int cycle = 0;
    int inpos = 0;
    int outpos = 0;
    char temp;
    
    //Pad the last to bytes, the outbuffer must always be a multiple of 4
    outputBuffer[outLength-1] = '=';
    outputBuffer[outLength-2] = '=';
    
    /* http://en.wikipedia.org/wiki/Base64
     Text content   M           a           n
     ASCII          77          97          110
     8 Bit pattern  01001101    01100001    01101110
     
     6 Bit pattern  010011  010110  000101  101110
     Index          19      22      5       46
     Base64-encoded T       W       F       u
     */
    
    while (inpos < inLength){
        switch (cycle) {
            case 0:
                outputBuffer[outpos++] = Encode[(inputBuffer[inpos]&0xFC)>>2];
                cycle = 1;
                break;
            case 1:
                temp = (inputBuffer[inpos++]&0x03)<<4;
                outputBuffer[outpos] = Encode[temp];
                cycle = 2;
                break;
            case 2:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xF0)>> 4];
                temp = (inputBuffer[inpos++]&0x0F)<<2;
                outputBuffer[outpos] = Encode[temp];
                cycle = 3;
                break;
            case 3:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xC0)>>6];
                cycle = 4;
                break;
            case 4:
                outputBuffer[outpos++] = Encode[inputBuffer[inpos++]&0x3f];
                cycle = 0;
                break;
            default:
                cycle = 0;
                break;
        }
    }
    NSString *pictemp = [NSString stringWithUTF8String:outputBuffer];
    free(outputBuffer);
    
    return pictemp;
}

+ (NSString*) formatCounterToString:(int)value
{
    NSString *string = [NSString stringWithFormat:@"%02d", value];
    return string;
}

+ (CVPixelBufferRef) pixelBufferFromCGImage:(CGImageRef)image Size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
                                          size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    status=status;//Added to make the stupid compiler not show a stupid warning.
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    
    //    CGContextTranslateCTM(context, 0.0, CGImageGetHeight(image));
    //    CGContextScaleCTM(context, 1.0, -1.0);//Flip vertically to account for different origin
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image)*2,
                                           CGImageGetHeight(image)*2), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

+ (void) mergeVideoURL:(NSString*)videoPath withAudioURL:(NSString*)audiopath ToVideoPath:(NSString*)finalVideoPath
{

    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/audio-bg.mp4",[Utilities documentsDirectoryPath]]])
    {
        [[NSFileManager defaultManager] copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"audio-bg.mp4"] toPath:[[Utilities documentsDirectoryPath] stringByAppendingPathComponent:@"audio-bg.mp4"]error:nil];
    }
    
    NSURL *videoURL = [NSURL fileURLWithPath: [NSString stringWithFormat:@"%@/%@",[Utilities documentsDirectoryPath],videoPath]];
    NSURL *audioURL = [NSURL fileURLWithPath: [NSString stringWithFormat:@"%@/%@",[Utilities documentsDirectoryPath],audiopath]];
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    
    //merge the two assets (sound with video)
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    NSLog(@"audio =%@",audioAsset);
    NSLog(@"video =%@",videoAsset);
    
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough];
        
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:finalVideoPath];
    NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    //removing if exists
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    NSLog(@"file type %@",_assetExport.outputFileType);
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void )
     {         
         NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
         NSString  *documentsDirectory = [paths  objectAtIndex:0];
         NSString  *oldappSettingsPath = [documentsDirectory stringByAppendingPathComponent:finalVideoPath];
         
         if ([[NSFileManager defaultManager] fileExistsAtPath:oldappSettingsPath])
         {
             NSFileManager *fileManager = [NSFileManager defaultManager];
             [fileManager removeItemAtPath: oldappSettingsPath error:NULL];
         }
         
         NSURL *documentDirectoryURL = [NSURL fileURLWithPath:oldappSettingsPath];
         [[NSFileManager defaultManager] copyItemAtURL:exportUrl toURL:documentDirectoryURL error:nil];
//         [audioAsset release];
//         [videoAsset release];
//         [_assetExport release];
         
         //save file to gallery
         AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
         UIViewController *topController = appDelegate.window.rootViewController;
         while (topController.presentedViewController)
         {
             NSLog(@"%@",topController.presentedViewController);
             topController = topController.presentedViewController;
         }
         
         if([topController isKindOfClass:[RecordWordViewController class]])
         {
             RecordWordViewController *rec = (RecordWordViewController*)topController;
             [rec saveAudioRecordingToGallery:oldappSettingsPath];
         }
         if([topController isKindOfClass:[GamePlayViewController class]])
         {
             GamePlayViewController *gamePlayViewController = (GamePlayViewController*)topController;
             [gamePlayViewController saveAudioRecordingToGallery:oldappSettingsPath];
         }
        }
     ];
}

+ (UIImage *)negativeImage:(UIImage*)image
{
    // get width and height as integers, since we'll be using them as
    // array subscripts, etc, and this'll save a whole lot of casting
    CGSize size = image.size;
    int width = size.width;
    int height = size.height;
    
    // Create a suitable RGB+alpha bitmap context in BGRA colour space
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *memoryPool = (unsigned char *)calloc(width*height*4, 1);
    CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    // draw the current image to the newly created context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    // run through every pixel, a scan line at a time...
    for(int y = 0; y < height; y++)
    {
        // get a pointer to the start of this scan line
        unsigned char *linePointer = &memoryPool[y * width * 4];
        
        // step through the pixels one by one...
        for(int x = 0; x < width; x++)
        {
            // get RGB values. We're dealing with premultiplied alpha
            // here, so we need to divide by the alpha channel (if it
            // isn't zero, of course) to get uninflected RGB. We
            // multiply by 255 to keep precision while still using
            // integers
            int r, g, b;
            if(linePointer[3])
            {
                r = linePointer[0] * 255 / linePointer[3];
                g = linePointer[1] * 255 / linePointer[3];
                b = linePointer[2] * 255 / linePointer[3];
            }
            else
                r = g = b = 0;
            
            // perform the colour inversion
            r = 0;//255 - r;
            g = 0;//255 - g;
            b = 0;//255 - b;
            
            // multiply by alpha again, divide by 255 to undo the
            // scaling before, store the new values and advance
            // the pointer we're reading pixel data from
            linePointer[0] = r * linePointer[3] / 255;
            linePointer[1] = g * linePointer[3] / 255;
            linePointer[2] = b * linePointer[3] / 255;
            //linePointer[3] = 0;
            linePointer += 4;
        }
    }
    
    // get a CG image from the context, wrap that into a
    // UIImage
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    
    // clean up
    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(memoryPool);
    
    // and return
    return returnImage;
}

+ (NSMutableArray*)generateFreeColors
{
    NSMutableArray *colors = [[NSMutableArray alloc]init];

    NSMutableDictionary *colorDict = [[NSMutableDictionary alloc]init];
    
    //black
    [colorDict setValue:[NSString stringWithFormat:@"%f",0/255.0] forKey:@"red"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",0/255.0] forKey:@"green"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",0/255.0] forKey:@"blue"];
    [colors addObject:colorDict];
//    [colorDict release];
    
    //white
    colorDict = [[NSMutableDictionary alloc]init];
    [colorDict setValue:[NSString stringWithFormat:@"%f",255.0/255.0] forKey:@"red"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",255.0/255.0] forKey:@"green"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",255.0/255.0] forKey:@"blue"];
    [colors addObject:colorDict];
//    [colorDict release];
    
    //red
    colorDict = [[NSMutableDictionary alloc]init];
    [colorDict setValue:[NSString stringWithFormat:@"%f",241.0/255.0] forKey:@"red"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",24.0/255.0] forKey:@"green"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",24.0/255.0] forKey:@"blue"];
    [colors addObject:colorDict];
//    [colorDict release];
    
    //brown
    colorDict = [[NSMutableDictionary alloc]init];
    [colorDict setValue:[NSString stringWithFormat:@"%f",135.0/255.0] forKey:@"red"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",108.0/255.0] forKey:@"green"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",80.0/255.0] forKey:@"blue"];
    [colors addObject:colorDict];
//    [colorDict release];

    // blue
    colorDict = [[NSMutableDictionary alloc]init];
    [colorDict setValue:[NSString stringWithFormat:@"%f",22.0/255.0] forKey:@"red"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",100.0/255.0] forKey:@"green"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",247.0/255.0] forKey:@"blue"];
    [colors addObject:colorDict];
//    [colorDict release];
    
    // yellow
    colorDict = [[NSMutableDictionary alloc]init];
    [colorDict setValue:[NSString stringWithFormat:@"%f",227.0/255.0] forKey:@"red"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",241.0/255.0] forKey:@"green"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",22.0/255.0] forKey:@"blue"];
    [colors addObject:colorDict];
//    [colorDict release];
    
    return colors;
}

+ (NSMutableArray*)generatePackageColors
{
    NSMutableArray *colors = [[NSMutableArray alloc]init] ;
    
    NSMutableDictionary *colorDict = [[NSMutableDictionary alloc]init];
    //pink
    [colorDict setValue:[NSString stringWithFormat:@"%f",222.0/255.0] forKey:@"red"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",33.0/255.0] forKey:@"green"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",241.0/255.0] forKey:@"blue"];
    [colors addObject:colorDict];
//    [colorDict release];
    
    
    //green
    colorDict = [[NSMutableDictionary alloc]init];
    [colorDict setValue:[NSString stringWithFormat:@"%f",31.0/255.0] forKey:@"red"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",241.0/255.0] forKey:@"green"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",58.0/255.0] forKey:@"blue"];
    [colors addObject:colorDict];
//    [colorDict release];
    
    //purple
    colorDict = [[NSMutableDictionary alloc]init];
    [colorDict setValue:[NSString stringWithFormat:@"%f",110.0/255.0] forKey:@"red"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",28.0/255.0] forKey:@"green"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",150.0/255.0] forKey:@"blue"];
    [colors addObject:colorDict];
//    [colorDict release];
    
    //orange
    colorDict = [[NSMutableDictionary alloc]init];
    [colorDict setValue:[NSString stringWithFormat:@"%f",255.0/255.0] forKey:@"red"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",182.0/255.0] forKey:@"green"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",24.0/255.0] forKey:@"blue"];
    [colors addObject:colorDict];
//    [colorDict release];
    
    //grey
    colorDict = [[NSMutableDictionary alloc]init];
    [colorDict setValue:[NSString stringWithFormat:@"%f",133.0/255.0] forKey:@"red"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",133.0/255.0] forKey:@"green"];
    [colorDict setValue:[NSString stringWithFormat:@"%f",133.0/255.0] forKey:@"blue"];
    [colors addObject:colorDict];
//    [colorDict release];
    return colors;
}

+ (NSMutableArray*)generateAllColors
{
    NSMutableArray *colors = [[NSMutableArray alloc]init];
    
    // Red to Yellow
    int red   = 255;
    int green = 0;
    int blue  = 0;
    
    for (green = 0; green <=255; green+=15)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithFloat:red/255.0]     forKey:@"red"];
        [dic setObject:[NSNumber numberWithFloat:green/255.0]   forKey:@"green"];
        [dic setObject:[NSNumber numberWithFloat:blue/255.0]    forKey:@"blue"];
        [colors addObject:dic];
//        [dic release];
    }
    
    // Yellow to Green
//    red   = 255;
//    green = 255;
//    blue  = 0;
    
    for (red = 240; red >=0; red-=15)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithFloat:red/255.0]     forKey:@"red"];
        [dic setObject:[NSNumber numberWithFloat:green/255.0]   forKey:@"green"];
        [dic setObject:[NSNumber numberWithFloat:blue/255.0]    forKey:@"blue"];
        [colors addObject:dic];
//        [dic release];
    }
    
    //Green to Cyan
    red   = 0;
    green = 255;
    blue  = 0;
    
    for (blue = 15; blue <= 255; blue+=15)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithFloat:red/255.0]     forKey:@"red"];
        [dic setObject:[NSNumber numberWithFloat:green/255.0]   forKey:@"green"];
        [dic setObject:[NSNumber numberWithFloat:blue/255.0]    forKey:@"blue"];
        [colors addObject:dic];
//        [dic release];
    }
    
    //Cyan to Blue
    red   = 0;
    green = 255;
    blue  = 255;
    
    for (green = 240; green >= 0; green-=15)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithFloat:red/255.0]     forKey:@"red"];
        [dic setObject:[NSNumber numberWithFloat:green/255.0]   forKey:@"green"];
        [dic setObject:[NSNumber numberWithFloat:blue/255.0]    forKey:@"blue"];
        [colors addObject:dic];
//        [dic release];
    }
    
    //Blue to Magenta
    red   = 0;
    green = 0;
    blue  = 255;
    
    for (red = 15; red <= 255; red+=15)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithFloat:red/255.0]     forKey:@"red"];
        [dic setObject:[NSNumber numberWithFloat:green/255.0]   forKey:@"green"];
        [dic setObject:[NSNumber numberWithFloat:blue/255.0]    forKey:@"blue"];
        [colors addObject:dic];
//        [dic release];
    }
    
    //Magenta to Red
    red   = 255;
    green = 0;
    blue  = 255;
    
    for (blue = 240; blue >= 15; blue-=15)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithFloat:red/255.0]     forKey:@"red"];
        [dic setObject:[NSNumber numberWithFloat:green/255.0]   forKey:@"green"];
        [dic setObject:[NSNumber numberWithFloat:blue/255.0]    forKey:@"blue"];
        [colors addObject:dic];
//        [dic release];
    }
    
    //Black to yellow
    red   = 0;
    green = 0;
    blue  = 0;
    
    for (int i = 0; i <= 255; i+=25)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        red   = i;
        green = i;
        blue  = i;
        if(red > 249)
            red = 255;
        if(green > 249)
            green = 255;
        if(blue > 249)
            blue = 255;
        [dic setObject:[NSNumber numberWithFloat:red/255.0]     forKey:@"red"];
        [dic setObject:[NSNumber numberWithFloat:green/255.0]   forKey:@"green"];
        [dic setObject:[NSNumber numberWithFloat:blue/255.0]    forKey:@"blue"];
        [colors addObject:dic];
//        [dic release];
    }

    return colors;
}

+ (NSMutableArray*)generateFreeBrushes
{
    NSMutableArray *brushes = [[NSMutableArray alloc]init];
    [brushes addObject:@"circle-brush.png"];
    return brushes;
}


+ (NSMutableArray*)generatePackageBrushes
{
    NSMutableArray *brushes = [[NSMutableArray alloc]init];
    [brushes addObject:@"square-brush.png"];
    [brushes addObject:@"triangle-brush.png"];
    [brushes addObject:@"star-brush.png"];

    return brushes;
}

+ (NSMutableArray*)generateAllBrushes
{
    NSMutableArray *brushes = [[NSMutableArray alloc]init];
    [brushes addObject:@"circle-brush.png"];
    [brushes addObject:@"square-brush.png"];
    [brushes addObject:@"triangle-brush.png"];
    [brushes addObject:@"star-brush.png"];
    [brushes addObject:@"oval-brush.png"];
    [brushes addObject:@"hashtag-brush.png"];
    [brushes addObject:@"smiley-brush.png"];
    [brushes addObject:@"peace-brush.png"];
    [brushes addObject:@"cross-brush.png"];
    [brushes addObject:@"moon-brush.png"];
    [brushes addObject:@"heart-brush.png"];
    [brushes addObject:@"arrow-brush.png"];
    [brushes addObject:@"quotation-brush.png"];
    return brushes;
}

+ (void)saveUserInfo:(UserData*)userData
{
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userData.username forKey:@"username"];
    [defaults setObject:userData.password forKey:@"password"];
    [defaults setObject:userData.email forKey:@"email"];
    [defaults setObject:userData.name forKey:@"name"];
    [defaults setObject:userData.facebookID forKey:@"facebook_id"];
    [defaults setObject:userData.facebookAccessToken forKey:@"facebook_access_token"];
    [defaults setInteger:userData.coins forKey:@"coins"];
    [defaults setInteger:userData.bubbles forKey:@"bubbles"];
    [defaults setBool:userData.soundsEnabled forKey:@"sounds_enabled"];
    [defaults setBool:userData.validLogin forKey:@"valid_login"];
    [defaults setObject:userData.deviceID forKey:@"device_id"];
    [defaults setObject:userData.token forKey:@"token"];
    [defaults setObject:userData.loginType forKey:@"login_type"];
    [defaults setInteger:userData.userID forKey:@"user_id"];
    [defaults setObject:userData.token forKey:@"token"];
    [defaults setObject:userData.userphotourl forKey:@"picture"];
    
    [defaults synchronize];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Used data saved");
}

+ (UserData*)loadUserInfo
{
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"valid_login"]boolValue])
        return nil;
    UserData *userData = [[UserData alloc]init];
    [userData setUsername:[defaults objectForKey:@"username"]];
    [userData setPassword:[defaults objectForKey:@"password"]];
    [userData setEmail:[defaults objectForKey:@"email"]];
    [userData setName:[defaults objectForKey:@"name"]];
    [userData setFacebookID:[defaults objectForKey:@"facebook_id"]];
    [userData setFacebookAccessToken:[defaults objectForKey:@"facebook_access_token"]];
    [userData setCoins:[[defaults objectForKey:@"coins"]intValue]];
    [userData setBubbles:[[defaults objectForKey:@"bubbles"]intValue]];
    [userData setSoundsEnabled:[[defaults objectForKey:@"sounds_enabled"]boolValue]];
    [userData setValidLogin:[[defaults objectForKey:@"valid_login"]boolValue]];
    [userData setDeviceID:[defaults objectForKey:@"device_id"]];
    [userData setToken:[defaults objectForKey:@"token"]];
    [userData setLoginType:[defaults objectForKey:@"login_type"]];
    [userData setUserID:[[defaults objectForKey:@"user_id"]intValue]];
    [userData setToken:[defaults objectForKey:@"token"]];
    [userData setUserphotourl:[defaults objectForKey:@"picture"]];

    NSLog(@"User data loaded");
    return userData;
}

+ (NSMutableArray*)groupAlphabeticallyArray:(NSMutableArray *)list
{
    NSMutableArray *tempList = [[NSMutableArray alloc]init];
    for (int i=0; i < [list count]; i++)
    {
        [tempList addObject:[NSString stringWithFormat:@"%@ %@",[[list objectAtIndex:i] objectForKey:@"firstname"],[[list objectAtIndex:i] objectForKey:@"lastname"]]];
    }
    [tempList sortUsingSelector:@selector(compare:)];
    
    NSMutableArray *groupedArray = [[NSMutableArray alloc] init];
    NSMutableArray *sameLetterFriends = [[NSMutableArray alloc] init];
    NSString *initialLetter = @"";
    for(int i = 0; i < [tempList count]; i++)
    {
        NSString *friend = [tempList objectAtIndex:i];
        NSString *firstLetter = [[friend substringToIndex:1] uppercaseString];
        if ([firstLetter isEqualToString:initialLetter] || [firstLetter length] == 0)
        {
            [sameLetterFriends addObject:friend];
        }else
        {
            NSMutableDictionary *section=[[NSMutableDictionary alloc] init];
            [section setValue:initialLetter forKey:@"headerName"];
            [section setValue:sameLetterFriends forKey:@"rowValue"];
            
            [groupedArray addObject:section];
            
            initialLetter = firstLetter;
//            [section release];
//            [sameLetterFriends release];
            
            sameLetterFriends = [[NSMutableArray alloc] init];
            [sameLetterFriends addObject:friend];
        }
    }
//    [tempList release];
    NSMutableDictionary *section=[[NSMutableDictionary alloc] init];
    [section setValue:initialLetter forKey:@"headerName"];
    [section setValue:sameLetterFriends forKey:@"rowValue"];
    [groupedArray addObject:section];
    
//    [sameLetterFriends release];
//    [section release];
    
    [groupedArray removeObjectAtIndex:0];
    return groupedArray;
}

+ (BOOL) cacheImage:(NSString *) ImageURLString Filename:(NSString*)filename
{
    BOOL saveOK = NO;
    NSURL *ImageURL = [NSURL URLWithString: ImageURLString];
    
    if([ImageURLString length] > 0)
    {
        NSString *uniquePath = [[self documentsDirectoryPath] stringByAppendingPathComponent: filename];
        
//        if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
//        {
            NSData *data = [[NSData alloc] initWithContentsOfURL: ImageURL];
            UIImage *image = [[UIImage alloc] initWithData: data];
            
            if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
            {
                saveOK = [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
            }
            else
            if( [ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound ||
               [ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound)
            {
                saveOK = [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
            }else
                saveOK = [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];

//            [data release];
//        }
    }
    return saveOK;
}

+ (UIImage *) getCachedImage:(NSString *)filename
{
    if([filename length] > 0)
    {
        NSString *uniquePath = [[self documentsDirectoryPath] stringByAppendingPathComponent: filename];
        UIImage *image;
        
        // Check for a cached version
        if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
        {
            image = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
            return image;
        }
        else
        {
            return nil;
        }
        
        return image;
    }
    return nil;
}

+ (NSString*)formatCoins:(int)coins
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"%d",coins];
    if(coins > 999 && coins < 9999+1)
    {
        [string insertString:@"," atIndex:1];
    }
    if(coins > 9999 && coins < 99999+1)
    {
        [string insertString:@"," atIndex:2];
    }
    if(coins > 99999 && coins < 999999+1)
    {
        [string insertString:@"," atIndex:3];
    }
    if(coins > 999999 && coins < 9999999+1)
    {
        [string insertString:@"," atIndex:1];
        [string insertString:@"," atIndex:5];
    }
    return  string;
}

+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    return randomString;
}

+ (NSString*)randomizeString:(NSString*)string
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < [string length]; i++)
    {
        [array addObject:[string substringWithRange:NSMakeRange(i, 1)]];
    }
    NSMutableArray *randomizedarray = [NSMutableArray arrayWithCapacity:[array count]];
    NSMutableArray *copy = [[NSMutableArray alloc]init];
    [copy setArray:array];

    while ([copy count] > 0)
    {
        int index = arc4random() % [copy count];
        id objectToMove = [copy objectAtIndex:index];
        [randomizedarray addObject:objectToMove];
        [copy removeObjectAtIndex:index];
    }
//    [array release];
//    [copy release];
    
    NSString *stringOut = @"";
    for (NSString *stringObj in randomizedarray)
    {
        stringOut = [stringOut stringByAppendingString: [NSString stringWithFormat:@"%@",stringObj]];
    }
    return stringOut;
}

+ (UIColor*)colorFromDict:(NSDictionary*)dict
{
    UIColor *color = [UIColor colorWithRed:[[dict objectForKey:@"red"]floatValue]
                                     green:[[dict objectForKey:@"green"]floatValue]
                                      blue:[[dict objectForKey:@"blue"]floatValue]
                                     alpha:1.0];
    return color;
}

+ (NSString*)createShareLink:(int)game_round_id Owner:(BOOL)owner
{
    return [NSString stringWithFormat:@"%@/web/share/%d/%d",shareBaseUrl, game_round_id, owner];
}

+ (NSString*)shortenURL:(NSString*)url
{
    NSString *newUrl = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=%@&apikey=%@&longUrl=%@&format=txt", kBitlyUsername, kBitlyApiKey, url]] encoding:NSUTF8StringEncoding error:nil];
    return  newUrl;
}

+ (BOOL) validEmail:(NSString*) emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
//    [regEx release];
    if (regExMatches == 0)
    {
        return NO;
    } else
        return YES;
}
@end
