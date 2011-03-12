//
//  AddAnniversaryTableViewController.m
//  iPhotoDiary
//
//  Created by HYOUNG JUN WOO on 10. 6. 27..
//  Copyright 2010 Mazdah.com. All rights reserved.
//

#import "AddAnniversaryTableViewController.h"
#import "AnniversaryModel.h"

#import "EXFLogging.h"


@implementation AddAnniversaryTableViewController

@synthesize delegate;
@synthesize annData;

#pragma mark -
#pragma mark View lifecycle

/*
- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {

	}
	
	return self;
}
*/

- (void)viewDidLoad {
	
//	UIApplication *app = [UIApplication sharedApplication];
//	[[NSNotificationCenter defaultCenter] addObserver:self 
//											 selector:@selector(applicationWillTerminate:)
//												name :UIApplicationWillTerminateNotification
//											   object:app];
	[super viewDidLoad];
//	[self loadData];
//	Debug(@"Default = %@", [annData count]);
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
	Debug(@"viewWillAppear");
    [super viewWillAppear:animated];

//	[self loadData];
//	Debug(@"Default = %@", [annData count]);
}


/*
- (void)viewDidAppear:(BOOL)animated {
	Debug(@"viewDidAppear");
    [super viewDidAppear:animated];
}
*/

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark -
#pragma mark Persistance File Process

- (void)loadData {
	NSString *filePath = [self dataFilePath];
	Debug("filePath = %@", filePath);
//	NSError *error;
//	[[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
	tempData = [[NSMutableDictionary alloc] init];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		annData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
		
		if ([annData isKindOfClass:[NSMutableDictionary class]]) {
			Debug("loadData : OK - annData.count = %d", [annData count]);
		} else {
			Debug("loadData : NOT OK - class name = %@", [[annData class] name]);
		}
	} else {
		Debug(@"File Not Exist");
		annData = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *firstData = [[NSMutableDictionary alloc] init];
		[annData setObject:firstData forKey:@"AnnData"];
		[annData writeToFile:filePath atomically:YES];
	}

	
	NSArray *keys = [annData allKeys];
	NSInteger keyNum = 0;
	for (NSInteger i = 0; i < [annData count]; i++) {
		NSString *key = (NSString *)[keys objectAtIndex:i];
		Debug(@"annData[%d].key = %@", i, key);
		if (![key isEqualToString:@"AnnData"]) {
			NSMutableDictionary *data = (NSMutableDictionary *)[annData objectForKey:key];
			Debug(@"[data count] = %d", [data count]);
			
			NSArray *subkeys = [data allKeys];
			
			for (NSInteger j =0; j < [subkeys count]; j++) {
				Debug(@"data[%d].key = %@", j, [subkeys objectAtIndex:j]);
				[tempData setObject:[data objectForKey:[subkeys objectAtIndex:j]] forKey:[NSString stringWithFormat:@"%d",keyNum]];
				keyNum++;
			}			
		}
	}
	
	[self.tableView reloadData];
	Debug("tempData.count = %d", [tempData count]);
}

- (NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	return [documentDirectory stringByAppendingPathComponent:@"AnnData.plist"];
}

