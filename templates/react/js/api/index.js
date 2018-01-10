import Schlepp from 'schlepp';

import appConstants from 'app_constants';
import sessionMethods from 'api/sessions';

class Api extends Schlepp {
  constructor(options) {
    super(options);

    this.sessions = sessionMethods(this);
  }
}

export default new Api({
  host: appConstants.API_HOST,
  bearerTokenKeyInLocalStorage: `${appConstants.APP_NAME}:auth_token`,
});
