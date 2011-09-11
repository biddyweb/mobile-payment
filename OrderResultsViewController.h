//
//  OrderResultsViewController.h
//  mobil-payment
//
//  Created by Torben Toepper on 01.09.11.
//  Copyright 2011 redrauscher. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderResultsViewController : UIViewController {
	IBOutlet UILabel *txnID;
	NSString *transactionID;
}

@property (nonatomic, retain) NSString *transactionID;

-(IBAction)homeButtonPressed;

@end
