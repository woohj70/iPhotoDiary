//
//  MCLunarDate.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 4. 30..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCLunarDate : NSObject {
	NSInteger yearLunar;         // 음력변환후년도(양력과다를수있음)
	NSInteger yearDangi;             // 당해년도단기
	NSInteger lunarMonth;              // 음력변환후달
	NSInteger lunarDay;                // 음력변환후일
	NSInteger lunarDayOfWeek;          // 주중요일을숫자로( 0:일, 1:월... 6:토)
	BOOL      yoondal;          // 윤달여부0:평달/1:윤달
	NSString  *currentYearGapja;//[5];          // 당해년도갑자표기(한글)
	NSString  *dayOfWeek;//[3];          // 요일(한글)
	NSString  *dayOfWeekGapja;//[5];          // 당일갑자표기(한글)
	NSString	*monthOfYearGapja;
	NSString  *currentYearDdi;//[7];           // 당해년도띠표기(한글)
	NSString  *currentYearGapjaChinese;//[5];          // 당해년도갑자표기(한자)
	NSString  *dayOfWeekChinese;//[3];          // 요일(한자)
	NSString  *dayOfWeekGapjaChinese;//[5];          // 당일갑자표기(한자)
	NSString	*monthOfYearGapjaChinese;
}

@property (nonatomic, readwrite) NSInteger yearLunar;
@property (nonatomic, readwrite) NSInteger yearDangi;
@property (nonatomic, readwrite) NSInteger lunarMonth;
@property (nonatomic, readwrite) NSInteger lunarDay;
@property (nonatomic, readwrite) NSInteger lunarDayOfWeek;
@property (nonatomic, getter=isYoondal) BOOL      yoondal;
@property (nonatomic, retain) NSString  *currentYearGapja;
@property (nonatomic, retain) NSString  *dayOfWeek;
@property (nonatomic, retain) NSString  *monthOfYearGapja;
@property (nonatomic, retain) NSString  *dayOfWeekGapja;
@property (nonatomic, retain) NSString  *currentYearDdi;
@property (nonatomic, retain) NSString  *currentYearGapjaChinese;
@property (nonatomic, retain) NSString  *dayOfWeekChinese;
@property (nonatomic, retain) NSString  *dayOfWeekGapjaChinese;
@property (nonatomic, retain) NSString  *monthOfYearGapjaChinese;

@end
