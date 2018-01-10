import React, { Component } from 'react';
import { has } from 'lodash';
import { Provider } from 'react-redux';
import { MemoryRouter } from 'react-router';

import createStore from 'test/mock_store';

const defaultStore = { router: { location: { pathname: '/' } } };

const connectWrapper = (WrappedComponent, store = defaultStore) => {
  class Wrapper extends Component {
    render() {
      const providerStore = has(store, 'getState') ? store : createStore(store);

      return (
        <Provider store={providerStore}>
          <MemoryRouter>
            <WrappedComponent {...this.props} />
          </MemoryRouter>
        </Provider>
      );
    }
  }

  return Wrapper;
};

export default connectWrapper;
