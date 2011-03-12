//
//  CalendarDetailView.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 30..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarButton.h"
#import "EventData.h"
#import "DiaryData.h"

@interface CalendarDetailView : UIView {
//	UIImageView *imageView;
	UILabel *dateLabel;
	UIButton *closeButton;
	CalendarButton *calButton;
}

@property(nonatomic, retain) UILabel *dateLabel;
@property(nonatomic, retain) UIButton *closeButton;

- (void)hideView;

@end
