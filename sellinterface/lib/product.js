/**
 * Created by hanchong on 15/4/11.
 */

require("./WarnConfig");
var ObjectID = require("mongodb").ObjectID;
var log4js = require('log4js');
var logger = log4js.getLogger('normal');
var ProductProvider = require("../modules/dao/ProductProvider").ProductProvider;
var productProvider = new ProductProvider();

// 初始化商品
exports.initProduct = function(req,callback){
    var name = req.query.name;
    var price = req.query.price;
    var intro = req.query.intro;
    var spe = req.query.spe;
    var img = req.query.img;
    var id = req.query.id;
    if (name == "" || name == undefined || name == null) {
        callback({"result":false,"isSuccess":false,message:"没有name..."});
        return;
    }
    if (price == "" || price == undefined || price == null) {
        callback({"result":false,"isSuccess":false,message:"没有price..."});
        return;
    }
    if (intro == "" || intro == undefined || intro == null) {
        callback({"result":false,"isSuccess":false,message:"没有intro..."});
        return;
    }
    if (spe == "" || spe == undefined || spe == null) {
        callback({"result":false,"isSuccess":false,message:"没有spe..."});
        return;
    }
    if (img == "" || img == undefined || img == null) {
        callback({"result":false,"isSuccess":false,message:"没有img..."});
        return;
    }
    var json = {
        name : name,
        price : price,
        intro : intro,
        spe : spe,
        img : img
    };
    console.log("json--->>>%@",json);
    if (id == "" || id == null || id == undefined) {
        json._id = new ObjectID();
        productProvider.findOne({name : name},{},function(err,result){
            if (err) {
                logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                callback(global.warnCode.adminDbError);
            } else if (result != null) {
                callback({"result":true,"isSuccess":false,message:"存在该商品"});
            } else {
                productProvider.insert(json,{},function(err){
                    if (err) {
                        logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                        callback(global.warnCode.adminDbError);
                    } else {
                        callback({"result":true,"isSuccess":true,message:""});
                    }
                });
            }
        });
    }
    else {
        productProvider.findOne({_id: new ObjectID(id)},{},function(err,result){
            if (err || result == null) {
                logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                callback(global.warnCode.adminDbError);
            }
            else {
                productProvider.update({_id: new ObjectID(id)},{"$set": json},function(err,result){
                    if (err) {
                        logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
                        callback(global.warnCode.adminDbError);
                    } else {
                        callback({"result":true,"isSuccess":true,message:""});
                    }
                });
            }
        });
    }
};

// 商品列表
exports.productList = function(req,callback){

    productProvider.find({},{},function(err,result){
        if (err) {
            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
            callback(global.warnCode.adminDbError);
        } else {
            callback({"result":true,list:result});
        }
    });
};

// 商品详情
exports.productDetail = function(req,callback){
    var id = req.query.id;
    productProvider.findOne({_id:new ObjectID(id)},{},function(err,result){
        if (err) {
            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
            callback(global.warnCode.adminDbError);
        } else if (result == null) {
            callback(global.warnCode.productNotExistError);
        } else {
            var s = result;
            s.result = true;
            callback(s);
        }
    });
};

