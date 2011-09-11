//
//  CostomerWebsiteViewController.h
//  mobile-payment
//
//  Created by Torben Toepper on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CostomerWebsiteViewController : UIViewController {
    IBOutlet UIWebView *_webView;
    NSString *url;
}

@property (nonatomic, retain) IBOutlet UIWebView *_webView;
@property (nonatomic, retain) NSString *url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:_url;

@end
