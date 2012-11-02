//
//  ServiceHelper.m
//  NYStateSnowmobiling
//
//  Created by Edward Elliott on 4/11/11.
//  Copyright 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "ServiceHelper.h"
#import "EmailNotification.h"
#import "TicketMoniter.h"
#import "Blob.h"
#import "BlobEntity.h"
#import "ServiceTechConstants.h"
#import "SolutionBlobPacket.h"
#import "ProblemBlobPacket.h"
#import "UserRolls.h"
#import "Base64Utils.h"
#import "Snooze.h"
#import "IntervalType.h"
#import "SnoozeReason.h"

@implementation ServiceHelper

@synthesize asynchUrlDelegate;

NSMutableData *_responseData;    

//NSString *_rootUrl = @"http://www.ekeservices.net/ServicePleaseWebService";
 NSString *_rootUrl = @"http://sts-03.servicetrackingsystems.com/ServiceTechService";

#pragma mark HTTP Methods
+ (NSString *)stringWithUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method
{
	NSString *jsonString = nil;
	
	@try 
	{
		NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
																   cachePolicy:NSURLRequestReloadIgnoringCacheData
															   timeoutInterval:1200];
		
		[urlRequest setHTTPMethod:method];
		
		if(postData != nil)
		{
			[urlRequest setHTTPBody:postData];
		}
		
		[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		[urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
		
		// Fetch the JSON response
		NSData *urlData;
		NSURLResponse *response;
		
		NSError *error;
		
		// Sending the request
		
		// Make synchronous request
		urlData = [NSURLConnection sendSynchronousRequest:urlRequest
										returningResponse:&response
													error:&error];
				
		// Construct a String around the Data from the response
		jsonString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];

//        //NSLog(@" ********** RESPONSE STRING ********: %@",jsonString);
		return jsonString;	
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.stringWithUrl - Error: %@", [exception description]);
	}
	@finally 
	{
		// //NSLog(@"Leaving stringWithUrl");
	}
}

+ (BOOL) connectedToInternet
{
	NSString *ekeSvcString = [NSMutableString stringWithFormat:@"http://www.ekeservices.net/ServicePleaseWebService/categories"]; 
	
	NSStringEncoding encoding;
	
	NSError *err = nil;
	
	NSString *urlContents = [NSString stringWithContentsOfURL:[NSURL URLWithString:ekeSvcString] usedEncoding:&encoding error:&err];
	
	if(urlContents)
	{
//		//NSLog(@"urlContents %@", urlContents);
	} 
	else 
	{
		// only check or print out err if urlContents is nil
		//NSLog(@"err %@",err);
	}
		
	return ( urlContents != NULL ) ? YES : NO;
}

+ (id) objectWithUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method
{
	id theObject = nil;
	
	@try 
	{
		// Calling stringWithUrl
		NSString *jsonString = [self stringWithUrl:url postData:postData httpMethod:method];
		
		// Converting jsonString to NSData
		NSData *theJSONData = [NSData dataWithBytes:[jsonString UTF8String] 
											 length:[jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
		
		NSError *theError = nil;
		
		// Parse the JSON into an Object
		theObject = [[CJSONDeserializer deserializer] deserialize:theJSONData error:&theError];	
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.objectWithUrl - Error: %@", [exception description]);
		theObject = nil;
	}
	@finally 
	{
		// //NSLog(@"Leaving objectWithUrl");
	}
	
	return theObject;
}

#pragma mark Category

+ (BOOL) doescategoryExist:(NSString *)categoryName
{
	BOOL categoryExists = NO;
	
	@try
	{
        NSString *trimmedcategoryName = [categoryName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

		NSMutableArray *categorieList = [ServiceHelper getAllCategories];
		
		NSEnumerator *enumerator = [categorieList objectEnumerator];
		
		Category *category = nil;
		
		while (category = [enumerator nextObject])
		{
            NSString *trimmedcategoriesName = [[category categoryName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

			if ([[trimmedcategoriesName lowercaseString] compare:[trimmedcategoryName lowercaseString]] == 0)
			{
				categoryExists = YES;
				
				break;
			}
		}
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in doesLocationExist.  Error: %@", [exception description]);
		
		categoryExists = NO;
	}
	@finally
	{
		return categoryExists;
	}
}

+ (Category *) getCategory:(NSString *)categoryId
{
	Category *category = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/category/%@", _rootUrl, categoryId];
		
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id currentCategory = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
        category = [[Category alloc]init];
        
        [category setCategoryId:[currentCategory valueForKey:@"CategoryId"]];
        [category setOrganizationId:[currentCategory valueForKey:@"OrganizationId"]];
        [category setCategoryName:[currentCategory valueForKey:@"CategoryName"]];
        id CategoryIcon = [currentCategory valueForKey:@"CategoryIcon"];
        UIImage *image = NULL;
        if (CategoryIcon == [NSNull null])
            [category setCategoryIcon:image];
        else
            [category setCategoryIcon:(UIImage *)CategoryIcon];
        [category setCreateDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"CreateDate"]]];
        [category setEditDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"EditDate"]]];
        
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getCategory.  Error: %@", [exception description]);
		
		category = nil;
	}
	@finally 
	{
        return category;
	}
}

+ (NSMutableArray *) getAllCategories
{
        NSMutableArray *categoryListing = nil;
        
        @try 
        {
            
            NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/categories", _rootUrl];
            
            NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
            
            id categories = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
            
            if(categories != nil && [categories count] > 0)
            {
                id currentCategory = nil;
                
                NSEnumerator *enumerator = [categories objectEnumerator];
                
                if(categoryListing == nil)
                {
                    categoryListing = [[NSMutableArray alloc] init];
                }
                
                while (currentCategory = [enumerator nextObject])
                {
                    Category *category = [[Category alloc] init];
                    
                    [category setCategoryId:[currentCategory valueForKey:@"CategoryId"]];
                    [category setCategoryName:[currentCategory valueForKey:@"CategoryName"]];
                    [category setCategoryIcon:[currentCategory valueForKey:@"CategoryIcon"]];
                    
                    id CategoryIcon = [currentCategory valueForKey:@"CategoryIcon"];
                    UIImage *image = NULL;
                    if (CategoryIcon == [NSNull null])
                        [category setCategoryIcon:image];
                    else
                        [category setCategoryIcon:(UIImage *)CategoryIcon];

                    [category setOrganizationId:[currentCategory valueForKey:@"OrganizationId"]];
                    [category setCreateDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"CreateDate"]]];
                    [category setEditDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"EditDate"]]];
                    
                    [categoryListing addObject:category];
                }
            }
        }
        @catch (NSException *exception) 
        {
            //NSLog(@"Error in getCategoriesByOrganization.  Error: %@", [exception description]);
            
            categoryListing = nil;
        }
        @finally 
        {
            return categoryListing;
        }
}


+ (NSMutableArray *) getCategoriesByOrganization:(NSString *)organizationId
{
	NSMutableArray *categoryListing = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/categoriesByOrganization/%@", _rootUrl, organizationId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id categories = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(categories != nil && [categories count] > 0)
		{
			id currentCategory = nil;
			
			NSEnumerator *enumerator = [categories objectEnumerator];
			
			if(categoryListing == nil)
			{
				categoryListing = [[NSMutableArray alloc] init];
			}
			
			while (currentCategory = [enumerator nextObject])
			{
				Category *category = [[Category alloc] init];
				
				[category setCategoryId:[currentCategory valueForKey:@"CategoryId"]];
				[category setCategoryName:[currentCategory valueForKey:@"CategoryName"]];
                id CategoryIcon = [currentCategory valueForKey:@"CategoryIcon"];
                UIImage *image = NULL;
                if (CategoryIcon == [NSNull null])
                    [category setCategoryIcon:image];
                else
                    [category setCategoryIcon:(UIImage *)CategoryIcon];
                [category setOrganizationId:[currentCategory valueForKey:@"OrganizationId"]];
				[category setCreateDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"CreateDate"]]];
				[category setEditDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"EditDate"]]];
				
				[categoryListing addObject:category];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getCategoriesByOrganization.  Error: %@", [exception description]);
		
		categoryListing = nil;
	}
	@finally 
	{
		return categoryListing;
	}
}

+ (Category *) addCategory:(Category *)category
{
	Category *newCategory = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/category", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Category toJsonString:category indent:NO];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentCategory = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (newCategory == nil) 
		{
			newCategory = [[Category alloc] init];
		}
		
		[newCategory setCategoryId:[currentCategory valueForKey:@"CategoryId"]];
		[newCategory setOrganizationId:[currentCategory valueForKey:@"OrganizationId"]];
		[newCategory setCategoryName:[currentCategory valueForKey:@"CategoryName"]];
		[newCategory setCategoryIcon:[currentCategory valueForKey:@"CategoryIcon"]];
		[newCategory setCreateDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"CreateDate"]]];
		[newCategory setEditDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"EditDate"]]];
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getCategory.  Error: %@", [exception description]);
		
		newCategory = nil;
	}
	@finally 
	{
		return newCategory;
	}	
}

+ (Category *) updateCategory:(Category *)category
{
	Category *updatedCategory = nil;
	
	@try
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/updateCategory?categoryId=%@", _rootUrl,category.categoryId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Category toJsonString:category indent:NO];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentCategory = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (updatedCategory == nil)
		{
			updatedCategory = [[Category alloc] init];
		}
		
		[updatedCategory setCategoryId:[currentCategory valueForKey:@"CategoryId"]];
		[updatedCategory setOrganizationId:[currentCategory valueForKey:@"OrganizationId"]];
		[updatedCategory setCategoryName:[currentCategory valueForKey:@"CategoryName"]];
		[updatedCategory setCategoryIcon:[currentCategory valueForKey:@"CategoryIcon"]];
		[updatedCategory setCreateDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"CreateDate"]]];
		[updatedCategory setEditDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"EditDate"]]];
	}
	@catch (NSException *exception)
	{
		updatedCategory = nil;
	}
	@finally
	{
		return updatedCategory;
	}
}

+ (NSString *) deleteCategory:(NSString *)categoryId
{
    NSString *response ;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/deleteCategory?categoryId=%@", _rootUrl,categoryId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
        
	}
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}

#pragma mark Contact


+ (NSMutableArray *) getContacts
{
	NSMutableArray *contactList = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/contacts", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id contacts = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(contacts != nil && [contacts count] > 0)
		{
			id currentContact = nil;
			
			NSEnumerator *enumerator = [contacts objectEnumerator];
			
			if(contactList == nil)
			{
				contactList = [[NSMutableArray alloc] init];
			}
			
			while (currentContact = [enumerator nextObject])
			{
				Contact *contact = [[Contact alloc] init];
				
				[contact setContactId:[currentContact valueForKey:@"ContactId"]];
				[contact setOrganizationId:[currentContact valueForKey:@"OrganizationId"]];
				[contact setContactName:[currentContact valueForKey:@"ContactName"]];
				[contact setFirstName:[currentContact valueForKey:@"FirstName"]];
				[contact setMiddleName:[currentContact valueForKey:@"MiddleName"]];
				[contact setLastName:[currentContact valueForKey:@"LastName"]];
				[contact setEmail:[currentContact valueForKey:@"Email"]];
				[contact setPhone:[currentContact valueForKey:@"Phone"]];
				[contact setLocationId:[currentContact valueForKey:@"LocationId"]];
				[contact setCreateDate:[Utility getDateFromJSONDate:[currentContact valueForKey:@"CreateDate"]]];
				[contact setEditDate:[Utility getDateFromJSONDate:[currentContact valueForKey:@"EditDate"]]];
				
				[contactList addObject:contact];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getContacts.  Error: %@", [exception description]);
		
		contactList = nil;
	}
	@finally 
	{
		return contactList;
	}
}

+ (NSMutableArray *) getContactsByLocation:(NSString *)locationId
{
	NSMutableArray *contactList = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/contactsByLocation?locationId=%@", _rootUrl, locationId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id contacts = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(contacts != nil && [contacts count] > 0)
		{
			id currentContact = nil;
			
			NSEnumerator *enumerator = [contacts objectEnumerator];
			
			if(contactList == nil)
			{
				contactList = [[NSMutableArray alloc] init];
			}
			
			while (currentContact = [enumerator nextObject])
			{
				Contact *contact = [[Contact alloc] init];
				
				[contact setContactId:[currentContact valueForKey:@"ContactId"]];
				[contact setOrganizationId:[currentContact valueForKey:@"OrganizationId"]];
				[contact setContactName:[currentContact valueForKey:@"ContactName"]];
				[contact setFirstName:[currentContact valueForKey:@"FirstName"]];
				[contact setMiddleName:[currentContact valueForKey:@"MiddleName"]];
				[contact setLastName:[currentContact valueForKey:@"LastName"]];
				[contact setEmail:[currentContact valueForKey:@"Email"]];
				[contact setPhone:[currentContact valueForKey:@"Phone"]];
                id CallbackNumber = [currentContact valueForKey:@"CallbackNumber"];
                if (CallbackNumber == [NSNull null])
                    [contact setCallBackNum:@""];
                else 
                    [contact setCallBackNum:(NSString *)CallbackNumber];
				[contact setLocationId:[currentContact valueForKey:@"LocationId"]];
				[contact setCreateDate:[Utility getDateFromJSONDate:[currentContact valueForKey:@"CreateDate"]]];
				[contact setEditDate:[Utility getDateFromJSONDate:[currentContact valueForKey:@"EditDate"]]];
				
				[contactList addObject:contact];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getContactsByLocation.  Error: %@", [exception description]);
		
		contactList = nil;
	}
	@finally 
	{
		return contactList;
	}
}

+ (Contact *) getContact:(NSString *)contactId
{
	Contact *contact = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/contact?contactId=%@", _rootUrl, contactId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id curContact = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
				
        contact = [[Contact alloc]init];
        
        [contact setContactId:[curContact valueForKey:@"ContactId"]];
        [contact setOrganizationId:[curContact valueForKey:@"OrganizationId"]];
        [contact setContactName:[curContact valueForKey:@"ContactName"]];
        [contact setFirstName:[curContact valueForKey:@"FirstName"]];
        [contact setMiddleName:[curContact valueForKey:@"MiddleName"]];
        [contact setLastName:[curContact valueForKey:@"LastName"]];
        [contact setEmail:[curContact valueForKey:@"Email"]];
        [contact setPhone:[curContact valueForKey:@"Phone"]];
        [contact setLocationId:[curContact valueForKey:@"LocationId"]];
        [contact setCreateDate:[Utility getDateFromJSONDate:[curContact valueForKey:@"CreateDate"]]];
        [contact setEditDate:[Utility getDateFromJSONDate:[curContact valueForKey:@"EditDate"]]];
    }
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getContact.  Error: %@", [exception description]);
		
		contact = nil;
	}
	@finally 
	{
		return contact;
	}
}

