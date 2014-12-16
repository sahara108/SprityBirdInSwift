//
//  ShizzleTAGKeys.h
//  Shizzle
//
//  Created by Nguyen Tuan on 8/6/14.
//  Copyright (c) 2014 Shizzle Labs. All rights reserved.
//

#ifndef Shizzle_ShizzleTAGKeys_h
#define Shizzle_ShizzleTAGKeys_h

static NSString *TAGIdentifier                  = @"GTM-WQ48RR";

#if DEMO_SERVER
static NSString *TAGPhoShizzleHostKey           = @"demo_host";
static NSString *TAGPhoShizzleForgotPwKey       = @"demo_forgotURL";
static NSString *TAGPhoShizzleRunscopePort      = @"demo_runscope_port";
static NSString *TAGPhoShizzleWebURL            = @"demo_web";
#else
#if TEST_SERSVER
static NSString *TAGPhoShizzleHostKey           = @"test_host";
static NSString *TAGPhoShizzleForgotPwKey       = @"test_forgotURL";
static NSString *TAGPhoShizzleRunscopePort      = @"test_runscope_port";
static NSString *TAGPhoShizzleWebURL            = @"test_web";
#else
#if INT_SERSVER
static NSString *TAGPhoShizzleHostKey           = @"int_host";
static NSString *TAGPhoShizzleForgotPwKey       = @"int_forgotURL";
static NSString *TAGPhoShizzleRunscopePort      = @"int_runscope_port";
static NSString *TAGPhoShizzleWebURL            = @"int_web";
#else
static NSString *TAGPhoShizzleHostKey           = @"host";
static NSString *TAGPhoShizzleForgotPwKey       = @"forgotURL";
static NSString *TAGPhoShizzleRunscopePort      = @"runscope_port";
static NSString *TAGPhoShizzleWebURL            = @"web";
#endif
#endif
#endif

static NSString *TAGVideoLimitedTime            = @"timeLimited";

static NSString *TAGLogLevel                    = @"loglevel";

#endif
