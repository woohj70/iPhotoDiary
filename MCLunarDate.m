//
//  MCLunarDate.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 4. 30..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "MCLunarDate.h"


@implementation MCLunarDate

@synthesize yearLunar;
@synthesize yearDangi;
@synthesize lunarMonth;
@synthesize lunarDay;
@synthesize lunarDayOfWeek;
@synthesize yoondal;
@synthesize currentYearGapja;
@synthesize dayOfWeek;
@synthesize dayOfWeekGapja;
@synthesize monthOfYearGapja;
@synthesize currentYearDdi;
@synthesize currentYearGapjaChinese;
@synthesize dayOfWeekChinese;
@synthesize dayOfWeekGapjaChinese;
@synthesize monthOfYearGapjaChinese;

- (id) init {
	if (![super init])
        return nil;
	
	return self;
}

- (void)dealloc {
	[currentYearGapja release];
	[dayOfWeek release];
	[dayOfWeekGapja release];
	[monthOfYearGapja release];
	[currentYearDdi release];
	[currentYearGapjaChinese release];
	[dayOfWeekChinese release];
	[dayOfWeekGapjaChinese release];
	[monthOfYearGapjaChinese release];
	
	[super dealloc];
}

@end
