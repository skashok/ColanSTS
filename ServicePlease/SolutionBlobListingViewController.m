//
//  FlipsideViewController.m
//  TestServiceTech
//
//  Created by Ed Elliott on 8/3/12.
//  Copyright (c) 2012 Ed Elliott. All rights reserved.
//

#import "SolutionBlobListingViewController.h"

#include <stdlib.h>

@interface SolutionBlobListingViewController ()

@end

@implementation SolutionBlobListingViewController

@synthesize appDelegate = _appDelegate;

@synthesize solutionBlobs = _solutionBlobs;

- (void)awakeFromNib
{
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
	
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	if (_appDelegate == nil)
	{
		_appDelegate = [[UIApplication sharedApplication] delegate];
	}
	
	NSString *solutionBlobId = [[[self appDelegate ] solutionBlobIds] objectAtIndex:randIndex];
	
	[self setSolutionBlobs:[svcUtility getSolutionBlobs:solutionBlobId]];
	
	[[self tableView] reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

#pragma mark Table View Controller delegate stuff
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self solutionBlobs] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"CustomCell";
	
	CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil)
	{
		cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	[[cell label] setText:@"Challenger"];
	
	UIImage *image = [UIImage imageWithData:[[[self solutionBlobs] objectAtIndex:[indexPath row]] valueForKey:@"blobData"]];
	
	[[cell imgView] setImage:image];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
