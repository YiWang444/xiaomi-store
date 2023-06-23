

# 项目说明



##  自己替换代码

### 前端

````
在 /xiaomi-store-vue/src/views/PersonalSpace.vue 的第402行

// 阿里云OSS的相关配置
this.OSSClient = new OSS({
    region: '',
    accessKeyId: '',
    accessKeySecret: '',
    bucket: ''
});
````

### 后端

````c++
在 xiaomi-store/src/main/java/com/example/shopping_system/service/UserService.java 的第 112行 和 115行

112: user.setUserImg("你的阿里云OSS前缀.aliyuncs.com/".concat(fileName));
115: return Result.success("你的阿里云OSS前缀.aliyuncs.com/".concat(fileName), "更新用户头像成功");
````

````yml
在 xiaomi-store/src/main/resources/application.yml 更改数据库用户和密码
server:
  port: 18888
spring:
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    url: jdbc:mysql://localhost:3306/storeDB?characterEncoding=UTF8&useSSL=false
    username: '数据库用户名'
    password: '数据库密码'
#配置日志  log-impl:日志实现
mybatis-plus:
    configuration:
      log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
logging:
  level:
    com.example.mapper: DEBUG #指定 mapper 包的日志级别为 debug
````



## 一些说明

### -1. 请先执行 sql语句，create_table.sql文件

### 0. 阿里云OSS的配置说明

​	**如果不会阿里云OSS的配置，将上述图片路径配置改为本地即可**

````
默认情况下，项目中的所有图片都不能显示，以为图片路径不对，自己调整一下就行

我在阿里云OSS建了 store_system/user/ ，如果要保持一致可以先建 store_system 文件夹，再建 user 文件夹
````

### 1. **本文全部用Post请求**

````
restful风格的五种种请求方式，可以根据需求改写

get：多用来获取数据
post：多用来新增数据
put：多用来修改数据（需要传递所有字段，相当于全部更新）
patch：多用来修改数据，是在put的基础上新增改进的，适用于局部更新，比如我只想修改用户名，只传用户名的字段就ok了，而不需要像put一样把所有字段传过去
delete：多用来删除数据
````

### 2. 数据库额外加了四个字段

````
deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
version INT(11) NOT NULL DEFAULT 1 COMMENT '乐观锁版本号',
create_time datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
update_time datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间'
````

### 3. 使用了统一响应体（Result类）

````
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Result {
    private String code;//响应码
    private String msg;  //响应信息 描述字符串
    private Object data; //返回的数据

    //增删改 成功响应
    public static Result success(){
        return new Result("001","success",null);
    }
    //查询 成功响应
    public static Result success(Object data, String msg){
        return new Result("001", msg,data);
    }
    //失败响应
    public static Result error(String code, String msg){
        return new Result(code, msg,null);
    }
}
````

### 4. 有问题可以在 Issues里留言，看到第一时间回复

### 5. 前端跳转有点问题（多刷新就行），不过最好把前端重塑一下



## 一、用户模块

### 1.1 登录

**请求URL：**

```
/users/login
```

**请求方式：**

```
Post
```

**发送示例**

````json
{
    "userName": "zhangsan",
    "password": "a123456"
}
````

**参数说明：**

| 参数 | 是否必选 | 类型 | 说明 |
| :-: | :-: | :-: | :-: |
| userName | 是 | string | 用户名 |
|  password  | 是 | string | 密码 |

**返回示例：**

```javascript
{
  "code": "001",
    "user": {
    "user_id": 1,
    "userName": "admin"
  },
  "msg": "登录成功"
}

{'code': '004', 'msg': '用户名或密码错误'}
```



### 1.2 查找用户名是否存在

**请求URL：**

```
/users/findUserName
```

**请求方式：**

```
Post
```

**发送示例**

