module.exports = function(TrackingKey) {

	TrackingKey.disableRemoteMethod('create', true);
	TrackingKey.disableRemoteMethod('upsert', true);
	TrackingKey.disableRemoteMethod('exists', true);
	TrackingKey.disableRemoteMethod('findById', true);
	TrackingKey.disableRemoteMethod('find', true);
	TrackingKey.disableRemoteMethod('findOne', true);
	TrackingKey.disableRemoteMethod('deleteById', true);
	TrackingKey.disableRemoteMethod('updateAttributes', true);
	TrackingKey.disableRemoteMethod('createChangeStream', true);
	TrackingKey.disableRemoteMethod('updateAll', true);
	TrackingKey.disableRemoteMethod('prototype.updateAttributes', true);
	TrackingKey.disableRemoteMethod('count', true);

	TrackingKey.getKey = function(deviceId, cb) {
		
		var ds = TrackingKey.app.datasources.postgresqlDs;
		var sql = "SELECT get_tracking_key($1) as tracking_key";
		ds.connector.execute(sql, [deviceId], function(err, trackingKey){
			 cb(err, trackingKey);
		});
	  	
    };
     
    TrackingKey.remoteMethod(
        'getKey', 
        {
          accepts: {arg: 'device_id', type: 'number'},
          returns: {type: 'string', root: false},
          http: {verb: 'get', path: '/:device_id'}
        }
    );

};
