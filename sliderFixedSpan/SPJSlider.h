//
//  SPJSlider.h
//  SPJlider
//
//  Created by spj on 16/7/18.
//  Copyright © 2016年 杰子 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPJSlider.h"
typedef void(^valueChangeBlock)(NSString *string);

@interface SPJSlider : UIControl



/**
 *  回调
 */
@property (nonatomic, copy)valueChangeBlock block;

@property (strong, nonatomic)UIImageView *centerImage;

@property (nonatomic, strong)UILabel *showLabel;
/**
 *  初始化方法
 *
 *  @param frame
 *  @param titleArray         必传，传入节点数组
 *  @param firstAndLastTitles 首，末位置的title
 *  @param defaultIndex       必传，范围（0到(array.count-1)）
 *  @param sliderImage        传入画块图片
 *
 *  @return 
 */
- (void)initWithTitles:(NSArray *)titleArray
    firstAndLastTitles:(NSArray *)firstAndLastTitles
          defaultIndex:(int)defaultIndex
           sliderImage:(UIImage *)sliderImage;



@end
