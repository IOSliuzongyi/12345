//
//  HomeCollectionVC.m
//  takedaApp
//
//  Created by user001 on 2017/5/8.
//  Copyright © 2017年 user001. All rights reserved.
//

#import "HomeViewController.h"
#import "MainCollectionCell.h"

static NSString * const cellID = @"MainCollectionCell";
@interface HomeViewController ()
@property (nonatomic) NSArray *dataArray;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupInitData];
    [self setupInitUI];
    [self loadData];
}

- (void)setupInitUI
{
    self.navigationItem.title  = @"武田应用商店";
//    self.collectionView.alwaysBounceVertical = YES;
    self.view.backgroundColor = [AppColor customViewBgColor];
//    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil]
//          forCellWithReuseIdentifier:cellID];
}

- (void)setupInitData
{
    _dataArray = @[@{ @"title":@"吾爱武家", @"icon":@"pic",@"abstract":@"111", @"class": @""},
                   @{ @"title":@"武田SFE", @"icon":@"pic",@"abstract":@"222", @"class": @""},
                   @{ @"title":@"GCMM2016", @"icon":@"pic",@"abstract":@"333", @"class": @""},
                   @{ @"title":@"武田财管家", @"icon":@"pic",@"abstract":@"444", @"class": @""},
                     @{ @"title":@"武田大咖(KA)", @"icon":@"pic",@"abstract":@"555", @"class": @""}, ];
}

- (void)loadData
{

}

#pragma mark --UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray count];
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dic[@"icon"]];
    cell.title.text = dic[@"title"];
    cell.detail.text = dic[@"abstract"];
    return  cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 0, 8);
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CUScreenWidth() - 16)/3, 110);
}

//UICollectionView被选中时调用的方法
#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
 }

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 允许选中时，高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 设置是否允许取消选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
