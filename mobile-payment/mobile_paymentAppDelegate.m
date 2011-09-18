//
//  mobile_paymentAppDelegate.m
//  mobile-payment
//
//  Created by Torben Toepper on 24.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "mobile_paymentAppDelegate.h"
#import "ECNetworkHandler.h"
#import "Properties.h"
#import <AudioToolbox/AudioToolbox.h>
#import "TransactionsViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "Config.h"


@implementation mobile_paymentAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize apnContentType, apnContentInfo, apnHardwareId;

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
    NSLog(@"%@", launchOptions);
    // Override point for customization after app launch    
	
	self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [[PayPal getInstance] fetchDeviceReferenceTokenWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX withDelegate:self];
    
    //TODO: Build with a timer!
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
    // APN Handler
    if ([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] != nil) {
        NSDictionary *userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        apnContentType = [[NSString alloc] initWithString:[[userInfo objectForKey:@"data"] objectForKey:@"type"]];
        apnContentInfo = [[NSArray alloc] initWithArray:[[userInfo objectForKey:@"data"] objectForKey:@"values"]];
        apnHardwareId  = [[NSString alloc] initWithString:[[userInfo objectForKey:@"data"] objectForKey:@"hardware_id"]];
        
        [self showNotification];
    }
    
    return YES;
}

- (void)receivedDeviceReferenceToken:(NSString *)token {
    // Stash the device token somewhere to use later. [ECNetworkHandler sharedInstance].deviceReferenceToken = token;
    //XLog(@"erfolg!");
    //NSLog(@"%@", token);
}
- (void)couldNotFetchDeviceReferenceToken {
    // Record the errorMessage that tells what went wrong. 
    //NSLog(@"DEVICE REFERENCE TOKEN ERROR: %@", [PayPal getInstance].errorMessage);
    //[ECNetworkHandler sharedInstance].deviceReferenceToken = @"";
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

#pragma mark APN
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    Properties *props = [[Properties alloc] init];
    
    NSString *customer_id = [props get:@"customer_id"];
    NSString *token = [NSString stringWithFormat:@"%@", devToken];
    
    if(customer_id != @"") {
        NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:token, @"apn_token", nil];
        [props storeInDB:properties];
    }
    
    [props release];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    apnContentType = [[NSString alloc] initWithString:[[userInfo objectForKey:@"data"] objectForKey:@"type"]];
    apnContentInfo = [[NSArray alloc] initWithArray:[[userInfo objectForKey:@"data"] objectForKey:@"values"]];
    apnHardwareId  = [[NSString alloc] initWithString:[[userInfo objectForKey:@"data"] objectForKey:@"hardware_id"]];
    
    NSString *alertMessage = [[apsInfo objectForKey:@"alert"] objectForKey:@"body"];
    NSString *soundType = [apsInfo objectForKey:@"sound"];
    UIApplicationState state = [application applicationState];

    if (state == UIApplicationStateActive){
        NSLog(@" It is in active state");
        application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
        NSLog(@"%i", application.applicationIconBadgeNumber);
        
        NSLog(@"%@", userInfo);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile-Payment" 
                                                        message:alertMessage
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Anzeigen", nil];
        
        int soundFile = 1002;
        if(soundType == @"beep") {
            soundFile = 1002;
        }
        
        
        AudioServicesPlaySystemSound(soundFile);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [alert show];
        [alert release];
    } else {
        if ([apnContentInfo count] > 0 ) {
            [self showNotification];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(1 == (int)buttonIndex) {
        [self showNotification];
    }
}

-(void)showNotification {
    if([apnContentType isEqualToString:@"customer"]) {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        
            TransactionsViewController *transactionsController = [[TransactionsViewController alloc] initWithNibName:@"TransactionsViewController" bundle:nil transactionIds:apnContentInfo hardwareId:apnHardwareId];
            [transactionsController dismissModalViewControllerAnimated:NO];
            
            UINavigationController *navcon = (UINavigationController*)self.tabBarController.selectedViewController;
            
            [navcon popToRootViewControllerAnimated:NO];
            [navcon pushViewController:transactionsController animated:YES];
            
            [transactionsController release];

    }
        
    [apnHardwareId release];
    [apnContentInfo release];
    [apnContentType release];
}

- (void)dealloc {
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

@end
