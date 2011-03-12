/*
 * Copyright (c) 2008, Keith Lazuka, dba The Polypeptides
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *	- Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *	- Neither the name of the The Polypeptides nor the
 *	  names of its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY Keith Lazuka ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL Keith Lazuka BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "KLDate.h"

static KLDate *Today;

static BOOL IsLeapYear(NSInteger year)
{
    return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
}

@implementation KLDate

+ (id)today
{
    if (!Today) {
        NSInteger year, month, day;
        CFAbsoluteTime absoluteTime = CFDateGetAbsoluteTime((CFDateRef)[NSDate date]);
        CFCalendarRef calendar = CFCalendarCopyCurrent();
        CFCalendarDecomposeAbsoluteTime(calendar, absoluteTime, "yMd", &year, &month, &day);
        CFRelease(calendar);
        Today = [[KLDate alloc] initWithYear:year month:month day:day];
    }

    return Today;
}

// Designated initializer
- (id)initWithYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    NSParameterAssert(1 <= month && month <= 12);
    NSParameterAssert(1 <= day   && day   <= 31);
    
    if (![super init])
        return nil;
    
    _year = year;
    _month = month;
    _day = day;
    
	jeulgi = [NSDictionary dictionaryWithObjectsAndKeys:@"입춘",@"2/4",@"우수",@"2/18",@"경칩",@"3/5",@"춘분",@"3/20",@"청명",@"4/4",@"곡우",@"4/20",
			  @"입하",@"5/5",@"소만",@"5/21",@"망종",@"6/5",@"하지",@"6/21",@"소서",@"7/7",@"대서",@"7/22",
			  @"입추",@"8/7",@"처서",@"8/23",@"백로",@"9/7",@"추분",@"9/23",@"한로",@"10/8",@"상강",@"10/23",
			  @"입동",@"11/7",@"소설",@"11/22",@"대설",@"12/7",@"동지",@"12/21",@"소한",@"1/5",@"대한",@"1/20",nil];
	jeulgiYoon = [NSDictionary dictionaryWithObjectsAndKeys:@"입춘",@"2/5",@"우수",@"2/19",@"경칩",@"3/6",@"춘분",@"3/21",@"청명",@"4/5",@"곡우",@"4/21",
				  @"입하",@"5/6",@"소만",@"5/22",@"망종",@"6/6",@"하지",@"6/22",@"소서",@"7/8",@"대서",@"7/23",
				  @"입추",@"8/8",@"처서",@"8/24",@"백로",@"9/8",@"추분",@"9/24",@"한로",@"10/9",@"상강",@"10/24",
				  @"입동",@"11/8",@"소설",@"11/23",@"대설",@"12/8",@"동지",@"12/21",@"소한",@"1/6",@"대한",@"1/21",nil];
	
	if (IsLeapYear(_year)) {		
		_todayJeulgi = [jeulgiYoon objectForKey:[NSString stringWithFormat:@"%d/%d", _month, _day]];
	} else {
		_todayJeulgi = [jeulgi objectForKey:[NSString stringWithFormat:@"%d/%d", _month, _day]];
	}
	
	if (_todayJeulgi == NULL) {
		_todayJeulgi = @"";
	}
	
    return self;
}



#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    return [[KLDate allocWithZone:zone] initWithYear:_year month:_month day:_day];
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    // super is an NSObject and does not implement NSCoding, so we use designated initializer instead
    if (![super init])
        return nil;
    
    [decoder decodeValueOfObjCType:@encode(NSInteger) at:(void*)&_year];
    [decoder decodeValueOfObjCType:@encode(NSInteger) at:(void*)&_month];
    [decoder decodeValueOfObjCType:@encode(NSInteger) at:(void*)&_day];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    // super is an NSObject and does not implement NSCoding, so we don't tell super to encode itself
    [encoder encodeValueOfObjCType:@encode(NSInteger) at:(void*)&_year];
    [encoder encodeValueOfObjCType:@encode(NSInteger) at:(void*)&_month];
    [encoder encodeValueOfObjCType:@encode(NSInteger) at:(void*)&_day];
}

#pragma mark Operations

- (NSComparisonResult)compare:(KLDate *)otherDate
{
    NSInteger selfComposite = ([self yearOfCommonEra]*10000) 
                            + ([self monthOfYear]*100)
                            + [self dayOfMonth];
    
    NSInteger otherComposite = ([otherDate yearOfCommonEra]*10000) 
                             + ([otherDate monthOfYear]*100)
                             + [otherDate dayOfMonth];
    
    if (selfComposite < otherComposite)
        return NSOrderedAscending;
    else if (selfComposite == otherComposite)
        return NSOrderedSame;
    else
        return NSOrderedDescending;
}

- (BOOL)isEarlierThan:(KLDate *)aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)isLaterThan:(KLDate *)aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL)isToday
{
    return ([self compare:[KLDate today]] == NSOrderedSame);
}

- (BOOL)isEqual:(id)anObject
{
    if ([anObject isKindOfClass:[self class]]) {
        return [self compare:anObject] == NSOrderedSame;
    } else {
        return NO;
    }
}

- (NSUInteger)hash
{
    return [self monthOfYear];
}

- (NSString *)description
{
    if([self monthOfYear] <10 && [self dayOfMonth]<10 )
		return [NSString stringWithFormat:@"%ld-0%ld-0%ld",(long)[self yearOfCommonEra],(long)[self monthOfYear],(long)[self dayOfMonth]];
	else if([self monthOfYear] <10)
		return [NSString stringWithFormat:@"%ld-0%ld-%ld",(long)[self yearOfCommonEra],(long)[self monthOfYear],(long)[self dayOfMonth]];
	else if ([self dayOfMonth]<10)
		return [NSString stringWithFormat:@"%ld-%ld-0%ld",(long)[self yearOfCommonEra],(long)[self monthOfYear],(long)[self dayOfMonth]];
	else
		return [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[self yearOfCommonEra],(long)[self monthOfYear],(long)[self dayOfMonth]];
}
-(NSString*)previousDay
{
	if([self monthOfYear] <10 && [self dayOfMonth]<11 )
		return [NSString stringWithFormat:@"%ld-0%ld-0%ld",(long)[self yearOfCommonEra],(long)[self monthOfYear],(long)([self dayOfMonth]+1)];
	else if([self monthOfYear] <10)
		return [NSString stringWithFormat:@"%ld-0%ld-%ld",(long)[self yearOfCommonEra],(long)[self monthOfYear],(long)([self dayOfMonth]+1)];
	else if ([self dayOfMonth]<11)
		return [NSString stringWithFormat:@"%ld-%ld-0%ld",(long)[self yearOfCommonEra],(long)[self monthOfYear],(long)([self dayOfMonth]+1)];
	else
		return [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[self yearOfCommonEra],(long)[self monthOfYear],(long)([self dayOfMonth]+1)];
}

#pragma mark NSCalendarDate-like interface
- (NSInteger)yearOfCommonEra 
{ 
    return _year;
}

- (NSInteger)monthOfYear
{
    return _month;
}

- (NSInteger)dayOfMonth
{
    return _day;
}

- (NSString *)todayJeulgi {
	return _todayJeulgi;
}

- (BOOL)isTheLastDayOfTheYear { return _month == 12 && _day == 31; }
- (BOOL)isTheFirstDayOfTheYear { return _month == 1 && _day == 1; }

- (BOOL)isTheDayBefore:(KLDate *)anotherDate
{
    // trivial case first
    if (![self isEarlierThan:anotherDate])
        return NO;

    // at this point, I know that self is earlier than anotherDate
    if ([anotherDate yearOfCommonEra] - _year > 1)
        return NO;
    else if ([anotherDate yearOfCommonEra] - _year == 1)
        return [self isTheLastDayOfTheYear] && [anotherDate isTheFirstDayOfTheYear];
    
    // at this point, I know that self and anotherDate are both in the same year
    if ([anotherDate monthOfYear] - _month > 1)
        return NO;
    else if (_month == [anotherDate monthOfYear])
        return [anotherDate dayOfMonth] - _day == 1;
    
    // at this point, self is in the month before anotherDate
    if ([anotherDate dayOfMonth] != 1)
        return NO;
    
    // at this point, self is in the month before anotherDate, and anotherDate is the first day in its month
    
    switch (_month) {
        case 1:
            return _day == 31;
        case 2:
            return IsLeapYear(_year) ? _day == 29 : _day == 28;
        case 3:
            return _day == 31;
        case 4:
            return _day == 30;
        case 5:
            return _day == 31;
        case 6:
            return _day == 30;
        case 7:
            return _day == 31;
        case 8:
            return _day == 31;
        case 9:
            return _day == 30;
        case 10:
            return _day == 31;
        case 11:
            return _day == 30;
        case 12:
            return _day == 31;
        default:
            NSAssert(NO, @"Fell through switch statement in [KLDate isTheDayBefore:]");
            break;
    }
    return NO;
}

@end
