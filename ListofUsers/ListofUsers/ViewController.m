//
//  ViewController.m
//  ListofUsers
//
//  Created by dinesh on 25/06/18.
//  Copyright © 2018 dinesh. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface ViewController (){
    
    NSMutableDictionary *dic;
    
    NSMutableArray *dataArr;
    
    NSManagedObjectContext *context;
    
    AppDelegate *app;
    
    UIImage *img;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    dataArr = [[NSMutableArray alloc]init];
    
    app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    context = app.persistentContainer.viewContext;

     [self gettingSavedValues];
    
    [self JsonRequestandResponce:[NSURL URLWithString:@"https://reqres.in/api/users"]];
        
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (dataArr.count) {
        
        NSMutableDictionary *Userdic = [dataArr objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[Userdic valueForKey:@"firstName"],[Userdic valueForKey:@"lastName"]];
        
        UIImage *Image = [UIImage imageWithData:[Userdic valueForKey:@"profileImage"]];
        
        cell.imageView.image = Image;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UsersList *dic = [dataArr objectAtIndex:indexPath.row];

    DetailViewController *detailView = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    detailView.detailUserValues = dic;
    
    [self.navigationController pushViewController:detailView animated:YES];

}

-(void)JsonRequestandResponce:(NSURL *)url{
    
    NSURLSessionConfiguration *sessionConf = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConf];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    req.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *DataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            for (NSDictionary *dicValue in [dic valueForKey:@"data"]) {
                
                [self loadbyPaging:dicValue];
            }
            
            
            NSError *error;
            
            if (![context save:&error]) {
                
//                NSLog(@"Failed to Save");
            }
            
            [self gettingSavedValues];
            
            if ([dic valueForKey:@"page"] <= [dic valueForKey:@"total_pages"]) {
                
                NSNumber *page = [dic valueForKey:@"page"];
                
                int pageint = [page intValue];
                
                [self JsonRequestandResponce:[NSURL URLWithString:[NSString stringWithFormat:@"https://reqres.in/api/users?page=%d",pageint + 1]]];
            }
            
        }
    }];
    
    [DataTask resume];
    
}

-(void)loadbyPaging:(NSDictionary *)responceData{
    
    NSIndexPath *path;
    
    int i;
    
    for (i = 0; i<1; i++) {
        
        [self savemethod:responceData];
        
        path = [NSIndexPath indexPathForRow:dataArr.count - 1 inSection:0];
    }
    
}

-(void)savemethod:(NSDictionary *)responceData{
    
    NSNumber *idvalue = [responceData valueForKey:@"id"];
    
    UsersList * ObjValue = [self checkValueAlreadyCreated:[idvalue stringValue]];
    
    if (!ObjValue) {
        
        ObjValue = [NSEntityDescription insertNewObjectForEntityForName:@"UsersList" inManagedObjectContext:context];
        
    }
    
    [ObjValue setValue:[responceData valueForKey:@"first_name"] forKey:@"firstName"];
    
    [ObjValue setValue:[responceData valueForKey:@"last_name"] forKey:@"lastName"];
    
    [ObjValue setValue:[idvalue stringValue] forKey:@"id"];
    
    NSURL *url = [NSURL URLWithString:[responceData valueForKey:@"avatar"]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [ObjValue setValue:data forKey:@"profileImage"];
    
}

-(UsersList *)checkValueAlreadyCreated:(NSString *)idValue{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"UsersList"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", idValue];
    
    [request setPredicate:predicate];
    
    NSArray *valueDic = [context executeFetchRequest:request error:nil];
    
    return valueDic.count > 0 ? valueDic.firstObject : nil;

}

-(void)gettingSavedValues{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"UsersList"];
    
    [dataArr removeAllObjects];
    
    dataArr = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:nil]];
        
    dispatch_async(dispatch_get_main_queue(), ^{
        
         [self.ListOfTbleview reloadData];
    });
    
   
}

@end
