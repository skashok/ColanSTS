//
//  AppDelegate.m
//  ServicePlease
//
//  Created by Ed Elliott on 1/20/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ServiceTechConstants.h"
#import "FTURLOperation.h"

#define TESTING 1

static UIView  *loadingBgView;
static UIView *loadingView;
static UIActivityIndicatorView  *activityIndicator;

const unsigned char SpeechKitApplicationKey[] =
    {
		0x6d, 0x66, 0xe1, 0x54, 0x6c, 0x9a, 0x68, 0x17, 0x8e, 0xde, 0xae, 0xe2, 0xf1, 0x70, 0x3b, 0x38, 0xcc, 0xc5, 0xf3, 0xc, 0xb5, 0xff, 0x80, 0x4e, 0x4, 0x84, 0xd5, 0x3f, 0xb5, 0x11, 0x54, 0x22, 0x78, 0x36, 0x77, 0xe4, 0xd0, 0xdf, 0xfb, 0x5e, 0xbe, 0xa9, 0x40, 0xaf, 0x1a, 0x7b, 0xe7, 0xe6, 0x41, 0xdb, 0xf3, 0xf6, 0xda, 0x73, 0x44, 0xde, 0xf8, 0x19, 0x1e, 0xad, 0x2a, 0x72, 0xcf, 0xa2
	};

@implementation AppDelegate

@synthesize currentTMActionMenu;

@synthesize window = _window;

@synthesize selectedEntities = _selectedEntities;

@synthesize categoryList = _categoryList;

@synthesize monitorActionButtonState = _monitorActionButtonState;

@synthesize monitorActionPopupView = _monitorActionPopupView;

@synthesize filterListOfLocations = _filterListOfLocations;

@synthesize filterListOfContacts = _filterListOfContacts;

@synthesize filterListOfSPTypes = _filterListOfSPTypes;

@synthesize filterListOfStatus = _filterListOfStatus;

@synthesize filterListOfTechs = _filterListOfTechs;

@synthesize isProblemSoutionView = _isProblemSoutionView;

@synthesize newTicketCreationProcess=_newTicketCreationProcess;

@synthesize currentTicketMonitorSelected = _currentTicketMonitorSelected;

@synthesize filterListOfSinceTypes = _filterListOfSinceTypes;

@synthesize filterListOfCategories = _filterListOfCategories;

@synthesize currentContactVerificationIP = _currentContactVerificationIP;

@synthesize curContactListingVC = _curContactListingVC;

@synthesize lastSolutionBlobID = _lastSolutionBlobID;

@synthesize lastProblemBlobID = _lastProblemBlobID;

@synthesize curprobSoluVC = _curprobSoluVC;

@synthesize curAddprobVC = _curAddprobVC;

@synthesize curTicketMonitorVC = _curTicketMonitorVC;

@synthesize ifticketRowselectedAndnewBtnPressed = _ifticketRowselectedAndnewBtnPressed;

@synthesize currentKDpopPresentVC = _currentKDpopPresentVC;

@synthesize currentKDListVc =_currentKDListVc;

@synthesize applicationList = _applicationList;

@synthesize currentServiceHelper = _currentServiceHelper;

// Voice Recognition
@synthesize currentRecoResult = m_currentRecoResult;
@synthesize currentTextField = m_currentTextField;
@synthesize currentTextView = _currentTextView;
@synthesize currentTMFilter = _currentTMFilter;
@synthesize currentSortingElement = _currentSortingElement;

@synthesize snoozeIntervalValue;

@synthesize selectedIndexInSettingsPage;

@synthesize filterPro_SolTicket;

@synthesize dBHelper;

@synthesize techNameList;

