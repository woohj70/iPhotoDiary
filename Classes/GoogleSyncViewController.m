//
//  GoogleSyncViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 7. 8..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "GoogleSyncViewController.h"

@interface GoogleSyncViewController (PrivateMethods)
- (void)updateUI;

- (void)fetchAllCalendars;
- (void)fetchSelectedCalendar;

- (void)addACalendar;
- (void)renameSelectedCalendar;
- (void)deleteSelectedCalendar;

- (void)fetchSelectedCalendarEvents;
- (void)addAnEvent;
- (void)editSelectedEvent;
- (void)deleteSelectedEvents;
- (void)batchDeleteSelectedEvents;
- (void)queryTodaysEvents;

- (void)fetchSelectedCalendarACLEntries;
- (void)addAnACLEntry;
- (void)editSelectedACLEntry;
- (void)deleteSelectedACLEntry;

- (void)fetchSelectedCalendarSettingsEntries;

- (GDataServiceGoogleCalendar *)calendarService;
- (GDataEntryCalendar *)selectedCalendar;
- (GDataEntryCalendarEvent *)singleSelectedEvent;
- (NSArray *)selectedEvents;
- (GDataEntryACL *)selectedACLEntry;
- (GDataEntryCalendarSettings *)selectedSettingsEntry;

- (BOOL)isACLSegmentSelected;
- (BOOL)isEventsSegmentSelected;
- (BOOL)isSettingsSegmentSelected;
- (GDataFeedBase *)feedForSelectedSegment;

- (GDataFeedCalendar *)calendarFeed;
- (void)setCalendarFeed:(GDataFeedCalendar *)feed;
- (NSError *)calendarFetchError;
- (void)setCalendarFetchError:(NSError *)error;
- (GDataServiceTicket *)calendarFetchTicket;
- (void)setCalendarFetchTicket:(GDataServiceTicket *)ticket;

- (GDataFeedCalendarEvent *)eventFeed;
- (void)setEventFeed:(GDataFeedCalendarEvent *)feed;
- (NSError *)eventFetchError;
- (void)setEventFetchError:(NSError *)error;
- (GDataServiceTicket *)eventFetchTicket;
- (void)setEventFetchTicket:(GDataServiceTicket *)ticket;

- (GDataFeedACL *)ACLFeed;
- (void)setACLFeed:(GDataFeedACL *)feed;
- (NSError *)ACLFetchError;
- (void)setACLFetchError:(NSError *)error;
- (GDataServiceTicket *)ACLFetchTicket;
- (void)setACLFetchTicket:(GDataServiceTicket *)ticket;

- (GDataFeedCalendarSettings *)settingsFeed;
- (void)setSettingsFeed:(GDataFeedCalendarSettings *)feed;
- (NSError *)settingsFetchError;
- (void)setSettingsFetchError:(NSError *)error;
- (GDataServiceTicket *)settingsFetchTicket;
- (void)setSettingsFetchTicket:(GDataServiceTicket *)ticket;

@end

enum {
	// calendar segmented control segment index values
	kAllCalendarsSegment = 0,
	kOwnedCalendarsSegment = 1
};

enum {
	// event/ACL/settings segmented control segment index values
	kEventsSegment = 0,
	kACLSegment = 1,
	kSettingsSegment = 2
};

@implementation GoogleSyncViewController

@synthesize account;
@synthesize passwordField;

@synthesize calendarList;
@synthesize syncButton;
@synthesize loginButton;
@synthesize saveAccount;
@synthesize mCalendarProgressIndicator;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark IBAction

- (IBAction)loginButtonClicked {
	NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
	NSString *username = account.text;
	username = [username stringByTrimmingCharactersInSet:whitespace];
	
	if ([username rangeOfString:@"@"].location == NSNotFound) {
		// if no domain was supplied, add @gmail.com
		username = [username stringByAppendingString:@"@gmail.com"];
	}

	account.text = username;
	
	[self fetchAllCalendars];
}

- (IBAction)syncButtonClicke {
}

- (IBAction)saveAccountOn {
}

#pragma mark Fetch all calendars

- (GDataServiceGoogleCalendar *)calendarService {
	
	static GDataServiceGoogleCalendar* service = nil;
	
	if (!service) {
		service = [[GDataServiceGoogleCalendar alloc] init];
		
		[service setShouldCacheDatedData:YES];
		[service setServiceShouldFollowNextLinks:YES];
	}
	
	// update the username/password each time the service is requested
	NSString *username = account.text;
	NSString *password = passwordField.text;
	
	[service setUserCredentialsWithUsername:username
								   password:password];
	
	return service;
}

