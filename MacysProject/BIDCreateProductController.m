//
//  BIDCreateProductController.m
//  MacysProject
//
//  Created by Jose Alvarado on 8/9/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "BIDCreateProductController.h"
#import <sqlite3.h>

@interface BIDCreateProductController ()

@property NSMutableArray *products;
@property NSMutableArray *images;

@end

@implementation BIDCreateProductController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _products = [@[@"Product 1", @"Prouduct 2", @"Product 3"] mutableCopy];
    _images = [@[@"shoe.png", @"sock.png", @"shirt.png"] mutableCopy];
    
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
//    @property (nonatomic) NSInteger *prouctID;
//    @property (strong, nonatomic) NSString *name;
//    @property (strong, nonatomic) NSString *description;
//    @property (nonatomic) NSDecimal *regularPrice;
//    @property (nonatomic) NSDecimal *salePrice;
//    @property (nonatomic) UIImage *image;
//    @property (strong, nonatomic) NSMutableArray *colors;
//    @property (strong, nonatomic) NSDictionary *stores;
    
    NSString *creatSQL = @"CREATE TABLE IF NOT EXISTS PRODUCTS "
        "(ROW INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, DESCRIPTION TEXT, PRICE REAL, SALE_PRICE REAL, IMAGE TEXT, COLORS TEXT, STORES TEXT)";
    char *errorMsg;
    if (sqlite3_exec(database, [creatSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Error creating table: %s", errorMsg);
    }
    
    sqlite3_close(database);
}

-(NSString *) dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"data.sqlite"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_products count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [_products objectAtIndex:indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *productName = [_products objectAtIndex:indexPath.row];
    NSString *productDescription = @"Description";
    double price = 5.0;
    double sale_price = 3.0;
    NSString *image = [_images objectAtIndex:indexPath.row];
    
    NSArray *colors = @[@"green", @"red", @"blue"];
    NSDictionary *stores = @{@"Oregon": @[@"Salem", @"Portland"], @"California": @[@"San Francisco", @"Sacramento"]};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:colors
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString * jsonColors = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSData *jsonStoreData = [NSJSONSerialization dataWithJSONObject:stores options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStores = [[NSString alloc] initWithData:jsonStoreData encoding:NSUTF8StringEncoding];
    
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    char *insert = "INSERT INTO PRODUCTS (NAME, DESCRIPTION, PRICE, SALE_PRICE, IMAGE, COLORS, STORES) "
        "VALUES (?, ?, ?, ?, ?, ?, ?);";
    char *errorMsg = NULL;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, insert, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [productName UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [productDescription UTF8String], -1, NULL);
        sqlite3_bind_double(stmt, 3, price);
        sqlite3_bind_double(stmt, 4, sale_price);
        sqlite3_bind_text(stmt, 5, [image UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 6, [jsonColors UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [jsonStores UTF8String], -1, NULL);
    }
    if (sqlite3_step(stmt) != SQLITE_DONE){
        NSAssert(0, @"Error updating table: %s", errorMsg);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    
    [[[UIAlertView alloc] initWithTitle:@"Success"
                                message:[NSString stringWithFormat:@"Created %@", productName]
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil, nil] show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
