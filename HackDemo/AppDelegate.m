//
//  AppDelegate.m
//  HackDemo
//
//  Created by hzyuxiaohua on 29/09/2016.
//  Copyright © 2016 hzyuxiaohua. All rights reserved.
//

#import "AppDelegate.h"

#import <Aspects/Aspects.h>
#import <JSPatch/JPEngine.h>

@interface Test : NSObject

- (void)test;

@end

@implementation Test

- (void)test
{
    NSLog(@"Origin Test Log.");
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self runTest];
    
    return YES;
}

- (void)runTest
{
    Test* t = [[Test alloc] init];
    [t test];
    
    __unused Test* t1 = [[Test alloc] init];
    
    [self aspect_hook:t];
    [t test];
}

- (void)aspect_hook:(id)obj
{
    NSError* error = nil;
    __unused id<AspectToken> token =
    [obj aspect_hookSelector:@selector(test) withOptions:AspectPositionAfter usingBlock:^ {
        NSLog(@"aspect_hook_log.");
    } error:&error];
}

@end
