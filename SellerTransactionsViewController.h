//
//  SellerTransactionsViewController.h
//  mobile-payment
//
//  Created by Torben Toepper on 22.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TransactionsViewController.h"
#import "Customer.h"

@interface SellerTransactionsViewController : TransactionsViewController {
    IBOutlet UISegmentedControl *segmentedControl;
    Customer *customer;
}

@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) Customer *customer;

-(IBAction)segmentChanged:(id)sender;

@end
