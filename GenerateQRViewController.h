//
//  GenerateQRViewController.h
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 redrauscher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenerateQRViewController : UIViewController {
    IBOutlet UITextField *amount;
}

@property (nonatomic, retain) IBOutlet UITextField *amount;

- (IBAction)generatePressed:(id)sender;

@end
