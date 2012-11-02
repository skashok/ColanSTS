//
//  AddProblemViewController.h
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 15/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//
@class AppDelegate;
#import <UIKit/UIKit.h>
#import "Problem.h"
#import "AppDelegate.h"


@interface AddProblemViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate>{
    
    IBOutlet UIButton *changeAudio;
    IBOutlet UIButton *playBtn;
}
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIButton *changeAudio;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UIProgressView *playingprogress;
@property (strong, nonatomic) IBOutlet UITextView *problemTextView;
@property (strong, nonatomic) IBOutlet UILabel *textViewTittle;
@property (strong, nonatomic) IBOutlet UILabel *audioTimer;

- (IBAction)doneBtnPressed:(id)sender;
- (IBAction)editBtnPressed:(id)sender;
- (IBAction)imageBtnPressed:(id)sender;
- (IBAction)audioBtnPressed:(id)sender;
- (IBAction)playBtnPressed:(id)sender;



@end
