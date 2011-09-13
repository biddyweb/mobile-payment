//
//  RootViewController.h
//  mobil-payment
//
//  Created by Torben Toepper on 24.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import "BookViewController.h"
#import "GenerateQRViewController.h"
#import "TransactionsViewController.h"

@class BookViewController;

@interface RootViewController : UIViewController <ZXingDelegate, DeviceReferenceTokenDelegate> {
    IBOutlet UITextView *resultsView;
    IBOutlet UIButton *bookButton;
    NSString *resultsToDisplay;
    BookViewController *booksController;
    GenerateQRViewController *generateQrController;
    
    BOOL tokenFetchAttempted;
}

@property (nonatomic, assign) BOOL tokenFetchAttempted;

@property (nonatomic, retain) IBOutlet UIButton *bookButton;
@property (nonatomic, retain) IBOutlet BookViewController *bookController;
@property (nonatomic, retain) IBOutlet GenerateQRViewController *generateQrController;
@property (nonatomic, retain) IBOutlet UITextView *resultsView;
@property (nonatomic, copy) NSString *resultsToDisplay;

- (IBAction)scanPressed:(id)sender;
- (IBAction)bookPressed:(id)sender;
- (IBAction)transactionsPressed:(id)sender;
- (IBAction)generatePressed:(id)sender;
- (IBAction)myDataPressed:(id)sender;

@end
