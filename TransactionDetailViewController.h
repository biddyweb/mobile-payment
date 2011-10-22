//
//  TransactionDetailViewController.h
//  mobile-payment
//
//  Created by Torben Toepper on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TransactionDetailViewController : UITableViewController {
    Transaction *transaction;
}

@property(nonatomic, retain) Transaction *transaction;

-(NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
