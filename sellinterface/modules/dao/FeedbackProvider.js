/**
 * Created by hanchong on 15/5/26.
 */

var DataProvider = require('../DataProvider.js').DataProvider,
    util = require('util');
var FeedbackProvider = function() {
    this.collectionName = 'feedback'; // 表名
};

util.inherits(FeedbackProvider, DataProvider);
exports.FeedbackProvider = FeedbackProvider;

// 意见反馈表