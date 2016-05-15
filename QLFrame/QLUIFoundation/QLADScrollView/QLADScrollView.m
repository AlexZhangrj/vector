//
//  QLADScrollView.m
//  ADScrollView
//
//  Created by 王青海 on 15/5/10.
//  Copyright (c) 2015年 王青海. All rights reserved.
//

#import "QLADScrollView.h"

@interface QLScrollViewTapInNoScroll : UIScrollView

@property (nonatomic, assign) BOOL isTapIn;
//@property (nonatomic, copy)

@end

@implementation QLScrollViewTapInNoScroll

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    self.isTapIn = YES;
//    NSLog(@"uyy");
//    [super touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    self.isTapIn = NO;
//    NSLog(@"nn");
//    [super touchesEnded:touches withEvent:event];
//}
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"%p", event);
//    return [super hitTest:point withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    UITapGestureRecognizer
//    NSLog(@"touchesCancelled");
//}

@end


@interface QLADScrollView ()<UIScrollViewDelegate>
{
    NSUInteger _numberOfItems;
}
@property (nonatomic, assign) NSUInteger numberOfItems;
@property (nonatomic, weak) QLADScrollViewCell * cellLeft;
@property (nonatomic, weak) QLADScrollViewCell * cellCenter;
@property (nonatomic, weak) QLADScrollViewCell * cellRight;

@property (nonatomic, weak) QLADScrollViewCell * focusCell;

@property (nonatomic, assign) NSInteger rollCount;

//focus焦点

@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, assign) BOOL isRollingByTimer;

@end


