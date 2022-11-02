//
//  ViewController.m
//  SensorData
//
//  Created by Apple on 11/2/22.
//

#import "ViewController.h"

static NSString *cellId = @"cellID";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.redColor;
    
    // testUIClick
//    [self __testUIClick];
    
    // testGesture
//    [self __testGesture];
    
    // testList
    [self __testList];
}

#pragma mark - UI
- (void)__testUIClick {

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(__btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
    sw.on = false;
    [sw addTarget:self action:@selector(__swChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sw];
}

- (void)__btnClick {
    
    NSLog(@"original:__btnClick");
}

- (void)__swChange:(UISwitch *)sw {
    
    NSLog(@"original:__swChange");
}

#pragma makr - Gesture
- (void)__testGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__tapGestureAction:)];
    [self.view addGestureRecognizer:tap];
    
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__longGestureAction:)];
    longGes.minimumPressDuration = 1.0;
    [self.view addGestureRecognizer:longGes];
}



- (void)__tapGestureAction:(UIGestureRecognizer *)rec {
    NSLog(@"original:__tapGestureAction");
}


- (void)__longGestureAction:(UIGestureRecognizer *)ges {
    NSLog(@"original:__longGestureAction");
}


#pragma makr - list
- (void)__testList {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self __testListData];
}

- (void)__testListData {
    self.dataSource = [NSMutableArray array];
    for (int i = 0; i<10; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"num%d",i]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"detail:%@", self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"original:didSelectRowAtIndexPath");
}

@end
