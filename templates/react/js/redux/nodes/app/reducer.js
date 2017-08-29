import config from 'redux/nodes/app/config';
import initialState from 'redux/initial_state';

const { actionTypes } = config;

export default (state = initialState.app, action) => {
  switch (action.type) {
    case actionTypes.LOGIN_REQUEST:
    case actionTypes.LOGOUT_REQUEST:
      return {
        ...state,
        loading: true,
      };
    case actionTypes.LOGIN_SUCCESS:
      return {
        ...state,
        loading: false,
        session: { jwt: action.payload.jwt },
      };
    case actionTypes.LOGIN_FAILURE:
    case actionTypes.LOGOUT_SUCCESS:
      return {
        ...state,
        session: {},
        loading: false,
      };
    case actionTypes.LOGOUT_FAILURE:
      return {
        ...state,
        loading: false,
      };
    default:
      return state;
  }
};
