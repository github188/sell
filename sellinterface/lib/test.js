/**
 * Created by tmachc on 15/4/8.
 */

require('./WarnConfig');
var ObjectID = require("mongodb").ObjectID;
var log4js = require('log4js');
var logger = log4js.getLogger('normal');
var UserProvider = require("../modules/dao/UserProvider").UserProvider;
var userProvider = new UserProvider();


exports.initData = function(req,callback){
    var json = {
        _id : new ObjectID(),
        phone : "110",
        password : "123",
        name : "admin",
        sex : "",
        age : 0,
        type : "admin"
    };
    console.log("111");
    userProvider.find({},{},function(err,result){
        console.log("222",err,result);
        if (err) {
            logger.warn(global.warnCode.adminDbError,":",req.url,req.body);
            callback(global.warnCode.adminDbError);
        } else {
            console.log("333");
            callback({"result":true,"list":result});
        }
    });
    //callback({"code":0});
};