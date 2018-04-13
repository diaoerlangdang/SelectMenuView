//
//  WWSelectMenuView.m
//  TestSelectMenu
//
//  Created by wuruizhi on 2018/3/29.
//  Copyright © 2018年 wuruizhi. All rights reserved.
//

#import "WWSelectMenuView.h"
#import <Masonry.h>


//默认文字颜色
#define DEFAULT_NORMAL_TEXT_COLOR UIColor.blackColor
//默认文字选中颜色
#define DEFAULT_SELECT_TEXT_COLOR UIColor.blackColor

//默认背景颜色
#define DEFAULT_NORMAL_BG_COLOR UIColor.whiteColor

//默认背景选中颜色
#define DEFAULT_SELECT_BG_COLOR [UIColor colorWithRed:0xD0/255.0 green:0xD0/255.0 blue:0xD0/255.0 alpha:1]

//默认分隔线颜色
#define DEFAULT_SEPARATE_LINE_COLOR [UIColor colorWithRed:0xD0/255.0 green:0xD0/255.0 blue:0xD0/255.0 alpha:1]

//默认字体大小
#define DEFAULT_NORMAL_TEXT_FONT [UIFont systemFontOfSize:15]

//默认选中字体大小
#define DEFAULT_SELECT_TEXT_FONT [UIFont systemFontOfSize:15]

//分隔线左侧边距
#define DEFAULT_SEPARATE_LINE_MARGIN_LEFT  10.0

//分割线右侧边距
#define DEFAULT_SEPARATE_LINE_MARGIN_RIGHT 10.0

@interface WWSelectMenuView()<UITableViewDelegate, UITableViewDataSource>


/**
 tableView 数组
 */
@property (nonatomic, strong) NSMutableArray<UITableView *> *tableViews;


/**
 背景框
 */
@property (nonatomic, strong) UIView *bgView;


/**
 内容view
 */
@property (nonatomic, strong) UIView *contentView;


@property (nonatomic, strong)MASConstraint *heigthMas;

//是否正在隐藏
@property (nonatomic, assign) BOOL isHidding;


@end

@implementation WWSelectMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableViews = [NSMutableArray array];
        _selectIndexArr = [NSMutableArray array];
        _sectionWidth = 100;
        _isShow = false;
        _isHidding = false;
        
        _textColor = DEFAULT_NORMAL_TEXT_COLOR;
        _selectTextColor = DEFAULT_SELECT_TEXT_COLOR;
        _textFont = DEFAULT_NORMAL_TEXT_FONT;
        _selectTextFont = DEFAULT_SELECT_TEXT_FONT;
        
        _bgColor = DEFAULT_NORMAL_BG_COLOR;
        _selectBgColor = DEFAULT_SELECT_BG_COLOR;
        
        _separateLineColor = DEFAULT_SEPARATE_LINE_COLOR;
        _separateLineMarginLeft = DEFAULT_SEPARATE_LINE_MARGIN_LEFT;
        _separateLineMarginRight = DEFAULT_SEPARATE_LINE_MARGIN_RIGHT;
        
        _bgView = [UIView new];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        
        _bgView.userInteractionEnabled = YES;
        [_bgView addGestureRecognizer:tapGestureRecognizer];
        
        _contentView = [UIView new];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
        }];
        
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(selectMenuView:numberOfRowsInSection:)]) {
        
        return [_delegate selectMenuView:self numberOfRowsInSection:[_tableViews indexOfObject:tableView]];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger section = [_tableViews indexOfObject:tableView];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(selectMenuView:section:row:)]) {
        
        cell.textLabel.text = [_delegate selectMenuView:self section:section row:indexPath.row];
    }
    
    if (_selectIndexArr.count > section && indexPath.row == [_selectIndexArr[section] integerValue]) {
        cell.backgroundColor = _selectBgColor;
        cell.textLabel.textColor = _selectTextColor;
        cell.textLabel.font = _selectTextFont;
    }
    else {
        cell.backgroundColor = _bgColor;
        cell.textLabel.textColor = _textColor;
        cell.textLabel.font = _textFont;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [_tableViews indexOfObject:tableView];
    NSInteger num = 0;
    if (_delegate != nil && [_delegate respondsToSelector:@selector(numberOfSectionsInSelectMenuView:)]) {
        
        num = [_delegate numberOfSectionsInSelectMenuView:self];
    }
    
    //修改选中列表
    if (_selectIndexArr.count < section) {
        [_selectIndexArr addObject:@(indexPath.row)];
    }
    else {
        _selectIndexArr[section] = @(indexPath.row);
    }
    
    
    //选择
    if (_delegate != nil && [_delegate respondsToSelector:@selector(selectMenuView:section:didSelect:)]) {
        [_delegate selectMenuView:self section:section didSelect:indexPath.row];
    }
    
    //正在隐藏
    if (_isHidding) {
        return;
    }
    
    if (section+1 >= num) {
        
        [self hideMenu:true];
    }
    else {
        
        [_tableViews[section] reloadData];
        
        if (section+1 >= _tableViews.count) {
            [self addTableView];
        }
        else {
            [_tableViews[section+1] reloadData];
            
            NSArray<UITableView *> *tmp = [_tableViews subarrayWithRange:NSMakeRange(section+2, _tableViews.count-section-2)];
            for (UITableView *view in tmp) {
                NSInteger pos = [_tableViews indexOfObject:view];
                [_selectIndexArr removeObjectAtIndex:pos];
                [view removeFromSuperview];
                [_tableViews removeObject:view];
            }
            
            if (_selectIndexArr.count > section+1) {
                [_selectIndexArr removeObjectAtIndex:section+1];
            }
            
//            _selectIndexArr[section+1] = @(-1);
        }
    }
}