// begin retrieving the list of the user's calendars
- (void)fetchAllCalendars {
	
	[self setCalendarFeed:nil];
	[self setCalendarFetchError:nil];
	[self setCalendarFetchTicket:nil];
	
	[self setEventFeed:nil];
	[self setEventFetchError:nil];
	[self setEventFetchTicket:nil];
	
	[self setACLFeed:nil];
	[self setACLFetchError:nil];
	[self setACLFetchTicket:nil];
	
	[self setSettingsFeed:nil];
	[self setSettingsFetchError:nil];
	[self setSettingsFetchTicket:nil];
	
	GDataServiceGoogleCalendar *service = [self calendarService];
	GDataServiceTicket *ticket;
	
	int segment = kAllCalendarsSegment;
	NSString *feedURLString;
	
	// The sample app shows the default, non-editable feed of calendars,
	// and the "OwnCalendars" feed, which allows calendars to be inserted
	// and deleted.  We're not demonstrating the "AllCalendars" feed, which
	// allows subscriptions to non-owned calendars to be inserted and deleted,
	// just because it's a bit too complex to easily keep distinct from add/
	// delete in the user interface.
	
	if (segment == kAllCalendarsSegment) {
		feedURLString = kGDataGoogleCalendarDefaultFeed;
	} else {
		feedURLString = kGDataGoogleCalendarDefaultOwnCalendarsFeed;
	}
	
	ticket = [service fetchFeedWithURL:[NSURL URLWithString:feedURLString]
							  delegate:self
					 didFinishSelector:@selector(calendarListTicket:finishedWithFeed:error:)];
	
	[self setCalendarFetchTicket:ticket];
	
	[self updateUI];
}

- (void)calendarListTicket:(GDataServiceTicket *)ticket
          finishedWithFeed:(GDataFeedCalendar *)feed
                     error:(NSError *)error {
	[self setCalendarFeed:feed];
	[self setCalendarFetchError:error];
	[self setCalendarFetchTicket:nil];
	
	[self updateUI];
}

- (void)setCalendarFeed:(GDataFeedCalendar *)feed {
	[mCalendarFeed autorelease];
	mCalendarFeed = [feed retain];
}

- (void)setCalendarFetchError:(NSError *)error {
	[mCalendarFetchError release];
	mCalendarFetchError = [error retain];
}

- (void)setCalendarFetchTicket:(GDataServiceTicket *)ticket {
	[mCalendarFetchTicket release];
	mCalendarFetchTicket = [ticket retain];
}

- (void)setEventFeed:(GDataFeedCalendarEvent *)feed {
	[mEventFeed autorelease];
	mEventFeed = [feed retain];
}

- (void)setEventFetchError:(NSError *)error {
	[mEventFetchError release];
	mEventFetchError = [error retain];
}

- (void)setEventFetchTicket:(GDataServiceTicket *)ticket {
	[mEventFetchTicket release];
	mEventFetchTicket = [ticket retain];
}

- (void)setACLFeed:(GDataFeedACL *)feed {
	[mACLFeed autorelease];
	mACLFeed = [feed retain];
}

- (void)setACLFetchError:(NSError *)error {
	[mACLFetchError release];
	mACLFetchError = [error retain];
}

- (void)setACLFetchTicket:(GDataServiceTicket *)ticket {
	[mACLFetchTicket release];
	mACLFetchTicket = [ticket retain];
}

- (void)setSettingsFeed:(GDataFeedCalendarSettings *)feed {
	[mSettingsFeed autorelease];
	mSettingsFeed = [feed retain];
}

- (void)setSettingsFetchError:(NSError *)error {
	[mSettingsFetchError release];
	mSettingsFetchError = [error retain];
}

- (void)setSettingsFetchTicket:(GDataServiceTicket *)ticket {
	[mACLFetchTicket release];
	mACLFetchTicket = [ticket retain];
}

