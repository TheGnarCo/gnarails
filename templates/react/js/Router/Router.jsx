import React, { Component } from 'react';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'react-router-redux'
import { Route } from 'react-router';

import App from 'components/App';
import history from 'redux/history';
import store from 'redux/store';

export default class Router extends Component {
  render () {
    return (
      <Provider store={store}>
        <ConnectedRouter history={history}>
          <App>
            <h1>Welcome to Gnarails</h1>
          </App>
        </ConnectedRouter>
      </Provider>
    )
  }
}
