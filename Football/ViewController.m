//
//  ViewController.m
//  Football
//
//  Created by ucan on 15/12/28.
//  Copyright © 2015年 ucan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>{
    UITapGestureRecognizer *_tapResign;
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic)CGFloat value_0;
@property (nonatomic)CGFloat value_1;
@property (nonatomic)CGFloat value_2;
@property (nonatomic)CGFloat value_3;
@property (nonatomic)CGFloat value_4;
@property (nonatomic)CGFloat value_5;
@property (nonatomic)CGFloat value_6;
@property (nonatomic)CGFloat value_7;
@property (nonatomic)CGFloat value_8;
@property (nonatomic)CGFloat value_9;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _num_TF.delegate = self;
    _dataArray = [[NSMutableArray alloc]initWithArray:[self getTheResult]];
    
    _tapResign = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarddidShow) name:UIKeyboardDidShowNotification object:nil];
    
//    [self showAllResult];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- 获取整体数据
- (NSArray *)getTheResult{
    
    NSString *schoolsPath = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"txt"];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:schoolsPath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"___:%@",content);
    NSArray *contentArray = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger j = 0; j < contentArray.count; j++){
        NSString *oneStr = [contentArray objectAtIndex:j];
        NSArray *oneArray = [oneStr componentsSeparatedByString:@"\t"];
        
        NSMutableArray *resultArr = [[NSMutableArray alloc]init];
        
        for (NSInteger i = 0; i < oneArray.count; i++) {
            
            CGFloat value = [[oneArray objectAtIndex:i]floatValue];
            if (i>2 && i<7) {
                value = value/100;
            }
            NSString *valueStr = [NSString stringWithFormat:@"%.4f",value];
            
            [resultArr addObject:valueStr];
        }
        
        [resultsArray addObject:resultArr];
        
    }
    
//    NSLog(@"****:%@",resultsArray);
    
    
    return resultsArray;
    
    
    
}

#pragma mark- 按组中的第几个数排序
- (NSArray *)sortArray:(NSArray *)array number:(NSInteger)num{
    
    NSArray *resultArray =[array sortedArrayUsingComparator:^NSComparisonResult(NSArray *array1, NSArray *array2){
        NSComparisonResult result = [[array1 objectAtIndex:num] compare:[array2 objectAtIndex:num]];
        
        return result;
        
    }];
    
    
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:resultArray];
    
//    NSLog(@"sort:%@",_dataArray);
    return _dataArray;
    
}

#pragma mark- 获取单场数据 num要和依照排序的数字对应

- (NSArray *)getOneKindValue:(NSArray *)array number:(NSInteger)num{
    if (array.count > 0 ) {
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        
        for (NSInteger i=0; i<array.count; i++) {
           
            NSArray *oneArray = [array objectAtIndex:i];
            
            [resultArray addObject:[oneArray objectAtIndex:num]];
            
        }
       
        return resultArray;
    }else{
        
        return nil;
    }
    
}


/*
#pragma mark- 数据排序
- (NSArray *)sortTheArray:(NSArray *)array{
    
    NSArray *resultArray =[array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        
        return result;
        
    }];

    NSLog(@"sort:%@",resultArray);
    
    return resultArray;
    
}*/

#pragma mark- 生成二维散点

- (NSMutableArray *)generateTwoDimensionalData:(NSArray *)array{
    if (array.count>0) {
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        for (NSInteger i=0; i<array.count; i++) {
            
            NSMutableArray *oneArray = [[NSMutableArray alloc]init];
            CGFloat oneValue = [[array objectAtIndex:i]floatValue];
            [oneArray addObject:@(i)];
            [oneArray addObject:@(oneValue)];
            
            [resultArray addObject:oneArray];
            
        }
        return resultArray;
    }else{
        return nil;
    }
}


