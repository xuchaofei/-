//
//  TitleButton.m
//  网易新闻
//
//  Created by yz on 15/10/21.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "TitleButton.h"

@implementation TitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect drawRect = CGRectMake(0, 0, rect.size.width * self.progress, rect.size.height);
    [[UIColor redColor] set];
    
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
//    UIRectFill(drawRect);
}


@end
