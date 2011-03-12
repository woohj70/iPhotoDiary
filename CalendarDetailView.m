//
//  CalendarDetailView.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 30..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "CalendarDetailView.h"
#import "EXFLogging.h"

@implementation CalendarDetailView

@synthesize dateLabel;
@synthesize closeButton;

- (id)initWithFrame:(CGRect)frame andButton:(CalendarButton *)button{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code

		calButton = button;
//		[button release];
		Debug(@"CalendarDetailView dateButton.retainCount = %d", [button retainCount]);
//		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detailviewbg.png"]];
		self.backgroundColor = [UIColor clearColor];
//		[self setNeedsDisplay];
		
		[self drawControlls];
    }
    return self;
}

- (void)drawControlls {
	KLDate *date = [calButton klDate];
	MCLunarDate *lunarDate = [calButton lunarDate];
	NSString *yoondal = [lunarDate isYoondal]?@"윤달":@"평달";
	NSArray *events = calButton.eventArray;
	NSMutableString *eventname = @"";
	
	
	dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 250, 35)];
	dateLabel.backgroundColor = [UIColor clearColor];
	dateLabel.font = [UIFont systemFontOfSize:14];
	dateLabel.textColor = [UIColor whiteColor];
	dateLabel.text = [NSString stringWithFormat:@"%d년 %d월 %d일의 정보", [date yearOfCommonEra], [date monthOfYear], [date dayOfMonth]];
	[self addSubview:dateLabel];
	[dateLabel release];
	Debug(@"dateLabel.retainCount = %d", [dateLabel retainCount]);	
	
	closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.frame = CGRectMake(250, 200, 60, 30);
	[closeButton setBackgroundImage:[UIImage imageNamed:@"btnClose"] forState:UIControlStateNormal];
	closeButton.backgroundColor = [UIColor darkGrayColor];
	
	[closeButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchDown];
	[self addSubview:closeButton];
	
	UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(5, 35, 250, 180)];
	contentView.font = [UIFont systemFontOfSize:14];
	contentView.textColor = [UIColor whiteColor];
	contentView.editable = NO;
	contentView.backgroundColor = [UIColor clearColor];
	
		
	if ([events count] > 0) {
		eventname = @"Event 목록";
		
		//		Debug("event count = %d, %d", [events count], [dateButton.eventArray count]);
		for (NSInteger i = 0; i < [events count]; i++) {
			EventData *data = [events objectAtIndex:i];
			//			Debug("calendar button clicked = %@", [data valueForKey:@"eventname"]);
			eventname = [NSString stringWithFormat:@"%@\n%d. %@", eventname, i + 1, [data valueForKey:@"eventname"]];
		}
	}
	
	
	
	NSArray *diary = calButton.diaryArray;
	
	if ([diary count] > 0) {
		eventname = [NSString stringWithFormat:@"%@\n\nDiary 목록", eventname];
		
		for (NSInteger i = 0; i < [diary count]; i++) {
			DiaryData *data = [diary objectAtIndex:i];
			//			Debug("calendar button clicked = %@", [data valueForKey:@"tag"]);
			eventname = [NSString stringWithFormat:@"%@\n%d. %@", eventname, i + 1, [data valueForKey:@"tag"]];
		}
	}
	
	
	
	NSMutableDictionary *dic = calButton.anniversaryDic;
	
	if ([dic count] > 0) {
		eventname = [NSString stringWithFormat:@"%@\n\n기념일 목록", eventname];
		
		NSArray *keys = [dic allKeys];
		for (NSInteger i = 0; i < [keys count]; i++) {
			NSMutableDictionary *dic2 = [dic objectForKey:[keys objectAtIndex:i]];
			//			Debug("calendar button clicked = %@", [dic2 objectForKey:@"name"]);
			eventname = [NSString stringWithFormat:@"%@\n%d. %@", eventname, i + 1, [dic2 objectForKey:@"name"]];
		}
	}
	
	contentView.text = [NSString stringWithFormat:@"음력 단기 %d년 %d월 %d일\n%@년 %@월 %@일 %@\n절기 : %@\n\n%@", 
	 [lunarDate yearDangi], [lunarDate lunarMonth], [lunarDate lunarDay],
	 [lunarDate currentYearGapjaChinese],[lunarDate monthOfYearGapjaChinese],[lunarDate dayOfWeekGapjaChinese],
	 yoondal,[date todayJeulgi],eventname];
	
	
	[self addSubview:contentView];
	
	
	[contentView release];
	
	
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

	[super drawRect:rect];
	UIImage *img = [UIImage imageNamed: @"detailviewbg.png"];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


- (void)hideView {
	Debug(@"hideView");
	[self removeFromSuperview];
	
	Debug(@"self.retainCount = %d", [self retainCount]);
//	[self release];
}

- (void)dealloc {
	[dateLabel release];
	[closeButton release];
	[calButton release];
    [super dealloc];
}


@end
