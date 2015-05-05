/**
 * Created by hanchong on 15/5/1.
 */

var DataProvider = require('../DataProvider.js').DataProvider,
    util = require('util');
var AddressProvider = function() {
    this.collectionName = 'address'; // 表名
};

util.inherits(AddressProvider, DataProvider);
exports.AddressProvider = AddressProvider;

// 地址表