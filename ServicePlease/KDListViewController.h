//
//  KDListViewController.h
//  ServiceTech
//
//  Created by Bala Subramaniyan on 19/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"
#import "Solution.h"
#import "AppDelegate.h"
#import "popViewController.h"
#import "WEPopoverController.h"
#import "custom_KD_PopOverViewController.h"
#import "TTTAttributedLabel.h"

@interface KDListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate,WEPopoverControllerDelegate,ASYNCServiceDelegate>
{
    WEPopoverController *custom_KD_popoverView;
    Solution *solution;
    Class  popoverClass;
    
    IBOutlet UIButton *DoneBtn;
    IBOutlet UITableView *listofSolutionView;
    IBOutlet UITextView *selectedTextView;
    IBOutlet UILabel *locationLbl;
    IBOutlet UILabel *CategoryLbl;
    BOOL iPad;
    
    UIView *loadingView;
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray *listofSolutionArray;
    NSMutableArray *predictKDSolutionArray;
    NSMutableArray *tableDataArray;
    UIStoryboard *mainStoryboard;
    UIControl *transparentView;
    NSString *descString;
        
    BOOL unlike;

}

@property (nonatomic,retain) AppDelegate *appDelegate;

@property (nonatomic,retain)WEPopoverController *custom_KD_popoverView;

@property (nonatomic,retain) IBOutlet UIButton *DoneBtn;

@property (strong,nonatomic) IBOutlet UITableView *listofSolutionView;

@property (strong, nonatomic) IBOutlet UITextView *selectedTextView;

@property (strong, nonatomic) IBOutlet UILabel *locationLbl;

@property (strong, nonatomic) IBOutlet UILabel *CategoryLbl;

@property (strong, nonatomic) IBOutlet UILabel *keyWordLbl;

-(IBAction)DoneBtnPressed:(id)sender;

- (IBAction)KDBtnPressed:(id)sender;

- (IBAction)TM_BtnPressed:(id)sender;

-(void)KD_location:(NSString *)location KD_category:(NSString *)category KD_description:(NSString *)description KDsolutionList:(NSMutableArray *)KDsolutionList;

- (void)presentCustomize_KD_PopOverVC_WithSize_Ipad:(CGSize *)IpadSize Iphone:(CGSize *)IphoneSize;

-(void)KD_PopOverCancelBtnPressed;

-(void)KD_PopOverCancelBtnPressedWith_location:(NSString *)location category:(NSString *)category describtion:(NSString *)describtion KDsolutionList:(NSMutableArray *)KDsolutionList;

- (void)popOverTextViewIsEditng;

- (void)popOverTextViewIsendEditing; 

- (IBAction)likeBtnPressed:(id)sender;

- (IBAction)unlikeBtnPressed:(id)sender;

@end
