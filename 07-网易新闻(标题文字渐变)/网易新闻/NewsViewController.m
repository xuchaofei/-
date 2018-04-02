//
//  NewsViewController.m
//  网易新闻
//
//  Created by yz on 15/10/21.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "NewsViewController.h"


#import "VideoViewController.h"
#import "ReaderViewController.h"
#import "ScienceViewController.h"
#import "SocietyViewController.h"
#import "HotViewController.h"
#import "TopLineViewController.h"

#import "TitleButton.h"

#define ScreenW  [UIScreen mainScreen].bounds.size.width
#define ScreenH  [UIScreen mainScreen].bounds.size.height



@interface NewsViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *selButton;


@property (nonatomic, strong) NSMutableArray *titleBtns;

// 标题滚动view
@property (weak, nonatomic) IBOutlet UIScrollView *titileScrollView;

// 内容滚动view
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;

@end

@implementation NewsViewController

- (NSMutableArray *)titleBtns
{
    if (_titleBtns == nil) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}

// 头条，热点，视频，社会，订阅，科技(science)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 添加所有子控制器
    [self setUpChildViewController];
    
    // 设置标题
    [self setUpTitle];
    
    // iOS7之后,导航控制器下所有ScrollView都会添加额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    // 初始化scrollView
    [self setUpScrollView];
    
}

- (void)setUpScrollView
{
    self.titileScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width, 0);
    
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.pagingEnabled = YES;
    self.contentView.bounces = NO;
    
    self.contentView.delegate = self;
}


- (void)setUpChildViewController
{
    
    TopLineViewController *topLineVc = [[TopLineViewController alloc] init];
    topLineVc.title = @"头条";
    [self addChildViewController:topLineVc];
    
    HotViewController *hotVc = [[HotViewController alloc] init];
    hotVc.title = @"热点";
    [self addChildViewController:hotVc];
    
    VideoViewController *videoVc = [[VideoViewController alloc] init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    SocietyViewController *societyVc = [[SocietyViewController alloc] init];
    societyVc.title = @"社会";
    [self addChildViewController:societyVc];
    
    ReaderViewController *readerVc = [[ReaderViewController alloc] init];
    readerVc.title = @"订阅";
    [self addChildViewController:readerVc];
    
    ScienceViewController *scienceVc = [[ScienceViewController alloc] init];
    scienceVc.title = @"科技";
    [self addChildViewController:scienceVc];
}


// 设置标题
- (void)setUpTitle
{
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = 100;
    CGFloat btnH = 44;
    
    for (NSUInteger i = 0; i < count; i++) {
        btnX = i * btnW;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title  forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titileScrollView addSubview:btn];
        
        [self.titleBtns addObject:btn];
        // 默认选中第一个
        if (i == 0) {
            [self titleClick:btn];
            
        }
    }
    
    self.titileScrollView.contentSize = CGSizeMake(btnW * count, 0);
    
}

// 点击标题按钮
- (void)titleClick:(UIButton *)btn
{

    
    // 0.设置标题按钮居中
    [self setUpTitleBtnMiddle:btn];
    
    // 1.滚动到对应的界面
    CGFloat offsetX = btn.tag * ScreenW;
    
    self.contentView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.添加对应子控制器view到对应的位置
    UIViewController *vc = self.childViewControllers[btn.tag];
    
    vc.view.frame = CGRectMake(offsetX, 0, ScreenW, self.contentView.bounds.size.height);
    
//    NSLog(@"%@",NSStringFromCGRect(self.contentView.bounds));
    [self.contentView addSubview:vc.view];
    
    // 还原之前标题的形变
    [self setSelectBtn:btn];
    
}

- (void)setSelectBtn:(UIButton *)btn
{
    _selButton.transform = CGAffineTransformIdentity;
    [_selButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selButton.selected = NO;
    
    btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    btn.selected = YES;
    
    _selButton = btn;

}

#pragma mark - UIScrollViewDelegate
// 减速完成的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获取当前的偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 获取页码
    int page = offsetX / scrollView.bounds.size.width;
    
    UIButton *btn = self.titileScrollView.subviews[page];
    
    // 选中按钮
    [self setSelectBtn:btn];
   
    
    // 设置按钮居中
    [self setUpTitleBtnMiddle:btn];
    
    // 添加对应子控制器到界面上
    UIViewController *vc = self.childViewControllers[page];
    
    // 已经加载的view就不需要添加了
    if (vc.isViewLoaded) return;
    
    vc.view.frame = CGRectMake(offsetX , 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    
    [self.contentView addSubview:vc.view];
}

// 设置标题按钮居中
- (void)setUpTitleBtnMiddle:(UIButton *)btn
{
    
    // 计算偏移量
    CGFloat offsetX = btn.center.x - ScreenW * 0.5;
    
    // 左边偏移多了，表示需要往左边看，可视范围往左边，偏移量就减少，最少应该是0
    if (offsetX < 0) offsetX = 0;
    CGFloat maxOffsetX = self.titileScrollView.contentSize.width - ScreenW;
    
    // 右边偏移多了，表示需要往右边看，可视范围往又边，偏移量就增加，最大不超过内容范围 - 屏幕宽度
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;

    
    [self.titileScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}


// 监听内容view滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    
    NSInteger leftIndex = page;
    
    // 右边缩放比例
    CGFloat rightScale = (page - leftIndex);
    // 左边缩放比例
    CGFloat leftScale = (1 - rightScale);
    
    NSInteger rightIndex = leftIndex + 1;
    
    // 获取左边按钮
    TitleButton *leftBtn = self.titleBtns[leftIndex];
    
    NSInteger count = self.titleBtns.count;
    
    // 获取右边按钮
    TitleButton *rightBtn;
    
    if (rightIndex < count) {
       rightBtn  = self.titleBtns[rightIndex];
    }
    
    
    // 设置尺寸
    CGFloat leftTransform = leftScale * 0.3 + 1; // 1 ~ 1.3
    CGFloat rightTransform = rightScale * 0.3 + 1; // 1 ~ 1.3
    leftBtn.transform = CGAffineTransformMakeScale(leftTransform, leftTransform);
    rightBtn.transform = CGAffineTransformMakeScale(rightTransform, rightTransform);
    
    // 设置颜色
    /*
     RGB 红色: 1 0 0
         黑色: 0 0 0
     */

    UIColor *leftColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
    UIColor *rightColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
    
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    
    
    
}


@end
