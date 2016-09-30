//
//  AppDelegate.m
//  HackDemo
//
//  Created by hzyuxiaohua on 29/09/2016.
//  Copyright © 2016 hzyuxiaohua. All rights reserved.
//

#import "AppDelegate.h"

#import <objc/objc-runtime.h>
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

+ (void)class_test
{
    NSLog(@"origin_class_test_log.");
}

@end

@interface AppDelegate ()

@property (nonatomic, strong) id<AspectToken> aspect_token;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self runTest];
    
    return YES;
}

- (void)runTest
{
    [self jspatch_hook];
    Test* t = [[Test alloc] init];
    [self aspect_hook:t];
    
    [t test];
    
//    __unused Test* t1 = [[Test alloc] init];
//    [t1 test];
//
//    [self aspect_hook:t];
//    
//    [t1 test];
//    [t test];
//    
//    if ([self.aspect_token remove]) {
//        [t test];
//    }
    
//    Class class = NSClassFromString(@"Test_Aspects_");
//    Test* at = [[class alloc] init];
//    [at test];
}

- (void)aspect_hook:(id)obj
{
    NSError* error = nil;
    self.aspect_token =
    [obj aspect_hookSelector:@selector(test) withOptions:AspectPositionInstead usingBlock:^ {
        NSLog(@"aspect_hook_log.");
    } error:&error];
    
//    [Test aspect_hookSelector:@selector(class_test) withOptions:AspectPositionAfter usingBlock:^ {
//        NSLog(@"aspect_class_hook_log.");
//    } error:&error];
    
//    SEL selector = NSSelectorFromString(@"aspects__test");
//    id value = objc_getAssociatedObject(obj, selector);
//    
//    Class class = NSClassFromString(@"Test_Aspects_");
//    
//    Test* at = [[class alloc] init];
//    [at test];
    
    assert(error == nil);
}

- (void)jspatch_hook
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"js_demo" ofType:@"js"];
    if (path.length == 0) {
        return;
    }
    
    [JPEngine startEngine];
    [JPEngine evaluateScriptWithPath:path];
}

@end
