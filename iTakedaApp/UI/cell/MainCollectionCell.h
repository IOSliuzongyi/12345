//
//  MainCollectionCell.h
//  takadaApp
//
//  Created by  on 08/05/2017.
//  Copyright © 2017 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end
