/**
 * Created by hanchong on 15/4/9.
 */

var DataProvider = require('../DataProvider.js').DataProvider,
    util = require('util');
var OrderProvider = function() {
    this.collectionName = 'order'; // 表名
};

util.inherits(OrderProvider, DataProvider);
exports.OrderProvider = OrderProvider;

// 订单表