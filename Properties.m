//
//  Properties.m
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "Properties.h"
#import "ASIFormDataRequest.h"
#import "Config.h"
#import "SBJsonParser.h"
#include <stdlib.h>

@implementation Properties

@synthesize prefs;

- (id)init
{
    self = [super init];
    if (self) {
        prefs = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

-(NSString *)get:(NSString *)key {
    return [prefs stringForKey:key] == nil ? @"" : [prefs stringForKey:key];
}

-(void)store:(NSString *)key value:(NSString *)value {
    [prefs setObject:value forKey:key];
}

-(BOOL)storeInDB:(NSDictionary *)properties {
    NSString *customer_id = [self get:@"customer_id"];
    UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
    NSURL *url = [Config newCustomerUrl];
    
    if(customer_id != @"") url = [Config updateCustomerUrl:customer_id];
    
    NSLog(@"%@", url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    if(customer_id != @"") [request setRequestMethod:@"PUT"];

    if([properties objectForKey:@"storename"] != nil)
        [request setPostValue:[properties objectForKey:@"storename"] forKey:@"customer[name]"];
    if([properties objectForKey:@"currency"] != nil)
        [request setPostValue:[properties objectForKey:@"currency"] forKey:@"customer[currency]"];
    if([properties objectForKey:@"paypalUsername"] != nil)
        [request setPostValue:[properties objectForKey:@"paypalUsername"] forKey:@"customer[paypal_username]"];
    if([properties objectForKey:@"paypalPassword"] != nil)
        [request setPostValue:[properties objectForKey:@"paypalPassword"] forKey:@"customer[paypal_password]"];
    if([properties objectForKey:@"paypalSignature"] != nil)
        [request setPostValue:[properties objectForKey:@"paypalSignature"] forKey:@"customer[paypal_signature]"];
    if([properties objectForKey:@"website_url"] != nil)
        [request setPostValue:[properties objectForKey:@"website_url"] forKey:@"customer[website_url]"];
    if([properties objectForKey:@"street"] != nil)
        [request setPostValue:[properties objectForKey:@"street"] forKey:@"customer[street]"];
    if([properties objectForKey:@"zip"] != nil)
        [request setPostValue:[properties objectForKey:@"zip"] forKey:@"customer[zip]"];
    if([properties objectForKey:@"location"] != nil)
        [request setPostValue:[properties objectForKey:@"location"] forKey:@"customer[location]"];
    if([properties objectForKey:@"apn_token"] != nil)
        [request setPostValue:[properties objectForKey:@"apn_token"] forKey:@"customer[apn_token]"];
    
    if(customer_id != @"") [request setPostValue:deviceUDID forKey:@"customer[hardware_id]"];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *json_error;
        SBJsonParser *json = [[SBJsonParser new] autorelease];
        NSDictionary *values = [json objectWithString:response error:&json_error];
        
        if(values == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" 
                                                            message:[NSString stringWithFormat:@"JSON parsing failed: %@", [json_error localizedDescription]]
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            if([values objectForKey:@"id"] != nil) {
                [prefs setObject:[NSString stringWithFormat:@"%@", [values objectForKey:@"id"]] forKey:@"customer_id"];
                [prefs setObject:[NSString stringWithFormat:@"%@", [values objectForKey:@"token"]] forKey:@"customer_token"];
                return true;
            }
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" 
                                                        message:[NSString stringWithFormat:@"Web parsing failed: %@", [error localizedDescription]]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

    return false;
}

@end
