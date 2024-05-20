import { geoLocationManager } from '@kit.LocationKit';
import { PermissionUtil } from './PermissionUtil';

/**
 *
 */
export class LocationUtil{

  private constructor() {}

  /**
   * 判断当前定位是否开启可用并且已经拥有对应的权限
   * @returns true 开启并可用、false未开启
   */
  static async isLocationEnable() {
    let permissionEnable = await PermissionUtil.checkPermissions(['ohos.permission.LOCATION','ohos.permission.APPROXIMATELY_LOCATION'])
    return permissionEnable && geoLocationManager.isLocationEnabled() && geoLocationManager.isGeocoderAvailable()
  }

  /**
   * 获取当前地理位置，需要获取权限
   * @returns 地理位置信息
   */
  static async getCurrentLocation(): Promise<geoLocationManager.Location> {
    try {
      let requestInfo: geoLocationManager.CurrentLocationRequest = {'priority': geoLocationManager.LocationRequestPriority.ACCURACY,
        'scenario': geoLocationManager.LocationRequestScenario.UNSET,'maxAccuracy': 0,'timeoutMs': 5000};
      let location = await geoLocationManager.getCurrentLocation(requestInfo)
      return Promise.resolve(location)
    } catch (err) {
      console.log(err)
      return Promise.reject(err)
    }
  }

  /**
   * 根据坐标转化为地理描述，默认获取当前默认定位地址
   * @param location 获取对应的坐标对应的地址
   * @returns 返回坐标对应的地址
   */
  static async getLocationAddress(location ?:geoLocationManager.Location):Promise<Array<geoLocationManager.GeoAddress>> {
    let loc = location
    if (location == null) {
      loc = await LocationUtil.getCurrentLocation()
    }
    let latitude = loc?.latitude??32
    let longitude = loc?.longitude??118
    let maxItems = 1
    let reverseGeocodeReq: geoLocationManager.ReverseGeoCodeRequest = {
      'latitude': latitude,
      'longitude': longitude,
      'maxItems': maxItems
    }
    return geoLocationManager.getAddressesFromLocation(reverseGeocodeReq)
  }


}