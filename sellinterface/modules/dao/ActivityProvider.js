/**
 * Created by hanchong on 15/5/26.
 */

var DataProvider = require('../DataProvider.js').DataProvider,
    util = require('util');
var ActivityProvider = function() {
    this.collectionName = 'activity'; // 表名
};

util.inherits(ActivityProvider, DataProvider);
exports.ActivityProvider = ActivityProvider;

// 活动表