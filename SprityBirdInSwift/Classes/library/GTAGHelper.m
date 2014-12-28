//
//  ShizzleStatic.m
//  Shizzle
//
//  Created by Nguyen Tuan on 8/6/14.
//  Copyright (c) 2014 Shizzle Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTAGKeys.h"
#import "GTAGHelper.h"
#import "TAGManager.h"
#import "TAGContainerOpener.h"

@interface GTAGHelper ()

@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *forgotURL;
@property (nonatomic, strong) NSString *runscopePort;
@property (nonatomic, assign) ShizzleLogLevel logLevel;
@property (nonatomic, strong) NSString *webURL;

@property (nonatomic, assign) int64_t videoLimitedTime;

@property (nonatomic, strong) TAGManager *tagManager;
@property (nonatomic, strong) TAGContainer *container;
@property (nonatomic, strong) NSString *currentContainerVersion;

@end

static void *TAGRefreshResourceFromNetworkContext = &TAGRefreshResourceFromNetworkContext;

@implementation GTAGHelper

static dispatch_once_t onceToken;

static GTAGHelper *sharedInstance = nil;

#ifdef DEBUG
static int64_t limitTime = 60;
#else
static int64_t limitTime = 900; //15 minutes
#endif

+(instancetype)shareInstance
{
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        //create default value
    }
    
    return self;
}

-(void)setup
{
}

-(void)load
{
    self.tagManager = [TAGManager instance];
    
    id future =
    [TAGContainerOpener openContainerWithId:TAGIdentifier   // Update with your Container ID.
                                 tagManager:self.tagManager
                                   openType:kTAGOpenTypePreferNonDefault
                                    timeout:nil];
    
    // Method calls that don't need the container.
    self.container = [future get];
    self.currentContainerVersion = [self.container valueForKey:@"resourceVersion"];
    
    [self patchInfomationFromGTA];
    [self.container refresh];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [self patchInfomationFromGTA];
}

#pragma mark Setter

-(void)patchInfomationFromGTA
{
    NSString *host = [self.container stringForKey:TAGPhoShizzleHostKey];
    if (host.length > 0) {
        _host = host;
    }
    
    NSString *forgotURL = [self.container stringForKey:TAGPhoShizzleForgotPwKey];
    if (forgotURL.length > 0) {
        _forgotURL = forgotURL;
    }
    
    NSString *loglevel = [self.container stringForKey:TAGLogLevel];
    if ([loglevel isEqualToString:@"log_file"]) {
        _logLevel = ShizzleLogLevelEnableLogFile;
    }else if ([loglevel isEqualToString:@"debug"]) {
        _logLevel = ShizzleLogLevelDebug;
    }else if ([loglevel isEqualToString:@"none"]) {
        _logLevel = ShizzleLogLevelNone;
    }
    
    NSString *runscopePort = [self.container stringForKey:TAGPhoShizzleRunscopePort];
    if (runscopePort.length > 0) {
        _runscopePort = runscopePort;
    }
    
    NSString *webURL = [self.container stringForKey:TAGPhoShizzleWebURL];
    if (webURL.length > 0) {
        _webURL = webURL;
    }
    
    _videoLimitedTime = [self.container int64ForKey:TAGVideoLimitedTime];
}

#pragma mark Getter

@end
