/**
 * Created with JetBrains WebStorm.
 * User: witmob
 * Date: 13-9-4
 * Time: 下午5:38
 * To change this template use File | Settings | File Templates.
 */
var DataProvider = require('../DataProvider.js').DataProvider,
    util = require('util');
var ChunksProvider = function() {
    this.collectionName = 'fs.chunks';
};
util.inherits(ChunksProvider, DataProvider);
exports.ChunksProvider = ChunksProvider;