//
//  WBClassifyScanTableViewController.m
//  whubook2
//
//  Created by lxyy on 15/3/6.
//  Copyright (c) 2015年 lxyy. All rights reserved.
//

#import "WBClassifyScanTableViewController.h"
#import "WBTime.h"

@interface WBClassifyScanTableViewController ()

@end

@implementation WBClassifyScanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"WBClassifyScanTVC");
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"教材";
    
    [self getupdatewithTableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getupdatewithTableView
{
    
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    [mutDic setObject:[WBTime userId] forKey:@"userId"];
    [mutDic setObject:[WBTime doId] forKey:@"doId"];
    [mutDic setObject:@"m" forKey:@"who"];
    [mutDic setObject:[NSNumber numberWithInt:-1] forKey:@"type"];
    [mutDic setObject:[NSNumber numberWithInt:1] forKey:@"currentPage"];
    [mutDic setObject:[NSNumber numberWithInt:10] forKey:@"each"];
    [mutDic setObject:[NSNumber numberWithInt:-1] forKey:@"beginId"];
    [mutDic setObject:@"goodsId" forKey:@"orderBy"];
    [mutDic setObject:@"up" forKey:@"orderUp"];
    [mutDic setObject:[NSNumber numberWithInt:1] forKey:@"school"];
    [mutDic setObject:[NSNumber numberWithInt:26] forKey:@"academy"];
    
    NSData *mutDicdata = [NSJSONSerialization dataWithJSONObject:mutDic options:NSJSONWritingPrettyPrinted error:nil];
    //NSString *datastr = [[NSString alloc] initWithData:mutDicdata encoding:NSUTF8StringEncoding];
    NSString *datastr = [NSString stringWithFormat:@"doId=%@&userId=%@&who=m&type=%@&currentPage=%@&each=%@&beginId=%@&orderBy=%@&orderUp=%@&school=%@&academy=%@",[WBTime doId], [WBTime userId], [mutDic objectForKey:@"type"], [mutDic objectForKey:@"currentPage"], [mutDic objectForKey:@"each"], [mutDic objectForKey:@"beginId"], [mutDic objectForKey:@"orderBy"], [mutDic objectForKey:@"orderUp"], [mutDic objectForKey:@"school"], [mutDic objectForKey:@"academy"]];
    
    NSLog(@"datastr ----- %@",datastr);
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.whubook.com/books/getbooks"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [datastr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString *str1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            id object;        //遍历输出dic
            NSEnumerator * enumerator = [dic keyEnumerator];
            while(object = [enumerator nextObject])
            {
                id objectValue = [dic objectForKey:object];
                if(objectValue != nil)
                {
                    NSLog(@"%@所对应的value是 %@",object,objectValue);
                }
            }
            
//NSLog(@"233");
            //NSLog(@"返回：  %@",str1);
            //code
        }];
    }];
    
    [dataTask resume];
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}



- (IBAction)cancelAddAccount {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