@synthesize solutionQueryString ;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self createActiveIndicatorView];
    
    self.monitorActionButtonState = NO;
	
	// Set the application defaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"bda11d91-7ade-4da1-855d-24adfe39d174" forKey:@"apikey_preference"];
	
	[defaults registerDefaults:appDefaults];
	
	[defaults synchronize];
	
    [SpeechKit setupWithID:@"NMDPTRIAL_Service_Tracking_Systems_NCEdElliott20110311135505"
		 			  host:@"sandbox.nmdp.nuancemobility.net" port:443 useSSL:NO delegate:self];// Voice Recognition

	// Set earcons to play
	SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
	SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
	SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];
	
	[SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
	[SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
	[SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];

	if (_categoryList == nil) 
	{
		_categoryList = [[NSMutableArray alloc] init];
	}
	
	if (_selectedEntities == nil) 
	{
		_selectedEntities = [[SelectedEntities alloc] init];
	}
    
	if (_filterListOfLocations == nil) 
	{
		_filterListOfLocations = [[NSMutableArray alloc] init];
	}
    
    if (_filterListOfSinceTypes == nil) 
	{
		_filterListOfSinceTypes = [[NSMutableArray alloc] init];
	}
    
    if (_filterListOfCategories == nil) 
	{
		_filterListOfCategories = [[NSMutableArray alloc] init];
	}
    
    if (snoozeIntervalValue == nil)
	{
		snoozeIntervalValue = [[NSMutableDictionary alloc] init];
	}
    if (_applicationList == nil)
	{
		_applicationList = [[NSMutableArray alloc] init];
	}

    _filterListOfSinceTypes = [NSArray arrayWithObjects:@"Oldest",@"Newest",nil];
	
    if (_filterListOfStatus == nil) 
	{
		_filterListOfStatus = [[NSMutableArray alloc] initWithObjects:@"High",@"Medium",@"Low",@"Pending",@"Closed", nil];
	}
    
    if (_currentServiceHelper == nil) {
        
        _currentServiceHelper = [[ServiceHelper alloc]init];
    }
    
    if (techNameList == nil)
    {
        techNameList = [[NSMutableArray alloc] init];
    }

    [TestFlight takeOff:SP_TESTFLIGHT_TeamToken];
    
    #ifdef TESTING
        [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    #endif

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSError *error;
    
    NSString *dataPath = [documentsDir stringByAppendingPathComponent:@"Images"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];

    return YES;
}
		
- (void)recordButtonAction:(UITextField *)currentTextField 
              languageType:(int)languageType
{
    if (transactionState == TS_RECORDING) 
    {
        [voiceSearch stopRecording];
    }
    else if (transactionState == TS_IDLE) 
    {
        SKEndOfSpeechDetection detectionType;
        NSString* recoType;
        NSString* langType;
        
        transactionState = TS_INITIAL;
        
        if(currentTextField != nil)
        {
            [self setCurrentTextField:currentTextField];
            
            [currentTextField resignFirstResponder];
		}
        
        // alternativesDisplay.text = @"";
        
        // if (recognitionType.selectedSegmentIndex == 0) {
        //     /* 'Search' is selected */
        //     detectionType = SKShortEndOfSpeechDetection; /* Searches tend to be short utterances free of pauses. */
        //     recoType = SKSearchRecognizerType; /* Optimize recognition performance for search text. */
        // }
        // else {
        // /* 'Dictation' is selected */
        //     detectionType = SKLongEndOfSpeechDetection; /* Dictations tend to be long utterances that may include short pauses. */
        //     recoType = SKDictationRecognizerType; /* Optimize recognition performance for dictation or message text. */
        // }
		
        // 'Dictation' is selected 
        detectionType = SKLongEndOfSpeechDetection;     // Dictations tend to be long utterances that may include short pauses
        recoType = SKDictationRecognizerType;           // Optimize recognition performance for dictation or message text. 
        
        // // 'Search' is selected 
        // detectionType = SKShortEndOfSpeechDetection;    // Searches tend to be short utterances free of pauses. 
        // recoType = SKSearchRecognizerType;              // Optimize recognition performance for search text. 
        
		switch (languageType) 
        {
			case 0:
				langType = @"en_US";
				break;
			case 1:
				langType = @"en_GB";
				break;
			case 2:
				langType = @"fr_FR";
				break;
			case 3:
				langType = @"de_DE";
				break;
			default:
				langType = @"en_US";
				break;
		}
        
        // Nuance can also create a custom recognition type optimized for your application 
        // if neither search nor dictation are appropriate. 
        
        //NSLog(@"Recognizing type:'%@' Language Code: '%@' using end-of-speech detection:%d.", recoType, langType, detectionType);
        
        if (voiceSearch) 
		{
			voiceSearch = nil;
		}
		
        voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                               detection:detectionType
                                                language:langType 
                                                delegate:self];
    }
}
- (void)recordButtonActionTextView:(UITextView *)currentTextView
              languageType:(int)languageType
{
    if (transactionState == TS_RECORDING) 
    {
        [voiceSearch stopRecording];
    }
    else if (transactionState == TS_IDLE) 
    {
        SKEndOfSpeechDetection detectionType;
        NSString* recoType;
        NSString* langType;
        
        transactionState = TS_INITIAL;
        
        if(currentTextView != nil)
        {
            [self setCurrentTextView:currentTextView];
            
            [currentTextView resignFirstResponder];
		}
        
        // alternativesDisplay.text = @"";
        
        // if (recognitionType.selectedSegmentIndex == 0) {
        //     /* 'Search' is selected */
        //     detectionType = SKShortEndOfSpeechDetection; /* Searches tend to be short utterances free of pauses. */
        //     recoType = SKSearchRecognizerType; /* Optimize recognition performance for search text. */
        // }
        // else {
        // /* 'Dictation' is selected */
        //     detectionType = SKLongEndOfSpeechDetection; /* Dictations tend to be long utterances that may include short pauses. */
        //     recoType = SKDictationRecognizerType; /* Optimize recognition performance for dictation or message text. */
        // }
		
        // 'Dictation' is selected 
        detectionType = SKLongEndOfSpeechDetection;     // Dictations tend to be long utterances that may include short pauses
        recoType = SKDictationRecognizerType;           // Optimize recognition performance for dictation or message text. 
        
        // // 'Search' is selected 
        // detectionType = SKShortEndOfSpeechDetection;    // Searches tend to be short utterances free of pauses. 
        // recoType = SKSearchRecognizerType;              // Optimize recognition performance for search text. 
        
		switch (languageType) 
        {
			case 0:
				langType = @"en_US";
				break;
			case 1:
				langType = @"en_GB";
				break;
			case 2:
				langType = @"fr_FR";
				break;
			case 3:
				langType = @"de_DE";
				break;
			default:
				langType = @"en_US";
				break;
		}
        
        // Nuance can also create a custom recognition type optimized for your application 
        // if neither search nor dictation are appropriate. 
        
        //NSLog(@"Recognizing type:'%@' Language Code: '%@' using end-of-speech detection:%d.", recoType, langType, detectionType);
        
        if (voiceSearch) 
		{
			voiceSearch = nil;
		}
		
        voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                               detection:detectionType
                                                language:langType 
                                                delegate:self];
    }
}


