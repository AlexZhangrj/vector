//
//  QLADScrollView.h
//  ADScrollView
//
//  Created by 王青海 on 15/5/10.
//  Copyright (c) 2015年 王青海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLADScrollViewCell.h"

@class QLADScrollViewCell;
@class QLADScrollView;

@protocol QLADScrollViewDataSource <NSObject>
@required

- (NSInteger)numberOfItemsADScrollView:(QLADScrollView *)ADScrollView;

//设置内容
- (void)ADScrollView:(QLADScrollView *)ADScrollView cellForItemAtItem:(NSInteger)item ADScrollViewCell:(QLADScrollViewCell *)ADScrollViewCell;
@end

@protocol QLADScrollViewDelegate <NSObject>
@optional

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtItem:(NSInteger)item;
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtItem:(NSInteger)item;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtItemAtItem:(NSInteger)item;
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtItemAtItem:(NSInteger)item;

@end

@interface QLADScrollView : UIView



- (instancetype)initWithFrame:(CGRect)frame;


@property (nonatomic, weak) id <QLADScrollViewDelegate> delegate;
@property (nonatomic, weak) id <QLADScrollViewDataSource> dataSource;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic) BOOL allowsSelection; // default is YES


@property (nonatomic, weak, readonly) UIScrollView * scrollView;
@property (nonatomic, weak, readonly) UIPageControl * pageControl;

@property (nonatomic, assign) BOOL autoRoll;


- (void)reloadData;
- (NSUInteger)numberOfItems;




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

@end
