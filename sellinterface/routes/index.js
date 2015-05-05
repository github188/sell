
var express = require('express');
var router = express.Router();
var multipart = require('connect-multiparty');
var multipartMiddleware = multipart();

var log4js = require('log4js');
var logger = log4js.getLogger('normal');
var test = require('../lib/test');
var user = require('../lib/user');
var product = require('../lib/product');
var order = require('../lib/order');

/* GET home page. */
router.all('/',multipartMiddleware, function(req, res, next) {
    //首先获取到命令]
    if (req.method == "POST") {
        var command = req.body.command;
        logger.debug("req.body:",req.body);
        logger.debug("req.query:",req.query);
        logger.debug("req.files:",req.files);
    }
    else {
        var command = req.query.command;
        logger.debug("req.query:",req.query);
    }
    logger.debug("command:",command);
    if (command == null){
        this.sendRes({code:'10000',message:"参数错误"},res);
    } else {
        if(this[command] == null){
            logger.warn({code:2000,message:'命令不存在'}+":"+req.url+":"+req.query);
            sendRes({code:2000,message:'命令不存在'},res);
        } else {
            this[command](req, function(sendResponse){
                sendRes(sendResponse,res);
            });
        }
    }
});

module.exports = router;

//发送数据
var sendRes = function(sendResponse,res){
  logger.debug('result->',sendResponse);
  res.send(sendResponse);
};

//测试
initData = function(req,callback){
  test.initData(req,function(sendRes){
    callback(sendRes);
  });
};

// 上传图片
uploadImage = function(req,callback){
    user.uploadImage(req,function(sendRes){
        callback(sendRes);
    });
};

//********************************** 用户

// 获取验证码
getCode = function(req,callback){
    user.getCode(req,function(sendRes){
        callback(sendRes);
    });
};
// 注册 找回密码 登录 修改密码
register = function(req,callback){
    user.register(req,function(sendRes){
        callback(sendRes);
    });
};
// 地址列表
addressList = function(req,callback){
    user.addressList(req,function(sendRes){
        callback(sendRes);
    });
};
// 地址详情
addressDetail = function(req,callback){
    user.addressDetail(req,function(sendRes){
        callback(sendRes);
    });
};
// 添加修改地址
changeAddress = function(req,callback){
    user.changeAddress(req,function(sendRes){
        callback(sendRes);
    });
};

//********************************** 商品

// 初始化商品
initProduct = function(req,callback){
    product.initProduct(req,function(sendRes){
        callback(sendRes);
    });
};

// 商品列表
productList = function(req,callback){
    product.productList(req,function(sendRes){
        callback(sendRes);
    });
};

// 商品详情
productDetail = function(req,callback){
    product.productDetail(req,function(sendRes){
        callback(sendRes);
    });
};

//********************************** 订单

// 下订单
initOrder = function(req,callback){
    order.initOrder(req,function(sendRes){
        callback(sendRes);
    });
};
// 修改订单状态
changeOrder = function(req,callback){
    order.changeOrder(req,function(sendRes){
        callback(sendRes);
    });
};
// 订单列表
orderList = function(req,callback){
    order.orderList(req,function(sendRes){
        callback(sendRes);
    });
};