#pragma mark- 数据整合得出结果
- (NSMutableArray *)getLinearEquation:(NSMutableArray *)array{
    if (array.count>0) {
        NSInteger num = array.count;//总个数
        CGFloat plus_xy = 0;
        CGFloat plus_x = 0;
        CGFloat plus_y = 0;
        CGFloat plus_xx = 0;
        CGFloat plus_yy = 0;
        for (NSInteger i=0; i<array.count; i++) {
            NSArray *oneArray = [array objectAtIndex:i];
            CGFloat x = [[oneArray objectAtIndex:0]floatValue];
            CGFloat y = [[oneArray objectAtIndex:1]floatValue];
            plus_x += x;
            plus_y += y;
            plus_xx += x*x;
            plus_xy += x*y;
            plus_yy += y*y;
            
        }
        
        CGFloat k = (num*plus_xy - plus_x*plus_y)/(num*plus_xx - plus_x*plus_x);
        CGFloat b = (plus_y - k*plus_x)/num;
        CGFloat rr = (plus_xy - plus_x*plus_y/num)*(plus_xy - plus_x*plus_y/num)/((plus_xx-plus_x*plus_x/num)*(plus_yy-plus_y*plus_y/num));
        CGFloat x_ = plus_x/num;
        CGFloat y_ = plus_y/num;
        CGFloat y = k*x_+b;
        
        NSString *result = [NSString stringWithFormat:@"y=%fx+%f  y=%f y_=%f  R^2=%f",k,b,y,y_,rr];
        NSLog(@"%@",result);
        
        
        CGFloat value_rr = 0;
        for (NSInteger j=0; j<array.count; j++) {
            NSArray *oneArray = [array objectAtIndex:j];
            CGFloat x = [[oneArray objectAtIndex:0]floatValue];
            CGFloat y = [[oneArray objectAtIndex:1]floatValue];
            value_rr = fabs(k*x+b-y)/(k*x+b);
            if (value_rr>[_num_TF.text floatValue]/100) {
                
                [array removeObjectAtIndex:j];
                [_dataArray removeObjectAtIndex:j];
                
                NSLog(@"差距百分比大于0.05 输出：%li ___:%f",(long)j,value_rr);
            }
            
        }
        
        NSMutableArray *resArray = [[NSMutableArray alloc]initWithCapacity:0];
        [resArray addObject:@(y_)];
        [resArray addObject:@(rr)];
        
        
        
        return resArray;
    }else{
        return nil;
    }
}

- (void)showAllResult{
    
    NSString *result = @"";
    
    for (NSInteger i=0; i<10; i++) {
        
        
        
        [self sortArray:_dataArray number:i];//排序
        
        NSLog(@"&&&&&&&&&&&:%li",_dataArray.count);
        
        NSArray *oneArray = [self getOneKindValue:_dataArray number:i];//获取单组数据
        
        NSMutableArray *twoDim = [self generateTwoDimensionalData:oneArray];//生成二维散点
        
        NSMutableArray *resArray = [[NSMutableArray alloc]init];
        [resArray addObjectsFromArray:[self getLinearEquation:twoDim]];
        
        NSString *oneResult = [NSString stringWithFormat:@"y_=%f  r^2=%f",[[resArray objectAtIndex:0]floatValue],[[resArray objectAtIndex:1]floatValue]];//得到趋势线方程均值方差
        NSString *one_res = [oneResult stringByAppendingString:@"\n\n"];
        result = [result stringByAppendingString:one_res];
        
        switch (i) {
            case 0:
            {
                _value_0 = [[resArray objectAtIndex:0] floatValue];
            }
                break;
                
            case 1:
            {
                _value_1 = [[resArray objectAtIndex:0] floatValue];
            }
                break;
                
            case 2:
            {
                _value_2 = [[resArray objectAtIndex:0] floatValue];
            }
                break;
                
            case 3:
            {
                _value_3 = [[resArray objectAtIndex:0] floatValue];
            }
                break;
                
            case 4:
            {
                _value_4 = [[resArray objectAtIndex:0] floatValue];
            }
                break;
                
            case 5:
            {
                _value_5 = [[resArray objectAtIndex:0] floatValue];
            }
                break;
                
            case 6:
            {
                _value_6 = [[resArray objectAtIndex:0] floatValue];
            }
                break;
                
            case 7:
            {
                _value_7 = [[resArray objectAtIndex:0] floatValue];
            }
                break;
                
            case 8:
            {
                _value_8 = [[resArray objectAtIndex:0] floatValue];
            }
                break;
                
            case 9:
            {
                _value_9 = [[resArray objectAtIndex:0] floatValue];
            }
                break;
                
            default:
                break;
        }
    }
    
    _resultLabel.text = result;
}
- (IBAction)buttonAction:(id)sender {
    
    [_num_TF resignFirstResponder];
    NSLog(@"数组个数：%li",_dataArray.count);
    
    
    if ([_num_TF.text length] == 0) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"请输入剔除离散百分比" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
    }else{
        
        [self showAllResult];
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}



-(void)keyboarddidShow
{
    [self.view addGestureRecognizer:_tapResign];
    
    
}
-(void)hideKeyboard
{
    [self.view endEditing:YES];
    
    [self.view removeGestureRecognizer:_tapResign];
    
}

- (IBAction)showResultAction:(id)sender {
    
    _resultLabel.text = [NSString stringWithFormat:@"%f  %f  %f\n\n%f  %f  %f\n\n%f  %f  %f",_value_7,_value_8,_value_9,_value_0*_value_3,_value_1*_value_4,_value_2*_value_5,(_value_7-_value_0*_value_3)/(_value_0*_value_3),(_value_8-_value_1*_value_4)/(_value_1*_value_4),(_value_9-_value_2*_value_5)/(_value_2*_value_5)];
}
@end
