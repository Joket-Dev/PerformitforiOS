//
//  UserData.m
//  PerformIt
//
//  Created by Mihai Puscas on 5/3/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import "UserData.h"

@implementation UserData
@synthesize username, password, email;
@synthesize facebookID, facebookAccessToken;
@synthesize name;
@synthesize coins, soundsEnabled, validLogin;
@synthesize deviceID;
@synthesize token;
@synthesize loginType;
@synthesize userID;
@synthesize bubbles;
@synthesize userphotourl;

- (id)copyWithZone:(NSZone *)zone
{
    UserData *copy = [[UserData alloc] init];
    copy.username = self.username;
    copy.password = self.password;
    copy.email = self.email;
    copy.facebookAccessToken = self.facebookAccessToken;
    copy.facebookID = self.facebookID;
    copy.coins = self.coins;
    copy.soundsEnabled = self.soundsEnabled;
    copy.validLogin = self.validLogin;
    copy.name = self.name;
    copy.deviceID = self.deviceID;
    copy.token = self.token;
    copy.loginType = self.loginType;
    copy.userID = self.userID;
    copy.bubbles = self.bubbles;
    copy.userphotourl = self.userphotourl;
    return copy;
}
@end