#pragma mark -
#pragma mark SKRecognizerDelegate methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    //NSLog(@"Recording started.");
    
    transactionState = TS_RECORDING;
    
    // [recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
    
    // [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    //NSLog(@"Recording finished.");
    
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateVUMeter) object:nil];
    
    // [self setVUMeterWidth:0.];
    
    transactionState = TS_PROCESSING;
    
    // [recordButton setTitle:@"Processing..." forState:UIControlStateNormal];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    //NSLog(@"Got results.");
    
    long numOfResults = [results.results count];
    
    transactionState = TS_IDLE;
    
    // [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    if (numOfResults > 0)
    {
        [self setCurrentRecoResult:[results firstResult]];
		
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentRecoResultChanged" 
                                                            object:[self currentTextField]];
        
        //NSLog(@"%@", [results firstResult]);
    }
    
	if (numOfResults > 1) 
    {
        //NSLog(@"%@", [[results.results subarrayWithRange:NSMakeRange(1, numOfResults-1)] componentsJoinedByString:@"\n"]);
    }
    
    if (results.suggestion) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:results.suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];        
        [alert show];
    }
    
	voiceSearch = nil;
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    //NSLog(@"Got error.");
    
    transactionState = TS_IDLE;
    
    // [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];        
    [alert show];
    
    if (suggestion) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];        
        [alert show];
    }
    
    voiceSearch = nil;
}