````json
{
    "userName": "zhangsan"
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| userName |    是    | string | 用户名 |

**返回示例：**

```javascript
{
  "code": "001",
  "msg": "用户名不存在，可以注册"
}

{'code': "004", 'msg': '用户名已经存在，不能注册'}
```



### 1.3 注册

**请求URL：**

```
/users/register
```

**请求方式：**

```
Post
```

**发送示例**

````
{
    "userName": "zhangsan",
    "password": "a123456"
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| userName |    是    | string | 用户名 |
| password |    是    | string |  密码  |

**返回示例：**

```javascript
{
  code: '001',
  msg: '注册成功'
}

{'code': "004", 'msg': '用户名已经存在，不能注册'}
```



### 1.4 判断用户信息正确（更新用户信息前置工作）

**请求URL：**

```
/users/checkField
```

**请求方式：**

```
Post
```

**发送示例**

````
{
    "userId": 1,
    "field": "name",
    "value": "张三"
}

{
    "userId": 1,
    "field": "password",
    "value": "asd666"
}

{
    "userId": 1,
    "field": "telephone",
    "value": "13832955555"
}
````

**参数说明：**

|  参数  | 是否必选 |  类型  |   说明   |
| :----: | :------: | :----: | :------: |
| userId |    是    |  Int   |  用户名  |
| field  |    是    | string |   密码   |
| value  |    是    | string | 电话号码 |

**返回示例：**

```javascript
{ code: '001', msg: '检测通过' }

{ code: '002', msg: '旧密码错误，请重新输入' }

{ code: '003', msg: '手机号码错误，不要更改默认选项' }

{ code: '004', msg: '用户不存在' }
```



### 1.5 更新用户信息（根据字段）

**请求URL：**

```
/users/updateField
```

**请求方式：**

```
Post
```

**发送示例**

````
{
    "userId": 1,
    "field": "name",
    "value": "张三"
}

{
    "userId": 1,
    "field": "password",
    "value": "asd666"
}

{
    "userId": 1,
    "field": "telephone",
    "value": "13832955555"
}
````

**参数说明：**

|  参数  | 是否必选 |  类型  |   说明   |
| :----: | :------: | :----: | :------: |
| userId |    是    |  Int   |  用户名  |
| field  |    是    | string |   密码   |
| value  |    是    | string | 电话号码 |

**返回示例：**

```javascript
{ code: '001', msg: '更改成功' }

{ code: '002', msg: '用户已存在，更改姓名失败' }

{ code: '003', msg: '密码不能相同，更改密码失败' }

{ code: '004', msg: '电话失败不能相同，更改电话号码失败' }
```



### 1.6 保存用户头像

**请求URL：**

```
/users/saveUserImg
```

**请求方式：**

```
Post
```

**发送示例**

````
{
    "userId": 1,
    "fileName": "store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg" // 后端拼接阿里云OSS的前缀, MD5加密文件名
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |    说明    |
| :------: | :------: | :----: | :--------: |
|  userId  |    是    | string |   用户名   |
| fileName |    是    | string | 头像文件名 |

**返回示例：**

```javascript
{
  code: "001"
  data: "https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg"  // 将拼接好的文件名返回
  msg: "更新用户头像成功"
}
```





## 二、购物车模块

### 2.1 获取购物车信息

**请求URL：**

```
/user/shoppingCart/getShoppingCart/
```

**请求方式：**

```
Post
```

**发送示例**

````
{
    "userId": 1
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| userId |    是    | int | 用户id |

**返回示例：**

```javascript
{
    "code": "001",
    "msg": "购物车不为空",
    "data": [
        {
            "id": 16,
            "productId": 1,
            "productName": "Redmi K30",
            "productImg": "https://${path}/store_system/product/Redmi-k30.png",
            "price": 1000.0,
            "num": 2,
            "maxNum": 16,
            "checked": false
        }
    ]
}
        
        
可能购物车为空，即返回:
{
	"code": "001",
	"shoppingCartData": []
}
```

### 2.2 添加购物车

**请求URL：**

```
/user/shoppingCart/addShoppingCart
```

**请求方式：**

```
Post
```

**发送示例**

````
{
    "userId": 1,
    "productId": 4
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| userId |    是    | int | 用户id |
| productId |    是    | int |  商品id  |

**返回示例：**

```javascript
{
	"code": "002",
	"msg": "商品已在购物车,数量+1"
}

{
	"code": "003",
	"msg": "商品已达到购物限额"
}

{
    "code": "001",
    "msg": "添加购物车成功!",
    "data": {
        "id": 17,
        "productId": 4,
        "productName": "小米test",
        "productImg": null,
        "price": 1799.0,
        "num": 1,
        "maxNum": 20,
        "checked": false
    }
}
```



### 2.3  删除购物车

**请求URL：**

```
/user/shoppingCart/deleteShoppingCart
```

**请求方式：**

```
Post
```

**发送示例**

````javascript
{
    "userId": 1,
    "productId": 4
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| userId |    是    | int | 用户id |
| productId |    是    | int |  商品id  |

**返回示例：**

```javascript
{
	"code": "001",
	"msg": "删除购物车成功"
}

{
	"code": "002",
	"msg": "该商品不在购物车"
}
```

### 2.4  更新购物车数量

**请求URL：**

```
user/shoppingCart/updateShoppingCart/
```

**请求方式：**

```
Post
```

**发送示例**

````js
{
    "userId": 1,
    "productId": 1,
    "num": 11
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| userId |    是    | int | 用户id |
| productId |    是    | int |  商品id  |
| num |    是    | int |  数量  |
|**返回示例：**||||

```javascript
{"code": "001", "msg": "修改购物车数量成功"}

{'code': '002', 'msg': '该商品不在购物车'}

{'code': '003', 'msg': '数量没有发生变化'}

{"code": "004", "msg": "商品已达到购物限额"}
```

## 三、轮播图模块

### 3.1  轮播图管理

**请求URL：**

```
/resources/carousel/
```

**请求方式：**

```
Post
```

(无参数的post请求，可考虑改为get方式)

**参数说明：**

无参数

**返回示例：**

```javascript
{
    "code": "001",
    "msg": "查询轮播图成功",
    "data": [
        {
            "carouselId": 1,
            "imgPath": "https://${path}/store_system/carousel/cms_1.jpg",
            "describes": null
        },
        {
            "carouselId": 2,
            "imgPath": "https://${path}/store_system/carousel/cms_2.jpg",
            "describes": null
        },
        {
            "carouselId": 3,
            "imgPath": "https://${path}/store_system/carousel/cms_3.jpg",
            "describes": null
        },
        {
            "carouselId": 4,
            "imgPath": "https://${path}/store_system/carousel/cms_4.jpg",
            "describes": null
        }
    ]
}
```

## 四、商品模块

### 4.1  首页展示同一类别前7个商品
注: 可根据需要自定义数量

**请求URL：**

```
/product/getPromoProduct
```

**请求方式：**

```
Post
```

**发送示例**

````js
{
    "categoryId": 1
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| categoryId |    是    | string | 类别名称 |

**返回示例：**

```javascript
{
    "code": "001",
    "msg": "查询成功",
    "data": [
        {
            "productId": 1,
            "productName": "Redmi K30",
            "productTitle": "120Hz流速屏，全速热爱",
            "productIntro": "120Hz高帧率流速屏/ 索尼6400万前后六摄 / 6.67'小孔径全面屏 / 最高可选8GB+256GB大存储 / 高通骁龙730G处理器 / 3D四曲面玻璃机身 / 4500mAh+27W快充 / 多功能NFC",
            "productPrice": 2000.0,
            "productSellingPrice": 1000.0,
            "productNum": 16,
            "productSales": 100,
            "productPicture": "https://${path}/store_system/product/Redmi-k30.png",
            "categoryId": 1
        },
        {
            "productId": 2,
            "productName": "Redmi K30 5G",
            "productTitle": "双模5G,120Hz流速屏",
            "productIntro": "双模5G / 三路并发 / 高通骁龙765G / 7nm 5G低功耗处理器 / 120Hz高帧率流速屏 / 6.67'小孔径全面屏 / 索尼6400万前后六摄 / 最高可选8GB+256GB大存储 / 4500mAh+30W快充 / 3D四曲面玻璃机身 / 多功能NFC",
            "productPrice": 2599.0,
            "productSellingPrice": 1599.0,
            "productNum": -4,
            "productSales": 99,
            "productPicture": "public/imgs/phone/Redmi-k30-5G.png",
            "categoryId": 1
        },
        {
            "productId": 3,
            "productName": "小米CC9 Pro",
            "productTitle": "1亿像素,五摄四闪",
            "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
            "productPrice": 2799.0,
            "productSellingPrice": 1799.0,
            "productNum": 17,
            "productSales": 0,
            "productPicture": "public/imgs/phone/Mi-CC9.png",
            "categoryId": 1
        },
        {
            "productId": 4,
            "productName": "小米test",
            "productTitle": "1亿像素,五摄四闪",
            "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
            "productPrice": 2799.0,
            "productSellingPrice": 1799.0,
            "productNum": 20,
            "productSales": 0,
            "productPicture": null,
            "categoryId": 1
        },
        {
            "productId": 5,
            "productName": "2",
            "productTitle": "1亿像素,五摄四闪",
            "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
            "productPrice": 2799.0,
            "productSellingPrice": 1799.0,
            "productNum": 20,
            "productSales": 0,
            "productPicture": null,
            "categoryId": 1
        },
        {
            "productId": 6,
            "productName": "3",
            "productTitle": "1亿像素,五摄四闪",
            "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
            "productPrice": 2799.0,
            "productSellingPrice": 1799.0,
            "productNum": 20,
            "productSales": 0,
            "productPicture": null,
            "categoryId": 1
        },
        {
            "productId": 7,
            "productName": "4",
            "productTitle": "1亿像素,五摄四闪",
            "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
            "productPrice": 2799.0,
            "productSellingPrice": 1799.0,
            "productNum": 20,
            "productSales": 200,
            "productPicture": null,
            "categoryId": 1
        }
    ]
}
```

### 4.2  单个商品详情

**请求URL：**

```
/product/getDetails
```

**请求方式：**

```
Post
```

**发送示例**

````js
{
    "productId": 1
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| productId |    是    | int | 商品ID |

**返回示例：**

```javascript
{
    "code": "001",
    "msg": "查询成功",
    "data": {
        "productId": 1,
        "productName": "Redmi K30",
        "productTitle": "120Hz流速屏，全速热爱",
        "productIntro": "120Hz高帧率流速屏/ 索尼6400万前后六摄 / 6.67'小孔径全面屏 / 最高可选8GB+256GB大存储 / 高通骁龙730G处理器 / 3D四曲面玻璃机身 / 4500mAh+27W快充 / 多功能NFC",
        "productPrice": 2000.0,
        "productSellingPrice": 1000.0,
        "productNum": 16,
        "productSales": 100,
        "productPicture": "https://${path}/store_system/product/Redmi-k30.png",
        "categoryId": 1
    }
}
```

### 4.3  获取指定商品的全部图片

**请求URL：**

```
/product/getDetailsPicture/
```

**请求方式：**

```
Post
```

**发送示例**

````js
{
    "productId": 1
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| productId |    是    | int | 商品ID |

**返回示例：**

```javascript
{
    "code": "001",
    "msg": "查询成功",
    "data": [
        {
            "id": 1,
            "productId": 1,
            "productPicture": "https://${path}/store_system/product/Redmi-k30-1.png",
            "intro": null
        },
        {
            "id": 2,
            "productId": 1,
            "productPicture": "https://${path}/store_system/product/Redmi-k30-2.png",
            "intro": null
        },
        {
            "id": 3,
            "productId": 1,
            "productPicture": "https://${path}/store_system/product/Redmi-k30-3.png",
            "intro": null
        },
        {
            "id": 4,
            "productId": 1,
            "productPicture": "https://${path}/store_system/product/Redmi-k30-4.png",
            "intro": null
        },
        {
            "id": 23,
            "productId": 1,
            "productPicture": "https://${path}/store_system/product/Redmi-k30-5.png",
            "intro": null
        }
    ]
}
```

### 4.4  获取分类列表

**请求URL：**

```
/product/getCategory/
```

**请求方式：**

```
Post
```

**参数说明：**

无参数

**返回示例：**

```javascript
{
	"code": "001",
	"category": [
		{
			"categoryId": 1,
			"categoryName": "手机"
		},
		{
			"categoryId": 2,
			"categoryName": "电视机"
		},
		{
			"categoryId": 3,
			"categoryName": "空调"
		}
	]
}
```

### 4.5  获取全部商品 || 获取指定类别商品

**请求URL：**

```
/product/getAllProduct/ || /api/product/getProductByCategory
```

**前端代码如下:**

````js
getData() {
  // 如果分类列表为空则请求全部商品数据，否则请求分类商品数据
  const api =
    this.categoryId.length == 0
      ? "/api/product/getAllProduct"
      : "/api/product/getProductByCategory";
  this.$axios
    .post(api, {
      "categoryId": this.categoryId[0],
      "currentPage": this.currentPage,
      "pageSize": this.pageSize
    })
    .then(res => {
      this.product = res.data.data.data;
      this.total = res.data.data.total;
      console.log(this.total)
    })
    .catch(err => {
      return Promise.reject(err);
    });
}
````



**发送示例**

​	**注: 	categoryId 是分类查询的时候才携带  ( 4.6 获取指定类别商品 ), categoryId 为空执行的是全部数据查询**

````js
{
    "categoryId": 1,
    "pageSize": 15,
    "currentPage": 1
}

{
    "pageSize": 15,
    "currentPage": 1
}
````

**请求方式：**

```
Post
```

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| categoryId |    非    | [] | 类别ID |
| pageSize |    是    | int | 页码大小 |
| currentPage |    是    | int | 当前页(设置1为首页即可) |

**返回示例：**

```javascript
{
    "code": "001",
    "msg": "查询成功",
    "data": {
        "data": [
            {
                "productId": 1,
                "productName": "Redmi K30",
                "productTitle": "120Hz流速屏，全速热爱",
                "productIntro": "120Hz高帧率流速屏/ 索尼6400万前后六摄 / 6.67'小孔径全面屏 / 最高可选8GB+256GB大存储 / 高通骁龙730G处理器 / 3D四曲面玻璃机身 / 4500mAh+27W快充 / 多功能NFC",
                "productPrice": 2000.0,
                "productSellingPrice": 1000.0,
                "productNum": 16,
                "productSales": 100,
                "productPicture": "https://${path}/store_system/product/Redmi-k30.png",
                "categoryId": 1
            },
            {
                "productId": 2,
                "productName": "Redmi K30 5G",
                "productTitle": "双模5G,120Hz流速屏",
                "productIntro": "双模5G / 三路并发 / 高通骁龙765G / 7nm 5G低功耗处理器 / 120Hz高帧率流速屏 / 6.67'小孔径全面屏 / 索尼6400万前后六摄 / 最高可选8GB+256GB大存储 / 4500mAh+30W快充 / 3D四曲面玻璃机身 / 多功能NFC",
                "productPrice": 2599.0,
                "productSellingPrice": 1599.0,
                "productNum": -4,
                "productSales": 99,
                "productPicture": "public/imgs/phone/Redmi-k30-5G.png",
                "categoryId": 1
            },
            {
                "productId": 3,
                "productName": "小米CC9 Pro",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 17,
                "productSales": 0,
                "productPicture": "public/imgs/phone/Mi-CC9.png",
                "categoryId": 1
            },
            {
                "productId": 4,
                "productName": "小米test",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 0,
                "productPicture": null,
                "categoryId": 1
            },
            {
                "productId": 5,
                "productName": "2",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 0,
                "productPicture": null,
                "categoryId": 1
            },
            {
                "productId": 6,
                "productName": "3",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 0,
                "productPicture": null,
                "categoryId": 1
            },
            {
                "productId": 7,
                "productName": "4",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 200,
                "productPicture": null,
                "categoryId": 1
            },
            {
                "productId": 8,
                "productName": "5",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 300,
                "productPicture": null,
                "categoryId": 1
            },
            {
                "productId": 9,
                "productName": "6",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 400,
                "productPicture": null,
                "categoryId": 1
            },
            {
                "productId": 10,
                "productName": "7",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 30,
                "productPicture": null,
                "categoryId": 1
            },
            {
                "productId": 11,
                "productName": "8",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 40,
                "productPicture": null,
                "categoryId": 1
            },
            {
                "productId": 12,
                "productName": "9",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 70,
                "productPicture": null,
                "categoryId": 1
            },
            {
                "productId": 13,
                "productName": "11",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 90,
                "productPicture": null,
                "categoryId": 1
            },
            {
                "productId": 14,
                "productName": "12",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 0,
                "productPicture": null,
                "categoryId": 1
            },
            {
                "productId": 15,
                "productName": "13",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 0,
                "productPicture": null,
                "categoryId": 1
            }
        ],
        "total": 17
    }
}
```



### 4.6  由商品分类获取热门商品信息-----(多类)

注 :  多类别自定义

**请求URL：**

```
/product/getHotProduct/
```

**请求方式：**

```
Post
```

**发送示例**

````js
{
    "categoryId": 1
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| categoryId |    是    | [] | 类别名称 |

可考虑直接使用categoryID, 如果后续制作后台管理，名称可修改

categoryName  :  ["保护套", "保护膜", "充电器", "充电宝"]

这里就是从上述4类里面按照销量顺序从高到低返回7条数据，视为热门商品

**返回示例：**

​	**(默认返回7条数据)**

```javascript
{
    "code": "001",
    "msg": "查询成功",
    "data": [
        {
            "productId": 9,
            "productName": "6",
            "productTitle": "1亿像素,五摄四闪",
            "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
            "productPrice": 2799.0,
            "productSellingPrice": 1799.0,
            "productNum": 20,
            "productSales": 400,
            "productPicture": null,
            "categoryId": 1
        },
        {
            "productId": 8,
            "productName": "5",
            "productTitle": "1亿像素,五摄四闪",
            "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
            "productPrice": 2799.0,
            "productSellingPrice": 1799.0,
            "productNum": 20,
            "productSales": 300,
            "productPicture": null,
            "categoryId": 1
        },
        {
            "productId": 7,
            "productName": "4",
            "productTitle": "1亿像素,五摄四闪",
            "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
            "productPrice": 2799.0,
            "productSellingPrice": 1799.0,
            "productNum": 20,
            "productSales": 200,
            "productPicture": null,
            "categoryId": 1
        },
        {
            "productId": 1,
            "productName": "Redmi K30",
            "productTitle": "120Hz流速屏，全速热爱",
            "productIntro": "120Hz高帧率流速屏/ 索尼6400万前后六摄 / 6.67'小孔径全面屏 / 最高可选8GB+256GB大存储 / 高通骁龙730G处理器 / 3D四曲面玻璃机身 / 4500mAh+27W快充 / 多功能NFC",
            "productPrice": 2000.0,
            "productSellingPrice": 1000.0,
            "productNum": 16,
            "productSales": 100,
            "productPicture": "https://${path}/store_system/product/Redmi-k30.png",
            "categoryId": 1
        },
        {
            "productId": 2,
            "productName": "Redmi K30 5G",
            "productTitle": "双模5G,120Hz流速屏",
            "productIntro": "双模5G / 三路并发 / 高通骁龙765G / 7nm 5G低功耗处理器 / 120Hz高帧率流速屏 / 6.67'小孔径全面屏 / 索尼6400万前后六摄 / 最高可选8GB+256GB大存储 / 4500mAh+30W快充 / 3D四曲面玻璃机身 / 多功能NFC",
            "productPrice": 2599.0,
            "productSellingPrice": 1599.0,
            "productNum": -4,
            "productSales": 99,
            "productPicture": "public/imgs/phone/Redmi-k30-5G.png",
            "categoryId": 1
        },
        {
            "productId": 13,
            "productName": "11",
            "productTitle": "1亿像素,五摄四闪",
            "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
            "productPrice": 2799.0,
            "productSellingPrice": 1799.0,
            "productNum": 20,
            "productSales": 90,
            "productPicture": null,
            "categoryId": 1
        },
        {
            "productId": 12,
            "productName": "9",
            "productTitle": "1亿像素,五摄四闪",
            "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
            "productPrice": 2799.0,
            "productSellingPrice": 1799.0,
            "productNum": 20,
            "productSales": 70,
            "productPicture": null,
            "categoryId": 1
        }
    ]
}
```

### 4.7  搜索商品

**请求URL：**

```
/product/getProductBySearch/
```

**请求方式：**

```
Post
```

**发送示例**

````js
{
    "search": "小米",
    "pageSize": 15,
    "currentPage": 1
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| search |    是    | str | 搜索内容 |
| pageSize | 是 | int | 页码大小 |
| currentPage | 是 | int | 当前页(设置1为首页即可) |

**返回示例：**

**seach : 小米， 支持模糊搜索**

```javascript
{
    "code": "001",
    "msg": "查询成功",
    "data": {
        "data": [
            {
                "productId": 3,
                "productName": "小米CC9 Pro",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 17,
                "productSales": 0,
                "productPicture": "public/imgs/phone/Mi-CC9.png",
                "categoryId": 1
            },
            {
                "productId": 4,
                "productName": "小米test",
                "productTitle": "1亿像素,五摄四闪",
                "productIntro": "1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器",
                "productPrice": 2799.0,
                "productSellingPrice": 1799.0,
                "productNum": 20,
                "productSales": 0,
                "productPicture": null,
                "categoryId": 1
            }
        ],
        "total": 2
    }
}
```



## 五、 订单模块

### 5.1  添加订单

(products来着 2.1节 获取购物车信息的返回)
**请求URL：**

```
/order/addOrder/
```

**请求方式：**

```
Post
```

**发送示例**

````js
{
    "userId": 1,
    "products": [
        {
            "productId": 3, 
            "price": 100, 
            "num": 2
        },
        {
            "productId": 2, 
            "price": 200, 
            "num": 3
        }
    ]
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| userId |    是    | int | 用户ID |
| products |    是    | [{…}, {…}] |  结算的全部商品  |

```js
products结构
{
  productId: "", // 商品id
  price: "", // 商品价格
  num: "", // 商品数量
}
```




**返回示例：**

```javascript
{'code': '001', 'msg': '购买成功'}
{'code': '002', 'msg': '购买失败'}
```

### 5.2  获取已有订单

**请求URL：**

```
/order/getOrder/
```

**请求方式：**

```
Post
```

**发送示例**

````
{
    "userId": 1
}
````

**参数说明：**

|  参数  | 是否必选 | 类型 |  说明  |
| :----: | :------: | :--: | :----: |
| userId |    是    | int  | 用户ID |

**返回示例：**

```javascript
{
    "code": "001",
    "msg": "查询订单成功",
    "data": [
        [
            {
                "orderId": "8360526552148541440",
                "userId": 1,
                "productId": 1,
                "productNum": 3,
                "productPrice": 1000,
                "createTime": "2023-06-23T18:11:14",
                "productName": "Redmi K30",
                "productPicture": "https://${path}/store_system/product/Redmi-k30.png"
            }
        ],
        [
            {
                "orderId": "8358665674094608384",
                "userId": 1,
                "productId": 3,
                "productNum": 2,
                "productPrice": 100,
                "createTime": "2023-06-18T14:56:46",
                "productName": "小米CC9 Pro",
                "productPicture": "public/imgs/phone/Mi-CC9.png"
            },
            {
                "orderId": "8358665674094608384",
                "userId": 1,
                "productId": 2,
                "productNum": 3,
                "productPrice": 200,
                "createTime": "2023-06-18T14:56:46",
                "productName": "Redmi K30 5G",
                "productPicture": "public/imgs/phone/Redmi-k30-5G.png"
            }
        ]
    ]
}
```

##  六、收藏模块

### 6.1  查看收藏

**请求URL：**

```
/user/collect/getCollect
```

**请求方式：**

```
Post
```

**发送示例**

````
{
    "userId": 1
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| userId |    是    | int | 用户ID |


**返回示例：**

```javascript
{
    "code": "001",
    "msg": "查询收藏成功",
    "data": [
        {
            "productId": 2,
            "productName": "Redmi K30 5G",
            "productTitle": "双模5G,120Hz流速屏",
            "productIntro": "双模5G / 三路并发 / 高通骁龙765G / 7nm 5G低功耗处理器 / 120Hz高帧率流速屏 / 6.67'小孔径全面屏 / 索尼6400万前后六摄 / 最高可选8GB+256GB大存储 / 4500mAh+30W快充 / 3D四曲面玻璃机身 / 多功能NFC",
            "productPrice": 2599.0,
            "productSellingPrice": 1599.0,
            "productNum": -7,
            "productSales": 99,
            "productPicture": "public/imgs/phone/Redmi-k30-5G.png",
            "categoryId": 1
        },
        {
            "productId": 1,
            "productName": "Redmi K30",
            "productTitle": "120Hz流速屏，全速热爱",
            "productIntro": "120Hz高帧率流速屏/ 索尼6400万前后六摄 / 6.67'小孔径全面屏 / 最高可选8GB+256GB大存储 / 高通骁龙730G处理器 / 3D四曲面玻璃机身 / 4500mAh+27W快充 / 多功能NFC",
            "productPrice": 2000.0,
            "productSellingPrice": 1000.0,
            "productNum": 16,
            "productSales": 100,
            "productPicture": "https://${path}/store_system/product/Redmi-k30.png",
            "categoryId": 1
        }
    ]
}
```

### 6.2  添加收藏

**请求URL：**

```
/collect/addCollect
```

**请求方式：**

```
Post
```

**发送示例**

````
{
    "userId": 1,
    "productId": 1
}
````

**参数说明：**

|  参数   | 是否必选 | 类型 |  说明  |
| :-----: | :------: | :--: | :----: |
| userId |    是    | int  | 用户ID |
| productId |    是    | int  | 商品ID |

**返回示例：**

```javascript
{
	"code": "001",
	"msg": "添加收藏成功"
}
{
	"code": "003",
	"msg": "该商品已经添加收藏，请到我的收藏查看"
}
```



### 6.3  删除收藏

**请求URL：**

```
/collect/deleteCollect/
```

**请求方式：**

```
Post
```

**发送示例**

````js
{
    "userId": 1,
    "productId": 1
}
````

**参数说明：**

|   参数   | 是否必选 |  类型  |  说明  |
| :------: | :------: | :----: | :----: |
| userId |    是    | int | 用户ID |
| productId |    是    | int  | 商品ID |


**返回示例：**

```javascript
{
	"code": "001",
	"msg": "删除收藏成功",
  "data": null
}

{
	"code": "002",
	"msg": "该商品不在收藏列表",
  "data": null
}
```



##  七、评论模块

### 7.1  查看评论（默认分页大小5）

**请求URL：**

```
/discussion/getDiscussionInfo
```

**请求方式：**

```
Post
```

**默认分页大小由后端决定，一般一页定5-10条**

**发送示例**

````js
{
    "productId": 1,
    "currentPage": 1,
    "lastDiscussionId": 0 // 上次获取的最后一条评论ID，深度分页时加快查询速度
}
````

**参数说明：**

|       参数       | 是否必选 | 类型 |    说明    |
| :--------------: | :------: | :--: | :--------: |
|    productId     |    是    | int  |   用户ID   |
|   currentPage    |    是    | int  |   商品ID   |
| lastDiscussionId |    是    | int  | 最后评论ID |

**返回示例：**

```javascript
{
    "code": "001",
    "msg": "获取评论成功",
    "data": [
        {
            "id": 23,
            "commentUser": {
                "id": 1,
                "nickName": "张三",
                "avatar": "https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg"
            },
            "targetUser": null,
            "content": "chinaFa",
            "createDate": "2023-06-23 00:41:03",
            "childrenList": [
                {
                    "id": 131,
                    "commentUser": {
                        "id": 1,
                        "nickName": "张三",
                        "avatar": "https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg"
                    },
                    "targetUser": {
                        "id": 1,
                        "nickName": "张三",
                        "avatar": "https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg"
                    },
                    "content": "chinaChild",
                    "createDate": "2023-06-23 13:54:02",
                    "childrenList": null
                }
            ]
        },
        {
            "id": 24,
            "commentUser": {
                "id": 1,
                "nickName": "张三",
                "avatar": "https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg"
            },
            "targetUser": null,
            "content": "ee[嘻嘻][嘻嘻]",
            "createDate": "2023-06-23 13:47:06",
            "childrenList": null
        },
        {
            "id": 25,
            "commentUser": {
                "id": 1,
                "nickName": "张三",
                "avatar": "https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg"
            },
            "targetUser": null,
            "content": "heng[闭嘴][闭嘴]",
            "createDate": "2023-06-23 13:51:25",
            "childrenList": null
        },
        {
            "id": 26,
            "commentUser": {
                "id": 1,
                "nickName": "张三",
                "avatar": "https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg"
            },
            "targetUser": null,
            "content": "t1",
            "createDate": "2023-06-23 15:02:47",
            "childrenList": null
        },
        {
            "id": 27,
            "commentUser": {
                "id": 1,
                "nickName": "张三",
                "avatar": "https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg"
            },
            "targetUser": null,
            "content": "t2",
            "createDate": "2023-06-23 15:02:50",
            "childrenList": null
        }
    ]
}
```



### 7.2  查看评论数量(全部)

**请求URL：**

```
/discussion/getDiscussionCount
```

**请求方式：**

```
Post
```

**发送示例**

````js
{
    "productId": 1
}
````

**参数说明：**

|   参数    | 是否必选 | 类型 |  说明  |
| :-------: | :------: | :--: | :----: |
| productId |    是    | int  | 商品ID |

**返回示例：**

````js
{
    "code": "001",
    "msg": "获取评论个数成功",
    "data": 28
}
````



### 7.3  添加一级评论

**请求URL：**

```
/discussion/addDiscussion
```

**请求方式：**

```
Post
```

**发送示例**

````js
{
    "userId":1,
    "productId":1,
    "content":"一级评论内容"
}
````

**参数说明：**

|   参数    | 是否必选 |  类型  |   说明   |
| :-------: | :------: | :----: | :------: |
|  userId   |    是    |  int   |  用户ID  |
| productId |    是    |  int   |  商品ID  |
|  content  |    是    | string | 评论内容 |

**返回示例：**

**返回数据，便于前端实时显示**

````js
{
    "code": "001",
    "msg": "添加评论成功",
    "data": {
        "id": 53,
        "commentUser": {
            "id": 1,
            "nickName": "张三",
            "avatar": "https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg"
        },
        "targetUser": null,
        "content": "一级评论内容",
        "createDate": "2023-06-23 19:40:50",
        "childrenList": []
    }
}
````



### 7.4  添加二级评论

**请求URL：**

```
/discussion/addSunDiscussion
```

**请求方式：**

```
Post
```

**发送示例**

````js
{
    "userId":1,
    "productId":1,
    "parentId":52,
    "touchId":1,
    "content":"二级评论内容"
}
````

**参数说明：**

|   参数    | 是否必选 |  类型  |    说明     |
| :-------: | :------: | :----: | :---------: |
|  userId   |    是    |  int   |   用户ID    |
| productId |    是    |  int   |   商品ID    |
| parentId  |    是    |  long  | 一级评论ID  |
|  touchId  |    是    |  int   | 被@用户的ID |
|  content  |    是    | string |  评论内容   |

**返回示例：**

**返回数据，便于前端实时显示**

````js
{
    "code": "001",
    "msg": "添加二级评论成功",
    "data": {
        "id": 160,
        "commentUser": {
            "id": 1,
            "nickName": "张三",
            "avatar": "https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg"
        },
        "targetUser": {
            "id": 1,
            "nickName": "张三",
            "avatar": "https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg"
        },
        "content": "二级评论内容",
        "createDate": "2023-06-23 19:46:18",
        "childrenList": null
    }
}
````

