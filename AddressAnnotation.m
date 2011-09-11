//
//  AddressAnnotation.m
//  mobile-payment
//
//  Created by Torben Toepper on 11.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation

@synthesize coordinate, row;

- (NSString *)subtitle {
    return [NSString stringWithFormat:@"%@\n%@ %@", [row objectForKey:@"street"], [row objectForKey:@"zip"], [row objectForKey:@"location"]];
}

- (NSString *)title {
    return [row objectForKey:@"customer"];
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c {
    coordinate=c;
    return self;
}
@end
