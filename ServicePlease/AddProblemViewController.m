//
//  AddProblemViewController.m
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 15/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "AddProblemViewController.h"
#import "Problem.h"
#import "AppDelegate.h"
#import "ServicePleaseValidation.h"
#import "ServiceHelper.h"


@implementation AddProblemViewController

@synthesize appDelegate;
@synthesize playingprogress;
@synthesize problemTextView;
@synthesize textViewTittle;
@synthesize audioTimer;
@synthesize changeAudio;
@synthesize playBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate setCurAddprobVC:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [problemTextView setEditable:NO];
    changeAudio.enabled=NO;
    playingprogress.progress=0.0f;
    
    // Do any additional setup after loading the view.
    
}

- (void)viewDidUnload
{
    [self setProblemTextView:nil];
    changeAudio = nil;
    [self setPlayingprogress:nil];
    [self setTextViewTittle:nil];
    [self setAudioTimer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.curprobSoluVC popOverTextViewIsEditng];
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.curprobSoluVC popOverTextViewIsendEditing];
    return YES ;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}


// called when 'return' key pressed. return NO to ignore
- (IBAction)doneBtnPressed:(id)sender {
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.curprobSoluVC doneBtnPressed];
    
}
- (IBAction)editBtnPressed:(id)sender {
    
    [problemTextView setEditable:YES];
    changeAudio.enabled=YES;
}

- (IBAction)imageBtnPressed:(id)sender {
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.curprobSoluVC ImagesBtnPressed];
}

- (IBAction)audioBtnPressed:(id)sender {
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.curprobSoluVC audioRecording];
    
}

- (IBAction)playBtnPressed:(id)sender {
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.curprobSoluVC playBtnPressed];
    
}
@end
