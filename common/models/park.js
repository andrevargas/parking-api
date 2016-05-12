module.exports = function(Park) {

	Park.disableRemoteMethod('create', true);
	Park.disableRemoteMethod('upsert', true);
	Park.disableRemoteMethod('exists', true);
	Park.disableRemoteMethod('findById', true);
	Park.disableRemoteMethod('find', true);
	Park.disableRemoteMethod('findOne', true);
	Park.disableRemoteMethod('deleteById', true);
	Park.disableRemoteMethod('updateAttributes', true);
	Park.disableRemoteMethod('createChangeStream', true);
	Park.disableRemoteMethod('updateAll', true);
	Park.disableRemoteMethod('prototype.updateAttributes', true);
	Park.disableRemoteMethod('count', true);

	Park.getAll = function(trackingKey, lat, long, cb) {
		var ds = Park.app.datasources.postgresqlDs;
		var sql = "SELECT get_all_parks($1, $2, $3) as parks";
		ds.connector.query(sql, [trackingKey, lat, long], function(err, data){
			cb(err, data)
    	});
	}

	Park.remoteMethod(
        'getAll', 
    	{
          	accepts: [
          		{arg: 'tracking_key', type: 'string'},
          		{arg: 'latitude', type: 'string'},
          		{arg: 'longitude', type: 'string'}
      		],
          	returns: {arg: 'parks', type: 'object', root: true},
          	http: {verb: 'get', path: '/:tracking_key/:latitude/:longitude'}
        }
    );

};
