//
//  SellerViewController.h
//  mobil-payment
//
//  Created by Torben Toepper on 24.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenerateQRViewController.h"
#import "TransactionsViewController.h"


@interface SellerViewController : UIViewController {
    GenerateQRViewController *generateQrController;
}

@property (nonatomic, retain) IBOutlet GenerateQRViewController *generateQrController;

-(NSMutableArray *)getTransactions;
- (IBAction)transactionsPressed:(id)sender;
- (IBAction)generatePressed:(id)sender;
- (IBAction)myDataPressed:(id)sender;

@end