#pragma mark End of SKRecognizerDelegate methods

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults *defaluts=[NSUserDefaults standardUserDefaults];
    
    if ([defaluts boolForKey:@"DeailyRecapIsActvie"])
    {
        dailyRecapOBJ =[[DailyRecapDB alloc]init];
        NSMutableArray *daillyRecaplistFrmSQL= [dBHelper loadData];
        NSMutableString *jsonStringBuilder = nil; 
        NSString *jsonString = @"";
        
        for (int i =0;i <[daillyRecaplistFrmSQL count];i++ )
        {
            dailyRecapOBJ=[daillyRecaplistFrmSQL objectAtIndex:i];
            @try
            {
                if (jsonStringBuilder == nil)
                {
                    jsonStringBuilder = [[NSMutableString alloc] init];
                }
                if (i==0)
                    [jsonStringBuilder appendFormat:@"\t[ { \n"];
                else
                    [jsonStringBuilder appendFormat:@"\t{ \n"];
                
                [jsonStringBuilder appendFormat:@"\t     \"Tech\":\"%@\", \n",   [dailyRecapOBJ tech]];
                [jsonStringBuilder appendFormat:@"\t     \"Action\":\"%@\", \n", [dailyRecapOBJ action]];
                [jsonStringBuilder appendFormat:@"\t     \"Object\":\"%@\", \n", [dailyRecapOBJ object]];
                [jsonStringBuilder appendFormat:@"\t     \"Value\":\"%@\", \n",  [dailyRecapOBJ value]];
                [jsonStringBuilder appendFormat:@"\t     \"TimeStamp\":\"\\/Date(%.0f)\\/\" \n", [[NSDate date] timeIntervalSince1970] * 1000];
                
                if (i==[daillyRecaplistFrmSQL count]-1)
                    [jsonStringBuilder appendFormat:@"\t} ]"];
                else
                    [jsonStringBuilder appendFormat:@"\t},"];
                
                jsonString = jsonStringBuilder;
            }
            @catch (NSException *exception)
            {
                //NSLog(@"Error occurred in toJsonString.  Error: %@", [exception description]);
                
                jsonString = @"";
            }
            @finally
            {
                
            }
        }
        //  NSLog(@"jsonstring = %@",jsonString);
        NSString *response=[ServiceHelper addDailyRecaplist:jsonString];
        //  NSLog(@"response = %@",response);
        
        if (response !=nil)
        {
            [dBHelper deleteFromDatabase];
        }
    }
    
    [self uploadingBlobs];
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        
        [application endBackgroundTask:bgTask];
        
        bgTask = UIBackgroundTaskInvalid;
        
    }];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)uploadingBlobs
{
    NSString *folderName = @"Images";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *currentfilename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,folderName];
    
    NSArray *directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentfilename error:nil];
    
    int numberOfFileInFolder;
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"];
    NSArray *onlyTXTs = [directoryContent filteredArrayUsingPredicate:fltr];
    numberOfFileInFolder = [onlyTXTs  count];
    
    documentDirectoryUrl = [[NSMutableDictionary alloc] init];
    
    websiteData = [NSMutableDictionary dictionaryWithCapacity:5];
    
    operationQueue = [NSOperationQueue new];
    
    [operationQueue setMaxConcurrentOperationCount:5];
    
    for (int i = 0; i < numberOfFileInFolder; i++)
    {
        NSString *keyValue = [NSString stringWithFormat:@"%d",i];
        
        NSString *currentfilename = [NSString stringWithFormat:@"%@/%@/%@",documentsDirectory,folderName,[onlyTXTs objectAtIndex:i]];
        
        NSData *data = [[NSMutableData alloc]initWithContentsOfFile:currentfilename];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSMutableDictionary *sessionDataDictionary = [unarchiver decodeObjectForKey:[NSString stringWithFormat:@"blobDetails%d",i]];
        [unarchiver finishDecoding];
        
        NSString *Type;
        NSString *Id;
        NSData *bytes;
        NSString *typeId;
        
        Type = [sessionDataDictionary objectForKey:@"type"];
        
        Id = [sessionDataDictionary objectForKey:@"Id"];
        bytes = [sessionDataDictionary objectForKey:@"BlobBytes"];
        typeId = [sessionDataDictionary objectForKey:@"BlobTypeId"];
        
        //        NSLog(@"Type = %@",Type);
        //        NSLog(@"solutionId = %@",Id);
        //        NSLog(@"solution image = %@",bytes);
        //        NSLog(@"ST_IMAGE_BlobTypeId = %@",typeId);
        
        
        [documentDirectoryUrl setValue:currentfilename forKey:keyValue];
        
        FTURLOperation *operation = [[FTURLOperation alloc] initWithJSON:Type solutionId:Id blobBytes:bytes blobTypeId:typeId currentFileUrl:currentfilename] ;
        [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
        [operationQueue addOperation:operation]; // operation starts as soon as its added
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)operation change:(NSDictionary *)change context:(void *)context {
    NSString *source = nil;
    NSData *data = nil;
    NSError *error = nil;
    
    if ([operation isKindOfClass:[FTURLOperation class]])
    {
        FTURLOperation *downloadOperation = (FTURLOperation *)operation;
        for (NSString *key in [documentDirectoryUrl allKeys])
        {
            if ([[documentDirectoryUrl valueForKey:key] isEqualToString:downloadOperation.currentFileUrl])
            {
                source = key;
                break;
            }
        }
        if (source) {
            data = [downloadOperation data];
            error = [downloadOperation error];
        }
    }
    
    if (source) {
        NSString *docuDirectoryUrl = [documentDirectoryUrl objectForKey:source];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:docuDirectoryUrl error:NULL];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSArray *directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
        int numberOfFileInFolder = [directoryContent  count];
        NSLog(@"count= %d", numberOfFileInFolder);
        if (error != nil) {
            // handle error
            // Notify that we have got an error downloading this data;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DataDownloadFailed"
                                                                object:self
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:source, @"source", error, @"error", nil]];
            
        } else {
            // Notify that we have got this source data;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DataDownloadFinished"
                                                                object:self
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:source, @"source", data, @"data", nil]];
            // save data
            [websiteData setValue:data forKey:source];
        }
    }
}

