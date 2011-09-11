//
//  TransactionDetailViewController.h
//  mobile-payment
//
//  Created by Torben Toepper on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionDetailViewController : UITableViewController {
    NSDictionary *row;
}

@property(nonatomic, retain) NSDictionary *row;

@end
