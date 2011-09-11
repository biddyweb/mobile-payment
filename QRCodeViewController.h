//
//  QRCodeViewController.h
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface QRCodeViewController : UIViewController {
    NSString *amount;
    NSString *currency;
    IBOutlet UIWebView *webView;
    IBOutlet UIImageView *qrImageView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIImageView *qrImageView;
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) NSString *currency;

- (id)initWithNibNameAndAmount:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil amount:(NSString *)_amount currency:(NSString *)_currency;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
- (IBAction)cancelPressed:(id)sender;

@end
