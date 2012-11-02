//
//  AppDelegate.h
//  ServicePlease
//
//  Created by Ed Elliott on 1/20/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <SpeechKit/SpeechKit.h>
#import "ContactListingViewController.h"
#import "SelectedEntities.h"
#import "ServiceTechConstants.h"
#import "ContactListingViewController.h"
#import "ProblemSolutionViewController.h"
#import "AddProblemViewController.h"
#import "KDListViewController.h"
#import "DBHelper.h"

@class DBHelper;

@class ContactListingViewController;

@class ProblemSolutionViewController;

@class AddProblemViewController;

@class TicketMonitorViewController;

// Voice Recognition
enum 
{
    TS_IDLE,
    TS_INITIAL,
    TS_RECORDING,
    TS_PROCESSING,
    
} transactionState;


@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate, SKRecognizerDelegate,SpeechKitDelegate>
{
   
    // Voice Recognition
    SKRecognizer* voiceSearch;
    
    TicketMonitorFilter currentTMFilter;
    
    TicketMonitorSortingElement currentSortingElement;
    
    BOOL isProblemSoutionView,newTicketCreationProcess,ifticketRowselectedAndnewBtnPressed;
     
    int currentTicketMonitorSelected;
    
    BOOL filterPro_SolTicket;
    
    TicketMonitorActionMenu currentTMActionMenu;
   
    KDPopUpViewPresentControllers currentKDpopPresentVC;
    
    int selectedIndexInSettingsPage;
 
    DBHelper *dBHelper;
    
    DailyRecapDB *dailyRecapOBJ;
    
    UIBackgroundTaskIdentifier bgTask;

    NSMutableArray *techNameList;

    NSMutableDictionary *contentDict;

    NSMutableDictionary *documentDirectoryUrl;

    NSMutableDictionary *websiteData;

    NSString *solutionQueryString;
    
    NSOperationQueue *operationQueue;

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SelectedEntities *selectedEntities;

@property (strong, nonatomic)  DBHelper *dBHelper;

@property (nonatomic, assign) TicketMonitorActionMenu currentTMActionMenu;

@property (strong, nonatomic) NSMutableArray *categoryList;

@property (strong, nonatomic) NSMutableArray *filterListOfLocations;

@property (strong, nonatomic) NSMutableArray *filterListOfContacts;

@property (strong, nonatomic) NSMutableArray *filterListOfSPTypes;

@property (strong, nonatomic) NSMutableArray *filterListOfSinceTypes;

@property (strong, nonatomic) NSMutableArray *filterListOfCategories;

@property (strong, nonatomic) NSMutableArray *filterListOfStatus;

@property (strong, nonatomic) NSMutableArray *filterListOfTechs;

@property (assign, nonatomic) BOOL monitorActionButtonState;

@property (assign, nonatomic)  BOOL newTicketCreationProcess;

@property (assign, nonatomic) BOOL isProblemSoutionView;

@property (assign, nonatomic) BOOL ifticketRowselectedAndnewBtnPressed;

@property (assign, nonatomic) int currentTicketMonitorSelected;;

@property (strong, nonatomic) UIView *monitorActionPopupView;

@property (strong, nonatomic) NSIndexPath *currentContactVerificationIP;

@property (strong, nonatomic) ContactListingViewController *curContactListingVC;

@property (strong, nonatomic) ProblemSolutionViewController *curprobSoluVC;

@property (strong, nonatomic) AddProblemViewController *curAddprobVC;

@property (strong,nonatomic )TicketMonitorViewController *curTicketMonitorVC;

@property (strong,nonatomic)  KDListViewController *currentKDListVc;

@property (nonatomic,assign) KDPopUpViewPresentControllers currentKDpopPresentVC;

@property (nonatomic,retain)  ServiceHelper *currentServiceHelper;

@property (strong, nonatomic) NSString *lastSolutionBlobID;

@property (strong, nonatomic) NSString *lastProblemBlobID;

@property (strong, nonatomic) NSMutableArray *applicationList;

// Voice Recognition
@property (strong, nonatomic) NSString *currentRecoResult;
@property (strong, nonatomic) UITextField *currentTextField;
@property (strong, nonatomic) UITextView *currentTextView;

@property(nonatomic,assign) TicketMonitorFilter currentTMFilter;

@property (nonatomic,assign)TicketMonitorSortingElement currentSortingElement;

@property (assign, nonatomic) BOOL filterPro_SolTicket;

@property (strong , nonatomic) NSMutableDictionary *snoozeIntervalValue;

@property int selectedIndexInSettingsPage;

@property(nonatomic,retain) NSMutableArray *techNameList;

@property (nonatomic , retain) NSString *solutionQueryString;

// Voice Recognition
- (void)recordButtonAction:(UITextField *)currentTextField 
              languageType:(int)languageType;
- (void)recordButtonActionTextView:(UITextView *)currentTextView
                      languageType:(int)languageType;


#pragma  mark - ActiveIndicatorMethods

- (void)createActiveIndicatorView;

+ (void)activeIndicatorStartAnimating:(UIView*)view;

+ (void)activeIndicatorStopAnimating;

#pragma  mark - ActivityIndicatorMethods for present model alone

+ (void)activityIndicatorStartAnimating:(UIView*)view;

+ (void)activityIndicatorStopAnimating;

@end
