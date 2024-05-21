import { BaseListViewModel } from '@ohos/component/Index'
import { ArrayList } from '@kit.ArkTS'

export class ListViewModel extends BaseListViewModel {
  ListViewModel() {
    super.constructor()
    this.dataList.add("1")
    this.dataList.add("2")
    this.dataList.add("3")
    this.dataList.add("4")
  }

  loadData(isLoading: boolean): Promise<ArrayList<Object>> {
    return new Promise((resolve,reject)=> {
      this.dataList.add("ceshi45")
      this.dataList.add("ceshi332")
      resolve(this.dataList)
    });
  }
}