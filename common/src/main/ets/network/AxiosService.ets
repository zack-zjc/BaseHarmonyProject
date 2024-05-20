import axios, { AxiosError, AxiosRequestHeaders, AxiosResponse,
  FormData,
  InternalAxiosRequestConfig } from "@ohos/axios"
import fs from '@ohos.file.fs';
import { JsonUtil } from '../util/CommonUtil';

/**
 * 获取一个初始化的请求对象
 * @returns axios对象实例
 */
export function getAxiosClient(){
  let instance = axios.create({
    baseURL: 'https://w.cekid.com/',
    timeout: 5000,
    headers: {
      'Content-Type': 'application/json'
    } as AxiosRequestHeaders,
  });
  //请求拦截器
  instance.interceptors.request.use((config:InternalAxiosRequestConfig)=> {
    return config
  }, (error:AxiosError) => {
    console.log(error.message);
    return Promise.reject(error);
  })
  //请求返回拦截器
  instance.interceptors.response.use((response:AxiosResponse)=> {
    return response;
  }, (error:AxiosError)=> {
    console.log(error.message);
    return Promise.reject(error);
  })
  return instance
}

//axios单例对象
let axiosClient = getAxiosClient()

export class AxiosService {

  /**
   * 类型参数的作用，T决定AxiosResponse实例中data的类型
   * @param config 请求配置
   * @returns 返回请求对象
   */
  private static async request<R,T>(config: InternalAxiosRequestConfig): Promise<T> {
    return new Promise<T>((resolve, reject) => {
      axiosClient
        .request<R,T>(config)
        .then(res => {
          resolve(res)
        }).catch((err:AxiosError) => {
          console.log(err.message)
          reject(err)
        });
    });
  }

  /**
   * 通用返回string类型的请求
   * @param config 请求配置
   * @returns 返回序列化后的对象
   */
  static async stringRequest<R>(config: InternalAxiosRequestConfig): Promise<R> {
    return new Promise((resolve,reject)=>{
      AxiosService.request<R,string>(config).then(responseStr => {
        resolve(JsonUtil.parse<R>(responseStr))
      }).catch((err:AxiosError) => {
        reject(err)
      })
    })
  }

  /**
   * 普通网络请求
   * @param config 请求配置
   * @returns 返回序列化后的对象
   */
  static async get<R>(config: InternalAxiosRequestConfig): Promise<R> {
    return new Promise((resolve,reject)=>{
      config.method = 'GET'
      AxiosService.stringRequest<R>(config).then(response => {
        resolve(response)
      }).catch((err:AxiosError) => {
        reject(err)
      })
    })
  }

  /**
   * 普通网络请求
   * @param config 请求配置
   * @returns 返回序列化后的对象
   */
  static async postJson<R>(config: InternalAxiosRequestConfig): Promise<R> {
    return new Promise((resolve,reject)=>{
      config.method = 'POST'
      AxiosService.stringRequest<R>(config).then(response => {
        resolve(response)
      }).catch((err:AxiosError) => {
        reject(err)
      })
    })
  }

  /**
   * 普通网络请求
   * @param config 请求配置
   * @returns 返回序列化后的对象
   */
  static async postForm<R>(config: InternalAxiosRequestConfig): Promise<R> {
    return new Promise((resolve,reject)=>{
      config.method = 'POST'
      config.headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
      } as AxiosRequestHeaders
      AxiosService.stringRequest<R>(config).then(response => {
        resolve(response)
      }).catch((err:AxiosError) => {
        reject(err)
      })
    })
  }

  /**
   * 上传文件
   * @param config 请求配置
   * @returns 返回序列化后的对象
   */
  static async uploadFile<R>(filePath:string,config: InternalAxiosRequestConfig): Promise<R> {
    return new Promise((resolve,reject)=>{
      let formData = new FormData()
      let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
      let stat = fs.lstatSync(filePath);
      let buffer = new ArrayBuffer(stat.size);
      // 以同步方法从流文件读取数据。
      fs.readSync(file.fd, buffer);
      fs.fsyncSync(file.fd);
      fs.closeSync(file.fd);
      formData.append('file', buffer);
      config.data = formData
      config.method = 'POST'
      config.headers = {
        'Content-Type': 'multipart/form-data'
      } as AxiosRequestHeaders
      axiosClient
        .request<string,string,FormData>(config)
        .then(responseStr => {
          resolve(JsonUtil.parse<R>(responseStr))
        }).catch((err:AxiosError) => {
        console.log(err.message)
        reject(err)
      });
    })
  }

}


