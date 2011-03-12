//
//  GoogleSyncViewController.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 7. 8..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GData.h"

@interface GoogleSyncViewController : UIViewController {


	UITextField *account;
	UITextField *passwordField;
	
	UITextView *calendarList;
	UIButton *syncButton;
	UIButton *loginButton;
	
	UISwitch *saveAccount;
	
	GDataFeedCalendar *mCalendarFeed;
	GDataServiceTicket *mCalendarFetchTicket;
	NSError *mCalendarFetchError;
    
	GDataFeedCalendarEvent *mEventFeed;
	GDataServiceTicket *mEventFetchTicket;
	NSError *mEventFetchError;
	
	GDataFeedACL *mACLFeed;
	GDataServiceTicket *mACLFetchTicket;
	NSError *mACLFetchError;
	
	GDataFeedCalendarSettings *mSettingsFeed;
	GDataServiceTicket *mSettingsFetchTicket;
	NSError *mSettingsFetchError;
	
	UIActivityIndicatorView *mCalendarProgressIndicator;
}

@property(nonatomic, retain) IBOutlet UITextField *account;
@property(nonatomic, retain) IBOutlet UITextField *passwordField;
@property(nonatomic, retain) IBOutlet UITextView *calendarList;
@property(nonatomic, retain) IBOutlet UIButton *syncButton;
@property(nonatomic, retain) IBOutlet UIButton *loginButton;
@property(nonatomic, retain) IBOutlet UISwitch *saveAccount;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *mCalendarProgressIndicator;

- (IBAction)loginButtonClicked;
- (IBAction)syncButtonClicke;
- (IBAction)saveAccountOn;
- (IBAction)textFieldDoneEditing:(id)sender;

@end