#pragma  mark - ActiveIndicatorMethods

- (void)createActiveIndicatorView
{
    loadingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    loadingBgView.backgroundColor = [UIColor clearColor];
    loadingBgView.center = CGPointMake(self.window.frame.size.width / 2, self.window.frame.size.height / 2);
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.5;
    grayView.center = CGPointMake(self.window.frame.size.width / 2, self.window.frame.size.height / 2);
    [loadingBgView addSubview:grayView];
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.layer.cornerRadius = 10;
    loadingView.layer.borderWidth = 1;
    loadingView.layer.borderColor = [UIColor whiteColor].CGColor;
    loadingView.center = CGPointMake(self.window.frame.size.width / 2, self.window.frame.size.height / 2);
    
    UIActivityIndicatorView  *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(0, 0,40, 40);;
    [loadingView addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, 70 / 2);
    [activityIndicator startAnimating];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 120, 20)];
    textLabel.text =@"Loading..";
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [loadingView addSubview:textLabel];
    
    [loadingBgView addSubview:loadingView];
    
}

+ (void)activeIndicatorStartAnimating:(UIView*)view
{
    loadingView.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
    [activityIndicator startAnimating];
    [view addSubview:loadingBgView];
}

+ (void)activeIndicatorStopAnimating
{
    [activityIndicator stopAnimating];
    [loadingBgView removeFromSuperview];
}

#pragma  mark - ActivityIndicatorMethods for present model alone

+ (void)activityIndicatorStartAnimating:(UIView*)view
{
    loadingBgView.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
    [activityIndicator startAnimating];
    [view addSubview:loadingBgView];
}

+ (void)activityIndicatorStopAnimating
{
    [activityIndicator stopAnimating];
    [loadingBgView removeFromSuperview];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation NS_AVAILABLE_IOS(4_2); // no equiv. notification. return NO if the application can't open for some reason
{
    NSLog(@"URL: which is coming: %@",url);
 
    NSString *stringUrl = [[NSString alloc]initWithFormat:@"You have clicked: %@",url];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"INFO" message:stringUrl delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    return YES;
}
@end
