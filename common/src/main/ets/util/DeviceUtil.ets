import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

/**
 * 设备相关的操作方法集合
 * 设置底部绘制延伸到导航条
 * .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
 */
export class DeviceUtil {

  /**
   * 获取返回时上一个window对象，用于页面切换时aboutToAppear中切换页面状态
   * @param context 页面对象
   * @returns 窗口对象
   */
  static async getLastWindow(context:Context):Promise<window.Window>{
    let cxt = context as common.UIAbilityContext
    return window.getLastWindow(cxt)
  }


  /**
   * 设置穿透状态栏,就是设置页面全屏
   * @param windowStage 窗口参数
   */
  static async setTranslucentWindow(windowStage:window.WindowStage){
    windowStage.getMainWindow((err,windowClass) => {
      if (err.code) {
        console.log(err.message)
        return
      }
      windowClass.setWindowLayoutFullScreen(true)
    })
  }

  /**
   * 设置当前窗口的颜色
   * @param windowStage  窗口参数
   * @param color 颜色
   */
  static async setWindowBackgroundColor(windowStage:window.WindowStage,color:string){
    windowStage.getMainWindow((err,windowClass) => {
      if (err.code) {
        console.log(err.message)
        return
      }
      windowClass.setWindowBackgroundColor(color)
    })
  }

  /**
   * 设置状态栏和导航栏可通过手势触摸出现
   * @param windowStage 窗口参数
   */
  static async setSpecificSystemBar(windowStage:window.WindowStage){
    windowStage.getMainWindow((err,windowClass) => {
      if (err.code) {
        console.log(err.message)
        return
      }
      windowClass.setWindowLayoutFullScreen(true)
      if (canIUse('SystemCapability.Window.SessionManager')) {
        windowClass.setSpecificSystemBarEnabled('status',false)
        windowClass.setSpecificSystemBarEnabled('navigation',false)
      }
    })
  }

  /**
   * 获取顶部状态栏高度
   * @param windowStage 窗口对象
   * @returns 返回状态栏高度单位像素px
   */
  static async getStatusBarHeight(windowStage:window.WindowStage):Promise<number>{
    return new Promise((resolve,reject)=> {
      windowStage.getMainWindow((err,windowClass) => {
        if (err.code) {
          console.log(err.message)
          reject(err)
          return
        }
        let avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        let statusBarHeight = avoidArea.topRect.height
        AppStorage.setOrCreate('statusBarHeight', statusBarHeight);
        resolve(statusBarHeight)
      })
    })
  }

  /**
   * 获取底部导航栏高度
   * @param windowStage 窗口对象
   * @returns 返回状态栏高度单位像素px
   */
  static async getNavigatorBarHeight(windowStage:window.WindowStage):Promise<number>{
    return new Promise((resolve,reject)=> {
      windowStage.getMainWindow((err,windowClass) => {
        if (err.code) {
          console.log(err.message)
          reject(err)
          return
        }
        let avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        let navigatorBarHeight = avoidArea.bottomRect.height
        AppStorage.setOrCreate('navigatorBarHeight', navigatorBarHeight);
        resolve(navigatorBarHeight)
      })
    })
  }

}