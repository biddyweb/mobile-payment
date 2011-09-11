//
//  Config.h
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 redrauscher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

+(NSString *)webUrl;
+(NSString *)webUrlTEMP;

+(NSURL *)transactionsUrlWith:(NSString *)hardwareId;
+(NSURL *)transactionsUrl:(NSString *)customerId;
+(NSURL *)transactionUrl:(NSString *)customerId transaction:(NSString *)transactionId asJSON:(BOOL)asJSON;
+(NSString *)transactionUrlAsString:(NSString *)customerId transaction:(NSString *)transactionId asJSON:(BOOL)asJSON;
+(NSURL *)transactionConfirmationUrl:(NSString *)customerId transaction:(NSString *)transactionId asJSON:(BOOL)asJSON;
+(NSURL *)newCustomerUrl;
+(NSURL *)updateCustomerUrl:token;
+(int)qrCodeCustomerPosition;
+(int)qrCodeTransactionPosition;

@end
