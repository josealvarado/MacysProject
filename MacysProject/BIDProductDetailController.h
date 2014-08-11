//
//  BIDProductDetailController.h
//  MacysProject
//
//  Created by Jose Alvarado on 8/10/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIDProduct.h"
#import "BIDEditProductController.h"

@interface BIDProductDetailController : UIViewController<UIActionSheetDelegate, BIDEditProductControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelID;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIButton *buttonImage;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelSalePrice;
@property (weak, nonatomic) IBOutlet UITextView *textViewColors;
@property (weak, nonatomic) IBOutlet UITextView *textViewStores;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
- (IBAction)buttonOptions:(id)sender;

@property (copy, nonatomic) NSDictionary *selection;

@property (strong, nonatomic) BIDProduct *product;

@end
