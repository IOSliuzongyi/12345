//
//  JCTopic.h
//  PSCollectionViewDemo
//
//  Created by jc on 14-1-7.
//
//

#import <UIKit/UIKit.h>
//#import "URLImageView.h"

@protocol JCTopicDelegate<NSObject>
-(void)didClick:(id)data atIndex:(int)index;
-(void)currentPage:(int)page total:(NSUInteger)total;
@end
@interface JCTopic : UIScrollView<UIScrollViewDelegate>{
    UIButton * pic;
    bool flag;
    int scrollTopicFlag;
    NSTimer * scrollTimer;
    int currentPage;
    CGSize imageSize;
    UIImage *image;
}
@property(nonatomic,strong)NSArray * pics;
@property(nonatomic,weak)id<JCTopicDelegate> JCdelegate;
-(void)releaseTimer;
-(void)upDate;
@end