+ (BOOL) doesContactExist:(NSString *)contactName 
				firstName:(NSString *)firstName 
			   middleName:(NSString *)middleName
				 lastName:(NSString *)lastName
{
	BOOL contactExists = NO;
	
	@try 
	{
        NSString *trimmedcontactName = [contactName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *trimmedfirstName = [firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *trimmedmiddleName = [middleName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *trimmedlastName = [lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

		NSMutableArray *contactList = [ServiceHelper getContacts];
		
		NSEnumerator *enumerator = [contactList objectEnumerator];
		
		Contact *contact = nil;
		
		while (contact = [enumerator nextObject]) 
		{
            NSString *trimmedcontactName1 = [[contact contactName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *trimmedfirstName1 = [[contact firstName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *trimmedmiddleName1 = [[contact middleName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

            NSString *trimmedlastName1 = [[contact lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

			if ([[trimmedcontactName1 lowercaseString] compare:[trimmedcontactName lowercaseString]] == 0 &&
				[[trimmedfirstName1 lowercaseString] compare:[trimmedfirstName lowercaseString]] == 0 &&
				[[trimmedmiddleName1 lowercaseString]  compare:[trimmedmiddleName lowercaseString]] == 0 &&
				[[trimmedlastName1 lowercaseString]  compare:[trimmedlastName lowercaseString]] == 0)
			{
				contactExists = YES;
				
				break;
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in doesContactExist.  Error: %@", [exception description]);
		
		contactExists = NO;
	}
	@finally 
	{
		return contactExists;
	}
}

+ (Contact *) addContact:(Contact *)contact
{
	Contact *newContact = nil;
	
	@try  
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/contact", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Contact toJsonString:contact indent:NO];
        
        ////NSLog(@"ADD Contact Json String : %@",jsonString);
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentContact = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (newContact == nil) 
		{
			newContact = [[Contact alloc] init];
		}
		
		[newContact setContactId:[currentContact valueForKey:@"ContactId"]];
		[newContact setOrganizationId:[currentContact valueForKey:@"OrganizationId"]];
		[newContact setContactName:[currentContact valueForKey:@"ContactName"]];
		[newContact setFirstName:[currentContact valueForKey:@"FirstName"]];
		[newContact setMiddleName:[currentContact valueForKey:@"MiddleName"]];
		[newContact setLastName:[currentContact valueForKey:@"LastName"]];
		[newContact setEmail:[currentContact valueForKey:@"Email"]];
		[newContact setLocationId:[currentContact valueForKey:@"LocationId"]];
		[newContact setPhone:[currentContact valueForKey:@"Phone"]];
        [newContact setCallBackNum:[currentContact valueForKey:@"CallbackNumber"]];
		[newContact setCreateDate:[Utility getDateFromJSONDate:[currentContact valueForKey:@"CreateDate"]]];
		[newContact setEditDate:[Utility getDateFromJSONDate:[currentContact valueForKey:@"EditDate"]]];
	}
	@catch (NSException *exception) 
	{
		newContact = nil;
		
		//NSLog(@"Error in addContact.  Error: %@", [exception description]);
	}
	@finally 
	{
		return newContact;
	}
}

+ (Contact *) updateContact:(Contact *)contact contactId:(NSString *)contactId
{
	Contact *updatedContact = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/updateContact?contactId=%@", _rootUrl,contactId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Contact toJsonString:contact indent:NO];
        
      //  //NSLog(@"contact- %@",jsonString);
		
        NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentContact = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
        
        if (updatedContact == nil) 
		{
			updatedContact = [[Contact alloc] init];
		}
		
		[updatedContact setContactId:[currentContact valueForKey:@"ContactId"]];
		[updatedContact setOrganizationId:[currentContact valueForKey:@"OrganizationId"]];
		[updatedContact setContactName:[currentContact valueForKey:@"ContactName"]];
		[updatedContact setFirstName:[currentContact valueForKey:@"FirstName"]];
		[updatedContact setMiddleName:[currentContact valueForKey:@"MiddleName"]];
		[updatedContact setLastName:[currentContact valueForKey:@"LastName"]];
		[updatedContact setEmail:[currentContact valueForKey:@"Email"]];
		[updatedContact setLocationId:[currentContact valueForKey:@"LocationId"]];
		[updatedContact setPhone:[currentContact valueForKey:@"Phone"]];
        [updatedContact setCallBackNum:[currentContact valueForKey:@"CallbackNumber"]];
		[updatedContact setCreateDate:[Utility getDateFromJSONDate:[currentContact valueForKey:@"CreateDate"]]];
		[updatedContact setEditDate:[Utility getDateFromJSONDate:[currentContact valueForKey:@"EditDate"]]];
	}
	@catch (NSException *exception) 
	{
		updatedContact = nil;
		
		//NSLog(@"Error in updateContact.  Error: %@", [exception description]);
        
    }
	@finally 
	{
        return updatedContact;
	}
}

+ (NSString *) deleteContact:(NSString *)contactId
{
    NSString *response ;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/deleteContact?contactId=%@", _rootUrl,contactId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
        
	}
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}

#pragma mark ServicePlanTypes
+ (NSMutableArray *) getServicePlanTypes
{
	NSMutableArray *ServicePlanTypeList = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/servicePlanTypes", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id ServicePlanTypes = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(ServicePlanTypes != nil && [ServicePlanTypes count] > 0)
		{
			id currentServicePlanType = nil;
			
			NSEnumerator *enumerator = [ServicePlanTypes objectEnumerator];
			
			if(ServicePlanTypeList == nil)
			{
				ServicePlanTypeList = [[NSMutableArray alloc] init];
			}
			
			while (currentServicePlanType = [enumerator nextObject])
    		{
                
                
				SPTypes *servicePlanTypes = [[SPTypes alloc] init];
				
				[servicePlanTypes setServicePlanTypeId:[currentServicePlanType valueForKey:@"ServicePlanTypeId"]];
				[servicePlanTypes setName:[currentServicePlanType valueForKey:@"Name"]];
				[servicePlanTypes setCreateDate:[Utility getDateFromJSONDate:[currentServicePlanType valueForKey:@"CreateDate"]]];
				[servicePlanTypes setEditDate:[Utility getDateFromJSONDate:[currentServicePlanType valueForKey:@"EditDate"]]];
				
				[ServicePlanTypeList addObject:servicePlanTypes];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getContacts.  Error: %@", [exception description]);
		
		ServicePlanTypeList = nil;
	}
	@finally 
	{
		return ServicePlanTypeList;
	}
}


#pragma mark Location
+ (NSMutableArray *) getLocations
{
	NSMutableArray *locationList = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/locations", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id locations = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(locations != nil && [locations count] > 0)
		{
			id currentLocation = nil;
			
			NSEnumerator *enumerator = [locations objectEnumerator];
			
			if(locationList == nil)
			{
				locationList = [[NSMutableArray alloc] init];
			}
			
			while (currentLocation = [enumerator nextObject])
			{
				Location *location = [[Location alloc] init];
				
				[location setLocationId:[currentLocation valueForKey:@"LocationId"]];
				[location setOrganizationId:[currentLocation valueForKey:@"OrganizationId"]];
				[location setLocationInfoId:[currentLocation valueForKey:@"LocationInfoId"]];
				[location setLocationName:[currentLocation valueForKey:@"LocationName"]];
				[location setCreateDate:[Utility getDateFromJSONDate:[currentLocation valueForKey:@"CreateDate"]]];
				[location setEditDate:[Utility getDateFromJSONDate:[currentLocation valueForKey:@"EditDate"]]];
				
				[locationList addObject:location];
			}
		}
	}
	@catch (NSException *exception) 
	{
		locationList = nil;
		
		//NSLog(@"Error in getLocations.  Error: %@", [exception description]);
	}
	@finally 
	{
		return locationList;
	}
}

+ (NSMutableArray *) getLocationsByOrganization:(NSString *)organizationId
{
	NSMutableArray *locationList = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/locationsByOrganization?organizationId=%@", _rootUrl, organizationId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id locations = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(locations != nil && [locations count] > 0)
		{
			id currentLocation = nil;
			
			NSEnumerator *enumerator = [locations objectEnumerator];
			
			if(locationList == nil)
			{
				locationList = [[NSMutableArray alloc] init];
			}
			
			while (currentLocation = [enumerator nextObject])
			{
				Location *location = [[Location alloc] init];
				
				[location setLocationId:[currentLocation valueForKey:@"LocationId"]];
				[location setOrganizationId:[currentLocation valueForKey:@"OrganizationId"]];
				[location setLocationInfoId:[currentLocation valueForKey:@"LocationInfoId"]];
				[location setLocationName:[currentLocation valueForKey:@"LocationName"]];
				[location setCreateDate:[Utility getDateFromJSONDate:[currentLocation valueForKey:@"CreateDate"]]];
				[location setEditDate:[Utility getDateFromJSONDate:[currentLocation valueForKey:@"EditDate"]]];
				
				[locationList addObject:location];
			}
		}
	}
	@catch (NSException *exception) 
	{
		locationList = nil;
		
		//NSLog(@"Error in getLocationsByOrganization.  Error: %@", [exception description]);
	}
	@finally 
	{
		return locationList;
	}
}

+ (BOOL) doesLocationExist:(NSString *)locationName
{
	BOOL locationExists = NO;
	
	@try 
	{
        NSString *trimmedlocationName = [locationName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

		NSMutableArray *locationList = [ServiceHelper getLocations];
		
		NSEnumerator *enumerator = [locationList objectEnumerator];
		
		Location *location = nil;
		
		while (location = [enumerator nextObject]) 
		{
            NSString *trimmedlocationsName = [[location locationName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

			if ([[trimmedlocationsName lowercaseString] compare:[trimmedlocationName lowercaseString]] == 0)
			{
				locationExists = YES;
				
				break;
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in doesLocationExist.  Error: %@", [exception description]);
		
		locationExists = NO;
	}
	@finally 
	{
		return locationExists;
	}
}

+ (Location *) addLocation:(Location *)location
{
	Location *newLocation = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/location", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Location toJsonString:location indent:NO];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentLocation = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (newLocation == nil) 
		{
			newLocation = [[Location alloc] init];
		}
		
		[newLocation setLocationId:[currentLocation valueForKey:@"LocationId"]];
		[newLocation setOrganizationId:[currentLocation valueForKey:@"OrganizationId"]];
		[newLocation setLocationName:[currentLocation valueForKey:@"LocationName"]];
		[newLocation setLocationInfoId:[currentLocation valueForKey:@"LocationInfoId"]];
		[newLocation setCreateDate:[Utility getDateFromJSONDate:[currentLocation valueForKey:@"CreateDate"]]];
		[newLocation setEditDate:[Utility getDateFromJSONDate:[currentLocation valueForKey:@"EditDate"]]];
	}
	@catch (NSException *exception) 
	{
		newLocation = nil;
		
		//NSLog(@"Error in addLocation.  Error: %@", [exception description]);
	}
	@finally 
	{
		return newLocation;
	}
}

+ (Location *) updateLocation:(Location *)location
{
	Location *updatedLocation = nil;
	
	@try 
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/updateLocation?locationId=%@", _rootUrl,location.locationId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Location toJsonString:location indent:NO];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentLocation = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (updatedLocation == nil)
		{
			updatedLocation = [[Location alloc] init];
		}
		
		[updatedLocation setLocationId:[currentLocation valueForKey:@"LocationId"]];
		[updatedLocation setOrganizationId:[currentLocation valueForKey:@"OrganizationId"]];
		[updatedLocation setLocationName:[currentLocation valueForKey:@"LocationName"]];
		[updatedLocation setLocationInfoId:[currentLocation valueForKey:@"LocationInfoId"]];
		[updatedLocation setCreateDate:[Utility getDateFromJSONDate:[currentLocation valueForKey:@"CreateDate"]]];
		[updatedLocation setEditDate:[Utility getDateFromJSONDate:[currentLocation valueForKey:@"EditDate"]]];

	}
	@catch (NSException *exception) 
	{
		updatedLocation = nil;
	}
	@finally 
	{		
		return updatedLocation;
	}
}

+ (NSString *) deleteLocation:(NSString *)locationId
{
    NSString *response ;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/deleteLocation?locationId=%@", _rootUrl,locationId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
        
	}
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}

+ (Location *) getLocation:(NSString *)locationId
{
	Location *location = nil;
	
    @try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/location?locationId=%@", _rootUrl,locationId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id loc = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(loc != nil)
		{
			
            location = [[Location alloc] init];
            
            [location setLocationId:[loc valueForKey:@"LocationId"]];
            [location setOrganizationId:[loc valueForKey:@"OrganizationId"]];
            [location setLocationInfoId:[loc valueForKey:@"LocationInfoId"]];
            [location setLocationName:[loc valueForKey:@"LocationName"]];
            [location setCreateDate:[Utility getDateFromJSONDate:[loc valueForKey:@"CreateDate"]]];
            [location setEditDate:[Utility getDateFromJSONDate:[loc valueForKey:@"EditDate"]]];
				
		}
	}
	@catch (NSException *exception) 
	{
		location = nil;
		
		//NSLog(@"Error in getLocations.  Error: %@", [exception description]);
	}
	@finally 
	{
		return location;
	}
}


+ (NSString *) getLocationByLocationId:(NSString *)locationId
{
	NSString *Location = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/location?locationId=%@", _rootUrl, locationId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSMutableDictionary *categories = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(categories != nil && [categories count] > 0)
		{
            Location = [categories valueForKey:@"LocationName"];
        }
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getCategoriesByOrganization.  Error: %@", [exception description]);
		
		Location = nil;
	}
	@finally 
	{
		return Location;
	}
}

#pragma mark LocationInfo
+ (NSMutableArray *) getLocationInfoList
{
	NSMutableArray *locationInfoList = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/locationInfo", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id locationInfoEntries = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(locationInfoEntries != nil && [locationInfoEntries count] > 0)
		{
			id currentLocationInfo = nil;
			
			NSEnumerator *enumerator = [locationInfoEntries objectEnumerator];
			
			if(locationInfoList == nil)
			{
				locationInfoList = [[NSMutableArray alloc] init];
			}
			
			while (currentLocationInfo = [enumerator nextObject])
			{
				LocationInfo *locationInfo = [[LocationInfo alloc] init];
				
				[locationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"LocationInfoId"]];
				[locationInfo setAddress1:[currentLocationInfo valueForKey:@"Address1"]];
				[locationInfo setAddress2:[currentLocationInfo valueForKey:@"Address2"]];
				[locationInfo setCity:[currentLocationInfo valueForKey:@"City"]];
				[locationInfo setState:[currentLocationInfo valueForKey:@"State"]];
				[locationInfo setPostalCode:[currentLocationInfo valueForKey:@"PostalCode"]];
				[locationInfo setCountry:[currentLocationInfo valueForKey:@"Country"]];
				[locationInfo setBusinessPhone:[currentLocationInfo valueForKey:@"BusinessPhone"]];
				[locationInfo setFax:[currentLocationInfo valueForKey:@"Fax"]];
				[locationInfo setMobilePhone:[currentLocationInfo valueForKey:@"MobilePhone"]];
				[locationInfo setHomePhone:[currentLocationInfo valueForKey:@"HomePhone"]];
				[locationInfo setEmail1:[currentLocationInfo valueForKey:@"Email1"]];
				[locationInfo setEmail2:[currentLocationInfo valueForKey:@"Email2"]];
				[locationInfo setWebsite:[currentLocationInfo valueForKey:@"Website"]];
				[locationInfo setCreateDate:[Utility getDateFromJSONDate:[currentLocationInfo valueForKey:@"CreateDate"]]];
				[locationInfo setEditDate:[Utility getDateFromJSONDate:[currentLocationInfo valueForKey:@"EditDate"]]];
				
				[locationInfoList addObject:locationInfo];
			}
		}
	}
	@catch (NSException *exception) 
	{
		locationInfoList = nil;
		
		//NSLog(@"Error in getLocationInfoList.  Error: %@", [exception description]);
	}
	@finally 
	{
		return locationInfoList;
	}
}

+ (LocationInfo *) getLocationInfoById:(NSString *)locationInfoId
{
	LocationInfo *locationInfo = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/locationInfo?locationInfoId=%@", _rootUrl, locationInfo];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id locationInfoEntries = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(locationInfoEntries != nil && [locationInfoEntries count] > 0)
		{
			id currentLocationInfo = nil;
			
			NSEnumerator *enumerator = [locationInfoEntries objectEnumerator];
			
			while (currentLocationInfo = [enumerator nextObject])
			{
				locationInfo = [[LocationInfo alloc] init];
				
				[locationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"LocationInfoId"]];
				[locationInfo setAddress1:[currentLocationInfo valueForKey:@"Address1"]];
				[locationInfo setAddress2:[currentLocationInfo valueForKey:@"Address2"]];
				[locationInfo setCity:[currentLocationInfo valueForKey:@"City"]];
				[locationInfo setState:[currentLocationInfo valueForKey:@"State"]];
				[locationInfo setPostalCode:[currentLocationInfo valueForKey:@"PostalCode"]];
				[locationInfo setCountry:[currentLocationInfo valueForKey:@"Country"]];
				[locationInfo setBusinessPhone:[currentLocationInfo valueForKey:@"BusinessPhone"]];
				[locationInfo setFax:[currentLocationInfo valueForKey:@"Fax"]];
				[locationInfo setMobilePhone:[currentLocationInfo valueForKey:@"MobilePhone"]];
				[locationInfo setHomePhone:[currentLocationInfo valueForKey:@"HomePhone"]];
				[locationInfo setEmail1:[currentLocationInfo valueForKey:@"Email1"]];
				[locationInfo setEmail2:[currentLocationInfo valueForKey:@"Email2"]];
				[locationInfo setWebsite:[currentLocationInfo valueForKey:@"Website"]];
				[locationInfo setCreateDate:[Utility getDateFromJSONDate:[currentLocationInfo valueForKey:@"CreateDate"]]];
				[locationInfo setEditDate:[Utility getDateFromJSONDate:[currentLocationInfo valueForKey:@"EditDate"]]];
			}
		}
	}
	@catch (NSException *exception) 
	{
		locationInfo = nil;
		
		//NSLog(@"Error in getLocationInfoById.  Error: %@", [exception description]);
	}
	@finally 
	{
		return locationInfo;
	}
}

+ (BOOL) doesLocationInfoExist:(NSString *)address city:(NSString *)city state:(NSString *)state
{
	BOOL locationInfoExists = NO;
	
	@try 
	{
        
        NSString *trimmedaddress = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        NSString *trimmedcity = [city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        NSString *trimmedstate = [state stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

		NSMutableArray *locationInfoList = [ServiceHelper getLocationInfoList];
		
		NSEnumerator *enumerator = [locationInfoList objectEnumerator];
		
		LocationInfo *locationInfo = nil;
		
		while (locationInfo = [enumerator nextObject]) 
		{
            NSString *trimmedaddress1 = [[locationInfo address1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *trimmedcity1 = [[locationInfo city] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *trimmedstate1 = [[locationInfo state] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

			if ([[trimmedaddress1 lowercaseString] compare:[trimmedaddress lowercaseString]] == 0 &&
				[[trimmedcity1 lowercaseString] compare:[trimmedcity lowercaseString]] == 0 &&
				[[trimmedstate1 lowercaseString] compare:[trimmedstate lowercaseString]] == 0)
			{
				locationInfoExists = YES;
				
				break;
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in doesLocationInfoExist.  Error: %@", [exception description]);
		
		locationInfoExists = NO;
	}
	@finally 
	{
		return locationInfoExists;
	}
}

+ (LocationInfo *) addLocationInfo:(LocationInfo *)locationInfo
{
	LocationInfo *newLocationInfo = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/locationInfo", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [LocationInfo toJsonString:locationInfo indent:NO];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentLocationInfo = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (newLocationInfo == nil) 
		{
			newLocationInfo = [[LocationInfo alloc] init];
		}
		
		[newLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"LocationInfoId"]];
		[newLocationInfo setAddress1:[currentLocationInfo valueForKey:@"Address1"]];
		[newLocationInfo setAddress2:[currentLocationInfo valueForKey:@"Address2"]];
		[newLocationInfo setCity:[currentLocationInfo valueForKey:@"City"]];
		[newLocationInfo setState:[currentLocationInfo valueForKey:@"State"]];
		[newLocationInfo setPostalCode:[currentLocationInfo valueForKey:@"PostalCode"]];
		[newLocationInfo setCountry:[currentLocationInfo valueForKey:@"Country"]];
		[newLocationInfo setBusinessPhone:[currentLocationInfo valueForKey:@"BusinessPhone"]];
		[newLocationInfo setFax:[currentLocationInfo valueForKey:@"Fax"]];
		[newLocationInfo setMobilePhone:[currentLocationInfo valueForKey:@"MobilePhone"]];
		[newLocationInfo setHomePhone:[currentLocationInfo valueForKey:@"HomePhone"]];
		[newLocationInfo setEmail1:[currentLocationInfo valueForKey:@"Email1"]];
		[newLocationInfo setEmail2:[currentLocationInfo valueForKey:@"Email2"]];
		[newLocationInfo setWebsite:[currentLocationInfo valueForKey:@"Website"]];
		[newLocationInfo setCreateDate:[Utility getDateFromJSONDate:[currentLocationInfo valueForKey:@"CreateDate"]]];
		[newLocationInfo setEditDate:[Utility getDateFromJSONDate:[currentLocationInfo valueForKey:@"EditDate"]]];
	}
	@catch (NSException *exception) 
	{
		newLocationInfo = nil;
		
		//NSLog(@"Error in addLocationInfo.  Error: %@", [exception description]);
	}
	@finally 
	{
		return newLocationInfo;
	}
}

+ (LocationInfo *) updateLocationInfo:(LocationInfo *)locationInfo
{
	LocationInfo *updatedLocationInfo = nil;
	
	@try 
	{
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in updateLocationInfo.  Error: %@", [exception description]);
		
		updatedLocationInfo = nil;
	}
	@finally 
	{
		return updatedLocationInfo;
	}
}

+ (NSNumber *) deleteLocationInfo:(NSString *)locationInfoId
{
	NSNumber *deleteWasSuccessful = [NSNumber numberWithBool:NO];
	
	@try 
	{
        
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in deleteLocationInfo.  Error: %@", [exception description]);
		
		deleteWasSuccessful = nil;
	}
	@finally 
	{
		return deleteWasSuccessful;
	}
}

#pragma mark Organization
+ (Organization *) getOrganizationByUserId:(NSString *)userId
{
	Organization *organization = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/userOrganization?userId=%@", _rootUrl, userId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id org = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(org != nil)
		{
			if(organization == nil)
			{
				organization = [[Organization alloc] init];
			}

			[organization setCreateDate:[org valueForKey:@"CreateDate"]];
			[organization setEditDate:[org valueForKey:@"EditDate"]];
			[organization setLocationId:[org valueForKey:@"LocationId"]];
			[organization setOrganizationId:[org valueForKey:@"OrganizationId"]];
			[organization setOrganizationName:[org valueForKey:@"OrganizationName"]];											   
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getOrganizationByUserId.  Error: %@", [exception description]);
		
		organization = nil;
	}
	@finally 
	{
		return organization;
	}
}

#pragma mark User
+ (NSNumber *) validateUser:(NSString *)userName password:(NSString *)password
{
	NSNumber *isUserValid = [NSNumber numberWithBool:NO];
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/validateUser?userId=%@&password=%@", _rootUrl, userName, password];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id wasUserValidated = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(wasUserValidated != nil)
		{
			if ([wasUserValidated compare:[NSNumber numberWithInt:1]] == 0) 
			{
				isUserValid = [NSNumber numberWithBool:YES];
			}
			else if ([wasUserValidated compare:[NSNumber numberWithInt:0]] == 0)
			{
				isUserValid = [NSNumber numberWithBool:NO];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in validateUser.  Error: %@", [exception description]);
		
		isUserValid = [NSNumber numberWithBool:NO];
	}
	@finally 
	{
		return isUserValid;
	}
}

+ (NSMutableArray *)getUsers
{
	NSMutableArray *userList = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/users", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id users = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(users != nil && [users count] > 0)
		{
			id currentUser = nil;
			
			NSEnumerator *enumerator = [users objectEnumerator];
			
			if(userList == nil)
			{
				userList = [[NSMutableArray alloc] init];
			}
			
			while (currentUser = [enumerator nextObject])
			{
				User *user = [[User alloc] init];
				
				[user setUserId:[currentUser valueForKey:@"UserId"]];
				[user setUserName:[currentUser valueForKey:@"UserName"]];
				[user setHashedPassword:[currentUser valueForKey:@"HashedPassword"]];
				[user setFirstName:[currentUser valueForKey:@"FirstName"]];											   
				[user setMiddleName:[currentUser valueForKey:@"MiddleName"]];
				[user setLastName:[currentUser valueForKey:@"LastName"]];
				[user setEmail:[currentUser valueForKey:@"Email"]];
				[user setPhone:[currentUser valueForKey:@"Phone"]];
				[user setLocationId:[currentUser valueForKey:@"LocationId"]];
				[user setCreateDate:[Utility getDateFromJSONDate:[currentUser valueForKey:@"CreateDate"]]];
				[user setEditDate:[Utility getDateFromJSONDate:[currentUser valueForKey:@"EditDate"]]];
				
				[userList addObject:user];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getUsers.  Error: %@", [exception description]);
		
		userList = nil;
	}
	@finally 
	{
		return userList;
	}
}

+ (User *) getUserByUserName:(NSString *)userName
{
	User *user = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/user/%@", _rootUrl, userName];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id usr = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(usr != nil)
		{
			if(user == nil)
			{
				user = [[User alloc] init];
			}
			
			[user setUserId:[usr valueForKey:@"UserId"]];
			[user setUserName:[usr valueForKey:@"UserName"]];
			[user setHashedPassword:[usr valueForKey:@"HashedPassword"]];
			[user setFirstName:[usr valueForKey:@"FirstName"]];											   
			[user setMiddleName:[usr valueForKey:@"MiddleName"]];
			[user setLastName:[usr valueForKey:@"LastName"]];
			[user setEmail:[usr valueForKey:@"Email"]];
			[user setPhone:[usr valueForKey:@"Phone"]];
			[user setLocationId:[usr valueForKey:@"LocationId"]];
			[user setCreateDate:[Utility getDateFromJSONDate:[usr valueForKey:@"CreateDate"]]];
			[user setEditDate:[Utility getDateFromJSONDate:[usr valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getUserByUserName.  Error: %@", [exception description]);
		
		user = nil;
	}
	@finally 
	{
		return user;
	}
}

+ (User *)getUserByUserId:(NSString *)userId
{
	User *foundUser = nil;
	
	@try 
	{
		NSMutableArray *userList = [ServiceHelper getUsers];
		
		NSEnumerator *enumerator = [userList objectEnumerator];
		
		id currentUser = nil;
		
		while (currentUser = [enumerator nextObject])
		{
			if ([[currentUser userId] compare:userId] == 0) 
			{
				foundUser = currentUser;
				
				break;
			}
		}	
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getUserByUserId.  Error: %@", [exception description]);
		
		foundUser = nil;
	}
	@finally 
	{
		return foundUser;
	}
}

+(NSString *)getUserRollid:(NSString *)userId
{
    NSString *responseRollId;
    
    @try 
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/roleByUserId?userId=%@", _rootUrl, userId];
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id curUserId = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        if (curUserId!=nil && [curUserId count]>0) 
        {
            
            responseRollId=[curUserId valueForKey:@"RoleId"];
        }
        
        else 
        {
            responseRollId=nil;
        }
        
    }
    @catch (NSException *exception) 
    {
        //NSLog(@"Error in getContact.  Error: %@", [exception description]);
        
        responseRollId = nil;
    }
    @finally 
    {
        
        return responseRollId;
    }    
}

+ (NSMutableArray *)getRolls
{
    NSMutableArray *rollList = nil;
    
    @try 
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/roles", _rootUrl];
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id rolls = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        if(rolls != nil && [rolls count] > 0)
        {
            id currentUser = nil;
            
            NSEnumerator *enumerator = [rolls objectEnumerator];
            
            if(rollList == nil)
            {
                rollList = [[NSMutableArray alloc] init];
            }
            
            while (currentUser = [enumerator nextObject])
            {
                
                UserRolls *rollsObj = [[UserRolls alloc] init];
                
                [rollsObj setRoleID:[currentUser valueForKey:@"RoleId"]];
                [rollsObj setName:[currentUser valueForKey:@"Name"]];
                
                [rollsObj setCreateDate:[Utility getDateFromJSONDate:[currentUser valueForKey:@"CreateDate"]]];
                [rollsObj setEditDate:[Utility getDateFromJSONDate:[currentUser valueForKey:@"EditDate"]]];
                
                [rollList addObject:rollsObj];
            }
        }
    }
    @catch (NSException *exception) 
    {
        //NSLog(@"Error in getUsers.  Error: %@", [exception description]);
        
        rollList = nil;
    }
    @finally 
    {
        
        return rollList;
    }
}

#pragma mark Ticket

+ (NSMutableArray *) getAllTickets
{
	NSMutableArray *allTicketListing = nil;
    
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/tickets",_rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(tickets != nil && [tickets count] > 0)
		{
			id currentTicket = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(allTicketListing == nil)
			{
				allTicketListing = [[NSMutableArray alloc] init];
			}
			
			while (currentTicket = [enumerator nextObject])
			{
				Ticket *ticket = [[Ticket alloc] init];

				[ticket setTicketId:[currentTicket valueForKey:@"TicketId"]];
				[ticket setTicketNum:[currentTicket valueForKey:@"TicketNum"]];
				[ticket setTicketNumber:[currentTicket valueForKey:@"TicketNumber"]];
                [ticket setTicketName:[currentTicket valueForKey:@"TicketName"]];
				[ticket setCategoryId:[currentTicket valueForKey:@"CategoryId"]];
                [ticket setContactId:[currentTicket valueForKey:@"ContactId"]];
				[ticket setLocationId:[currentTicket valueForKey:@"LocationId"]];
                [ticket setOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
				[ticket setOpenClose:[currentTicket valueForKey:@"OpenClose"]];
                [ticket setUserId:[currentTicket valueForKey:@"UserId"]];
                
				if ([currentTicket valueForKey:@"CreateDate"] != nil) 
				{
					[ticket setCreateDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CreateDate"]]];
				}
                
				if ([currentTicket valueForKey:@"EditDate"] != nil) 
				{
					[ticket setEditDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"EditDate"]]];
				}
                
				if ([currentTicket valueForKey:@"CloseDate"] != nil) 
				{
					[ticket setCloseDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CloseDate"]]];
				}
                [ticket setTicketStatus:[currentTicket valueForKey:@"Status"]];
				[ticket setOpenClose:[currentTicket valueForKey:@"OpenClose"]];
				[ticket setOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
				[ticket setUserId:[currentTicket valueForKey:@"UserId"]];
				
				[allTicketListing addObject:ticket];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allTicketListing = nil;
	}
	@finally 
	{
		return allTicketListing;
	}
}

+ (NSMutableArray *) getTicketsByCategory:(NSString *)categoryId
{
	NSMutableArray *ticketListing = nil;

	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/ticketsByCategory?categoryId=%@", _rootUrl, categoryId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(tickets != nil && [tickets count] > 0)
		{
			id currentTicket = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(ticketListing == nil)
			{
				ticketListing = [[NSMutableArray alloc] init];
			}
			
			while (currentTicket = [enumerator nextObject])
			{
				Ticket *ticket = [[Ticket alloc] init];
				
				[ticket setTicketId:[currentTicket valueForKey:@"TicketId"]];
				[ticket setTicketName:[currentTicket valueForKey:@"TicketName"]];
				[ticket setCategoryId:[currentTicket valueForKey:@"CategoryId"]];

				if ([currentTicket valueForKey:@"CreateDate"] != nil) 
				{
					[ticket setCreateDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CreateDate"]]];
				}

				if ([currentTicket valueForKey:@"EditDate"] != nil) 
				{
					[ticket setEditDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"EditDate"]]];
				}

				if ([currentTicket valueForKey:@"CloseDate"] != nil) 
				{
					[ticket setCloseDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CloseDate"]]];
				}
				
				[ticket setOpenClose:[currentTicket valueForKey:@"OpenClose"]];
                [ticket setTicketStatus:[currentTicket valueForKey:@"Status"]];
				[ticket setOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
				[ticket setUserId:[currentTicket valueForKey:@"UserId"]];
				
				[ticketListing addObject:ticket];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		ticketListing = nil;
	}
	@finally 
	{
		return ticketListing;
	}
}

+ (NSMutableArray *) getTicketsByLocations:(NSString *)locationParams
{
	NSMutableArray *allTicketListing = nil;
    
	@try 
    {

		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/ticketsByLocations", _rootUrl];
		
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        

		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
		
		if(tickets != nil && [tickets count] > 0)
		{
			id currentTicket = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(allTicketListing == nil)
			{
				allTicketListing = [[NSMutableArray alloc] init];
			}
			
			while (currentTicket = [enumerator nextObject])
			{
				Ticket *ticket = [[Ticket alloc] init];
                
				[ticket setTicketId:[currentTicket valueForKey:@"TicketId"]];
				[ticket setTicketNum:[currentTicket valueForKey:@"TicketNum"]];
				[ticket setTicketNumber:[currentTicket valueForKey:@"TicketNumber"]];
                [ticket setTicketName:[currentTicket valueForKey:@"TicketName"]];
				[ticket setCategoryId:[currentTicket valueForKey:@"CategoryId"]];
                [ticket setContactId:[currentTicket valueForKey:@"ContactId"]];
				[ticket setLocationId:[currentTicket valueForKey:@"LocationId"]];
                [ticket setOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
				[ticket setOpenClose:[currentTicket valueForKey:@"OpenClose"]];
                [ticket setTicketStatus:[currentTicket valueForKey:@"Status"]];
                [ticket setUserId:[currentTicket valueForKey:@"UserId"]];
                
				if ([currentTicket valueForKey:@"CreateDate"] != nil) 
				{
					[ticket setCreateDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CreateDate"]]];
				}
                
				if ([currentTicket valueForKey:@"EditDate"] != nil) 
				{
					[ticket setEditDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"EditDate"]]];
				}
                
				if ([currentTicket valueForKey:@"CloseDate"] != nil) 
				{
					[ticket setCloseDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CloseDate"]]];
				}
				
				[ticket setOpenClose:[currentTicket valueForKey:@"OpenClose"]];
				[ticket setOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
				[ticket setUserId:[currentTicket valueForKey:@"UserId"]];
				
				[allTicketListing addObject:ticket];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allTicketListing = nil;
	}
	@finally 
	{
		return allTicketListing;
	}
}

+ (Ticket *) addTicket:(Ticket *)ticket
{
	Ticket *newTicket = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/ticket", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Ticket toJsonString:ticket indent:NO];
		
       NSLog(@"jsonString = %@",jsonString);
        
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentTicket = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (newTicket == nil) 
		{
			newTicket = [[Ticket alloc] init];
		}
		
		[newTicket setTicketId:[currentTicket valueForKey:@"TicketId"]];
		[newTicket setCategoryId:[currentTicket valueForKey:@"CategoryId"]];
		[newTicket setCloseDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CloseDate"]]];
		[newTicket setContactId:[currentTicket valueForKey:@"ContactId"]];
		[newTicket setLocationId:[currentTicket valueForKey:@"LocationId"]];
		[newTicket setOpenClose:[currentTicket valueForKey:@"OpenClose"]];
		[newTicket setOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
		[newTicket setTicketName:[currentTicket valueForKey:@"TicketName"]];
        [newTicket setTicketNumber:[currentTicket valueForKey:@"TicketNumber"]];
        [newTicket setIsHelpDoc:[currentTicket valueForKey:@"IsHelpDoc"]];
		[newTicket setUserId:[currentTicket valueForKey:@"UserId"]];
		[newTicket setCreateDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CreateDate"]]];
		[newTicket setEditDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"EditDate"]]];
	}
	@catch (NSException *exception) 
	{
		newTicket = nil;
		
		//NSLog(@"Error in addTicket.  Error: %@", [exception description]);
	}
	@finally 
	{		
		return newTicket;
	}
}

+ (Ticket *) updateTicket:(Ticket *)ticket
{
	Ticket *updatedTicket = nil;
	
	@try 
	{

       // http://www.ekeservices.net/ServicePleaseWebService/updateTicket?ticketId=50f14218-6aa3-4d53-a593-2072f938f77c
        
        NSMutableString *serviceOperationUrl = [NSMutableString stringWithFormat:@"%@/updateTicket?ticketId=%@", _rootUrl,ticket.ticketId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Ticket toJsonString:ticket indent:NO];
        
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentTicket = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (updatedTicket == nil) 
		{
			updatedTicket = [[Ticket alloc] init];
		}
		
		[updatedTicket setTicketId:[currentTicket valueForKey:@"TicketId"]];
		[updatedTicket setCategoryId:[currentTicket valueForKey:@"CategoryId"]];
		[updatedTicket setCloseDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CloseDate"]]];
		[updatedTicket setContactId:[currentTicket valueForKey:@"ContactId"]];
		[updatedTicket setLocationId:[currentTicket valueForKey:@"LocationId"]];
		[updatedTicket setOpenClose:[currentTicket valueForKey:@"OpenClose"]];
		[updatedTicket setOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
		[updatedTicket setTicketName:[currentTicket valueForKey:@"TicketName"]];
		[updatedTicket setUserId:[currentTicket valueForKey:@"UserId"]];
		[updatedTicket setCreateDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CreateDate"]]];
		[updatedTicket setEditDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"EditDate"]]];
		
	}
	@catch (NSException *exception) 
	{
		updatedTicket = nil;
		
		//NSLog(@"Error in updateTicket.  Error: %@", [exception description]);
	}
	@finally 
	{		
		return updatedTicket;
	}
}

+ (NSString *) deleteTicket:(NSString *)ticketId
{
    NSString *response ;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/deleteTicket?ticketId=%@", _rootUrl,ticketId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
        
	}
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}

#pragma mark Problem

+ (NSMutableArray *) getAllProblems
{
	NSMutableArray *allProblemListing = nil;
    
	@try 
    {
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/problems", _rootUrl];
		
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(tickets != nil && [tickets count] > 0)
		{
			id currentProblem = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(allProblemListing == nil)
			{
				allProblemListing = [[NSMutableArray alloc] init];
			}
			
			while (currentProblem = [enumerator nextObject])
			{
				Problem *problem = [[Problem alloc] init];
                
                [problem setTicketId:[currentProblem objectForKey:@"TicketId"]];		
                [problem setProblemId:[currentProblem objectForKey:@"ProblemId"]];
                [problem setProblemShortDesc:[currentProblem objectForKey:@"ProblemShortDesc"]];
                [problem setProblemText:[currentProblem objectForKey:@"ProblemText"]];
                                
				if ([currentProblem valueForKey:@"CreateDate"] != nil) 
				{
					[problem setCreateDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"CreateDate"]]];
				}
                
				if ([currentProblem valueForKey:@"EditDate"] != nil) 
				{
					[problem setEditDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"EditDate"]]];
				}
                				
				[allProblemListing addObject:problem];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allProblemListing = nil;
	}
	@finally 
	{
		return allProblemListing;
	}
}
+ (Problem *) getProblemByTicket:(NSString *)ticketId
{
	Problem *problem = nil;
	
	@try 
	{
		
	}
	@catch (NSException *exception) 
	{
		problem = nil;
		
		//NSLog(@"Error in getProblemByTicket.  Error: %@", [exception description]);
	}
	@finally 
	{		
		return problem;
	}
}

+ (Problem *) addProblem:(Problem *)problem
{
	Problem *newProblem = nil;
	
	@try 
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/problem", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Problem toJsonString:problem indent:NO];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentSolution = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (newProblem == nil) 
		{
			newProblem = [[Problem alloc] init];
		}
		
		[newProblem setTicketId:[currentSolution valueForKey:@"TicketId"]];
		[newProblem setProblemId:[currentSolution valueForKey:@"problemId"]];
        [newProblem setProblemShortDesc:[currentSolution valueForKey:@"problemShortDesc"]];
        [newProblem setProblemText:[currentSolution valueForKey:@"problemText"]];
		[newProblem setCreateDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"CreateDate"]]];
		[newProblem setEditDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"EditDate"]]];

	}
	@catch (NSException *exception) 
	{
		newProblem = nil;
		
		//NSLog(@"Error in addProblem.  Error: %@", [exception description]);
	}
	@finally 
	{		
		return newProblem;
	}
}

+ (Problem *) updateProblem:(Problem *)problem
{
	Problem *updatedProblem = nil;
	
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/updateProblem?problemId=%@", _rootUrl,problem.problemId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Problem toJsonString:problem indent:NO];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentSolution = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (updatedProblem == nil)
		{
			updatedProblem = [[Problem alloc] init];
		}
		
		[updatedProblem setTicketId:[currentSolution valueForKey:@"TicketId"]];
		[updatedProblem setProblemId:[currentSolution valueForKey:@"problemId"]];
        [updatedProblem setProblemShortDesc:[currentSolution valueForKey:@"problemShortDesc"]];
        [updatedProblem setProblemText:[currentSolution valueForKey:@"problemText"]];
		[updatedProblem setCreateDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"CreateDate"]]];
		[updatedProblem setEditDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"EditDate"]]];
        
	}
	@catch (NSException *exception)
	{
		updatedProblem = nil;
		
		//NSLog(@"Error in addProblem.  Error: %@", [exception description]);
	}
	@finally
	{
		return updatedProblem;
	}
}

+ (NSNumber *) deleteProblem:(NSString *)problemId
{
	NSNumber *wasSuccessful = [NSNumber numberWithBool:NO];
	
	@try 
	{
		
	}
	@catch (NSException *exception) 
	{
		wasSuccessful = [NSNumber numberWithBool:NO];
		
		//NSLog(@"Error in deleteProblem.  Error: %@", [exception description]);
	}
	@finally 
	{		
		return wasSuccessful;
	}
}

+ (NSMutableArray *) searchProblem:(NSString *)problemString
{
    NSMutableArray *allProblemListing = nil;
	
	@try 
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/searchProblems", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [NSString stringWithFormat:@"[\"%@\"]",problemString];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentProblem = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if(currentProblem != nil && [currentProblem count] > 0)
		{
			NSEnumerator *enumerator = [currentProblem objectEnumerator];
			
			if(allProblemListing == nil)
			{
				allProblemListing = [[NSMutableArray alloc] init];
			}
			
			while (currentProblem = [enumerator nextObject])
			{
				Problem *problem = [[Problem alloc] init];
                
                [problem setTicketId:[currentProblem objectForKey:@"TicketId"]];		
                [problem setProblemId:[currentProblem objectForKey:@"ProblemId"]];
                [problem setProblemShortDesc:[currentProblem objectForKey:@"ProblemShortDesc"]];
                [problem setProblemText:[currentProblem objectForKey:@"ProblemText"]];
                
				if ([currentProblem valueForKey:@"CreateDate"] != nil) 
				{
					[problem setCreateDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"CreateDate"]]];
				}
                
				if ([currentProblem valueForKey:@"EditDate"] != nil) 
				{
					[problem setEditDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"EditDate"]]];
				}
                
				[allProblemListing addObject:problem];
			}
		}
        
	}
	@catch (NSException *exception) 
	{		
		//NSLog(@"Error in addProblem.  Error: %@", [exception description]);
	}
	@finally 
	{		
		return allProblemListing;
	}
}


#pragma mark Solution

+ (NSMutableArray *) getAllSolutions
{
	NSMutableArray *allSolutionListing = nil;
    
	@try 
    {
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/solutions", _rootUrl];
		
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(tickets != nil && [tickets count] > 0)
		{
			id currentProblem = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(allSolutionListing == nil)
			{
				allSolutionListing = [[NSMutableArray alloc] init];
			}
			
			while (currentProblem = [enumerator nextObject])
			{
				Solution *solution = [[Solution alloc] init];
                
                [solution setTicketId:[currentProblem objectForKey:@"TicketId"]];		
                [solution setSolutionId:[currentProblem objectForKey:@"SolutionId"]];
                [solution setSolutionShortDesc:[currentProblem objectForKey:@"SolutionShortDesc"]];
                [solution setSolutionText:[currentProblem objectForKey:@"SolutionText"]];
                
				if ([currentProblem valueForKey:@"CreateDate"] != nil) 
				{
					[solution setCreateDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"CreateDate"]]];
				}
                
				if ([currentProblem valueForKey:@"EditDate"] != nil) 
				{
					[solution setEditDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"EditDate"]]];
				}
                
				[allSolutionListing addObject:solution];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allSolutionListing = nil;
	}
	@finally 
	{
		return allSolutionListing;
	}
}

+ (NSMutableArray *) getSolutionByTicket:(NSString *)ticketId
{
    NSMutableArray *solutionListing;
    
	Solution *solution = nil;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/solutions", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id solutions = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(solutions != nil && [solutions count] > 0)
		{
			id currentSolution = nil;
			
			NSEnumerator *enumerator = [solutions objectEnumerator];
			
			if(solutionListing == nil)
			{
				solutionListing = [[NSMutableArray alloc] init];
			}
			
			while (currentSolution = [enumerator nextObject])
			{
				solution = [[Solution alloc] init];
				
				[solution setSolutionId:[currentSolution valueForKey:@"SolutionId"]];
				[solution setSolutionShortDesc:[currentSolution valueForKey:@"SolutionShortDesc"]];
				[solution setSolutionText:[currentSolution valueForKey:@"SolutionText"]];
                
				if ([currentSolution valueForKey:@"createDate"] != nil) 
				{
					[solution setCreateDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"createDate"]]];
				}
                
				if ([currentSolution valueForKey:@"editDate"] != nil) 
				{
					[solution setEditDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"editDate"]]];
				}
				
				[solutionListing addObject:solution];
			}
		}
    }
	@catch (NSException *exception) 
	{
		solutionListing = nil;
		
		//NSLog(@"Error in getSolutionByTicket.  Error: %@", [exception description]);
	}
	@finally 
	{		
		return solutionListing;
	}
}

