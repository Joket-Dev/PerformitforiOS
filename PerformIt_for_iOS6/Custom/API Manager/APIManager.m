//
//  APIManager.m
//  PerformIt
//
//  Created by Mihai Puscas on 6/3/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "APIManager.h"
#import "Constants.h"


#import "APIManager.h"
#import "JSON.h"
#import <CommonCrypto/CommonDigest.h>
//#import "Base64.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <CommonCrypto/CommonDigest.h>

NSString *k_SecretKey = @"df02#8sd(_@sdfkjh";

double k_ApiTimeout = 20;
int requestTag;
id sender;
ASIHTTPRequest *request;

@implementation APIManager

+ (void) releaseRequest
{
    if (request!=nil)
    {
        [request release];
        request=nil;
    }
}

+ (NSString *) SHA1:(NSString *)str
{
    const char *cStr = [str UTF8String];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(cStr, (CC_LONG)strlen(cStr), result);
	NSString *s = [NSString  stringWithFormat:
				   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
				   result[0], result[1], result[2], result[3], result[4],
				   result[5], result[6], result[7],
				   result[8], result[9], result[10], result[11], result[12],
				   result[13], result[14], result[15],
				   result[16], result[17], result[18], result[19]
				   ];
	return [s lowercaseString];
}

+ (NSString*)MakeSecretKey:(NSString *)requestParams
{
    NSArray *keyArray = [requestParams componentsSeparatedByString:@"&"];
    NSMutableArray *last=[[NSMutableArray alloc] init];
    for(int i=0;i<keyArray.count;i++)
    {
        NSString *hard=[keyArray objectAtIndex:i];
        NSRange range = [hard rangeOfString:@"="];
        NSString *newText = [hard stringByReplacingCharactersInRange:range withString:@"*"];
        NSArray *keyVal = [newText componentsSeparatedByString:@"*"];
        if (keyVal.count > 0)
        {
            NSString *variabl=[[keyVal objectAtIndex:0] stringByAppendingString:k_SecretKey];
            [last addObject:[variabl stringByAppendingString:[keyVal objectAtIndex:1]]];
        }
    }
    NSSortDescriptor *desc = [[[NSSortDescriptor alloc] initWithKey:nil ascending:YES selector:@selector(localizedCompare:)] autorelease];
    NSArray *sortedArray = [last sortedArrayUsingDescriptors:[NSArray arrayWithObject:desc]];
    NSString* keyFroSh1=[sortedArray componentsJoinedByString:@""];
    [last release];
    return [[self SHA1:keyFroSh1]uppercaseString];
}

+ (NSString*)MD5:(NSString*)stringForMD5
{
    const char *ptr = [stringForMD5 UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

+ (NSString*)computeSessionToken:(NSString*)username
{
    //usr/fb +key md5
    NSString *sessionToken = [NSString stringWithFormat:@"%@%@",username,k_SecretKey];
    return [self MD5:sessionToken];
}

+ (NSString*) encodeToPercentEscapeString:(NSString*) string
{
    return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                (CFStringRef) string,
                                                                NULL,
                                                                (CFStringRef) @"+/]",
                                                                kCFStringEncodingUTF8) autorelease];
}

+ (void) setSender:(id)snd
{
    sender = snd;
}

