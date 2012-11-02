//
//  ViewController.h
//  PopUpView
//
//  Created by Apple on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Mediaplayer/Mediaplayer.h>
#import "Blob.h"
#import "customCell.h"
#import "customSolutionTabellCell.h"
#import "Problem.h"
#import "Solution.h"
#import "AddProblemViewController.h"
#import "WEPopoverController.h"
#import "SolutionBlobPacket.h"
#import "Base64Utils.h"
#import "TicketMonitorViewController.h"
#import "AddTicketViewController.h"
#import "custom_KD_PopOverViewController.h"
#import "DCRoundSwitch.h"

@class custom_KD_PopOverViewController;

@class AddProblemViewController;

@class WEPopoverController;

@interface ProblemSolutionViewController :  UIViewController<UISearchBarDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,MPMediaPickerControllerDelegate,UIPopoverControllerDelegate,UITableViewDelegate,UITableViewDataSource,WEPopoverControllerDelegate,customProblemTabelViewCellDelegate,customSolutionTabelViewCellDelegate,CatsResponseDelegate,UITextFieldDelegate>
{
    customCell *problemCustomCell;
    customSolutionTabellCell *solutionCustomCell;
    Problem     *problem;
    Solution    *solution;
    AppDelegate *appDelegate;
    WEPopoverController      *popoverController;
    AddProblemViewController *addProblemVC;
    custom_KD_PopOverViewController *custom_KD_PopOverVC;
    Ticket *currentCreationOfTicketOBJ;
    FilterPopupView *filterPopupView;
    Ticket *ticket;
    DCRoundSwitch *helpDocSwitch;

    IBOutlet UIView *problemView;
    IBOutlet UIView *solutionView;
    IBOutlet UIView *addProblemOrSolutionView;
    IBOutlet UITextView *addProblemOrSolutionTextView;
    IBOutlet UIScrollView *problemScrollView;
    IBOutlet UIScrollView *solutionScrollView;
    IBOutlet UISearchBar *search_Bar;
    IBOutlet UITableView *problemList;
    IBOutlet UITableView *solutionList;
    IBOutlet UILabel *heplDoc;
    
    UIAlertView *probSolAlertView;
    UIAlertView *cameraAlertView;
    UIAlertView *audioAlertView;
    UIAlertView *imageCountAlretView;
    UIAlertView *saveTicketAlert;
    UIAlertView *audioAlret;
    UIImage  *currentProblemImage;
    UIImage  *currentSolutionImage;
    UILabel  *tittleLabel;
    UILabel  *describtionlabel;
    UILabel  *headingLabel , *authorLabel , *rateLabel;
    UIActivityIndicatorView *activityIndicator;
    UIPopoverController     *popoverController1;
    UITableView  *KDtableView;
    UIView       *KDheaderView;
    UIView       *loadingView;
    UIStoryboard *mainStoryboard;
    UITapGestureRecognizer *solutionViewTapGestureRecognizer;
    UITapGestureRecognizer *problemViewTapGestureRecognizer;
    UIControl *transparentView;
    
    AVAudioPlayer       *player;
    AVAudioRecorder     *audioRecorder;
    UIPopoverController *popOver;
    NSMutableDictionary *recordSetting;
    NSMutableDictionary *editedObject;
    NSString *recorderFilePath;
    NSInteger currentPopoverCellIndex;
	Class popoverClass;
    NSTimer  *playTime,*recordTime;
    NSURL    *audioFilePath;
    NSData   *currentBlobData;
    NSTimer  *timer;
    
    NSMutableArray *listofProblems,*listofSolutions;
    NSMutableArray *filteredListofProblem;
    NSMutableArray *filteredListofSolution;
    NSMutableArray *currentImagesList;
    NSMutableArray *problemdetailArray,*solutiondetailArray;
    NSMutableArray *locationList;
    NSMutableArray *contactList;
    NSMutableArray *ImageList;
    NSMutableArray *dataArray;
    NSMutableArray *listofKD,*filterlistofKD;
    NSMutableArray *list;
    
    NSString *audioPath;  
    NSString *categoryId;
    NSString *techName;
    NSString *userID;
    
    BOOL isAudioRecording,isAudoPlaying,
    keyboardIsInFront,problemViewIsDoubleClicked,
    solutionViewIsDoubleClicked,playerPaused,
    problemViewPopoverIsInFront;
    BOOL kdableviewIndexSelected;
    BOOL isSolutionSelected;
    BOOL isKDVisible;
    BOOL iPad; 
    
    int   prosolnToggle;
    int   tapCount;
    int   searchProcessValue;
    int   totalRecords;
    float auidioPlayerTime;
    
}

