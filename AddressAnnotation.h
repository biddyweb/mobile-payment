//
//  AddressAnnotation.h
//  mobile-payment
//
//  Created by Torben Toepper on 11.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Customer.h"

@interface AddressAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *mTitle;
    NSString *mSubTitle;
    Customer *customer;
}

@property(nonatomic, retain) Customer *customer;

@end