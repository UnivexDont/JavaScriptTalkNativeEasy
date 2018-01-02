//
//  JSTNEViewController.m
//  JavaScriptTalkNativeEasy
//
//  Created by JMan on 02/01/2018.
//  Copyright © 2018 Donter. All rights reserved.
//

#import "JSTNEViewController.h"
#import "JSTNEUIWebViewController.h"
#import "JSTNEWKWebViewController.h"
@interface JSTNEViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation JSTNEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifer = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifer];

    }
    cell.textLabel.text = indexPath.row?@"WKWebView":@"UIWebView";
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        JSTNEWKWebViewController *wkVC = [[JSTNEWKWebViewController alloc] init];
        [self.navigationController pushViewController:wkVC animated:YES];
    }else{
        JSTNEUIWebViewController *uiVC = [[JSTNEUIWebViewController alloc] init];
        [self.navigationController pushViewController:uiVC animated:YES];
    }
}

@end
