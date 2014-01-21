//
//  AppDelegate.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "AppDelegate.h"
#import "Shared.h"
#import "Reachability.h"

@implementation AppDelegate

@synthesize def,scheduleData,RouteData,ShuttleScheduleLArrayobj,shuttleRouteArrayobj,shuttleInfoArrayobj,dictShuttleData;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    self.netStatus = [self.internetReachability currentReachabilityStatus];
	[self.internetReachability startNotifier];

    NSSetUncaughtExceptionHandler(&HandleUncaughtException);
    
    return YES;
}

- (void) reachabilityChanged:(NSNotification *)note
{
    self.internetReachability = [note object];
    self.netStatus = [self.internetReachability currentReachabilityStatus];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    //return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    return UIInterfaceOrientationMaskAll;
}

#pragma mark Register Notification Methods
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"Token: %@", deviceToken);
    
    Shared *objShared = [Shared GetInstance];
    [objShared SetDeviceToken:[[NSString alloc] initWithString:[NSString stringWithFormat:@"%@",deviceToken]]];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)data
{
    NSLog(@"%@",[data description]);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}
#pragma -

#pragma mark Exception Handler
void HandleUncaughtException(NSException *objException)
{
    [ExceptionHandler AddExceptionForScreen:@"" MethodName:@"Uncaught exception" Exception:[objException description]];
}
#pragma -
@end
