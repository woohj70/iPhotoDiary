//
//  DiaryListCell.h
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 23..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiaryListCellDelegate;

@interface DiaryListCell : UITableViewCell {
	UILabel *titleField;
	UILabel *dateField;
	
	UIImageView *photoView;
	id<DiaryListCellDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UILabel *titleField;
@property (nonatomic, retain) IBOutlet UILabel *dateField;
@property (nonatomic, retain) IBOutlet UIImageView *photoView;

@property (nonatomic, retain) id<DiaryListCellDelegate> delegate;

@end

@protocol DiaryListCellDelegate

- (void)moveDiaryView;

@end