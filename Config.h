//
//  Config.h
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

+(NSString *)webUrl;
+(NSString *)webUrlTEMP;

+(NSURL *)transactionsUrlWith:(NSString *)hardwareId;
+(NSURL *)transactionsUrlWith:(NSString *)hardwareId andIds:(NSArray *)transactionIds;
+(NSURL *)transactionsUrl:(NSNumber *)customerId;
+(NSURL *)transactionUrl:(NSString *)customerId transaction:(NSString *)transactionId asJSON:(BOOL)asJSON;
+(NSURL *)openTransactionsUrl:(NSNumber *)customer_id;
+(NSString *)transactionUrlAsString:(NSString *)customerId transaction:(NSString *)transactionId asJSON:(BOOL)asJSON;
+(NSURL *)transactionConfirmationUrl:(NSString *)customerId transaction:(NSString *)transactionId asJSON:(BOOL)asJSON;
+(NSURL *)customerUrl:(NSNumber *)customer_id;
+(NSURL *)newCustomerUrl;
+(NSURL *)updateCustomerUrl:token;
+(int)qrCodeCustomerPosition;
+(int)qrCodeTransactionPosition;

@end