+ (void)cancelRequest
{
    for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
    {
        NSLog(@"cancel request: %@",req.url);
        [req cancel];
        [req setDelegate:nil];
    }
    [request clearDelegatesAndCancel];
}
+ (void) apiCallFile:(NSString*)url andMethodName:(NSString*)method filePath:(NSString*) filePath andTag:(int)tag
{
    NSString *htmlEncodedUrl;
    htmlEncodedUrl = [self encodeToPercentEscapeString:url];
    if (request != nil)
    {
        [request release];
        request = nil;
    }
    
    request = [[ASIFormDataRequest  alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",baseUrl,method]]];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    [request setRequestMethod:@"POST"];
    [request setTag:tag];
    [request setTimeOutSeconds:k_ApiTimeout];
    [ASIHTTPRequest setDefaultTimeOutSeconds:k_ApiTimeout];
    [request setTimeOutSeconds:k_ApiTimeout];
    
    NSMutableData *requestData = [[NSMutableData alloc]init];
    [requestData setData:[NSData dataWithBytes: [htmlEncodedUrl UTF8String] length: [htmlEncodedUrl length]]];
    [request setPostBody:requestData];
    [request setPostLength:[requestData length]];
    
    [(ASIFormDataRequest*)request addFile:filePath forKey:@"audio"];
    
    [requestData release];
    [request setDelegate:sender];
    [request startAsynchronous];
}
+ (void) apiCall:(NSString*)url andMethodName:(NSString*)method andTag:(int)tag
{
    NSString *htmlEncodedUrl;
    htmlEncodedUrl = [self encodeToPercentEscapeString:url];
    if (request != nil)
    {
        [request release];
        request = nil;
    }
    
    request = [[ASIFormDataRequest  alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",baseUrl,method]]];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    [request setRequestMethod:@"POST"];
    [request setTag:tag];
    [request setTimeOutSeconds:k_ApiTimeout];
    [ASIHTTPRequest setDefaultTimeOutSeconds:k_ApiTimeout];
    [request setTimeOutSeconds:k_ApiTimeout];
    
    NSMutableData *requestData = [[NSMutableData alloc]init];
    [requestData setData:[NSData dataWithBytes: [htmlEncodedUrl UTF8String] length: [htmlEncodedUrl length]]];
    [request setPostBody:requestData];
    [request setPostLength:[requestData length]];
    
    [requestData release];
    [request setDelegate:sender];
    [request startAsynchronous];
}

+ (void) loginUser:(NSString*)username andPassword:(NSString*)password andDeviceID:(NSString*)device_id Version:(float)version andTag:(int)tag
{
    NSString *function = @"login_custom";
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@&device_id=%@&version=%f",username, password,device_id, version, nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) loginFB:(NSString*)facebook_id andDeviceID:(NSString*)device_id Version:(float)version andTag:(int)tag
{
    NSString *function = @"login_facebook";
    NSString *params = [NSString stringWithFormat:@"facebook_id=%@&device_id=%@&version=%f",facebook_id, device_id, version, nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}


+ (void) registerUser:(NSString*)username andPassword:(NSString*)password andEmail:(NSString*)email andDeviceID:(NSString*)device_id Version:(float)version andTag:(int)tag
{
    NSString *function = @"register";
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@&email=%@&device_id=%@&version=%f",username, password, email, device_id, version, nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) forgotPassword:(NSString*)email andDeviceID:(NSString*)device_id Version:(float)version andTag:(int)tag
{
    NSString *function = @"recover_password";
    NSString *params = [NSString stringWithFormat:@"email=%@&device_id=%@&version=%f", email, device_id, version, nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) logoutUser:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"logout";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&version=%f", token, version, nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) checkUser:(NSString*)user andType:(NSString*)user_type Token:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"check_user";
    NSString *params = [NSString stringWithFormat:@"field=%@&data=%@&app_id=%@&version=%f", user_type, user, token, version, nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) saveSettings:(NSString*)token Firtsname:(NSString*)firstname Lastname:(NSString*)lastname Version:(float)version andTag:(int)tag
{
    NSString *function = @"save_profile";
    NSString *params = [NSString stringWithFormat:@"firstname=%@&lastname=%@&app_id=%@&version=%f", firstname, lastname, token, version, nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) getUserCoins:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"get_coins";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&version=%f", token, version, nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) getFacebookFriends:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"get_facebook_friends";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&version=%f", token, version, nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) getGameWords:(NSString*)opponent_id WithBubbles:(BOOL)bubbles Token:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"get_game_words";
    NSString *params = [NSString stringWithFormat:@"player_id=%@&app_id=%@&check_bubbles=%d&version=%f",opponent_id, token, bubbles, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) createGame:(NSString*)word_id Opponent:(NSString*)opponent_id Token:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"create_game";
    NSString *params = [NSString stringWithFormat:@"player_2=%@&word_id=%@&app_id=%@&version=%f",opponent_id, word_id, token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) sendGameData:(NSString*)game_round_id Data:(NSString*)data Token:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"send_data";
    NSString *params = [NSString stringWithFormat:@"game_round_id=%@&data=%@&app_id=%@&version=%f",game_round_id, data, token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}
+ (void) sendAudioGameData:(NSString *)game_round_id audio_url:(NSString*) audio_url Token:(NSString*) token Version:(float)version andTag:(int) tag
{
    NSString *function = @"send_audio";
    NSString *params = [NSString stringWithFormat:@"game_round_id=%@&app_id=%@&version=%f",game_round_id, token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCallFile:requestString andMethodName:function filePath:audio_url andTag:tag];
    
}
+ (void) getAvailableCoins:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"coin_list";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&version=%f", token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) getGames:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"get_games";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&version=%f",token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) purchasedCoins:(NSString*)coins_id Extra:(NSString*)extra_data Token:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"coins_purchased";
    NSString *params = [NSString stringWithFormat:@"coin_id=%@&extra_data=%@&app_id=%@&version=%f", coins_id, extra_data, token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) getGameDetails:(NSString*)game_round_id Token:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"get_game_details";
    NSString *params = [NSString stringWithFormat:@"game_round_id=%@&app_id=%@&version=%f",game_round_id, token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) getLeaderboard:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"get_leaderboard";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&version=%f", token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) finishGame:(NSString*)game_round_id Word:(NSString*)word Time:(int)time Token:(NSString*)token ExtraTimer:(int)extra_timer Version:(float)version andTag:(int)tag
{
    NSString *packet_id = @"";
    if(extra_timer == -1)
    {
        
    }else
    {
        packet_id = [NSString stringWithFormat:@"%d",extra_timer];
    }
    
    NSString *function = @"finish_game";
    NSString *params = [NSString stringWithFormat:@"game_round_id=%@&word=%@&time=%d&app_id=%@&packet_id=%@&version=%f", game_round_id, word, time,token, packet_id, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) continueGame:(NSString*)game_id Word:(NSString*)word_id Token:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"continue_game";
    NSString *params = [NSString stringWithFormat:@"game_id=%@&word_id=%@&app_id=%@&version=%f",game_id, word_id, token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) getAchievements:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"get_achievements";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&version=%f", token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) getPurchasablePackets:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"get_purchasable_packets";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&version=%f", token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) registerPurchase:(NSString*)token PacketID:(int)packet_id Version:(float)version andTag:(int)tag
{
    NSString *function = @"purchase_packet";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&packet_id=%d&version=%f", token, packet_id, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) share:(NSString*)token GameRoundID:(int)game_round_id To:(NSString*)to Data:(NSString*)data Version:(float)version andTag:(int)tag
{
    NSString *function = @"share";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&game_round_id=%d&to=%@&data=%@&version=%f", token, game_round_id, to, data, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) deleteGame:(NSString*)token GameRoundID:(int)game_round_id Version:(float)version andTag:(int)tag
{
    NSString *function = @"delete_game";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&game_round_id=%d&version=%f", token, game_round_id, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) getBubbles:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"get_bubbles";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&version=%f", token, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) purchaseBubbles:(NSString*)token BubbleID:(int)bubble_id Version:(float)version andTag:(int)tag
{
    NSString *function = @"purchase_bubbles";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&bubble_id=%d&version=%f", token, bubble_id, version,nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) getAvailableBubbles:(NSString*)token Version:(float)version andTag:(int)tag
{
    NSString *function = @"bubble_list";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&version=%f", token, version, nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];
}

+ (void) buyCoins:(NSDictionary *)coins Token:(NSString*)token Version:(float)version andTag:(int)tag;
{
    NSInteger coin = [[coins objectForKey:@"coins"] integerValue];
    
    NSString *function = @"buy_coins";
    NSString *params = [NSString stringWithFormat:@"app_id=%@&version=%f&coins=%ld", token, version, coin, nil];
    NSString *requestString = [NSString stringWithFormat:@"%@&%@",function,params];
    
    requestString =[requestString stringByAppendingString:[NSString stringWithFormat:@"&validation_hash=%@",[self MakeSecretKey:params]]];
    [self apiCall:requestString andMethodName:function andTag:tag];

}



@end
