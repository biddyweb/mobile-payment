//
//  CatalogViewController.h
//  mobile-payment
//
//  Created by Torben Toepper on 11.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatalogViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *table;
    IBOutlet UINavigationBar *navigation;
    IBOutlet UIBarButtonItem *cancelButton;
    
    NSArray *catalog;
    UITextField *inputField;
    NSString *pageTitle;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigation;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;

@property (nonatomic, retain) NSArray *catalog;
@property (nonatomic, retain) UITextField *inputField;
@property (nonatomic, retain) NSString *pageTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil catalog:(NSArray *)_catalog inputField:(UITextField *)field title:(NSString *)_title;

@end
