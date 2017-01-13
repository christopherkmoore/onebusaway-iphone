//
//  OBAPickerController.m
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 1/12/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

#import "OBAPickerController.h"
@import Masonry;

@interface OBAPickerController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong) UIToolbar *topToolbar;
@property(nonatomic,strong) UIPickerView *pickerView;
@end

@implementation OBAPickerController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];

    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];

    self.topToolbar = [[UIToolbar alloc] initWithFrame:<#(CGRect)#>]
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 20;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@ minutes", @(row)];
}

@end
