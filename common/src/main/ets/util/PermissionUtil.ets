import { abilityAccessCtrl, bundleManager, common, Context, Permissions, Want } from '@kit.AbilityKit';

/**
 * 权限控制方法集合
 */
export class PermissionUtil {

  private constructor() {}

  /**
   * 请求权限
   * @param permissions 权限列表
   * @returns 返回true,所有权限都已被通过，reject返回未被允许的权限
   */
  static async requestPermission(permissions: Array<Permissions>){
    let atManager = abilityAccessCtrl.createAtManager()
    let requestResult = await atManager.requestPermissionsFromUser(getContext(),permissions)
    let grantStatus: Array<number> = requestResult.authResults
    let grantPermissions: Array<string> = requestResult.permissions
    let isAllGrant = true;
    for(let i = 0; i<grantStatus.length; i++) {
      if (grantStatus[i] !== 0) {
        isAllGrant = false
        break
      }
    }
    if (isAllGrant) {
      return Promise.resolve(true)
    }
    let forbidPermission = Array<Permissions>()
    if (permissions.length != grantPermissions.length) {
      for (let i = 0; i < permissions.length; i++) {
        if (grantPermissions.indexOf(permissions[i]) < 0) {
          forbidPermission.push(permissions[i])
        }
      }
    }
    return Promise.reject(forbidPermission)
  }

  /**
   * 检查单个获取权限状态
   * @param permission 权限对象
   * @returns 权限授权状态
   */
  static async checkPermission(permission: Permissions): Promise<Boolean> {
    let atManager = abilityAccessCtrl.createAtManager()
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED
    let tokenID: number = -1
    try {
      let bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      tokenID = bundleInfo.appInfo.accessTokenId
      grantStatus = await atManager.checkAccessToken(tokenID,permission)
    } catch (err) {
      console.log(`获取accessTokenId失败-${err}`);
    }
    return grantStatus == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
  }

  /**
   * 检查多个权限是否被授权
   * @param permissions 权限列表
   * @returns true所有权限被授权、false部分授权
   */
  static async checkPermissions(permissions: Array<Permissions>): Promise<Boolean> {
    for(let i = 0; i<permissions.length; i++) {
      let isGrant = await PermissionUtil.checkPermission(permissions[i])
      if (!isGrant) {
        return false
      }
    }
    return true
  }

  /**
   * 打开应用权限设置页面
   * @param context
   */
  static openPermissionSettings(context: Context) {
    let params: Record<string, Object> = {
      "settingsParamBundleName": `${context.applicationInfo.name}`
    }
    let  wantInfo:Want = {
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: 'application_info_entry',
      parameters: params
    }
    let abilityContext = getContext() as common.UIAbilityContext
    abilityContext.startAbility(wantInfo).then(() => {
      console.log(`open-${context.applicationInfo.name}-setting`)
    }).catch((err:object|null) => {
      console.log(err?.toString())
    })
  }
}
