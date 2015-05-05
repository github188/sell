/**
 * Created by tmachc on 14-2-17.
 */

var DataProvider = require('../DataProvider.js').DataProvider,
    util = require('util');
var ProductProvider = function() {
    this.collectionName = 'product'; // 表名
};

util.inherits(ProductProvider, DataProvider);
exports.ProductProvider = ProductProvider;

// 产品表