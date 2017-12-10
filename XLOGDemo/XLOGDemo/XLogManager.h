//
//  XLogManager.h
//  XLOGDemo
//
//  Created by 李金 on 2017/12/10.
//  Copyright © 2017年 Kingandyoga. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface XLogManager : NSObject
typedef enum {
    XLoglevelAll = 0,
    XLogLevelVerbose = 0,
    XLogLevelDebug,    // Detailed information on the flow through the system.
    XLogLevelInfo,     // Interesting runtime events (startup/shutdown), should be conservative and keep to a minimum.
    XLogLevelWarn,     // Other runtime situations that are undesirable or unexpected, but not necessarily "wrong".
    XLogLevelError,    // Other runtime errors or unexpected conditions.
    XLogLevelFatal,    // Severe errors that cause premature termination.
    XLogLevelNone,     // Special level used to disable all log messages.
}XLogLevel;

typedef void(^finishFlushBlock)(BOOL);

// setup manager
+ (void)setupWithLevel:(XLogLevel)level
                  path:(NSString *)path
           encryptCode:(u_int8_t)encryptCode
         needCosoleLog:(BOOL)needCosoleLog
                prefix:(NSString *)prefix
                logext:(NSString *)logext;

// flush before close please.
+ (void)close;

// log function
+ (void)logWithLevel:(XLogLevel)level format:(NSString *)format, ... ;
+ (void)logWithLevel:(XLogLevel)level string:(NSString *)string;

// Xlog will clear the log file which had created more than this time.
+ (void)setActiveTime:(u_int64_t)time;

// flush log into file immediately
+ (void)flushLog:(finishFlushBlock)block;

@end
#define XLog_General(logLevel, format, ...) \
{\
NSString *aMessage = [NSString stringWithFormat:format, ##__VA_ARGS__, nil];\
[XLogManager logWithLevel:logLevel string:aMessage]; \
}

#define XLog_Error() XLog_General(XLogLevelError, format, ##__VA_ARGS__)
#define XLog_Debug() XLog_General(XLogLevelDebug, format, ##__VA_ARGS__)
#define XLog_Info() XLog_General(XLogLevelInfo, format, ##__VA_ARGS__)
#define XLog_Warn() XLog_General(XLogLevelWarn, format, ##__VA_ARGS__)

