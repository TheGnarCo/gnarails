import { applyMiddleware, compose, createStore } from 'redux';
import Es6ObjectAssign from 'es6-object-assign';
import Es6Promise from 'es6-promise';
import middlewares from 'redux/middlewares';
import reducers from 'redux/reducers';
import InitialState from 'redux/initial_state';

const appliedMiddleware = applyMiddleware(...middlewares);

// ie polyfills
Es6ObjectAssign.polyfill();
Es6Promise.polyfill();

export default createStore(reducers, InitialState, compose(appliedMiddleware));
