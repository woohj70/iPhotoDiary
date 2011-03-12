//
//  ChildGenderInfoCell.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 25..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChildGenderInfoCellDelegate;

@interface ChildGenderInfoCell : UITableViewCell {
	UILabel *labelField;
	UISegmentedControl *genderControl;
	id<ChildGenderInfoCellDelegate> delegate;
}

@property(nonatomic,retain) IBOutlet UILabel *labelField;
@property(nonatomic,retain) IBOutlet UISegmentedControl *genderControl;

@property(nonatomic, assign) id<ChildGenderInfoCellDelegate> delegate;

@end

@protocol ChildGenderInfoCellDelegate <NSObject>

- (void)scrollNewPosition:(ChildGenderInfoCell *)cell;
@end