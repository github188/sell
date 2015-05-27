/**
 * Created by hanchong on 15/4/11.
 */

require("./WarnConfig");
var ObjectID = require("mongodb").ObjectID;
var log4js = require('log4js');
var logger = log4js.getLogger('normal');
var UserProvider = require("../modules/dao/UserProvider").UserProvider;
var userProvider = new UserProvider();
var AddressProvider = require("../modules/dao/AddressProvider").AddressProvider;
var addressProvider = new AddressProvider();
var BinaryProvider = require("../modules/BinaryProvider").BinaryProvider;
var binaryProvider = new BinaryProvider();
var FeedbackProvider = require("../modules/dao/FeedbackProvider").FeedbackProvider;
var feedbackProvider = new FeedbackProvider();
var ActivityProvider = require("../modules/dao/ActivityProvider").ActivityProvider;
var activityProvider = new ActivityProvider();

// 获取验证码
exports.getCode = function(req,callback){
    var type = req.query.type;    // 1为注册，2为找回密码
    var phone = req.query.phone;
    // 随机生成一个4位验证码 保存到用户的数据中 并返回给客户端
    var code = parseInt(Math.random() * 10000);
    if (type == 1) {
        userProvider.findOne({phone : phone}, {}, function(err,result){
            if (err) {
                logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                callback(global.warnCode.adminDbError);
            } else if (result != null) { // 有查询结果
                if (result.password == "") {
                    // 没注册
                    userProvider.update({phone : phone}, {$set:{code:code}}, function(err){
                        if (err) {
                            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                            callback(global.warnCode.adminDbError);
                        } else {
                            callback({result:true,isSuccess:true,message:"",code:code});
                        }
                    });
                } else {
                    // 已注册
                    callback({"result":true,"isSuccess":false,message:"手机号已注册"});
                }
            } else {
                // 未注册，创建一个新的用户，保存验证码，密码为空
                var json = {
                    _id : new ObjectID(),
                    phone : phone,
                    password : "",
                    name : "",
                    sex : "",
                    age : 0,
                    type : "user",
                    code : code
                };
                userProvider.insert(json, {}, function(err){
                    if (err) {
                        logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                        callback(global.warnCode.adminDbError);
                    } else {
                        callback({result:true,isSuccess:true,message:"",code:code});
                    }
                });
            }
        });
    }
    else {
        userProvider.findOne({phone : phone}, {}, function(err,result){
            if (err) {
                logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                callback(global.warnCode.adminDbError);
            } else if (result != null) { // 有查询结果
                 // 判断密码是否为空
                if (result.password == "") {
                    // 没注册
                    callback({"result":true,"isSuccess":false,message:"手机号尚未注册"});
                } else {
                    // 已注册
                    userProvider.update({phone : phone}, {$set:{code:code}}, function(err){
                        if (err) {
                            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                            callback(global.warnCode.adminDbError);
                        } else {
                            callback({result:true,isSuccess:true,message:"",code:code});
                        }
                    });
                }
            } else {
                callback({"result":true,"isSuccess":false,message:"手机号尚未注册"});
            }
        });
    }
};

// 注册
exports.register = function(req,callback){
    var phone = req.query.phone;
    var password = req.query.password;
    var code = req.query.code;
    var type = req.query.type;  // 1、注册 2、找回密码 3、登录 4、修改密码
    var oldPassword = req.query.oldPassword;
    userProvider.findOne({phone : phone},{},function(err,result){
        console.log("phone--->>>",phone);
        console.log("result--->>>",result);
        if (err || result == null) {
            logger.warn(global.warnCode.userNotExistError,":",req.url,req.body);
            callback(global.warnCode.userNotExistError);
        } else {
            if (type == 1 || type == 2 || type == "1" || type == "2") {
                if (result.code == code) {
                    // update 密码
                    userProvider.update({phone : phone},{$set:{password:password}},function(err){
                        if (err) {
                            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                            callback(global.warnCode.adminDbError);
                        } else {
                            callback({result:true,isSuccess:true,message:"",id:result._id,type:result.type,phone:result.phone});
                        }
                    });
                } else {
                    callback({"result":true,"isSuccess":false,message:"验证码不正确"});
                }
            } else if (type == 3 || type == "3") {
                // 验证密码是否正确
                if (result.password == password) {
                    callback({result:true,isSuccess:true,message:"",id:result._id,type:result.type,phone:result.phone});
                } else {
                    callback({"result":true,"isSuccess":false,message:"密码错误"});
                }
            } else if (type == 4 || type == "4") {
                // update 密码
                if (result.password == oldPassword) {
                    userProvider.update({phone : phone},{$set:{password:password}},function(err){
                        if (err) {
                            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                            callback(global.warnCode.adminDbError);
                        } else {
                            callback({result:true,isSuccess:true,message:"",id:result._id,phone:result.phone});
                        }
                    });
                } else {
                    callback({"result":true,"isSuccess":false,message:"密码错误"});
                }
            }
        }
    });
};

// 地址列表
exports.addressList = function(req,callback){
    addressProvider.find({},{},function(err,result){
        if (err) {
            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
            callback(global.warnCode.adminDbError);
        }
        else {
            callback({"result":true,"isSuccess":true,message:"",list:result});
        }
    });
};

