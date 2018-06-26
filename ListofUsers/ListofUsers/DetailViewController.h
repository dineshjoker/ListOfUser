//
//  DetailViewController.h
//  ListofUsers
//
//  Created by dinesh on 26/06/18.
//  Copyright © 2018 dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersList+CoreDataClass.h"
@interface DetailViewController : UIViewController

@property(strong,nonatomic) UsersList *detailUserValues;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITableView *detailUserTblView;

@end
