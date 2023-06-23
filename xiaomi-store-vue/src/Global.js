// import OSS from 'ali-oss';

// const OSSClient = new OSS({
//   region: 'oss-cn-beijing',
//   accessKeyId: 'LTAI5tSRKT3N7cV8tDhCP3MF',
//   accessKeySecret: 'l50Ksr6ySHKox4bTDJPOmKxngjervj',
//   bucket: 'web-framework023',
//   secure: true // 为 true 时使用 HTTPS 协议，更加安全
// });
// https://web-framework023.oss-cn-beijing.aliyuncs.com/



exports.install = function (Vue) {
  Vue.prototype.$target = "http://101.132.181.9:3000/"; // 线上后端地址
  // Vue.prototype.$target = "http://localhost:3000/"; // 本地后端地址
  // 封装提示成功的弹出框
  Vue.prototype.notifySucceed = function (msg) {
    this.$notify({
      title: "成功",
      message: msg,
      type: "success",
      offset: 100
    });
  };
  // 封装提示失败的弹出框
  Vue.prototype.notifyError = function (msg) {
    this.$notify.error({
      title: "错误",
      message: msg,
      offset: 100
    });
  };
}