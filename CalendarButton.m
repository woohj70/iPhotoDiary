//
//  CalendarButton.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 5. 11..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "CalendarButton.h"


@implementation CalendarButton

@synthesize klDate;
@synthesize lunarDate;
@synthesize eventArray;
@synthesize anniversaryDic;
@synthesize diaryArray;

- (id)init {
	if (self = [super init]) {

	}
	
	return self;
}
 
- (void) dealloc {
	[super dealloc];
	[klDate release];
	[lunarDate release];
	[eventArray release];
	[anniversaryDic release];
	[diaryArray release];
}
@end