@property (nonatomic, retain) IBOutlet DCRoundSwitch *helpDocSwitch;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (nonatomic, retain) WEPopoverController *popoverController;
@property (nonatomic,retain)  IBOutlet UIToolbar *toolBar;
@property (nonatomic,retain)  IBOutlet UITableView *tableViewOBJ;
@property (nonatomic,retain)  IBOutlet UIView *problemView;
@property (nonatomic,retain)  IBOutlet UIView *solutionView;
@property (strong, nonatomic) IBOutlet UIView *bottomToolBarView;
@property (nonatomic,retain)  IBOutlet UIButton *solutionButton;
@property (nonatomic,retain)  UISearchBar *search_Bar;
@property (nonatomic,retain)  IBOutlet UIButton *addProblem;
@property (nonatomic,retain)  UIAlertView *probSolAlertView;
@property (nonatomic,retain)  UITextView *currentTextView;
@property (nonatomic,retain)  IBOutlet UIButton *addSolImageButton;
@property (nonatomic,retain)  IBOutlet UIButton *addProbImageButton;
@property (nonatomic,retain)  IBOutlet UIButton *proSolBackwardBtn;
@property (nonatomic,retain)  IBOutlet UIButton *proSolFrwardBtn;
@property(nonatomic,retain)   NSString *audioPath;
@property (strong, nonatomic) IBOutlet UITableView *problemList;
@property (strong, nonatomic) IBOutlet UITableView *solutionList;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UILabel *textViewTittle;
@property (strong, nonatomic) IBOutlet UILabel *audioTimer;
@property (strong, nonatomic) IBOutlet UIButton *audioBtn;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn;
@property (strong, nonatomic) IBOutlet UIButton *proSoluBtn;
@property (strong, nonatomic) IBOutlet UIButton *KD_Btn;
@property (strong, nonatomic) IBOutlet UIButton *TM_Btn;

@property (strong, nonatomic) NSMutableArray *filteredListofProblem;
@property (strong, nonatomic) NSMutableArray *filteredListofSolution;
@property (strong, nonatomic) NSMutableArray *locationList;
@property (strong, nonatomic) NSMutableArray *contactList;
@property (strong,nonatomic)IBOutlet UIView *addProblemOrSolutionView;
@property (strong,nonatomic)IBOutlet UITextView *addProblemOrSolutionTextView;
@property (strong , nonatomic)       NSMutableArray *listofKD,*filterlistofKD;
@property (nonatomic,retain)  Ticket *currentCreationOfTicketOBJ;

- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)CameraBtnPressed;
- (IBAction)audioBtnPressed;
- (IBAction)SaveBtnPressed;
- (IBAction)KD_BtnPressed:(id)sender;
- (IBAction)proSoluBtnPressed:(id)sender forEvent:(UIEvent*)event;
- (IBAction)TM_BtnPressed:(id)sender;
- (IBAction)leftNavBtnPressed;
- (IBAction)rightNavBtnPressed;

- (void)doneBtnPressed;
- (void)audioRecording;
- (NSData *)retriveAudioFile;
- (void)addImages:(UIImagePickerControllerSourceType)sourceType;
- (void)addImagesToImageList:(NSData *)imageData;
-(void)keyboardWasShown:(id)sender;
-(void)keyboardWasHidden:(id)sender;
- (void)ImagesBtnPressed;
//- (void)dissmissModelVC;
- (void)playBtnPressed;

- (void)popOverTextViewIsEditng;
- (void)popOverTextViewIsendEditing;
- (void)KD_popOverTextViewIsEditng;
- (void)KD_popOverTextViewIsendEditing;

- (BOOL) doesSolutionExist:(Solution *) solution;

- (BOOL) saveSolution:(Solution *) solution;

- (Solution *) createSolutionInstance;

//- (NSArray *)arrayFromData:(NSData *)data;

- (Problem *) createProblemInstance;

- (BOOL) saveProblem:(Problem *) problem;

- (BOOL) doesProblemExist:(Problem *) solution;

-(NSString *)getProblemTitleString:(Problem *)curProblem isIntialEnrty:(BOOL)isFirstEnrty;

-(NSString *)getSolutionTitleString:(Solution *)curSolution;

- (void)performOnSeparateMethod;

- (void)addingProblem;

- (void)addingSolution;

- (void)dismissPopover;

- (void)searchProcessControllingSection:(NSString *)searchString;

-(void)createLoadingView;

- (void)threadStartAnimating:(id)data;

- (void)threadStopAnimating:(id)data;

- (void)getSolutionListfromKD;

- (void)saveByExistingLocAndCat;

- (void)customizeNewFrameFor_SolView_Ipad:(CGRect)x1 Iphone_frame:(CGRect)x2  ProbView_Ipad:(CGRect)y1 Iphone_frame:(CGRect)y2 addProbOrSolView_Ipad:(CGRect)z1 Iphone_frame:(CGRect)z2 bottomToolBarView_Ipad:(CGRect)a1 Iphone_frame:(CGRect)a2;

- (void)replacingBottomToolBarViewItems_MeansHide_KD_ProSol_AND_TM_Btns:(BOOL)Hide_KD_ProSol_AND_TM_Btns;

- (void)presentCustomizePopOverWithSize_Ipad:(CGSize *)IpadSize Iphone:(CGSize *)IphoneSize textViewText:(NSString *)text textViewTittle:(NSString *)tittleString;

- (void)presentCustomize_KD_PopOverVC_WithSize_Ipad:(CGSize *)IpadSize Iphone:(CGSize *)IphoneSize;

- (void)managingAudioRecordingMode;

-(void)KD_PopOverCancelBtnPressed;

-(void)KD_PopOverCancelBtnPressedWith_location:(NSString *)location category:(NSString *)category describtion:(NSString *)describtion KDsolutionList:(NSMutableArray *)KDsolutionList;

@end