+ (Solution *) addSolution:(Solution *)solution
{
	Solution *newSolution = nil;

	@try 
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/solution", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Solution toJsonString:solution indent:NO];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentSolution = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (newSolution == nil) 
		{
			newSolution = [[Solution alloc] init];
		}
		
		[newSolution setTicketId:[currentSolution valueForKey:@"TicketId"]];
		[newSolution setSolutionId:[currentSolution valueForKey:@"SolutionId"]];
        [newSolution setSolutionShortDesc:[currentSolution valueForKey:@"SolutionShortDesc"]];
        [newSolution setSolutionText:[currentSolution valueForKey:@"SolutionText"]];
		[newSolution setCreateDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"CreateDate"]]];
		[newSolution setEditDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"EditDate"]]];

	}
	@catch (NSException *exception) 
	{
		newSolution = nil;
		
		//NSLog(@"Error in addSolution.  Error: %@", [exception description]);
	}
	@finally 
	{		
		return newSolution;
	}
}

+ (Solution *) updateSolution:(Solution *)solution
{
	Solution *updatedSolution = nil;
	
	@try 
	{
        // http://www.ekeservices.net/ServicePleaseWebService/updateSolution?solutionId=
        
        NSMutableString *serviceOperationUrl = [NSMutableString stringWithFormat:@"%@/updateSolution?solutionId=", _rootUrl];
        
        [serviceOperationUrl appendString:solution.solutionId];
        		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [Solution toJsonString:solution indent:NO];
        
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentSolution = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (updatedSolution == nil) 
		{
			updatedSolution = [[Solution alloc] init];
		}
		
		[updatedSolution setTicketId:[currentSolution valueForKey:@"TicketId"]];
		[updatedSolution setSolutionId:[currentSolution valueForKey:@"SolutionId"]];
        [updatedSolution setSolutionShortDesc:[currentSolution valueForKey:@"SolutionShortDesc"]];
        [updatedSolution setSolutionText:[currentSolution valueForKey:@"SolutionText"]];
		[updatedSolution setCreateDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"CreateDate"]]];
		[updatedSolution setEditDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"EditDate"]]];		
	}
	@catch (NSException *exception) 
	{
		updatedSolution = nil;
		
		//NSLog(@"Error in updateTicket.  Error: %@", [exception description]);
	}
	@finally 
	{		
		return updatedSolution;
	}
}

