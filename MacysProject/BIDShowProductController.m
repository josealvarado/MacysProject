//
//  BIDShowProductController.m
//  MacysProject
//
//  Created by Jose Alvarado on 8/10/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "BIDShowProductController.h"
#import "BIDProduct.h"
#import <sqlite3.h>

@interface BIDShowProductController ()

@property (nonatomic) NSMutableArray *products;

@end

@implementation BIDShowProductController

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
}

- (void)viewWillAppear:(BOOL)animated{
    self.products = [[NSMutableArray alloc] init];
    
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    NSString *creatSQL = @"CREATE TABLE IF NOT EXISTS PRODUCTS "
    "(ROW INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, DESCRIPTION TEXT, PRICE REAL, SALE_PRICE REAL, IMAGE TEXT, COLORS TEXT, STORES)";
    char *errorMsg;
    if (sqlite3_exec(database, [creatSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Error creating table: %s", errorMsg);
    }
    
    NSString *query = @"SELECT ROW, NAME, DESCRIPTION, PRICE, SALE_PRICE, IMAGE, COLORS, STORES FROM PRODUCTS";
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            int row = sqlite3_column_int(statement, 0);
            char *name = (char *)sqlite3_column_text(statement, 1);
            char *description = (char *)sqlite3_column_text(statement, 2);
            double price = sqlite3_column_double(statement, 3);
            double sale_price = sqlite3_column_double(statement, 4);
            char *image = (char *)sqlite3_column_text(statement, 5);
            char *colors = (char *)sqlite3_column_text(statement, 6);
            char *stores = (char *)sqlite3_column_text(statement, 7);
            
//            NSLog(@"row - %d", row);
//            NSLog(@"name - %s", name);
//            NSLog(@"description - %s", description);
//            NSLog(@"price - %f", price);
//            NSLog(@"sale_price - %f", sale_price);
//            NSLog(@"image - %s", image);
//            NSLog(@"colors - %s", colors);
//            NSLog(@"stores - %s", stores);
            
            
            NSString *productName = [[NSString alloc] initWithUTF8String:name];
            NSString *productDescription = [[NSString alloc] initWithUTF8String:description];
            NSString *productImage = [[NSString alloc] initWithUTF8String:image];
            NSString *productColors = [[NSString alloc] initWithUTF8String:colors];
            NSString *productStores = [[NSString alloc] initWithUTF8String:stores];

            NSArray *array = [NSJSONSerialization JSONObjectWithData:[productColors dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[productStores dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            
            BIDProduct *product = [[BIDProduct alloc] init];
            product.prouctID = row;
            product.name = productName;
            product.description = productDescription;
            product.regularPrice = price;
            product.salePrice = sale_price;
            product.image = productImage;
            product.colors = [array mutableCopy];
            product.stores = dict;
            
            [self.products addObject:product];
            
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(database);
    
//    NSLog(@"product size = %d", [self.products count]);
    
    [self.tableView reloadData];

}

- (NSString *) dataFilePath
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
    return [self.products count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    BIDProduct *product = [_products objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = product.name;
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setSelection:)]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        BIDProduct *product = [self.products objectAtIndex:indexPath.row];
        NSDictionary *selection = @{@"indexPath" : indexPath,
                                    @"object" : product.name};
        [destination setValue:selection forKey:@"selection"];
    
        [destination setValue:product forKey:@"product"];
    }
}


@end
