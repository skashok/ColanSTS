//
//  popViewController.h
//  Test
//
//  Created by karthik keyan on 02/08/12.
//  Copyright (c) 2012 karthik.krishna@colanonline.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"
#import "ContactListingViewController.h"

@interface popViewController : UIViewController<UITextFieldDelegate>{
    
    
    IBOutlet UITextField *name;
    IBOutlet UITextField *email;
    IBOutlet UITextField *telePhone;
    IBOutlet UITextField *callBack;
    
    WEPopoverController *popoverController;
}

@property (nonatomic, retain) WEPopoverController *popoverController;
- (IBAction)DoneBtnpressed:(id)sender;

@end