+ (NSNumber *) deleteSolution:(NSString *)solutionId
{
	NSNumber *wasSuccessful = [NSNumber numberWithBool:NO];
	
	@try 
	{
		
	}
	@catch (NSException *exception) 
	{
		wasSuccessful = [NSNumber numberWithBool:NO];
		
		//NSLog(@"Error in deleteSolution.  Error: %@", [exception description]);
	}
	@finally 
	{		
		return wasSuccessful;
	}
}

+ (NSMutableArray *) searchSolution:(NSString *)solutionString
{
	NSMutableArray *allSolutionListing = nil;
    
	@try 
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/searchSolutions", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [NSString stringWithFormat:@"[\"%@\"]",solutionString];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id currentSolution = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if(currentSolution != nil && [currentSolution count] > 0)
		{
			id currentProblem = nil;
			
			NSEnumerator *enumerator = [currentSolution objectEnumerator];
			
			if(allSolutionListing == nil)
			{
				allSolutionListing = [[NSMutableArray alloc] init];
			}
			
			while (currentProblem = [enumerator nextObject])
			{
				Solution *solution = [[Solution alloc] init];
                
                [solution setTicketId:[currentProblem objectForKey:@"TicketId"]];		
                [solution setSolutionId:[currentProblem objectForKey:@"SolutionId"]];
                [solution setSolutionShortDesc:[currentProblem objectForKey:@"SolutionShortDesc"]];
                [solution setSolutionText:[currentProblem objectForKey:@"SolutionText"]];
                
				if ([currentProblem valueForKey:@"CreateDate"] != nil) 
				{
					[solution setCreateDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"CreateDate"]]];
				}
                
				if ([currentProblem valueForKey:@"EditDate"] != nil) 
				{
					[solution setEditDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"EditDate"]]];
				}
                
				[allSolutionListing addObject:solution];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allSolutionListing = nil;
	}
	@finally 
	{
		return allSolutionListing;
	}
}




#pragma mark EmailNotification
/// Added by ASHOKK Colan

+ (BOOL ) sendNotificationEmail:(Location *)location emaillocationInfoDetail:(LocationInfo *)locationinfo
{
	BOOL emailServiceSucess = NO;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/sendEmail", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
		NSString *jsonString = [EmailNotification JsonContentofEmailWithIndent:NO withLocation:location withLoacationInfoDetail:locationinfo];
        
//        //NSLog(@"EMAIL BODY DATA:%@",jsonString);
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
        [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
	}
	@catch (NSException *exception) 
	{
		emailServiceSucess = NO;
		
		//NSLog(@"Error in Executing sendEmail Service");
	}
	@finally 
	{   
        emailServiceSucess = YES;
        
		return emailServiceSucess;
	}
}


+ (BOOL ) sendTicketNotificationEmail:(NSString *)jsonString
{
	BOOL emailServiceSucess = NO;
	
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/sendEmail", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
//        //NSLog(@"TICKET EMAIL BODY DATA:%@",jsonString);
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
        [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
	}
	@catch (NSException *exception) 
	{
		emailServiceSucess = NO;
		
		//NSLog(@"Error in Executing sendEmail Service");
	}
	@finally 
	{   
        emailServiceSucess = YES;
        
		return emailServiceSucess;
	}
}

+ (NSString *) sendTextNotificationPhoneDestination:(NSString *)phoneDestination Message:(NSString *)message CustomerNickname:(NSString *) customerNickname Username:(NSString *)username Password:(NSString *)password
{
	NSString *response;
    
    NSData *urlData;
    
	@try
	{
        NSMutableString *serviceOperationUrl=[[NSMutableString alloc] initWithFormat:@"https://www.primemessage.net/TxTNotify/TxTNotify?PhoneDestination=%@&Message=%@&CustomerNickname=%@&Username=%@&Password=%@",phoneDestination,message,customerNickname,username,password];
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];        
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
        
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        
        response = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        
        NSLog(@"response = %@",response);
	}
	@catch (NSException *exception)
	{
	}
	@finally
	{
		return response;
	}
}


#pragma mark TicketMonitor
+ (NSMutableArray *) getTicketMonitorRows
{
    NSMutableArray *allTicketListing = nil;
    
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/ticketMonitorRows",_rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(tickets != nil && [tickets count] > 0)
		{
			id currentTicket = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(allTicketListing == nil)
			{
				allTicketListing = [[NSMutableArray alloc] init];
			}
			
			while (currentTicket = [enumerator nextObject])
			{
				TicketMoniter *ticketMonitor = [[TicketMoniter alloc] init];
                
                NSString *timeElapsed = [(NSNumber*)[currentTicket valueForKey:@"Elapsed"]stringValue];
                
				[ticketMonitor setTicketCategory:[currentTicket valueForKey:@"Category"]];
                [ticketMonitor setTicketCategoryId:[currentTicket valueForKey:@"CategoryId"]];
                
				[ticketMonitor setTicketContact:[currentTicket valueForKey:@"Contact"]];
                [ticketMonitor setTicketContactId:[currentTicket valueForKey:@"ContactId"]];
                
				[ticketMonitor setTicketDescription:[currentTicket valueForKey:@"Description"]];
                [ticketMonitor setTicketElapsed:timeElapsed];
				[ticketMonitor setTicketLocation:[currentTicket valueForKey:@"Location"]];
                [ticketMonitor setTicketLocationId:[currentTicket valueForKey:@"LocationId"]];
                [ticketMonitor setTicketOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
                
                [ticketMonitor setTicketServicePlan:[currentTicket valueForKey:@"ServicePlan"]];
				[ticketMonitor setTicketStatus:[currentTicket valueForKey:@"Status"]];
                [ticketMonitor setTicketTech:[currentTicket valueForKey:@"Tech"]];
                [ticketMonitor setTicketTicketId:[currentTicket valueForKey:@"TicketId"]];
                [ticketMonitor setTicketTicketNumber:[currentTicket valueForKey:@"TicketNumber"]];
                
				if ([currentTicket valueForKey:@"Time"] != nil) 
				{
					[ticketMonitor setTicketTime:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"Time"]]];
				}
                [ticketMonitor setTicketUserId:[currentTicket valueForKey:@"UserId"]];
                
				[allTicketListing addObject:ticketMonitor];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allTicketListing = nil;
	}
	@finally 
	{
		return allTicketListing;
	}
}

