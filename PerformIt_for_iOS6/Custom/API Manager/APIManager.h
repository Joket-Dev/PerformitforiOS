//
//  APIManager.h
//  PerformIt
//
//  Created by Mihai Puscas on 6/3/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (void) releaseRequest;
+ (void) apiCall:(NSString*)url andMethodName:(NSString*)method andTag:(int)tag;
+ (void) setSender:(id)snd;
+ (void)cancelRequest;

+ (NSString*) MakeSecretKey:(NSString*)requestParams;
+ (NSString*)MD5:(NSString*)stringForMD5;
+ (NSString*)computeSessionToken:(NSString*)username;
+ (NSString*) encodeToPercentEscapeString:(NSString*) string;

+ (void) loginUser:(NSString*)username andPassword:(NSString*)password andDeviceID:(NSString*)device_id Version:(float)version andTag:(int)tag;
+ (void) loginFB:(NSString*)facebook_id andDeviceID:(NSString*)device_id Version:(float)version andTag:(int)tag;
+ (void) registerUser:(NSString*)username andPassword:(NSString*)password andEmail:(NSString*)email andDeviceID:(NSString*)device_id Version:(float)version andTag:(int)tag;
+ (void) forgotPassword:(NSString*)email andDeviceID:(NSString*)device_id Version:(float)version andTag:(int)tag;
+ (void) logoutUser:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) checkUser:(NSString*)user andType:(NSString*)user_type Token:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) saveSettings:(NSString*)token Firtsname:(NSString*)firstname Lastname:(NSString*)lastname Version:(float)version andTag:(int)tag;
+ (void) getUserCoins:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) getFacebookFriends:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) getGameWords:(NSString*)opponent_id WithBubbles:(BOOL)bubbles Token:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) createGame:(NSString*)word_id Opponent:(NSString*)opponent_id Token:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) sendGameData:(NSString*)game_round_id Data:(NSString*)data Token:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) getAvailableCoins:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) getGames:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) purchasedCoins:(NSString*)coins_id Extra:(NSString*)extra_data Token:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) getGameDetails:(NSString*)game_round_id Token:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) getLeaderboard:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) finishGame:(NSString*)game_round_id Word:(NSString*)word Time:(int)time Token:(NSString*)token ExtraTimer:(int)extra_timer Version:(float)version andTag:(int)tag;
+ (void) continueGame:(NSString*)game_id Word:(NSString*)word_id Token:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) getAchievements:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) getPurchasablePackets:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) registerPurchase:(NSString*)token PacketID:(int)packet_id Version:(float)version andTag:(int)tag;
+ (void) share:(NSString*)token GameRoundID:(int)game_round_id To:(NSString*)to Data:(NSString*)data Version:(float)version andTag:(int)tag;
+ (void) deleteGame:(NSString*)token GameRoundID:(int)game_round_id Version:(float)version andTag:(int)tag;
+ (void) getBubbles:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) purchaseBubbles:(NSString*)token BubbleID:(int)bubble_id Version:(float)version andTag:(int)tag;
+ (void) getAvailableBubbles:(NSString*)token Version:(float)version andTag:(int)tag;

+ (void) buyCoins:(NSString *)coins Token:(NSString*)token Version:(float)version andTag:(int)tag;
+ (void) sendAudioGameData:(NSString *)game_round_id audio_url:(NSString*) audio_url Token:(NSString*) token Version:(float)version andTag:(int) tag;

@end
