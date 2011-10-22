//
//  TransactionsViewController.h
//  mobile-payment
//
//  Created by Torben Toepper on 04.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"

@interface TransactionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *table;
}

@property (nonatomic, retain) NSMutableArray *table;

+ (NSMutableArray *)getTransactions:(Customer *)customer;
+ (NSMutableArray *)getOpenTransactions:(Customer *)customer;
+(NSMutableArray *)_getTransactions:(NSURL *)url;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil table:(NSMutableArray *)_table;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil transactionIds:(NSArray *)transactionIds hardwareId:(NSString *)hardwareId;

@end
