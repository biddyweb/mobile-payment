//
//  mobile_paymentAppDelegate.m
//  mobile-payment
//
//  Created by Torben Toepper on 24.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "mobile_paymentAppDelegate.h"
#import "ECNetworkHandler.h"


@implementation mobile_paymentAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

/*
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 {
 // Override point for customization after application launch.
 // Add the navigation controller's view to the window and display.
 self.window.rootViewController = self.navigationController;
 [self.window makeKeyAndVisible];
 return YES;
 }
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	
	[_window addSubview:[_navigationController view]];
    [_window makeKeyAndVisible];
    
    [NSThread detachNewThreadSelector:@selector(initializePayPal) toTarget:self withObject:nil];
    
	return YES;
}

-(void)initializePayPal {
    //[[PayPal getInstance] fetchDeviceReferenceTokenWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX withDelegate:self];
    [[PayPal getInstance] fetchDeviceReferenceTokenWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX withDelegate:self];
    return;
}

- (void)receivedDeviceReferenceToken:(NSString *)token {
    // Stash the device token somewhere to use later. [ECNetworkHandler sharedInstance].deviceReferenceToken = token;
    XLog(@"erfolg!");
}
- (void)couldNotFetchDeviceReferenceToken {
    // Record the errorMessage that tells what went wrong. 
    NSLog(@"DEVICE REFERENCE TOKEN ERROR: %@", [PayPal getInstance].errorMessage);
    [ECNetworkHandler sharedInstance].deviceReferenceToken = @"";
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    PayPal *paypal = [PayPal getInstance];
    //paypal.lang = @"DE";
    [paypal fetchDeviceReferenceTokenWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX withDelegate:nil];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
