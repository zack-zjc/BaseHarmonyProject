import { ArrayList } from '@kit.ArkTS';

export interface  BaseViewModel {

}

/**
 * 基础页面的viewModel
 */
export class BasePageViewModel implements BaseViewModel {

  /**
   * 展示页面loading弹框
   */
  async showLoading() {

  }

  /**
   * 隐藏页面弹框
   */
  async hideLoading(){

  }

}

/**
 * 列表对应的viewModel
 */
export abstract class BaseListViewModel implements  BaseViewModel {
  BaseListViewModel() {

  }

  dataList :ArrayList<Object> = new ArrayList<Object>()

  /**
   * 加载数据的通用方法
   * @param isLoading 是否上拉加载
   * @returns
   */
  abstract loadData(isLoading:boolean):Promise<ArrayList<Object>>

  /**
   * 下拉刷新
   * @returns 数据集合
   */
  onRefresh():Promise<ArrayList<Object>>{
    return new Promise((resolve,reject) => {
      this.loadData(false).then((dataList) => {
        this.dataList.clear();
        dataList.forEach((element) => {
          this.dataList.add(element);
        })
        resolve(this.dataList)
      }).catch((err:object|null) => {
        reject(err)
      })
    })
  }

  /**
   * 上拉加载
   * @returns 数据集合
   */
  onLoading():Promise<ArrayList<Object>>{
    return new Promise((resolve,reject) => {
      this.loadData(true).then((dataList) => {
        dataList.forEach((element) => {
          this.dataList.add(element);
        })
        resolve(this.dataList)
      }).catch((err:object|null) => {
        reject(err)
      })
    })
  }

}

//导出通用的页面ViewModel
let commonPageViewModel = new BasePageViewModel();
export default commonPageViewModel;
