//
//  mobile_paymentAppDelegate.h
//  mobile-payment
//
//  Created by Torben Toepper on 24.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPal.h"

@interface mobile_paymentAppDelegate : NSObject <UIApplicationDelegate, DeviceReferenceTokenDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    
    NSString *apnHardwareId;
    NSString *apnContentType;
    NSArray *apnContentInfo;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSString *apnHardwareId;
@property (nonatomic, retain) NSString *apnContentType;
@property (nonatomic, retain) NSArray *apnContentInfo;

-(void)showNotification;

@end
