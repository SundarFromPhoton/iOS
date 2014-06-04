//
//  AddContactViewController.h
//  Contacts
//
//  Created by sundar on 04/06/14.
//  Copyright (c) 2014 Sundar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactViewController : UIViewController
{
    
}
@property(nonatomic,retain)IBOutlet UITextField *nameTxtFiled;
@property(nonatomic,retain)IBOutlet UITextField *addressTxtFiled;
@property(nonatomic,retain)IBOutlet UITextField *phoneNumTxtFiled;

-(IBAction)saveContact:(id)sender;
@end
