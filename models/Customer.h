//
//  Customer.h
//  mobile-payment
//
//  Created by Torben Toepper on 16.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject {
    NSString *name;
    NSString *website_url;
    NSString *street;
    NSString *zip;
    NSString *location;
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *website_url;
@property(nonatomic, retain) NSString *street;
@property(nonatomic, retain) NSString *zip;
@property(nonatomic, retain) NSString *location;

-(id)initWithDictinoary:dict;

@end
