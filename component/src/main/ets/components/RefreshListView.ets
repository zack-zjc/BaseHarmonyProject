import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh'
import { BaseListViewModel } from '../viewmodel/BaseViewModel';

/**
 * 可下拉刷新的组件
 */
@Component
export struct RefreshListView {

  //列表ViewModel
  listViewModel ?:BaseListViewModel;
  //滑动控制器
  scroller: Scroller = new Scroller();
  //刷新配置
  configure: PullToRefreshConfigurator = new PullToRefreshConfigurator();
  //数据对象
  @State data: Array<Object> = this.listViewModel?.dataList?.convertToArray()??[];
  //是否可以下拉刷新
  @State enableRefresh:boolean = true;
  //是否可以上拉加载
  @State enableLoadMore:boolean = true;
  //主体列表组件
  @BuilderParam contentList ?:(dataList:Array<Object>)=>void;
  //主体列表组件
  @BuilderParam customLoad ?: (() => void) | null;
  //主体列表组件
  @BuilderParam customRefresh ?: (() => void) | null;

  build() {
    PullToRefresh({
      refreshConfigurator:this.configure.setHasRefresh(this.enableRefresh).setHasLoadMore(this.enableLoadMore),
      data: this.data,
      scroller: this.scroller,
      customList: () => {
        this.contentList?.(this.data?? [])
      },
      onRefresh: () => {
        return new Promise<string>((resolve, reject) => {
          this.listViewModel?.onRefresh().then((dataList) => {
            this.data = dataList.convertToArray();
            resolve('刷新成功');
          }).catch((err:object|null) => {
            reject('刷新失败');
          });
        });
      },
      onLoadMore: () => {
        return new Promise<string>((resolve, reject) => {
          this.listViewModel?.onLoading().then((dataList) => {
            this.data = dataList.convertToArray();
            resolve('');
          }).catch((err:object|null) => {
            reject('加载失败');
          });
        });
      },
      customLoad: this.customLoad,
      customRefresh: this.customRefresh,
    })
  }

}