// 地址详情
exports.addressDetail = function(req,callback){
    var id = req.query.id;
    var address = req.query.address;
    if (id == "" || id == undefined || id == null) {
        var json = {
            _id : new ObjectID(),
            address : address
        };
        addressProvider.insert(json, {}, function(err){
            if (err) {
                logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                callback(global.warnCode.adminDbError);
            }
            else {
                callback({"result":true,"isSuccess":true,message:""});
            }
        });
    }
    else {
        addressProvider.findOne({_id:new ObjectID(id)},{},function(err,result){
            if (err || result == null) {
                logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                callback(global.warnCode.adminDbError);
            } else {
                if (address == "" || address == undefined || address == null) {
                    result.result = true;
                    callback(result);
                }
                else {
                    addressProvider.update({_id:new ObjectID(id)}, {$set:{address:address}}, function(err){
                        if (err) {
                            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                            callback(global.warnCode.adminDbError);
                        } else {
                            callback({result:true,isSuccess:true,message:""});
                        }
                    });
                }
            }
        });
    }
};

// 添加修改地址
exports.changeAddress = function(req,callback){
    var userId = req.query.userId;
    var id = req.query.id;
    var address = req.query.address;
    var name = req.query.name;
    var phone = req.query.phone;
    var type = req.query.type;  // 1为添加，2为修改，3为删除
    if (type == 1) {
        var json = {
            _id : new ObjectID(),
            userId : userId,
            name : name,
            phone : phone,
            address : address
        };
        addressProvider.insert(json , {}, function(err){
            if (err) {
                logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                callback(global.warnCode.adminDbError);
            }
            else {
                callback({"result":true,"isSuccess":true,message:""});
            }
        });
    }
    else if (type == 2) {
        var json = {
            name : name,
            phone : phone,
            address : address
        };
        addressProvider.findOne({_id: new ObjectID(id)},{},function(err,result){
            if (err || result == null) {
                logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                callback(global.warnCode.adminDbError);
            }
            else {
                addressProvider.update({_id: new ObjectID(id)},{"$set":json},function(err){
                    if (err || result == null) {
                        logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                        callback(global.warnCode.adminDbError);
                    }
                    else {
                        callback({"result":true,"isSuccess":true,message:""});
                    }
                });
            }
        });
    }
    else if (type == 3) {
        addressProvider.findOne({_id: new ObjectID(id)},{},function(err,result){
            if (err || result == null) {
                logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                callback(global.warnCode.adminDbError);
            }
            else {
                addressProvider.remove({_id: new ObjectID(id)},{},function(err){
                    if (err || result == null) {
                        logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                        callback(global.warnCode.adminDbError);
                    }
                    else {
                        callback({"result":true,"isSuccess":true,message:""});
                    }
                });
            }
        });
    }
    else {
        callback({"result":false,"isSuccess":false,message:"没有type"});
    }
};

// 上传图片
exports.uploadImage = function(req,callback){
    var imagePath = req.files.file.path;
    var imageID = new ObjectID();
    binaryProvider.writeFile(imagePath, "image/jpeg", imageID, function (err, result) {
        if (err) {
            logger.warn("saveImages binaryProvider.writeFile err: ", err);
            callback(global.warnCode.adminDbError);
        }
        else {
            callback({"result":true,"isSuccess":true,message:"",id:imageID});
        }
    });
};

// 下载图片
exports.loadImage = function(req,res){
    var id = req.query.id;
    binaryProvider.read(new ObjectID(id),function(err,binaryData,fileType){
        if(err) {
            logger.error(global.warn.readFailed+":"+req.url+":"+req.body,err);
            throw (global.warn.readFailed);
        }
        else {
            res.writeHead(200, {"Content-Type:": fileType});
            res.write(binaryData, "binary");
            res.end();
        }
    })
};

// 意见反馈
exports.newFeedback = function(req,callback){
    var userId = req.query.userId;
    var feedback = req.query.feedback;
    userProvider.findOne({},{},function(err,result){
        if (err || result == null) {
            logger.warn(global.warnCode.userNotExistError,":",req.url,req.body);
            callback(global.warnCode.userNotExistError);
        } else {
            var json = {
                _id : new ObjectID(),
                userId : userId,
                userPhone : result.phone,
                feedback : feedback
            };
            feedbackProvider.insert(json, {}, function(err){
                if (err) {
                    logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                    callback(global.warnCode.adminDbError);
                }
                else {
                    callback({"result":true,"isSuccess":true,message:""});
                }
            });
        }
    });
};

// 反馈列表
exports.feedbackList = function(req, callback){
    feedbackProvider.find({}, {}, function(err,result){
        if (err) {
            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
            callback(global.warnCode.adminDbError);
        }
        else {
            callback({"result":true,"isSuccess":true,message:"",list:result});
        }
    });
};

// 意见反馈
exports.newActivity = function(req,callback){
    var activity = req.query.activity;
    var json = {
        _id : new ObjectID(),
        activity : activity,
        date : new Date()
    };
    activityProvider.insert(json, {}, function(err){
        if (err) {
            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
            callback(global.warnCode.adminDbError);
        }
        else {
            callback({"result":true,"isSuccess":true,message:""});
        }
    });
};

// 活动列表
exports.activityList = function(req, callback){
    activityProvider.find({}, {}, function(err,result){
        if (err) {
            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
            callback(global.warnCode.adminDbError);
        }
        else {
            for (var i = 0; i < result.length; i ++) {
                result[i].date = format(result[i].date, "yyyy-MM-dd hh:mm:ss");
            };
            callback({"result":true,"isSuccess":true,message:"",list:result});
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