- (void)updateUI {
	
	// calendar list display
	
	if (mCalendarFetchTicket != nil) {
		mCalendarProgressIndicator.hidden = NO;
		[mCalendarProgressIndicator startAnimating];
	} else {
		[mCalendarProgressIndicator stopAnimating];
		mCalendarProgressIndicator.hidden = YES;
	}
	
	// calendar fetch result or selected item
	NSString *calendarResultStr = @"";
	if (mCalendarFetchError) {
		calendarResultStr = [mCalendarFetchError description];
	} else {
		GDataEntryCalendar *calendar = [self selectedCalendar];
		if (calendar) {
			calendarResultStr = [calendar description];
		}
	}
	calendarList.text = calendarResultStr;
	
	// the bottom table displays event, ACL, or settings entries
	
/*
	BOOL isEventDisplay = [self isEventsSegmentSelected];
	BOOL isACLDisplay = [self isACLSegmentSelected];
	
	GDataServiceTicket *entryTicket;
	NSError *error;
	
	if (isEventDisplay) {
		entryTicket = mEventFetchTicket;
		error = mEventFetchError;
	} else if (isACLDisplay) {
		entryTicket = mACLFetchTicket;
		error = mACLFetchError;
	} else {
		entryTicket = mSettingsFetchTicket;
		error = mSettingsFetchError;
	}
	
	if (entryTicket != nil) {
		[mEventProgressIndicator startAnimation:self];
	} else {
		[mEventProgressIndicator stopAnimation:self];
	}
	
	// display event, ACL, or settings fetch result or selected item
	NSString *eventResultStr = @"";
	if (error) {
		eventResultStr = [error description];
	} else {
		GDataEntryBase *entry = nil;
		if (isEventDisplay) {
			entry = [self singleSelectedEvent];
		} else if (isACLDisplay) {
			entry = [self selectedACLEntry];
		} else {
			entry = [self selectedSettingsEntry];
		}
		
		if (entry != nil) {
			eventResultStr = [entry description];
		}
	}
	[mEventResultTextField setString:eventResultStr];
	
	// enable/disable cancel buttons
	[mCalendarCancelButton setEnabled:(mCalendarFetchTicket != nil)];
	[mEventCancelButton setEnabled:(entryTicket != nil)];
	
	// enable/disable other buttons
	BOOL isCalendarSelected = ([self selectedCalendar] != nil);
	
	BOOL doesSelectedCalendarHaveACLFeed =
    ([[self selectedCalendar] ACLLink] != nil);
	
	[mMapEventButton setEnabled:NO];
	
	if (isEventDisplay) {
		
		[mAddEventButton setEnabled:isCalendarSelected];
		[mQueryTodayEventButton setEnabled:isCalendarSelected];
		
		// Events segment is selected
		NSArray *selectedEvents = [self selectedEvents];
		unsigned int numberOfSelectedEvents = [selectedEvents count];
		
		NSString *deleteTitle = (numberOfSelectedEvents <= 1) ?
		@"Delete Entry" : @"Delete Entries";
		[mDeleteEventButton setTitle:deleteTitle];
		
		if (numberOfSelectedEvents == 1) {
			
			// 1 selected event
			GDataEntryCalendarEvent *event = [selectedEvents objectAtIndex:0];
			BOOL isSelectedEntryEditable = ([event editLink] != nil);
			
			[mDeleteEventButton setEnabled:isSelectedEntryEditable];
			[mEditEventButton setEnabled:isSelectedEntryEditable];
			
			BOOL hasEventLocation = ([event geoLocation] != nil);
			[mMapEventButton setEnabled:hasEventLocation];
			
		} else {
			// zero or many selected events
			BOOL canBatchEdit = ([mEventFeed batchLink] != nil);
			BOOL canDeleteAll = (canBatchEdit && numberOfSelectedEvents > 1);
			
			[mDeleteEventButton setEnabled:canDeleteAll];
			[mEditEventButton setEnabled:NO];
		}
	} else if (isACLDisplay) {
		// ACL segment is selected
		BOOL isEditableACLEntrySelected =
		([[self selectedACLEntry] editLink] != nil);
		
		[mDeleteEventButton setEnabled:isEditableACLEntrySelected];
		[mEditEventButton setEnabled:isEditableACLEntrySelected];
		
		[mAddEventButton setEnabled:doesSelectedCalendarHaveACLFeed];
		[mQueryTodayEventButton setEnabled:NO];
	} else {
		// settings segment is selected
		[mDeleteEventButton setEnabled:NO];
		[mEditEventButton setEnabled:NO];
		[mAddEventButton setEnabled:NO];
		[mQueryTodayEventButton setEnabled:NO];
	}
	
	// enable or disable the Events/ACL segment buttons
	[mEntrySegmentedControl setEnabled:isCalendarSelected
							forSegment:kEventsSegment];
	[mEntrySegmentedControl setEnabled:isCalendarSelected
							forSegment:kSettingsSegment];
	[mEntrySegmentedControl setEnabled:doesSelectedCalendarHaveACLFeed
							forSegment:kACLSegment];
*/
}

- (GDataEntryCalendar *)selectedCalendar {
	
	NSArray *calendars = [mCalendarFeed entries];
	int rowIndex = 0;//[mCalendarTable selectedRow];
	if ([calendars count] > 0 && rowIndex > -1) {
		
		GDataEntryCalendar *calendar = [calendars objectAtIndex:rowIndex];
		return calendar;
	}
	return nil;
}

#pragma mark -
#pragma mark TextField & Keyboard Handling

- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[account release];
	[passwordField release];
	
	[calendarList release];
	[syncButton release];
	[loginButton release];
	[saveAccount release];
	 
	 [mCalendarFeed release];
	 [mCalendarFetchTicket release];
	 [mCalendarFetchError release];
	 
	 [mEventFeed release];
	 [mEventFetchTicket release];
	 [mEventFetchError release];
	 
	 [mACLFeed release];
	 [mACLFetchTicket release];
	 [mACLFetchError release];
	 
	 [mSettingsFeed release];
	 [mSettingsFetchTicket release];
	 [mSettingsFetchError release];
	 [mCalendarProgressIndicator release];
    [super dealloc];
}


@end
