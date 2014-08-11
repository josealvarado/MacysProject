//
//  BIDEditProductController.h
//  MacysProject
//
//  Created by Jose Alvarado on 8/10/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIDProduct.h"

@protocol BIDEditProductControllerDelegate;

@interface BIDEditProductController : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPrice;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSalePrice;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;

@property (weak, nonatomic) IBOutlet UIButton *buttonGreen;
@property (weak, nonatomic) IBOutlet UIButton *buttonRed;
@property (weak, nonatomic) IBOutlet UIButton *buttonBlue;

@property (weak, nonatomic) IBOutlet UIButton *buttonSalem;
@property (weak, nonatomic) IBOutlet UIButton *buttonPortland;

@property (weak, nonatomic) IBOutlet UIButton *buttonSacramento;
@property (weak, nonatomic) IBOutlet UIButton *buttonSanFrancisco;

@property (nonatomic, assign) id currentResponder;

- (IBAction)buttonSelected:(id)sender;


@property (strong, nonatomic) BIDProduct *product;

@property (weak, nonatomic) id<BIDEditProductControllerDelegate> delegate;

- (void)buttonSave:(id)sender;

@end

@protocol BIDEditProductControllerDelegate <NSObject>

- (void)updateProduct:(BIDProduct *) product;

@end


