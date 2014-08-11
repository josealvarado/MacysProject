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
    _textFieldName.text = _product.name;
    
    _textFieldPrice.text = [NSString stringWithFormat:@"%.2f", _product.regularPrice];
    _textFieldSalePrice.text = [NSString stringWithFormat:@"%.2f", _product.salePrice];
    _textViewDescription.text = _product.description;
    
    _buttonGreen.selected = NO;
    _buttonRed.selected = NO;
    _buttonBlue.selected = NO;
    
    for (int i = 0; i < [_product.colors count]; i++) {
        NSString *color = [_product.colors objectAtIndex:i];
        if ([color isEqualToString:@"green"]) {
            _buttonGreen.selected = YES;
        } else if ([color isEqualToString:@"red"]){
            _buttonRed.selected = YES;
        } else {
            _buttonBlue.selected = YES;
        }
    }
    
    _buttonSalem.selected = NO;
    _buttonPortland.selected = NO;
    _buttonSacramento.selected = NO;
    _buttonSanFrancisco.selected = NO;
    
    for (NSString *key in _product.stores) {
        NSArray *subArray = [_product.stores objectForKey:key];
        
        for (int i = 0; i < [subArray count]; i++) {
            NSString *city = [subArray objectAtIndex:i];
            if ([city isEqualToString:@"Salem"]) {
                _buttonSalem.selected = YES;
            } else if ([city isEqualToString:@"Portland"]){
                _buttonPortland.selected = YES;
            } else if ([city isEqualToString:@"Sacramento"]){
                _buttonSacramento.selected = YES;
            } else {
                _buttonSanFrancisco.selected = YES;
            }
        }
    }
    
}

- (void) setProduct:(BIDProduct *)product{
    _product = product;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonSave:(id)sender {
    _product.name = _textFieldName.text;
    _product.regularPrice = [_textFieldPrice.text doubleValue];
    _product.salePrice = [_textFieldSalePrice.text doubleValue];
    _product.description = _textViewDescription.text;
    
    NSMutableArray *newColors = [[NSMutableArray alloc] init];
    if (_buttonGreen.selected) {
        [newColors addObject:@"green"];
    }
    if (_buttonRed.selected) {
        [newColors addObject:@"red"];
    }
    if (_buttonBlue.selected) {
        [newColors addObject:@"blue"];
    }
    _product.colors = newColors;
    
    NSMutableDictionary *newStores = [[NSMutableDictionary alloc] init];
    if (_buttonPortland.selected || _buttonSalem.selected) {
        NSMutableArray *stores = [[NSMutableArray alloc] init];
        if (_buttonPortland.selected) {
            [stores addObject:@"Portland"];
        }
        if (_buttonSalem.selected){
            [stores addObject:@"Salem"];
        }
        [newStores setValue:stores forKeyPath:@"Oregon"];
    }
    if (_buttonSacramento.selected || _buttonSanFrancisco.selected) {
        NSMutableArray *stores = [[NSMutableArray alloc] init];
        if (_buttonSacramento.selected) {
            [stores addObject:@"Sacramento"];
        }
        if (_buttonSanFrancisco.selected){
            [stores addObject:@"San Francisco"];
        }
        [newStores setValue:stores forKeyPath:@"California"];
    }
    _product.stores = newStores;
    
    id<BIDEditProductControllerDelegate> editDelegate = self.delegate;
    
    [editDelegate updateProduct:_product];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _currentResponder = textField;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    _currentResponder = textView;
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [_currentResponder resignFirstResponder];
}

- (IBAction)buttonSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}
@end
