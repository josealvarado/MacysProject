//
//  BIDProductImageController.m
//  MacysProject
//
//  Created by Jose Alvarado on 8/10/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "BIDProductImageController.h"

@interface BIDProductImageController ()

@end

@implementation BIDProductImageController

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
    
    [self.viewProductImage setImage:[UIImage imageNamed:[self.selection2 objectForKey:@"name"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