@implementation QLADScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _autoRoll = NO;
        _rollCount = 0;
        UIView * backgroundView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:backgroundView];
        self.backgroundView = backgroundView;
        _allowsSelection = YES;
        
        UIScrollView * scrollView = [[QLScrollViewTapInNoScroll alloc]initWithFrame:self.bounds];
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 30, 0);
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * 10, 0);
        [self addSubview:scrollView];
        _scrollView = scrollView;
        
        
        QLADScrollViewCell * cellLeft = [[QLADScrollViewCell alloc]initWithFrame:CGRectMake(scrollView.frame.size.width * 9, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        cellLeft.backgroundColor = [UIColor whiteColor];
        cellLeft.cellItem = 0;
        [scrollView addSubview:cellLeft];
        _cellLeft = cellLeft;
//        cellLeft.backgroundColor = [UIColor yellowColor];
        
        QLADScrollViewCell * cellCenter = [[QLADScrollViewCell alloc]initWithFrame:CGRectMake(scrollView.frame.size.width * 10, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        cellCenter.backgroundColor = [UIColor whiteColor];
        cellCenter.cellItem = 0;
        [scrollView addSubview:cellCenter];
        _cellCenter = cellCenter;
//        cellCenter.backgroundColor = [UIColor blueColor];
        
        QLADScrollViewCell * cellRight = [[QLADScrollViewCell alloc]initWithFrame:CGRectMake(scrollView.frame.size.width * 11, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        cellRight.backgroundColor = [UIColor whiteColor];
        cellRight.cellItem = 0;
        [scrollView addSubview:cellRight];
        _cellRight = cellRight;
//        cellRight.backgroundColor = [UIColor greenColor];
        
//        for (NSInteger i=0; i<30; i++) {
//            QLADScrollViewCell * cellRight = [[QLADScrollViewCell alloc]initWithFrame:CGRectMake(scrollView.frame.size.width * i, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
//            [scrollView addSubview:cellRight];
////            self.cellRight = cellRight;
//            cellRight.backgroundColor = [UIColor greenColor];
//            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
//            lab.backgroundColor = [UIColor blueColor];
//            lab.text = [NSString stringWithFormat:@"%ld", i];
//            [cellRight addSubview:lab];
//            
//            
//        }
        
        
        UIPageControl * pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 70, 14)];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:311.0/255 green:31.0/255 blue:100.0/255 alpha:1.0f];
        pageControl.center = CGPointMake(self.bounds.size.width - 40, self.bounds.size.height - 10);
        [self addSubview:pageControl];
        _pageControl = pageControl;
        
    }
    return self;
}

- (void)recoverScrollViewAndCell
{
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * 10, 0);
    
    _cellLeft.frame = CGRectMake(self.scrollView.frame.size.width * 9, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    _cellLeft.cellItem = 0;
    
    _cellCenter.frame = CGRectMake(self.scrollView.frame.size.width * 10, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    _cellCenter.cellItem = 0;
    
    _cellRight.frame = CGRectMake(self.scrollView.frame.size.width * 11, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    _cellRight.cellItem = 0;
    
    self.pageControl.currentPage = 0;
}

- (void)setNumberOfItems:(NSUInteger)numberOfItems
{
    _numberOfItems = numberOfItems;
    self.pageControl.numberOfPages = numberOfItems;
    
    
    if (_numberOfItems == 0) {
        _cellLeft.cellItem = -1;
        _cellCenter.cellItem = -1;
        _cellRight.cellItem = -1;
    }else if (_numberOfItems == 1) {
        _cellLeft.cellItem = 0;
        _cellCenter.cellItem = 0;
        _cellRight.cellItem = 0;
    }else if (_numberOfItems == 2) {
        _cellLeft.cellItem = 1;
        _cellCenter.cellItem = 0;
        _cellRight.cellItem = 1;
    }else if(_numberOfItems > 2){
        _cellLeft.cellItem = numberOfItems - 1;
        _cellCenter.cellItem = 0;
        _cellRight.cellItem = 1;
    }else {
        _cellLeft.cellItem = - 1;
        _cellCenter.cellItem = - 1;
        _cellRight.cellItem = - 1;
    }
}

- (void)reloadData
{
    [self recoverScrollViewAndCell];
    if (self.dataSource) {
        NSInteger num = [self.dataSource numberOfItemsADScrollView:self];
        if (num < 0) {
            num = 0;
        }
        self.numberOfItems = (NSUInteger)num;
        if (_cellLeft.cellItem > -1) {
            [self.dataSource ADScrollView:self cellForItemAtItem:_cellLeft.cellItem ADScrollViewCell:_cellLeft];
        }
        if (_cellCenter.cellItem > -1) {
            [self.dataSource ADScrollView:self cellForItemAtItem:_cellCenter.cellItem ADScrollViewCell:_cellCenter];
        }
        if (_cellRight.cellItem > -1) {
            [self.dataSource ADScrollView:self cellForItemAtItem:_cellRight.cellItem ADScrollViewCell:_cellRight];
        }
    }
}

- (void)setAutoRoll:(BOOL)autoRoll
{
    if (_autoRoll != autoRoll) {
        _autoRoll = autoRoll;
        if (autoRoll) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(nextCell:) userInfo:nil repeats:YES];
        }else {
            [self.timer invalidate];
            self.timer = nil;
            self.isRollingByTimer = NO;
            self.scrollView.userInteractionEnabled = YES;
        }
    }
}

- (void)nextCell:(NSTimer *)timer
{
//    NSLog(@"%@", [NSDate date]);
    if (self.rollCount < 0) {
        self.rollCount = 0;
    }else {
        if (((QLScrollViewTapInNoScroll *)self.scrollView).isTapIn) {
            self.rollCount = 0;
        }else {
            self.rollCount ++;
            if (self.rollCount >= 3) {
                [self rollScrollViewByTime];
                self.rollCount = 0;
            }
        }
    }
}

- (void)rollScrollViewByTime
{
    self.isRollingByTimer = YES;
    self.scrollView.userInteractionEnabled = NO;
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x += self.scrollView.frame.size.width;
    [UIView animateWithDuration:1 animations:^{
        self.scrollView.contentOffset = contentOffset;
    } completion:^(BOOL finished) {
        self.isRollingByTimer = NO;
        self.scrollView.userInteractionEnabled = YES;
        UIScrollView * scrollView = self.scrollView;

        
        if (scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * 21, 0);
            CGRect frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x - scrollView.frame.size.width;
            _cellLeft.frame = frame;
            
            frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x;
            _cellCenter.frame = frame;
            
            frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x + scrollView.frame.size.width;
            _cellRight.frame = frame;
            
        }else if (scrollView.contentOffset.x >= scrollView.bounds.size.width * 28) {
            scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * 8, 0);
            CGRect frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x - scrollView.frame.size.width;
            _cellLeft.frame = frame;
            
            frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x;
            _cellCenter.frame = frame;
            
            frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x + scrollView.frame.size.width;
            _cellRight.frame = frame;
        }
    }];
    
}

- (NSUInteger)numberOfItems
{
    return _numberOfItems;
}

