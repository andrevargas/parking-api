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

	Position.sendPosition = function(tracking_key, position, cb) {
		cb(null, tracking_key, position);
		console.log(position)
    };

    Position.remoteMethod(
        'sendPosition', 
    	{
          	accepts: [
          		{arg: 'tracking_key', type: 'number'},
          		{arg: 'position', type: 'PositionType', http: {source: 'body'}}
          	],
          	returns: [
          		{arg: 'key', type: 'string'},
          		{arg: 'position', type: 'PositionType'}
      		],
          	http: {verb: 'post', path: '/:tracking_key'}
        }
    );

};
