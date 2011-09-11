//
//  PropertiesViewController.h
//  mobil-payment
//
//  Created by Torben Toepper on 27.08.11.
//  Copyright 2011 Torben Toepper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Properties.h"

@interface PropertiesViewController : UITableViewController <UITextFieldDelegate> {
    Properties *props;

    IBOutlet UIToolbar *keyboardToolbar;
    IBOutlet UIBarButtonItem *toolbarActionButton;

    NSMutableArray *table;
    NSMutableArray *inputFields;
}

@property (nonatomic, retain) Properties *props;
@property (nonatomic, retain) NSMutableArray *table;
@property (nonatomic, retain) NSMutableArray *inputFields;
@property (nonatomic, retain) IBOutlet UIToolbar *keyboardToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *toolbarActionButton;


/*
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (void)animateTextField: (UITextField*) textField up: (BOOL) up;
 */
-(void)prepare;
-(BOOL)check;
-(BOOL)isFieldProtected:(NSString *)key;
-(IBAction)submit:(id)sender;
-(IBAction)closeKeyboard:(id)sender;
-(IBAction)nextField:(id)sender;
-(IBAction)prevField:(id)sender;

@end
