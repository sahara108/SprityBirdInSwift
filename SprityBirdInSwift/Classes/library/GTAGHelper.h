//
//  ShizzleStatic.h
//  Shizzle
//
//  Created by Nguyen Tuan on 8/6/14.
//  Copyright (c) 2014 Shizzle Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ShizzleLogLevel) {
    ShizzleLogLevelNone = 0,
    ShizzleLogLevelDebug,
    ShizzleLogLevelEnableLogFile
};

@interface GTAGHelper : NSObject

+(instancetype)shareInstance;

-(NSString*)host;
-(NSString*)webURL;
-(NSString*)forgotURL;
-(NSString*)runscopePort;
-(int64_t)videoLimitedTime;
-(ShizzleLogLevel)logLevel;

-(NSString*)hostWithoutRunscope;

@end