#pragma mark -
#pragma mark setEditing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    Debug(@"setEditing");
    [super setEditing:editing animated:animated];
	
	[self.tableView beginUpdates];
	
	NSArray *ingredientsInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[tempData count] inSection:0]];
	
	if (editing) {
		Debug(@"editing is true");
        [self.tableView insertRowsAtIndexPaths:ingredientsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
		//		overviewTextField.placeholder = @"Overview";
	} else {
		Debug(@"editing is false");
        [self.tableView deleteRowsAtIndexPaths:ingredientsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
		//		overviewTextField.placeholder = @"";
    }
    
    [self.tableView endUpdates];
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rows = [tempData count];
	
	if (self.editing) {
		rows++;
	}
	
	Debug(@"rows = %d", rows);
    return rows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	NSInteger ingredientCount = [tempData count];
	UITableViewCell *cell = nil;
	
	Debug(@"cellForRowAtIndexPath : indexPath.row = %d", indexPath.row);
	if (indexPath.row < ingredientCount) {
		// If the row is within the range of the number of ingredients for the current recipe, then configure the cell to show the ingredient name and amount.
		static NSString *IngredientsCellIdentifier = @"IngredientsCell";
		
		cell = [tableView dequeueReusableCellWithIdentifier:IngredientsCellIdentifier];
		
		if (cell == nil) {
			// Create a cell to display an ingredient.
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IngredientsCellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		NSMutableDictionary *tmpdic = (NSMutableDictionary *)[tempData objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
		
		cell.text = [tmpdic objectForKey:@"name"];
		cell.detailTextLabel.text = [tmpdic objectForKey:@"date"];
		cell.image = [UIImage imageNamed:@"ann_icon.png"];		
		
	} else {
		// If the row is outside the range, it's the row that was added to allow insertion (see tableView:numberOfRowsInSection:) so give it an appropriate label.
		static NSString *AddIngredientCellIdentifier = @"AddIngredientCell";
		
		cell = [tableView dequeueReusableCellWithIdentifier:AddIngredientCellIdentifier];
		if (cell == nil) {
			// Create a cell to display "Add Ingredient".
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddIngredientCellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		cell.textLabel.text = @"기념일 등록";
	}
	
	return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
#pragma mark -
#pragma mark Editing rows

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	Debug(@"5555 : indexPath.row = %d", indexPath.row);
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    // Only allow editing in the ingredients section.
    // In the ingredients section, the last row (row number equal to the count of ingredients) is added automatically (see tableView:cellForRowAtIndexPath:) to provide an insertion cell, so configure that cell for insertion; the other cells are configured for deletion.
    // If this is the last item, it's the insertion row.
    if (indexPath.row == [tempData count]) {
        style = UITableViewCellEditingStyleInsert;
    }
    else {
        style = UITableViewCellEditingStyleDelete;
    }
   
    return style;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSMutableDictionary *tdata = [tempData objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
		NSString *delKey = [tdata objectForKey:@"date"];
		Debug("del data key = %@", delKey);
		
		NSMutableDictionary *delData = [annData objectForKey:[tdata objectForKey:@"date"]];
		[delData removeObjectForKey:[tdata objectForKey:@"name"]];
		
		Debug("del data key2 = %@", delKey);
		
		if ([delData count] > 0) {
			[annData setObject:delData forKey:delKey];
		} else {
			[annData removeObjectForKey:[tdata objectForKey:@"date"]];
		}
		
		[annData writeToFile:[self dataFilePath] atomically:YES];
		
		[tempData removeObjectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
		[self loadData];
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	Debug(@"didSelectRowAtIndexPath : indexPath.row = %d", indexPath.row);
	AnniversaryDetailViewController *anniversaryView = [[AnniversaryDetailViewController alloc] initWithNibName:@"AnniversaryDetailViewController" bundle:nil];
	anniversaryView.existData = [tempData objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
	
	[delegate changeViewController:(AnniversaryDetailViewController *)anniversaryView];
//	self.editing = NO;
}

//Edit 모드로 들어갔을 때 셀 선택을 막는 코드
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Debug(@"6666 : %d, %d", indexPath.row, [tempData count]);
	NSIndexPath *rowToSelect = indexPath;
	BOOL isEditing = self.editing;
    // If editing, don't allow instructions to be selected
    // Not editing: Only allow instructions to be selected
	if ((isEditing && indexPath.row < [tempData count])) {
		Debug(@"6666 inner if : %d, %d", indexPath.row, [tempData count]);
	    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	    rowToSelect = nil;    
	}
	
	return rowToSelect;
}

#pragma mark -
#pragma mark Editing

- (void)processEdit:(BOOL) editing {
	self.editing = editing;
	//[self setEditing:editing animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[annData release];
    [super dealloc];
}


@end

