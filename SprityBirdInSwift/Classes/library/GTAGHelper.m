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
        [self setup];
        
#if DEMO_SERVER || TEST_SERSVER || INT_SERSVER
        //get value from GTA
        [self load];
#endif
    }
    
    return self;
}

-(void)setup
{
//    _host = PhoShizzleHost;
//    _forgotURL = shizzleForgotPasswordURL;
//    _logLevel = ShizzleLogLevelEnableLogFile;
//    _videoLimitedTime = limitTime;
//    _runscopePort = PhoShizzleRunscopePort;
//    _webURL = PhoShizzleWebURL;
}

-(void)load
{
    self.tagManager = [TAGManager instance];
    
    // Optional: Change the LogLevel to Verbose to enable logging at VERBOSE and higher levels.
    [self.tagManager.logger setLogLevel:kTAGLoggerLogLevelVerbose];
    
    id future =
    [TAGContainerOpener openContainerWithId:TAGIdentifier   // Update with your Container ID.
                                 tagManager:self.tagManager
                                   openType:kTAGOpenTypePreferNonDefault
                                    timeout:nil];
    
    // Method calls that don't need the container.
    self.container = [future get];
    self.currentContainerVersion = [self.container valueForKey:@"resourceVersion"];
    [self.container addObserver:self forKeyPath:@"lastRefreshTime" options:NSKeyValueObservingOptionNew context:TAGRefreshResourceFromNetworkContext];
    
    [self patchInfomationFromGTA];
    [self.container refresh];
}

-(void)dealloc
{
    [self.container removeObserver:self forKeyPath:@"lastRefreshTime"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [self patchInfomationFromGTA];
}

#pragma mark NetworkCallback

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == TAGRefreshResourceFromNetworkContext) {
        NSString *version = [self.container valueForKey:@"resourceVersion"];
        if (![version isEqualToString:self.currentContainerVersion]) {
            self.currentContainerVersion = version;
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Google TAG manager has changed. Shizzle will automatically logout to apply new settings. Please sign in again to continue using." delegate:self cancelButtonTitle:@"DONE" otherButtonTitles:nil] show];
        }
    }
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

-(NSString *)hostWithoutRunscope
{
    NSString *host = _host;
    NSString *port = _runscopePort;
    if ([host rangeOfString:@"runscope"].length > 0) {
        host = [host stringByReplacingOccurrencesOfString:@".runscope.net/shizzle-service/" withString:@""];
        host = [host stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        NSString *lastPath = [NSString stringWithFormat:@".%@",host.pathExtension];
        host = [host stringByReplacingOccurrencesOfString:lastPath withString:[NSString stringWithFormat:@":%@",port]];
        host = [host stringByAppendingString:@"/shizzle-service/"];
    }
    
    return host;
}

-(NSString *)runscopePort
{
    return _runscopePort;
}

-(NSString *)host
{
    return _host;
}

-(NSString *)webURL
{
    return _webURL;
}

-(NSString *)forgotURL
{
    return _forgotURL;
}

-(ShizzleLogLevel)logLevel
{
    return _logLevel;
}

-(int64_t)videoLimitedTime
{
    return _videoLimitedTime;
}

@end
