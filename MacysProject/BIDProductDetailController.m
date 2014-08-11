//
//  BIDProductDetailController.m
//  MacysProject
//
//  Created by Jose Alvarado on 8/10/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "BIDProductDetailController.h"
#import <sqlite3.h>
#import "BIDEditProductController.h"

@interface BIDProductDetailController ()

@end

@implementation BIDProductDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    UIImage *image = [UIImage imageNamed:self.product.image];
    [self.buttonImage setBackgroundImage:image forState:UIControlStateNormal];
    self.labelID.text = [NSString stringWithFormat:@"%d", self.product.prouctID];
    self.labelName.text = self.product.name;
    self.labelPrice.text = [NSString stringWithFormat:@"%.2f", self.product.regularPrice];
    self.labelSalePrice.text = [NSString stringWithFormat:@"%.2f", self.product.salePrice];
    self.textViewColors.text = [self.product.colors componentsJoinedByString:@", "];
    self.textViewDescription.text = self.product.description;
    self.textViewStores.text = [self fixDictionary:self.product.stores];
}

- (void)updateProduct:(BIDProduct *)product{
    self.product = product;
    
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    NSError *error;
    NSData *jsonColorData = [NSJSONSerialization dataWithJSONObject:self.product.colors options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonColors = [[NSString alloc] initWithData:jsonColorData encoding:NSUTF8StringEncoding];
    
    NSData *jsonStoreData = [NSJSONSerialization dataWithJSONObject:self.product.stores options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStores = [[NSString alloc] initWithData:jsonStoreData encoding:NSUTF8StringEncoding];
    
    NSString *removeKeyword = [NSString stringWithFormat:@"UPDATE PRODUCTS SET NAME = '%@', PRICE = %f, SALE_PRICE = %f, DESCRIPTION = '%@', COLORS = '%@', STORES = '%@' WHERE ROW = %d", self.product.name, self.product.regularPrice, self.product.salePrice, self.product.description, jsonColors, jsonStores,  self.product.prouctID];
    
    sqlite3_stmt *statement;
    const char *errorMsg = NULL;
    if (sqlite3_prepare_v2(database, [removeKeyword UTF8String], -1, &statement, &errorMsg) == SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"successfully updated product");
        }
        else
        {
            NSLog(@"Failed to update %s", errorMsg);
        }
        sqlite3_finalize(statement);
        
    }
    else
    {
        NSLog(@"Failed to update 2 %s", errorMsg);
    }
    sqlite3_close(database);
}

- (NSString *)fixDictionary:(NSDictionary *)dict{
    NSString *returnMe = @"";
    
    for (id key in dict) {
        NSArray *subArray = [dict objectForKey:key];
        
        returnMe = [NSString stringWithFormat:@"%@%@: %@\n", returnMe, key, [subArray componentsJoinedByString:@", "]];
    }
    
    return returnMe;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setSelection2:)]){
        
        NSDictionary *dict = @{@"name": self.product.image};
        
        [destination setValue:dict forKey:@"selection2"];
    }
}


- (IBAction)buttonOptions:(id)sender {
    NSString *actionSheetTitle = @"Product Options";
    NSString *destructiveTitle = @"Delete";
    NSString *other1 = @"Edit";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:other1 , nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        sqlite3 *database;
        if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
            sqlite3_close(database);
            NSAssert(0, @"Failed to open database");
        }
        
        NSString *removeKeyword = [NSString stringWithFormat:@"DELETE FROM PRODUCTS WHERE ROW = %d",_product.prouctID];
        sqlite3_stmt *statement;
        const char *errorMsg = NULL;
        if (sqlite3_prepare_v2(database, [removeKeyword UTF8String], -1, &statement, &errorMsg) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_DONE)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSLog(@"Failed to delete %s", errorMsg);
            }
            sqlite3_finalize(statement);
            
        }
        else
        {
            NSLog(@"Failed to delete 2 %s", errorMsg);
        }
        sqlite3_close(database);
    } else if (buttonIndex == 1){
        
        BIDEditProductController *editProduct = [[BIDEditProductController alloc] init];
        editProduct.delegate = self;
        [editProduct setProduct:self.product];
        
        [self.navigationController pushViewController:editProduct animated:YES];
    }
}

- (NSString *) dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"data.sqlite"];
}

@end
