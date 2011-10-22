//
//  Transaction.m
//  mobile-payment
//
//  Created by Torben Toepper on 16.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

@synthesize amount, paid_at, transaction_id, currency_key, customer;

-(id)initWithDictinoary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.amount = [dict objectForKey:@"amount"];
        self.paid_at = [Transaction dateFromInternetDateTimeString:[[NSString alloc] initWithFormat:@"%@", [dict objectForKey:@"paid_at"]]];
        self.transaction_id = [dict objectForKey:@"transaction_id"];
        self.currency_key = [dict objectForKey:@"currency_key"];
        
        self.customer = [[Customer alloc] initWithDictinoary:[dict objectForKey:@"customer"]];
    }
    return self;
}

+(NSDate *)dateFromInternetDateTimeString:(NSString *)dateString {
    
    // Setup Date & Formatter
    NSDate *date = nil;
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:en_US_POSIX];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [en_US_POSIX release];
    }
    
    /*
     *  RFC3339
     */
    
    NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
    RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
    
    // Remove colon in timezone as iOS 4+ NSDateFormatter breaks
    // See https://devforums.apple.com/thread/45837
    if (RFC3339String.length > 20) {
        RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":" 
                                                                 withString:@"" 
                                                                    options:0
                                                                      range:NSMakeRange(20, RFC3339String.length-20)];
    }
    
    if (!date) { // 1996-12-19T16:39:57-0800
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"]; 
        date = [formatter dateFromString:RFC3339String];
    }
    if (!date) { // 1937-01-01T12:00:27.87+0020
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"]; 
        date = [formatter dateFromString:RFC3339String];
    }
    if (!date) { // 1937-01-01T12:00:27
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"]; 
        date = [formatter dateFromString:RFC3339String];
    }
    if (date) return date;
    
    /*
     *  RFC822
     */
    
    NSString *RFC822String = [[NSString stringWithString:dateString] uppercaseString];
    if (!date) { // Sun, 19 May 02 15:21:36 GMT
        [formatter setDateFormat:@"EEE, d MMM yy HH:mm:ss zzz"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) { // Sun, 19 May 2002 15:21:36 GMT
        [formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) {  // Sun, 19 May 2002 15:21 GMT
        [formatter setDateFormat:@"EEE, d MMM yyyy HH:mm zzz"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) {  // 19 May 2002 15:21:36 GMT
        [formatter setDateFormat:@"d MMM yyyy HH:mm:ss zzz"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) {  // 19 May 2002 15:21 GMT
        [formatter setDateFormat:@"d MMM yyyy HH:mm zzz"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) {  // 19 May 2002 15:21:36
        [formatter setDateFormat:@"d MMM yyyy HH:mm:ss"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (!date) {  // 19 May 2002 15:21
        [formatter setDateFormat:@"d MMM yyyy HH:mm"]; 
        date = [formatter dateFromString:RFC822String];
    }
    if (date) return date;
    
    // Failed
    return nil;
    
}

@end
