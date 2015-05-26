/**
 * Created by hanchong on 15/4/11.
 */

require("./WarnConfig");
var ObjectID = require("mongodb").ObjectID;
var log4js = require('log4js');
var logger = log4js.getLogger('normal');
var OrderProvider = require("../modules/dao/OrderProvider").OrderProvider;
var orderProvider = new OrderProvider();
var UserProvider = require("../modules/dao/UserProvider").UserProvider;
var userProvider = new UserProvider();

exports.initOrder = function(req,callback){
    var projectAndNum = req.query.projectAndNum;
    var total = req.query.total;
    var addressID = req.query.addressID;
    var userId = req.query.userId;
    var list = [];
    var arr = projectAndNum.split("/");
    for (var i = 0; i < arr.length; i ++) {
        var json = {
            productId : arr[i].split(",")[0],
            num : arr[i].split(",")[1]
        };
        list.push(json);
    }
    var order = {
        _id : new ObjectID(),
        userId : userId,
        total : total,
        list : list,
        addressID : addressID,
        initTime : new Date(),
        changeTime : new Date(),
        payType : "",
        state : 4          // 1、未支付   2、已支付待配送   3、已配送   4、已完成
    };
    console.log("order--->>>",order);
    orderProvider.insert(order,{},function(err){
        if (err) {
            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
            callback(global.warnCode.adminDbError);
        } else {
            callback({result:true,isSuccess:true,message:"",id:order._id});
        }
    });
};

// 修改订单状态
exports.changeOrder = function(req,callback){
    var userId = req.query.userId;
    var state = req.query.state;
    var payType = req.query.payType;
    var orderId = req.query.orderId;
    if (state == 2 || state == 4) {
        // 付款
        change(orderId,userId,state, payType,function(res){
            callback(res);
        });
    }
    else {
        // 管理员配送
        userProvider.findOne({_id:new ObjectID(userId)},{},function(err,result){
            if (err || result == null) {
                logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                callback(global.warnCode.adminDbError);
            } else {
                if (result.type == "admin") {
                    change(orderId,userId,state, payType,function(res){
                        callback(res);
                    });
                } else {
                    logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                    callback(global.warnCode.adminDbError);
                }
            }
        });
    }
};

function change(orderId, userId, state, payType,callback){
    orderProvider.findOne({_id:new ObjectID(orderId)},{},function(err,result){
        if (err || result == null) {
            logger.warn(global.warnCode.adminDbError,":");
            callback(global.warnCode.adminDbError);
        } else {
            var set = {state:state, changeTime: new Date()};
            if (payType != null && payType != undefined && payType != "") {
                set.payType = payType;
            }
            orderProvider.update({_id:new ObjectID(orderId)},{$set: set},function(err){
                if (err) {
                    logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                    callback(global.warnCode.adminDbError);
                } else {
                    callback({result:true,isSuccess:true,message:""});
                }
            })
        }
    });
}

// 订单列表
exports.orderList = function(req,callback){
    var userId = req.query.userId;
    userProvider.findOne({_id:new ObjectID(userId)},{},function(err,result1) {
        if (err || result1 == null) {
            logger.warn(global.warnCode.adminDbError, ":", req.url, req.body);
            callback(global.warnCode.adminDbError);
        }
        else {
            var json = {};
            if (result1.type == "user") {
                json.userId = userId;
            }
            orderProvider.find(json,{},function(err,result){
                if (err) {
                    logger.warn(global.warnCode.adminDbError, ":", req.url, req.body);
                    callback(global.warnCode.adminDbError);
                }
                else {
                    for (var i = 0; i < result.length; i ++) {
                        result[i].initTime = format(result[i].initTime, "yyyy-MM-dd hh:mm:ss");
                        result[i].changeTime = format(result[i].changeTime, "yyyy-MM-dd hh:mm:ss");
                    }
                    callback({result:true,isSuccess:true,message:"",list:result});
                }
            });
        }
    });
};

//时间格式转换
function format(d, format) {
//        {date} d
//        日期
//        {string} format
//        日期格式：yyyy-MM-dd w hh:mm:ss
//        yyyy/yy 表示年份
//        MM/M 月份
//        w 星期
//        dd/d 日
//        hh/h 小时
//        mm/m 分
//        ss/s 秒

    var str = format;
    var Week = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
    var month = d.getMonth() + 1;

    str = str.replace(/yyyy/, d.getFullYear());
    str = str.replace(/yy/, (d.getYear() % 100) > 9 ? (d.getYear() % 100).toString() : '0' + (d.getYear() % 100));
    str = str.replace(/MM/, month > 9 ? month.toString() : '0' + month);
    str = str.replace(/M/g, month);
    str = str.replace(/dd/, d.getDate() > 9 ? d.getDate().toString() : '0' + d.getDate());
    str = str.replace(/d/g, d.getDate());

    str = str.replace(/w/g, Week[d.getDay()]);

    str = str.replace(/hh/, d.getHours() > 9 ? d.getHours().toString() : '0' + d.getHours());
    str = str.replace(/h/g, d.getHours());
    str = str.replace(/mm/, d.getMinutes() > 9 ? d.getMinutes().toString() : '0' + d.getMinutes());
    str = str.replace(/m/g, d.getMinutes());
    str = str.replace(/ss/, d.getSeconds() > 9 ? d.getSeconds().toString() : '0' + d.getSeconds());
    str = str.replace(/s/g, d.getSeconds());
    console.log(str);
    return str;
}