+ (NSMutableArray *) getTicketMonitorRowsByLocations:(NSString *)locationIds
{
    NSMutableArray *allTicketListing = nil;
    
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/ticketMonitorRowsByLocations",_rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
		NSData *postData = [locationIds dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if(tickets != nil && [tickets count] > 0)
		{
			id currentTicket = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(allTicketListing == nil)
			{
				allTicketListing = [[NSMutableArray alloc] init];
			}
			
			while (currentTicket = [enumerator nextObject])
			{
				TicketMoniter *ticketMonitor = [[TicketMoniter alloc] init];
                
                NSString *timeElapsed = [(NSNumber*)[currentTicket valueForKey:@"Elapsed"]stringValue];
                
				[ticketMonitor setTicketCategory:[currentTicket valueForKey:@"Category"]];
                [ticketMonitor setTicketCategoryId:[currentTicket valueForKey:@"CategoryId"]];
                
				[ticketMonitor setTicketContact:[currentTicket valueForKey:@"Contact"]];
                [ticketMonitor setTicketContactId:[currentTicket valueForKey:@"ContactId"]];
                
				[ticketMonitor setTicketDescription:[currentTicket valueForKey:@"Description"]];
                [ticketMonitor setTicketElapsed:timeElapsed];
				[ticketMonitor setTicketLocation:[currentTicket valueForKey:@"Location"]];
                [ticketMonitor setTicketLocationId:[currentTicket valueForKey:@"LocationId"]];
                [ticketMonitor setTicketOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
                
                [ticketMonitor setTicketServicePlan:[currentTicket valueForKey:@"ServicePlan"]];
				[ticketMonitor setTicketStatus:[currentTicket valueForKey:@"Status"]];
                [ticketMonitor setTicketTech:[currentTicket valueForKey:@"Tech"]];
                [ticketMonitor setTicketTicketId:[currentTicket valueForKey:@"TicketId"]];
                [ticketMonitor setTicketTicketNumber:[currentTicket valueForKey:@"TicketNumber"]];
                
				if ([currentTicket valueForKey:@"Time"] != nil) 
				{
					[ticketMonitor setTicketTime:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"Time"]]];
				}
                [ticketMonitor setTicketUserId:[currentTicket valueForKey:@"UserId"]];
                
                
				[allTicketListing addObject:ticketMonitor];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allTicketListing = nil;
	}
	@finally 
	{
		return allTicketListing;
	}
}

+ (NSMutableArray *) getTicketMonitorRowsByTE:(NSString *)statusIds
{
    NSMutableArray *allTicketListing = nil;
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/ticketMonitorRowsByElapsedTime?sortOrder=%@", _rootUrl,statusIds];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(tickets != nil && [tickets count] > 0)
		{
			id currentTicket = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(allTicketListing == nil)
			{
				allTicketListing = [[NSMutableArray alloc] init];
			}
			
			while (currentTicket = [enumerator nextObject])
			{
				TicketMoniter *ticketMonitor = [[TicketMoniter alloc] init];
                
                NSString *timeElapsed = [(NSNumber*)[currentTicket valueForKey:@"Elapsed"]stringValue];
                
                [ticketMonitor setTicketCategory:[currentTicket valueForKey:@"Category"]];
                [ticketMonitor setTicketCategoryId:[currentTicket valueForKey:@"CategoryId"]];
                
				[ticketMonitor setTicketContact:[currentTicket valueForKey:@"Contact"]];
                [ticketMonitor setTicketContactId:[currentTicket valueForKey:@"ContactId"]];
                
				[ticketMonitor setTicketDescription:[currentTicket valueForKey:@"Description"]];
                [ticketMonitor setTicketElapsed:timeElapsed];
				[ticketMonitor setTicketLocation:[currentTicket valueForKey:@"Location"]];
                [ticketMonitor setTicketLocationId:[currentTicket valueForKey:@"LocationId"]];
                [ticketMonitor setTicketOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
                
                [ticketMonitor setTicketServicePlan:[currentTicket valueForKey:@"ServicePlan"]];
				[ticketMonitor setTicketStatus:[currentTicket valueForKey:@"Status"]];
                [ticketMonitor setTicketTech:[currentTicket valueForKey:@"Tech"]];
                [ticketMonitor setTicketTicketId:[currentTicket valueForKey:@"TicketId"]];
                [ticketMonitor setTicketTicketNumber:[currentTicket valueForKey:@"TicketNumber"]];
                
				if ([currentTicket valueForKey:@"Time"] != nil) 
				{
					[ticketMonitor setTicketTime:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"Time"]]];
				}
                [ticketMonitor setTicketUserId:[currentTicket valueForKey:@"UserId"]];
                
                
				[allTicketListing addObject:ticketMonitor];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allTicketListing = nil;
	}
	@finally 
	{
		return allTicketListing;
	}
}

+ (NSMutableArray *) getTicketMonitorRowsByStatus:(NSString *)statusIds
{
    NSMutableArray *allTicketListing = nil;
    
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/ticketMonitorRowsByStatus?status=%@", _rootUrl,statusIds];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(tickets != nil && [tickets count] > 0)
		{
			id currentTicket = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(allTicketListing == nil)
			{
				allTicketListing = [[NSMutableArray alloc] init];
			}
			
			while (currentTicket = [enumerator nextObject])
			{
				TicketMoniter *ticketMonitor = [[TicketMoniter alloc] init];
                
                NSString *timeElapsed = [(NSNumber*)[currentTicket valueForKey:@"Elapsed"]stringValue];
                
                [ticketMonitor setTicketCategory:[currentTicket valueForKey:@"Category"]];
                [ticketMonitor setTicketCategoryId:[currentTicket valueForKey:@"CategoryId"]];
                
				[ticketMonitor setTicketContact:[currentTicket valueForKey:@"Contact"]];
                [ticketMonitor setTicketContactId:[currentTicket valueForKey:@"ContactId"]];
                
				[ticketMonitor setTicketDescription:[currentTicket valueForKey:@"Description"]];
                [ticketMonitor setTicketElapsed:timeElapsed];
				[ticketMonitor setTicketLocation:[currentTicket valueForKey:@"Location"]];
                [ticketMonitor setTicketLocationId:[currentTicket valueForKey:@"LocationId"]];
                [ticketMonitor setTicketOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
                
                [ticketMonitor setTicketServicePlan:[currentTicket valueForKey:@"ServicePlan"]];
				[ticketMonitor setTicketStatus:[currentTicket valueForKey:@"Status"]];
                [ticketMonitor setTicketTech:[currentTicket valueForKey:@"Tech"]];
                [ticketMonitor setTicketTicketId:[currentTicket valueForKey:@"TicketId"]];
                [ticketMonitor setTicketTicketNumber:[currentTicket valueForKey:@"TicketNumber"]];
                
				if ([currentTicket valueForKey:@"Time"] != nil) 
				{
					[ticketMonitor setTicketTime:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"Time"]]];
				}
                [ticketMonitor setTicketUserId:[currentTicket valueForKey:@"UserId"]];
                
                
				[allTicketListing addObject:ticketMonitor];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allTicketListing = nil;
	}
	@finally 
	{
		return allTicketListing;
	}
}

+ (NSMutableArray *) getticketMonitorRowsByCategory:(NSString *)categoryIds
{
    NSMutableArray *allTicketListing = nil;
    
	@try 
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/ticketMonitorRowsByCategories", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSData *postData = [categoryIds dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
        
		if(tickets != nil && [tickets count] > 0)
		{
			id currentTicket = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(allTicketListing == nil)
			{
				allTicketListing = [[NSMutableArray alloc] init];
			}
			
			while (currentTicket = [enumerator nextObject])
			{
				TicketMoniter *ticketMonitor = [[TicketMoniter alloc] init];
                
                NSString *timeElapsed = [(NSNumber*)[currentTicket valueForKey:@"Elapsed"]stringValue];
                
                [ticketMonitor setTicketCategory:[currentTicket valueForKey:@"Category"]];
                [ticketMonitor setTicketCategoryId:[currentTicket valueForKey:@"CategoryId"]];
                
				[ticketMonitor setTicketContact:[currentTicket valueForKey:@"Contact"]];
                [ticketMonitor setTicketContactId:[currentTicket valueForKey:@"ContactId"]];
                
				[ticketMonitor setTicketDescription:[currentTicket valueForKey:@"Description"]];
                [ticketMonitor setTicketElapsed:timeElapsed];
				[ticketMonitor setTicketLocation:[currentTicket valueForKey:@"Location"]];
                [ticketMonitor setTicketLocationId:[currentTicket valueForKey:@"LocationId"]];
                [ticketMonitor setTicketOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
                
                [ticketMonitor setTicketServicePlan:[currentTicket valueForKey:@"ServicePlan"]];
				[ticketMonitor setTicketStatus:[currentTicket valueForKey:@"Status"]];
                [ticketMonitor setTicketTech:[currentTicket valueForKey:@"Tech"]];
                [ticketMonitor setTicketTicketId:[currentTicket valueForKey:@"TicketId"]];
                [ticketMonitor setTicketTicketNumber:[currentTicket valueForKey:@"TicketNumber"]];
                
				if ([currentTicket valueForKey:@"Time"] != nil) 
				{
					[ticketMonitor setTicketTime:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"Time"]]];
				}
                [ticketMonitor setTicketUserId:[currentTicket valueForKey:@"UserId"]];
                
                
				[allTicketListing addObject:ticketMonitor];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allTicketListing = nil;
	}
	@finally 
	{
		return allTicketListing;
	}
}

+ (NSMutableArray *) getticketMonitorRowsByContactId:(NSString *)ContactIds
{
    NSMutableArray *allTicketListing = nil;
    
	@try 
	{
        
        
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@//ticketMonitorRowsByContacts", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
        NSData *postData = [ContactIds dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if(tickets != nil && [tickets count] > 0)
		{
			id currentTicket = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(allTicketListing == nil)
			{
				allTicketListing = [[NSMutableArray alloc] init];
			}
			
			while (currentTicket = [enumerator nextObject])
			{
                
                
				TicketMoniter *ticketMonitor = [[TicketMoniter alloc] init];
                
                NSString *timeElapsed = [(NSNumber*)[currentTicket valueForKey:@"Elapsed"]stringValue];
                
                [ticketMonitor setTicketCategory:[currentTicket valueForKey:@"Category"]];
                [ticketMonitor setTicketCategoryId:[currentTicket valueForKey:@"CategoryId"]];
                
				[ticketMonitor setTicketContact:[currentTicket valueForKey:@"Contact"]];
                [ticketMonitor setTicketContactId:[currentTicket valueForKey:@"ContactId"]];
                
				[ticketMonitor setTicketDescription:[currentTicket valueForKey:@"Description"]];
                [ticketMonitor setTicketElapsed:timeElapsed];
				[ticketMonitor setTicketLocation:[currentTicket valueForKey:@"Location"]];
                [ticketMonitor setTicketLocationId:[currentTicket valueForKey:@"LocationId"]];
                [ticketMonitor setTicketOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
                
                [ticketMonitor setTicketServicePlan:[currentTicket valueForKey:@"ServicePlan"]];
				[ticketMonitor setTicketStatus:[currentTicket valueForKey:@"Status"]];
                [ticketMonitor setTicketTech:[currentTicket valueForKey:@"Tech"]];
                [ticketMonitor setTicketTicketId:[currentTicket valueForKey:@"TicketId"]];
                [ticketMonitor setTicketTicketNumber:[currentTicket valueForKey:@"TicketNumber"]];
                
				if ([currentTicket valueForKey:@"Time"] != nil) 
				{
					[ticketMonitor setTicketTime:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"Time"]]];
				}
                [ticketMonitor setTicketUserId:[currentTicket valueForKey:@"UserId"]];
                
                
				[allTicketListing addObject:ticketMonitor];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allTicketListing = nil;
	}
	@finally 
	{
		return allTicketListing;
	}
}

+ (NSMutableArray *) getticketMonitorRowsByUserId:(NSString *)userIds
{
    NSMutableArray *techList = nil;
	
	@try 
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/ticketMonitorRowsByTechs", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSData *postData = [userIds dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id techs = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if(techs != nil && [techs count] > 0)
		{
			id currentTech = nil;
			
			NSEnumerator *enumerator = [techs objectEnumerator];
			
			if(techList == nil)
			{
				techList = [[NSMutableArray alloc] init];
			}
			
			while (currentTech = [enumerator nextObject])
			{
				TicketMoniter *ticketMonitor = [[TicketMoniter alloc] init];
                
                NSString *timeElapsed = [(NSNumber*)[currentTech valueForKey:@"Elapsed"]stringValue];
                
				[ticketMonitor setTicketCategory:[currentTech valueForKey:@"Category"]];
                [ticketMonitor setTicketCategoryId:[currentTech valueForKey:@"CategoryId"]];
                
				[ticketMonitor setTicketContact:[currentTech valueForKey:@"Contact"]];
                [ticketMonitor setTicketContactId:[currentTech valueForKey:@"ContactId"]];
                
				[ticketMonitor setTicketDescription:[currentTech valueForKey:@"Description"]];
                [ticketMonitor setTicketElapsed:timeElapsed];
				[ticketMonitor setTicketLocation:[currentTech valueForKey:@"Location"]];
                [ticketMonitor setTicketLocationId:[currentTech valueForKey:@"LocationId"]];
                [ticketMonitor setTicketOrganizationId:[currentTech valueForKey:@"OrganizationId"]];
                
                [ticketMonitor setTicketServicePlan:[currentTech valueForKey:@"ServicePlan"]];
				[ticketMonitor setTicketStatus:[currentTech valueForKey:@"Status"]];
                [ticketMonitor setTicketTech:[currentTech valueForKey:@"Tech"]];
                [ticketMonitor setTicketTicketId:[currentTech valueForKey:@"TicketId"]];
                [ticketMonitor setTicketTicketNumber:[currentTech valueForKey:@"TicketNumber"]];
                
				if ([currentTech valueForKey:@"Time"] != nil) 
				{
					[ticketMonitor setTicketTime:[Utility getDateFromJSONDate:[currentTech valueForKey:@"Time"]]];
				}
                [ticketMonitor setTicketUserId:[currentTech valueForKey:@"UserId"]];
                
                
				[techList addObject:ticketMonitor];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getContactsByLocation.  Error: %@", [exception description]);
		
		techList = nil;
	}
	@finally 
	{
		return techList;
	}
}

+ (NSMutableArray *) getticketMonitorRowsByServicePlanTypeIds:(NSString *)servicePlanTypeIds
{
    NSMutableArray *sptypesList = nil;
	
	@try 
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/ticketMonitorRowsByServicePlanTypes", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSData *postData = [servicePlanTypeIds dataUsingEncoding:NSStringEncodingConversionAllowLossy]; 
		
		id sptypes = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if(sptypes != nil && [sptypes count] > 0)
		{
			id currentTech = nil;
			
			NSEnumerator *enumerator = [sptypes objectEnumerator];
			
			if(sptypesList == nil)
			{
				sptypesList = [[NSMutableArray alloc] init];
			}
			
			while (currentTech = [enumerator nextObject])
			{
				TicketMoniter *ticketMonitor = [[TicketMoniter alloc] init];
                
                NSString *timeElapsed = [(NSNumber*)[currentTech valueForKey:@"Elapsed"]stringValue];
                
				[ticketMonitor setTicketCategory:[currentTech valueForKey:@"Category"]];
                [ticketMonitor setTicketCategoryId:[currentTech valueForKey:@"CategoryId"]];
                
				[ticketMonitor setTicketContact:[currentTech valueForKey:@"Contact"]];
                [ticketMonitor setTicketContactId:[currentTech valueForKey:@"ContactId"]];
                
				[ticketMonitor setTicketDescription:[currentTech valueForKey:@"Description"]];
                [ticketMonitor setTicketElapsed:timeElapsed];
				[ticketMonitor setTicketLocation:[currentTech valueForKey:@"Location"]];
                [ticketMonitor setTicketLocationId:[currentTech valueForKey:@"LocationId"]];
                [ticketMonitor setTicketOrganizationId:[currentTech valueForKey:@"OrganizationId"]];
                
                [ticketMonitor setTicketServicePlan:[currentTech valueForKey:@"ServicePlan"]];
				[ticketMonitor setTicketStatus:[currentTech valueForKey:@"Status"]];
                [ticketMonitor setTicketTech:[currentTech valueForKey:@"Tech"]];
                [ticketMonitor setTicketTicketId:[currentTech valueForKey:@"TicketId"]];
                [ticketMonitor setTicketTicketNumber:[currentTech valueForKey:@"TicketNumber"]];
                
				if ([currentTech valueForKey:@"Time"] != nil) 
				{
					[ticketMonitor setTicketTime:[Utility getDateFromJSONDate:[currentTech valueForKey:@"Time"]]];
				}
                [ticketMonitor setTicketUserId:[currentTech valueForKey:@"UserId"]];
                
                
				[sptypesList addObject:ticketMonitor];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getContactsByLocation.  Error: %@", [exception description]);
		
		sptypesList = nil;
	}
	@finally 
	{
		return sptypesList;
	}
}

+ (NSMutableArray *) assignTicket:(NSString *)ticketId andTechid:(NSString *)techID
{
    NSMutableArray *allTicketListing = nil;
    
	@try 
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/assignTicket?ticketId=%@&techId=%@", _rootUrl,ticketId,techID];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id tickets = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(tickets != nil && [tickets count] > 0)
		{
			id currentTicket = nil;
			
			NSEnumerator *enumerator = [tickets objectEnumerator];
			
			if(allTicketListing == nil)
			{
				allTicketListing = [[NSMutableArray alloc] init];
			}
			
			while (currentTicket = [enumerator nextObject])
			{
				TicketMoniter *ticketMonitor = [[TicketMoniter alloc] init];
                
                NSString *timeElapsed = [(NSNumber*)[currentTicket valueForKey:@"Elapsed"]stringValue];
                
                [ticketMonitor setTicketCategory:[currentTicket valueForKey:@"Category"]];
                [ticketMonitor setTicketCategoryId:[currentTicket valueForKey:@"CategoryId"]];
                
				[ticketMonitor setTicketContact:[currentTicket valueForKey:@"Contact"]];
                [ticketMonitor setTicketContactId:[currentTicket valueForKey:@"ContactId"]];
                
				[ticketMonitor setTicketDescription:[currentTicket valueForKey:@"Description"]];
                [ticketMonitor setTicketElapsed:timeElapsed];
				[ticketMonitor setTicketLocation:[currentTicket valueForKey:@"Location"]];
                [ticketMonitor setTicketLocationId:[currentTicket valueForKey:@"LocationId"]];
                [ticketMonitor setTicketOrganizationId:[currentTicket valueForKey:@"OrganizationId"]];
                
                [ticketMonitor setTicketServicePlan:[currentTicket valueForKey:@"ServicePlan"]];
				[ticketMonitor setTicketStatus:[currentTicket valueForKey:@"Status"]];
                [ticketMonitor setTicketTech:[currentTicket valueForKey:@"Tech"]];
                [ticketMonitor setTicketTicketId:[currentTicket valueForKey:@"TicketId"]];
                [ticketMonitor setTicketTicketNumber:[currentTicket valueForKey:@"TicketNumber"]];
                
				if ([currentTicket valueForKey:@"Time"] != nil) 
				{
					[ticketMonitor setTicketTime:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"Time"]]];
				}
                [ticketMonitor setTicketUserId:[currentTicket valueForKey:@"UserId"]];
                
                
				[allTicketListing addObject:ticketMonitor];
			}
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getTicketsByCategory.  Error: %@", [exception description]);
		
		allTicketListing = nil;
	}
	@finally 
	{
		return allTicketListing;
	}
}

# pragma mark Blob


+ (void) createSolutionBlob:(NSString *)solutionBlobId blobBytes:(NSData *)blobBytes blobTypeId:(NSString *)blobTypeId
{
	if ((blobBytes != nil) && ([blobBytes length] > 0) )
    {
        BlobEntity *blobRequest = [[BlobEntity alloc] init];
        
        [blobRequest setBlobBytes:[Base64Utils base64EncodedString:blobBytes]];
        
        [blobRequest setBlobTypeId:blobTypeId];
        
        [blobRequest setEntityId:solutionBlobId];
        
        NSString *jsonString = [blobRequest getJSONString];
        
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/solutionBlob", _rootUrl];
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:serviceUrl];
        
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *postData = [NSMutableData data];
        
        [postData appendData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:postData];
        
        [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSError *theError = nil;
        NSURLResponse *theResponse = nil;
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)theResponse;
        
        int code = [httpResponse statusCode];
        
        NSLog(@"createSolutionBlob - HTTP Status = %d", code);
        
        NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        NSLog(@"createSolutionBlob - Response String = %@", responseString);
    }
}

/*
 Retrieving Solution Blob Id's.
 */

+ (NSMutableArray *)getSolutionBlobs:(NSString *)solutionId
{
	NSMutableArray *solutionBlobs = nil;
    
    NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/solutionBlobs?solutionId=%@", _rootUrl,solutionId];
    //NSString *serviceOperationUrl = @"http://www.ekeservices.net/ServicePleaseWebService/solutionBlobs?solutionId=dc78fda5-841e-4524-9873-a995305e2880";
    
   // //NSLog(@"serviceOperationUrl = %@", serviceOperationUrl);

    NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serviceUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy  
                                                       timeoutInterval:20000000000000.0];		
	[request setHTTPMethod:@"GET"];
	
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
	NSError *theError = nil;
	NSURLResponse *theResponse = nil;
	
	NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
	
	//NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)theResponse;
	
	//int code = [httpResponse statusCode];
    
	////NSLog(@"HTTP Status = %d", code);
	
	NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
	solutionBlobs = [SolutionBlobPacket createFromJSONString:responseString];
    
   // //NSLog(@"HTTP solutionBlobs = %@", solutionBlobs);

    return solutionBlobs;
    
    //	return nil;
}

+ (void) createProblemBlob:(NSString *)problemBlobId blobBytes:(NSData *)blobBytes blobTypeId:(NSString *)blobTypeId
{
    
    if ((blobBytes != nil) && ([blobBytes length] > 0) )
        
    {
        BlobEntity *blobRequest = [[BlobEntity alloc] init];
        
        [blobRequest setBlobBytes:[Base64Utils base64EncodedString:blobBytes]];
        
        // [blobRequest setBlobBytes:blobBytes];
        
        // [blobRequest setBlobTypeId:ST_IMAGE_BlobTypeId];
        [blobRequest setBlobTypeId:blobTypeId];
        
        [blobRequest setEntityId:problemBlobId];
        
        NSString *jsonString = [blobRequest getJSONString];
        
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/problemBlob", _rootUrl];
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:serviceUrl];
        
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *postData = [NSMutableData data];
        
        [postData appendData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:postData];
        
        [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSError *theError = nil;
        NSURLResponse *theResponse = nil;
        
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)theResponse;
        
        int code = [httpResponse statusCode];
        
        NSLog(@"createProblemBlob - HTTP Status = %d", code);
        
        NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        NSLog(@"createProblemBlob - Response String = %@", responseString);
    }
}

