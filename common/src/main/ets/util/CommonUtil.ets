import { promptAction } from '@kit.ArkUI';

/**
 * 序列化类收敛入口方便后续可统一替换序列化方案
 */
export class JsonUtil {

  private constructor() {}

  static stringify<T>(data: T, space: number = 2): string {
    return JSON.stringify(data, null, space);
  }

  static parse<T>(jsonString: string): T {
    return JSON.parse(jsonString) as T;
  }

}


/**
 * 展示toast操作
 * @param message 对应的内容
 * @param duration 展示时长
 */
export function showToast(message: string, duration: number = 2000) {
  try {
    promptAction.showToast({ message: message, duration: duration, bottom: "center"})
  } catch (error) {
    console.error(`taost error code is ${error.code}`);
  }
}