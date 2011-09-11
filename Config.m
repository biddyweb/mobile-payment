//
//  Config.m
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import "Config.h"

@implementation Config

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(NSString *)webUrl {
   return @"http://localhost:8080/"; 
}

+(NSString *)webUrlTEMP {
    return @"http://payment.dev/"; 
}

+(NSURL *)transactionsUrlWith:(NSString *)hardwareId {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@transactions.json?hardware_id=%@", [Config webUrlTEMP], hardwareId]];
}

+(NSURL *)transactionsUrl:(NSString *)customerId {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Config webUrlTEMP], [NSString stringWithFormat:@"customers/%@/transactions.json", customerId]]];
}

+(NSURL *)transactionUrl:(NSString *)customerId transaction:(NSString *)transactionId asJSON:(BOOL)asJSON {
    return [NSURL URLWithString:[Config transactionUrlAsString:customerId transaction:transactionId asJSON:asJSON]];
}

+(NSString *)transactionUrlAsString:(NSString *)customerId transaction:(NSString *)transactionId asJSON:(BOOL)asJSON {
    NSString *json = asJSON ? @".json" : @".png";

    return [NSString stringWithFormat:@"%@%@", [Config webUrlTEMP], [NSString stringWithFormat:@"customers/%@/transactions/%@%@", customerId, transactionId, json]];
}

+(NSURL *)transactionConfirmationUrl:(NSString *)customerId transaction:(NSString *)transactionId asJSON:(BOOL)asJSON {
    NSString *json = asJSON ? @".json" : @".png";
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Config webUrlTEMP], [NSString stringWithFormat:@"customers/%@/transactions/%@/confirm%@", customerId, transactionId, json]]];
}

+(NSURL *)newCustomerUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Config webUrlTEMP], @"customers.json"]];
}

+(NSURL *)updateCustomerUrl:token {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [Config webUrlTEMP], [NSString stringWithFormat:@"customers/%@.json", token]]];
}

+(int)qrCodeCustomerPosition {
    return 4;
}

+(int)qrCodeTransactionPosition {
    return 6;
}

@end
