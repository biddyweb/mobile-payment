//
//  TransactionsViewController.h
//  mobile-payment
//
//  Created by Torben Toepper on 04.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionsViewController : UITableViewController {
    NSMutableArray *table;
}

@property (nonatomic, retain) NSMutableArray *table;

+ (NSMutableArray *)getTransactions;
+ (NSDate *)dateFromInternetDateTimeString:(NSString *)dateString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil table:(NSMutableArray *)_table;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil transactionIds:(NSArray *)transactionIds hardwareId:(NSString *)hardwareId;

@end
