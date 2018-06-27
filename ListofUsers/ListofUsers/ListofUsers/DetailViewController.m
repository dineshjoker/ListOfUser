//
//  DetailViewController.m
//  ListofUsers
//
//  Created by dinesh on 26/06/18.
//  Copyright © 2018 dinesh. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize detailUserValues,detailUserTblView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Detail Screen";
    
    self.userImage.image = [UIImage imageWithData:[detailUserValues valueForKey:@"profileImage"]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"Id: %@",[detailUserValues valueForKey:@"id"]];
   
    }else if (indexPath.row ==1){
    
        cell.textLabel.text = [NSString stringWithFormat:@"FirstName: %@",[detailUserValues valueForKey:@"firstName"]];
   
    }else if (indexPath.row == 2){
        
        cell.textLabel.text = [NSString stringWithFormat:@"LastName: %@",[detailUserValues valueForKey:@"lastName"]];
    }
    
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
