//
//  MainCollectionCell.h
//  takedaApp
//
//  Created by user001 on 2017/5/8.
//  Copyright © 2017年 user001. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MainCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end
