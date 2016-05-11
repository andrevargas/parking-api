module.exports = function(Position) {

	Position.disableRemoteMethod('create', true);
	Position.disableRemoteMethod('upsert', true);
	Position.disableRemoteMethod('exists', true);
	Position.disableRemoteMethod('findById', true);
	Position.disableRemoteMethod('find', true);
	Position.disableRemoteMethod('findOne', true);
	Position.disableRemoteMethod('deleteById', true);
	Position.disableRemoteMethod('updateAttributes', true);
	Position.disableRemoteMethod('createChangeStream', true);
	Position.disableRemoteMethod('updateAll', true);
	Position.disableRemoteMethod('prototype.updateAttributes', true);
	Position.disableRemoteMethod('count', true);

	Position.sendPosition = function(trackingKey, position, cb) {
		
		var moment = require('moment');
		var momentDate = moment(position.date).format('YYYY-MM-DD HH:mm:ss');

		var ds = Position.app.datasources.postgresqlDs;

		var sql = "INSERT INTO position (tracking_key_number, point_date, accuracy, actual_location) VALUES ($1, $2, $3, $4)";
		var point = "SRID=4326;POINT(" + position.lat + " " + position.long + ")";
		ds.connector.query(sql, [trackingKey, momentDate, position.accuracy, point], function(err){
			if(err){
				cb(err);
			}
			var sql = "SELECT get_actual_park($1, $2) as current_park";
			ds.connector.query(sql, [position.lat, position.long], function(err, actualPark){
				cb(err, actualPark[0].current_park);
			});

		});

    };

    Position.remoteMethod(
        'sendPosition', 
    	{
          	accepts: [
          		{arg: 'tracking_key', type: 'string'},
          		{arg: 'position', type: 'PositionType', http: {source: 'body'}}
          	],
          	returns: {arg: 'actualPark', type: 'object', root: true},
          	http: {verb: 'post', path: '/:tracking_key'}
        }
    );

};
