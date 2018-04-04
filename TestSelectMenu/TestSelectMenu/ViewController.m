//
//  ViewController.m
//  TestSelectMenu
//
//  Created by wuruizhi on 2018/3/29.
//  Copyright © 2018年 wuruizhi. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "WWSelectMenuView.h"

@interface ViewController ()<WWSelectMenuViewDelegate>

@property (nonatomic, strong) WWSelectMenuView *menuView;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<NSString *> *> *dict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"显示菜单" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
//        make.width.equalTo(@100);
        make.top.equalTo(@100);
    }];
    
    [btn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    _menuView = [WWSelectMenuView new];
    _menuView.delegate = self;
    _menuView.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 500);
    _menuView.selectTextColor = [UIColor redColor];
    _menuView.selectBgColor = [UIColor grayColor];
    
    _dict = [NSMutableDictionary dictionary];
    for (NSInteger i=0; i<10; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger j=0; j<20; j++) {
            NSString *str = [NSString stringWithFormat:@"%ld-%ld",i,j];
            [array addObject:str];
        }
        _dict[[NSString stringWithFormat:@"%ld", i]] = array;
    }
    
}

- (void)showMenu
{
    [_menuView showMenuForSuperView:self.view];
}

- (NSInteger)numberOfSectionsInSelectMenuView:(WWSelectMenuView *)selectMenuView
{
    return 3;
}

- (NSInteger)selectMenuView:(WWSelectMenuView *)selectMenuView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _dict.allKeys.count;
    }
    else if(section == 1) {
        return _dict[_dict.allKeys[selectMenuView.selectIndexArr[section-1].integerValue]].count;
    }
    
    return 10;
}

- (NSString *)selectMenuView:(WWSelectMenuView *)selectMenuView section:(NSInteger)section row:(NSInteger)row
{
    if (section == 0) {
        return _dict.allKeys[row];
    }
    else {
        return _dict[_dict.allKeys[selectMenuView.selectIndexArr[section-1].integerValue]][row];
    }
    return [NSString stringWithFormat:@"%ld-%ld", section, row];
}

- (void)selectMenuView:(WWSelectMenuView *)selectMenuView section:(NSInteger)section didSelect:(NSInteger)row
{
}

- (void)selectMenuView:(WWSelectMenuView *)selectMenuView finish:(NSArray<NSNumber *> *)selectIndexs
{
    NSLog(@"%@",selectIndexs);
}

- (void)selectMenuViewWithCancel:(WWSelectMenuView *)selectMenuView
{
    NSLog(@"取消");
}

@end