//更新tableviews
- (void)updateTableViews
{
    NSInteger num = 0;
    if (_delegate != nil && [_delegate respondsToSelector:@selector(numberOfSectionsInSelectMenuView:)]) {
        
        num = [_delegate numberOfSectionsInSelectMenuView:self];
    }
    
    for (UIView *view in _tableViews) {
        [view removeFromSuperview];
    }
    
    [_tableViews removeAllObjects];
    [_selectIndexArr removeAllObjects];
    
    [self addTableView];

}

- (void)addTableView {
    
    UITableView *lastView = nil;
    
    if (_tableViews.count > 0) {
        lastView = _tableViews[_tableViews.count-1];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, CGFLOAT_MIN)];
    tableView.separatorInset = UIEdgeInsetsMake(0, _separateLineMarginLeft, 0, _separateLineMarginRight);
    tableView.separatorColor = _separateLineColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsHorizontalScrollIndicator = false;
    tableView.showsVerticalScrollIndicator = false;
    [_contentView addSubview:tableView];
    [_tableViews addObject:tableView];
//    [_selectIndexArr addObject:@(-1)];
    
    
    __block MASConstraint *leftMas = nil;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (lastView == nil) {
            make.left.equalTo(_contentView).offset(7);
        }
        else {
            //菜单没展示
            if (!_isShow) {
                make.left.equalTo(lastView.mas_right).offset(5);
            }
            else {
                leftMas = make.left.equalTo(lastView);
            }
            
        }
        make.top.equalTo(_contentView);
        make.width.equalTo(@(_sectionWidth));
        make.height.equalTo(_contentView);
    }];
    
    [_contentView bringSubviewToFront: lastView];
    
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(tableView); 
        make.right.equalTo(tableView.mas_right).offset(-5);
        if (_isShow) {
            _heigthMas = make.height.equalTo(self).multipliedBy(0.5);
        }
        else {
            make.height.equalTo(@0);
        }
    }];
    
    
    if (_isShow) {
        [self layoutIfNeeded];
        
        [leftMas uninstall];
        
        [UIView animateWithDuration:0.3 animations:^{
            [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(5);
            }];
            //强制绘制
            [self layoutIfNeeded];
        }];
    }
    
}


/**
 显示菜单
 
 @param superView 父view
 */
- (void)showMenuForSuperView:(UIView *)superView
{
    if (_isShow) {
        return;
    }
    
    [self updateTableViews];
    
    [superView addSubview:self];
    _isShow = true;
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            _heigthMas = make.height.equalTo(self).multipliedBy(0.5);
        }];
        //强制绘制
        [self layoutIfNeeded];
    }];
    
}


/**
 隐藏menu
 */
- (void)hideMenu
{
    [self hideMenu:false];
}

/**
 隐藏menu
 
 @param isFinish 是否完成
 */
- (void)hideMenu:(BOOL)isFinish
{
    if (isFinish) {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(selectMenuView:finish:)]) {
            [_delegate selectMenuView:self finish:_selectIndexArr];
        }
    }
    else {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(selectMenuViewWithCancel:)]) {
            [_delegate selectMenuViewWithCancel:self];
        }
    }
    
    _isHidding = true;
    
    [self layoutIfNeeded];
    
    if (_heigthMas != nil) {
        [_heigthMas uninstall];
        _heigthMas = nil;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        //强制绘制
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self removeFromSuperview];
            _isShow = false;
            _isHidding = false;
        }
        
    }];
}

@end
