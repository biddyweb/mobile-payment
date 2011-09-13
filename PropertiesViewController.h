//
//  PropertiesViewController.h
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Properties.h"

@interface PropertiesViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    Properties *props;
    
    IBOutlet UITableView *localTableView;
    IBOutlet UINavigationBar *navigation;
    IBOutlet UIToolbar *keyboardToolbar;
    IBOutlet UIBarButtonItem *toolbarActionButton;
    IBOutlet UIBarButtonItem *cancel;
    IBOutlet UIBarButtonItem *done;

    NSMutableArray *table;
    NSMutableDictionary *inputFields;
    NSMutableArray *inputFieldsAsArray;
}

@property (nonatomic, retain) Properties *props;
@property (nonatomic, retain) NSMutableArray *table;
@property (nonatomic, retain) NSMutableDictionary *inputFields;
@property (nonatomic, retain) NSMutableArray *inputFieldsAsArray;
@property (nonatomic, retain) IBOutlet UITableView *localTableView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigation;
@property (nonatomic, retain) IBOutlet UIToolbar *keyboardToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *toolbarActionButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *done;


/*
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (void)animateTextField: (UITextField*) textField up: (BOOL) up;
 */
-(void)prepare;
-(BOOL)check;
-(BOOL)isFieldProtected:(NSString *)key;
-(IBAction)cancel:(id)sender;
-(IBAction)submit:(id)sender;
-(IBAction)closeKeyboard:(id)sender;
-(IBAction)nextField:(id)sender;
-(IBAction)prevField:(id)sender;

@end
