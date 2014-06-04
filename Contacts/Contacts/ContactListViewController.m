//
//  ViewController.m
//  Contacts
//
//  Created by sundar on 04/06/14.
//  Copyright (c) 2014 Sundar. All rights reserved.
//

#import "ContactListViewController.h"
#import "AddContactViewController.h"
#import "findContactViewController.h"

@interface ContactListViewController ()

@end

@implementation ContactListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addContacts:(id *)sender{
    AddContactViewController *addContactVC = [[AddContactViewController alloc]init];
    [self.navigationController pushViewController:addContactVC animated:YES];
}

-(IBAction)findContact:(id *)sender{
    
    findContactViewController *findContactVC = [[findContactViewController alloc]init];
    [self.navigationController pushViewController:findContactVC animated:YES];
}
@end