/*
 Retrieving Solution Blob Id's.
 */

+ (NSMutableArray *)getProblemBlobs:(NSString *)problemId
{
	NSMutableArray *problemBlobs = nil;
    
    NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/problemBlobs?problemId=%@", _rootUrl,problemId];
    
   // //NSLog(@"serviceOperationUrl = %@", serviceOperationUrl);

    NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serviceUrl
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy  
                                                timeoutInterval:20000000000000.0];	
	[request setHTTPMethod:@"GET"];
	
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
	NSError *theError = nil;
	NSURLResponse *theResponse = nil;
	
	NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
	
	//NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)theResponse;
	
	//int code = [httpResponse statusCode];
    
	////NSLog(@"HTTP Status = %d", code);
	
	NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	
	problemBlobs = [ProblemBlobPacket createFromJSONString:responseString];
    
   // //NSLog(@"HTTP problemBlobs = %@", problemBlobs);

	return problemBlobs;
}

#pragma Tech Performance

+ (NSMutableArray *)getTotalticketopen:(NSMutableArray *)receivedTechIdArray startDate:(NSString *)receiveStartDate endDate:(NSString *)receiveendDate
{
    
    NSMutableArray *returnTotalTicketOpen=[[NSMutableArray alloc] init];
	
    @try 
	{
        for (int loop=0;loop<[receivedTechIdArray count]; loop++)
        {
            NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/openTicketCountByTech?techId=%@&startDate=%@&endDate=%@", _rootUrl,[receivedTechIdArray objectAtIndex:loop],receiveStartDate,receiveendDate];
            
            NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
            
            NSString *avgTime= [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
            
            [returnTotalTicketOpen addObject:avgTime];
            
        }
        
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getAvgTime.  Error: %@", [exception description]);
		
		returnTotalTicketOpen = nil;
	}
	@finally 
	{
		return returnTotalTicketOpen;
	}
}

+(NSMutableArray *)getTicketclose:(NSMutableArray *)receivedTechIdArray startDate:(NSString *)receiveStartDate endDate:(NSString *)receiveendDate
{
    NSMutableArray *returnTotalTicketCloseArray=[[NSMutableArray alloc] init];
	@try 
	{
        
        for (int loop=0;loop<[receivedTechIdArray count]; loop++)
        {
            NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/closedTicketCountByTech?techId=%@&startDate=%@&endDate=%@", _rootUrl,[receivedTechIdArray objectAtIndex:loop],receiveStartDate,receiveendDate];
            
            NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
            
            NSString *avgTime= [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
            
            [returnTotalTicketCloseArray addObject:avgTime];
            
        }
        
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getAvgTime.  Error: %@", [exception description]);
		
		returnTotalTicketCloseArray = nil;
	}
	@finally 
	{
		return returnTotalTicketCloseArray;
	}
}



+ (NSMutableArray *)averageTimeToCloseByTech:(NSMutableArray *)receivedTechIdArray startDate:(NSString *)receiveStartDate endDate:(NSString *)receiveendDate
{
    
    NSMutableArray *returnPerformTechIdArray=[[NSMutableArray alloc] init];
	@try 
	{
        //2012-06-01,2012-09-04
        for (int loop=0;loop<[receivedTechIdArray count]; loop++)
        {
            
            NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/averageTimeToCloseByTech?techId=%@&startDate=%@&endDate=%@", _rootUrl,[receivedTechIdArray objectAtIndex:loop],receiveStartDate,receiveendDate];
            
            NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
            
            NSString *avgTime= [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
            
            [returnPerformTechIdArray addObject:avgTime];
            
        }
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in getAvgTime.  Error: %@", [exception description]);
		
		returnPerformTechIdArray = nil;
	}
	@finally 
	{
		return returnPerformTechIdArray;
	}
}

+ (NSMutableArray *)averageResponseTime:(NSMutableArray *)receivedTechIdArray startDate:(NSString *)receiveStartDate endDate:(NSString *)receiveendDate
{
    
    NSMutableArray *returnAvgResponseTime=[[NSMutableArray alloc] init];
    @try 
    {
        int loopCount = [receivedTechIdArray count];
        
        for (int loop=0 ;loop < loopCount; loop++)
        {
            NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/averageResponseTimeByTech?techId=%@&startDate=%@&endDate=%@", _rootUrl,[receivedTechIdArray objectAtIndex:loop],receiveStartDate,receiveendDate];
            
           // //NSLog(@"serviceOperationUrl==>%@",serviceOperationUrl);
            
            NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
            
            id avgRTime = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
            
            NSString *avgResTimeStr = avgRTime; 
            
            [returnAvgResponseTime addObject:avgResTimeStr];
        }
    }
    @catch (NSException *exception) 
    {
        //NSLog(@"Error in getAvgTime.  Error: %@", [exception description]);
        
        returnAvgResponseTime = nil;
    }
    @finally 
    {
        return returnAvgResponseTime;
    }
}


#pragma mark - KD Search


+ (NSMutableArray *) problemKnowledgeSearch:(NSString *)problemString
{
    NSMutableArray *allProblemListing = nil;
	
   // problemString = @"{\"HelpDocOption\": 3,\"CategoryIds\": [\"6a2a4eff-9b01-4148-9122-498d7cf62216\"],\"LocationIds\": [\"29a2b522-e8c7-4406-bf22-5ebde960a17e\",\"5b9d02ba-cb1f-42d9-bd6a-4af0b39f62e1\"],\"SearchTerms\": [\"Text Message\",\"ticket\",\"Test\"]}}";
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/problemKnowledgeSearch", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [[NSString alloc] initWithString:problemString];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentProblem = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if(currentProblem != nil && [currentProblem count] > 0)
		{
			NSEnumerator *enumerator = [currentProblem objectEnumerator];
			
			if(allProblemListing == nil)
			{
				allProblemListing = [[NSMutableArray alloc] init];
			}
			
			while (currentProblem = [enumerator nextObject])
			{
				Problem *problem = [[Problem alloc] init];
                
                [problem setTicketId:[currentProblem objectForKey:@"TicketId"]];
                [problem setProblemId:[currentProblem objectForKey:@"ProblemId"]];
                [problem setProblemShortDesc:[currentProblem objectForKey:@"ProblemShortDesc"]];
                [problem setProblemText:[currentProblem objectForKey:@"ProblemText"]];
                
				if ([currentProblem valueForKey:@"CreateDate"] != nil)
				{
					[problem setCreateDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"CreateDate"]]];
				}
                
				if ([currentProblem valueForKey:@"EditDate"] != nil)
				{
					[problem setEditDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"EditDate"]]];
				}
                
				[allProblemListing addObject:problem];
			}
		}
        
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in addProblem.  Error: %@", [exception description]);
	}
	@finally
	{
		return allProblemListing;
	}
}

- (NSMutableArray *) solutionKnowledgeSearch:(NSString *)solutionString
{
    NSMutableArray *allSolutionListing = nil;

    @try
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/solutionKnowledgeSearch", _rootUrl];
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        NSString *jsonString = [[NSString alloc] initWithString:solutionString];
        
        NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        
        [self stringWithUrl:serviceUrl postData:postData httpMethod:@"POST"];

    }
    @catch (NSException *exception)
    {
        allSolutionListing = nil;
    }
    @finally
    {
        return allSolutionListing;
    }
}


+ (NSMutableArray *) searchProblemsByLocations:(NSString *)problemString
{
    NSMutableArray *allProblemListing = nil;
	
    problemString = @"{\"EntityIds\": [\"29a2b522-e8c7-4406-bf22-5ebde960a17e\",\"5b9d02ba-cb1f-42d9-bd6a-4af0b39f62e1\"],\"SearchTerms\": [\"new\", \"ticket\",\"Test\"]}";
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/searchProblemsByLocations", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [[NSString alloc] initWithString:problemString];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentProblem = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if(currentProblem != nil && [currentProblem count] > 0)
		{
			NSEnumerator *enumerator = [currentProblem objectEnumerator];
			
			if(allProblemListing == nil)
			{
				allProblemListing = [[NSMutableArray alloc] init];
			}
			
			while (currentProblem = [enumerator nextObject])
			{
				Problem *problem = [[Problem alloc] init];
                
                [problem setTicketId:[currentProblem objectForKey:@"TicketId"]];
                [problem setProblemId:[currentProblem objectForKey:@"ProblemId"]];
                [problem setProblemShortDesc:[currentProblem objectForKey:@"ProblemShortDesc"]];
                [problem setProblemText:[currentProblem objectForKey:@"ProblemText"]];
                
				if ([currentProblem valueForKey:@"CreateDate"] != nil)
				{
					[problem setCreateDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"CreateDate"]]];
				}
                
				if ([currentProblem valueForKey:@"EditDate"] != nil)
				{
					[problem setEditDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"EditDate"]]];
				}
                
				[allProblemListing addObject:problem];
			}
		}
        
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in addProblem.  Error: %@", [exception description]);
	}
	@finally
	{
		return allProblemListing;
	}
}

+ (NSMutableArray *) searchProblemsByCategories:(NSString *)problemString
{
    NSMutableArray *allProblemListing = nil;
	
    problemString = @"{\"EntityIds\": [\"6a2a4eff-9b01-4148-9122-498d7cf62216\",\"d8eb7052-de67-4177-aa26-b7e274f2c517\"],\"SearchTerms\": [\"new\", \"ticket\",\"Test\"]}";
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/searchProblemsByCategories", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [[NSString alloc] initWithString:problemString];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentProblem = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if(currentProblem != nil && [currentProblem count] > 0)
		{
			NSEnumerator *enumerator = [currentProblem objectEnumerator];
			
			if(allProblemListing == nil)
			{
				allProblemListing = [[NSMutableArray alloc] init];
			}
			
			while (currentProblem = [enumerator nextObject])
			{
				Problem *problem = [[Problem alloc] init];
                
                [problem setTicketId:[currentProblem objectForKey:@"TicketId"]];
                [problem setProblemId:[currentProblem objectForKey:@"ProblemId"]];
                [problem setProblemShortDesc:[currentProblem objectForKey:@"ProblemShortDesc"]];
                [problem setProblemText:[currentProblem objectForKey:@"ProblemText"]];
                
				if ([currentProblem valueForKey:@"CreateDate"] != nil)
				{
					[problem setCreateDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"CreateDate"]]];
				}
                
				if ([currentProblem valueForKey:@"EditDate"] != nil)
				{
					[problem setEditDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"EditDate"]]];
				}
                
				[allProblemListing addObject:problem];
			}
		}
        
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in addProblem.  Error: %@", [exception description]);
	}
	@finally
	{
		return allProblemListing;
	}
}


