typedef enum{
    
    LOCATION_FILTER,
    CONTACT_FILTER,
    SINCE_FILTER,
    TICKET_FILTER,
    CATEGORY_FILTER,
    TECH_FILTER,
    STATUS_FILTER,
    SERVICEPLAN_FILTER
    
} TicketMonitorFilter;

typedef enum
{
    LOCATION_ELEMENT = 0,
    CONTACT_ELEMENT,
    SINCE_ELEMENT,
    TICKET_ELEMENT,
    CATEGORY_ELEMENT,
    TECH_ELEMENT,
    STATUS_ELEMENT,
    SERVICEPLAN_ELEMENT
    
} TicketMonitorSortingElement;

typedef enum
{
    NEW_WITH_TM_ROW_SEL,
    NEW_WO_TM_ROW_SEL,
    
} TicketMonitorActionMenu;

typedef enum 
{
    NoHelpDocs = 1,
    JustHelpDocs = 2,
    Combined = 3
}helpDocOptions;

typedef enum
{
    TICKETMONITER_VC,
    PROBLEMSOLUTION_VC,
    KDLIST_VC
    
}KDPopUpViewPresentControllers;

#define SP_TESTFLIGHT_TeamToken @"0c877fe27f91bfc041d751a3d9a43aa4_OTUzNzIyMDEyLTA1LTMxIDA1OjQ4OjQ3LjQwOTQ1Mw"

#define ST_VIDEO_BlobTypeId @"B07ED0F5-2B0B-4628-9DC5-5DACC224ECCD"

#define ST_AUDIO_BlobTypeId @"A140795F-48B7-4FC8-B8E4-6E216705B4CA"

#define ST_IMAGE_BlobTypeId @"A2C27AD5-D614-4AFE-A353-B3F7268D82A6"

#define ST_User_Role_ADMIN @"e70d5798-8130-4081-a664-ba494e8cbc4d"

#define ST_User_Role_TECH @"a6849e5a-19af-4efc-a4f5-71a7f296f1bb"

#define ST_User_Role_TECH_SUPER @"6c49c5f9-d664-48f9-b62a-5f6246c40157"

#define ST_User_Role_BACK_OFFICE @"6039bc0c-f6dc-413c-9071-dbed0d6f51af"

#define ST_User_Role_Customer_Care @"b17221e0-1967-4468-9f35-2926a51d4398"


#define ST_TM_No_Rows @"No rows found for the given filter criteria. Please try again."
