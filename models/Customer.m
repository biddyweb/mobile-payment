//
//  Customer.m
//  mobile-payment
//
//  Created by Torben Toepper on 16.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Customer.h"
#import "ASIFormDataRequest.h"
#import "SBJsonParser.h"
#import "Config.h"

@implementation Customer

@synthesize customer_id, name, website_url, street, zip, location;

-(id)initWithDictinoary:dict {
    self = [super init];
    if (self) {
        self.customer_id = [dict objectForKey:@"id"];
        self.name = [dict objectForKey:@"name"];
        self.website_url = [dict objectForKey:@"website_url"];
        self.street = [dict objectForKey:@"street"];
        self.zip = [dict objectForKey:@"zip"];
        self.location = [dict objectForKey:@"location"];
    }
    return self;
}

+(id)find:(NSNumber *)customer_id {
    NSURL *url = [Config customerUrl:customer_id];
    NSLog(@"URL:%@", customer_id);
    NSLog(@"%@", [Config customerUrl:customer_id]);
    ASIFormDataRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *json_error;
        SBJsonParser *json = [[SBJsonParser new] autorelease];
        NSArray *values = [json objectWithString:response error:&json_error];
        
        if(values == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" 
                                                            message:[NSString stringWithFormat:@"JSON parsing failed: %@", [json_error localizedDescription]]
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            return [[Customer alloc] initWithDictinoary:values];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" 
                                                        message:[NSString stringWithFormat:@"Web parsing failed: %@", [error localizedDescription]]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    return nil;
}

@end