+ (NSMutableArray *) searchSolutionsByLocations:(NSString *)solutionString
{
	NSMutableArray *allSolutionListing = nil;
    
    solutionString = @"{\"EntityIds\": [\"29a2b522-e8c7-4406-bf22-5ebde960a17e\",\"5b9d02ba-cb1f-42d9-bd6a-4af0b39f62e1\"],\"SearchTerms\": [\"new\", \"ticket\",\"Test\"]}";
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/searchSolutionsByLocations", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [[NSString alloc] initWithString:solutionString];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentSolution = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if(currentSolution != nil && [currentSolution count] > 0)
		{
			id currentProblem = nil;
			
			NSEnumerator *enumerator = [currentSolution objectEnumerator];
			
			if(allSolutionListing == nil)
			{
				allSolutionListing = [[NSMutableArray alloc] init];
			}
			
			while (currentProblem = [enumerator nextObject])
			{
				Solution *solution = [[Solution alloc] init];
                
                [solution setTicketId:[currentProblem objectForKey:@"TicketId"]];
                [solution setSolutionId:[currentProblem objectForKey:@"SolutionId"]];
                [solution setSolutionShortDesc:[currentProblem objectForKey:@"SolutionShortDesc"]];
                [solution setSolutionText:[currentProblem objectForKey:@"SolutionText"]];
                
				if ([currentProblem valueForKey:@"CreateDate"] != nil)
				{
					[solution setCreateDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"CreateDate"]]];
				}
                
				if ([currentProblem valueForKey:@"EditDate"] != nil)
				{
					[solution setEditDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"EditDate"]]];
				}
                
				[allSolutionListing addObject:solution];
			}
		}
	}
	@catch (NSException *exception)
	{
		allSolutionListing = nil;
	}
	@finally
	{
		return allSolutionListing;
	}
}

+ (NSMutableArray *) searchSolutionsByCategories:(NSString *)solutionString
{
	NSMutableArray *allSolutionListing = nil;
    
    solutionString = @"{\"EntityIds\": [\"29a2b522-e8c7-4406-bf22-5ebde960a17e\",\"5b9d02ba-cb1f-42d9-bd6a-4af0b39f62e1\"],\"SearchTerms\": [\"new\", \"ticket\",\"Test\"]}";
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/searchSolutionsByCategories", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [[NSString alloc] initWithString:solutionString];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentSolution = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if(currentSolution != nil && [currentSolution count] > 0)
		{
			id currentProblem = nil;
			
			NSEnumerator *enumerator = [currentSolution objectEnumerator];
			
			if(allSolutionListing == nil)
			{
				allSolutionListing = [[NSMutableArray alloc] init];
			}
			
			while (currentProblem = [enumerator nextObject])
			{
				Solution *solution = [[Solution alloc] init];
                
                [solution setTicketId:[currentProblem objectForKey:@"TicketId"]];
                [solution setSolutionId:[currentProblem objectForKey:@"SolutionId"]];
                [solution setSolutionShortDesc:[currentProblem objectForKey:@"SolutionShortDesc"]];
                [solution setSolutionText:[currentProblem objectForKey:@"SolutionText"]];
                
				if ([currentProblem valueForKey:@"CreateDate"] != nil)
				{
					[solution setCreateDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"CreateDate"]]];
				}
                
				if ([currentProblem valueForKey:@"EditDate"] != nil)
				{
					[solution setEditDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"EditDate"]]];
				}
                
				[allSolutionListing addObject:solution];
			}
		}
	}
	@catch (NSException *exception)
	{
		allSolutionListing = nil;
	}
	@finally
	{
		return allSolutionListing;
	}
}

#pragma mark - SNOOZE

+ (Snooze *) addSnooze:(Snooze *)snoozeBody
{    
    Snooze *snooze;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/snooze", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
        NSString *jsonString = [Snooze toJsonString:snoozeBody indent:NO];
        
        NSLog(@"jsonString = %@",jsonString);
        
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentSnooze = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
        if(snooze == nil)
        {
            snooze = [[Snooze alloc] init];
        }
        
        [snooze setSnoozeId:[currentSnooze objectForKey:@"SnoozeId"]];
        [snooze setTicketId:[currentSnooze objectForKey:@"TicketId"]];
        [snooze setReasonId:[currentSnooze objectForKey:@"ReasonId"]];
        [snooze setIsCompleted:[currentSnooze objectForKey:@"IsCompleted"]];
        if ([currentSnooze valueForKey:@"CompletedDate"] != nil)
        {
            [snooze setCompletedDate:[currentSnooze valueForKey:@"CompletedDate"]];
        }
        [snooze setIsDateInterval:[currentSnooze objectForKey:@"IsDateInterval"]];
        [snooze setIsQuickShare:[currentSnooze objectForKey:@"IsQuickShare"]];
        if ([currentSnooze valueForKey:@"StartDate"] != nil)
        {
            [snooze setStartDate:[currentSnooze valueForKey:@"StartDate"]];
        }
        if ([currentSnooze valueForKey:@"EndDate"] != nil)
        {
            [snooze setEndDate:[currentSnooze valueForKey:@"EndDate"]];
        }
        [snooze setSnoozeInterval:[[currentSnooze objectForKey:@"SnoozeInterval"] intValue]];
        [snooze setIntervalTypeId:[currentSnooze objectForKey:@"IntervalTypeId"]];
        if ([currentSnooze valueForKey:@"CreateDate"] != nil)
        {
            [snooze setCreateDate:[currentSnooze valueForKey:@"CreateDate"]];
        }
        if ([currentSnooze valueForKey:@"EditDate"] != nil)
        {
            [snooze setEditDate:[currentSnooze valueForKey:@"EditDate"]];
        }
	}
	@catch (NSException *exception)
	{
		snooze = nil;
	}
	@finally
	{
		return snooze;
	}
}

+ (NSString *) deleteSnooze:(NSString *)snoozeId
{
    NSString *response ;    
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/deleteSnooze?snoozeId=%@", _rootUrl,snoozeId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
        
	}
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}


+ (Snooze *) updateSnooze:(Snooze *)updatesnooze
{
    Snooze *snooze;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/updateSnooze?snoozeId=%@", _rootUrl,updatesnooze.snoozeId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
        NSString *jsonString = [Snooze toJsonString:updatesnooze indent:NO];
        
        NSLog(@"jsonString = %@",jsonString);
        
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        
		id currentSnooze = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
        if(snooze == nil)
        {
            snooze = [[Snooze alloc] init];
        }
        
        [snooze setSnoozeId:[currentSnooze objectForKey:@"SnoozeId"]];
        [snooze setTicketId:[currentSnooze objectForKey:@"TicketId"]];
        [snooze setReasonId:[currentSnooze objectForKey:@"ReasonId"]];
        [snooze setIsCompleted:[currentSnooze objectForKey:@"IsCompleted"]];
        if ([currentSnooze valueForKey:@"CompletedDate"] != nil)
        {
            [snooze setCompletedDate:[currentSnooze valueForKey:@"CompletedDate"]];
        }
        [snooze setIsDateInterval:[currentSnooze objectForKey:@"IsDateInterval"]];
        [snooze setIsQuickShare:[currentSnooze objectForKey:@"IsQuickShare"]];
        if ([currentSnooze valueForKey:@"StartDate"] != nil)
        {
            [snooze setStartDate:[currentSnooze valueForKey:@"StartDate"]];
        }
        if ([currentSnooze valueForKey:@"EndDate"] != nil)
        {
            [snooze setEndDate:[currentSnooze valueForKey:@"EndDate"]];
        }
        [snooze setSnoozeInterval:[[currentSnooze objectForKey:@"SnoozeInterval"] intValue]];
        [snooze setIntervalTypeId:[currentSnooze objectForKey:@"IntervalTypeId"]];
        if ([currentSnooze valueForKey:@"CreateDate"] != nil)
        {
            [snooze setCreateDate:[currentSnooze valueForKey:@"CreateDate"]];
        }
        if ([currentSnooze valueForKey:@"EditDate"] != nil)
        {
            [snooze setEditDate:[currentSnooze valueForKey:@"EditDate"]];
        }
	}
	@catch (NSException *exception)
	{
		snooze = nil;
	}
	@finally
	{
		return snooze;
	}
}

+ (Snooze *) getSnoozeBySnoozeId:(NSString *)snoozeId
{
    Snooze *snooze;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/snooze?snoozeId=%@", _rootUrl,snoozeId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id currentSnooze = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
        if(snooze == nil)
        {
            snooze = [[Snooze alloc] init];
        }
        
        [snooze setSnoozeId:[currentSnooze objectForKey:@"SnoozeId"]];
        [snooze setTicketId:[currentSnooze objectForKey:@"TicketId"]];
        [snooze setReasonId:[currentSnooze objectForKey:@"ReasonId"]];
        [snooze setIsCompleted:[currentSnooze objectForKey:@"IsCompleted"]];
        if ([currentSnooze valueForKey:@"CompletedDate"] != nil)
        {
            [snooze setCompletedDate:[currentSnooze valueForKey:@"CompletedDate"]];
        }
        [snooze setIsDateInterval:[currentSnooze objectForKey:@"IsDateInterval"]];
        [snooze setIsQuickShare:[currentSnooze objectForKey:@"IsQuickShare"]];
        if ([currentSnooze valueForKey:@"StartDate"] != nil)
        {
            [snooze setStartDate:[currentSnooze valueForKey:@"StartDate"]];
        }
        if ([currentSnooze valueForKey:@"EndDate"] != nil)
        {
            [snooze setEndDate:[currentSnooze valueForKey:@"EndDate"]];
        }
        [snooze setSnoozeInterval:[[currentSnooze objectForKey:@"SnoozeInterval"] intValue]];
        [snooze setIntervalTypeId:[currentSnooze objectForKey:@"IntervalTypeId"]];
        if ([currentSnooze valueForKey:@"CreateDate"] != nil)
        {
            [snooze setCreateDate:[currentSnooze valueForKey:@"CreateDate"]];
        }
        if ([currentSnooze valueForKey:@"EditDate"] != nil)
        {
            [snooze setEditDate:[currentSnooze valueForKey:@"EditDate"]];
        }
	}
	@catch (NSException *exception)
	{
		snooze = nil;
	}
	@finally
	{
		return snooze;
	}
}


+ (NSMutableArray *) getAllSnooze
{
	NSMutableArray *allSnoozeListing = nil;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/snoozes", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id currentSnooze = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(currentSnooze != nil && [currentSnooze count] > 0)
		{	
            id currentSnoozeValue = nil;
            
			NSEnumerator *enumerator = [currentSnooze objectEnumerator];
			
			if(allSnoozeListing == nil)
			{
				allSnoozeListing = [[NSMutableArray alloc] init];
			}
			
			while (currentSnoozeValue = [enumerator nextObject])
			{
				Snooze *snooze = [[Snooze alloc] init];
                
                [snooze setSnoozeId:[currentSnoozeValue objectForKey:@"SnoozeId"]];
                [snooze setTicketId:[currentSnoozeValue objectForKey:@"TicketId"]];
                [snooze setReasonId:[currentSnoozeValue objectForKey:@"ReasonId"]];
                [snooze setIsCompleted:[currentSnoozeValue objectForKey:@"IsCompleted"]];
                if ([currentSnoozeValue valueForKey:@"CompletedDate"] != nil)
                {
                    [snooze setCompletedDate:[currentSnoozeValue valueForKey:@"CompletedDate"]];
                }
                [snooze setIsDateInterval:[currentSnoozeValue objectForKey:@"IsDateInterval"]];
                [snooze setIsQuickShare:[currentSnoozeValue objectForKey:@"IsQuickShare"]];
                if ([currentSnoozeValue valueForKey:@"StartDate"] != nil)
                {
                    [snooze setStartDate:[currentSnoozeValue valueForKey:@"StartDate"]];
                }
                if ([currentSnoozeValue valueForKey:@"EndDate"] != nil)
                {
                    [snooze setEndDate:[currentSnoozeValue valueForKey:@"EndDate"]];
                }
                [snooze setSnoozeInterval:[[currentSnoozeValue objectForKey:@"SnoozeInterval"] intValue]];
                [snooze setIntervalTypeId:[currentSnoozeValue objectForKey:@"IntervalTypeId"]];
                if ([currentSnoozeValue valueForKey:@"CreateDate"] != nil)
                {
                    [snooze setCreateDate:[currentSnoozeValue valueForKey:@"CreateDate"]];
                }
                if ([currentSnoozeValue valueForKey:@"EditDate"] != nil)
                {
                    [snooze setEditDate:[currentSnoozeValue valueForKey:@"EditDate"]];
                }
				[allSnoozeListing addObject:snooze];
			}
		}
	}
	@catch (NSException *exception)
	{
		allSnoozeListing = nil;
	}
	@finally
	{
		return allSnoozeListing;
	}
}


#pragma mark - LikeUnlike

+ (LikeUnlike *) addLikeUnlike:(LikeUnlike *)likeUnlikeBody
{
    LikeUnlike *likeUnlike;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/likeUnlike", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
        NSString *jsonString = [LikeUnlike toJsonString:likeUnlikeBody indent:NO];
        
        NSLog(@"jsonString = %@",jsonString);
        
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentLikeUnlike = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
        if(likeUnlike == nil)
        {
            likeUnlike = [[LikeUnlike alloc] init];
        }
        
        [likeUnlike setLikeUnlikeId:[currentLikeUnlike objectForKey:@"LikeUnlikeId"]];
        [likeUnlike setSolutionId:[currentLikeUnlike objectForKey:@"SolutionId"]];
        [likeUnlike setLike:[[currentLikeUnlike objectForKey:@"Like"] intValue]];
        [likeUnlike setUnlike:[currentLikeUnlike objectForKey:@"Unlike"]];
        [likeUnlike setUserId:[currentLikeUnlike objectForKey:@"UserId"]];
        if ([currentLikeUnlike valueForKey:@"CreateDate"] != nil)
        {
            [likeUnlike setCreateDate:[currentLikeUnlike valueForKey:@"CreateDate"]];
        }
        if ([currentLikeUnlike valueForKey:@"EditDate"] != nil)
        {
            [likeUnlike setEditDate:[currentLikeUnlike valueForKey:@"EditDate"]];
        }
	}
	@catch (NSException *exception)
	{
		likeUnlike = nil;
	}
	@finally
	{
		return likeUnlike;
	}
}


+ (NSMutableArray *) getAllLikeUnlikeByTechId:(NSString *)techId
{
	NSMutableArray *allLikeUnlikeListing = nil;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/likeUnlikesForTech?techId=%@&startDate=2010-10-22&endDate=2012-11-02", _rootUrl,techId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id currentLikeUnlike = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(currentLikeUnlike != nil && [currentLikeUnlike count] > 0)
		{
			NSEnumerator *enumerator = [currentLikeUnlike objectEnumerator];
			
			if(allLikeUnlikeListing == nil)
			{
				allLikeUnlikeListing = [[NSMutableArray alloc] init];
			}
			
			while (currentLikeUnlike = [enumerator nextObject])
			{
                LikeUnlike *likeUnlike = [[LikeUnlike alloc] init];
                
                [likeUnlike setLikeUnlikeId:[currentLikeUnlike objectForKey:@"LikeUnlikeId"]];
                [likeUnlike setSolutionId:[currentLikeUnlike objectForKey:@"SolutionId"]];
                [likeUnlike setLike:[[currentLikeUnlike objectForKey:@"Like"] intValue]];
                [likeUnlike setUnlike:[currentLikeUnlike objectForKey:@"Unlike"]];
                [likeUnlike setUserId:[currentLikeUnlike objectForKey:@"UserId"]];
                if ([currentLikeUnlike valueForKey:@"CreateDate"] != nil)
                {
                    [likeUnlike setCreateDate:[currentLikeUnlike valueForKey:@"CreateDate"]];
                }
                if ([currentLikeUnlike valueForKey:@"EditDate"] != nil)
                {
                    [likeUnlike setEditDate:[currentLikeUnlike valueForKey:@"EditDate"]];
                }
                [allLikeUnlikeListing addObject:likeUnlike];
            }
		}
	}
	@catch (NSException *exception)
	{
		allLikeUnlikeListing = nil;
	}
	@finally
	{
		return allLikeUnlikeListing;
	}
}

#pragma mark - IntervalTypes

+ (NSMutableArray *) getAllIntervalTypes
{
	NSMutableArray *allIntervalTypesListing = nil;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/intervalTypes", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id currentIntervalTypes = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(currentIntervalTypes != nil && [currentIntervalTypes count] > 0)
		{
            id currentIntervalTypeValue = nil;
            
			NSEnumerator *enumerator = [currentIntervalTypes objectEnumerator];
			
			if(allIntervalTypesListing == nil)
			{
				allIntervalTypesListing = [[NSMutableArray alloc] init];
			}
			
			while (currentIntervalTypeValue = [enumerator nextObject])
			{
				IntervalType *intervalType = [[IntervalType alloc] init];
                
                [intervalType setIntervalTypeId:[currentIntervalTypeValue objectForKey:@"IntervalTypeId"]];
                [intervalType setName:[currentIntervalTypeValue objectForKey:@"Name"]];
                if ([currentIntervalTypeValue valueForKey:@"CreateDate"] != nil)
                {
                    [intervalType setCreateDate:[currentIntervalTypeValue valueForKey:@"CreateDate"]];
                }
                if ([currentIntervalTypeValue valueForKey:@"EditDate"] != nil)
                {
                    [intervalType setEditDate:[currentIntervalTypeValue valueForKey:@"EditDate"]];
                }
				[allIntervalTypesListing addObject:intervalType];
			}
		}
	}
	@catch (NSException *exception)
	{
		allIntervalTypesListing = nil;
	}
	@finally
	{
		return allIntervalTypesListing;
	}
}




