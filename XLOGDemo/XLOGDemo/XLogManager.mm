//
//  XLogManager.m
//  XLOGDemo
//
//  Created by 李金 on 2017/12/10.
//  Copyright © 2017年 Kingandyoga. All rights reserved.
//

#import "XLogManager.h"
#include <mars/xlog/xlogger.h>
#include <mars/xlog/xloggerbase.h>
#include <mars/xlog/appender.h>
#import <sys/xattr.h>
@implementation XLogManager
#pragma mark - public


+ (void)setupWithLevel:(XLogLevel)level
                  path:(NSString *)path
           encryptCode:(u_int8_t)encryptCode
         needCosoleLog:(BOOL)needCosoleLog
                prefix:(NSString *)prefix
                logext:(NSString *)logext{
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    NSString* logPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:path];
    
    setxattr([logPath UTF8String], attrName, &attrValue, sizeof(attrValue), 0, 0);
    TLogLevel logLevel = (TLogLevel)level;
    xlogger_SetLevel(logLevel);
    appender_set_file_log_ext([logext UTF8String]);
    appender_set_console_log(true);
    char encrypt[8];
    sprintf(encrypt, "%d", encryptCode);
    appender_open(kAppednerAsync, [logPath UTF8String], [prefix UTF8String], "0x11");
}

+ (void)close{
    appender_close();
}

+ (void)logWithLevel:(XLogLevel)level format:(NSString *)format, ... {
    if ([self shouldLog:level]) {
        XLoggerInfo *info = new XLoggerInfo();
        TLogLevel logLevel = (TLogLevel)level;
        info->level = logLevel;
        
        va_list argList;
        va_start(argList, format);
        NSString* message = [[NSString alloc] initWithFormat:format arguments:argList];
        va_end(argList);
        
        // crash problem
        // reference: https://github.com/CocoaLumberjack/CocoaLumberjack/pull/831
        va_start(argList, format);
        xlogger_Write(info, message.UTF8String);
        va_end(argList);
    }
}

+ (void)logWithLevel:(XLogLevel)level string:(NSString *)string{
    if ([self shouldLog:level]) {
        XLoggerInfo *info = new XLoggerInfo();
        TLogLevel logLevel = (TLogLevel)level;
        info->level = logLevel;
        xlogger_Write(info, string.UTF8String);
    }
}
// 60 * 60 * 24 = 1day
+ (void)setActiveTime:(u_int64_t)time{
    appender_set_max_file_time(time);
}

+ (void)flushLog:(finishFlushBlock)block{
    [self logWithLevel:XLogLevelError format:@"-------- flush -------"];
    appender_flush();
    block(YES);
}

#pragma mark - Private
+ (BOOL)shouldLog:(XLogLevel)level {
    
    if (level >= xlogger_Level()) {
        return YES;
    }
    
    return NO;
}
@end