- (void)setFocusCell:(QLADScrollViewCell *)focusCell
{
    if (_focusCell != focusCell) {
//        _focusCell.backgroundColor = [UIColor greenColor];
        _focusCell = focusCell;
        if (_focusCell == self.cellLeft) {
            CGRect frame = self.cellRight.frame;
            frame.origin.x = _focusCell.frame.origin.x - _focusCell.frame.size.width;
            self.cellRight.frame = frame;
            NSInteger item = _focusCell.cellItem - 1;
            if ([self numberOfItems] == 0) {
                item = -1;
            }else if ([self numberOfItems] == 1) {
                item = 0;
            }else if ([self numberOfItems] == 2) {
                if (_focusCell.cellItem == 0) {
                    item = 1;
                }else {
                    item = 0;
                }
            }else{
                if (item < 0) {
                    item = [self numberOfItems] - 1;
                }
            }

            self.cellRight.cellItem = item;
            
            self.cellLeft = self.cellRight;
            self.cellRight = self.cellCenter;
            self.cellCenter = _focusCell;
            
            if (_cellLeft.cellItem > -1) {
                [self.dataSource ADScrollView:self cellForItemAtItem:_cellLeft.cellItem ADScrollViewCell:_cellLeft];
            }
            
        }else if (_focusCell == self.cellRight) {
            CGRect frame = self.cellLeft.frame;
            frame.origin.x = _focusCell.frame.origin.x + _focusCell.frame.size.width;
            self.cellLeft.frame = frame;
            
            NSInteger item = _focusCell.cellItem + 1;
            if ([self numberOfItems] == 0) {
                item = -1;
            }else if ([self numberOfItems] == 1) {
                item = 0;
            }else if ([self numberOfItems] == 2) {
                if (_focusCell.cellItem == 0) {
                    item = 1;
                }else {
                    item = 0;
                }
            }else{
                if (item >= [self numberOfItems]) {
                    item = 0;
                }
            }
            
            self.cellLeft.cellItem = item;
            
            self.cellRight = self.cellLeft;
            self.cellLeft = self.cellCenter;
            self.cellCenter = _focusCell;
            if (_cellRight.cellItem > -1) {
                [self.dataSource ADScrollView:self cellForItemAtItem:_cellRight.cellItem ADScrollViewCell:_cellRight];
            }
        }else if (_focusCell == self.cellCenter) {
            NSLog(@"cellCenter错误");
        }
        
//        [self.cellLeft sendSubviewToBack:self.cellRight];
//        [self.cellLeft sendSubviewToBack:self.cellCenter];
        
//        [self.scrollView insertSubview:self.cellLeft belowSubview:self.cellRight];
//        [self.scrollView insertSubview:self.cellLeft belowSubview:self.cellCenter];

        [self.scrollView insertSubview:self.cellLeft aboveSubview:self.cellRight];
        [self.scrollView insertSubview:self.cellCenter aboveSubview:self.cellRight];
        
        
        self.pageControl.currentPage = _focusCell.cellItem;

//        _focusCell.backgroundColor = [UIColor redColor];
    }
}


/*
- (NSArray *)indexPathsForSelectedItems; // returns nil or an array of selected index paths
- (void)selectItemAtItem:(NSInteger)item animated:(BOOL)animated;
- (void)deselectItemAtItem:(NSInteger)item animated:(BOOL)animated;








- (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point;
- (NSIndexPath *)indexPathForCell:(UICollectionViewCell *)cell;

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)visibleCells;
- (NSArray *)indexPathsForVisibleItems;


- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;


- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion; // allows multiple insert/delete/reload/move calls to be animated simultaneously. Nestable.

*/

#pragma mark scrollView 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
//    NSLog(@"scroll");
//    NSLog(@"%lf", scrollView.contentOffset.x + scrollView.frame.size.width/2 - self.cellRight.frame.origin.x);
//    NSLog(@"%lf", scrollView.contentOffset.x - scrollView.frame.size.width/2 - self.cellCenter.frame.origin.x);

    
//    if (scrollView.contentOffset.x < self.cellCenter.frame.origin.x) {
//        self.cellRight.hidden = YES;
//        self.cellLeft.hidden = NO;
//    }else {
//        self.cellRight.hidden = NO;
//        self.cellLeft.hidden = YES;
//    }
    
    if (scrollView.contentOffset.x + scrollView.frame.size.width/2 > self.cellRight.frame.origin.x && scrollView.contentOffset.x + scrollView.frame.size.width/2 < self.cellRight.frame.origin.x + self.cellRight.frame.size.width) {
        self.focusCell = self.cellRight;
    }else if(scrollView.contentOffset.x + scrollView.frame.size.width/2 < self.cellLeft.frame.origin.x + self.cellLeft.frame.size.width && scrollView.contentOffset.x + scrollView.frame.size.width/2 > self.cellLeft.frame.origin.x) {
        self.focusCell = self.cellLeft;
    }
    
    if (!self.isRollingByTimer) {
        self.rollCount = 0;
        if (scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * 21, 0);
            CGRect frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x - scrollView.frame.size.width;
            _cellLeft.frame = frame;
            
            frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x;
            _cellCenter.frame = frame;
            
            frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x + scrollView.frame.size.width;
            _cellRight.frame = frame;
            
        }else if (scrollView.contentOffset.x >= scrollView.bounds.size.width * 28) {
            scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * 8, 0);
            CGRect frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x - scrollView.frame.size.width;
            _cellLeft.frame = frame;
            
            frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x;
            _cellCenter.frame = frame;
            
            frame = _cellLeft.frame;
            frame.origin.x = scrollView.contentOffset.x + scrollView.frame.size.width;
            _cellRight.frame = frame;
        }
    }else {
        
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    self.rollCount = 0;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    self.rollCount = 0;
}
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
//{
//    NSLog(@"scrollViewWillBeginDecelerating");
//}
//
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    self.rollCount = 0;
}
////滚动动画停止时执行,代码改变时出发,也就是setContentOffset改变时
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    NSLog(@"scrollViewDidEndScrollingAnimation");
}



@end
