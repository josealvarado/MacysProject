//
//  BIDProduct.h
//  MacysProject
//
//  Created by Jose Alvarado on 8/9/14.
//  Copyright (c) 2014 ___Jose-Alvarado___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIDProduct : NSObject

@property int prouctID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;
@property double regularPrice;
@property double salePrice;
@property (nonatomic) NSString *image;
@property (strong, nonatomic) NSMutableArray *colors;
@property (strong, nonatomic) NSDictionary *stores;

@end
