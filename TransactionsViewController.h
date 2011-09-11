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

+ (NSDate *)dateFromInternetDateTimeString:(NSString *)dateString;

@end
