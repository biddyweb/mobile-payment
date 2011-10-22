//
//  Customer.m
//  mobile-payment
//
//  Created by Torben Toepper on 16.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Customer.h"

@implementation Customer

@synthesize name, website_url, street, zip, location;

-(id)initWithDictinoary:dict {
    self = [super init];
    if (self) {
        self.name = [dict objectForKey:@"name"];
        self.website_url = [dict objectForKey:@"website_url"];
        self.street = [dict objectForKey:@"street"];
        self.zip = [dict objectForKey:@"zip"];
        self.location = [dict objectForKey:@"location"];
    }
    return self;
}

@end
