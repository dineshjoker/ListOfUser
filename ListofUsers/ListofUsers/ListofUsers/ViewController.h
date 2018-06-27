//
//  ViewController.h
//  ListofUsers
//
//  Created by dinesh on 25/06/18.
//  Copyright © 2018 dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersList+CoreDataClass.h"
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ListOfTbleview;


@end

