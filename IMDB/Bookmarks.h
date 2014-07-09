//
//  Bookmarks.h
//  IMDB
//
//  Created by progforce on 22.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bookmarks : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    NSMutableArray * array;
}
@property (retain,nonatomic) IBOutlet UITableView * table;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain) NSIndexPath * Index;
@end
