//
//  SearchFilm.h
//  IMDB
//
//  Created by progforce on 21.10.13.
//  Copyright (c) 2013 Progforce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFilm : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray *array;
    NSMutableData *jsonData;

    BOOL flag;
}
@property (retain,nonatomic) IBOutlet UITableView * table;
@end
