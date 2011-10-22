//
//  Transaction.h
//  mobile-payment
//
//  Created by Torben Toepper on 16.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"

@interface Transaction : NSObject {
    NSString *amount;
    NSDate *paid_at;
    NSString *transaction_id;
    NSString *currency_key;
    Customer *customer;
}

@property(nonatomic, retain) NSString *amount;
@property(nonatomic, retain) NSDate *paid_at;
@property(nonatomic, retain) NSString *transaction_id;
@property(nonatomic, retain) NSString *currency_key;
@property(nonatomic, retain) Customer *customer;

-(id)initWithDictinoary:(NSDictionary *)dict;
+(NSDate *)dateFromInternetDateTimeString:(NSString *)dateString;

@end
