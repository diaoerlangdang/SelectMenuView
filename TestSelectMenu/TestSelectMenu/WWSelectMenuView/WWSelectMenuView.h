//
//  WWSelectMenuView.h
//  TestSelectMenu
//
//  Created by wuruizhi on 2018/3/29.
//  Copyright © 2018年 wuruizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWSelectMenuView;

@protocol WWSelectMenuViewDelegate<NSObject>

@optional


/**
 菜单块数

 @param selectMenuView 菜单view
 @return 块数
 */
- (NSInteger)numberOfSectionsInSelectMenuView:(WWSelectMenuView *)selectMenuView;



/**
 菜单某块的个数

 @param selectMenuView 菜单view
 @param section 第几块
 @return 个数
 */
- (NSInteger)selectMenuView:(WWSelectMenuView *)selectMenuView numberOfRowsInSection:(NSInteger)section;



/**
 获取数据

 @param selectMenuView 菜单view
 @param section 菜单块
 @param row 某块的位置
 @return 数据
 */
-(NSString *)selectMenuView:(WWSelectMenuView *)selectMenuView section:(NSInteger)section row:(NSInteger)row;


/**
 菜单选择
 
 @param selectMenuView 菜单view
 @param section 第几块
 @param row 选择的位置
 */
- (void)selectMenuView:(WWSelectMenuView *)selectMenuView section:(NSInteger)section didSelect:(NSInteger)row;


/**
 菜单完成
 
 @param selectMenuView 菜单view
 @param selectIndexs 选中的位置数组
 */
- (void)selectMenuView:(WWSelectMenuView *)selectMenuView finish:(NSArray<NSNumber *> *)selectIndexs;


/**
 菜单取消
 
 @param selectMenuView 菜单view
 */
- (void)selectMenuViewWithCancel:(WWSelectMenuView *)selectMenuView;

@end

@interface WWSelectMenuView : UIView

@property (nonatomic, weak) id<WWSelectMenuViewDelegate> delegate;

//选中位置数组
@property (nonatomic, strong, readonly) NSMutableArray<NSNumber *> *selectIndexArr;

//每个菜单的宽度，默认100
@property (nonatomic, assign) CGFloat sectionWidth;

//是否已显示
@property (nonatomic, assign) BOOL isShow;

//文字颜色 默认黑色
@property (nonatomic, strong) UIColor *textColor;

//文字选中颜色 默认黑色
@property (nonatomic, strong) UIColor *selectTextColor;

//文字字体 默认15号字体
@property (nonatomic, strong) UIFont *textFont;

//文字选中字体 默认15号字体
@property (nonatomic, strong) UIFont *selectTextFont;

//背景颜色 默认白色
@property (nonatomic, strong) UIColor *bgColor;

//背景选中颜色 默认0xD0D0D0
@property (nonatomic, strong) UIColor *selectBgColor;

//分隔线颜色 默认0xD0D0D0
@property (nonatomic, strong) UIColor *separateLineColor;

//分隔线左侧距离， 默认10
@property (nonatomic, assign) CGFloat separateLineMarginLeft;

//分隔线右侧距离，默认10
@property (nonatomic, assign) CGFloat separateLineMarginRight;


/**
 显示菜单

 @param superView 父view
 */
- (void)showMenuForSuperView:(UIView *)superView;

/**
 隐藏menu，取消选择
 */
- (void)hideMenu;

/**
 隐藏menu

 @param isFinish 是否完成
 */
- (void)hideMenu:(BOOL)isFinish;

@end
