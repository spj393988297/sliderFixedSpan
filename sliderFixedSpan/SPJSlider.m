
//
//  Created by spj on 16/3/24.
//  Copyright © 2016年 杰子 All rights reserved.
//
//



#define SelectViewBgColor   [UIColor colorWithRed:9/255.0 green:170/255.0 blue:238/255.0 alpha:1]
#define defaultViewBgColor  [SPJColorHex colorWithHexString:@"#b6b6b6"]

#define SPJSlideWidth      (self.bounds.size.width)
#define SPJSliderHight     (self.bounds.size.height)

#define SPJSliderTitle_H   (SPJSliderHight*.3)

#define CenterImage_W       26.0

#define SPJSliderLine_W    (SPJSlideWidth-CenterImage_W)
#define SPJSLiderLine_H    2.0
#define SPJSliderLine_Y    (SPJSliderHight-SPJSliderTitle_H)


#define CenterImage_Y       (SPJSliderLine_Y+(SPJSLiderLine_H/2))


#import "SPJSlider.h"
#import "SPJColorHex.h"
@interface SPJSlider()
{

    CGFloat _pointX;
    NSInteger _sectionIndex;//当前选中的那个
    CGFloat _sectionLength;//根据数组分段后一段的长度
    UILabel *_selectLab;
    UILabel *_leftLab;
    UILabel *_rightLab;
}
/**
 *  必传，范围（0到(array.count-1)）
 */
@property (nonatomic,assign)CGFloat defaultIndx;

/**
 *  必传，传入节点数组
 */
@property (nonatomic,strong)NSArray *titleArray;

/**
 *  首，末位置的title
 */
@property (nonatomic,strong)NSArray *firstAndLastTitles;
/**
 *  传入图片
 */
@property (nonatomic,strong)UIImage *sliderImage;

@property (strong,nonatomic)UIView *selectView;
@property (strong,nonatomic)UIView *defaultView;
@end

@implementation SPJSlider


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    [super drawRect:rect];
//}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor=[UIColor clearColor];
    
    //userInteractionEnabled=YES;代表当前视图可交互，该视图不响应父视图手势
    //UIView的userInteractionEnabled默认是YES，UIImageView默认是NO
    _defaultView=[[UIView alloc] initWithFrame:CGRectMake(CenterImage_W/2, SPJSliderLine_Y, SPJSlideWidth-CenterImage_W, SPJSLiderLine_H)];
    _defaultView.backgroundColor=defaultViewBgColor;
    _defaultView.layer.cornerRadius=SPJSLiderLine_H/2;
    _defaultView.userInteractionEnabled=NO;
    [self addSubview:_defaultView];
    
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(CenterImage_W/2, SPJSliderLine_Y, SPJSlideWidth-CenterImage_W, SPJSLiderLine_H)];
    _selectView.backgroundColor = [UIColor redColor];
    _selectView.layer.cornerRadius = SPJSLiderLine_H/2;
    _selectView.userInteractionEnabled = NO;
    [self addSubview:_selectView];
    
    _centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CenterImage_W, CenterImage_W)];
    _centerImage.center=CGPointMake(0, CenterImage_Y);
    _centerImage.userInteractionEnabled = NO;
    _centerImage.alpha = 1;
    [self addSubview:_centerImage];
    
    _selectLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    _selectLab.textColor=[UIColor blackColor];
    _selectLab.font=[UIFont systemFontOfSize:14];
    _selectLab.textAlignment=1;
    [self addSubview:_selectLab];
    
    self.showLabel = [[UILabel alloc]initWithFrame:CGRectMake(SPJSlideWidth/2-100, CGRectGetMaxY(_centerImage.frame)+60, 200, 80)];
    self.showLabel.textAlignment = NSTextAlignmentCenter;
    self.showLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:self.showLabel];
}

- (void)initWithTitles:(NSArray *)titleArray firstAndLastTitles:(NSArray *)firstAndLastTitles defaultIndex:(int)defaultIndex sliderImage:(UIImage *)sliderImage
{
        _pointX=0;
        _sectionIndex=0;
            
        self.titleArray = titleArray;
        self.defaultIndx = defaultIndex;
        self.firstAndLastTitles=firstAndLastTitles;
        self.sliderImage=sliderImage;
}


