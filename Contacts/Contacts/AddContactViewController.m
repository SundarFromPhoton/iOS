//
//  AddContactViewController.m
//  Contacts
//
//  Created by sundar on 04/06/14.
//  Copyright (c) 2014 Sundar. All rights reserved.
//

#import "AddContactViewController.h"
#import "DBManager.h"

@interface AddContactViewController ()

@end

@implementation AddContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"Add Contact";
	// Do any additional setup after loading the view.
}

-(IBAction)saveContact:(id)sender{
    BOOL success = NO;
    NSString *alertString = @"Data Insertion failed";
    if (_nameTxtFiled.text.length>0 &&_addressTxtFiled.text.length>0 &&
        _phoneNumTxtFiled.text.length>0)
    {
        success = [[DBManager getSharedInstance]saveData:_nameTxtFiled.text address:_addressTxtFiled.text phoneNo:_phoneNumTxtFiled.text];
    }
    else{
        alertString = @"Enter all fields";
    }
    if (success == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                              alertString message:nil
                                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                              @"Contact Saved" message:nil
                                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
