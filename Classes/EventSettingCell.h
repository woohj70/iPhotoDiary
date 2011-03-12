//
//  EvenSettingCell.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 25..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventSettingCell : UITableViewCell {
	UILabel *titleLabel;
	UILabel *valueLabel;
	
	NSDate *eventDate;
}

@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UILabel *valueLabel;
@property(nonatomic, retain) NSDate *eventDate;

@end