-(void)setDefaultIndx:(CGFloat)defaultIndx{
    CGFloat withPress=defaultIndx/(_titleArray.count-1);
    //设置默认位置
    CGRect rect=[_selectView frame];
    rect.size.width = withPress * SPJSliderLine_W;
    _selectView.frame = rect;
    
    _pointX=withPress * SPJSliderLine_W;
    _sectionIndex=defaultIndx;
}

-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    _sectionLength = (SPJSliderLine_W/(titleArray.count-1));
    //NSLog(@"(%lu),(%f),(%f)",(unsigned long)titleArray.count,LiuXSliderLine_W,_sectionLength);
}

-(void)setFirstAndLastTitles:(NSArray *)firstAndLastTitles{
    _leftLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 80, SPJSliderTitle_H)];
    _leftLab.font=[UIFont systemFontOfSize:12];
    _leftLab.textColor=[UIColor lightGrayColor];
    _leftLab.text=[firstAndLastTitles firstObject];
    [self addSubview:_leftLab];
    
    _rightLab=[[UILabel alloc] initWithFrame:CGRectMake(SPJSlideWidth-80, 10, 80, SPJSliderTitle_H)];
    _rightLab.font=[UIFont systemFontOfSize:12];
    _rightLab.textColor=[UIColor lightGrayColor];
    _rightLab.text=[firstAndLastTitles lastObject];
    _rightLab.textAlignment=2;
    [self addSubview:_rightLab];
}

-(void)setSliderImage:(UIImage *)sliderImage{
    _centerImage.image=sliderImage;
    [self refreshSlider];
}


#pragma mark ---UIColor Touchu
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    _pointX=_sectionIndex*(_sectionLength);
    [self refreshSlider];
    [self labelEnlargeAnimation];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    [self refreshSlider];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    _pointX=_sectionIndex*(_sectionLength);
    if (self.block) {
        self.block([self.titleArray objectAtIndex:_sectionIndex]);
    }
    [self refreshSlider];
    [self labelLessenAnimation];
    
}

-(void)changePointX:(UITouch *)touch{
    CGPoint point = [touch locationInView:self];
    _pointX=point.x;
    if (point.x<0) {
        _pointX=CenterImage_W/2;
    }else if (point.x>SPJSliderLine_W){
        _pointX=SPJSliderLine_W+CenterImage_W/2;
    }
    //四舍五入计算选择的节点
    _sectionIndex=(int)roundf(_pointX/_sectionLength);
//    NSLog(@"pointx=(%f),(%ld),(%f)",point.x,(long)_sectionIndex,_pointX);
   
}

-(void)refreshSlider{
    _pointX=_pointX+CenterImage_W/2;
    _centerImage.center=CGPointMake(_pointX, CenterImage_Y);
    CGRect rect = [_selectView frame];
    rect.size.width=_pointX-CenterImage_W/2;
    _selectView.frame=rect;
    
    //_selectLab.center=CGPointMake(_pointX, 3);
    _selectLab.text=[NSString stringWithFormat:@"%@",_titleArray[_sectionIndex]];
    if (_sectionIndex==0) {
        _leftLab.hidden=YES;
        _selectLab.center=CGPointMake(_pointX, 10);
    }else if (_sectionIndex==_titleArray.count-1) {
        _rightLab.hidden=YES;
        _selectLab.center=CGPointMake(_pointX, 10);
    }else{
        _leftLab.hidden=NO;
        _rightLab.hidden=NO;
        _selectLab.center=CGPointMake(_pointX, 7);
    }
    
}

-(void)labelEnlargeAnimation{
    [UIView animateWithDuration:.1 animations:^{
        [_selectLab.layer setValue:@(1.4) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)labelLessenAnimation{
    [UIView animateWithDuration:.1 animations:^{
        [_selectLab.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        
    }];
}


@end
