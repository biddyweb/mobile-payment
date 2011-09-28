//
//  FindViewController.h
//  mobile-payment
//
//  Created by Torben Toepper on 26.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindViewController : UIViewController <CLLocationManagerDelegate> {
    IBOutlet UIWebView *webView;
    
    CLLocationManager *locationManager;
    float longitude;
    float latitude;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

@end
