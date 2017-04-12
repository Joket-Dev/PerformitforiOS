//
//  UserData.h
//  PerformIt
//
//  Created by Mihai Puscas on 5/3/13.
//  Copyright (c) 2013 Mihai Puscas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject
{
    NSString *username;
    NSString *password;
    NSString *email;
    
    NSString *name;
    
    NSString *facebookID;
    NSString *facebookAccessToken;
    
    int bubbles;
    int coins;
    BOOL soundsEnabled;
    BOOL validLogin;
    NSString *deviceID;
    NSString *token;
    NSString *loginType;
    int userID;
    NSString * userphotourl;
}
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *facebookAccessToken;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, assign) int bubbles;
@property (nonatomic, assign) int coins;
@property (nonatomic, assign) BOOL soundsEnabled;
@property (nonatomic, assign) BOOL validLogin;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *loginType;
@property (nonatomic, assign) int userID;
@property (nonatomic, strong) NSString *userphotourl;



@end