+ (BOOL) doesIntervalTypeExist:(NSString *)intervalTypeName
{
	BOOL intervalTypeExists = NO;
	
	@try
	{
        NSString *trimmedintervalTypeName = [intervalTypeName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

		NSMutableArray *categorieList = [ServiceHelper getAllIntervalTypes];
		
		NSEnumerator *enumerator = [categorieList objectEnumerator];
		
		IntervalType *intervalType = nil;
		
		while (intervalType = [enumerator nextObject])
		{
            NSString *trimmedintervalsName = [[intervalType name] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			if ([[trimmedintervalsName lowercaseString] compare:[trimmedintervalTypeName lowercaseString]] == 0)
			{
				intervalTypeExists = YES;
				
				break;
			}
		}
	}
	@catch (NSException *exception)
	{
		intervalTypeExists = NO;
	}
	@finally
	{
		return intervalTypeExists;
	}
}

+ (IntervalType *) addIntervalType:(IntervalType *)intervalTypeBody
{
    IntervalType *intervalType;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/intervalType", _rootUrl];
        
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
        NSString *jsonString = [IntervalType toJsonString:intervalTypeBody indent:NO];
        
        NSLog(@"jsonString = %@",jsonString);
        
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentIntervalTypeValue = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
        if(intervalType == nil)
        {
            intervalType = [[IntervalType alloc] init];
        }
        
        [intervalType setIntervalTypeId:[currentIntervalTypeValue objectForKey:@"IntervalTypeId"]];
        [intervalType setName:[currentIntervalTypeValue objectForKey:@"Name"]];
        if ([currentIntervalTypeValue valueForKey:@"CreateDate"] != nil)
        {
            [intervalType setCreateDate:[currentIntervalTypeValue valueForKey:@"CreateDate"]];
        }
        if ([currentIntervalTypeValue valueForKey:@"EditDate"] != nil)
        {
            [intervalType setEditDate:[currentIntervalTypeValue valueForKey:@"EditDate"]];
        }
	}
	@catch (NSException *exception)
	{
		intervalType = nil;
	}
	@finally
	{
		return intervalType;
	}
}


+ (IntervalType *) updateIntervalType:(IntervalType *)intervalTypeBody
{
    IntervalType *intervalType;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/updateIntervalType?intervalTypeId=\%@", _rootUrl,intervalTypeBody.intervalTypeId];
        
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
        NSString *jsonString = [IntervalType toJsonString:intervalTypeBody indent:NO];
        
        NSLog(@"jsonString = %@",jsonString);
        
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentIntervalTypeValue = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
        if(intervalType == nil)
        {
            intervalType = [[IntervalType alloc] init];
        }
        
        [intervalType setIntervalTypeId:[currentIntervalTypeValue objectForKey:@"IntervalTypeId"]];
        [intervalType setName:[currentIntervalTypeValue objectForKey:@"Name"]];
        if ([currentIntervalTypeValue valueForKey:@"CreateDate"] != nil)
        {
            [intervalType setCreateDate:[currentIntervalTypeValue valueForKey:@"CreateDate"]];
        }
        if ([currentIntervalTypeValue valueForKey:@"EditDate"] != nil)
        {
            [intervalType setEditDate:[currentIntervalTypeValue valueForKey:@"EditDate"]];
        }
	}
	@catch (NSException *exception)
	{
		intervalType = nil;
	}
	@finally
	{
		return intervalType;
	}
}

+ (NSString *) deleteIntervalType:(NSString *)intervalTypeId
{        
    NSString *response ;
    
    @try
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/deleteIntervalType?intervalTypeId=%@", _rootUrl,intervalTypeId];
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
        
    }
    @catch (NSException *exception)
    {
        response = nil;
    }
    @finally
    {
        return response;
    }
}


#pragma mark - SnoozeReasons

+ (NSMutableArray *) getAllSnoozeReasons
{
	NSMutableArray *allSnoozeReasonsListing = nil;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/snoozeReasons", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id currentSnoozeReasons = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
		if(currentSnoozeReasons != nil && [currentSnoozeReasons count] > 0)
		{
            id currentSnoozeReasonValue = nil;
            
			NSEnumerator *enumerator = [currentSnoozeReasons objectEnumerator];
			
			if(allSnoozeReasonsListing == nil)
			{
				allSnoozeReasonsListing = [[NSMutableArray alloc] init];
			}
			
			while (currentSnoozeReasonValue = [enumerator nextObject])
			{
				SnoozeReason *snoozeReason = [[SnoozeReason alloc] init];
                
                [snoozeReason setReasonId:[currentSnoozeReasonValue objectForKey:@"ReasonId"]];
                [snoozeReason setName:[currentSnoozeReasonValue objectForKey:@"Name"]];
                if ([currentSnoozeReasonValue valueForKey:@"CreateDate"] != nil)
                {
                    [snoozeReason setCreateDate:[currentSnoozeReasonValue valueForKey:@"CreateDate"]];
                }
                if ([currentSnoozeReasonValue valueForKey:@"EditDate"] != nil)
                {
                    [snoozeReason setEditDate:[currentSnoozeReasonValue valueForKey:@"EditDate"]];
                }
				[allSnoozeReasonsListing addObject:snoozeReason];
			}
		}
	}
	@catch (NSException *exception)
	{
		allSnoozeReasonsListing = nil;
	}
	@finally
	{
		return allSnoozeReasonsListing;
	}
}


+ (BOOL) doesSnoozeReasonExist:(NSString *)snoozeReasonName
{
	BOOL snoozeReasonExists = NO;
	
	@try
	{
        NSString *trimmedsnoozeReasonName = [snoozeReasonName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
		NSMutableArray *categorieList = [ServiceHelper getAllSnoozeReasons];
		
		NSEnumerator *enumerator = [categorieList objectEnumerator];
		
		SnoozeReason *snoozeReason = nil;
		
		while (snoozeReason = [enumerator nextObject])
		{
            NSString *trimmedReasonname = [[snoozeReason name] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

			if ([[trimmedReasonname lowercaseString] compare:[trimmedsnoozeReasonName lowercaseString]] == 0)
			{
				snoozeReasonExists = YES;
				
				break;
			}
		}
	}
	@catch (NSException *exception)
	{
		snoozeReasonExists = NO;
	}
	@finally
	{
		return snoozeReasonExists;
	}
}

+ (SnoozeReason *) addSnoozeReason:(SnoozeReason *)snoozeReasonBody
{
    SnoozeReason *snoozeReason;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/snoozeReason", _rootUrl];
        		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
        NSString *jsonString = [SnoozeReason toJsonString:snoozeReasonBody indent:NO];
        
        NSLog(@"jsonString = %@",jsonString);
        
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentSnoozeReasonValue = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
        if(snoozeReason == nil)
        {
            snoozeReason = [[SnoozeReason alloc] init];
        }
        
        [snoozeReason setReasonId:[currentSnoozeReasonValue objectForKey:@"ReasonId"]];
        [snoozeReason setName:[currentSnoozeReasonValue objectForKey:@"Name"]];
        if ([currentSnoozeReasonValue valueForKey:@"CreateDate"] != nil)
        {
            [snoozeReason setCreateDate:[currentSnoozeReasonValue valueForKey:@"CreateDate"]];
        }
        if ([currentSnoozeReasonValue valueForKey:@"EditDate"] != nil)
        {
            [snoozeReason setEditDate:[currentSnoozeReasonValue valueForKey:@"EditDate"]];
        }
	}
	@catch (NSException *exception)
	{
		snoozeReason = nil;
	}
	@finally
	{
		return snoozeReason;
	}
}

+ (SnoozeReason *) updateSnoozeReason:(SnoozeReason *)snoozeReasonBody
{
    SnoozeReason *snoozeReason;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/updateSnoozeReason?snoozeReasonId=%@", _rootUrl,snoozeReasonBody.reasonId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
        NSString *jsonString = [SnoozeReason toJsonString:snoozeReasonBody indent:NO];
        
        NSLog(@"jsonString = %@",jsonString);
        
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentSnoozeReasonValue = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
        if(snoozeReason == nil)
        {
            snoozeReason = [[SnoozeReason alloc] init];
        }
        
        [snoozeReason setReasonId:[currentSnoozeReasonValue objectForKey:@"ReasonId"]];
        [snoozeReason setName:[currentSnoozeReasonValue objectForKey:@"Name"]];
        if ([currentSnoozeReasonValue valueForKey:@"CreateDate"] != nil)
        {
            [snoozeReason setCreateDate:[currentSnoozeReasonValue valueForKey:@"CreateDate"]];
        }
        if ([currentSnoozeReasonValue valueForKey:@"EditDate"] != nil)
        {
            [snoozeReason setEditDate:[currentSnoozeReasonValue valueForKey:@"EditDate"]];
        }
	}
	@catch (NSException *exception)
	{
		snoozeReason = nil;
	}
	@finally
	{
		return snoozeReason;
	}
}

+ (NSString *) deleteSnoozeReason:(NSString *)snoozeReasonId
{
    NSString *response ;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/deleteSnoozeReason?snoozeReasonId=%@", _rootUrl,snoozeReasonId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
        
	}
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}

#pragma mark ApplicationType

+ (BOOL) doesApplicationTypeExist:(NSString *)applicationName {
  	
    BOOL applicationTypeExists = NO;
	
	@try
	{
        NSString *trimmedapplicationName = [applicationName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

		NSMutableArray *applicationTypes = [ServiceHelper getAllApplicationTypes];
		
		NSEnumerator *enumerator = [applicationTypes objectEnumerator];
		
		ApplicationType *applicationType = nil;
		
		while (applicationType = [enumerator nextObject])
		{
            NSString *trimmedapplicationsName = [[applicationType applicationName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

			if ([[trimmedapplicationsName lowercaseString] compare:[trimmedapplicationName lowercaseString]] == 0)
			{
				applicationTypeExists = YES;
				
				break;
			}
		}
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in doesLocationExist.  Error: %@", [exception description]);
		
		applicationTypeExists = NO;
	}
	@finally
	{
		return applicationTypeExists;
	}
}

+ (NSMutableArray *) getAllApplicationTypes {
    
    NSMutableArray *ApplicationTypeListing = nil;
    
    @try
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/applicationTypes", _rootUrl];
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        id applicationTypes = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        
        if(applicationTypes != nil && [applicationTypes count] > 0)
        {
            id currentApplicationType = nil;
            
            NSEnumerator *enumerator = [applicationTypes objectEnumerator];
            
            if(ApplicationTypeListing == nil)
            {
                ApplicationTypeListing = [[NSMutableArray alloc] init];
            }
            
            while (currentApplicationType = [enumerator nextObject])
            {
                ApplicationType *applicationType = [[ApplicationType alloc] init];
                
                [applicationType setApplicationTypeId:[currentApplicationType valueForKey:@"ApplicationTypeId"]];
                [applicationType setApplicationName:[currentApplicationType valueForKey:@"Name"]];
                [applicationType setCreateDate:[Utility getDateFromJSONDate:[currentApplicationType valueForKey:@"CreateDate"]]];
                [applicationType setEditDate:[Utility getDateFromJSONDate:[currentApplicationType valueForKey:@"EditDate"]]];
                
                [ApplicationTypeListing addObject:applicationType];
            }
        }
    }
    @catch (NSException *exception)
    {
        //NSLog(@"Error in getCategoriesByOrganization.  Error: %@", [exception description]);
        
        ApplicationTypeListing = nil;
    }
    @finally
    {
        return ApplicationTypeListing;
    }
}

+ (ApplicationType *) getApplicationType:(NSString *)applicationTypeId
{
    
    ApplicationType *applicationType = nil;
	
	@try
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/applicationType/%@", _rootUrl, applicationTypeId];
		
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		id currentApplicationType = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
		
        applicationType = [[ApplicationType alloc]init];
        
        [applicationType setApplicationTypeId:[currentApplicationType valueForKey:@"ApplicationTypeId"]];
        [applicationType setApplicationName:[currentApplicationType valueForKey:@"Name"]];
        [applicationType setCreateDate:[Utility getDateFromJSONDate:[currentApplicationType valueForKey:@"CreateDate"]]];
        [applicationType setEditDate:[Utility getDateFromJSONDate:[currentApplicationType valueForKey:@"EditDate"]]];
        
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in getCategory.  Error: %@", [exception description]);
		
		applicationType = nil;
	}
	@finally
	{
        return applicationType;
	}
}

+ (ApplicationType *) addApplicationType:(ApplicationType *)applicationType {
    
    ApplicationType *newApplicationType = nil;
	
	@try
	{
		NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/applicationType", _rootUrl];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [ApplicationType toJsonString:applicationType indent:NO];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentApplicationType = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (newApplicationType == nil)
		{
			newApplicationType = [[ApplicationType alloc] init];
		}
		[newApplicationType setApplicationTypeId:[currentApplicationType valueForKey:@"ApplicationTypeId"]];
        [newApplicationType setApplicationName:[currentApplicationType valueForKey:@"Name"]];
		[newApplicationType setCreateDate:[Utility getDateFromJSONDate:[currentApplicationType valueForKey:@"CreateDate"]]];
		[newApplicationType setEditDate:[Utility getDateFromJSONDate:[currentApplicationType valueForKey:@"EditDate"]]];
	}
	@catch (NSException *exception)
	{
		newApplicationType = nil;
	}
	@finally
	{
		return newApplicationType;
	}
}

+ (ApplicationType *) updateApplicationType:(ApplicationType *)applicationType applicationTypeId:(NSString *)applicationTypeId
{
    ApplicationType *updatedApplicationType = nil;
	
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/updateApplicationType?applicationTypeId=%@", _rootUrl,applicationTypeId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		NSString *jsonString = [ApplicationType toJsonString:applicationType indent:NO];
		
		NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
		
		id currentApplicationType = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
		
		if (updatedApplicationType == nil)
		{
			updatedApplicationType = [[ApplicationType alloc] init];
		}
        
		[updatedApplicationType setApplicationTypeId:[currentApplicationType valueForKey:@"ApplicationTypeId"]];
        [updatedApplicationType setApplicationName:[currentApplicationType valueForKey:@"Name"]];
		[updatedApplicationType setCreateDate:[Utility getDateFromJSONDate:[currentApplicationType valueForKey:@"CreateDate"]]];
		[updatedApplicationType setEditDate:[Utility getDateFromJSONDate:[currentApplicationType valueForKey:@"EditDate"]]];
	}
	@catch (NSException *exception)
	{
		updatedApplicationType = nil;
	}
	@finally
	{
		return updatedApplicationType;
	}
}

+ (NSString *) deleteApplicationType:(NSString *)ApplicationTypeId
{
    NSString *response ;
    
	@try
	{
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"%@/deleteApplicationType?applicationTypeId=%@", _rootUrl,ApplicationTypeId];
		
		NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
		
		response = [ServiceHelper objectWithUrl:serviceUrl postData:nil httpMethod:@"POST"];
        
	}
	@catch (NSException *exception)
	{
		response = nil;
	}
	@finally
	{
		return response;
	}
}

#pragma mark - ASYNCConnectionDelegate Methods

- (void)stringWithUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method
{
   	
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:1200];
    
    [urlRequest setHTTPMethod:method];
    
    if(postData != nil)
    {
        [urlRequest setHTTPBody:postData];
    }
    
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [connection start];
}

-(void)connection:(NSConnection*)conn didReceiveResponse:
(NSURLResponse *)response
{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:
(NSData *)data
{
    if (receivedData==nil)
    {
        receivedData =[[NSMutableData alloc]init];
    }
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:
(NSError *)error
{
   
    [asynchUrlDelegate ASYNCConnectionDidFailedWithError:[error localizedDescription]];
   
    NSLog(@"Connection failed! Error - %@ %@",[error localizedDescription],[[error userInfo] objectForKey:
   
                                                                            NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  id  theobject = nil;
    
    NSString *jsonString = nil;
    
    jsonString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSData *theJSONData = [NSData dataWithBytes:[jsonString UTF8String]
                                         length:[jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSError *theError = nil;

    theobject = [[CJSONDeserializer deserializer] deserialize:theJSONData error:&theError];
        
    [asynchUrlDelegate ASYNCConnectionDidFinished:theobject];

    receivedData = nil;
}

-(void)cancelRequest
{
    
}

#pragma mark - DailyRecap

+ (NSString *)addDailyRecaplist:(NSString *)jsonString
{
    NSString *response ;
    
    @try
    {
        
        NSData *postData = [jsonString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        
        NSString *serviceOperationUrl = @"http://servicetech.colandevelopmentteam.com/dailyRecap";
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        response = [ServiceHelper objectWithUrl:serviceUrl postData:postData httpMethod:@"POST"];
        
    }
    
    @catch (NSException *exception)
    {
        response = nil;
    }
    @finally
    {
        return response;
    }
}

+ (DailyRecap *) getDailyRecap:(NSString *)dailyRecapSettingsId{
   
    return nil;
}
+ (DailyRecap *) addDailyRecap:(DailyRecap *)dailyRecap{

    return nil;
}
+ (DailyRecap *) updateDailyRecap:(DailyRecap *)dailyRecap dailyRecapId:(NSString *)dailyRecapId{
 
    return nil;
}
+ (NSString *) deleteDailyRecap:(NSString *)dailyRecapSettingsId{
   
    return nil;
}

@end
