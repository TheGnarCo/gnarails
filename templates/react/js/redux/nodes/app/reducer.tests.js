import expect from 'expect';

import reducer from 'redux/nodes/app/reducer';
import { app as appState } from 'redux/initial_state';

describe('App - reducer', () => {
  describe('dispatching the login actions', () => {
    describe('LOGIN_REQUEST', () => {
      it('sets the loading boolean to true', () => {
        const action = { type: 'LOGIN_REQUEST' };

        expect(reducer(appState, action)).toEqual({
          ...appState,
          loading: true,
        });
      });
    });

    describe('LOGIN_SUCCESS', () => {
      it('saves the JWT to state', () => {
        const action = { type: 'LOGIN_SUCCESS', payload: { jwt: 'jwt' } };
        expect(reducer(appState, action)).toEqual({
          ...appState,
          session: { jwt: 'jwt' },
        });
      });
    });

    describe('LOGIN_FAILURE', () => {
      it('removes the JWT from state', () => {
        const action = { type: 'LOGIN_FAILURE' };
        const state = { ...appState, session: { jwt: 'jwt' } };

        expect(reducer(state, action)).toEqual({
          ...appState,
          session: {},
        });
      });
    });
  });

  describe('dispatching the logout actions', () => {
    describe('LOGOUT_REQUEST', () => {
      it('sets the loading boolean to true', () => {
        const action = { type: 'LOGOUT_REQUEST' };

        expect(reducer(appState, action)).toEqual({
          ...appState,
          loading: true,
        });
      });
    });

    describe('LOGOUT_SUCCESS', () => {
      it('removes the JWT from state', () => {
        const action = { type: 'LOGOUT_SUCCESS' };
        const state = { ...appState, session: { jwt: 'jwt' } };

        expect(reducer(state, action)).toEqual({
          ...appState,
          session: {},
        });
      });
    });

    describe('LOGOUT_FAILURE', () => {
      it('sets the loading boolean to false', () => {
        const action = { type: 'LOGOUT_FAILURE' };
        const state = { ...appState, loading: true };

        expect(reducer(state, action)).toEqual({
          ...appState,
          loading: false,
        });
      });
    });
  });
});
