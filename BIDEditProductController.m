//
//  BIDEditProductController.m
//  MacysProject
//
//  Created by Jose Alvarado on 8/10/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import "BIDEditProductController.h"

@interface BIDEditProductController ()

@end

@implementation BIDEditProductController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"Edit Product";
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *buttonSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSave setTitle:@"Save" forState:UIControlStateNormal];
    buttonSave.titleLabel.font = [UIFont fontWithName:@"Muli" size:14];
    buttonSave.titleLabel.textAlignment = NSTextAlignmentRight;

    buttonSave.bounds = CGRectMake(0, 0, 60, 30);
    [buttonSave sizeToFit];
    [buttonSave addTarget:self action:@selector(buttonSave:) forControlEvents:UIControlEventTouchUpInside];
    buttonSave.titleLabel.textColor = [UIColor blackColor];

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:buttonSave];
    
    self.navigationItem.rightBarButtonItem = barButton;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated{
    self.textFieldName.text = self.product.name;
    
    self.textFieldPrice.text = [NSString stringWithFormat:@"%.2f", self.product.regularPrice];
    self.textFieldSalePrice.text = [NSString stringWithFormat:@"%.2f", self.product.salePrice];
    self.textViewDescription.text = self.product.description;
    
    self.buttonGreen.selected = NO;
    self.buttonRed.selected = NO;
    self.buttonBlue.selected = NO;
    
    for (int i = 0; i < [self.product.colors count]; i++) {
        NSString *color = [self.product.colors objectAtIndex:i];
        if ([color isEqualToString:@"green"]) {
            self.buttonGreen.selected = YES;
        } else if ([color isEqualToString:@"red"]){
            self.buttonRed.selected = YES;
        } else {
            self.buttonBlue.selected = YES;
        }
    }
    
    self.buttonSalem.selected = NO;
    self.buttonPortland.selected = NO;
    self.buttonSacramento.selected = NO;
    self.buttonSanFrancisco.selected = NO;
    
    for (NSString *key in self.product.stores) {
        NSArray *subArray = [self.product.stores objectForKey:key];
        
        for (int i = 0; i < [subArray count]; i++) {
            NSString *city = [subArray objectAtIndex:i];
            if ([city isEqualToString:@"Salem"]) {
                self.buttonSalem.selected = YES;
            } else if ([city isEqualToString:@"Portland"]){
                self.buttonPortland.selected = YES;
            } else if ([city isEqualToString:@"Sacramento"]){
                self.buttonSacramento.selected = YES;
            } else {
                self.buttonSanFrancisco.selected = YES;
            }
        }
    }
    
}

- (void) setProduct:(BIDProduct *)product{
    self.product = product;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonSave:(id)sender {
    self.product.name = self.textFieldName.text;
    self.product.regularPrice = [self.textFieldPrice.text doubleValue];
    self.product.salePrice = [self.textFieldSalePrice.text doubleValue];
    self.product.description = self.textViewDescription.text;
    
    NSMutableArray *newColors = [[NSMutableArray alloc] init];
    if (self.buttonGreen.selected) {
        [newColors addObject:@"green"];
    }
    if (self.buttonRed.selected) {
        [newColors addObject:@"red"];
    }
    if (self.buttonBlue.selected) {
        [newColors addObject:@"blue"];
    }
    self.product.colors = newColors;
    
    NSMutableDictionary *newStores = [[NSMutableDictionary alloc] init];
    if (self.buttonPortland.selected || self.buttonSalem.selected) {
        NSMutableArray *stores = [[NSMutableArray alloc] init];
        if (self.buttonPortland.selected) {
            [stores addObject:@"Portland"];
        }
        if (self.buttonSalem.selected){
            [stores addObject:@"Salem"];
        }
        [newStores setValue:stores forKeyPath:@"Oregon"];
    }
    if (self.buttonSacramento.selected || self.buttonSanFrancisco.selected) {
        NSMutableArray *stores = [[NSMutableArray alloc] init];
        if (self.buttonSacramento.selected) {
            [stores addObject:@"Sacramento"];
        }
        if (self.buttonSanFrancisco.selected){
            [stores addObject:@"San Francisco"];
        }
        [newStores setValue:stores forKeyPath:@"California"];
    }
    self.product.stores = newStores;
    
    id<BIDEditProductControllerDelegate> editDelegate = self.delegate;
    
    [editDelegate updateProduct:_product];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.currentResponder = textView;
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self.currentResponder resignFirstResponder];
}

- (IBAction)buttonSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}
@end
