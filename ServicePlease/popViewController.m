//
//  popViewController.m
//  Test
//
//  Created by karthik keyan on 02/08/12.
//  Copyright (c) 2012 karthik.krishna@colanonline.com. All rights reserved.
//

#import "popViewController.h"
#import "AppDelegate.h"

@interface popViewController ()

@end

@implementation popViewController
@synthesize popoverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(250,280);       
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  
    callBack = nil;
    telePhone = nil;
       email = nil;
        name = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([telePhone isEditing]==YES) {
        
        
       // viewController.view.frame=CGRectMake(0,-50 ,320 ,464);
        
    }else if([callBack isEditing]==YES){
        
        //viewController.view.frame=CGRectMake(0,-100 ,320 ,464);
    } 
    
    
    return YES;   
}// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [callBack resignFirstResponder];
    [name resignFirstResponder];
    [email resignFirstResponder];
    [telePhone resignFirstResponder];
    return YES;
}

- (IBAction)DoneBtnpressed:(id)sender {
    
   // AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
  //  [appDelegate.viewController dismissPop];
    
}

@end
