//
//  ViewController.m
//  sliderFixedSpan
//
//  Created by 孙培杰 on 16/7/25.
//  Copyright © 2016年 spj. All rights reserved.
//

#import "ViewController.h"
#import "SPJSlider.h"
#define UISCREENWIDTH [[UIScreen mainScreen]bounds].size.width
#define UISCREENHEIGHT [[UIScreen mainScreen]bounds].size.height

@interface ViewController ()
@property (nonatomic, strong)SPJSlider *slider;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSlider];
}

- (void)addSlider{
    NSArray *titlesArray = @[@"1000",@"2000",@"3000",@"4000",@"5000",@"6000"];
    NSArray *firstAndLastArray = @[@"1000",@"6000"];
    self.slider=[[SPJSlider alloc]initWithFrame:CGRectMake(UISCREENWIDTH/2-150,UISCREENHEIGHT/2-20, 300, 40)];
    [self.slider initWithTitles:titlesArray firstAndLastTitles:firstAndLastArray defaultIndex:2 sliderImage:[UIImage imageNamed:@"circle"]];
    [self.view addSubview:self.slider];
    __weak ViewController *weakSelf = self;
    self.slider.block = ^(NSString *string){
        NSLog(@"当前选择的为%@",string);
        weakSelf.slider.showLabel.text = string;
    };
}

@end
