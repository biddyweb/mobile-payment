//
//  AddressAnnotation.m
//  mobile-payment
//
//  Created by Torben Toepper on 11.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation

@synthesize coordinate, customer;

- (NSString *)subtitle {
    return [NSString stringWithFormat:@"%@\n%@ %@", customer.street, customer.zip, customer.location];
}

- (NSString *)title {
    return customer.name;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c {
    coordinate=c;
    return self;
}
@end
