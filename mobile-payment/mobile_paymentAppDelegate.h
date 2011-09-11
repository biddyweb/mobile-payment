//
//  mobile_paymentAppDelegate.h
//  mobile-payment
//
//  Created by Torben Toepper on 24.08.11.
//  Copyright 2011 redrauscher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mobile_paymentAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
