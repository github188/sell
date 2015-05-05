/**
 * Created by hanchong on 15/5/2.
 */

var express = require('express');
var router = express.Router();
var multipart = require('connect-multiparty');
var multipartMiddleware = multipart();

var log4js = require('log4js');
var logger = log4js.getLogger('normal');
var user = require('../lib/user');

router.all('/',multipartMiddleware, function(req, res, next) {
    //首先获取到命令]
    if (req.method == "POST") {
        var command = req.body.command;
        logger.debug("req.body--->>>:",req.body);
        logger.debug("req.query--->>>:",req.query);
        logger.debug("req.files--->>>:",req.files.file.path);
    }
    else {
        var command = req.query.command;
        logger.debug("req.query--->>>:",req.query);
    }
    user.loadImage(req,res);
});

module.exports = router;
