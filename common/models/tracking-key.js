module.exports = function(TrackingKey) {

	TrackingKey.getKey = function(deviceId, cb) {
		
		var ds = TrackingKey.app.datasources.postgresqlDs;
		var sql = "SELECT trim(get_tracking_key($1)) as tracking_key";
		ds.connector.execute(sql, [deviceId], function(err, trackingKey){
			 cb(err, trackingKey);
		});
	  	
    };
     
    TrackingKey.remoteMethod(
        'getKey', 
        {
          accepts: {arg: 'device_id', type: 'number'},
          returns: {arg: 'tracking_key', type: 'string', root: true},
          http: {verb: 'get', path: '/:device_id/get'}
        }
    );

};
