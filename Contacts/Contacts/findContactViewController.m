//
//  findContactViewController.m
//  Contacts
//
//  Created by sundar on 04/06/14.
//  Copyright (c) 2014 Sundar. All rights reserved.
//

#import "findContactViewController.h"
#import "DBManager.h"

@interface findContactViewController ()

@end

@implementation findContactViewController

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
    self.title = @"Find Contact";

    // Do any additional setup after loading the view from its nib.
}
-(IBAction)findContact:(id)sender{
    NSArray *data = [[DBManager getSharedInstance]findByName: _nameTxtFiled.text];
    if (data == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                              @"Data not found" message:nil delegate:nil cancelButtonTitle:
                              @"OK" otherButtonTitles:nil];
        [alert show];
            }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                              @"Address" message:[data objectAtIndex:0]
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
